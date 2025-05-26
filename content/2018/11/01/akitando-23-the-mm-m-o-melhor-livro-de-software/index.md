---
title: "[Akitando] #23 - The MM-M: O Melhor Livro de Software?"
date: '2018-11-01T17:00:00-03:00'
slug: akitando-23-the-mm-m-o-melhor-livro-de-software
tags:
- Fred Brooks
- Harlan Mills
- David Parnas
- Tom DeMarco
- Mythical Man-Month
- No Silver Bullet
- Engenharia de Software
- Agile
- Gerenciamento
- Projetos
- Software
- akitando
draft: false
---

Disclaimer: esta série de posts são transcripts diretos dos scripts usados em cada video do canal [Akitando](https://www.youtube.com/channel/UCib793mnUOhWymCh2VJKplQ). O texto tem erros de português mas é porque estou apenas publicando exatamente como foi usado pra gravar o video, perdoem os errinhos.


<iframe width="560" height="315" src="https://www.youtube.com/embed/wcGGklDfHM4" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


### Descrição no YouTube

Vocês vão encontrar dezenas de listas de "Top 10 Livros sobre desenvolvimento de Software". Mas como realmente confiar numa lista? Vou explicar um dos critérios que eu uso para escolher.

E aproveitando o gancho do vídeo anterior, de porque blockchains não são balas de prata pra tudo, vamos ver a origem da frase Balas de Prata.

O livro The MM-M é possivelmente um dos livros que eu consideraria obrigatório a qualquer um que leve a sério a área de Engenharia de Software, particularmente como gerir um projeto de software.

Mas um livro publicado em 1975 não está atrasado? Agile não é o jeito moderno?

Vamos quebrar esses e muitos outros mitos que muitos de vocês devem ter até hoje sobre gerenciamento ágil de software.

Quando gravei eu disse que não sabia de onde tinha ouvido falar desse livro pela primeira vez, mas fui vascular meus e-mails mais velhos e sem querer achei exatamente. Foi no dia 27 de julho de 2002 (então eu estava certo, 15 anos atrás), e foi no Slashdot.org, exatamente nesta página: https://web.archive.org/web/20040412002157/http://slashdot.org/books/980805/1148235.shtml

Fica aqui pra posteridade :-)

Links:

