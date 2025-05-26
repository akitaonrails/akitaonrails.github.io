---
title: "[Akitando] #89 - Introdução a Videogames e Emuladores"
date: '2020-12-22T10:30:00-03:00'
slug: akitando-89-introducao-a-videogames-e-emuladores
tags:
- videogame
- emulador
- retroarch
- ultrahle
- cemu
- citra
- nintendo
- sega
- sony
- playstation
- xbox
- saturn
- akitando
draft: false
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/vUqLLpUJ47s" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## DESCRIÇÃO

Finalmente vou contar sobre um dos assuntos que eu mais gosto: videogames e emuladores. E aproveitar os episódios que eu vim fazendo sobre Introdução a Computadores pra adicionar mais alguns conhecimentos interessantes pra quem é programador entender como essas coisas funcionam.

ERRATA: eu falo que PPSSPP emula PS Vita mas na verdade é o PSP.


Links:

* Understanding the ELF File Format (https://linuxhint.com/understanding_elf_file_format/)
* Super Nintendo Architecture (https://www.copetti.org/projects/consoles/super-nintendo/)
* Mega Drive Architecture (https://www.copetti.org/projects/consoles/mega-drive-genesis/)
* CPU comparison: SNES vs. Genesis vs. TG16 (https://atariage.com/forums/topic/197977-cpu-comparison-snes-vs-genesis-vs-tg16/)
* Neat story about the 6502 CPU (NES.. sorta SNES..) (https://forum.nhl94.com/index.php?/topic/12514-neat-story-about-the-6502-cpu-nes-sorta-snes/)
* History of Console Emulators (http://www.emulationnation.com/console-emulation/history-of-console-emulators/)
* History of emulation (https://emulation.fandom.com/wiki/History_of_emulation)
* Emugen: History of emulation (https://emulation.gametechwiki.com/index.php/History_of_emulation)
* How UltraHLE changed Nintendo 64 emulation forever | MVG (https://www.youtube.com/watch?v=2NF5sU_n0uk)
* Introduction to N64 Programming (http://n64.icequake.net/doc/n64intro/kantan/step2/index1.html)
* After Burner II NEC PC Engine / TurboGrafx-16 (https://www.youtube.com/watch?v=TORgYPAXk18&t=0s)
* Mac OS on a Sega Genesis? Yes! (Mac OS on a Sega Genesis? Yes! (sega-16.com))
* Making a SEGA Mega Drive / Genesis game in 2019 (https://www.gamasutra.com/blogs/DoctorLudos/20191019/352537/Making_a_SEGA_Mega_Drive__Genesis_game_in_2019.php)

## SCRIPT

Olá pessoal, Fabio Akita



Feliz 2021! Muita gente tava esperando o novo ano pra deixar 2020 pra trás, mas infelizmente não sei se esse ano vai ser muito diferente não. Vamos cruzar os dedos. 





Depois que fiz o episódio onde falei do chip Apple M1 eu ia fazer este, mas acabei falando de segurança. Mas agora vou voltar ao assunto continuando a falar de emuladores e videogames. Isso porque uma das coisas que mais gosto nessa vida é videogames. Desde que comecei a trabalhar sempre dizia que eu trabalho pra ganhar dinheiro pra sustentar meus videogames, e é quase verdade mesmo.






Outra coisa que vocês já sabem que eu gosto é a história das coisas de tech. No episódio de hoje vou juntar a fome e a vontade de comer e contar um pouco da história dos videogames com uma visão mais de programador, levando em conta o que vimos nos episódios anteriores e focar em assuntos que eu pessoalmente gosto. Claro que o tema é gigantesco e não cabe tudo num video só, mas vamos ver o que eu consigo fazer hoje!






Antes de começar, eu vi nos comentários que muitos ficaram com uma dúvida com a explicação que eu dei sobre máquinas de Turing, ou o que hoje chamamos de programas, serem representados por um numerozão, lembram? Um binário é nada mais que um número gigante. Então como falei de emuladores, muitos perguntaram se o lance era fazer outro programa com o mesmo numerozão. 







Mas não é assim que você tem que pensar. Pensar num numerozão como sendo um texto em inglês e a versão emulada sendo o texto em português. Ambos os textos falam, digamos, sobre Harry Potter, mas em línguas diferentes e, portanto, resultam em numerozões diferentes. Quando você sai de Intel e vai pra ARM, por exemplo, necessariamente o mesmo programa recompilado, vai gerar um binário totalmente diferente e, de novo, um numerozão diferente. Espero que tenha esclarecido.




(...)




Pra começar já vou recomendar logo de cara o canal do Dimitris, mais conhecido como Modern Vintage Gamer. Assisto faz anos e ele sempre trás histórias dos bastidores, coisa que eu gosto. O canal dele tem várias histórias de como conseguiram quebrar a segurança dos mais diversos consoles, coisa que é essencial pra conseguir fazer um emulador. Ao longo dos anos empresas como a Sony, Sega, Nintendo, Microsoft, vem colocando mais e mais mecanismos de criptografia e segurança e, mesmo assim, dado tempo suficiente, a comunidade de emulação encontra maneiras de burlar e é fascinante entender como fazem isso.










Por exemplo, lembro da controvérsia quando a Sony retirou o suporte a Linux no Playstation 3 e o povo ficou pistola demais e isso acelerou alguém conseguir quebrar o PS3. Hoje em dia até a Microsoft já aprendeu e qualquer Xbox One você consegue colocar em modo de desenvolvimento, pra facilitar a vida de quem faz jogo independente, e ao mesmo tempo desincentiva gente que quer hackear pra instalar software homebrew, porque o próprio sistema já permite isso. Todo mundo fica feliz. O Dimitris faz uma série muito boa que conta essas histórias em mais detalhes, é o Mistakes were made, ou em bom português, “Erros foram cometidos”.












Pra quem não sabe, a gente costuma dividir consoles de videogames em gerações. Acabamos de entrar na nona geração com o PS5 e Xbox Series X. Infelizmente eu não reservei na pré-venda então me fodi. Se alguém souber de alguém querendo vender a um bom preço, mandem direct no meu Instagram. Enfim, acabamos de deixar pra trás a oitava geração, com PS4, XBox One, Switch e até o Wii U entra nessa. 









A anterior foi do PS3, XBox 360 e o Wii original e foi a maior lavada em favor do Xbox 360 com o Wii original também deixando sua marca com a febre por causa dos controles de movimento. A sexta foi do Dreamcast, PS2, Xbox original e Gamecube, que marcou a virada do milênio em direção ao mundo de alta fidelidade, HD, telas de Plasma e LCD de alta resolução. Mas no fim do século passado, a quinta geração foi o salto de 16 pra 32-bits e a primeira onda de jogos 3D com consoles como Nintendo 64, o Playstation original, o Sega Saturn, Atari Jaguar, Panasonic 3DO e vários outros, foi uma das gerações mais movimentadas que eu já vi, e o salto pra 32-bits foi uma das mais importantes e conturbadas da história recente.












A quarta geração foi dos 16-bits, a virada da década de 80 pra 90, com o Sega Genesis liderando no começo mas com o Super Nintendo lado a lado, a era de tentar ter qualidade gráfica de arcade em casa, e tinha outras opções excelentes como o Turbografx 16 que no Japão era chamado de PC Engine e também tinha o monstruoso Neo Geo. Aliás, Genesis é nos Estados Unidos, aqui no Brasil ou no Japão a gente conheceu como Mega Drive. 









A campanha de marketing da Sega nos Estados Unidos foi super agressiva, com o famoso slogan do "Sega does what Nintendon't" e com o lançamento de jogos como o lendário Sonic, veio o slogan bullshit de "Blast processing". Tecnicamente o Genesis era mesmo mais performático, mas fizeram o erro de configurar uma paleta de cores horrível e limitada. O Super Nintendo usava um chip de 16-bits mais fraco, mas eles tinham aceleração de background como o Mode 7 e uma paleta de cores muito mais rica.











Em seguida, a terceira geração foi dos 8-bits que representaram a renascença do videogame com o Nintendinho liderando, mas com outros como o Sega Master System tentando conseguir espaço. Em termos de hardware, essa geração foi o oposto da de 16-bits, o Master System é quem tinha uma paleta de cores mais rica e por isso jogos de Nintendinho tem cores meio bleh e no Master System eram cores bem mais saturadas e diversificadas. Mas obviamente o sistema de licenciamento e exclusividade da Nintendo garantia muito mais jogos pro console deles, deixando a Sega com poucas opções.









A terceira e quarta geração foram marcadas pelo que hoje conhecemos como a “Guerra dos Consoles”, a briga entre a Sega e a Nintendo. E, de novo, mais nos Estados Unidos, porque no Japão a Sega dominava nos arcades mas nos consoles sempre foi a Nintendo na frente. Até eles fazerem uma merda com a Sony. Fizeram parceria pra lançar o Nintendo Playstation com tecnologia de CD da Sony. Mas num grande evento, a CES, a Nintendo anunciou que ia fazer parceria com a Philips e a Sony só descobriu isso com todo mundo nesse evento. Foi uma cagada homérica da Nintendo, procurem essa história. Mas o importante é que isso deixou a diretoria da Sony full pistola e por isso eles aprovaram lançar o próprio console, o Playstation original, daí o resto - como diriam - foi história.










Voltando, a segunda geração foi a que terminou nos Estados Unidos com o crash dos videogames no começo dos anos 80, a geração do nostálgico Atari 2600, Magnavox Odyssey 2, Intellivision, ColecoVision, Vectrex e dezenas de outros. O crash aconteceu justamente pelo excesso de consoles e principalmente excesso de jogos extremamente ruins, o que arruinou a reputação de games, afastou todo o público e inspirou a Nintendo a criar o modelo de licenciamento e controle de qualidade pra lançar jogos pro console deles. 









Eu joguei alguma coisa nessa época, e apesar da nostalgia, não acho mais divertido jogos de Atari hoje em dia. Esses jogos não envelheceram nada bem, e quem gosta realmente é pelas memórias da infância. Eu tenho essas memórias, mas viraram só isso mesmo, memórias. Nem Enduro, nem River Raid, nem Space Invaders, ou Pitfall, todos jogos que eu adorava, não consigo mais jogar hoje. A tecnologia nessa época ainda era bem experimental, bem pouco madura, com pouquíssimos recursos, então realmente programar pra esses consoles era um exercício em frustração e era impossível fazer jogos mais sofisticados do que um Pacman.








Agora, segundo a Wikipedia, a primeira geração de consoles tem pelo menos uns 900, não é a toa que na próxima geração ia ter um crash. Começou como uma bolha. Tudo foi derivado da do avô dos videogames, o Pong. E nessa época ainda não havia sido inventado e nem difundido o conceito de cartuchos. A grande maioria desses consoles eram meros clones baratos de Pong e vinham com um único jogo, ou até mais de um, mas eram pré-instalados dentro e você podia trocar de jogo usando um interruptor, mas não podia instalar jogos novos.  Ainda era a geração que entendia que uma máquina só precisava executar uma única tarefa. E nessa geração trocentos fabricantes diferentes faziam seus próprios clones de Pong, Pacman e coisas assim. Imagina a dificuldade pro consumidor.











Já vimos nos episódios anteriores que cartuchos são uma placa com chips de ROM que o console tem acesso direto, sem precisar “carregar” nada pra RAM, é como se fosse um pente de RAM pré-carregado. E se você assistiu a série do Netflix, High Score viu que o primeiro console que introduziu o conceito de cartuchos foi o Fairchild Channel F em 1976 mas quem de fato popularizou a idéia foi o Atari VCS que saiu um ano depois. Vários fabricantes já estavam testando idéias pra baratear custos e facilitar vendas, e eventualmente alguém chegaria no cartucho, era inevitável. Todo mundo tava procurando formas de baratear os custos e tornar coisas como games mais acessíveis, sem usar mecanismos lentos como as fitas cassette, ou caros como disquetes.











Obviamente, a cada nova geração a complexidade dos consoles ia aumentando uma ordem de grandeza. Por exemplo, os consoles de 8-bits não são tão complicados assim e eu dei um pequeno exemplo no episódio do Super Mario com o Nintendinho e canais como o Coding Secrets e Retro Gaming Mechanics Explained tem muitos vídeos explicando técnicas de programação e como os jogos eram estruturados nessas plataformas, incluindo coisas como o lendário Mode 7 do Super Nintendo. Nessa época, cada clock contava e nenhum compilador ainda conseguir cuspir binários otimizados. Todo jogo precisava ser escrito em assembly, na mão mesmo. Recomendo assinar os canais deles.










Emular esses consoles significa encontrar as especificações dos chips e programar as instruções equivalentes em software, garantir que o clock funcione igual, que as instruções executem nos mesmos tempos. Isso não é tão trivial porque pensa que nossas CPUs hoje são absurdamente mais rápidas que antigamente, então a gente precisa propositalmente fazer as instruções rodar mais devagar. No caso de um Nintendinho você tem que criar o emulador pra CPU Ricoh 2A03 que é baseado no MOS 6502. Tem que escrever o emulador pro PPU ou Picture Processing Unit que é o chip responsável por renderizar backgrounds e sprites. Mesma coisa pro APU que é o Audio Processing Unit que tem cinco canais de áudio e é um PSG ou Programmable Sound Generator. Enfim, criar software pra emular cada um dos chips.










Daí precisa emular os 2 kilobytes de RAM que é bem fácil porque temos RAM de sobra hoje. Tem que emular os controles e finalmente os MMU ou memory management controllers que são chips que vinham nos cartuchos e permitiam bancos de ROM. O sistema permite um máximo de 40 kilobytes de ROM mas com os MMUs você podia ter cartuchos com até 2 megabytes ou mais e também memória com bateria pra gravar saves. E sim, é bastante coisa pra emular. Eu expliquei como isso funciona no episódio do Super Mario, dêem uma olhada. Aliás, tudo isso é só pro Nintendinho de 8-bits. Agora repita isso pra todos os consoles, em todas as suas variações ao longo dos anos, de cada uma das oito gerações que eu descrevi. É coisa pra cacete.










Falando só de especificações técnicas, sem olhar os jogos, tecnicamente o Turbografx 16 deveria ser o mais fraco, porque ele usa o processador 65C02 que é o mais rápido CPU 8-bits da família 6502, e tava competindo na geração de 16-bits do Genesis e Super Nintendo. A NEC escolheu usar chips de RAM e ROM dos cartuchos com o clock máximo que o CPU conseguia rodar, e isso foi muito inteligente. Se você pegar jogos de Turbografx como Bonks Adventure ou Dracula X que é o Castlevania, vai provavelmente dizer que é comparável ou até superior ao Super Castlevania IV do Super Nintendo. 










O Super Nintendo muita gente pensa que é o mais poderoso por conta do chip gráfico que tem capacidade de rotacionar e escalar o layer de background pra fazer os famosos efeitos pseudo-3D como em Mario Kart ou Pilotwings. Mas a Nintendo foi pelo caminho mais conservador e escolheu usar o processador 65816 que é o sucessor de 16-bits do 65C02 usado no Turbografx 16. Só que o chip de 8-bits do Turbografx ia até 7.6 Mhz e o chip de 16-bits do Super Nintendo foi capado em míseros 3.58 Mhz, metade, em parte porque a RAM não era mais rápida que isso. 








Muita gente pensa em performance só como clock da CPU, mas até hoje, você precisa parear a CPU com RAM porque o a CPU precisa ficar constantemente puxando dados e gravando nessa RAM, por isso coisas como clock da RAM e dual channel fazem muita diferença em PC de hoje. E por isso também uma Apple preferiu soldar a RAM direto do lado do seu novo CPU M1 pra garantir a melhor combinação de performance. Smartphones fazem a mesma coisa. Se você comprar um AMD Ryzen mais moderno mas colocar pentes de RAM velhas de menos de 2Ghz e sem colocar em dual channel, você criou um gargalo enorme, e está desperdiçando o CPU.













Sendo o Super Nintendo e o Turbografx derivados da família 6502, eu não posso dizer por experiência própria mas pelo que já li a respeito o assembly dele não era muito amigável pra programar, exigindo muita burocracia, como a constante troca de modes no Super Nintendo entre instruções de 8 bits e 16 bits. Se tentasse escrever em C, o código gerado ficava muito lento pelo overhead do C, faltava registradores pra conseguir otimizar. Enfim, não era uma CPU amigável pra um programador de assembly, e eu já disse que nessa época era obrigatório programar em assembly pra tirar o máximo dos poucos recursos que tinha nesses consoles.










Por outro lado, o Sega Genesis ou Mega Drive de fato tinha o CPU superior, eles escolheram o Motorola 68000 que era híbrido 32 e 16-bits, com clock também de 7.6 Mhz, o dobro do Super Nintendo e ainda vinha com um segundo processador Zilog Z80 de 8-bits que era o mesmo do Master System, usado como processador dedicado de áudio. Além disso, diferente do 65C02 e 65816, você conseguia escrever pelo menos parte do jogo em C, que gerava assembly suficientemente rápido pro 68000. E mesmo não tendo um chip gráfico dedicado pra conseguir os efeitos de rotação e escalonamento de background, ele conseguia alguns desses efeitos via software por causa do CPU mais rápido. Veja jogos como Castlevania Bloodlines por exemplo. Pois é, era possível fazer Mode 7 no Mega Drive, isso não era uma exclusividade do Super Nintendo. 









Mas como eu disse antes, uma coisa que o Mega Drive falhou foi na escolha de paletas de cor. Ele tinha conjuntos de cores horríveis e menos cores no total que o Super Nintendo ou Turbografx. Por isso, visualmente, os jogos de Megadrive parecem sempre mais feios em termos de cor se comparar jogos que foram lançados pras outras plataformas. Pegue jogos que saíram ao mesmo tempo em todas como Street Fighter II e no Mega Drive vai ser mais feinho.  Olha aqui do lado. Esse é o do Super Nintendo, esse outro do Turbografx e por último, esse é do Mega Drive.









No final do dia, tudo depende do que os programadores conseguiam extrair dessas máquinas. E em termos de jogos não se pode comparar os que saíram no lançamento dos consoles com os que saíram no final da geração. No começo é quando os programadores ainda não conhecem todo o potencial do hardware. E quando a geração tá acabando, é quando os programadores já descobriram todos os truques possíveis. É interessante ver como jogos como Afterburner II é definitivamente melhor no Turbografx com um processador teoricamente pior de 8-bits contra a versão do Mega Drive de 16-bits.









Mais do que isso, o processador do Mega Drive, o 68000 é super famoso e equipou microcomputadores como os Amiga e Macintosh por exemplo. Existiu até uma tentativa de emular o Mac OS 7 pra rodar em cima de um Mega Drive. Infelizmente, tirando uma thread de fórum de 2006, não achei imagens boas ou vídeos mostrando ele rodando. Se alguém tiver não deixe de compartilhar nos comentários. 









Obviamente não seria prático rodar o Mac OS num Mega Drive, é só mais uma evidência do que falei no vídeo anterior sobre máquinas universais de Turing: mesmo lento é possível emular outro sistema. E tecnicamente faz sentido, ele usa o Sega CD como um CD SCSI que o Mac consegue acessar e o video sai pela extensão 32X que foi uma expansão pro Mega Drive conseguir rodar polígonos e outros efeitos especiais, incluindo mais resolução e mais cores também.










De qualquer forma, até a terceira geração, dos 16-bits, muito da programação de jogos se fazia em Assembly, particularmente porque a família de CPUs da MOS não conseguia ter C que gerasse binários eficientes, então só codando assemblão na munheca mesmo. Mas a próxima geração teve um salto enorme. Na quarta geração começamos a usar processadores de 32-bits com arquitetura RISC, semelhante aos processadores ARM de celulares de hoje em dia e ao novo Apple M1. 







Era possível ter clocks maiores e acesso a exponencialmente mais endereços de RAM. E daí passou a se utilizar mais C, porque nessa arquitetura os compiladores evoluíram mais e já era possível ter código compilado tão eficiente ou mais do que escrever assembly na mão. E se alguém tinha alguma dúvida, não, em 99.99% dos casos você não vai conseguir escrever mais assembly melhor do que um compilador consegue gerar.








Num resumo bem resumido, pense que a arquitetura x86 ou CISC é feita de instruções complexas, ou seja, que fazem bastante coisa e por isso demoram vários clocks pra executar e arquitetura RISC como nos chips ARM é feita de instruções simples que, que executam poucas tarefas e por isso terminam rápido, tipo num único clock. Só pra ilustrar pra quem não tá acostumado com assembly, num processador x86 talvez eu tivesse uma função chamada “desenhar um botão” que numa instrução só já mostra um botão desenhado na tela. Num ARM hipotético teria só a função “desenhar linha” e eu precisaria chamar quatro vezes pra desenhar o mesmo botão. 










Na prática não faria tanta diferença porque desenhar botão digamos que leva 4 clocks pra executar e o desenhar linha leve 1 clock. No fim ambos levariam 4 clocks. Mas pra quem escreve direto em assembly faz diferença porque ele precisaria escrever muitas linhas a mais de código pra fazer a mesma coisa. Hoje em dia não faz diferença, porque do C o compilador que vai ter o trabalho de gerar o assembly, mas antigamente programar em C não era eficiente então fazia diferença essa história de arquiteturas CISC ou RISC porque influenciava diretamente na produtividade dos programadores.










Mas a partir da geração 32-bits passamos a programar quase que exclusivamente em C, deixando o trabalho de gerar assembly pros compiladores, como o compilador do Visual Studio da Microsoft ou o GCC que tem em todo Linux ou o LLVM, mais especificamente o Clang, que tem em todo Mac. Agora, imagine que descobrimos uma forma mais eficiente de fazer a função hipotética de desenhar botão e em vez de levar 4 clocks poderia levar 2. 









Num Intel fodeu, não tem como mexer nessa função porque ela é impressa no hardware, no chip da CPU. Num RISC, que tem instruções mais simples, podemos atualizar o compilador e ele vai cuspir um assembly mais otimizado que vai usar menos instruções e executar em 2 clocks. Ou seja, sempre temos possibilidades de, sem mexer no código em C, ganhar performance de graça por avanços nas otimizações dos compiladores. E nesse quesito o ARM tem mais vantagens do que x86 da Intel.











Pra nós, que dificilmente vamos programar assembly na mão, a arquitetura do chip por baixo não importa porque o compilador vai fazer o trabalho bruto de escrever assembly otimizado, mas basta saber que sim, a arquitetura RISC é definitivamente mais flexível do que os x86. A Intel é obrigada a carregar esse legado que vem da época em que era importante um assembly mais simples e, portanto, mais complexo. Hoje isso não é mais importante. Em última instância a arquitetura RISC era mais chata naquela época se você precisasse escrever assembly na mão, mas agora ela tem vantagens. Ela estava à frente do seu tempo.










De qualquer forma, a arquitetura dos dois tipos foi ficando mais complexa com o tempo, porque agora esses CPUs também eram capazes de realizar tarefas concorrentemente com multithreading além de ter chips gráficos capazes de calcular polígonos. Você tinha que ser um sadomasoquista hardcore pra querer fazer multithreading e polígonos em assembly num jogo inteiro. E antes os jogos tinham acesso direto ao hardware, sem um sistema operacional intermediando, mas no Saturn, Playstation ou Nintendo 64, agora eles tinham um firmware que funciona como um sistema operacional super leve. Agora meio que ficou necessário, porque senão ninguém ia conseguir fazer jogos nesses hardwares que eram exponencialmente mais complexos do que a geração anterior. É quando começamos a trocar um pouco de performance por mais qualidade de vida de programação.









Isso aumentou dramaticamente a dificuldade de emular esses sistemas. Porque se você fizer a engenharia reversa de chips de processamento de polígonos e tentar emular só via software, os CPUs de PCs da época simplesmente não conseguiam rodar. Ao mesmo tempo começamos a ter placas gráficas 3D em PC também com os venerados 3DFX. Pra programar em C pra placas 3DFX se usava a biblioteca Glide. Então algumas das primeiras tentativas de emular Playstation ou Nintendo 64 envolvia criar um software Adaptador entre as funções do console e os equivalentes na Glide. Por isso se você instalou emuladores dos anos 90 como o famoso UltraHLE tinha a chatice de achar a DLL certa de Glide por exemplo.










Existem vários vídeos e blogs onde você consegue encontrar a diferença de uma GPU pra uma CPU mas sendo bem simplista pra você ter uma idéia na cabeça. Numa CPU teríamos funções como adição, onde você coloca dois números em dois registradores e ele calcula a soma e grava em outro registrador, e vai fazendo assim uma instrução de cada vez. Se precisássemos processar todos os pixels de uma tela, digamos deixar a cor mais escura, seria um puta trampo pro CPU. Por que? Antigamente a resolução de videogame era tipo trezentos e vinte por duzentos e quarenta pixels, ou seja, setenta e seis mil e oitocentos pixels. 








Só pra simplificar a conta digamos que cada adição da CPU custasse um clock, então ia levar mais de setenta e seis mil clocks pra processar todos os pixels. E ele teria que dar um jeito de fazer isso sessenta vezes por segundo. Ou seja, não dava porque num processador da era 16-bits, de 7 megahertz significa 7 mil clocks por segundo. Então ia levar mais de dez segundos pra processar essa imagem do exemplo.









Agora uma GPU é feita pra executar múltiplas adições em paralelo. Desde sempre ela foi organizada no que hoje você conhece como multi-core. Mas em vez de quatro ou oito cores que você tem num Intel i5 da vida, uma GPU tem dezenas, ou centenas de pequenos cores que fazem bem pouca coisa muito rápido. Em vez de passar só um número como parâmetro, passamos um vetor. Pense em um vetor como um array de números. 







Então é a adição de um vetor com outro vetor. Digamos que a GPU aguente um vetor de 320 números, então ele precisaria processar a adição só duzentas e quarenta vezes, um por clock, ou melhor ela poderia rodar em duzentas e quarenta dos seus micro-cores e executar tudo em paralelo num clock só. Olha como só nesse exemplo, saltamos do custo de mais de setenta mil clocks pra um único clock.









Uma GPU executa tarefas muito simples em uma quantidade grande de dados de uma só vez, essa é a especialização dela. Porém, ela só é rápida pra esse tipo de cálculo mais massivo e não pra cálculos simples e lineares onde a próxima instrução depende do resultado da anterior. E gráficos é o melhor caso de uso, porque são trinta ou quarenta quadros por segundo com uma quantidade massiva de pixels que precisam ser processados e cujo processamento de uma linha de pixels independe da outra linha de pixels. 








E pixels podem ser organizados em vetores e matrizes, que são os elementos que uma GPU adora processar. E em tempos mais recentes inventaram uma forma de mandarmos pequenos programinhas pra GPU, isso é o que você já deve ter ouvido falar como shaders. Enfim, já foi uma longa tangente, por hoje vamos só entender isso. GPU é um troço simples que se tornar complexo porque roda com vetores longos e massivamente em paralelo. CPU é um troço complexo que roda com argumentos simples e linear.










Ah sim, e nessa época a Microsoft tava lançando coisas com Direct3D que era uma tentativa de padronizar a programação 3D pra placas gráficas de diferentes fabricantes. Então talvez você não tivesse a 3DFX Voodoo mas tinha a Nvidia TNT2. Então precisava do nGlide que era uma camada que respondia as APIs da Glide mas mapeava pra chamadas de Direct3D. Sim, se hoje em dia você tem dores de cabeça com drivers da Nvidia ou AMD, com Direct3D ou Vulkan ou OpenGL, imagina a zona no fim dos anos 90. Era a mesma coisa só que pior e mais instável, a gente ainda tava aprendendo como lidar com placas 3D. Um dia vou fazer um episódio falando mais de GPUs, mas pra agora, só estas noções que expliquei pra diferenciar um CPU de uma GPU deve bastar pra maioria dos casos.










Ver coisas como o emulador UltraHLE, rodando Super Mario 64, em um Pentium II ou III, mesmo que parcialmente e meio bugado, em 1999, sendo que o Nintendo 64 tinha sido lançado só 3 anos, antes era absurdamente impressionante. Pra você ter uma idéia, mesmo hoje em dia usando emuladores como o Mugen 64, você não consegue emulação perfeita de Nintendo 64. Temos dificuldade em manter 60 frames por segundo em hardware considerado fraco hoje mas que pra época era um supercomputador, como um Raspberry Pi 3 ou processadores de celular Androids. Isso depois de 20 anos. De qualquer forma o UltraHLE era tão bom que deixou a Nintendo full pistola e você pode conferir essa história no video do canal Modern Vintage Game que vou deixar nas descrições abaixo.











A estratégia de emulação começou a mudar com o UltraHLE. Com consoles de 8 e 16 bits a estratégia era emular os chips como a CPU, PPU e tudo mais. Com o aumento da complexidade nas plataformas de 32-bits isso era um trabalho brutal e bem mais difícil. Porém, como o processo de desenvolvimento dos jogos passou pra C, linkando com as bibliotecas no firmware dos consoles, outra estratégia passou a ser interceptar as chamadas de função em C e traduzir pro equivalente no Windows por exemplo. Se você assistiu meu episódio sobre WSL, o Windows Subsystem for Linux, vai lembrar que a versão 1.0 fazia a mesma coisa com programas pra Linux, interceptava as chamadas de sistema pra kernel do Linux e traduzia em tempo real pra chamadas pra kernel do Windows. 












O Playstation, pela popularidade, teve muito mais gente tentando emular e hoje em dia você consegue rodar praticamente todos os jogos, inclusive com hacks pra aumentar a resolução interna e aplicando filtros nas texturas pros jogos ficarem um pouco mais bonitos. Mas em paralelo ao UltraHLE a gente tinha alguns emuladores de Playstation também como o PSEmu ou o Virtual Game Station que era comercial e só rodava em Macintosh. Nenhum dos dois era perfeito na época, mas foram referência pra próxima geração de emuladores. 








O primeiro emulador que eu lembro que me deixou realmente impressionado foi o Bleem. Ele era diferente primeiro porque era comercial e fechado e segundo porque em vez de tentar emular tudo do sistema e todos os jogos, eles preferiram focar em otimizar bem só alguns poucos jogos, como Gran Turismo ou Final Fantasy 7. Ou seja, eles deixavam hardcoded no emulador algo como “if gran turismo mude pra fazer X”, até o Gran Turismo rodar liso mesmo que outros jogos falhem. E eles vendiam pacotes de otimizações pra cada jogo. Na época, quando vi os anúncios, eu achava que era enganação, mas de fato a desgraça funcionava. 












E eles ainda faziam isso de aumentar a resolução de renderização então jogos de playstation que nativamente só tinham 320 por 240 pixels dobrava pra 640 por 480. Lembrando que a gente usava monitores de 800 por 600 ou 1024 por 768. Então 640 por 480 era nosso HD. O emulador começou a mudar os jogos pra fazer coisas que originalmente eles não foram projetados pra fazer, e isso era fascinante. Pra ver como foi essa história eu recomendo o documentário sobre o Bleem do canal The Gaming Historian, que é outro canal bem produzido, e vou deixar o link nas descrições abaixo.










O Bleem acabou não vingando, tomaram um processo da Sony nas costas e eles tentaram voltar repetindo a estratégia com o Bleemcast na geração seguinte, pra emular Dreamcast. Mas apesar de não terem perdido o processo da Sony, os custos de advogados foram absurdos, e eles fecharam em 2001, no mesmo ano que a Sega decidiu descontinuar o Dreamcast também.








O desenvolvimento de emuladores de Playstation andou bem mais rápido do que Nintendo 64 mas o mais atrasado de todos sempre foi o Sega Saturn. Ele saiu antes do Playstation e esse lançamento foi um dos maiores desastres da história do videogame. Pra quem não sabe, a Sega dos Estados Unidos sempre se ferrava por causa das decisões da Sega do Japão. A falta que fazia mandar e-mails naquela época. Eles desenvolveram o 32X nos Estados Unidos pro Genesis sem saber que no Japão estava sendo desenvolvido o Saturn. Pensa a zona.










O Saturn ainda recebeu uma arquitetura super difícil de trabalhar com dois processadores paralelos. A maioria não sabe programar paralelo hoje, imagina naquela época. Daí acabavam só usando um dos processadores. Foi mais ou menos o mesmo problema que a Sony repetiu com o Playstation 3 e o famigerado CPU Cell com seus co-processadores paralelos, os SPUs. Até hoje o chip é considerado excepcional, mas era notoriamente difícil de programar. Tanto que só no final da sexta geração começaram a sair jogos que tiravam vantagem do processamento paralelo como o lendário The Last of Us original. E foi um dos motivos de porque a Sony perdeu essa geração pro XBox 360 da Microsoft, que era uma arquitetura muito mais simples de programar. Um canal que mostra vários jogos de Saturn é o canal do Sega Lord X, recomendo assistir pra ver se você nunca jogou Saturn.











Em termos de emuladores, o RPCS3 já consegue rodar muitos jogos de PS3 mas é bem pesado. Simular os SPUs sempre foi o desafio. E essas foram algumas das curiosidades que eu mais gosto sobre alguns dos meus videogames favoritos, mas tem toneladas de histórias a mais, tanto que existem canais de YouTube dedicados só nisso, como o The Gaming Historian ou Modern Vintage Games que já mencionei, recomendo que assistam o canal deles pra mais curiosidades assim. Mas o objetivo de hoje era dar uma pequeno overview, uma pincelada geral pra ver se vocês ficam interessados no assunto também. Eu acho que gosto mais de entender os mecanismos de como esses consoles e games funcionam, como eram construídos, que truques usavam, mais do que realmente jogar os jogos propriamente ditos.









Pra finalizar, deixa eu listar os emuladores que mais gosto pra vocês pesquisarem no Google e brincar. A maioria existe pra todas as plataformas e sistemas operacionais, incluindo Windows, Linux e rodam em Raspberry Pi que é fraquinho pros padrões hoje mas suficiente pra maioria dos emuladores. Mas se puder rodar num hardware pra Android melhor, eu recomendo. A maioria dos apps você encontra direto no Google Play Store. E o principal de todos é o RetroArch. Ele em si não é um emulador, mas uma interface pra vários emuladores, que são chamados de Cores. Nem todos funcionam bem ou de primeira, mas pelo RetroArch você consegue instalar os Cores online além de coisas como temas diferentes, artes das capas das caixas dos jogos, códigos de cheats, e diversas outras coisas. É um mundo em si só.









Quem gosta de Sony no próprio RetroArch tem cores de Playstation original. Tem o PCSX2 pra Playstation 2 que roda até que bem mas é pesado. Tem o RPCS3 que ainda não é muito estável e nem muito compatível mas se seu computador for potente deve rodar razoavelmente bem. E tem o PPSPP pro Vita, um dos meus favoritos, que roda muito bem. Jogos como Crisis Core rodam muito bem, mas God of War vai precisar de mais hardware pra rodar direito. E nem tentem rodar em Raspberry Pi, o hardware não é suficiente. Num smartphone mais novo deve rodar razoável, mas acima de PS2, recomendo um PC.










Pra quem gosta de Nintendo, o Nintendinho e Super Nintendo tem vários emuladores como o Mesen que já mencionei ou o Bsnes. E pelo RetroArch você baixa a maioria e é plug-and-play. Mas os mais interessantes são o Dolphin que consegue rodar bem jogos de Gamecube e Wii original, embora seja pesado. Tem o Citra que roda jogos de Nintendo 3DS muito bem. Mesmo no meu PC com Intel i7 alguns dão umas travadas e perde frame, então não é perfeito, mas tá evoluindo rápido. O mesmo vale pro Cemu que consegue rodar jogos de Wii U muito bem mas dá um puta trampo configurar. Se tiver paciência, vai poder jogar Zelda Breath of the Wild em Full HD com vários filtros que deixam o jogo mais bonito do que no Nintendo Switch. E falando em Switch tem o Yuzu que já roda vários jogos de Switch, mas eu mesmo não testei porque tenho um Switch.










Pra Sega, emuladores de mastersystem e genesis tem bastante no RetroArch, mas o mais difícil é o Saturn por causa da arquitetura complicada que expliquei antes. Mesmo assim, o emulador Yaba Sanshiro é bem competente e todo jogo que testei como Panzer Dragoon ou Sega Rally rodaram muito de boa mesmo num Android, então é o que recomendo. E quem gosta de Dreamcast tem o Redream que é pago, mas eu digo que vale a pena pagar porque é de longe o melhor emulador, que roda mais estável e mais compatível. 








Finalmente, eu gosto muito de jogos de arcade então NEO GEO é essencial, mas eu mesmo odeio procurar emuladores, bios e configurações que funcionam direito então nem vou recomendar muito que se tente do zero. Eu me enchi tanto que preferi comprar no Mercado Livre o emulador que vem com as ROMS e tudo mais já pré-configurado pra MAME. MAME é de longe o emulador mais chato do mundo de configurar, eu não recomendo. É melhor achar pré-configurado. E a razão de ser tão chato é que arcades eram como um console específico feito só pra um ou um conjunto pequeno de jogos. 









A Capcom tinha as famosas placas CPS1, os mais modernos usavam hardware derivado do Dreamcast, o Naomi. E se contar todas as placas criadas desde os anos 80, estamos falando de dezenas. E cada um tem uma configuração diferente. Configurar um a um na mão é um trabalho que não vale a pena. Se alguém tiver boas dicas de como facilmente configurar um bom emulador de Neo Geo pra Android, fiquem à vontade pra colocar nos comentários abaixo.







E sim, vou só listar os emuladores e não pretendo fazer vídeos de como configurar porque isso você vai achar toneladas de tutoriais em video e em blogs, bem detalhados. O próprio Wiki do RetroArch tem bastante documentação. Se você quer jogar jogos pirata, tem que fazer algum esforço ou gastar alguma grana pra comprar já configurado. Minha parte eu já fiz. Espero que tenham gostado dessa curta história dos videogames. Quem tem dúvidas ou histórias pra compartilhar, deixem nos comentários abaixo. Se curtiram o video mandem um joinha e compartilhe com seus amigos, assine o canal e não deixe de clicar no sininho pra não perder os próximos. A gente se vê, até mais!

