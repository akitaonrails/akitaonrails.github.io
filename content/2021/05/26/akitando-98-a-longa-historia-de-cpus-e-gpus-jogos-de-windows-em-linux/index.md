---
title: "[Akitando] #98 - A Longa História de CPUs e GPUs | Jogos de Windows em Linux??"
date: '2021-05-26T12:26:00-03:00'
slug: akitando-98-a-longa-historia-de-cpus-e-gpus-jogos-de-windows-em-linux
tags:
- CUDA
- Shaders
- OpenGL
- OpenCL
- Vulkan
- DXVK
- DirectX
- Steam
- Games
- akitando
draft: false
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/JEp7ozWqIps" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Finalmente parei pra brincar de jogos de Steam/Windows rodando em Linux na mesma (ou melhor) performance. LSI Steam + Wine + DXVK + Proton-GE. Qual é a história que nos trouxe até aqui? Hoje quero contar 30 anos de história de CPUs e GPUs pra você ter um panorama de como as coisas evoluíram no mundo gráfico até hoje. E a partir de 01:01:26 falar mais especificamente de como configurei NVIDIA Optimus no meu laptop.


## Conteúdo:


* 00:00:00 - Intro
* 00:02:08 - Games rodando no Linux
* 00:04:24 - pós-Intro
* 00:04:56 - ThinkPad X1 Extreme
* 00:05:17 - Solução térmica de laptops
* 00:08:56 - Boost e Throttling
* 00:11:08 - Diferentes tipos de CPUs
* 00:13:42 - AMD Ryzen acelerando!
* 00:16:11 - Apple e AMD vs Intel
* 00:17:33 - Intel atira no pé: Samsung avança
* 00:17:55 - Apple: jornada pra independência
* 00:21:28 - AMD quase compra NVIDIA?
* 00:21:59 - História dos GPUs
* 00:22:11 - 1990 - SGI, Rare e Nintendo
* 00:25:06 - 1994 - arcades e consoles 32-bits
* 00:26:04 - mundo monocromático
* 00:28:09 - cores: ATI e VESA
* 00:29:12 - entendendo resoluções
* 00:30:35 - entendendo interlacing
* 00:31:46 - workstations SGI
* 00:33:29 - 1995 - entra a 3DFX
* 00:34:10 - o fator Carmack
* 00:34:47 - o fim da 3DFX - libglide
* 00:36:54 - o fim da SGI - IrisGL
* 00:38:05 - 2000 - ATI vs NVIDIA
* 00:38:38 - 3D no desktop
* 00:39:51 - Shaders
* 00:40:28 - Cel Shading
* 00:41:09 - Vertex Shader
* 00:42:16 - Shader Languages
* 00:45:17 - GPGPU e nomenclaturas
* 00:47:43 - Cuda, OpenCL
* 00:48:25 - 2014 - Apple Metal
* 00:49:24 - Chegamos no Vulkan!
* 00:50:08 - MoltenVK, Angle, DX12
* 00:51:57 - Bytecode de shaders
* 00:53:19 - DXVK
* 00:54:33 - A API pra unificar todas as APIs
* 00:57:06 - Entra a Valve!
* 00:57:34 - Evoluindo do Wine
* 00:59:06 - 2018 - de DirectX pra Vulkan
* 01:00:25 - Finalmente, Proton!
* 01:01:26 - NVIDIA vs open source (config começa aqui)
* 01:04:11 - Decepticon: Optimus Prime
* 01:10:54 - (libusb com xow usa muita CPU, cuidado!)
* 01:11:31 - Resumão
* 01:13:28 - O outro legado da SGI
* 01:14:01 - Conclusão


## Links:

* Why did SGI (Silicon Graphics) fail? (https://www.quora.com/Why-did-SGI-Silicon-Graphics-fail)
* Why did AMD buy out ATI? ((8) Why did AMD buy out ATI? - Quora)
* The History of the Modern Graphics Processor (https://www.techspot.com/article/650-history-of-the-gpu/)
* 3Dfx History: The GPU’s Great Turning Point? (https://tedium.co/2018/02/14/3dfx-history-failure/)
* Chapter 34. PRIME Render Offload (https://download.nvidia.com/XFree86/Linux-x86_64/440.44/README/primerenderoffload.html)
* proton-ge-custom - GitHub (https://github.com/GloriousEggroll/proton-ge-custom)
* DXVK - GitHub (https://github.com/doitsujin/dxvk)
* MetalAngle - GitHub (https://github.com/kakashidinho/metalangle)
* MoltenVK - GitHub (https://github.com/KhronosGroup/MoltenVK)
* Angle - GitHub (https://chromium.googlesource.com/angle/angle)
* An interview with the developer of DXVK, part of what makes Valve's Steam Play tick (https://www.gamingonlinux.com/articles/an-interview-with-the-developer-of-dxvk-part-of-what-makes-valves-steam-play-tick.12537)
* The story of WebGPU — The successor to WebGL (https://eytanmanor.medium.com/the-story-of-webgpu-the-successor-to-webgl-bf5f74bc036a)
* Vulkan and Metal (some observations) (https://developer.apple.com/forums/thread/38469)
* 3 Years of Metal (https://blog.roblox.com/2020/05/3-years-metal/)
* A Comparison of Modern Graphics APIs (https://alain.xyz/blog/comparison-of-modern-graphics-apis)
* Thread Rare/SGI (https://twitter.com/GameAnim/status/1077359488657612800?s=20)
* The 8-bit Guy: CGA Graphics - Not as bad as you thought!(https://youtu.be/niKblgZupOc)


## SCRIPT

Olá pessoal, Fabio Akita


Algumas pessoas me perguntam em DMs como eu faço pra conciliar jogar, estudar, trabalhar e tudo mais. Na real, eu nunca conciliei bem não. Nunca tive dias e horários bem definidos pra fazer as coisas, sempre fui fazendo de acordo com a prioridade da época. Mas vocês esquecem de outra coisa: eu não estou mais no começo de carreira. Vira e mexe eu falo de games porque só agora é que tô tendo um pouco mais de tempo sobrando. Eu sempre gostei de games desde criança, mas na faixa dos 20 e poucos aos 30 e poucos anos eu quase não jogava. Cansei de começar jogo e nunca ter tempo de continuar.







Essa foi uma fase mais ou menos do começo dos anos 2000 até alguns poucos anos atrás, pulei a metade final do PS2, pulei o Xbox original, Wii, Wii U, PS3, Xbox 360. Só fui voltar na metade final da era do PS4 e Xbox One. Jogos de PC então, a última vez que tive um desktop foi lá pra 2001 ou 2002. Pra piorar, de 2004 a 2015 eu usei quase exclusivamente Macs, então esquece games. Pulei totalmente a fase do World of Warcraft ou Skyrim por exemplo. A última vez que eu tinha jogado FPS foi na época do Half Life II original e mesmo assim não acabei.







Mesmo assim sempre fiquei acompanhando a evolução das coisas, e finalmente de uns 3 anos pra cá que voltei a jogar mais. Só que aí comecei o canal e acabou meu tempo livre de novo. Como eu disse no episódio passado, eu tenho mais cabeça de colecionador do que propriamente jogador. Eu não jogo e-sports porque sou tão ruim num Counter Strike quanto num futebol de verdade e prefiro jogos single player. Eu não jogo pra socializar, pra mim é mais que nem ler um livro ou ver um filme.







De qualquer maneira empolguei pra fazer esse episódio porque meu notebook tava me irritando. É um notebook bom na real. Mas no Windows 10 ele superaquecia muito rápido, ventoinha ficava a milhão e pra usar no colo era bem ruim, mesmo fazendo undervolting. Já faz um tempo que queria colocar Linux nele, resolvi fazer isso esses dias.






Aproveitei pra testar uma coisa que já tinham me falado mas que só agora resolvi ver com os próprios olhos: o suporte a games de Windows rodando em Linux com praticamente a mesma performance, ou às vezes até um pouco melhor. E dêem uma olhada!



(... games)




Pois é, todas as cenas que vocês acabaram de ver foram gravadas via OBS na mesma máquina rodando os jogos, tudo do Steam, nativo num Linux, sem máquina virtual, sem dual boot nem nada! Se você já é gamer experiente, o que vou falar hoje provavelmente vai ser arroz com feijão, mas acho que a maioria das pessoas, incluindo a maioria dos programadores desconhece a história de como chegamos nesse ponto, vamos voltar no tempo de novo!





(...)





Esse notebook é um Thinkpad X1 Extreme. Quem assistiu o episódio sobre teclados mecânicos já viu ele. É um notebook muito bom no papel, mas a Lenovo pisou um pouco na bola na solução térmica. Eu li que o X2 também superaquece fácil. A gambiarra pra ajudar um pouco é trocar a pasta térmica. Pelo menos o processo pra isso é bem simples.






A maioria dos fabricantes usa uma pasta que tem mais durabilidade, pra você nunca ter que abrir a máquina pra trocar. Mas o problema é que esses tipos não dissipam tão bem o calor quanto deveriam. E pra piorar tenho uma GPU discreta, a GTX 1050 Max Q, que também esquenta bastante. Quando as duas funcionam juntas, rapaz, fica quente. Não recomendo usar no colo muito tempo se não quiser ficar estéril. CPU e GPU e qualquer chip na real, incluindo RAM, SSD, tudo dissipa a maior parte da eletricidade que consome na forma de calor.







Quanto mais você quer forçar um chip pra ir mais rápido, mais energia vai consumir e muito mais calor vai dissipar. Quando se fala em diminuir o tamanho dos transistores é pra consumir menos energia pra fazer o mesmo trabalho e aí dissipar menos calor. Produção de chips é sempre um trade off entre performance, consumo de energia e dissipação de calor. Quanto mais rápido você quer um chip, precisa dar mais energia, e precisa dar um jeito de esfriar, senão queima o chip.








O problema de dissipar é que quanto menor o chip e mesmo assim consumindo mais e mais energia, menos área tem pra dissipar. Por isso a gente estende essa área com heat pipes, canos de calor, que são troços de metal que vão de um lado pro outro do notebook. Daí os fans ou ventoinhas são colocados estrategicamente pra remover o calor que esses canos vão dissipando pro ar e pra carcaça do notebook.








Mesmo o material do cano sendo altamente condutor, ele precisa estar 100% encostado no chip, mas isso não é possível só encostando um metal no outro. Pra isso a gente coloca um material viscoso entre os dois, a tal pasta térmica, cujo trabalho é pegar o calor do chip e passar pros canos com a menor resistência possível. E por isso queremos uma pasta de boa qualidade. Você pode economizar onde quiser, menos na pasta térmica. Muita gente recomenda marcas como da Noctua, da Artic e eu escolhi a Thermal Grizzly Kryonaut. Que eu tinha usado já no meu PC e tinha sobrado.








Isso resolve parte do problema. Se você já pesquisou notebooks gamers e ultrabooks de produtividade não sei se já se perguntou porque os gamers como Predators costumam ser maiores e mais grossos do que ultrabooks como um Macbook Air. Porque aplicativos como Word, Excel, e navegadores raramente puxam 100% da CPU e da GPU o tempo todo. Se você abrir o Task Manager do Windows agora, vai ver que fica na faixa de 30% de uso pra menos. A realidade é que no dia a dia você não precisa de muito.









Só quando vai fazer processamento mais pesado, como compilar um programa grande, processar imagens, renderizar video ou jogar games, é que realmente vai puxar a máquina. Ultrabooks evitam colocar GPUs e preferem usar gráfico integrado como o Intel Irix. Fica tudo num chip só, a solução térmica pode ser mais simples, e no caso de um Macbook Air nem coloca ventoinha.








Já um notebook gamer parte do princípio que um dos usos principais vai ser jogar então é mais pesado porque vai ter mais canos de dissipação de calor, os heat pipes e até usar soluções mais agressivas como vapor chambers, que são canos que usam a dinâmica de fluidos internamente pra ajudar na dissipação. É o que videogames novos como o Xbox Series X usa.








Mais do que isso, além de usar pasta térmica, máquinas mais caras e modernas preferem usar metal líquido. Lembram do Exterminador do Futuro 2? É tipo isso, mais parecido em aparência com mercúrio. É altamente condutor de calor mas diferente de pasta normal, também condutor de eletricidade, por isso precisa ficar garantidamente isolado e nunca vazar na placa, porque senão vai dar curto circuito e queimar tudo. Eu mesmo não me animo a arriscar. Mesmo porque não pretendo brincar de overclocking.








Quem monta PCs e faz overclocking se diverte com essas coisas, mas foi só pra mencionar que existem essas coisas. Isso deriva de uma época onde clock, a velocidade da CPU, era fixa. Mas faz anos já que chips como CPU e GPU conseguem se auto-regular. Quando eles vêem que tem pouca demanda, tentam diminuir o clock pra usar menos energia, até o ponto onde o sistema não vai ficar muito lento. E quando começa um processamento maior, tipo renderizar um vídeo, daí aumenta até o máximo e se precisar de mais, ativa modo de Turbo Boost no caso da Intel ou Precision Boost da AMD.








Por isso é difícil comparar máquinas hoje em dia só olhando o gigahertz nominal da CPU. Existe clock base que é o mínimo que o CPU faz, por exemplo 1.5Ghz, existe um intervalo de clocks que ele pode ter, tipo subir pra 2Ghz, pra 3Ghz. E existe Turbo Boost, onde pode ir pra 4 Ghz ou mais. O problema quando entra em Turbo é que vai puxar consideravelmente mais energia, o que é ruim pra bateria num notebook, e é super ruim pra solução térmica. A temperatura que na média fica ali nos 40 graus rápido pode subir pra 90, 100 graus. E quando isso acontecer a CPU vai tentar se proteger.








Mesmo se seu trabalho ainda não tenha terminado, o CPU vai se capar e diminuir drasticamente dos 4Ghz que ele tava de volta pra baixo de 2Ghz. Mais da metade da performance pode ir pro saco até a temperatura voltar ao normal. Isso que chamamos de throttling. O que vai determinar até quanto um chip pode ir é a configuração de TDP que é thermal design power, medido em watts. 








Quanto maior o TDP, mais energia o chip vai receber, mais quente fica. O mesmo processador Intel i5 de fabricantes diferentes de notebook pode sair configurado com TDPs diferentes, dependendo da solução térmica. O problema é que nenhum fabricante quer capar demais os chips pra não parecer que a máquina dele é mais lenta que a do concorrente. Só que se você usa mesmo a máquina pra fazer coisas pesadas, rápido vai chegar no limite térmico e a máquina vai passar mais tempo em throttling do que em turbo boost e no geral você vai sentir a tudo lento, bateria acabando rápido, muito quente, e barulhento com ventoinha sempre ligada no máximo.








Exemplo mais notório eram os Macbooks de 2015 até agora. O design industrial da Apple foi feito pra um certo nível de dissipação térmica. A carcaça de alumínio até ajuda um pouco a dissipar comparado com carcaças de plástico. Mas nos últimos anos todo novo Macbook esquentava pra caramba e fazia throttling o tempo todo, perdendo pra maioria dos concorrentes. Isso porque a Intel vinha prometendo melhorar os chips e nunca conseguiu fazer isso. E a Apple ficou vendida nessas promessas. Por isso ela passou os últimos anos melhorando o próprio chip que vinha usando nos iPhones, até chegar no ponto de inflexão com os A14 bionic, que dá origem ao M1 de hoje.







A Intel usa processo de fabricação de 10 nanômetros, mas isso só a partir de 2018 ou 2019, com a série Cove de processadores, que é o nome das microarquiteturas de 10 nanômetros deles. Palm Cove, Sunny Cove e agora Willow Cove que é a arquitetura dos chips de codenome Ice Lake e Tiger Lake. Você vai reconhecer como os chips da geração 10 e 11, que saiu recentemente.






A gente consumidor, vendo nos sites, só enxerga que existe Core i3 que é considerado o mais fraquinho, Core i5 que povo enxerga como o melhor custo benefício, Core i7 pra quem precisa trabalhar mais pesado e Core i9 que é o top de linha. Mas esses são os nomes de marketing. Um Core i5 atual da décima primeira geração, codenome Tiger Lake, pode ser mais performático do que um Core i7 de 2011, codenome Sandy Bridge. 







Nem vou perder tempo tentando explicar a diferença de i3, i5, i7 e i9. Dentro de uma mesma geração, do i3 ao i9 vai variar preço, lógico. Mas isso porque o i3 vai ser o que tem menor clock, menos quantidade de cores, menos cache - que faz bastante diferença no dia a dia, mas também vai consumir menos energia e ser mais econômico. Daí o i9 no outro extremo vai ser o mais caro, mais bebedor de energia e o mais quente, e por isso você não vai ver em notebooks, mas também vai ter mais cores pra processamento paralelo, e mais cache, com clocks mais altos. Por isso depende do seu uso.







O do meu PC é um i9-9990K, o primeiro 9 é porque é da 9a geração Coffee Lake, ainda usando processo de 14 nanômetros. O modelo é 990 e o K é porque é desbloqueado pra overclocking. O do meu notebook Thinkpad X1 é um i7-8850H, então é 8a geração por acaso também codenome Coffee Lake, modelo 850 e esse H é de High Performance Graphics, porque a GPU integrada da Intel é um pouco melhor do que a média.






A Intel já vinha apanhando por causa da AMD desde quando começou a série Ryzen em 2016. Pra você não se confundir, eles também usam uma nomenclatura parecida de gerações e classes. Um Ryzen 3 é posicionado como concorrente do Intel i3, o Ryzen 5 concorrente do i5 e assim por diante. A primeira geração de 2016 era a série 1000 e hoje estamos na série 5000.







Eu acho que a primeira geração 1000 já era boa mas ainda não era tão ameaçadora pra Intel. Em 2016 ambos ainda usavam processo de fabricação MOSFET e tecnologia de 14 nanômetros. A Intel sempre teve as próprias fábricas, a AMD terceirizava pra GlobalFoundries. A arquitetura da AMD também tem nome, assim como Coffee Lake é o nome da microarquitetura da Intel, o da AMD é o Zen, na época Zen Plus.








Em 2018 a série 2000 da AMD saltou pra 12 nanômetros e a Intel ainda tava em 14. Eles já deviam ter avançado dos 14 e nada. Daí veio a bomba com a geração 3000 em 2019: a AMD se juntou com a fabricante chinesa de semicondutores TSMC que é a mesma que fabrica os chips de iPhone pra Apple. A necessidade de ter fabricantes com pontos fortes diferentes talvez tenha levado ao design de chiplets, um chip composto por chips menores, chiplets, de fabricantes diferentes. Chiplets de 7 nanômetros da TSMC com chiplets de 12 nanômetros da GlobalFoundries. Aqui começou o nocaute na Intel, ainda nos 14 nanômetros.








A série 3000 usa arquitetura Zen 2, que é o que a Sony e a Microsoft escolheram pra montar o novo Playstation 5 e Xbox Series X. A série Ryzen 4000 continua melhorando a arquitetura Zen 2 e a AMD não parou e lançou a arquitetura Zen 3 com a série 5000 em 2020. Enquanto isso a Intel pulou do antigo processo de 14 nanômetros MOSFET, finalmente pra FINFET mas ainda em meros 10 nanômetros.







MOSFET e FINFET são processos de como você monta o transistor no waffle de silício. Povo chama de transistor planar e transistor tridimensional, respectivamente. Pra gente que não é de eletrônica é detalhe demais, mas vou deixar link abaixo pra quem tiver interesse. Importante é entender que FINFET é um processo mais complicado e mais caro. E a Intel demorou pra adaptar as fábricas deles, mas a TSMC de Taiwan já tinha dominado essa tecnologia, porque já faziam chips de iPhone com processo de 5 nanômetros.







Essa é uma das razões de porque o chip M1 da Apple e os Ryzen da AMD consomem menos energia e têm mais performance que o equivalente da Intel. Só em termos de tamanho do transistor, o da Apple é metade do tamanho da Intel. O da AMD é 30% menor. Fora várias outras diferenças de arquitetura como o design mais drástico do M1 ser um SoC que é system on a chip, com memória e GPU tudo integrado pra maximizar a velocidade dos componentes.









A Intel tem pelo menos dois grandes problemas: sendo ela a maior do mercado, se deixou ser ultrapassada pela TSMC chinesa como a melhor fabricante de semicondutores, pelo menos aos olhos do público. Ela inventa uma desculpa atrás da outra faz alguns anos. Na prática faz parecer que quando chegaram nos 14 nanômetros, já dominava no desktop, nos notebooks e nos servidores. Fatia enorme do mercado, e quando tudo tá bom demais, você fica complacente. Porque ir mais rápido se o que já temos é bom o suficiente?






Daí a AMD que parecia estar decaindo deu 180 graus e voltou com tudo. E faz sentido, quando você não tem nada pra perder é quando vai arriscar as melhores idéias. E a parceria com a GlobalFoundries e depois com a TSMC selou o acordo. Eu não conheço a história deles direito, mas se fosse pensar numa hipótese eu diria que isso também foi culpa indireta da própria Intel. Deixa eu explicar.






Quando a Apple tava atrás de fornecedores pros componentes do iPhone antes do lançamento de 2007, eles foram pra Intel, afinal eles tinham acabado de migrar dos processadores PowerPC da IBM pra Intel em 2005. Mas como eu disse, pra um gigante que fornecesse milhões de chips pra data centers e desktops, um mercado de fones, em 2005, era irrisório e eles deixaram passar.






Quem ganhou foi a Samsung que começou a fabricar chips pra iPhone. A Samsung ganhou o know how não só de fazer chips como melhorar as telas que já tinham, antes de começarem a lançar a linha Galaxy. Lógico que depois que o iPhone literalmente explodiu no mundo e os Androids começaram a chegar, a Samsung, que também é uma gigante, não bobeou. Ao mesmo tempo virou concorrente e fornecedor pra Apple. Uma relação bem bizarra mesmo.







Lógico que a Apple precisava de plano B. E foi quando eles começaram a fazer pelo menos os designs dos próprios chips em vez de depender de propriedade intelectual da Samsung. Foi quando saiu o chip A4 em 2010, baseado na licença da ARM Cortex V8. Nesse ponto quem ainda fabricava o chip era a Samsung e ia continuar sendo assim por mais algum tempo.






Nessa época a Apple tava numa boa convergência de boas tecnologias. Se você assistiu meu video sobre Apple e GPL entende que fazia alguns anos que ela vinha melhorando suas tecnologias de compiladores e linguagens. Foi assim que conseguiram migrar de PowerPC pra Intel, foi assim que conseguiram modernizar do Objective-C pra Swift. O investimento em LLVM da Apple ia começar a se pagar.






Entenda. Quando você tem compiladores ruins, muita coisa depende da arquitetura do chip, mais especificamente do conjunto de instruções de baixo nível, porque eventualmente você acaba tendo que escrever trechos em assembler onde o compilador de C ou outra linguagem não consegue cuspir binários otimizados. Mas o LLVM ajudou a dividir os esforços em pesquisa de linguagens e pesquisa de otimização em coisas separadas, e fez cada um dos lados andar bem mais rápido.






Quem pesquisava linguagens não se preocupava como o binário ia ser cuspido, só em criar funcionalidades que facilitem a ergonomia do programador. E quem se preocupava no baixo nível do binário podia se concentrar em otimizar uma única linguagem intermediária que todos usam. Isso facilitou a vida de programadores de Mac pra criar código que funciona tanto nos Macs Intel quanto num iPhone ou iPad.








Do A4 até acho que o A7, a Apple foi refinando o design ARM dela e a fabricação ficou nas mãos da Samsung, mas no A8 de de 2016, que equipou os iPhone 6 e 6 Plus elas migraram pra TSMC, a mesma que faz os Ryzen pra AMD. Mais do que isso, essa era a 2a geração onde os chips da Apple pularam pra 64-bits e pegou todo mundo de surpresa. Em 2015 o mundo ainda tava na vergonha da transição lenta de 32 pra 64-bits e um mísero fone já tinha um chip de 64-bits e muita gente ficou coçando a cabeça, tipo, pra que 64-bits??







Do A7 foram 13 gerações até o atual A14 Bionic. 13 gerações diferentes sendo lançados um atrás do outro no espaço de 5 anos. Nesse meio do caminho o MacOS e o iOS e as ferramentas de desenvolvimento embaixo do XCode foram refinados constantemente. O ritmo deles tava muito bom. O que viria a ser A14X Bionic acabou sendo renomeado e virando o M1 que saiu no fim de 2020 e pegou o mundo de surpresa.







O plano B da Apple foi além, ela desenhou a própria CPU baseada no ARM Cortex e a GPU em PowerVR. E no lado de GPUs a Intel sempre teve a porcaria integrada dela que serve pra mostrar planilha, mas qualquer coisa mais complicada que isso espana. A AMD já tinha GPUs desde a era da ATI e investiu até a arquitetura Vega ficar muito melhor que a da Intel e mais próxima da NVIDIA.







Já que falamos do erro da Intel. Teve uma época que a AMD quase comprou a NVIDIA em vez da ATI, mas parece que o CEO da AMD na época tinha ego grande e o Jenssen da NVIDIA todo mundo sabe que tem um ego grande também daí o negócio não rolou. Imagina que time vermelho e time verde quase estiveram debaixo da mesma bandeira. A NVIDIA era outra empresa pequena que ninguém dava muita bola nos anos 90 e cresceu pro nível de hoje. Agora que vocês entenderam o resumo da história dos CPUs, vamos entender GPUs.








Nos anos 90 a gente tava começando a flertar com 3D no mundo não-profissional. Em tech a gente entendia a revolução da computação gráfica por causa de filmes e games. Isso era começo dos anos 90. Todo mundo ouvia que os efeitos mais sofisticados eram feitos em workstations como da SGI, a poderosa Silicon Graphics. No meio dos anos 90, começando a era de 32-bits com Saturn e Playstation, a gente lia em revistas tipo a Electronic Gaming Monthly que a Nintendo tinha uma parceria com a SGI pra lançar o Project Reality, que era o codinome do Ultra 64 que viria a ser o Nintendo 64.








A SGI ficou mais conhecida no meio dos gamers por causa da empresa Rare da Inglaterra, que tinha feito o inimaginável no fim da era dos 16-bits criando os sprites do jogo Donkey Kong Country usando workstations da SGI. A ideia era pré-renderizar todos os modelos e animações como bitmaps pra colocar no cartucho. Era um conceito ainda pouco explorado na época porque uma workstation Silicon Graphics não era menos que uns 100 mil dólares, em dólares dos anos 90!!








Isso catapultou a Rare pra se tornar um dos nomes mais conhecidos de produtores de games e o Donkey Kong pra se tornar o 3o jogo mais vendido do Super Nintendo, atrás só do Super Mario World e Super Mario All Stars, com o detalhe que ele saiu quase no fim da era de 16-bits, quando consoles de 32-bits como 3DO já tinham saído e Sega Saturn ia sair no mesmo ano. O Donkey Kong tinha gráficos que ninguém nunca tinha visto antes num videogame.








A Nintendo não foi boba nem nada e trouxe a Rare pra junto pra ajudar a hypar o Ultra 64. Eles fizeram jogos pra arcade como Cruisin' USA e Killer Instinct. Mesma estratégia, não eram jogos totalmente em 3D como num Playstation e sim um híbrido. Mesma estratégia do Donkey Kong: pré-renderizar num Silicon Graphics e importar os sprites bitmaps no jogo pra dar impressão de 3D. Aí os gráficos ficavam impressionantes.








Quando Donkey Kong Country e Killer Instinct saíram, era fim de 1994. Virtua Racing, Virtua Fighter da Sega e Ridge Racer da Namco tinham acabado de sair em 92 e 93. Nessa época eles sabiam fazer polígonos mas sem texturas. A Namco começou a usar textura, depois o Virtua Fighter 2, e isso em hardware de arcade que era muito mais caro e mais potente. Num Sega Saturn os gráficos em 3D com texturas ainda tinham resolução muito baixa. 







No horizonte tava o Playstation, mas com a propaganda e vendo no arcade o Killer Instinct, a gente chegava a acreditar que o Nintendo 64 podia ter níveis de Toy Story. Óbvio que a realidade foi bem menos do que o esperado. Tecnicamente o Nintendo 64 era melhor que o Playstation, mas ele escolheu usar cartuchos em vez de CD, então tinha bem menos espaço e era bem mais caro ter texturas, que ocupam muito espaço. Video então nem se fala. Por isso jogos de Nintendo 64 tem aparência mais pobre mesmo conseguindo ter mais resolução do que o Playstation. 






Essa história é pra outro dia, o importante é entender o seguinte: a era 32-bits ia ser marcada por chips 3D. Em 92 esse movimento começou nos arcades. E pra fazer 3D rudimentar naquela época não tinha aplicativos de modelagem sofisticados nem nada, os modelos em 3D eram simples porque alguns eram desenhados na mão, vértice a vértice ajustando os números na munheca. Já existia CAD mas nada perto de 3D Max ou Maya.







O que a Rare fez com Donkey Kong ou Killer Instinct foi modelar e animar num Silicon Graphics de 100 mil dólares. Cada quadro de animação podia levar de segundos a minutos ou mais pra renderizar dependendo da complexidade. Não era em tempo real. Mas aí a demanda pra fazer 3D começou a aumentar porque filmes e games trouxeram essa possibilidade pra imaginação dos consumidores, então todo mundo que queria parecer moderno precisava ter alguma coisa em 3D. Music videos, comerciais, propaganda e tudo mais.









Nesse momento a gente já tinha passado pela revolução dos microcomputadores de 8-bits dos anos 70 até começo dos 80, os Apple II, Sinclair e a IBM entrou no páreo e revolucionou o mercado padronizando e abrindo a especificação das máquinas, assim qualquer empresa podia montar máquinas compatíveis com IBM PCs. A era dos 16-bits foi dos PCs. Mas nos micros a gente podia ligar em TVs analógicas, aquelas caixas com tubos enormes. E mesmo a resolução sendo uma droga, a qualidade de imagem sendo terrível, a gente tinha cores.






Os IBM PCs originais se tornaram famosos por trazer os monitores monocromáticos de fósforo verde ou âmbar da era dos terminais de mainframe que gigantes como a NEC, Burroughs ou a própria IBM fabricavam. Então PC e monitor monocromático era meio que a imagem padrão de uma máquina de trabalho. Bem o tipo que a gente via em bancos. Quem trabalha não precisa de cores. Uma cor é mais que suficiente.







Nem todo mundo achava isso e outros mercados de nicho já começaram a crescer, embora eu não tivesse acesso na época. Militares ou agências como a NASA, indústria em geral, empresas de engenharia tanto civil ou mecatrônica queriam dar um jeito de usar esse troço novo chamado microcomputador pra acelerar pesquisas, designs, projetos e tudo mais. Em particular programas de simulação e CAD começaram a aparecer. Mas os PCs do começo dos anos 80 ainda não eram suficientes.








A Intel daquela época e seus concorrentes como a Cirrus passaram a construir chips pra acelerar cálculos mais complexos. Números inteiros pequenos não eram suficientes, porque design e simulação precisavam de pontos flutuantes, números quebrados, e muitos deles. Pra isso surgiram os co-processadores matemáticos como o 80387. Naquela época processadores tinham funções simples, que recebiam um ou dois números e calculavam algum outro. Pensa tipo ADD de soma ou MUL de multiplicação e com esses co-processadores você ganhava instruções como FADD ou FMUL pra lidar com floats. 






Em paralelo a isso, surgiram empresas como a ATI ou mesmo a gigante NEC do Japão pesquisando o próximo passo: monitores verdes são chatos, precisamos de mais cor, de mais resolução. Um consórcio chamado de VESA foi criado, a Video Electronics Standards Association. A ATI, ou Array Technologies Inc, foi um dos fundadores desse consórcio que servia pra especificar e padronizar componentes de monitores e gráficos. Hoje você associa o nome VESA ao padrão de parafusos atrás do monitor pra pendurar na parede, por exemplo, mas esse é só um dos padrões da VESA.








Com o consórcio formado, o interesse do mercado aparecendo, era hora de vitaminar os PCs verdes e aí foi surgindo o padrão CGA de 4 cores, que eu recomendo que você veja o video no canal do The 8-Bit Guy pra entender como funcionava. Depois veio o padrão EGA de 16-cores que eu mesmo não cheguei a ver na minha época e finalmente o supra sumo que tava na lista de coisas que eu mais queria em 1990: um monitor VGA colorido de 800 por 600 pixels e 256 cores!







Lembrem-se, micros antigos e videogames ainda estavam na faixa de resolução de 320 por 240 pixels, mesmo os da era de 32-bits como Playstation, eram só 256 por 224 pixels. Da geração de 8-bits até 32-bits de consoles, aumentou cores, aumentou recursos, mas a resolução não era muito mais que isso, principalmente porque numa TV normal de tubo, da época, não adiantava ir muito mais por causa do padrão NTSC ou PAL de TV.







Aliás, tentar entender os padrões antigos de TV analógica é um exercício de frustração. Porque a quantidade de frames por segundo é o número bizarro 29.97 quadros! Nem vou tentar explicar mas recomendo dar uma pesquisada pra entender sobre NTSC e PAL. O que você talvez não lembre é que o nintendinho de 8-bits e o Super Nintendo de 16-bits tinham a mesma resolução: 256 colunas por 240 linhas.







240 linhas é pouca coisa a mais que as 192 linhas horizontais do antigo Atari 2600. Um Playstation já suportava alguns modos a mais de resolução mas o normal dele era 256 por 224, menos linhas que um Super Nintendo. Ele tinha um modo mais esticado de 640 por 240 linhas e modo entrelaçado que dava pra ir até 640 por 480.







Pensa assim. Hoje você usa um monitor que a gente chama de Full HD, que tem 1080 linhas. HD são 720 linhas. E antes das telas planas tinha 480p que é progressivo, ou seja, cada quadro tem 480 linhas. Tinha 480i que é interlaced ou entrelaçado. Em modo entrelaçado você faz quadros com 240 linhas, mas um deles preenche as linhas pares e no quadro seguinte as linhas ímpares. Se você projetar elas rápido, na animação parece que tem 480 linhas, mas na verdade só tem metade. A vantagem era poder renderizar só metade do quadro de cada vez, a desvantagem é que em animações muito rápidas você ia ter um shimmer, dava pra ver os quadros desalinhando entre as linhas.







Mas esse era o modo máximo do primeiro Playstation. Não dava pra mostrar muito mais que isso numa TV comum. O conceito de HD, ou High Definition, que é só 720p, ainda não tinha aparecido pra gente. Mas em monitores de computador depois de 480 linhas já fomos pra 600 e até 1024 linhas bem rápido até. Nos anos 90 a gente já tinha quase o equivalente horizontal do Full HD de hoje, só que em formato mais quadrado de 4 por 3 de proporção, que era o comum. Wide screen ainda não era conhecido.







De qualquer forma, no mundo doméstico foi no começo dos anos 90 que começamos a entrar na era da multimídia, mas no mundo dos workstations como os IRIS da Silicon Graphics, custando dezenas de milhares de dólares, estava outro mercado de nicho que tinha empresas mais novas como a Sun Microsystems e a própria Microsoft querendo um pedaço. A SGI demorou muito pra se reinventar depois dos anos 80. Empresas como SGI e Sun, e a NEXT que o Steve Jobs fundou depois de sair da Apple em 1985, pensavam em workstations meio como a antiga IBM pensava em mainframes: como um conjunto único de hardware e software que eles precisavam controlar tudo. 







Eu acho que a Apple é a única empresa que sobrou com essa filosofia ainda. Mas elas sofreram com o advento do PC porque em vez de ter que escolher um sistema inteiro proprietário de processadores, placas gráficas, monitores, sistemas operacionais, era mais acessível pegar pedaços de cada coisa separado de diversos fabricantes. Era mais difícil de montar e configurar tudo, mas o custo compensava. Processador da Intel, placa gráfica da Trident, MS-DOS ou OS/2 ou depois Windows e ir montando assim. 







Eu não participei desse mercado de workstations então só sei o que ouvi falar, mas a SGI ia implodir sozinha depois de ter trabalhado no projeto do processador do Nintendo 64. Nessa época, do começo pro meio dos anos 90, empresas como a ATI já tinham entrado no mercado gráfico, ajudado a definir padrões da indústria pra coisas como monitor e tava começando a fabricar placas aceleradoras de 2D. Uma das famosas era a S3, acho que da VIA, e alguns já explorando a ideia de placas 3D.







Quem ia despontar do nada foi uma empresa que começou fazendo arcades, a 3DFx. A época era 1995, com Playstation, Nintendo 64 e o pobre Sega Saturn iniciando a era de 3D nos videogames. A Microsoft comprou uma empresa chamada RenderMorphics pra ter a tecnologia que viria a ser a base pro Direct3D. A Id Software, depois do sucesso absurdo do primeiro Doom tava criando uma engine 3D pra tirar o máximo dos Pentiums da época e suas instruções MMX. E a 3DFx trouxe a placa aceleradora Voodoo. Mais importante, trouxe a API Glide, um conjunto de instruções pra tirar proveito dessa placa 3D.








A 3DFx focou pesado em 3D. Naquela época o Windows ainda não era unanimidade, maioria dos games era lançado pra DOS, usando extensões como o 4Dos, a Microsoft tava atrasada pra entrar no vagão de 3D e a 3DFx tomou a dianteira com um conjunto de APIs mais fácil de programar. Mais importante: ela conseguiu conquistar ninguém menos que o lendário John Carmack e o Quake se tornou o killer app pra placas Voodoo. Sim, dava pra rodar só usando CPU Pentium porque o Carmack é um gênio, mas se ligasse no driver Glide com uma placa Voodoo o jogo ficava infinitamente mais bonito.







Mas a 3DFx foi o famoso caso da startup inovadora que cresceu super rápido e no seu pico começou a tomar decisões erradas, a prometer demais e entregar de menos, tentou mudar o business model e no final os concorrentes começaram a chegar. 







Tinha vários fabricantes de placas competindo como a Matrox com a Mystique, a Cirrus Logic, as Rage da ATI, as TNT da NVIDIA. Assim como hoje havia várias OEMs. Por exemplo, pra comprar uma placa NVIDIA hoje, tipo minha RTX 3080, você escolhe OEMs como a EVGA, Gainward, Asus e outros. Em vez de comprar direto da NVIDIA, você vai num integrador. Minha RTX 3080 é da Gainward. É como nos computadores, onde você pode até comprar chips direto da Intel porque hoje ela é grande, mas normalmente você compra um computador de um OEM integrador como Dell ou HP ou Acer.







E naquela época tinha vários OEMs diferentes que você não ouve mais falar como a Diamond que vendia em nome da 3DFx. E um dos erros da 3DFx foi tentar cortar o intermediário e vender direto. Só que naquela época não tinha capilaridade de e-commerce e marketplace. A Internet tava só começando. Não existia nem Google nem Amazon ainda. 







A Microsoft acelerou o Direct3D. Windows 95 foi um estrondoso sucesso e todo mundo ia querer jogos pra ele. A Voodoo 2 ainda era a mais performática, mas os concorrentes como a ATI e NVIDIA foram fechando a distância pouco a pouco. Some a isso as diversas decisões erradas e a 3DFx ia tomar o caminho da SGI. No fim dos anos 90 ambos iam desaparecer.






Se você quiser jogar jogos dos anos 90, que você pode baixar ou da Steam ou do GOG e rodar num DOXBox da vida, provavelmente vai precisar de um emulador do driver Glide. No caso de plataforma como a Steam, o jogo já vem com o DOSBox e os drivers todos. Nos anos 90 a 3DFx processava qualquer um que tentasse emular seus drivers, mas quando tava pra fechar eles resolveram abrir suas APIs como código aberto. E por isso hoje você tem projetos que traduzem as chamadas proprietárias da Glide pra outra biblioteca como DirectX.







A mesma coisa aconteceu com a SGI. Em Tech a gente sempre ouvia falar das workstation Silicon Graphics rodando sistema operacional UNIX que era o Irix e as APIs de programação pra 3D que era o IrisGL ou Integrated Raster Imaging System Graphics Language, que é mais uma abreviação inventada só pra formar a palavra Iris, claro. Mas o GL você já viu em outro lugar. O IRIS GL era a API proprietária da Silicon Graphics e um belo dia eles refatoraram essa API pra tirar coisas proprietárias e lançaram como um padrão aberto, a OpenGL. 







A Glide acabou no passado e só existe hoje no mundo dos retrogames. E acredite, são muitas dezenas de games que suportavam Glide. Desde os Quakes e Unreal originais, FIFA, Need for Speed, Mechwarrior, vários jogos clássicos de Star Wars como X-Wing vs Tie Fighter. Todo jogo que não foi portado pra APIs mais modernas num remaster da vida, ainda roda emulando Glide. Depois de 1999 praticamente só sobrou DirectX e OpenGL e a era do dueto NVIDIA vs ATI.







A gente entrou no Século XXI com a ATI Radeon DDR vs a NVIDIA GeForce 2 GTS. As outras foram aos poucos desaparecendo, a VIA, Matrox, Cirrus. Eu lembro do começo dos anos 2000 ser bem pouco empolgante, em parte porque quase todos os concorrentes foram sumindo, em outra parte porque eu tava trabalhando pra caramba e sem tempo pra jogar. Mas o mundo dos games continuou crescendo. Foi o começo da era dos e-sports com Starcraft, o Counter Striker original, Unreal Tournament, Quake III. 







Quando Jobs voltou pra Apple em 1997 e trouxe o know how da NEXT e tecnologias de workstation pros novos iMacs, ele também ajudou a empurrar a era de usar 3D nas interfaces gráficas de todo desktop com o framework Aqua, acelerado por placa gráfica. No mundo Linux a gente queria a mesma coisa e começou a ideia de compositors como o compiz. No mundo Microsoft eles tentaram o Aero Glass. Apple e mundo Linux começaram a adotar OpenGL nos sistemas operacionais. Microsoft obviamente continuou evoluindo, portando as coisas da antiga API de bitmaps GDI pra DirectX, e isso ia levar muitos anos. E fabricantes de placas como ATI e NVIDIA um funcionava melhor com OpenGL, outro com DirectX e ficava nessa disputa.







Eles foram tentando algumas coisas que não deu certo no mercado como o CrossFire da ATI e SLI da NVIDIA pra rodar mais de uma GPU na mesma máquina. Mas isso nunca foi estável e nem pegou muita tração. Ainda bem que já desistiram dessa ideia. Mas uma que pegou foi no lançamento da GeForce 3 que passou a suportar Pixel Shaders. Isso já existia no mundo das workstations mais caras, mas no mundo consumidor comum ainda era super novidade.






Falando bem a grosso modo, pensa em shaders como um filtro de Instagram ou plugins de Photoshop. Você parte de uma imagem e aplica um filtro pra dar blur. Ou pra mudar a cor. Ou pra criar efeitos. O termo shader nasceu na Pixar, na especificação do Renderman, o pai de todo software de modelagem e animação 3D como o Blender ou Cinema4D. Ed Catmull e os programadores originais da LucasArts que depois virou Pixar criaram toda a fundação da computação gráfica moderna. As estruturas de dados, os algoritmos, os workflows, tudo. E acho que shaders foi uma dessas coisas.






Eu não sou profissional dessa área mas resumindo você tem pixel shaders, como cel shading por exemplo, que a gente viu pela primeira vez em jogos como Jet Set Radio, que faz um modelo 3D ficar parecendo um desenho em 2D e você vê até hoje em jogos como Guilty Gear da Arc Software, pra mim a empresa que melhor domina essa técnica. Mas assim como Photoshop, você tem todo tipo de shader que é aplicado e transforma pixel a pixel de uma imagem.





Daí existem shaders 3D como os vertex shaders. Vertex ou vértice é uma estrutura de dados que contém metadados espaciais, posição, cor e muito mais. Todo mundo já viu um modelo 3D em wireframe, pense em vértices como cada um dos traços que monta o mesh do modelo. Um triângulo, por exemplo, tem 3 vértices e cada vértice é uma estrutura de dados. E em cima de cada vértice podemos aplicar filtros pra transformar esses vértices, os vertex shaders. O Hello World de vertex shader é o Gouraud shader, que é um método de interpolação.






Em poucas palavras você consegue pegar um modelo com poucos polígonos e ficaria aquele aspecto quadradão e aplicando esse shader ele alisa o shading e faz parecer contínuo, sem quebras bruscas, como se o modelo originalmente tivesse bem mais polígonos do que realmente tem. Então a gente consegue criar modelos menos quadrados sem aumentar a quantidade de polígonos, aplicando esse filtro em cada vértice. É uma das centenas de técnicas pra economizar processamento e ainda assim conseguir boa qualidade final.







Fora vertex shaders tem tesselation shader, geometry shader, primitive e mesh shaders e agora ray tracing shaders. Esses shaders são programas, código mesmo, e você escreve em linguagens parecidas com C como GLSL pra OpenGL ou HLSL pra DirectX, mas não é só isso. Você acha chato que hoje existe um monte de linguagens como Java, Python, Javascript, Rust, e por aí vai? Bom, existem diversas linguagens pra shaders também. A Apple tem o Metal Shading Language ou MSL, a Sony tem o PSSL que é o Playstation Shader Language, compatível com o HSLS da Microsoft. Isso no mundo de tempo real, pra renderização offline, tem o Gelato e o VEX da Houdini que se inspiram no original do Renderman da Pixar.








E existem vários tradutores de uma linguagem pra outra, tipo transpilers mesmo. Todos eles são parecidos com C ou C++. A Apple usa Clang do LLVM pra compilar o Metal Shading Language, que é baseado em C++14. Por isso é mais fácil usar ferramentas como Unity ou Unreal Engine. Porque eles vem com um editor visual de shaders baseados em Nodes. Se você já usou o sistema de Nodes de material do Blender ou o de Nodes de colorização do DaVinci Resolve, é parecido. Você vai montando visualmente uma árvore que depois é compilada num shader, sem precisar escrever uma linha de código.







Mas o importante é entender que shaders são aplicados per pixel ou per vertex. Pensa um jogo moderno rodando em Full HD, ou seja, 1920 por 1080 pixels. Um Pixel shader vai rodar nos 1920 vezes 1080 ou seja mais de 2 milhões de pixels. Pelo menos 30 a 60 vezes por segundo. Então com a GeForce 3 em diante as GPUs ficaram velozes ao ponto de processar 2 milhões de pixels num shader em menos de 16 milissegundos por frame, até menos que isso porque nesse tempo pode ser processado múltiplos shaders.







Calcular o shader pra cada pixel é uma tarefa altamente paralelizável e é isso que faz uma GPU. Em vez de poucos cores ou núcleros muito rápidos, como 4 cores de 4Ghz num Intel i5. Uma GPU como minha RTX 3080 vai rodar entre 1.4 a 1.7 Ghz. Parece pouco comparado com minha CPU i9 de 8 cores que pode ir até perto de 5Ghz cada um. Só que essa RTX tem quase 9 mil shading units, micro-cores pra rodar shaders. Basta eu quebrar minha imagem de 2 milhões de pixels em batches pra dividir pros 9 mil shading units.






Processar pixels e processar vértices é algo facilmente paralelizável, porque eu posso rodar o shader pra cada pixel individualmente em paralelo, sem precisar esperar. Numa CPU Intel com 8 cores eu quebraria os 2 milhões de pixels em 8 batches de 250 mil pixels cada. Ia levar ordens de grandeza mais tempo pra processar tudo. CPUs são boas pra processar linearmente, trabalhos grandes sem parar. GPUs são boas pra processar milhares de pequenos trabalhos em paralelo. Por isso elas se complementam. Nem todo trabalho dá pra ser paralelizado.








Quando DirectX chegou lá pra versão 10 e a NVIDIA lançou a GTX 280 eles já estavam começando a empurrar outro conceito. Em vez de chamar as coisas de shaders e os cores de shading unit, começaram a falar mais sobre unificação dos shaders e o conceito de GPGPU ou GPU de uso geral. Fica confuso porque em vez de falar de pixels ou vértices a gente passa a falar em stream de dados, uma corrente contínua de estruturas como pixels ou qualquer coisa que vai passar por esse monte de unidades de processamento, que antes era shading unit e agora, no caso da NVIDIA, chama de CUDA Cores ou, no caso da AMD, de Stream Cores. E em vez de passar por um programa pixel shader ou vertex shader, o nome mais moderno é compute kernels ou só kernels.








Pensa hoje numa CPU normal. Se você tem um arquivão gigante pra processar, por exemplo fazer limpeza removendo ou adicionando caracteres em cada linha. Você abre o arquivo e faz um loop pra ler linha a linha. E dentro do loop `while` ou `for` vai ter um código pra manipular o string. O programa de um shader ou kernel é só o que vai dentro desse `for`. Você não controla o loop, quem controla é a GPU. Você só fala "tó o arquivão, e toma o código, se vira", ele vai jogar cada linha num CUDA core e seu kernel vai processar a linha que receber naquela core. Até pouco tempo atrás a linguagem de kernels ou shaders não tinha nem condicionais como `if-else`.








Daí você tem funções gerais da GPU como os famosos `map` e `reduce` derivadas de linguagens funcionais. Com `map` você diz qual shader rodar pra cada input num core e `reduce` pra agregar o resultado de um batch de processamento num stream menor. Tem scan filter pra remover alguns resultados. Tem scatter, gather - que é o inverso -, sort, search. Mas no final são técnicas de pixel e vertex shaders com nomes mais atraente pro povo acadêmico de computação.







Quem pesquisava computação distribuída e paralela, cientistas de dados, povo que já usava coisas como Fortran entenderam que dava pra usar a GPU pra programar essas tarefas matemáticas paralelizáveis pra coisas como machine learning, por exemplo. A NVIDIA enxergou o caso de uso e tornou as APIs mais amigáveis pra aplicações fora do mercado de gráficos e games. Hoje você vai achar extensões pra várias linguagens, de C a Fortran, pra dar acesso a criar kernels e rodar nos CUDA Cores.






Como tudo em computação, sempre tem o jeito do fabricante e o jeito mais compatível com todas as alternativas. Você pode baixar as bibliotecas de CUDA da NVIDIA se tiver uma placa GeForce. Mas se quiser ser compatível com as Radeon da AMD talvez prefira usar um framework como OpenCL pra desenvolver kernels que podem ser compilados pra shaders pra ambos.






Por muito tempo a Apple desenvolvia a parte gráfica com OpenGL e depois a parte computacional pra GPU com OpenCL. Programas como Blender pra modelagem 3D permitem escolher interfacear com OpenCL ou direto CUDA, assim como num game você podia escolher usar os drivers de Glide, DirectX ou OpenGL.






Em 2014 a Apple começou a mudar a estratégia. O problema é que depois de quase duas décadas, plataformas como OpenGL e DirectX cresceram muito em escopo, ficaram bloated mesmo. Eles não são só interfaces pra falar com a GPU, elas controlam muito mais, o estado da renderização, a configuração dos pipelines. É como um framework web que cresceu demais e agora é pesado pra fazer sites pequenos. É o destino de todo software que faz sucesso e dura tempo demais.






Como as tecnologias de compiladores melhoraram drasticamente graças ao LLVM e compiladores como Clang, a Apple resolveu tirar o intermediário do caminho e criou uma API moderna, orientada a objetos, que é mais baixo nível e, mais importante, usa muito menos recursos do que OpenGL. Esse é o Metal. Você precisa entender um pouco mais sobre shaders, pipelines, mas a grande vantagem é que em Macs e iOS a performance é nitidamente maior tirando OpenGL e OpenCL da jogada.







Do lado de fora da Apple também tivemos mudança semelhante. Surgiu a API Vulkan, do grupo Khronos, dois anos depois, em 2016. Ele parece ser um pouco mais baixo nível até do que o Metal da Apple, também com objetivo de usar menos recursos quanto possível pra ser performático e diferente da Apple tem objetivo de ser independente de plataforma pra poder rodar em Android e qualquer coisa com uma GPU.






Pra ilustrar pense assim. Você é um desenvolvedor de jogos ou qualquer aplicativo gráfico, tipo um Photoshop. Se programar direto pros drivers da NVIDIA ou AMD, vai ficar bloqueado em um ou outro. Se usar Metal só vai rodar só em Mac e iOS. Se usar DirectX vai rodar só em Windows e XBox. Agora você tem algumas alternativas.







Num mundo ideal você vai programar usando as APIs do Vulkan. Daí pode usar um projeto com o MoltenVK que facilita compilar pras chamadas do Vulkan chamarem o Metal e converter a linguagem intermediária de shaders do Vulkan, o SPIR-V pro MSL que é o Metal Shading Language.






Se for um aplicativo que já existe escrito em GLSL de OpenGL dá pra usar o projeto Angle do Google, o Almost Native Graphics Layer Engine que traduz OpenGL pra Vulkan e outros backends. Tem um projeto ainda inacabado que é um fork desse Angle, o MetalAngle que adiciona backend de Metal. Ele suporta fazer aplicativos antigos escritos em OpenGL ES - que é um sub-conjunto menor do OpenGL) pra rodar em Metal sem alterar muita coisa, porque vai traduzir chamadas de OpenGL em chamadas de Metal.






E finalmente se for um aplicativo que já existe escrito em DirectX 9 a 11, dá pra usar o DXVK que traduz chamadas de DirectX pra chamadas de Vulkan. A própria Microsoft tava atenta a essas mudanças e por isso o DirectX 12 tenta ser uma alternativa um pouco menos pesada e mais perto do metal. DirectX é uma API mais madura, menos difícil de aprender e usar do que Vulkan, que é um pouco mais baixo nível.






Se não tá claro, um OpenGL é como se fosse Java. Antigo, estável mas pesado. Metal é como se fosse Objective-C ou Swift mesmo, mais baixo nível, mais leve. Um DirectX até o 11 é como se fosse C#, mais fácil de usar, mais estável mas mais pesado. Vulkan é como se fosse C++. E o DirectX 12 é como se eles pulassem de C# pra C++ também. É meio que o caminho inverso de sair de uma plataforma de mais alto nível pra ficar no baixo nível.




Mas isso é no nível das APIs, ainda tem os shaders. Shaders pra OpenGL são escritos numa linguagem de mais alto nível (pensa um Javascript) que é GLSL. Em DirectX é o HLSL, também de mais alto nível. A sigla HLSL justamente é High Level Shading Language. O DirectX compila o HLSL em um bytecode intermediário - tipo bytecodes de Java - que é DXBC ou DirectX ByteCode. Já o Vulkan lida com binários intermediários um pouco maiores e com mais metadados, que é o SPIR-V, foi originalmente feito pra OpenCL.






Se você já se aventurou em rodar um emulador de Wii U como Citra ou mesmo rodar Steam no Linux como eu mostrei no começo, já deve ter esbarrado ou com stutters, engasgadas ao jogar. Ou da primeira vez teve que esperar uma hora compilar “shaders de Vulkan”, e agora você sabe porque.






O esquema de shader do OpenGL era chatinho porque os shaders eram entregues em formato texto, daí cada driver de OpenGL precisava embutir literalmente um compilador pra compilar o shader antes de mandar pra GPU. Já drivers de DirectX e Vulkan usam um JIT, ou just in time compiler, que pega esse bytecode intermediário e transforma no binário final pra GPU, que é um passo menos complexo do que um compilador inteiro.






Quando você roda Steam no Linux usando a camada Proton - que já vou explicar - ele provavelmente vai usar o driver de Vulkan pra falar com a GPU. Mas a maioria dos jogos de PC ainda dependem do DirectX. Então ele usa o projeto DXVK pra converter chamadas de DirectX ou DX pra Vulkan ou VK, por isso chama DXVK. Mas ainda tem os shaders em DXBC. Antes de mandar pro Vulkan, o DXVK vai converter o bytecode de DXBC em SPIR-V e por isso ou o jovo vai ficar dando travadinhas no começo, que é quando os shaders são convertidos em tempo real ou, o jeito mais prático, o jogo vai primeiro checar se tem os shaders de Vulkan no cache. Se não tiver, vai converter todos antes de abrir o jogo justamente pra não ficar travando. E agora você sabe porque isso existe.








Por muitos anos em PC a preferência era fazer jogos usando DirectX, primeiro porque é mais conveniente porque em Windows todo mundo vai ter instalado. Segundo porque era mais moderno, mais fácil de aprender e com mais suporte de documentação, ferramentas e tudo mais comparado a OpenGL que a essa altura praticamente só a Apple usava. Mesmo assim, se você quisesse fazer um aplicativo ou jogo que funcionasse em tudo, era melhor escolher OpenGL, ou se tivesse grana, implementar e dar suporte pros dois.






Mas aí a Apple quebrou as pernas do povo de OpenGL migrando pra Metal. E o Vulkan quebrou o resto das pernas oferecendo um padrão melhor e com mais suporte. A Microsoft foi o marido traído e correu pra entregar o DirectX 12 como alternativa, se o problema fosse só performance. Com o Vulkan ficando mais estável e completo eles querem criar uma Meta API que vai servir pra escrever tanto pra Vulkan quanto suportar Metal e DirectX por baixo. Ou seja, a API que vai unificar todas as APIs.







Na verdade, a história toda é mais ou menos assim. Lá em 2009 quando o grupo Khronos tava estudando como trazer 3D nativo pra navegadores com a ajuda da própria Apple, Google, Mozilla e Opera, eles tavam chegando no WebGPU que ia usar OpenGL em Macs e Linux e DirectX no Windows. Chamadas de WebGL seriam convertidas pra equivalente em DirectX e transpilers seriam usados pra converter os shaders GLSL em HLSL. Não sei se foi aí que nasceu o projeto Angle do Google que funciona hoje pra Chrome e Firefox pra justamente isso.







O problema é que drivers OpenGL pra Mac e Linux eram muito ruins. Um dos muitos problemas foi o que falei do GLSL, que os drivers já não eram grande coisa, cheio de bugs, e com GLSL precisava ainda ter um compilador embutido. Imagina a complexidade e tanto de bugs pra manter tudo isso com pouca gente. DirectX 10 tava muito na frente tanto em estabilidade quanto facilidade de uso. Por isso todo mundo programava jogos só pra DirectX e raramente você via jogos em OpenGL bons pra Mac.






Aí em 2013 a AMD desenvolveu uma API de mais baixo nível chamada Mantle como alternativa pra DirectX e OpenGL e doaram a implementação pra Khronos que usou de base pra fazer o Vulkan. Depois, com o Metal funcionando melhor que OpenGL em MacOS e iOS e o Vulkan funcionando bem em Linux e Windows, dá pra voltar pra ideia do antigo projeto WebGPU: tirar OpenGL e DirectX dos planos e mirar em suportar Metal e Vulkan.







A ideia é que WebGPU vire uma API única que vai facilitar a vida de pequenos programadores independentes, estúdios de games que queiram fazer aplicativos e jogos pra todas as plataformas com uma API única. Ainda não estamos lá, mas enquanto isso pra WebGL existe o projeto Angle e o MetalAngle, e obviamente as engines de jogos como Unity e Unreal que dão suporte a todas as plataformas. 







Aliás, a reunião da Khronos que iniciou os trabalhos pro Vulkan foi nos escritórios da Valve. Ninguém tem mais interesse em aumentar o mercado, fazendo o Steam e todos os jogos saírem das porteiras do Windows, do que a Valve. O projeto Vulkan possibilita fazer uma coisa que a comunidade open source vem tentando faz anos: conseguir rodar DirectX. O problema é que DirectX é gigante, não é fácil de reimplementar via engenharia reversa e muito menos com performance. 





Quem é de Linux conhece o projeto Wine, sigla pra Wine is not an Emulator. A ideia em si é simples: vamos pegar um programa de Windows, digamos Notepad. Quando ele pedir pro Windows pra desenhar uma janela, a gente intercepta essa chamada, e traduz no equivalente no Linux. E vai fazendo isso chamada a chamada até o programa acreditar que tá rodando no Windows. Essa ideia começou nos anos 90 e continua até hoje e o objetivo era um dia poder fazer o Linux substituir o Windows como sistema operacional, porque o maior motivo que bloqueia as pessoas de saírem do Windows é que nenhum programa que eles precisam existe lá.








Quando Java saiu o mundo achava que todo mundo ia escrever tudo em Java e isso resolveria o problema. Ficou só na intenção mesmo porque não dá pra escrever tudo numa linguagem só. Java era boa pra algumas coisas, mas péssima pra outras. Ela é basicamente uma máquina virtual, então desperdiça tudo que o sistema operacional já faz e tem muita redundância. Antes que alguém diga que Android é em Java, não é. A sintaxe da linguagem é derivada de Java, mas depois de gerar bytecodes o Dalvik usa um compilador pra gerar binário nativo. Então não roda numa Java Virtual Machine. Ela só se aproveita do ferramental de Java pra desenvolver.






Não tem jeito, pra aplicativos e jogos precisa ser perto do metal. Mas traduzir o Windows inteiro é inviável. Exigiria milhões de horas homem e não ia resolver porque a Microsoft não tá parada  esperando, todo dia sai uma atualização nova pra Windows que muda alguma coisa. É uma corrida infinita de gato e rato.








Em 2018 só tem duas alternativas: rodar o Windows inteiro de verdade numa máquina virtual e passar a GPU da máquina de verdade pra dentro da máquina virtual. Mas isso não resolve também. Como é o Windows de verdade, você precisa pagar licença pra Microsoft. E mesmo em 2018, mesmo Wine tendo avançado bastante e conseguir rodar alguns aplicativos mais de versões mais velhas, jogos é complicado porque DirectX é um dos componentes mais complexos do Windows.







Mas com o Vulkan funcionando bem e agora tendo um framework gráfico decente pra todas as placas, isso começou a dar idéias pra alguns programadores. Assim como na história da 3DFx, o primeiro passo é ter APIs decentes, melhores que a antiga OpenGL. Primeiro surgiu um projeto chamado VK9 com o objetivo de traduzir chamadas de DirectX 9 pra Vulkan. 






Inspirado nisso outro programador, Philip Rebohle desenvolveu o DXVK que traduz chamadas de Direct 9 até 11. E quando ele anunciou que o projeto dele já permitia rodar o jogo Nier Automata, a Valve entrou em contato e contratou ele. Isso foi Janeiro de 2018. Construir um DirectX em código aberto do zero era muito difícil, mas fazer só uma casca que é só um adaptador da API do DirectX pra API do Vulkan, era bem mais possível.







Agora a Valve tinha as peças que precisava: Wine quase funcionando pro básico, Vulkan como driver de alta performance pra GPU no Linux e Windows, e o DXVK como camada de tradução que realmente funciona. Com isso eles começaram o projeto Steam Play e o projeto Proton. O Proton é um fork do Wine com diversos patches pra melhorar compatibilidade particularmente com jogos, e vários ajustes de qualidade de vida, modo tela cheia que funciona direito e patches específicos pra ajustar jogo por jogo.







E foi assim, nos últimos 2 anos eles trabalharam bastante. E finalmente temos jogos de Windows novos rodando em Linux quase com a mesma performance e até melhor em alguns casos. E outros desenvolvedores entraram na festa, surgiram forks de Proton e um dos mais famosos é o Proton GE do desenvolvedor Glorious Eggroll que customiza o Proton da Valve pra funcionar ainda melhor, corrige bugs, adiciona patches pra mais jogos e por aí vai.








Mas a novela não acabou. A NVIDIA é notória e reconhecida como não sendo muito legal com a comunidade. O suporte no Windows hoje até que é de boa, dá pau de vez em quando mas menos que antigamente. Mas em Linux ainda é um pé no saco. Em Linux temos o projeto Mesa que é o driver pra placa de video integrada da Intel, a AMD suporta o mesmo projeto pras placas Radeon. Mas óbvio, só a NVIDIA quer ser a diferente e só oferece os drivers em binários fechados. Tem uma tentativa de fazer drivers de código aberto via engenharia reversa chamada Nouveau, mas ela dificilmente vai ser tão performática e compatível quanto os drivers da própria NVIDIA. Mesmo problema do Wine.







Muitas distros e pessoas que são mais xiitas com código aberto e não admitem instalar binários proprietários ficam de fora do mundo NVIDIA porque o driver Nouveau funciona mas pra pouca coisa, em particular jogos não vão funcionar. Pra piorar, se você quer fazer alguma coisa de machine learning, deep learning ou qualquer coisa em placas NVIDIA vai precisar do pacote gigante que é o CUDA, que também é proprietário. Então, se você valoriza software livre, sua única opção é comprar AMD porque os drivers Mesa são todos abertos.







Quem gosta de NVIDIA vai precisar usar os drivers proprietários. Em desktop não tem nenhum problema. Na maioria das distribuições o pacote que se chama só `nvidia` e `cuda` devem funcionar. Pra placas mais antigas tem drivers legados com nomes como `nvidia-39xx`. Um dos problemas é que no mundo Linux estamos querendo mudar do antigo servidor X.org pra Wayland. X é o sistema gráfico do Linux que é usado por gerenciadores de desktop como GNOME ou KDE pra desenhar a interface gráfica.








O X é um dos mais antigos legados do mundo Linux. Grande, complexo, monolítico, que faz muito mais do que deveria. O exemplo clássico é que tem tipo lógica de impressora embutida no servidor gráfico. O Wayland é a versão reescrita, moderna, leve e mais fácil de trabalhar. Se você usa só placa integrada da Intel ou AMD, já pode usar Wayland hoje. Mas por causa dos drivers proprietários da NVIDIA que só suportam X.org, a gente não pode migrar. Dizem que a NVIDIA vai passar a dar suporte a Wayland em breve, mas é um dos problemas do código não ser aberto. O suporte só vai vir se a NVIDIA resolver que quer.








E ainda temos uma segunda complicação. Eu falei lá no começo do video que testei o Steam no meu notebook Thinkpad X1 Extreme com GTX 1050 Max Q como GPU discreta. Meu notebook, como todos os outros modernos com GPU NVIDIA discreta, tem 2 GPUs: a integrada da Intel e a da NVIDIA. O monitor do notebook tá sempre ligado no da Intel, então a GPU da NVIDIA não tem como mostrar no monitor.





Claro, uma GPU que não consegue mostrar no monitor poderia ser meio inútil pra games. Na realidade existe uma ponte entre a GPU da Intel e da NVIDIA que é chamada de Optimus. É uma tecnologia pra permitir usar as duas GPUs. Quando estamos usando a da Intel, a da NVIDIA fica em modo de economia de energia. Mas quando mandamos trocar, a GPU da Intel passa a fazer a ponte com a da NVIDIA, que vai renderizando e copiando os frames pra da Intel mostrar na tela.







O processo de ter um servidor X renderizado por um GPU e poder escolher outra aplicação dentro daquela tela de X pra ser renderizado por outro GPU é o processo de renderização offline batizada de Prime. Óbvio, a ponte chama Optimus e o processo chama Prime. E por isso nasceu outro projeto depois batizado de Bumblebee.






Por padrão tudo roda na GPU da Intel, mas usando um comando no terminal antes do programa como o antigo `optirun` a gente consegue fazer esse programa em específico sozinho rodar na GPU da NVIDIA. Daí o Bumblebee começou usando VirtualGL e depois migrou pra biblioteca `primus` pra copiar frames da memória da GPU da NVIDIA pra GPU da Intel, pra daí mostrar na tela.





Se você tem a versão VirtualGL do Bumblebee pode rodar programas na GPU discreta com o comando `optirun` na frente. Mas na versão nova com `primus` precisa rodar com `primusrun` ou chamar o `optirun` com o parâmetro `-b primus` pra indicar que é pra usar com primus. Fica a dica porque se você pegar tutoriais antigos vai ver o comando `optirun` se ver outros tutoriais um pouco menos antigos vai ver `primusrun`. E ambos podem ser considerados antigos hoje. O que estou explicando neste video só vale pra 2021.



O Bumblebee tinha outros subprojetos como o `bbswitch` que desliga a GPU da NVIDIA se ninguém estiver usando pra não ficar consumindo bateria à toa, que é o motivo de ter esse esquema todo. E com os drivers mais novos da NVIDIA talvez não seja mais necessário nem instalar o bbswitch. Então teste primeiro pra ver se sua bateria tá indo pro saco muito rápido. Só se estiver pesquise sobre o bbswitch, que é um módulo pra kernel do Linux e por isso sua kernel também precisa suportar DKMS.







Pra complicar o jeito mais novo de usar Optimus parece que chama Prime Offload Render. Pra isso a gente não instala bumblebee e vez disso deve ter um novo pacote chamado `nvidia-prime` pra instalar na sua distro e outro que provavelmente se chama `optimus-manager` ou `nvidia-optimus-manager`. Eu digo “provavelmente” porque o nome desses pacotes pode variar de distro pra distro. E isso só funciona se você tem um driver NVIDIA maior que a versão 435. Se eu não entendi errado, nesse esquema, em vez de `optirun` ou `primusrun`, no pacote `nvidia-prime` vai ter o comando `prime-run`, se estiver rodando em modo híbrido. 







Além do modo híbrido, você tem a opção de usar tudo na GPU discreta, como se não tivesse a integrada da Intel. Pra isso você usa o optimus-manager pra escolher qual quer usar, tem que fazer um logout e login de novo (e se estiver usando GDM como gerenciador de login precisa instalar a versão `gdm-prime` também), mas enfim, depois de logar vai estar tudo na GPU da NVIDIA que vai renderizar e copiar os frames da memória dele pra memória da placa da Intel, cujo único trabalho vai ser mostrar esses frames no monitor de verdade. Então a placa da Intel vira só um controlador glorificado e por isso disse `prime-run` só no modo híbrido.







Com o driver novo, sem precisar de Bumblebee e estando em modo híbrido, pra mandar um aplicativo dar offload pra GPU discreta é só setar essa variável de ambiente NV Prime Render Offload pra 1. Pra isso o ambiente tem que estar usando Vulkan. Acho que só de instalar o driver da NVIDIA já instala suporte a Vulkan. Um probleminha que pode passar batido é que essa diretiva de render offline vai carregar o Vulkan que, por sua vez, vai pegar o primeiro GPU que achar e pode ser a da Intel, então precisa de uma segunda variável pra dizer que é pra carregar só na NVIDIA que é VK de Vulkan Layer NV optimus Nvidia Only. Se eu não esquecer vou deixar links na descrição do video abaixo pra vocês pesquisarem em mais detalhes.




(configuração gdm-prime)




Por último, a razão de fazer toda essa zona em notebooks é pra economizar bateria, tentar fazer a GPU discreta ficar quietinha sem consumir energia à toa. O ideal é usar a GPU integrada da Intel que é fraquinha, mas pra renderizar nosso desktop e janelas tá mais que bom. Mesmo pra assistir video como YouTube e Netflix da vida, a placa integrada é mais que suficiente porque ela tem instruções pra decodificar codecs de video como H.264 direto em hardware.






Depois que configurar tudo, basta usar o comando `optimus-manager` e passar o parâmetro `--status` pra ver em que mode você tá. A recomendação é testar o modo híbrido primeiro, que significa que você vai ficar usando a da Intel como GPU primária mas vai deixar o driver da NVIDIA pré-carregado e pronto pra renderizar um aplicativo em offline se a gente executar ou com prime-run ou com a variável de NV Render offline.






Problema de deixar o driver carregado é confiar se ele vai ou não gerenciar a GPU pra deixar ela inativa, sem usar energia, quando ninguém estiver usando. Teoricamente era pro driver da NVIDIA fazer isso sozinho. Caso consiga, tem que usar alguma coisa como o módulo de kernel `bbswitch` que falei antes. Problema desse tipo de coisa é ele forçar desligar a GPU discreta e se alguma ferramenta por acaso tentar acessar ela, pode dar pau.






Se você ver que a bateria continua não durando e o bbswitch não for bom pro seu fluxo de trabalho, a outra utilidade do optimus-manager é mudar pra usar só a placa integrada e só quando precisar, tipo abrir um editor de video ou algo assim, daí você manualmente usa ou a linha de comando ou os aplicativos gráficos como o optimus-manager-qt pra trocar entre a integrada e a discreta. Inconveniente é que precisa dar logout e login pra trocar entre um e outro, mas pelo menos você sabe exatamente se tá ou não desligado, especialmente se bateria for um problema.






Eu espero que o povo de AMD precise configurar menos coisas que isso. Em 2021 a solução da NVIDIA ainda não é amigável o suficiente. Tá melhor que três anos atrás. Mas como depende totalmente da boa vontade deles, ainda vamos ter que esperar mais pra ter um suporte mais estável pra Linux. Pra ser justo, eu fiquei com vontade de documentar isso hoje porque comecei a testar Optimus num Dell XPS lá por 2017 ou algo assim e aí o processo era com Bumblebee e optirun e me confundiu quando fui usar hoje. Quem quiser ver minha configuração daquela época vou deixar os links na descrição abaixo. 






Fazendo tudo isso, agora eu tenho um Linux com drivers NVIDIA configurado pra rodar com Prime e Vulkan. Com meu Steam mais Proton e DXVK consigo rodar a maioria dos jogos que eu quero. Aliás, só faltou falar rapidinho que se como eu, você precisar de suporte pro controle sem fio de XBox One, veja o projeto `xow`. Ele precisa ficar carregado ativo num terminal pra ficar escutando o dongle de USB que é como o controle se conecta. Ou subir como um daemon, que eu não recomendo porque ele é meio bugado e começa a consumir muita CPU do nada e você quer matar ele fácil depois de jogar. Links nas descrições.







Eu falei bastante coisa, mas o objetivo foi mostrar como um simples ato de carregar um jogo no Linux envolveu mais de 20 anos de história com diversas empresas que surgiram e sumiram e diversas tecnologias que foram inventadas. E como um workstation Silicon Graphics de mais de 100 mil dólares no começo dos anos 90 hoje seria muito mais fraco que qualquer smartphone barato Android. Em pouco mais de 20 anos fomos de 100 mil dólares pra menos de 100 dólares.







É assim que mercados funcionam. Ninguém em 1992 poderia comprar um workstation desses, era inacessível. E quem comprava não era pra ostentar, era pra projetos militares, da NASA ou de entretenimento. Projetos de milhões de dólares, onde o custo de 100 mil não é tanto assim. Com bons resultados a demanda aumenta, e aumentando a demanda começam a aparecer concorrentes com alternativas. A Sun, a ATI, a 3DFx, a própria Microsoft. E pouco a pouco cada componente que fazia um Silicon Graphics ser especial foi sendo substituído por versões mais acessíveis.







A SGI cometeu um erro atrás do outro, mas deixou o OpenGL como legado. Na mesma época apareceu uma 3DFx que inovou em muitas áreas, inventou técnicas como soft shadow, reflexão, motion blur, e no final também cometeu vários erros e terminou comprada pela concorrente menor, a NVIDIA, e deixou pra trás o legado da Glide. A ATI, que inovou antes de todo mundo trazendo cor e resolução pros computadores verdes, competiu com NVIDIA, 3DFx e no final seu legado acabou dentro da AMD, que se tornou a maior rival tanto da Intel quanto da NVIDIA hoje, mantendo a dinâmica da concorrência em pé.






A própria Intel, no alto da sua arrogância, rejeitou o iPhone, o que abriu as portas pra Samsung entrar como concorrente mais rápido, e tudo isso levou de volta à ideia original da Silicon Graphics e da Sun: usar chips RISC baseados em ARM. Tudo dá voltas.




Um dos fundadores da Silicon Graphics foi o professor de Stanford, Jim Clark. Stanford que foi onde Steve Jobs e vários outros famosos estudaram. Depois da SGI, Jim Clark se uniu a outros estudantes com ideias inovadoras, como Marc Andressen, e juntos fundaram a Netscape, o primeiro navegador de sucesso comercial. Netscape que seria depois aberto como software livre e renomeado pra Mozilla Firefox. E hoje é o OpenGL que veio da SGI entrando nos navegadores de novo com WebGL e WebGPU.






Mas a maior moral da história é que muita gente que se acha super profissional ou acadêmico gosta de esnobar de gamers, mas hoje vocês aprenderam que quando um cara de data science falar em kernels, CUDA cores, e bla bla, na verdade ele tá falando de shaders de placa de vídeo. Um compute kernel de data science é um pixel shader. Se os elementos mudam de posição no grid é um vertex shader. As mesmas técnicas usadas pra fazer animação e games é a fundação desse movimento atual de data science, machine learning, inteligência artificial. 







De perguntas simples do tipo: como simular luzes pintando as cores de alguns pixels pra ser mais claro e outros pra serem mais escuros, e fazer esse modelo 3D de poucos polígonos parecer mais liso, saem as atuais perguntas de deep learning, inteligência artificial e tudo mais. Tudo é conectado. E se esse video não for a maior tangente que alguém já fez, não sei qual é. Eu saí da configuração de jogos no meu notebookzinho e pensei, o que alguém precisa saber pra realmente entender o que significa estar jogando esses jogos? E isso virou o resumo de mais de 30 anos de história. Se ficaram com dúvidas mandem nos comentários abaixo, se curtiram o video deixem um joinha, assinem o canal, cliquem no sininho e não deixem de compartilhar o video pra ajudar o canal. A gente se vê, até mais!