* The MM-M (https://www.amazon.com/Mythical-Man-Month-Software-Engineering-Anniversary/dp/0201835959)
* Peopleware (https://www.amazon.com/Peopleware-Productive-Projects-Teams-3rd/dp/0321934113/ref=sr_1_1?s=books&ie=UTF8&qid=1540781158&sr=1-1&keywords=peopleware)
* The Pragmatic Programmer (https://www.amazon.com/Pragmatic-Programmer-Journeyman-Master/dp/020161622X/ref=pd_sim_14_4?_encoding=UTF8&pd_rd_i=020161622X&pd_rd_r=c5fdf2b8-db24-11e8-8f8d-3f9a1c609712&pd_rd_w=NX6su&pd_rd_wg=Md4XU&pf_rd_i=desktop-dp-sims&pf_rd_m=ATVPDKIKX0DER&pf_rd_p=18bb0b78-4200-49b9-ac91-f141d61a1780&pf_rd_r=FW20HKV0BHRZNE9MEWZH&pf_rd_s=desktop-dp-sims&pf_rd_t=40701&psc=1&refRID=FW20HKV0BHRZNE9MEWZH)
* Clean Code (https://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882/ref=pd_sim_14_13?_encoding=UTF8&pd_rd_i=0132350882&pd_rd_r=c5fdf2b8-db24-11e8-8f8d-3f9a1c609712&pd_rd_w=NX6su&pd_rd_wg=Md4XU&pf_rd_i=desktop-dp-sims&pf_rd_m=ATVPDKIKX0DER&pf_rd_p=18bb0b78-4200-49b9-ac91-f141d61a1780&pf_rd_r=FW20HKV0BHRZNE9MEWZH&pf_rd_s=desktop-dp-sims&pf_rd_t=40701&psc=1&refRID=FW20HKV0BHRZNE9MEWZH)

## Script

Olá pessoal, Fabio Akita

Alguns vídeos atrás, alguém pediu nos comentários para recomendar livros na área de tecnologia. Vou dizer logo de cara: qualquer lista de top 10 livros de tecnologia que não mencione Fred Brook’s e seu magnum opus The Mythical Man-month perto do topo, não é uma lista confiável. … by Akita



Na verdade, aqui vai uma dica importante: os livros publicados mais recentemente, por autores “celebridadezinhas” raramente, muito raramente, são úteis. Eu não compro, eu recomendo não comprar se o objetivo for criar fundações sólidas. Deveria ser meio óbvio, mas pra um livro ser considerado realmente bom, ele PRECISA passar pelo teste do TEMPO. Durou 10 anos e ainda é válido? Começo a considerar. Durou 30, 50 anos? Agora eu começo a considerar se entra numa lista top 10. Colocar livros de menos de 10 anos num top 10 normalmente expõe a fraqueza da lista. 

Muitos autores modernos desprezam os livros antigos de engenharia de software porque tem a noção errada que os atuais livros de fake-agile ou os to-do list glorificados do kanban são a única doutrina necessária e os antigos programadores de Cobol faziam tudo errado. Se você pensa assim ou tem algum resquício disso no fundo da sua cabeça, vou dizer de novo logo de cara: você é moleque! Continue pensando assim e prepare-se para uma longa carreira medíocre.

(...)


Se você já está na área faz algum tempo, o livro de Fred Brooks The Mythical Man-Month vai ser surpreendentemente atual. Quando eu li esse livro uns 15 anos atrás, eu pensei, cara se eu tivesse lido esse livro uns 10 anos antes, no começo da minha carreira, talvez eu tivesse evitado muitos problemas ou pelo menos teria tido insights pra soluções diferentes. Brooks descreveu em detalhes TODOS os problemas que eu já passei em projetos e possíveis soluções. Ele foi publicado em 1975! seguindo as experiências adquiridas em diversos projetos como o sistema operacional OS/360 da IBM.

Ou seja, quase meio século depois, nossa área de engenharia de software continua errando nos MESMOS lugares que já se errava desde os anos 60!! George Santayana já dizia: aqueles que não se lembram do passado estão condenados a repetí-la. Eu tento não ser idiota, por isso passei os últimos anos indo atrás do passado, e é por isso que eu lido com projetos e equipes de uma maneira um pouco diferente e também por isso tenho zero interesse em discussões atuais de “agile”. Vou falar disso em outro vídeo.

Na verdade todos os grandes clichês que você já ouviu falar foram provavelmente tirados desse livro de Brooks. Por exemplo o título do livro é o capítulo 2 e também a chamada Lei de Brooks: adicionar mais gente num projeto atrasado só vai deixá-lo mais atrasado. 
Man-month ou pessoa-mês é a definição da quantidade de trabalho que uma pessoa faz em um mês. É a falácia de achar que pessoas e tempo são recursos iguais: ou seja, que se você tem 1 pessoa num projeto de 3 meses ou 3 pessoas num projeto de 1 mês, é tudo igual. O maior problema em projetos é a coordenação dessas pessoas. 

Coordenação entre pessoas, combinação de caminhos diferentes entre múltiplos nós. Qual era mesmo a fórmula que você aprendeu na faculdade? AH sim ! No pior caso, você tem n x (n-1) / 2 caminhos de comunicação. Lembrou?

Ou seja, 10 x 9 / 2 ou 45 linhas de comunicação entre 10 pessoas. Vamos adicionar 5 pessoas a mais, achando que vai melhorar. 
Agora vc tem 15 x 14 / 2 = 105 linhas de comunicação. 
E se for um time de 20 pessoas? 190 linhas de comunicação. Está vendo como o problema escala rapidamente? 

Toda vez que você adiciona pessoas novas no projeto, segundo Brooks e segundo minha experiência como evidência, você perturba o projeto de 3 maneiras importantes: você agora precisa reparticionar as tarefas com as pessoas novas. Essas pessoas novas precisam ser treinadas no que já foi feito até agora, é o tempo de phase-in ou on-boarding. E finalmente, temos as novas linhas de comunicação pra piorar. 

Como fazemos num projeto grande então? Brooks descreve a solução: você divide o sistema em sub-sistemas, cada qual com uma Equipe Cirúrgica - que ele define em detalhes no capítulo 3 -, uma equipe pequena - ele até menciona o conceito de Feature Teams. Uma equipe multidisciplinar com um líder claro. Já se sabe faz décadas, empiricamente, que uma equipe jamais deveria ter mais que 10 pessoas. Tem uma parte do capítulo que eu gosto que ele diz: “se um projeto de 200 pessoas tem 25 gerentes que são os programadores mais competentes e experientes, demita a tropa de 175 e coloque os gerentes de volta pra programar”. MAS isso faria o projeto levar 25 anos pra acabar. Portanto, melhor dividir as 200 pessoas em 20 equipes cirúrgicas de 10, cada um com um sub-sistema.

No capítulo 7 ele inicia descrevendo a Torre de Babel. Segundo o livro de Genesis a torre de Babel foi a segunda obra de engenharia da humanidade, a primeira tendo sido a Arca de Noé. Mas Babel foi o primeiro fiasco de engenharia. Vamos analisar esse conto bíblico pela ótica da engenharia: Eles tinham: 
1) uma missão clara? sim. 
2) pessoas suficiente, sim 
3) materiais? sim 
4) tempo suficiente? sim 
5) tecnologia adequada? Sim

