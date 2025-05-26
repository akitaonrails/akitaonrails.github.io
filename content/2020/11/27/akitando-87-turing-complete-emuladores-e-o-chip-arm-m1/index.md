---
title: "[Akitando] #87 Turing Complete, Emuladores e o Chip ARM M1"
date: '2020-11-27T20:00:00-03:00'
slug: akitando-87-turing-complete-emuladores-e-o-chip-arm-m1
tags:
- apple
- m1
- arm
- x86
- emulador
- turing complete
- akitando
draft: false
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/kz3649U2sJY" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## DESCRIÇÃO

Continuando o assunto sobre máquinas de Turing hoje resolvi pegar parte do material que eu cortei do episódio anterior e aproveitar o lançamento do chip Apple M1 pra dar uma introdução ao assunto de emuladores usando aspectos das diferenças de arquitetura RISC/CISC e como ARM e x86 se comparam.


Índice:

* 00:00 - Introdução
* 01:10 - Turing Complete
* 09:37 - Doom roda em QUALQUER lugar :-)
* 11:58 - Apple M1 / ARM x x86
* 21:40 - Pirataria


ERRATA:

No teste de gravidez, eu não prestei atenção e deixei passar que na verdade o @foone teve que trocar alguns componentes então o teste de gravidez não foi usado 100% como veio de fábrica e portanto NÃO, ele não é um computador universal também 🤷‍♂️ de qualquer forma fica o conceito, de que poderia ser, se rodasse Doom ;-) https://twitter.com/renatomefi/status/1332694946575486978?s=20


Links:

* Tom Scott: Are There Problems That Computers Can't Solve? (https://www.youtube.com/watch?v=eqvBaj8UYz4)
* Foone: Doom Pregnancy Test (https://twitter.com/Foone/status/1302820468819288066?s=20)
* Matthew Monis: MacBook Pro 13 Review - This M1 is Insane! (https://www.youtube.com/watch?v=BUBYO591Fo8)
* The Untold Story Of The Invention Of The Game Cartridge (https://www.fastcompany.com/3040889/the-untold-story-of-the-invention-of-the-game-cartridge)


## TRANSCRIPT

Olá pessoal, Fabio Akita


Fiquei contente que vocês gostaram do episódio que contei um pouco mais sobre a máquina de Turing e a arquitetura de Von Neumann. Aquele episódio tinha ficado grande e eu tive que cortar um trecho enorme pra não perder a linha de raciocínio do que eu queria contar. O trecho era tão grande na real, que era praticamente outro episódio. 






Pois é, no processo de escrever os textos e um dos motivos de porque eu não gosto de fazer live, é que eu faço muita tangente e aí o assunto fica mais complicado do que devia. Mesmo cortando eu ainda faço tangente. Ainda estou praticando cortar coisas, mas vira e mexe acontece de eu escrever 30 páginas e cortar 10 fora, como é o caso do material de hoje.






Então a primeira metade do video de hoje vai ser tipo a edição estendida director’s cut continuando o video anterior, mas a segunda metade vou começar a falar sobre emuladores e até dar uma palhinha do que eu acho dos novos chips Apple M1 no contexto de emulação e arquitetura. Mas isso vai ser introdução também pro próximo episódio onde vou cair mais no meu lado geek e falar de videogames. 



(...)





Eu nasci no fim dos anos 70. A revolução dos micro-computadores nasceu praticamente junto comigo. Por exemplo, a Atari foi fundada em 1972, a Microsoft em 75, a Apple em 76. No mesmo ano que eu nasci também nascia o computador PET, o antecessor da linha Commodore que sairia em 82. O padrão MSX nasceu em 83. O Sinclair ZX Spectrum nasceu em 82 e no Brasil ele foi clonado pela Microdigital e virou o venerado TK 90X, que eu queria ter quando criança mas não pude.










No caso do TK 90X ele usava processador Zilog Z80, o mesmo também usado no Sega Mastersystem que fez muito sucesso no Brasil, fabricado pela Tectoy e que existe até hoje. Outros modelos de micros como o Apple II ou Commodore 64 ou mesmo o Atari 2600 usavam o MOS 6502 ou sua evolução, o 65C02, que eu introduzi no episódio do Guia mais Hardcore de Introdução à Computação. 









Esse mesmo processador equipava o Nintendinho original de 8-bits. E mesmo o Super Nintendo usa o processador da família do 65816 que é baseado na arquitetura e instruções do 6502, meio como um Intel Core i5 de hoje é uma evolução dos Pentium de antigamente e ainda são compatíveis. Recomendo que assistam meu episódio também de Aprendendo sobre Computadores com Super Mario pra entender um pouco de como as instruções do 6502 funcionam na prática.













Essa conversa toda foi só pra voltar no conceito de máquinas Turing Universais ou UTMs. Pra recapitular, uma máquina de Turing, a abstração, é basicamente uma máquina com um leitor que consegue ler um bit de cada vez de uma fita infinita, consegue mover essa fita pra esquerda ou pra direita, e além de ler consegue mudar o valor de um bit de cada vez. Mesma coisa o console de um Nintendinho, onde é possível representar tudo que compõe o console com um número descritivo, porque ele é uma máquina de Turing. 







Um cartucho é um conjunto de chips de ROM. Dentro dessa ROM tá gravado o programa do jogo e os dados como os sprites, imagens e áudio que compõem o jogo. Mas é basicamente tudo uma sequência de bits. Poderíamos escrever os bits todos numa fita. E de fato, antigamente a gente gravava programas e jogos em fitas cassete. Quem é dos anos 80 deve se lembrar. Era lento pra cacete, mas disk drives ainda eram muito mais caros. Mesmo um disco que tem num HD mecânico ou um CD-ROM é uma fita de discos em círculo na mídia.







O cartucho é como se fosse a tal fita na máquina de Turing. Mais do que isso, sem pensar que existem todos esses elementos separados, do ponto de vista da fita ou sequência de bits, são zeros e uns um atrás do outro. Se não ficou claro, vamos pegar um trecho de assembly que eu mostrei no episódio do guia de introdução à computação, instruções do 6502. Lá pelo minuto 49 do vídeo eu mostro uma sequência de instruções, lda ff, sta 60 02. Vamos considerar que o programa são só essas duas linhas. Em hexadecimal isso viraria a9 ff 8d 02 60. Em binário isso viraria esse numerozão aqui do lado. Se eu jogar na calculadora, e convertermos pra decimal, essas duas linhas de código podem ser representados pelo número trezentos e sessenta e cinco mil e tra la la que você pode ver aqui do lado. Entendeu? O programa É esse número.

1010 1001 11111111 1000 1101 0000 0010 1100000
365068452192




Zeros e uns um atrás do outro é basicamente um numerozão, em binário. No caso do cartucho do Super Mario é um numerozão de mais de trezentos e vinte mil dígitos binários ou bits, pra ser mais exato, porque são 40 kilobytes vezes um mil e vinte e quatro pra termos em bytes e vezes oito pra termos quantos bits, já que 8 bits é 1 byte. Todo programa, não importa o comprimento, é um numerozão. Todo programa que você já escreveu ou vai escrever pode ser representado por um único número gigante.









Não só o cartucho por ser representado por um número, mas o funcionamento do nintendinho inteiro também pode ser representado por um numerozão. Uma máquina universal de Turing pode pegar o tal número descritivo de uma máquina de Turing, como o tal numerozão que representa o Nintendinho inteiro e simular. E o resultado dessa simulação vai ser exatamente a mesma da máquina de Turing correspondente, o console de verdade. Então, uma característica importante de uma UTM é sua capacidade de "simular" qualquer outra máquina de Turing.











Resumindo. Uma máquina de Turing ou máquina de computar é um modelo abstrato capaz de ter um número finito de configurações ou estados. Ele é alimentado com uma fita infinita de bits. A cada momento a máquina tá escaneando somente um símbolo dessa fita de cada vez, e é automática porque a cada momento o estado da máquina é determinado pelo símbolo, ou bit que ele tá lendo naquele instante. A grosso modo, pense numa máquina de Turing como uma função ou método de qualquer linguagem de programação moderna. 










O tal número descritivo representa o corpo dessa função, o binário do programa. Esse número descritivo ou programa manipula números computáveis, que na prática é quase todo número que você consegue pensar. E usa o que Turing chamou de funções computáveis. De curiosidade, ao contrário dos números, nem toda função é computável e existe muito mais funções não-computáveis do que computáveis na real. Portanto uma máquina de Turing Não consegue computar qualquer coisa. Existem funções que ela não tem capacidade de resolver. 












Isso é um conceito importante porque a intuição popular é que dado tempo suficiente pra evolução de chips e processadores, qualquer problema deveria ser possível de resolver com um computador. Porém vale saber que existem problemas que um computador de Turing nunca vai resolver. Um exemplo disso é o Halt Problem. E como é muita tangente pra hoje, recomendo assistir a explicação do Tom Scott, que é outro canal que eu sigo faz anos. Apenas lembre disso: existem problemas que são impossíveis de resolver com um computador. E não, um computador quântico ainda é uma máquina universal de Turing. Daqui algumas décadas tem a possibilidade de ser ridiculamente mais rápido que hoje, sem dúvida, mas não vai ter mais capacidades nem vai ser capaz de resolver problemas que já não se resolve hoje.










De qualquer forma, uma Universal Turing Machine é uma máquina que pode pegar o número descritivo de alguma máquina de Turing e simular ela perfeitamente. Então, pra resolver problemas de computação, você pode escolher uma máquina de Turing adequada pra um problema específico, já que cada máquina só consegue executar uma tarefa. Lembrem-se que antes disso uma máquina mecânica era construída pra resolver só um tipo de problema. Agora você pode pegar uma máquina Universal, carregar o número descritivo ou programa, que é o tal numerozão que expliquei antes, e simular diversas máquinas de Turing. Esse é o conceito moderno de programação e computadores derivado dos papers de Alan Turing.












Na prática, computadores reais não são máquinas de Turing nem máquinas Universais, pelo simples fato que elas tem limites e a definição matemática tem o ideal de memória infinita. Mas, pra todos os efeitos e propósitos, a revolução de Alan Turing foi conseguir definir a idéia e conceitos de uma máquina de uso geral, em vez de uma máquina especializada como calculadoras por exemplo. Uma máquina de Turing seria o que chamamos de “programa”, o tal número descritivo seria a implementação desse programa, uma máquina Universal é o computador propriamente dito que consegue rodar diversos programas diferentes.










Alguém me perguntou uma vez se uma calculadora ou um ábaco não poderiam ser computadores já que “computam” números. E é uma pergunta válida. Tecnicamente uma calculadora “e” um computador, intuitivamente, são máquinas de calcular. E quando eu falo calculadora não estou falando de coisas como a TI-83 que todo engenheiro que se preze conhece e usa. Uma TI-83 é definitivamente um computador inteiro, que carrega programas de calcular e plotar gráficos e por isso consegue até rodar Doom nele. Estou falando daquelas calculadoras velhas que se tinha nas mesas antigamente.











Na minha definição informal e não-rigorosa, eu costumo pensar num computador como uma máquina que consegue simular qualquer outro computador, mesmo que bem mais lento. Performance não define um computador, suas capacidades sim. E uma linguagem Turing Complete, pra mim, é uma linguagem que consegue programar a simulação de outro computador. Se uma determinada máquina consegue rodar um emulador, pra mim é uma máquina universal. E se a linguagem de programação é capaz de escrever um emulador, pra mim ela é Turing Complete. É uma definição parcial, mas eu gosto dela porque é bem prática. Não consegue escrever um emulador, essa linguagem não é Turing Complete. Não consegue rodar um emulador, então não é um computador.











Recentemente um usuário que eu sigo no Twitter faz tempo, o @foone, ganhou o noticiário porque ele fez Doom rodar num teste de gravidez! Pois é, a miniaturização chegou num tal ponto que dentro de um mísero teste de farmácia, daqueles que tem uma telinha LCD bem podrona, tem um CPU turing complete, capaz de minimamente executar um jogo ao ponto dele aparecer na tela e rodar. Lento, feio, mas roda. Pára pra pensar numa coisa, todo teste de gravidez mais moderno é um computador inteiro, com um programa feito pra rodar só uma vez e depois você jogar no lixo! Isso tudo dito, não, ábaco não é um computador, a calculadora antiga de mesa não é um computador, mas um teste de gravidez como esse definitivamente é um computador.










Toda vez que alguém fala coisas como "nossa, conseguiram rodar Doom numa TI-83 ou numa câmera fotográfica" lógico, eu acho impressionante que alguém se deu a esse trabalho, mas eu não acho surpreendente porque mesmo um computador fraco é capaz de simular outro computador, só vai ser super lento. Mesma coisa quando alguém se impressiona quando vê uma distribuição Linux ou mesmo Windows 95  rodando no Chrome ou Firefox, emulado via Javascript. Não me surpreende, mas certamente impressiona, especialmente se você for iniciante. 











Eu entendo a sensação. Eu me sentia da mesma forma nos anos 90, quando eu tinha um PC no nível de um 486 ou Pentium, que sequer tinha 32 MEGAbytes de RAM, e de repente eu tava conseguindo emular um nintendinho, que não fazia 10 anos só era possível jogar com um console de verdade. Ou a primeira vez que eu instalei o sistema operacional OS/2 que vinha com um emulador de MS-DOS e era possível até iniciar Windows 3.1 e rodar lado a lado dentro do OS/2. De qualquer forma, esses conceitos explodiam minha mente nos anos 90 e eu entendo que todo iniciante que vê isso pela primeira vez, mesmo hoje, deve ficar impressionado.












Agora, falando especificamente de emuladores. Um emulador simula um chip de outro computador via software. Quando um emulador carrega o jogo de um cartucho, o jogo em si não tem idéia que tá rodando num emulador. Pra todos os efeitos e propósitos, se o jogo tivesse consciência, ele não teria dúvidas que tá rodando no console de verdade. No máximo ia estranhar, “nossa, tá mais rápido esse hardware hoje”. Esse é o Matrix de verdade e eu falei um pouco disso no meu episódio sobre virtualização, dêem uma olhada.









Em particular sobre as discussões de ARM versus x86 que tá na moda agora, isso é um daqueles eventos que só acontece um a cada vinte anos. Eu usava Macs em 2006 quando aconteceu a transição de PowerPC pra Intel. Não vou entrar em detalhes dessas histórias porque nesse momento todo canal de tech no YouTube já tem vídeos a respeito e seria só ser redundante. Mas é relevante notar que em 2006 a Apple saiu de uma arquitetura RISC, de instruções reduzidas, pra Intel que tem instruções complexas. Agora ela tá fazendo o oposto, saindo de instruções complexas e indo pra arquitetura ARM, que é um RISC, de instruções reduzidas.










Pra nós programadores, uma coisa interessante é a camada Rosetta 2 que tem nos Mac OS a partir do Big Sur. Ele é um emulador pra conseguir executar binários legados de x86, convertendo as instruções pra ARM. Assim ele consegue rodar programas que não foram recompilados e atualizados pro novo chip M1. Todo reviewer tá com a cabeça explodindo porque o M1 já é mais rápido que modelos de notebooks PC comparáveis em preço aos novos Macbook Air ou Macbook Pro 13 polegadas. 







Mais do que isso, todo mundo achava que rodar um Photoshop ou Premiere sendo emulado pelo Rosetta seria provavelmente lento. E eles tão abismados como a performance não só tá aceitável, mas tá realmente rápido, sem engasgos nem nada. Bem diferente de quando pulamos de PowerPC pra Intel em 2006. Sério, eu lembro de usar o primeiro Rosetta nos Macbook brancos Intel e rodar qualquer coisa pelo Rosetta era super lento. Dava desgosto de usar. Mas nos M1 de agora, ao que tudo indica, vai rodar quase que igual à velocidade de quando rodava no Macbook Intel. 













Eu fiquei pensando sobre isso e vale lembrar um dos motivos possíveis. Todo mundo tá cansado de ouvir que a diferença de chips x86 e ARM é que um tem instruções mais complexas e o outro tem instruções mais simples. Pense por um segundo no que isso significa. A cada clock o processador executa uma ou mais instruções. Quanto mais instruções for possível executar por clock, maior a velocidade e menor o consumo de energia. O problema de instruções de complexidade variada é que é difícil de adivinhar quantas instruções dá pra rodar a cada clock. Pra ser mais exato, uma instrução x86 pode ser de um até 15 bytes de comprimento. 










Por causa disso um processador Intel costuma executar algo em torno de quatro instruções por clock. Isso é horrível, porque faz de conta que chegamos numa parte do programa que tem 10 instruções simples de um ou 2 bytes um atrás do outro. Talvez o processador pudesse rodar oito, dez ou mais instruções dessas no mesmo clock. Mas como nem sempre dá pra saber se cabe ou não, ele roda só quatro. E fazendo isso ele tá desperdiçando clock, desperdiçando energia. E sem mudar a arquitetura de instruções, o pipeline sempre vai ser curto e isso é inerente a ser um x86.










Agora, processadores ARM tem instruções ou de 16 ou de 32 bits, ou seja, de 2 ou 4 bytes. E só. E eles não se misturam. Ou você tá executando instruções de 32-bits ou de 16-bits. Pra mudar entre um ou outro você manda uma instrução pra mudar o mode. Isso significa que você sempre sabe exatamente o tamanho das instruções e com isso pode configurar um pipeline mais longo por clock. Em particular, o chip M1 da Apple consegue executar oito instruções por clock. Só em profundidade desse pipeline, um chip M1 de 2Ghz tem potencial de ser duas vezes mais veloz e eficiente do que um chip Intel equivalente de 2Ghz. Mais do que isso, um chip M1 de 2Ghz pode ser competitivo com um chip Intel de 3 ou até 4Ghz, por isso você tanto ganho de bateria e menos calor sendo dissipado.












Mas não é só isso. Considere o aspecto de emulação. Pra um chip ARM emular Intel é relativamente mais fácil do que Intel emular ARM. Por que? Porque como ARM tem instruções simples, ou seja, mais básicas, ela consegue emular facilmente qualquer instrução mais complexa de Intel. Por exemplo. Pra facilitar a explicação imagina se fossem processadores gráficos. Digamos que em ARM existam funções como desenhar uma linha, desenhar um círculo, desenhar um triângulo. 












Porém, em Intel existem funções mais complexas como, desenhar um botão, desenhar uma janela. Entenderam o que significa quando se fala em diferença de complexidade? Um só desenha linhas o outro numa única instrução já desenha um botão inteiro. Com instruções nesse ARM hipotético, como desenhar linha, eu consigo desenhar os botões ou janelas. Só vai dar mais trabalho porque eu preciso desenhar linha a linha. Se eu fosse um programador de assembly que precisa usar só essas instruções, seria um parto fazer isso. Mas como hoje escrevemos tudo em C ou outras linguagens, não faz diferença. Quem vai ter mais trabalho vai ser o compilador e não o programador. Agora, se eu só tenho instruções complexas, como desenhar o botão inteiro, como que eu desenho só uma linha? Fácil, eu faço um botão com 1 pixel de comprimento. Só que agora eu tô gastando o tempo de processamento de desenhar um botão inteiro pra fazer uma simples linha, portanto vai ser mais lento. 











Pra piorar a situação, pra rodar instruções de x86, você precisa fazer o equivalente a passar argumentos pra uma função, como num javascript por exemplo. No caso, os argumentos você preenche em registradores e depois chama a instrução, que seria o equivalente de uma função. Ou seja, existe um número limitado de argumentos que uma instrução pode receber, porque existem poucos registradores, que funcionam como variáveis globais numa linguagem como Javascript ou PHP. Pois bem, processadores x86 como Intel de 32-bits possui só 8 registradores de uso geral. Os processadores x86 de 64-bits que a maioria de nós usa hoje tem 16 registradores de uso geral. 










Adivinha quantos registradores tem um processador ARM de 32-bits? Dezesseis! E quantos tem o ARMv8 de 64-bits? Trinta e dois registradores. O dobro dos equivalentes x86. Ou seja, fodeu, pra um Intel emular uma instrução ARM que tem o dobro de registradores, ele vai ser obrigado a fazer vários truques pra lidar com argumentos que não cabem em todos os registradores que ele tem, e, de novo, a performance vai ser necessariamente mais baixa. No lado oposto, um chip Apple M1 que é um ARM de 64-bits, ele consegue facilmente emular qualquer instrução de x86 64 bits, porque tem registradores sobrando. Então a programação não precisa de truques, é super direto.










No frigir dos ovos? É uma ordem de grandeza mais simples e mais performático pra um processador ARM emular binários de x86 do que o oposto. O Rosetta de de 2006 era lento, porque ele tava justamente na situação oposta: precisava fazer os antigos processadores Intel dos novos Mac emular binários legados de PowerPC que é uma arquitetura RISC como ARM, era o caso de ter que usar uma função complexa que desenha um botão e desperdiçar o processamento pra emular uma linha.










É um dos motivos de porque é mais difícil ter emuladores de processadores RISC rodando bem em cima de um processador Intel. Por exemplo, até hoje não é performático emular os antigos PowerPC pra rodar Mac antigo. Da mesma forma é lento emular chips de smartphone, como os da Qualcomm que tem na maioria dos celulares Android que usamos. Já o inverso é mais rápido. Por isso eu fiquei um pouco decepcionado com o processador SQ1 que a Microsoft criou em parceria com a Qualcomm pra equipar os Surface Pro X. 










O SQ1 é um Apple M1 piorzinho. Também é um chip ARM e tá rodando Windows 10 compilado pra ARM, como o Big Sur no caso do Mac. E pra rodar programas legados de x86, ele também roda um emulador. Até hoje tá limitado a rodar binários de 32-bits e mesmo assim roda muito lento. Tá pra sair o suporte a emular binários de 64-bits, e a expectativa é que seja um pouco melhor, mas mesmo assim ainda atrás da Apple. Talvez você nem tenha ouvido falar do Surface Pro X, mas não é de hoje que a Microsoft vem tentando usar chips ARM também. A Apple não foi a primeira, mas pra variar, foi a que entregou mais bem feito.











O fato de emular x86 em cima de ARM não ser tão difícil e não representar uma perda tão significativa de performance é importante, porque com Windows, MacOS e Linux ganhando cada vez mais otimizações pra ARM, significa que a hegemonia da Intel tá com os dias contados. Por causa dos smartphones a tecnologia ARM evoluiu bastante e em ambiente móvel, a Intel simplesmente não tem como competir. E agora esses processadores tão pulando pra notebooks e desktop, e já tão bons. E com emuladores ninguém vai ficar preso em Intel por causa de aplicativos legados. E se esse caminho der certo, em breve esses chips ARM vão invadir em massa o ambiente de servidores. Aliás, o maior supercomputador do mundo já usa ARM. E isso poderia representar o último prego no caixão da Intel. Ela vai precisar se mexer rápido pra evitar isso.










Eu vou falar um pouco mais sobre ARM no próximo episódio, mas de qualquer forma a comunidade de desenvolvimento de emuladores é grande. Eu sempre fico impressionado porque na maior parte são voluntários trabalhando só pelo prazer de ver as coisas funcionando mesmo, já que não se pode ganhar muito dinheiro em cima de jogos que ainda tem licenças e copyrights, especialmente se mexer em consoles da Nintendo. Nunca mexa com a Nintendo, é processo garantido e muita diversão pra se livrar. A única exceção é se você vive na China, daí você tá seguro.










Não dá pra falar de emuladores e não tocar no assunto de pirataria. É um assunto controverso, ser a favor ou contra direitos autorais e eu vou dizer que sou neutro nessa discussão. Não tenho uma solução completa nem pra um lado, nem pro outro. Então não vou tentar argumentar hoje. Mas sim, como todo mundo, eu já pirateei muito quando era moleque. Eu teria tido muito mais dificuldade pra começar a ganhar dinheiro se não fosse pela pirataria naquela época, então tem esse ponto mesmo. Hoje em dia não tenho esse problema, então não tenho motivos pra piratear e pago tudo que eu uso, acho justo. 










Mesmo assim, existem software antigos especialmente de lugares como Japão por exemplo, que mesmo eu querendo comprar, não existe pra vender, e nesse caso a pirataria tem a função de preservar software do passado. E isso é outro fator importante. Então, se você é a favor ou contra, não sou eu que vou te julgar. Isso tudo dito, assim como todo YouTuber que fala do assunto, eu não vou dizer onde você encontra jogos pirata, mas qualquer um que saiba usar Google e sabe diferenciar de um malware, vai achar o que procura sem muito trabalho. 








E por hoje é isso aí! Já divaguei bastante e vai ter mais nerdice no próximo episódio. Eu sei que o assunto do Apple M1 tá na cabeça do povo, mas não pretendo fazer um video só sobre isso porque já tem bastante, mas de vez em quando vou salpicando algumas curiosidades como fiz hoje e vou fazer no próximo. Se ficaram com dúvidas não deixem de mandar nos comentários, se curtiram o video mandei um joinha e compartilhem o video com seus amigos, assinem o canal e não deixem de clicar no sininho pra não perder os próximos videos. A gente se vê, até mais!

