---
title: Conversando com Adrian Holovaty
date: '2008-01-01T16:47:00-02:00'
slug: conversando-com-adrian-holovaty
tags:
- interview
draft: false
---

**English readers, click [here](http://www.akitaonrails.com/2008/1/1/chatting-with-adrian-holovaty)**

**Traducción en [Español](http://www.marcelor.com/2008/01/conversando-con-adrian-holovaty-creador-del-proyecto-django-traduccion.html)**

Como prometi depois da entrevista com [Avi Bryant](http://www.akitaonrails.com/2007/12/15/chatting-with-avi-bryant-part-1) , aqui vai outra grande conversa com [Adrian Holovaty](http://www.holovaty.com/), o conhecido criador do framework web [Django](http://www.djangoproject.com/) escrito em Python.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/31/387373570_870fa6257c.jpg)

Para mim esta é uma matéria importante porque eu sempre disse que tecnologia não tem que ser sobre divórcio. Tecnologia é sobre integração. Sou um programador e evangelista Ruby on Rail tempo integral, mas acima de tudo, eu tento ser um ‘bom’ programador. E bons programadores reconhecem boa tecnologia e a conquista de seus criadores. E o Django de Adrian é uma dessa conquistas excepcionais que merecem a atenção e o sucesso.

Então, como meu primeiro post do ano (publicado às 0:01h!), gostaria de celebrar as grandes mentes da nossa comunidade de ‘desenvolvimento’, esperando que os bons desenvolvedores usem seu tempo criando grandes tecnologias em vez de desperdiçar em guerrinhas inúteis.


 **AkitaOnRails:** Como sempre faço, vamos começar falando um pouco sobre você. Há quanto tempo é programador?

**Adrian Holovaty:** Vamos ver – venho lidando com computadores desde que era um garoto brincando com o Commodore 64 no meio dos anos 80.

Um programa que escrevi na época foi para a calculadora TI-85 na classe de matemática do colégio. Quando me graduei um monte de estudantes estavam usando, porque eu tinha todas as fórmulas e coisas assim.

Eu não levei nenhuma dessas coisas a sério até a faculdade, quando estudei ciência da computação. Mas não terminei o curso, que é uma coisa que sempre me incomodou.

Meu curso principal na faculdade foi em jornalismo, pois originalmente eu queria ser um repórter de jornal, mas depois que eu trabalhei com um web site no jornal do campus ([The Maneater](http://www.themaneater.com/) – o melhor nome de jornal que já vi!), percebi que seria muito mais divertido trabalhar online do que com um produto em papel.

Então acabei achando uma maneira de combinar jornalismo/notícias e programação, e eu tive vários trabalhos fazendo exatamente isso!

**AkitaOnRails:** E o que o levou ao mundo dos computadores?

**Adrian:** Acho que foi minha criação, já que meu pai foi programador de computador desde os anos 70, nos dias do cartão perfurado. Eu lembro de ver todos os tipos de cartões em nossa casa enquanto crescia.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/31/247456700_94dbcdbf86.jpg)

**AkitaOnRails:** E, claro, como conheceu e se apaixonou por Python?

**Adrian:** Meu caminho de desenvolvimento web foi (eu acho) bem típico, pelo menos baseado nas experiência de meus amigos e colegas. Eu originalmente aprendi a escrever scripts CGI em Perl em um curso de desenvolvimento web da faculdade. Então eu me ensinei PHP porque alguém me recomendou.

Depois de fazer desenvolvimento Web com PHP por alguns anos, eu meio que me cansei disso. Naquela época, estava trabalhando com Simon Willison no website de um jornal na cidade de Lawrence, no Kansas. Simon e eu estávamos cansados de PHP e decidimos “mergulhar em Python” (trocadilho intencional) lendo o excelente livro de mesmo nome do [Mark Pilgrim](http://en.wikipedia.org/wiki/Mark_Pilgrim) , que foi lançado na época. Isso deve ter sido no fim de 2002.

Imediatamente nos apaixonamos por Python. E quando eu digo “imediatamente”, realmente quero dizer isso. Foi como uma revelação, algum tipo de momento divino. Foi o equivalente em programação à amor à primeira vista.

Então Simon e eu decidimos que, dali em diante, iríamos codificar tudo em Python. Essa é uma das coisas interessantes em se trabalhar em um pequeno grupo de desenvolvimento Web – podíamos tomar esse tipo de decisões instantâneas!

**AkitaOnRails:** Eu fui apresentado a Python pela primeira vez acho que em 2000. Mas foi através de desenvolvimento web usando [Zope](http://www.zope.org/). Acho que ele ganhou muita atenção naquela época. Você já tentou ele?

**Adrian:** Não, nunca tentei Zope. Ainda, até hoje, nunca tentei. E me disseram que isso foi uma coisa boa, porque evidentemente ele afastou algumas pessoas de Python na época, seja lá por qual razão. (A versão nova supostamente é muito melhor, mas eu não mexi com ele, também).

**AkitaOnRails:** Você está certo, e é meio engraçado porque um monte de pythonistas brasileiros ainda usam [Plone](http://plone.org/) (eu acho que ele evoluiu do Zope mas eu não tentei ele também). Então, todos sabemos que Django nasceu da necessidade quando você estava desenvolvendo websites para a World Online. Por favor nos descreva como você começou e como é o dia-a-dia de trabalho lá. Talvez o que o levou a Django durante seus dias de trabalho.

**Adrian:** Claro! Bem, geralmente quando as pessoas pensam em jornais, elas pensam em editores irritados e ultrapassados e repórteres rascunhando em blocos de papel com lápis. Esse jornal do Kansas em que trabalhei era o oposto disso. Está além do escopo desta entrevista, mas por várias razões o website desse jornal atraiu (e ainda atrai até hoje) uma grande equipe de desenvolvimento – uma que eu colocaria contra qualquer equipe 10 vezes o seu tamanho.

Estávamos fazendo coisas “Web 2.0” em 2002 e 2003, e estávamos construindo aplicações web em dias, não semanas ou meses. Isso era principalmente devido ao ambiente jornalístico – pessoal de jornal gosta de datas.

Então estávamos nessa cultura de _“desenvolvimento web com datas de jornalismo”_ e precisávamos de ferramentas que nos deixassem criar aplicações web rapidamente. Olhamos algumas bibliotecas Python que haviam na época (2003), e terminamos decidindo escrever nossas próprias coisas.

Não decidimos parar para fazer um framework – foi um caminho bem clássico e clichê, na realidade! O que aconteceu foi, nós construímos um site com Python. Então construímos mais um, e percebemos que os sites tem uma boa parte de código em comum, então fizemos a coisa certa e extraímos os pedaços comuns em uma biblioteca.

Continuamos a fazer isso – extraindo e extraindo, baseado em cada nova aplicação Web que criávamos – e eventualmente tínhamos um framework.

**AkitaOnRails:** Como anotação, realmente isso é meio que interessante! Eu adoraria ouvir o que você acha que a World Online tinha que atraía bons desenvolvedores como você para lá! Apenas um resumo está bom. É o tipo de percepção que empresas brasileiras precisam aprender melhor. Deixá-los usar Python provavelmente foi uma delas :-)

**Adrian:** Sim, meio que recai em **dar poder aos empregados**. Meu chefe, que liderava a equipe Web, delegava todas as decisões de tecnologia para mim e o Simon. Esse tipo de cultura realmente encoraja trabalho de qualidade, porque torna todos da equipe mais investidos.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/31/1454328380_6b6053d1c9.jpg)

￼  
**AkitaOnRails:** É verdade. Empresas tradicionais preferem um estilo mais hierárquico (e burocrático), com um gerente idiota segurando o chicote. Mas voltando ao assunto. Então, eu particularmente não gosto desses tipos de comparação linguagem x VS linguagem y ou framework a Vs framework b. Em vez disso gostaria de ouvir o que você acha que é legal sobre Python – a linguagem e a plataforma – e Django. Quais as funcionalidades em Django que você mais gosta, quero dizer, aqueles pedaços que realmente acha para você como “as” grandes idéias?

**Adrian:** Bem, eu amo abstrações – como, eu suspeito, qualquer programador. No seu núcleo, Django é somente um conjunto de abstrações comuns às tarefas de desenvolvimento Web. Me dá muito prazer criar abstrações de algo nível, para encapsular problemas maiores de uma maneira que as torna simples.

O que eu realmente gosto sobre Django é a profundidade e extensão das abstrações que ele dá. E em muitos casos (eu espero!), são limpas, fáceis de usar e entender. Deixe-me dar um exemplo de uma abstração: criar um feed RSS.

Quando se cria um feed RSS, você não quer se lembrar de cada tag, da exata formatação do feed – você apenas de importa sobre os itens no feed. Então Django dá uma biblioteca bem simples que recebe um punhado de itens e cria o feed a partir delas.

Isso foi um exemplo óbvio, mas o que realmente me empolga são as abstrações de alto nível, como o conceito de um “site admin”. Django vem com uma aplicação completamente dinâmica que cria um maravilhoso site CRUD pronto para produção para seu banco de dados. Não há código para escrever – é apenas um pouco de configuração opcional. Também tem algo chamado [**Databrowse**](http://www.djangoproject.com/documentation/databrowse/), que é uma abstração do conceito de _“Me mostre meus dados, como hiper-textos inteligentes”_.

Então, sempre que explico Django a alguém, eu sempre termino dizendo, _“é apenas um monte de abstrações de tarefas comuns em desenvolvimento Web”_ – do encapsulamento de baixo nível de HTTP para conceitos de maior nível. Quanto mais alto nível, mais produtivo você pode ser. Desculpe se isso foi muito conceitual!

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/31/1496211063_262b298650.jpg)

Já sobre Python – o que posso dizer? É maravilhoso. É como poesia. É tão limpo, tão lógico, tão regular, tão óbvio. E o sistema de importação é de morrer.

Muitas pessoas dizem que código Python é fácil de ler/entender por causa da consistência de espaços em branco e simplicidade da linguagem. Eu concordo com isso, mas eu acho que também tem a ver com a elegância do sistema de importação. Por que? Porque se quiser saber como **qualquer** módulo Python funciona, apenas olhe para o código, e olhe para os módulos que ele importa. Como o [Zen do Python](http://www.python.org/dev/peps/pep-0020/) diz, _“Namespaces é uma grande idéia buzinante – vamos fazer mais disso!”_

**AkitaOnRails:** Comunidades de tecnologia são legais porque são tão energéticas e apaixonadas. Por um lado você tem aqueles que contribuem e fazem a tecnologia crescer mais depressa. Do outro, tem os espertalhões e trolls que gostam de guerrinhas. Você se queima de vez em quando, ou tende a evitar esse tipo de discussão? Especialmente, algum tempo atrás você e o DHH estiveram juntos na apresentação [Snakes and Rubies](http://www.djangoproject.com/snakesandrubies/). Eu acho que foi muito legal porque não acabou em mais uma guerrinha. Qual sua opinião sobre esse tipo de discussão aberta e não inflamatória?

**Adrian:** A resposta a isso é óbvia – claramente discussões construtivas são mais produtivas.

Por vezes, eu tive minhas paixões por Python/Django tirarem o melhor de mim, mas eu melhorei muito com o tempo. Percebi uma coisa: no fim do dia, o que realmente importa são os sites que as pessoas criam com essas ferramentas, não as ferramentas em si. Se você vai julgar alguém, julgue os sites que essa pessoa faz, em vez das ferramentas que ela usa.

Atualmente, se eu me envolvo em algum tipo de discussão desse tipo, normalmente é para tentar acalmar as pessoas

**AkitaOnRails:** Bem dito. Voltando às funcionalidades, você mencionou ‘Databrowse’ antes. Eu gostaria de saber mais sobre isso. Acho que o Django não tinha isso na época em que eu tentei da primeira vez. É uma nova funcionalidade (ou eu estou atrasado?) Poderia elaborar mais essa construção?

**Adrian:** Databrowse ainda é pouco conhecido! Aqui vai o Caso de Uso.

Digamos que você tem um monte de dados no seu banco de dados, e tudo que quer é **olhar** para ele. Aqui vão suas opções atuais: você pode cair no console do psql ou mysql e rodar um punhado de SELECTs, mas isso fica cansativo. Você poderia rodar alguma coisa como PHPMyAdmin, mas isso é mais uma ferramenta administrativa do que uma ferramenta de **navegação**. Você poderia usar algum tipo de aplicação externa que permite navegar pelas tabelas do banco, no estilo MS Access, mas isso está no domínio de aplicações de desktop.

Databrowse automaticamente cria um site web que mostra seus dados, de forma que você pode clicar por aí como quiser.

A outra coisa que ele faz é apontar pesquisas interessante e não-óbvias. Por exemplo, se tiver uma tabela que tem uma coluna DATE (tipo Data), ele automaticamente criará uma visão de calendário dessa tabela.

O objetivo não é para as pessoas usarem isso para criar sites públicos – o objetivo é que as pessoas usem isso para explorar seus dados, sem nenhum esforço adicional.

Outro caso de uso vem do mundo do jornalismo. Eu costumava trabalhar para um cara chamado Derek Willis no jornal Washington Post. O trabalho dele era adquirir enormes bancos de dados e colocá-los na intranet do jornal, para que os repórteres pudessem procurar e navegar pelos dados para pesquisas.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/31/179099354_6199af510a.jpg)

Derek não queria ter que fazer uma nova aplicação Web toda vez que recebesse um novo conjunto de dados, então ele usou Databrowse para fazer sites de intranet que mostrasse seus bancos de dados – com pouco ou nenhum esforço.

Isso volta para o que eu estava dizendo sobre abstrações de alto-nível. Databrowse é um tipo particular de abstração, e é realmente legal que ele incluiu algo assim para as pessoas usarem, se precisarem.

**AkitaOnRails:** Parece muito legal, espero poder usar isso logo. Até certo ponto se parece um pouco com [Dabble Db](http://dabbledb.com) – apesar que é dentro da sua aplicação. Acho que você conhece [Avi Bryant](http://www.akitaonrails.com/2007/12/15/chatting-with-avi-bryant-part-1) ? Acabei de entrevistá-lo e foi uma conversa muito legal. Você já tentou Seaside? (apenas de curiosidade eu tenho uma foto de você e Avi olhando para o macbook dele sentados na grama, o que foi aquilo?)

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/19/627957460_48e4181526.jpg)

**Adrian:** Sim, isso foi inspirado no DabbleDB – é essencialmente uma simplificação do DabbleDB para seus próprios dados. Mas eu não diria nem isso, porque DabbleDB é todo um universo mais sofisticado do que Databrowse. DabbleDB é incrível.

Sim, eu me encontrei com Avi diversas vezes e sempre gosto de sua companhia. Até tocamos música juntos – ele é um fantástico tocador de harmônica!

A foto a que você se refere foi tirada na Foo Camp 2007. Eu nunca tentei Seaside, mas está na minha lista de tarefas. Se um dia eu tiver que desenvolver uma aplicação como DabbleDB que precisa manter uma **tonelada** de estado, eu me viraria para Seaside primeiro.

**AkitaOnRails:** Entendo, eu sinto que bons músicos tendem a ser bons programadores também. Então, meu primeiro parabéns a você é sobre seu [novo livro de Django](http://www.amazon.com/Definitive-Guide-Django-Development-Right/dp/1590597257) que acabou de ser lançado. Acredito que seja uma grande conquista para a comunidade Django. Mais do que isso você conseguiu torná-lo [disponível online](http://www.djangobook.com) sobre uma licença Creative Commons.

Como você se envolveu com esse livro? Foi difícil convencer sua editora a ter um livro prontamente disponível online? Pergunto isso porque pelo menos no Brasil essa é uma idéia que é MUITO difícil de empurrar para as editoras. Nos conte mais sobre sua experiência escrevendo, os desafios e obstáculos pelo caminho.

**Adrian:** Muito obrigado. Não há muita história aqui – o co-conspirador Jacob e eu fomos contatados pelo pessoal da Apress, que estavam interessados em publicar um livro de Django, e fizemos. Bem, devo completar: nos tomou **um longo tempo** , mas fizemos. Não foi difícil convencer a Apress a nos deixar disponibilizar o livro online. Eles tiveram uma experiência anterior fazendo o mesmo com o livro [Dive Into Python](http://www.diveintopython.org/) de Mark Pilgrim e eles são pessoas legais.

Em retrospecto, publicar o livro online foi uma decisão fantástica. Não somente o livro final está disponível online, mas tornamos capítulos disponíveis online enquanto as escrevíamos, com uma funcionalidade muito legal de comentários por parágrafo que deixa os leitores enviar erros, opiniões pelos quais estamos imensamente agradecidos. Tendo experimentado isso, eu não gostaria de publicar um livro de tecnologia de outra maneira.

**AkitaOnRails:** Agora, meu segundo parabéns é por causa do [Batten Award](http://www.j-lab.org/batten05winners.shtml) por conquista excepcional em jornalismo online. O [ChicagoCrime.org](http://www.chicagocrime.org/) é muito legal e um bom exemplo de [mashup](http://en.wikipedia.org/wiki/Mashup_(web_application_hybrid)) feito direito. Infelizmente nosso governo local e instituições públicas têm muito pouco ou nenhum dado disponível online para usarmos. De onde veio sua idéia? Como foi seu desenvolvimento?

**Adrian:** Obrigado – e não deixe isso os assustar de visitar a maravilhosa cidade de Chicago. ￼

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/31/adrian_oscon_2006.png)

**AkitaOnRails:** haha, eu moro em São Paulo. Não pode ser pior ;-)

**Adrian:** A idéia para o chicagocrime.org veio quando eu estava olhando o web site oficial do [Departamento de Polícia de Chicago](http://www.cityofchicago.org/police) e descobri que eles publicavam dados sobre crimes – embora em uma interface que é mais adequada para procura do que para navegação. Pensei, _“uau, são dados muito legais!”_ e comecei a escrever um extrator de tela em uns 10 minutos.

Na mesma época, eu estava lidando com o site do Google Maps, que havia acabado de ser lançado, para ver se poderia colocar mapas do Google em meus próprios web sites. Eu percebi que dados de crime dariam uma grande aplicação de mapas, então coloquei os dois juntos, e nascia um dos primeiros mashups de Google Maps. Enquanto estava desenvolvendo o site, [HousingMaps.com](http://www.housingmaps.com) ([Craigslist](http://www.craigslist.org/) + Google Maps) saiu, então ele me venceu ao ser o **primeiro** machup real de Google Maps – mas chicagocrime.org veio logo depois.

A coisa que eu mais me orgulho disso foi o fato de chicagocrime.org ter sido um dos sites que influenciou o Google a abrir sua API de mapas. Na época quando os primeiros mashups apareceram, tínhamos que fazer engenharia-reversa do Javascript do Google!

**AkitaOnRails:** Sei que você provavelmente tem duas grandes paixões em sua carreira: uma é desenvolvimento baseado em Python, claro, e a outra é jornalismo (não sei a ordem correta aqui). Você criou uma grande reputação na mídia online. Você está trabalhando para o Washington Post agora, correto? Eu li um artigo no [OJR](http://www.ojr.org/ojr/stories/060605niles/) onde você explicou sobre tecnologia sendo usada para dar poderes aos jornalistas. Você pretende ser um repórter algum dia, ou está mais para o back-end do jornalismo? Acho que você tem opiniões fortes sobre o futuro do jornalismo na Era da Internet, não é?

**Adrian:** Bem, eu diria que minha **principal** paixão é música, mas é difícil viver disso. (Django foi batizado inspirado no famoso músico de jazz [Django Reinhardt](http://en.wikipedia.org/wiki/Django_Reinhardt))  
 ￼  
Eu não estou mais trabalhando no Washington Post. No meio de 2007 eu ganhei um prêmio de dois anos da [Knight Foundation](http://www.holovaty.com/blog/archive/2007/05/23/1145) para criar um site de notícias local. Então fundei a [EveryBlock](http://everyblock.com) em Julho. Somos uma equipe de quatro pessoas e estamos trabalhando duro para fazer uma aplicação realmente legal.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/31/Picture_2.png)

Mas sim, voltando à sua pergunta, eu certamente tenho fortes opiniões sobre como o jornalismo é praticado na Internet. Isso provavelmente é fora do escopo dessa entrevista, mas você pode ler meu artigo/reclamação estranhamente entitulado [Uma maneira fundamental que sites de notícias precisam mudar](http://www.holovaty.com/blog/archive/2006/09/06/0307/) para terem uma idéia.

**AkitaOnRails:** Agora, isso é novidade para mim. Não sabia que você havia começado sua própria empresa (desculpe, eu ainda preciso alcançar a comunidade Python). Poderia nos dizer mais sobre sua nova empreitada?

**Adrian:** Ei, não posso te culpar – estamos nos mantendo fora dos radares. Não há muito a se dizer sobre a EveryBlock neste ponto além do que é um chicagocrime.org vitaminado. É como chicagocrime, mas para mais cidades do que somente Chicado e mais informações do que somente crime.

**AkitaOnRails:** Você deveria tentar para o Brasil :-)

**Adrian:** Graças à internacionalização do framework Django, isso é inteiramente possível.

**AkitaOnRails:** Sim, e falando nisso (fugindo um pouco do assunto) eu recomendo o filme brasileiro [Tropa de Elite](http://en.wikipedia.org/wiki/Tropa_de_Elite) agora que sei que você se interessa por dados relacionados a crimes ;-)

**Adrian:** Anotado! Adicionei “Tropa de Elite” à minha lista de FILMES_PARA_ASSISTIR.TXT :-)

[![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/31/1529992544_f8e9fc67b2.jpg)](http://leahculver.com/)

**AkitaOnRails:** Prosseguindo. Muitos grandes websites já são desenvolvidos em Django. Seus próprios trabalhos na World Online, Washington Post sendo alguns deles. Outro grande novo é o [Pownce](http://pownce.com/leahculver/) de [Kevin Rose’s](http://en.wikipedia.org/wiki/Kevin_Rose) (o criador do [Digg](http://digg.com)). Você, Kevin e outras pessoas influentes costumam de encontrar durante conferências, não é? O que acha que o influenciou a tentar Django? Outra coisa legal sobre o Pownce tem que ser [Leah Culver](http://leahculver.com/). Uma programadora como ela simplesmente inexiste aqui no Brasil, o que é uma pena. Você deveria torná-la símbolo oficial do Django!

**Adrian:** Nunca me encontrei com Kevin Rose, mas pelo que ouvi falar, acredito que Leah escolheu Django porque ou foi recomendado a ela ou ela gosta de Python, ou algo assim. Não conheço os bastidores. Também não me encontrei com Leah, mas ela foi legal o bastante para viajar a Lawrence, no Kansas, para nosso último [Django sprint](http://leahculver.com/2007/12/01/django-sprint-part-2/) algumas semanas atrás (que eu não pude ir pessoalmente, infelizmente).

**AkitaOnRails:** Não é uma regra escrita em pedra, mas na comunidade Rails nós ‘tendemos’ a gostar de tecnologias relacionadas a Mac. Claro, não é um requerimento para nenhuma linguagem e Linux é tão bom quanto. Mas o que posso dizer? Sou um fã de Apple. Eu gostaria de saber qual é seu ambiente de desenvolvimento. Quais ferramentas você usa para desenvolver websites baseados em Django?

**Adrian:** Recentemente mudei para Mac depois de muitos anos usando Linux no desktop, mas não assuma nada lendo isso – não sou um fã, nem de Linux ou Mac. Eu sinto falta do Linux, para ser honesto, e em diversas coisas não me impressionei pelas funcionalidades Unix do OS X. (Coisas básicas como suporte a readline no Python padrão está quebrado, etc).

As coisas legais sobre o Mac fazem valer a pena a mudança, entretanto. Mesmo depois de ter usado Mac como minha máquina principal por 6 meses, eu ainda me impressiono que eu posso somente fechar o laptop e ele dorme automaticamente. Isso nunca funcionou com Linux!

**AkitaOnRails:** Pergunto isso porque muitas pessoas olhando para Rails ou Django são programadores Java ou C# acostumados a ter uma IDE completa. Eu normalmente digo que qualquer editor de texto comum faz o serviço, e se realmente quiser poder, vim e emacs se encaixam perfeitamente. O que diz disso?

**Adrian:** Eu nunca usei uma IDE para programar, então sou a pessoa errada para perguntar. Na realidade, mais ou menos – eu usei algo como uma IDE na faculdade para programar em assembly. Ele mostrava o conteúdo de acumuladores e coisas assim.

**AkitaOnRails:** Oh, quase esqueci de perguntar: você e o [Guido van Rossum](http://www.python.org/~guido/) já se encontraram? Gostaria de saber sua opinião sobre o desenvolvimento do [Python 3000](http://www.python.org/dev/peps/pep-3000/) . Tem alguma coisa na nova versão que você espera muito?

**Adrian:** Sim, eu me encontrei com Guido várias vezes e tiver sorte o suficiente para jantar com ele uma vez! É quase idiota e desnecessário dizer isso, mas ele é incrivelmente esperto.

Eu realmente gosto dos novos conceitos e funcionalidades no Python 3000, e eu tive a oportunidade de participar do [sprint no Google](http://www.artima.com/weblogs/viewpost.jsp?thread=212259) Chicago alguns meses atrás. Minha funcionalidade favorita é a migração para strings Unicode por padrão, porque isso força os assuntos sobre encoding.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/31/Picture_3.png)

**AkitaOnRails:** Finalmente, o que foi esse barulho sobre o Django ser versionado 1.0 ou pular direto para 2.0? Não segui as discussões, apenas li os títulos algum tempo atrás. E o que as pessoas podem esperar da próxima versão do Django? Entendo que você não faz grandes lançamentos que mudam o jogo, mas o que você vê sendo lançado nos próximos meses em termos de novas funcionalidades?

**Adrian:** Há – essa é uma história engraçada. Eu me cansei das pessoas constantemente perguntando _“Quando o 1.0 vai sair? Quando o 10 vai sair?”_ Minha resposta sempre é, _“Por que você precisa de um número arbitrário assinalado no produto? Muitas pessoas estão usando a versão corrente, então não se segure. Números de versões são muito sem sentido.”_

Então eu sugeri na lista [django-developers](http://groups.google.com/group/django-developers/browse_thread/thread/b4c237ad76f9eeca/86e2d86b9fa8280f?lnk=gst&q=version+2.0#86e2d86b9fa8280f) para assinalar uma versão “2.0” para reforçar o fato que números de versões são de fato arbitrários. Mas, tendo pensado mais sobre isso, mudei de idéia. A quantidade de confusão que isso causaria não justificaria a quantidade de prazer de rebelião que eu teria nisso.

E sobre funcionalidades vindo, existe alguns branches acontecendo no código Django que eventualmente serão unificadas no trunk principal. Um desses branches é chamado [newforms-admin,](http://code.djangoproject.com/wiki/NewformsAdminBranch) que dramaticamente melhora a quantidade de customização que os desenvolvedores precisam fazer para o site admin do Django. Outro é o [queryset-refactor,](http://code.djangoproject.com/wiki/QuerysetRefactorBranch) que é um refatoramento da camada de banco de dados, novamente, para torná-lo mais extensível. Fora isso, existem pequenas funcionalidades que precisamos terminar, e aí será a hora para 1.0.

**AkitaOnRails:** Haha, Acho que você está certo, eu não gosto desse ‘culto do ponto-zero’ também, é bem sem sentido para um projeto open source que está em constante evolução. Mas algumas pessoas se preocupam com isso principalmente em ambientes mais corporativos. De qualquer forma, e para pessoas que querem ver Django em ação, quais websites você recomendaria que elas visitem? Alguns do Washington Post, talvez? Claro, algumas das grandes funcionalidades – como o site admin – são apenas para admins (duh) Mas as pessoas gostam de ver coisa ‘vivas’ em vez de um monte de tutoriais.

**Adrian:** Apenas para comentar, vejo que o David, do Rails, escreveu [uma reclamação](http://www.loudthinking.com/posts/20-dont-overestimate-the-power-of-versions) sobre esse mesmo tópico.

Bons sites em Django? Vejamos – existe o [Tabblo](http://www.tabblo.com/), um site de edição e compartilhamento de fotos que tem algumas funcionalidades interativas muito legais. Existe o [Curse.com](http://curse.com), site de um jogo massivamente online. Tem o [lawrence.com](http://lawrence.com), um site que eu ajudei a construir, que é um dos melhores sites de entretenimento local do mundo (se posso dizer isso!). E tem um site (esqueci o nome) que imprimirá um livro em papel de uma série de artigos do Wikipedia que você especificar – isso me impressionou muito da primeira vez que vi.

**AkitaOnRails:** Então, acho que acabamos :-) Foi uma conversa muito prazerosa. Espero que você tenha um grande Ano Novo!

**Adrian:** Obrigado pelas grandes perguntas e a conversa, e Feliz Ano Novo!

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/31/Picture_1.png)