Se eles tinham tudo isso, porque o projeto falhou? Em 2 aspectos: comunicação e, por consequência, organização. A conclusão? como pequenas equipes devem se comunicar uns com os outros? DE TODAS AS MANEIRAS POSSÍVEIS. Pega o maldito telefone e liga. Manda pombo correio, sinal de fumaça, mas se comunique! Falta de comunicação, já é sabido, desde a Genesis se você acredita na Bíblia, ou desde os anos 60 se você acredita em Brooks, é a principal causa de fiasco de projetos. Por que você acha que alguns dos softwares mais famosos hoje em dia são todos de coordenação? Jira, Trello, Slack, Basecamp, Github, etc.

Falando em Github. Na republicação de 1995 ele reflete sobre o capítulo da Torre de Babel. Citando: “No projeto do OS/360 nós decidimos que TODOS os programadores deveriam ver TODO o material. Harlan Mills argumentou de maneira persuasiva que programação deveria ser um processo público, e que expor todo o trabalho pra todo mundo ajuda o controle de qualidade, tanto por peer-pressure de fazer as coisas direito e por cada um poder de fato ajudar a encontrar falhas e bugs”. OS/360, o projeto de 1964. 
Você acha que a noção de “quanto mais olhos no código melhor” vem de open source? Eu diria que a noção de open source vem dessa visão dos anos 60!

No capítulo 4, ele fala de Aristrocracia, Democracia e Design de Sistemas, onde ele postula provavelmente algo ainda mais importante do que o título do livro: Integridade Conceitual. Citando Brooks: “Eu vou defender que integridade conceitual é a coisa MAIS importante a se considerar em design de sistemas. É melhor um sistema omitir certas features e melhorias, mas refletir apenas Um conjunto de idéias de design, do que ter um sistema que contém muitas idéias boas mas independentes e descoordenadas”. 

Uma equipe ou várias equipes, não importa, precisa de líderes cuja principal função é manter a Integridade Conceitual. Projetos de software não são e nunca devem ser democracias onde toda boa idéia de alguém entra no sistema. Alguém precisa ser responsável pela integridade do PRODUTO, como ele diz no título do capítulo, uma aristocracia mesmo, um ditador benevolente. Ou você já viu um projeto open source sem um Core Team que decide o que mergeia ou o que não mergeia? Deixe entrar tudo e você ganha uma Torre de Babel.

Nos anos 90 nós erramos nesse conceito e elevamos a idéia do famoso “arquiteto de sistemas” alto demais sem colocar esta missão de forma clara: integridade conceitual. Mas foi de novo um erro de não ler o livro porque Brooks deixa muito claro: o propósito de programar um sistema é deixar o computador mais fácil de usar. Uma arquitetura monumental feita por um arquiteto não serve pra nada se serviu ao sistema mas não ao Uso desse sistema. 
Outra coisa que eu sempre digo mas que Brooks disse primeiro: um arquiteto que não sabe programar não serve pra nada, citando Brooks: “o arquiteto deve estar sempre preparado para mostrar uma implementação pra toda feature que descreve, embora ele não deva ditar A implementação”. Mudamos um pouco o foco disso e dividimos o arquiteto entre líder técnico e outro papel para manter a parte da integridade conceitual: Hoje em dia você tem um conceito semelhante: chama-se PRODUCT OWNER.

E já que falamos num termo de Agile, vamos voltar a outra falácia: que só no século XXI aprendemos que waterfall é ruim e por isso substituímos por Agile. Isso é uma das noções mais erradas de todos os tempos. Eu digo isso por experiência porque isso assume que programadores dos anos 90 como eu eram todos burros. 
Bom, alguns eram. Mas pense assim: a gente entregava software no século XX. 

Vamos ao capítulo 11: Planeje jogar um fora. Citando Brooks: “na maioria dos projetos, o primeiro sistema é quase inusável. Pode ser lento demais, grande demais, complicado demais, ou todos os 3. Não há outra alternativa a não ser começar de novo, melhor, e construir uma versão redesenhada em que esses problemas são resolvidos. Isso pode ser feito de uma vez ou pedaço por pedaço.” Tudo que você discute hoje sobre reescrever ou refatorar, é uma discussão que vem sendo feita faz décadas, nada de novo aqui. Nesse capítulo ele define que a única constante é mudança e a primeira coisa a se fazer é aceitar o fato que mudanças são fatos da vida, do que uma exceção. Prepare o gerenciamento do projeto para aceitar mudanças. Parece um tema moderno de Agile? Essa frase também é de 1975.


Ele fala que eventualmente você vai, de uma vez ou em partes, acabar reescrevendo o primeiro sistema. Mas no capítulo 5 ele avisa dos perigos do Efeito do Segundo Sistema. Citando: “A tendência geral é fazer um design grande demais no segundo sistema, usando todas as idéias que foram cautelosamente deixadas de lado no primeiro.” Ele avisa que o segundo é o mais perigoso sistema que uma pessoa vai desenhar. Exemplo clássico? Lembram do Windows Vista? Ou no nosso mundo mais recente: todo novo framework de Javascript?

Ele define e descreve em detalhes essas etapas. Incluindo a quantidade de bugs que aparecem no sistema por conta dessas mudanças e como lidar com elas. Ele não chama dessa forma mas ele advoga testes, fixtures, testes de regressão. Deixa eu citar um trecho desse capítulo de novo: “O problema fundamental com manutenção é que consertar um defeito tem uma chance substancial - 20 a 50%- de introduzir outro defeito. 
Então o processo todo é dois passos pra frente e um passo pra trás. E porque defeitos não são corrigidos melhor? 
Primeiro, porque mesmo um defeito pequeno que parece local tem ramificações pelo sistema todo. Qualquer tentativa de consertar com pouco esforço vai reparar o defeito local e óbvio, mas a menos que a estrutura seja pura ou muito bem documentada, os efeitos do reparo vão passar despercebidos. 
Segundo, porque o reparador é normalmente alguém que não escreveu o código original, e normalmente é um junior ou trainee. … 
Como consequência da introdução de novos bugs, programas de manutenção requerem mais testes de sistemas. Teoricamente, depois de cada correção você deve rodar a suíte inteira de casos de teste, para garantir que o sistema não foi danificado”. 
Você acha que o conceito de rodar suites de testes, manulmente ou automatizado, é algo moderno? De novo, 1975. 

No capítulo 14 tem a frase que eu usei no video de Prioridades. “Como um projeto atrasa 1 ano? 1 dia de cada vez“. No capítulo ele diz: “Como alguém pode controlar um projeto grande com agenda apertada. O primeiro passo é TER uma agenda”. Defina milestones, defina prioridades, defina datas. Milestones precisam ser concretos, altamente específicos, mensuráveis. No mundo agile seria próximo da definição de DONE, ou finalizado, de cada etapa. Defina datas e faça caber, pra isso você precisa mudar alguma coisa: equipes, arquiteturas, backlogs. Mude, só não mude a data. Isso é gerência, qualquer coisa diferente é ingerência. 

Se só isso não te convenceu. Vamos à edição de 1995. A parte interessante das edições modernas é que Brooks vem criticando seu próprio livro e atualizando ou expandindo alguns dos conceitos. Em 95 ele fala do capítulo 11 onde ele postula que você vai jogar fora o primeiro sistema e explica melhor. Ele começa falando que o modelo Waterfall ou cascata está errado e também corretamente explica como Winston Royce melhorou o modelo sequencial em cascata em 1970 (!!) adicionando: estágios de feedback. 
Então Brooks resume: a primeira falácia básica do modelo de cascata é que ele assume que o projeto avança pelo processo somente UMA vez” e a segunda falácia é que ele assume que o sistema é construído de uma vez. 
Qual a solução? Um modelo de construção incremental (!), por exemplo, ele menciona o modelo de Harlan Mills onde começamos a construir primeiro o esqueleto do sistema e várias funções vazias e vamos preenchendo uma a uma. Compile, teste, repita. E citando Brooks: “Em TODO estágio temos um sistema que roda. Se formos diligentes em cada estágio temos um sistema debugado e testado … e já que temos um sistema funcionando toda vez, nós podemos começar testes com usuários muito mais cedo, podemos adotar estratégias que fazem caber no orçamento o que protege contra atrasos no planejamento (ao custo de ter menos features)”. Ele basicamente descreveu conceitualmente o modelo de test driven development, deploys frequentes, ambiente de staging com versões que sempre funcionam. É só o que há de mais moderno no mundo “Agile” de hoje. Em 1995!!

Na verdade com os conceitos do capítulo 11, do Second System, e esse de 95, ele fala muito sobre protótipos que vão ser jogados fora mas vão te ajudar a “pivotar”. Ele define MVP ou Most Viable Product sem usar o termo MVP que só foi cunhado no Lean Startup do Eric Ries em 2011. Mas o conceito já é conhecido na engenharia de software faz décadas!

Você acha que continuous integration ou CI e continuous deployment ou CD são criações do Agile moderno? Esse capítulo de 95 menciona James McCarthy que descreve o processo de Nightly Builds, ou builds toda noite que a Microsoft fazia desde aquela época, um processo automatizado que toda noite recompila e reconstrói a versão mais nova, daí na manhã seguinte dava pra testar a última versão. Se tivesse um defeito grave, pára tudo, até consertar, e repete o processo. 

Outra frase que todo mundo já ouviu pelo menos uma vez: “não existe bala de prata”. De onde vocês acham que vem isso? É o primeiro paper incluso na republicação de 20 anos de aniversário, de 1995! Ela se contrapõe à lei de Moore. Na Lei de Moore, que já acabou também aliás, Moore postulava que o poder de processamento dobraria a cada 12 a 18 meses. Simplesmente não há nada assim em software. Nós não conseguimos fazer projetos de software na metade do tempo a cada 12 a 18 meses. Nós estamos longe de ter sequer uma ordem de grandeza em eficiência de engenharia de software, é o elo perdido da nossa engenharia.

Durante a leitura do livro ele vai citando outros autores que vocês deveriam dar uma olhada. Se você assistiu minha série de porque sua linguagem não é especial, vão lembrar que eu mencionei Nicklaus Wirth que inventou talvez uma das coisas mais importantes de programação: a modularização, com sua linguagem Modula, antes do Pascal. Mas Brooks menciona bastante outro pesquisador importante: David Parnas, que criou o conceito de esconder informação, ou encapsulamento, um dos pilares da orientação a objetos que você usa até hoje e - eu tenho certeza - nunca sequer ouviu falar de David Parnas.

Além deles, Harlan Mills que desenvolveu uma metodologia de engenharia de software chamado Cleanroom e, que em muitos aspectos, já tem traços do que você poderia chamar de Agile. Finalmente Tom DeMarco, que eu tenho certeza que pelo menos você já ouviu falar por causa de seu famoso livro Peopleware.

Como podem ver The Mythical Man-Month é conterrâneo de alguns dos mais importantes nomes da computação, ele tem vários pontos que só fazem sentido se você pensar que ele foi escrito em 75 (portanto menciona-se linguagens como APL, Modula, ALGOL, COBOL, ADA, mas obviamente não menciona nada de Java ou Python, eles sequer tinham sido inventados na época!)

Eu vi Agile, técnicas de Extreme Programming, Repositórios como Git, todo o processo open source nascer desde o dia 1, e vejo como os conceitos já existiam antes. Se você só começou a programar no século XXI eu sei que parece que não havia nada antes, mas pra mim que começou a programar no fim dos anos 80, nada foi realmente surpreendente, só uma evolução do que eu já sabia. Eu vi muitas das coisas que eu já fazia ganhar nomes, só isso. Vou falar disso em outro episódio.

Novamente, se você leva a sério sua carreira de programação, deixe um pouco de lado os livros mais recentes - não estou dizendo pra não ler - mas comece por este. A partir dele, procure pela bibliografia de Fred Brooks, esses são os autores que realmente importam. Exemplos, eu mencionei nomes como Christopher Strachey do CPL ou Codd ou Dijkstra. 

Não leia o livro de Brooks como um procedimento ou doutrina a ser seguida. Ele é uma conversa: um programador experiente de 75 dizendo ao programador de 2018 como ele continua cometendo os mesmos erros, usando como contexto, os projetos e tecnologias dos anos 70 e 80. E você deveria ficar mais assustado em ver como em 50 anos, muito pouco realmente mudou na engenharia de software. 

E faz sentido, porque se toda vez você ignora o que já se sabe do passado, vai simplesmente cometer os mesmos erros e, se tiver sorte, chegar às mesmas conclusões. Seria mais inteligente subir no ombro de gigantes e usar o que eles já sabiam e nos avisaram. Eu faço isso, a forma como eu trabalho deriva mais de Brooks do que de Agile moderno. E quando eu vejo algumas barbaridades vindas do mundo Agile eu só penso 
… é ...

Num lado mais positivo, ele fez um capítulo chamado “The Joys of the Craft” onde ele tenta explorar porque programação é legal. Em resumo ele chegou nestes pontos:
Primeiro, simplesmente a graça em fazer coisas. Isso é crafting. Programação é uma profissão de prática. Ela depende de, prática!
Segundo, o prazer em fazer coisas que são úteis pra outras pessoas
Terceiro, o fascínio de ligar objetos complexos como quebra-cabeças de peças móveis e ver funcionar, brincando com as consequências dos princípios construídos no começo
Quarto é o prazer de estar sempre aprendendo
Finalmente, existe o deleite de trabalhar numa mídia tão maleável

Lembram o que eu venho dizendo nos vídeos sobre faculdade? A única coisa que você precisa é aprender a aprender, e o único jeito de fazer isso é primeiro gostando de aprender coisas. 
É o único jeito de começar a se tornar um bom programador. Se você se tornar doutrinado, só seguir certas marcas e só usar certas ferramentas, você nunca vai evoluir como programador. Você vai, no máximo, virar um bom codificador, ou datilógrafo. Copia mas nunca cria. Repete mas não sabe porque. Onde está a ciência em ciência da computação. Ciência não é dogmática.

E aí, o que acharam desse vídeo? Não me enganem, vocês já conheciam esse livro? Comentem abaixo se sim e o que mais gostam desse livro. Se curtiram o vídeo mantem um joinha, assinem o canal e cliquem no sininho pra não perder os próximos episódios! A gente se vê, até mais!
