---
title: "[Akitando] #116 - De 5 Tera a 25 Giga | Compressão de Dados e Multimídia"
date: '2022-03-23T14:28:00-03:00'
slug: akitando-116-de-5-tera-a-25-giga-compressao-de-dados-e-multimidia
tags:
- jpeg
- h.264
- h.265
- hevc
- fourier
- lempel-ziv
- zip
- 7zip
- rar
- video
- compressão
- akitando
draft: false
---

{{< youtube id="j4a1SgUWh1c" >}}

Huffman, Lempel-Ziv, LZ77: o que esses nomes tem a ver com o video que você tá assistindo aqui no YouTube e Netflix da vida? Vamos ver de uma forma prática sobre compressão de dados e como eles são aplicados no seu dia a dia. E de quebra vai aprender uma pequena introdução a ciência de cores e processamento de imagens e videos.

## Conteúdo

* 00:00:00 - O problema: Como faz streaming de 5TB em 2h??
* 00:03:52 - Cores não é só RGB: entendendo YUV
* 00:08:51 - Chrome Subsampling
* 00:13:52 - Contínuo pra Discreto: Fourier
* 00:15:22 - Resolução de Áudio
* 00:18:50 - Transformada Discreta de Fourier
* 00:20:11 - Transformada Discreta de Cosseno
* 00:24:14 - Quantização
* 00:27:37 - Run-Length Encoding
* 00:29:51 - Huffman Encoding
* 00:36:45 - Recapitulando até aqui
* 00:38:06 - JPEG
* 00:40:12 - GIF
* 00:42:44 - Lempel-Ziv
* 00:44:50 - Sliding Window
* 00:46:13 - Legado do PKZIP
* 00:49:26 - A treta da Unisys e GIF: PNG
* 00:53:33 - Aplicando tudo isso em video
* 00:55:00 - Codecs de video: AVC, HEVC
* 00:57:17 - Interframes e Intraframes
* 00:58:58 - Problema resolvido: bitrates
* 01:01:27 - codecs profissionais vs de consumo
* 01:04:40 - Resumo e Conclusão


## Links

* But what is the Fourier Transform? A visual introduction. (https://www.youtube.com/watch?v=spUNpyF58BY)
* How are Images Compressed? [46MB ↘↘ 4.07MB] (https://www.youtube.com/watch?v=Kv1Hiv3ox8I)
* Original CompuServe announcement about GIF patent (Original CompuServe announcement about GIF patent)
* Thomas Boutell (https://twitter.com/boutell/status/1357707533612441604?s=20&t=A2zgWT-iY2CiZrNvMI4lBw)
* Huffman Visualization (https://cmps-people.ok.ubc.ca/ylucet/DS/Huffman.html)
* Chroma Subsampling – 4:4:4 vs 4:2:2 vs 4:2:0 (https://www.displayninja.com/chroma-subsampling/)
* How JPEG works (https://cgjennings.ca/articles/jpeg-compression/)

## SCRIPT

Olá pessoal, Fabio Akita


Todo mundo já zipou alguma coisa. Até quem não é programador sabe que existe isso de "zipar" as coisas. Um programador tem que ir um passo além de só acreditar cegamente que as coisas funcionam como mágica. Como funciona compressão de dados? Já pararam pra pensar nisso? Melhor ainda, estamos assistindo um video aqui no YouTube. Como funciona a compressão de video pra possibilitar assistir isso aqui em Full HD ou 4K? Quem estudou ciência da computação provavelmente aprendeu o básico. A idéia do episódio de hoje não é falar de tudo que existe no assunto, mas dar mais noção pra você parar de ficar no escuro e aumentar sua curiosidade pra continuar estudando.



(...)




Vamos fazer uma conta de padeiro. Digamos que você tem grana sobrando, comprou uma TV nova 4K, e quer assistir filmes em 4K, com 8-bits de cor, em pelo menos 30 quadros por segundo. Um monte de jargão, vamos traduzir. Dizer 4K significa dizer 4 vezes a densidade de pixels de Full HD, High Definition. Full HD é a mesma coisa que 1080p, ou seja 1920 pixels na vertical e 1080 pixels na horizontal. O "p" é de progressivo, antigamente a gente tinha “i” de interlaced ou entrelaçado que ninguém usa mais então nem vou falar disso. Então, 4K é o dobro de resolução na vertical, que dá 3840 pixels e o dobro de resolução na horizontal, que dá 2160 pixels. O agora famoso 2160p. E cuidado que 8K tá chegando.







Tá claro que dobrando altura e comprimento, quadruplica a quantidade de pixels né? Geometria do primário aqui. Agora, se você é programador front-end, tá acostumado a cores de 24-bits, onde cada componente de RGB tem 8-bits cada, que são 256 tons pra cada uma das 3 cores primárias, vermelho, verde e azul. Normalmente a gente codifica em hexadecimal, então vai de 00 até FF. Preto é todas as cores zeradas então 000000. Branco é todas as cores no máximo, então FFFFFF. Esse é o básico de CSS que se aprende no dia 1, então vou assumir que todo mundo aqui tá confortável com isso.







Significa que cada cor precisa de 8-bits ou 1 byte, total de 3 bytes pra guardar uma cor por pixel. Repetindo, 24-bits é a mesma coisa que 3 bytes. Uma imagem 4K então vai ter 3840 colunas vezes 2160 linhas que dá um total de 8 milhões, 294 mil e 400 pixels. Tudo isso vezes 24 bits por pixel, que vai dar 24 milhões, 883 mil e 200 bytes, ou quase 24 megabytes por imagem.







Mas um video são 24 ou 30 desses quadros por segundo. A cada segundo precisaria trafegar 24 megabytes vezes 30 quadros que dá mais de 711 megabytes por segundo! De curiosidade, quanto precisaria ter de SSD aí no seu computador pra guardar um filme de 2 horas então? Só multiplicar por 7200 segundos, que é quantos segundos tem em 2 horas. Então 711 megabytes por segundo vezes 7200 segundos, vai dar a quantidade absurda de 5 milhões de megabytes, ou seja, nada menos que 5 terabytes.







Pensa um segundo, se isso fosse verdade, eu tenho certeza que o seu SSD aí na sua máquina não seria capaz de armazenar nem um único filme. Mas eu também sei que você baixa um monte de filmes via Torrent e deve ter uma dúzia nesse instante aí na sua pasta de downloads. Você é um programador, sua função é escovar bits. Como que você escovaria esses 42 trilhões de bits pra caber no seu HD?







O campo de compressão de video em particular é um corpo de conhecimento gigantesco, tem centenas de pesquisas e implementações e formas diferentes de resolver o problema. O que eu vou fazer a partir daqui é uma simplificação super grosseira pra vocês entenderem o básico, ter um modelo na cabeça pra ficar mais fácil quando quiserem ler sobre os detalhes avançados depois. Pra quem já é profissional da área, perdoem a simplificação mas é por uma boa causa. Vamos continuar.







Eu venho falando faz vários videos que tudo no final vira um linguição de bits. Um computador só entende uma fita de bits, nada mais. E uma fita de bits é nada mais, nada menos que um numerozão gigante de milhões de bits. Veja meus videos sobre a máquina de Turing e a introdução mais hardcore de computadores que soltei alguns meses atrás. Mas entenda que um video é também é só isso, um linguição de bits. Nosso trabalho, como programadores, é representar o mundo em forma de bits e processar esses bits pra tranformar em outros bits mais úteis. Um programa é só uma função, que nem uma equação, que recebe números e cospe números, no caso números em binário, bits.







E pra isso você tem que parar de assumir que as coisas são regras escritas em pedra. Por exemplo, se você é só programador de front-end e seu dia a dia é justamente escrever cores em hexadecimal pra RGB, seu mundo é estático em pensar que a única forma de representar cores é juntando 1 byte pra vermelho, 1 byte pra verde e 1 byte pra azul, e acabou. Isso não é verdade. Existem diversas formas de representar cores e RGB é a mais fácil de entender, porque todo mundo misturou tintas na escola em algum momento, mas não é a forma mais eficiente. Aqui começa aquele troço que todo iniciante não entende chamado “abstrações”. Vamos ver na prática o que isso significa.







E se eu quiser gastar menos bits por cor? Podemos diminuir de 24-bits pra digamos, 12-bits. Daí em vez de gastar 3 bytes no total, vamos gastar só 1 byte e meio, metade do espaço. Só que as possibilidades de cores não cai pela metade. Lembra, são potências de 2. Ou seja, caimos de um total de mais de 16 milhões de cores pra só umas 4 mil cores. Pra economizar metade do espaço de bytes, perdemos milhões de possibilidades de cores. É parecido quando se converte uma foto pra um GIF, que vou explicar sobre mais pro fim. Mas 4 mil cores é muito pouco hoje em dia. Pra fazer jogo de Nintendinho em pixel art tá mais que bom. Mas pra editar fotos, é impossível. É muito pouca informação de cor. Até um amador consegue ver uma foto com paleta de 4 mil cores e dizer que a qualidade é inaceitável.








Então não dá pra cortar bits do RGB, cada bit que eu corto, divido o total de cores por 8. Fodeu então? Não. No caso de video não se usa RGB e sim outra representação chamada YUV, alguns já devem ter visto esse nome. Mas simplificando a idéia é dividir a cor em 2 grandes componentes, a luminância que é o brilho ou luma e o chroma, que é representado por diferença de azul e diferença de vermelho. Quando se fala em color science, é aqui que isso começa. Em vez de pensar em cores como mistura de tintas, imaginamos cores como a distância pro ponto mais branco num espaço tridimensional. 







Se você é fotógrafo ou algo assim já deve ter ouvido falar em coisas como sRGB, Adobe RGB ou DCI-P3 que é color gamut ou gama de cores, que é um subconjunto do total teórico de cores possíveis de existir no espaço de cores. YUV representa numericamente todas as cores teóricas e color gamut como Adobe RGB é o que realmente é possível de mostrar num determinado monitor. Essa parte é bem longa, tem que passar por coisas como correção de gama, mas na prática se você não sabe a importância de DCI-P3 contra sRGB, é porque pra você isso não faz diferença. Só fotógrafos e coloristas profissionais que precisam saber os detalhes disso.








YUV vem da era de TV preto e branco e como fazer broadcast de video, daí já existia o conceito de luma, já que não tinha cores, ou chroma, ainda. Em YUV o Y é o luma, U é a projeção de azul e V é a projeção de vermelho. Em resumo, converter de RGB pra YUV é multiplicar o RGB por esta matriz aqui. Eu sei, assusta pra quem nunca viu Álgebra Linear. E converter de volta pra RGB é só inverter e multiplicar YUV por esta outra matriz. É uma conversão linear, um pra um, sem perder informação nenhuma. Se nunca pensou nisso, RGB é uma coordenada em 3 eixos de cor num espaço tridimensional, um vetor.







Pra visualizar, vejam esta imagem, um quadro de um video. Se separar em RGB, teríamos esse quadro representando só o componente vermelho, este só o verde e este outro só o azul. É como você pensa em canais no Photoshop, cores primárias sendo misturadas. Mas depois de converter pra YUV, agora este é o Y ou luma, que seria a imagem preto e branco e tons de cinza. Este é o quadro de projeção de azul e este outro o de projeção de vermelho, que é o componente UV ou chroma. Junte os 3 e temos a imagem original de volta.








Lembram DVD player antigo ou video game antigo? Antes de existir HDMI como que vocês ligavam os aparelhos na TV? Quando era modelo barato era só um cabo com conector RCA, o cabo composite ou composto. Mas tinha modelos melhores, com 2 ou 3 cabos RCA separados. Alguns poderiam chutar que era RGB, sinal de uma das 3 cores primárias em cada cabo. Mas não, é um cabo pra luma, e os outros dois pra chroma. Por isso algumas TVs podiam até ter escrito atrás YCrCr que é a mesma coisa que YUV. 







Sem entrar em detalhes sobre correção de gama, color space e outros detalhes, o que ganhamos fazendo isso? Beleza, convertemos um número de RGB em outro número em YUV, mas continua usando os mesmos 24-bits. “Tomeito, tomáto”. Não mudou nada. Ah, mas agora vem o pulo do gato. Na ciência de cores, pesquisas mostraram que o olho humano é mais sensível a mudanças de luma do que de chroma. Ou seja, o componente Y é muito mais importante que U e V. Em RGB a informação de brilho vem embutido em cada cor primária, e quando convertemos em YUV o que fizemos foi retirar essa informação pra um número separado de luma.






Vejam de novo a separação de canais, a imagem preto e branco é super nítida, conseguimos saber o que é. Mas agora olha os componentes de chroma, difícil de discernir o que estamos vendo né? Principalmente os detalhes. O mesmo não acontece se vermos os canais separados de RGB, porque a informação de luma está distribuido nas 3 cores primárias. Tão começando a ver a vantagem de representar a mesma informação de jeitos diferentes? RGB é mais fácil de descrever mas YUV vai ser mais fácil de manipular como vamos ver já já.








Já tentou ligar seu computador no HDMI da sua TV velha, que não tem um modo game? Já notou que assistir videos é normal, fica bonito. Mas quando liga o computador pra digitar um email as letras ficam todas meio borradas? Isso acontece porque sua TV é YUV 4:2:0. E o que significa isso? Pra entender vamos voltar pra RGB. Quando falamos em RGB estamos falando de 8-bits cor primária. Quando falamos de YUV estamos falando de samples ou grupos de 4 pixels organizados em duas linhas. Nesta primeira imagem temos o formato não comprimido, logo depois da conversão de RGB, que chamamos de 4:4:4, toda a informação de luma e de chroma preservados.








Agora, já disse que as pesquisas mostraram que nossos olhos são mais sensíveis a mudanças de luma do que de chroma. E se mantivermos a mesma quantidade de bits pra guardar luma então, garantindo a definição da imagem, e diminuirmos a quantidade de bits pra guardar chroma? Daí podemos pular pro esquema 4:2:2 que nem podemos ver aqui. Notem o importante, a informação de luma continua a mesma, mas cortamos chroma pela metade nesse sample, nesse grupo de pixels. Isso economiza um terço de bytes e caímos dos 48 bytes pra 36 bytes. Mas dá pra melhorar. Veja que perdemos muito menos informação do que quando tentamos cortar bits de RGB.







O que as pesquisas mostraram é que podemos cortar ainda mais no chroma e com isso chegamos ao formato YUV 4:2:0 que toda TV usa, que cai dos 48 bytes originais pra 30 bytes. Eu não tô muito certo dessa conta, mas é nessa faixa. Outra coisa é que o 2 e zero no 4:2:0 não se refere ao total de pixels. É como se fosse uma proporção. O primeiro 4 se refere a todos os 4 sample de pixels originais do canal de luma. O segundo 2 é o número de samples de chroma na primeira linha. O terceiro 0 é o número de mudanças dos samples de chroma entre as duas linhas, no caso 0 mudança no formato 4:2:0.








Se pareceu complicadinho é porque é mesmo. O que chamamos de YUV na realidade é o padrão YCbCr às vezes chamado de YCC e é tudo a mesma coisa. Mas não confundir com YPbPr que era o padrão mais antigo. Além disso eu falei que tem vários detalhes como correção de gamma e color space, que define padrões como o Rec. 709 que é o que todo mundo usa pra videos normalmente, como aqui no YouTube. Na prática, convertendo de RGB pra YUV 4:4:4 é um pra um, visualmente e em quantidade de bytes, não muda nada.







Mas mantendo o luma em 4 e descendo chroma pra 2:0, economizamos uns 40% de dados sem mudanças perceptíveis pra um ser humano, especialmente num video em movimento. Por isso a maioria das TVs é 4:2:0, por isso que video de DVD, Blu-Ray, streaming, incluindo esse aqui do YouTube é encodado em YUV 4:2:0, segundo o padrão Rec. 709. E por isso eu falei que quando se liga um computador numa TV que não suporta modo de game, PC, ou mais corretamente, YUV 4:4:4, as letras e detalhes precisos vão ficar meio borrados. Como 4:2:0 precisa de menos dados pra representar, é ideal pra fazer broadcast ou streaming ou guardar arquivos de video, porque precisa de menos banda e menos espaço sem quase perder qualidade do video, com exceção de detalhes pequenos, como letras e fontes pequenas.







Cada um dos componentes de YUV é representado por samples, e de 4:4:4 pra 4:2:0 estamos diminuindo samples do chroma então chamamos esse processo de Chroma Subsampling. Repetindo, estamos diminuindo bits de cor e mantendo bits de brilho pra ter praticamente a mesma imagem aos nossos olhos usando menos bits. Tudo que você achava que era RGB na verdade é YUV 4:2:0. Quando converte de 4:2:0 de volta pra RGB pra editar, ele completa os bits dos samples que faltam, duplicando dos que sobraram, então só aumenta o tamanho de bits mas não recupera o chroma perdido, lógico. Guarde essa informação.







Agora pára e pensa, um video é basicamente um conjunto de imagens. No nosso exemplo, imagens 4K. E precisa de 30 dessas imagens todo segundo pra termos algo em movimento suave como vemos na TV. Se a gente consegue reduzir 40% de todas as imagens, o video inteiro também fica 40% menor, portanto aqueles 5 terabytes pode cair pra até 3 terabytes, olha só que sensacional. Só que 3 tera ainda é absurdo pra 2 horas de video, continua não cabendo aí no seu computador. Como que faz então? 






Antes de continuar deixa eu introduzir mais um jargão pra vocês. A compressão de cores ou downsampling, que é descer o números de samples de chroma, é só uma técnica pra economizar bits jogando fora informação que nossos olhos não são bons de detectar. Isso significa que uma vez feito o downsampling, não tem mais como voltar pra imagem original, porque os detalhes originais foram simplificados. Isso é uma compressão que chamamos de lossly, ou seja, que perde informação.








Mas podemos ir além de chroma downsampling. Uma das principais funções de computadores é representar o mundo natural, analógico, contínuo, pro mundo digital, que é discreto e exato. Quando falamos em pixels, estamos arbitrariamente pegando a luz que chega de algum objeto e dividindo pacotes de luz em pixels, que é uma medida exata e discreta. Temos uma representação digital perto o suficiente pra ser convincente pros nossos olhos. Quanto mais pixels ou samples tivermos, quanto mais resolução, mais enxergamos a imagem como realista.







O mesmo vale pra outras coisas da natureza que queremos digitalizar como música e sons em geral. Se aprendeu física acústica no colegial vai lembrar que sons ou ondas representamos com um gráfico de curvas, senos, cossenos, radianos. Se já abriu qualquer editor de áudio como um Audacity ou Adobe Audition, já viu essa representação de ondas. E qualquer engenheiro de áudio sabe o que precisa fazer quando recebe onda analógica pra processamento digital: transformada de Fourier.







Eu mesmo não lembro mais quase nada de Fourier que aprendi na faculdade, mas acho que o principal é o seguinte. Da mesma forma que uma imagem não é formada de pixels discretos, uma onda de som também é contínua, mas num computador precisamos representar de forma discreta. Por isso que uma curva bonitinha como dessa imagem, uma linha contínua, pro computador fica tipo uma escadinha, que é um intervalo de valores discreto que mais ou menos representa essa curva original. Lembra quando eu falo que precisa pelo menos ter uma intuição matemática? Se gastou tempo estudando coisas como cálculo, enxergar isso deveria ser trivial.







Assim como temos samples pra representar som, samples de pixels por segundo representa video. Em video também representamos um movimento contínuo em quadros por segundo discretos. Quanto mais quadros por segundo pudermos ter, mais o movimento fica suave. Mas convencionamos uns 30 quadros por segundo que já é suficiente pra gente conseguir assistir um filme sem achar estranho. Quadros por segundo é uma medida de frequência. 30 quadros por segundo seriam 30hz. Um game precisa de no mínimo uns 60 quadros por segundo pra ficar bom de jogar, por isso compramos monitores de 60hz ou mais.







Quanto mais samples puder ter, maior a resolução, mais preciso vai ser o video ou áudio. A convenção da qualidade de CD de música é de 44.1khz, com samples de 16-bits, ou seja 44 mil e 100 samples por segundo, ordens de grandeza mais samples por segundo que video, mas cada sample ocupa bem menos espaço. Pelo jeito precisamos de bastante resolução pra enganar nossos ouvidos. Música HiFi que é o equivalente 4K da música, são pelo menos 192 khz com samples de 24-bits. 







Voltando pra CD, 16-bits vezes 44 mil e 100 dá 86 kilobytes por segundo. Um álbum de 24 músicas de 5 minutos cada, ou seja, 7200 segundos, vezes os 86 kilobytes por segundo vai dar aproximadamente 604 megabytes, que se você cresceu nos anos 90 e começo dos 2000 vai lembrar que um CD cabia 650 megabytes, por isso só isso de música já enche um CD. Era até engraçado porque antigamente tinha consoles como o Sega CD ou 3DO. Esses consoles não tinham potência pra ler arquivo de áudio comprimido tipo os mp3 de hoje e descomprimir em tempo real, por isso o áudio era sempre crú, descomprimido. 





Se tivesse as 24 faixas na trilha sonora, ocupando 600 mega, sobrava menos de 50 mega pro jogo em si. Por isso que cabia, porque um cartucho de megadrive não era muito mais que uns 2 megabytes, daí cabia fácil num CD de Sega CD. Mas eu tô fugindo do assunto. Mencionei áudio pra explicar que tudo analógico, imagem, video e áudio migram do mundo contínuo pro mundo discreto e no caso de áudio, todo engenheiro sabe analizar ondas usando transformada de Fourier, mais especificamente transformada discreta de Fourier pra representar um período de samples de onda como equações lineares.







Eu não tenho a matemática pra conseguir explicar isso fácil mas entenda que é uma conversão de sinais analógicos contínuos num domínio de frequências discretas, ou seja, dividir uma onda contínua de som em conjuntos de bits discretos. Pra quem estudou matemática, não dá pra representar todos os infinitos pontos de uma curva em conjuntos de números discretos, mas podemos achar as equações que geram esses pontos em determinado momento do tempo. 






O problema de transformada discreta de Fourier é que o cálculo disso é lento. Consoles e micros antigos dos anos 80 não tinham como calcular em tempo real. Mas nos anos 60 descobriram uma aproximação que é ordens de grandeza mais fácil de calcular, pulando da complexidade quadrática da transformada discreta de Fourier pra complexidade logaritmica, N.log N que é a transformada rápida de Fourier ou Fast Fourier, que é considerado o algoritmo numérico mais importante já criado. 






Quando falam se é importante entender matemática e tals, esse é "o" caso mais importante em processamento digital e se tiver interesse em pelo menos ter uma intuição visual de como enxergar uma transformada de Fourier eu recomendo muito os videos do Grant do canal 3Blue1Brown. Ele é o melhor professor de matemática que já vi no YouTube e em particular sobre Fourier tem uma forma visual animada que vai te dar uma imagem mental muito melhor do que eu jamais conseguiria.






Muito bem, vamos voltar. Porque falei todo esse mambo jambo de matemática? Porque grupos de pixels em imagens podemos tratar como séries de frequências também. Falando em resumo, bem resumido, estamos com nossa imagem gigante de 4K depois de fazer color downsampling pra YUV 4:2:0. O que podemos fazer agora?






Transformada Discreta e Transformada Rápida de Fourier transformam ondas contínuas em uma representação de uma série discreta. Quando falamos em ondas, falamos de senos e cossenos. E nessas equações estamos considerando duas dimensões, por isso são equações de números complexos. Lembra número complexo, que tem um componente que é um número real e outro que é um número imaginário.






Quando vamos mexer com imagens só precisamos de uma dimensão de números reais e por isso em vez de DFT ou FFT podemos usar DCT que é transformada discreta de cosseno. Em áudio usamos FFT não só pra representar o áudio analógico de forma digital mas também pra fazer DSP ou processamento digital de sinais, por exemplo, decompondo uma onda em ondas mais simples usando senos e cossenos. E de novo, eu to simplificando grosseiramente, mas é assim que fazemos coisas como denoising que é redução de ruído, equalização e tudo mais.







Pois bem, com DCT que é a transformada discreta de cosseno vamos decompor o luma e chroma de cada imagem em uma soma de funções de cosseno de diferentes frequências. Fodeu né. Calma que é complicado mesmo, mas pra visualizar não é tanto assim. Como uma imagem pode ter qualquer dimensão, o algoritmo começa dividindo a imagem em blocos de 8 por 8 pixels. Não importa se é uma imagem pequena do tamanho de um ícone ou gigante do tamanho de uma TV 8K. Vamos sempre trabalhar em blocos de 64 pixels de cada vez. Em computação a gente sempre usa a estratégia de dividir e conquistar. Nenhum trabalho é tão grande que não possa ser quebrado e atacado um pedaço de cada vez.








Agora o trabalho da fase de DCT é quebrar os canais de luma, chroma azul, chroma vermelho em uma soma de funções de cosseno. Simplificando, essas funções de cosseno podemos ver visualmente nesta imagem também de 8 por 8 imagens. É uma tabela pré-calculada, não se preocupem agora como ela foi criada, só aceitem que existe. Cada quadrado representa uma onda diferente, a tal função de cosseno, em duas dimensões. Lá no canto superior esquerdo é todo branco, normalmente o componente mais usado. E lá embaixo é uma pattern que parece tabuleiro de xadrez ou damas, um checkerboard. 








Temos que processar os 3 canais de YUV, mas vamos pegar primeiro um bloco de 8 por 8 pixels só do canal luma, que é a camada preto e branco. E vamos representar cada pixel pela intensidade de preto até branco, indo de 0 até 255. Na real acho que é de 16 até 235 ou algo assim por conta de correção de gama mas não interessa agora. Funções de cosseno, você lembra que é em radianos no eixo X, por exemplo Pi que é 180 graus e 2 Pi que é 360 graus. Mas no eixo Y vai de -1 até 1 positivo.








Então a primeira transformação que precisamos fazer pra cada pixel no nosso bloco é substrair por 128 pra dar números que vão de -128 até 127. Agora usando DCT, e aqui é a parte que vai ser uma caixinha preta que vocês vão ter que acreditar que funciona, vamos criar uma nova matriz de 8 por 8 com os pesos pra cada uma das imagens de frequência de base. Cada uma das imagens dessa tabela contribui um pouco pra reconstruir a imagem original. Se não ficou claro, veja esta imagem de uma pequena letra “A”. Pegando cada uma daquelas imagens bizarras de cosseno que eu falei e aplicando os pesos ou coeficientes e somando um em cima do outro, no final eu reconstruo o “A” original, sacaram? 






Se você é de CSS, de novo, é como se esses coeficientes fossem o tanto de RGB, o tanto de vermelho, o tanto de verde e o tanto de azul que precisa misturar pra fazer, por exemplo, marrom escuro. É o peso de cada cor. A diferença é que em vez de misturar, ou seja, somar componentes de cor, estamos somando tipo funções de cosseno, usando esses pesos pra dizer quanto que cada função contribui pra reconstruir a imagem original. 





A matriz de coeficiente resultante é interessante pela forma como essa base de funções de frequência é construído, blocos mais lá pro canto superior esquerdo tentem a contribuir mais pra reconstruir nosso bloco original de 8 por 8, por isso usamos coeficientes maiores. Mas os blocos mais lá pro canto inferior direito, contribuem pouco, são funções de alta frequência. E faz sentido, essa tabela base foi construída de tal forma a separar componentes de baixa frequência e de alta frequência.








Mesmo se você não for de computação já deve ter ouvido que animais, como cachorros, conseguem ouvir sons de alta frequência que nosso ouvidos humanos não conseguem ouvir. Mesma coisa pra luz, a luz visível é só uma faixa pequena de todas as frequências de cores. E sim, lembra que luz é uma onda, assim como som é uma onda. Ondas de baixa frequência começam lá atrás na faixa dos raios gama, depois raios x, depois ultravioleta, aí chegamos na minúscula faixa que é a luz que nós conseguimos enxergar, mas daí vai pro infravermelho até ondas de rádio.







E mesmo na faixa visível, nas bordas com o ultravioleta e infravermelho é difícil de distinguir um limite. Essas faixas não são discretas, tipo “a partir exatamente deste ponto que a gente não consegue ver”. Vai variar. E essa tabela base é feita pra quando calcularmos a tabela de coeficientes, os números que se aproximam do canto inferior direito sejam cores de alta frequência que a gente não consegue distinguir direito, mais uma vez, depois de anos de pesquisa, sabemos o que não conseguimos enxergar. Assim como na fase de color downsampling já reduzimos o chroma, agora vamos reduzir mais ainda nos 3 canais.








E isso foi pra um bloco de 8 por 8 pixels da imagem. Agora precisa repetir a mesma coisa pra todos os outros blocos que formam a imagem, em todos os 3 canais de luma e chroma. Fazendo tudo isso, até agora não comprimimos nada, só processamos os números que representam cada pixel de cada canal em outro número processando com a transformada discreta de cosseno. Mas o pulo do gato vem agora. Lembra quando você vai salvar uma imagem em JPEG e o Photoshop ou outro programa pede pra escolher se quer salvar em alta qualidade ou baixa qualidade, e tem um slider pra escolher algum valor no meio? E normalmente você escolhe lá pelos 80% porque você acha que isso vai salvar 80% dos detalhes do original? 







Pois é, essa é a fase chamada de quantização. Na prática é uma divisão de matriz. Um exemplo é essa tabela aqui. Notem que os números mais perto do canto superior esquerdo são menores e os próximos do canto inferior direito são maiores. Lembra as tabelas resultantes de coeficientes pra cada bloco de 8 por 8 pixels? Pois bem, vamos dividir cada número por cada número correpondente nessa tabela de quantização. Cada nível de qualidade, tipo os 80% que você escolheu pra salvar no Photoshop é uma tabela diferente. Quanto menor a qualidade, maiores os números dessas tabelas de divisão. 






Dividindo um número por outro grandão o resultado vai ser um número bem pequeno. Se der quebrado, arredonda pro inteiro mais próximo. Isso significa que os coeficientes mais próximos do canto interior direito vão ficar pequenos, ou melhor ainda, zerados. É aqui que começa a fase real de compressão. Olha só o resultado da divisão, uma boa parte dos números fica zerado e não tem problema porque elas contribuem pouco na reconstrução da imagem, no sentido que os detalhes que acrescentam, nossos olhos não distinguem tão bem. A tal da região da alta frequência.







Vamos fazer essa divisão pra todos os blocos que compõe a imagem original. E como último truque, vamos rearranjar esses pixels de lugar. Lembra que a imagem toda é só um linguição de bits? Onde cada grupo de uns 16 bits representa um pixel em YUV? A gente só tá mostrando elas quebradas em linha, formando um retângulo, pra ficar fácil de ver mas na realidade é uma linha atrás da outra no binário. E cada bloco de 8 por 8 pixels representa um pedaço de cada linha. Em vez de escrever uma linha de cada vez, vamos reescrever esse bloco em zigue zague, começando do canto superior esquerdo e descendo até o canto inferior direito. Isso pros zeros ficarem um atrás do outro. 







Na transformação de cosseno a gente fez de propósito os coeficientes que virariam zero na divisão ficarem mais acumulados num canto. A ordem que se escreve os bits não é importante contanto que na hora de ler de volta seja na mesma ordem, claro. E de novo, até este ponto ainda não comprimimos nada, só fizemos preparativos. Lembra que partimos de um bloco de 8 por 8 pixels e chegamos no mesmo bloco de 8 por 8 pixels. Nada mudou ainda.







Depois de fazer o zigue zague olha o que aconteceu, temos um array onde os números mais pro fim tem sequências de zeros. Agora sim, vamos pra compressão. O primeiro algoritmo é mais intuitivo. Vamos pegar um outro exemplo com uma string aleatória com sequências repetidas, tipo um "AABCDDDDEFFFFFGGGH" que tá aqui do lado com 18 caracteres. Concorda que poderíamos reescrever por exemplo como "A2B1D4E1F5G3H1". Ou seja, em vez de repetir F, 5 vezes, escrevemos F5 pra indicar que é pra repetir 5 vezes. Descemos de 18 caracteres e comprimimos pra 14, um ganho de 22%, mas isso porque essa string é curtinha, quanto maior for e quanto mais sequência repetidas tiver, mais comprimida fica.







Esse é um dos algoritmos mais simples e ingênuos de compressão lossless, ou seja, que não perde nenhuma informação, diferente de chroma subsampling que fizemos lá no começo. Da string comprimida podemos voltar pra original sem muito trabalho. Voltando pro nosso bloco de coeficientes divididos depois da quantização, aquelas sequências de zeros repetidos podemos fazer a mesma coisa e isso já vai nos dar um pequeno ganho.






Esse algoritmo se chama Run Length Encoding ou codificação de corrida de comprimento. O pior caso desse algoritmo obviamente é se a string original tiver alta entropia e quase nenhuma sequência repetida. Mas o próximo algoritmo é mais interessante e se aprende na ciência da computação. E começa criando uma tabela de frequência. No mesmo exemplo da string, vamos contando letra a letra e ordenando pela frequência vamos ter B 1, C 1, E 1, H 1, A 2, G 3, D 4, F 5







Agora vamos montar uma árvore binária de frequências. Começa pegando do começo dessa lista, O B e o C que só aparecem 1 vez cada e coloca embaixo de um nó que é a soma das frequências, no caso 2. Agora pegar o E e H que também só aparecem 1 vez e colocar embaixo de outro nó 2. Agora tem vários com frequência 2, meio que tanto faz, mas na ordem pegamos o nó 2 do E e H que acabamos de criar, o A que aparece 2 vezes no texto e colocamos embaixo de um nó 4 que é a soma das frequências.






Continuando, pegamos o nó 2 do B e C e a próxima frequência 3 da letra G e colocamos embaixo de um nó que a soma dá 5. Temos 2 nós 4, do A, E e H e do D, colocamos embaixo de um nó com soma 8. Depois pegamos a sub-árvore do B, C e G e o F que tem frequência 5 também e colocamos embaixo de outro nó com soma 10. E finalmente pegamos os nós resultantes 8 e 10 e colocamos embaixo da raíz 18, e formamos uma árvore binária de frequências. Agora pra que tivemos esse trabalhão todo?







Como que o computador enxerga aquela nossa string original "AABCDDDD" etc? Digamos que está representada como caracteres UTF-8. Lembra Unicode? Computadores não entendem letras, só números. Nós, programadores, que precisamos enxergar uma sequência de números e pedir pra ele desenhar ou processar alguma coisa. Sendo simplista, por convenção usamos uma tabelona gigante que é a UTF-16, que associa um número com até 2 elevado a 16 possíveis glifos, mais de 65 mil possíveis glifos.






Um glifo é basicamente o desenho de um caracter. UTF é uma tabela arbitrária que usamos por convenção e todo programa e sistema operacional traduz da mesma forma. O glifo da letra A maiúsculo em inglês é o ponto de código 0041 em hexadecimal. O glifo da letra B maiúscula é 0042 e assim por diante. Então, em hexadecimal o string AABC etc fica 4141 4243 e assim por diante. Mas lá embaixo, no nível do computador mesmo, ele enxerga em binário, zeros e uns, então fica um linguição tipo  0100 0001 0100 0001 0100 0010 e assim por diante.







No mínimo, o código que representa cada letra, vai ocupar 8 bits se o encoding for em UTF-8. Cada letra ocupa 1 byte portanto a string inteira ocupa 18 bytes. Mas e se eu esquecer UTF-8 e usar outra tabela com códigos que precisam de menos bits? É pra isso que criamos essa árvore binária de frequência. Ela que vai servir pra codificar o A, B, C etc com outro código diferente da UTF-8. Vamos ver como.







Começamos da raíz da árvore que é o nó 18 lá em cima e vamos descendo. Cada galho vai representar zero ou um. Se eu for pra esquerda vai ser zero, pra direita vai ser um. Então vamos lá, qual vai ser o código binário pro A? Em UTF-8 é 0100 0001, 8 bits. Vamos lá começando do nó 18, um galho pra esquerda, então 0. Mais um pra esquerda, 0 de novo. Esquerda, 0. Esquerda 0. Então o código pro A vai ser 0000. Logo de cara já economizamos metade do espaço. 






Daí tem A de novo, então 0000. Agora o B, da raíz vai pra direita, então 1. Daí tem mais 3 galhos pra baixo pra esquerda, então 3 zeros e o código pro B vai ser 1000. O C mesma coisa, começa pra direita então 1, desce dois galhos pra esquerda, então 0 e 0, e vira pra direita no final então 1. Portanto o código do C vai ser 1001. Mas começa a ficar divertido agora, porque temos uma sequência de 4 Ds. O código do D é começando pra esquerda 0 e indo pra direita que é 1, portanto o código do D é 01. Repetido 4 vezes fica 01010101. 8 bits, pra 4 letras. Agora começaram a entender?







Antes esse D seria o hexadecimal UTF-8 0044 que em binário é 0100 0100, 8 bits. Como são 4 Ds tó esse trecho ocuparia 4 bytes. Mas nesse sistema de encoding da árvore de frequência codificamos o D somente com 2 bits. Todas os 4 Ds vão ocupar um único byte, então esse trecho ficou 4 vezes menor! E pra não ficar tedioso vou parar por aqui mas é pra fazer a mesma coisa letra a letra, usando a árvore como o sistema de codificação.






No final vai ficar esse binariozão. Olha como o F que repete 5 vezes também ficou curtíssimo com 2 bits cada letra. E não é por acaso que o D e o F, que são as letras que mais repetem, sejam representados só com 2 bits enquanto letras que não repetem tanto como o A ou C precisam de 4 bits. Porque a árvore foi ordenada e montada de tal forma que as letras mais comuns fiquem mais próximos da raíz da árvore, precisando de menos galhos pra chegar neles. O string original tinha 18 letras, portanto 18 bytes. Agora o binário comprimido ficou só com 60 bits que é 12 bytes, economizamos 6 bytes nessa brincadeira que é 2/3 do tamanho original.

0000 0000 1000 1001 01 01 01 01 0010 11 11 11 11 11 101 0011






Pra strings pequenas assim esse sistema não compensa porque pra conseguir descomprimir precisa também salvar a estrutura da árvore junto, e vai dar mais que os 18 bytes originais. Mas em textos mais longos isso pode diminuir tudo em até umas 5 vezes. Pensa um arquivo de código fonte, ou um JSON, que só de identação tem um monte de espaço em branco. Espaço em branco, tabulação, tudo é um caracter e tudo ocupa espaço, mesmo o que você não enxerga. 







Com uma combinação de Run Length e esse sistema de árvore de frequência que se chama codificação de Huffman, dá pra comprimir bastante. Depende do texto, claro, alguns dá pra comprimir mais, outros menos. Huffman é um bom exemplo de porque todo programador precisa saber o que é uma árvore. E por isso eu fiz um vídeo só falando de árvores algum tempo atrás. Todo mundo pensa em tabelas como uma matriz, um array de array, mas uma tabela ordenada, de chaves e valores, costuma ser implementada como uma árvore.







Se estão curiosos em como descomprime, é fácil. Vamos lá, 0000 significa começar da raíz e descer pra esquerda 4 vezes, aí esbarra no A, então escreve A e volta pra raíz. Vem 0000 de novo, vai chegar no A de novo, concatena com o A anterior, volta pra raíz. Agora é 1000, direita e esquerda 3 vezes, esbarra no B, concatena. Volta pra raíz, 1001, direita, esquerda, esquerda, direita, esbarra no C, concatena. Volta pra raíz, 01, esquerda e direita e já esbarra no D, concatena. Volta pra raíz 01 01 01, esbarra no D 3 vezes. E vai fazendo assim até ter o texto original de volta. Viram como é super simples e fácil?








Se lembram porque estou falando de Run Length e Huffman? Porque voltando na explicação de imagem, fizemos a compressão de cores com chroma subsampling pra converter de RGB pra YUV 4:2:0, daí dividimos o linguição de bytes de cada canal em blocos de 8 por 8 bits e aplicamos o processamento de transformada discreta de cosseno ou DCT, depois a quantização pra simplificar os coeficientes.







Daí reescrevemos bloco a bloco em zigue zague pra forçar zeros repetidos mais próximos no fim de cada bloco. E agora? Uma sequência de zeros repetidos, é só aplicar Run Length pra diminuir o espaço que ocupam. Agora podemos aplicar Huffman. Criar a árvore de frequência dos números que mais se repetem perto da raíz e codificar como no exemplo da string. 





Recapitulando, uma imagem de video de 4K seria 3240 vezes 2160 pixels, com cada pixel ocupando 3 bytes em RGB. Isso daria uma imagem crua, descomprimida, de uns 20 megabytes. Aaplicando chroma subsampling, transformada discreta de cosseno, quantização de qualidade 8, run-length e Huffman, podemos chegar à mesma imagem ocupando nada menos que 900 kilobytes, menos de 1 mega. Uma compressão de mais de 20 pra 1, 20 vezes menor que o original e que pra 99% das pessoas vai ser difícil de distinguir com o original. Nada mau né?







Esse processo todo está por trás do formato de imagem mais difundido do mundo que todo mundo, até quem não é programador usa todo dia, vocês acabaram de aprender como funciona o famoso JPEG, que é um sistema de compressão lossy, que perde informações do original, mas que em quantização lá perto de 8 pelo menos, a gente não vai perceber no dia a dia a menos que precise abrir no Photoshop pra editar. E agora você talvez comece a entender as razões das limitações do formato.







Como um JPEG vai cortando informação ao longo de todo esse processo, é impossível recuperar os detalhes do original. É um processo “lossy”. E cada vez que edita um JPEG e salva num novo, vai continuar perdendo mais informação. Por isso que não se deve editar um JPEG diversas vezes. Toda vez vai perdendo mais e mais definição. Por todo esse processo que imagens que tem traços muito bem definidos, como desenhos, quadrinhos, anime e coisas assim ficam meio soft e perdem a nitidez nas bordas. Esse sistema é melhor pra fotos de natureza, pessoas, que tem coisas como céu com muitos tons de azul. Mesmo desconstruindo o tanto que fizemos, é difícil alguém não treinado notar que mudou alguma coisa.







E por isso JPEGs de baixa qualidade, que o original já não era grande coisa e você ainda vai e manda salvar em qualidade baixa, tipo quantização 1, fica artefatos visíveis em formato de quadradinhos, como num grid, porque a gente divide a imagem em bloquinhos quadrados e processa um a um e depois concatena o resultado. Esse sistema dá resultados impressionantes de mais de 20 ou 30 vezes de compressão, por outro lado, quanto mais nítido, ou no outro espectro, quando mais borrado o original for, pior vai ser o resultado, especialmente em quantizações mais agressivas. Em resumo, JPEG é muito bom pra comprimir uma foto e guardar ou transmir. Mas é uma bosta pra editar. Por isso que fotógrafo profissional não tira fotos em JPEG e sim em RAW, que fica muito maior que os 20 mega que eu falei, porque guarda bem mais informação de cores e tudo mais pra possibilitar manipular e ajustar num Photoshop ou Lightroom depois.







O formato BMP que o Paint ou Painbrush do Windows originalmente salvava sempre gerava arquivos grandões, porque não comprime nada. Mais parecido com o formato RAW de câmeras, era o antigo formato TIFF. Ambos são parecidos com BMP ou bitmap no sentido que não joga informação fora, mas eles aplicam um mínimo de compressão lossless, ou seja, que não perde nenhuma informação. Já vou explicar compressão lossless.







Mas tem um formato que surgiu da CompuServe, um dos primeiros provedores de internet dos anos 90, mesma época da America Onine, ou AOL. Naquela época estávamos engatinhando, era final dos anos 80. E começou a ficar óbvio que queríamos trafegar imagens, seja em BBS ou nesse troço novo chamado de Web. Mas não dava pra ser em Bitmap descomprimido. Mesmo TIFF era grandão. Daí eles inventaram o famigerado GIF ou JIF, seja lá como prefere chamar. A essa altura já nem me importo mais qual é o certo. É aquele formato de imagem de memes animados que todo mundo manda no zap.







O GIF é um patinho feio que continuamos usando até hoje por causa de funcionalidades que poucos tem. Em particular animações bem leves. Pra começar ele limita a quantidade de cores na imagem. Em vez de cada pixel ser representado por 24 bits de cor, limitaram a no máximo 8 bits, o que diminui o espaço de cores de mais de 16 milhões pra meras 256 cores. Sim, só 256. Cada componente do RGB tem 8 bits, mas no GIF tem que dar um jeito e enfiar tudo em só 8 bits no total. E obviamente não dá, então tem que jogar fora quase todas as cores e se virar com quase nada. Eu lembro que parte do trabalho em agência naquela época era otimizar as cores dos GIFs.







O processo não é muito diferente de fazer pixel art. Dá pra automatizar o processo de jogar cores fora mas às vezes o algoritmo escolhe um tom que não fica muito bom, daí temos que ajustar manualmente. Em cima disso o GIF ainda tinha duas funcionalidades que são os diferenciais até hoje. A primeira era poder escolher uma cor dessa paleta pra ser transparente. Como não era uma canal alpha de verdade, a transparência era bem abrupta e feia, só em cima de uma única cor. Mas pra memes tá mais que bom.






E a segunda funcionalidade era permitir ter mais de uma imagem dentro do mesmo arquivo, com a possibilidade de tocar animado, que é a coisa mais importante em todo meme de hoje em dia. O problema disso era a paleta de cores. Lembra que pode ter no máximo 256 cores? Pois é, e as cores valem pra todas as imagens da animação, por isso é inteligente não fazer animações que tenham quadros muito diferentes um do outro.






Depois de comprimir jogando milhões de cores fora, o segundo passo era comprimir reduzindo sequências de bytes repetidos, meio parecido com a idéia do Run-Length que falei antes, mas bem mais agressivo. Pra isso GIF usa um algoritmo de compressão chamado LZW ou Lempel-Ziv-Weich. Tecnicamente o algoritmo original foi criado por Abraham Lempel e Jacob Ziv coincidentemente no ano que eu nasci, em 1977. Por isso que o algoritmo original se chama LZ77 que você vai esbarrar bastante se começar a pesquisar sobre compressão. Também vai esbarrar no LZ78 que é uma otimização da fase de descompressão. O LZW é uma variação desse algoritmo criado por Terry Weich em 1983 mas já volto a falar dele. Vamos focar só no LZ77.






Vale eu explicar a idéia geral com um exemplo. Vamos pegar outro string, como esse "um tigre, dois tigres, três tigres". Sem descer em detalhes temos repetido 3 vezes o trecho "tigre". E se a gente substituir o 2o e 3o tigre com um ponteiro dizendo quantas letras pra trás precisa ir pra achar o 1o tigre e quantas letras queremos pegar? Então ficaria algo como "um tigre, dois <12,5>, três <25,5>". Esse 12,5 quer dizer, ande 12 letras pra trás e leia 5 letras. E 25,5 mesma coisa, ande 25 letras pra trás e leia 5 letras, ambos vão cair na primeira palavra “tigre” e com isso dá pra remontar a frase. Se eu codificar esses ponteiros com 4 bits cada valor, em 1 byte dá pra guardar.







O string original tem 33 letras, mas substituindo onde repete por esses ponteiros daria pra reduzir de cara pra 23 bytes, mais 2 bytes pra cada ponteiro, ou seja, 25 bytes. Mesmo nesse esquema simplificado já comprimimos em quase 25%, 1 quarto de economia. Imagine que num texto muito maior vai ter muito mais repetições e por isso dá pra comprimir bem. Se só o esquema de Huffman comprime umas 5 vezes, eu diria que o mesmo texto nesse esquema de ponteiros daria pra comprimir na faixa de 10 vezes. No geral acho que a eficiência é pelo menos 2 vezes maior que Huffman. Por isso vale a pena entender mais.







Imagina num texto longo fazer esse esquema de ponteiros. Pensa um livro por exemplo, centenas de páginas de texto. Se estivermos lá na última página e precisar fazer um ponteiro pra uma palavra na primeira página. Pra poder apontar tão longe significa que precisaríamos manter o livro inteiro em memória, megabytes de dados ou mais. Seria um puta desperdício de memória. E quando o algoritmo foi criado, no fim dos anos 70, sabemos que memória era hiper cara. Pensa que os melhores microcomputadores do começo dos anos 80 male male tinham 32 kilobytes de RAM. Então eu só posso manter pedaços do texto em memória enquanto vou descomprimindo, e por isso esses ponteiros não podem apontar pra tão longe no começo do texto.







Naquela época se reservava tipo 2 kilobytes, talvez 4. Esse bloco de buffer é o que se chama de sliding window ou janela deslizante, porque é como só desse pra ler o trecho do texto onde está essa janela. E os ponteiros só podiam referenciar dentro dessa janela, daí dá pra manter ponteiros usando poucos bits também. Quanto maior o sliding window, maiores as possibilidades de comprimir mais, mas mais RAM vai precisar. Então é um trade off. Hoje em dia RAM é barata, então dá pra ter sliding windows na faixa de megabytes. Porém quanto maior for o sliding window, maior tem que ser os ponteiros, daí ocupa mais espaço no total e comprime um pouco menos. É um balanço.







O primeiro grande sucesso que me lembro desse algoritmo surgiu na era dos BBS nos anos 80 pelo Phil Katz que inventou o formato ZIP, que usa esse algoritmo LZ77. Foi o famoso PKZIP que tinha os utilitário pkzip pra comprimir e pkunzip pra descomprimir. Quem daquela época não usou? Com a adoção pela Microsoft já naquela época o formato zip se popularizou, e embora outras coisas melhores tenham surgido, meio que virou o padrão até hoje. Com o tempo ganhou funcionalidades como encriptação, os famosos zips com senha que todo mundo que manja tem medo quando baixa, porque pode ser a pornografia que queria ou um malware.







Não confundir porque existem diversos formatos de compressão como zip, arj, rar, 7zip e outros que usam variações do algoritmo Lempel-Ziv. Uma coisa é o formato de arquivo, a estrutura de dados e metadados, outra coisa são os algoritmos que usam por dentro. E cada um usa estratégias diferentes pra tentar ultrapassar os concorrentes. Nos anos 80 mesmo surgiram diversas melhorias em cima do LZ77 como o LZSS ou Lempel-Ziv-Storer-Szymanski de 1982 criado por James Storer e Thomas Szymanski usado no bom e velho RAR. Lembram? WinRAR? O shareware que ninguém nunca pagou. Quem nunca baixou pirataria quebrada em vários arquivos de RAR?


 



No mundo Windows mais recente se popularizou o formato e ferramenta 7-zip, que é versátil e consegue lidar com outros formatos como o RAR ou ZIP originais, mas tem um formato próprio que usa outras variações do LZ77 como o Lempel-Ziv-Markov chain ou LZMA e LZMA2 criado pelo russo Igor Pavlov no fim dos anos 90. O Rar foi criado por outro russo, Eugene Roschal no começo dos anos 90. Naquela época pelo menos a gente falava que não podia subestimar um russo quando a questão era compressão de dados, porque entre RAR e 7zip eles contribuíram com alguns dos melhores formatos de compressão de arquivos.







Muitos desses formatos usam uma mistura de Huffman pra substituir letras ou palavras mais frequentemente usados por símbolos guardados num dicionário, aquela árvore binária de frequências e uma variação de Lempel-Ziv como LZSS ou LZMA2 pra substituir repetições por ponteiros dentro de um sliding window. E como cada um ajusta essas diversas combinações de dicionários, sliding windows, tamanho de ponteiros e tudo mais é que varia tanto quanto conseguem comprimir, quanto de CPU e RAM vão gastar no processo. Mas em geral, quanto menor consegue fazer o arquivo ficar, mais processamento e memória vai gastar. 






Desenvolvedores web devem estão mais acostumados com o formato gzip, que é do começo dos anos 90 e é o mais usado em servidores web. Caso não saibam, toda página web que vocês navegam provavelmente vem compactada em gzip. Se não vem, deveria. O gzip usa o algoritmo deflate, que foi criado pelo Phil Katz pro PKZIP original. A patente dele já expirou e por isso podemos usar hoje de graça. Deflate e gzip são muito comuns no mundo Linux e é uma combinação do LZ77 e Huffman como expliquei. Aliás, toda linguagem de programação ou já tem ou tem bibliotecas pra todos esses algoritmos, deflate, huffman e tudo mais. Pesquisem.








Huffman, Lempel e Ziv são as fundações pra tudo que é compressão lossless, ou seja, que não jogamos fora nada dos dados originais e quando descomprime volta exatamente como era antes, diferente do esquema de JPEG em imagens. E falando em JPEG, o objetivo dessa longa tangente de história foi só pra poder voltar a falar do seu GIF de memes. Como falei antes, criado pela Compuserve em cima de outra variação do LZ77, o LZW que é Lempel-Ziv-Weich, do Terry Weich. Estamos falando de uma era antes da idéia de software livre. E naquela época patentear software era mais importante ainda, ninguém sabia como as coisas iam evoluir.







O erro foi que a Compuserve criou o GIF usando o LZW do Weich e deu certo, o GIF começou a se popularizar, especialmente quando a Web comercial começou a crescer e surgiram navegadores como o antigo Netscape, que adotou o GIF com um dos formatos de imagem suportado. Antes disso, no meio dos anos 80 o Weich vendeu as patentes pra Sperry Corporation, que fez merge com a antiga Burroughs, famosa por mainframes e pelo UNIVAC e que depois se tornou a Unisys, que existe até hoje. Pois bem, a Unisys ficou sabendo desse tal de GIF usando as patentes deles sem pagar nada e em 1987 começou a negociar com a Compuserve.







Ninguém tava muito ciente disso e todo mundo continuou usando. Aí em 1994 eles anunciam que esperam que todo mundo que usasse e distribuisse GIFs precisaria pagar licenças. Imagina se tivesse Twitter em 1994, todo mundo ia ficar putaço e ia cair matando cancelando a Unisys. Como assim querem taxar meus memes?? Aí em 1995 o Thomas Boutell anunciou na usenet, que era tipo nosso Reddit da época, uma proposta pra resolver isso. Que seria todo mundo largar saporra de GIF e trabalhar num formato melhor e mais moderno. E daí nasceria o PNG ou Ping.






Deu tão certo que já em 1996 a W3C, que é quem define os padrões da Web, adotou e oficializou o PNG. Mas então significa que todo mundo distribuindo GIFs de memes hoje tá infringindo patente da Unisys? Felizmente não, porque a patente já expirou lá por 2004 e a gente voltou a usar GIFs porque apesar do PNG ser infinitamente superior, ele não suportava animações. A única função que GIF tem é pra memes animados. Até existe um formato de PNG animado que é o APNG mas demorou muito pros navegadores adotarem. Ele já foi criado tarde, pela Mozilla, em 2008. Mas Chromium só adotou em 2017 e por tabela navegadores baseados em Chromium como Microsoft Edge só vieram a adotar depois. Você sabia que tinha APNG? Pois é, nem eu.







PNG é bem versátil, suporta imagens de poucas cores como GIF, só com 8-bits de cor, mas dá pra subir pra imagens pra 24 bits ou 32 bits. Também suporta um canal de alpha pra transparência de qualidade infinitamente superior ao GIF e por isso é muito adequado pra desenvolvimento Web. E ele usa um sistema de otimização da paleta de cores pra facilitar ter sequências de repetições, é tipo filtros que não degradam a qualidade da imagem mas facilita depois usar o algoritmo Deflate. Lembra? Baseado em Huffman e LZ77, que o gzip usa? PNG é comprimido com Deflate, portanto, diferente de JPEG, ele é lossless.







Depois do PNG surgiram outros formatos como o WebP do Google. Mas nem vou falar do WebP, WebM, codecs como VP8 ou VP9 porque apesar de bons não se tornaram populares. Aliás, toda vez que esbarro numa porcaria de WebP quero xingar porque a adoção é tão baixa que pro Photoshop abrir eu preciso instalar um plugin por fora. Um JPEG faz compressão na casa de 20 pra 1. Um PNG faz compressão na casa de 4 pra um. São ordens de grandeza menos. Mas um WebP é só uns 25% melhor em compressão que um PNG. Eu sei que tem outras vantagens, mas a diferença é muito pequena pra trocar tudo de PNG pra WebP e por isso continuo usando PNG pra tudo. Se eu quero uma foto altamente comprimida, vou usar JPEG. Se quero uma foto razoavelmente comprimida mas mantendo os detalhes do original, vou usar PNG e ponto.







Vamos voltar pro assunto principal. Lembram o objetivo? Eu quero assistir um filme de 2h em 4K na minha TV nova. Mas o arquivo não comprimido de video, a gente fez as contas, e ia precisar de uns 5 teras. O máximo que conseguimos fazer foi converter de RGB pra YUV 4:2:0, que joga fora informações do canal de chroma que a gente não percebe, que é o chroma subsampling. Mas mesmo assim o tamanho do arquivo cai só pra 3 teras, que continua sendo coisa pra caramba.







O que é um video. É basicamente uma sequência de imagens. Por que não comprimir cada imagem em PNG então? Já cairia o tamanho de tudo 4 vezes. Não muda muita coisa porque isso só diminui o video de 5 pra 1 terabyte. 1 tera é o tamanho total dos HDs de metade de vocês aí assistindo. Eu chuto que a maioria deve estar com HDs de no máximo uns 512 giga. Ou seja, tá chegando perto, mas ainda não dá. Então a próxima escolha óbvia é comprimir cada quadro do frame em JPEG, e aí vai ficar 20 vezes menor né? Sim, isso diminui os 5 teras originais pra 256 gigabytes! 







Caraca olha só! Significa que se eu comprimir em JPEG já cabe 2 filmes no HD de vocês. Sucesso. Fim do episódio, deixem seu like e assinem o canal! Tô zoando. 256 gigas é um puta avanço, mas ainda não dá. Com conexão de 50 megabits que é o que a maioria de vocês aí deve ter, ia levar nada menos que 12 horas pra baixar. Não rola fazer streaming disso porque assistir um filme de 2 horas precisando de 12 horas pra baixar, só se você assistisse beeeeem em slow motion.






Falando em velocidade de internet, esse é o requisito pra streaming. 50 megabits é por volta de 6 megabytes por segundo, no máximo. Pra eu conseguir assistir um filme de 2h nessa velocidade, considerando uma conexão perfeita, que não engasga nem desconecta, ou seja, sem considerar buffer, significa que o tamanho máximo do arquivo do filme teria que ser menos 6 megabytes por segundo vezes 7200 segundos, ou seja, 42 gigas. Esse é o máximo, na realidade tem que ser menos que isso. Então precisamos dar um jeito de pegar o video compactado com JPEG que deu 256 gigas e comprimir 6 vezes ainda.






Aliás, realmente existe formato de video que comprime os quadros em JPEG. O Motion JPEG ou M-JPEG. É um dos componentes que depois se torna o que você conhece como MPEG1 que se usava nos antigos Video-CD, ou MPEG2 que se usava nos antigos DVDs. Ou o MPEG4 também chamado de AVC, Advanced Video Coding, que você conhece como H.264 que é o codec que a maioria dos videos aqui do YouTube, Netflix e outros usam. Na verdade a gente tá migrando pro H.265 mas já falo dele. Aliás, nomenclatura de tecnologias de imagens, áudio, video, é uma bosta. Tem três nomes diferentes pra mesma coisa, com um monte de versões diferentes, diferentes empresas usando nomes diferentes. É uma confusão mesmo. Se esses nomes te confundem, você não tá sozinho. Mas vamos nos ater ao básico.







Não necessariamente a compressão é o JPEG igualzinho das suas fotos mas sim um algoritmo de compressão baseado em DCT, transformada discreta de cosseno, então seria tipo variações das técnicas usadas pelo JPEG. Mas como já vimos, precisamos de mais que isso. Como estamos chegando no final, não vou entediar demais com todos os detalhes, mas o pulo do gato é simples. Presta atenção aqui em mim. Como são meus videos? É esse meu cenário aqui atrás que fica imóvel e não muda absolutamente nada do começo ao fim do video, e sou eu bobão aqui na frente, falando e se mexendo que nem um idiota. Concorda que precisa só de um quadro com a imagem inteira e depois pode recortar só eu aqui na frente pro resto do video?






O que é um video? É um conjunto de imagens. A grosso modo uma câmera de video que nem essa aqui na minha frente tá tirando fotos de mim, 60 vezes por segundo. Num video de 1 hora tem 216 mil fotos. Toda a parte da imagem que é o cenário tá repetido em todas essas fotos, 216 mil vezes. Se eu arrancar fora esse cenário de todas as fotos, só de bater o olho você pode chutar que daria pra jogar fora pelo menos metade da imagem, concorda? Lembra como é mais fácil comprimir sequências repetidas de zeros? Olha quantos zeros tem aqui ao redor de mim agora.





É exatamente isso que um codec como o H.264 vai fazer. Ele vai primeiro gravar um interframe ou keyframe que é uma foto completa, como essa. Daí os próximos frames vai gravando o que se chama de intraframes, que são deltas. Sabe commit de Git, que é só o trecho que você mudou no código e não o arquivo original inteiro? Mesmo conceito. Então vai ter um interframe e vários intraframes na sequência com deltas. O correto da imagem inteira é falar interframe, mas vou falar keyframe pra ficar mais fácil de distinguir de intraframe.






Eu não lembro se a quantidade de intraframes era fixo ou se o codec detecta quando teve tanta mudança que é melhor pegar um keyframe inteiro de novo. Dependendo do codec ele pode escolher ser conservador e pelo menos o keyframe comprimir usando um algoritmo lossless como equivalente de PNG pra aumentar a qualidade e os intraframes usando um derivado de DCT, como um JPEG. Indo direto aos finalmentes, quanto que aqueles 5 terabytes consegue diminuir somando um esquema de JPEG com um esquema de inter e intrarames? 







Normalmente um filme por volta de 2h, em H.264 que é o codec mais usado atualmente, numa qualidade boa, próxima de Blu-Ray UHD que é a versão 4K, seria por volta de 20 a 25 gigabytes. Naquela mesma conexão de 6 mega por segundo daria pra baixar esse filme em aproximadamente 1 hora e 18 minutos. Ou seja, dá pra baixar todos os bits do video em menos tempo que a duração do video, que é o pré-requisito pra ser possível fazer streaming, que é poder começar a assistir enquanto o video vai baixando no fundo. Ou seja, atingimos nosso objetivo de conseguir assistir o filme via streaming na TV nova 4K!







E é exatamente isso que acontece no YouTube ou Netflix. Os videos em 4K de 30 quadros por segundo são encodados em H.264 com um bitrate de 35 a 45 megabits por segundo, dependendo do video. Lembrando que o tamanho final de um video não é linear com a duração do video. Depende do tipo de conteúdo. Desenho animado, por exemplo, vai ser mais fácil de compactar do que um filme de ação com câmera que balança o tempo todo, famoso shaky cam, como nos filmes do Jason Bourne, porque fica bem mais difícil fazer delta intraframes. A qualidade da imagem também importa porque senão fica qualidade ruim quando faz color downsampling ou DCT. Por isso que vários filmes diferentes de 2h vão dar tamanhos de arquivos bem diferentes um do outro.








Tem bem mais otimizações que codecs modernos fazem. Eles avaliam movimentos rápidos entre frames pra tentar normalizar, diferente de cenas que são só pessoas paradas conversando por exemplo. Tem técnicas como compensação de movimento, que existe desde o MPEG2 dos DVDs. O H.264 ou AVC que é o codec de video mais difundido pra consumo foi lançado oficialmente por volta de 2003 e levou desde 1998 até chegar no formato final. E mesmo depois saíram revisões do formato. 






E já em 2004 começou os estudos pro sucessor que hoje conhecemos como H.265 ou HEVC de High Efficiency Video Coding que foi lançado por volta de 2013 e só em anos recentes a adoção ficou significativa. Na prática, se você edita videos, exporte em HEVC que os arquivos tendem a ficar quase 50% menores e com qualidade pelo menos similar ao H.264, mas pra isso ele gasta bem mais processamento do que o H.264. Lembram o que eu expliquei antes que podemos ajustar o algoritmo pra criar arquivos menores ao custo de mais processamento e mais memória?







Falando em quem edita videos, H.264 e H.265 são o que se chama de codecs de consumo. Assim como eu falei que JPEG é ótimo pra guardar suas fotos mas não pra editar, esses codecs de consumo é mesma coisa, ótimo pra poder baixar rápido e assistir, mas péssimos pra editar. Primeiro porque assim como JPEG eles fazem chroma downsampling, porque pra TV YUV 4:2:0 é mais que suficiente e você não vai notar que jogamos fora metade da informação de chroma. Mas pra editar faz diferença, porque agora não temos cores suficientes pra trabalhar. 







Fotógrafos profissionais devem tirar fotos no formato RAW que usa compressão lossless, por causa do algoritmo deflate. Daí edita no Lightroom da vida e no final exporta em JPEG pra postar no Instagram. Mesma coisa video, o formato correto pra gravar nunca deve ser H.264 ou H.265 e sim Apple ProRes ou DNxHR ou CineForm ou outros formatos proprietários como o REDCODE, se usa câmeras da RED. Todos esses formatos são similares a zip, 7zip, rar, compressão lossless, que não joga informação fora. Eles tem diferentes taxas de compressão caso queira sacrificar qualidade de video por espaço de armazenamento.







Por exemplo, eu gravo meus videos aqui em DNxHR. E gravo no perfil que comprime mais e mesmo assim dá 1 gigabyte por minuto de video. Então se eu gravar 2 horas de video vai dar pelo menos 120 gigabytes. E se gravar com menos compressão pode chegar lá no 1 terabyte fácil. Quem edita videos profissionalmente precisa disso. Num H.264 final vai estar em YUV 4:2:0, mas no meu video gravado em DNxHR vai estar em YUV 4:2:2, ou seja, mais informação de cor. E pra ser agressivo era só gravar em ProRes 4:4:4 que é zero perda de informação de chroma. Agora você sabe o que significa ProRes 4444 versus ProRes 422.







Além disso H.264 usa o esquema de inter e intraframes. Acho que todo mundo já viu como se edita videos? Num programa como Adobe Premiere ou DaVinci Resolve. São programas de uma categoria que se chama NLE ou Non Linear Editing, edição não linear, ou seja, que eu posso editar qualquer ponto do video que quiser. Só que toda vez que eu peço um frame pra editar, só vai ter o intraframe, que é o delta, a imagem incompleta. Então precisa voltar alguns frames pra trás e localizar o keyframe completo, mesclar os dois e aí eu tenho a imagem inteira. Imagina navegar num clip de video pra frente e pra trás e toda horas precisar processar frames assim.







Com um codec profissional como o Apple ProRes ou DNxHR ele vai ter só keyframes. Então esses codecs são mais parecidos com o M-JPEG original, o Motion JPEG onde todo frame é um JPEG completo, sem deltas. Por isso, apesar do tamanho do arquivo de video ser ordens de grandeza maior, pra editar é muito mais performático, porque não precisa reconstruir os frames o tempo todo, eles já estão inteiros, é só ler. Um H.264 atrapalha pra editar e exige mais processamento e mais memória da máquina, por isso não compensa. Espaço em disco é barato, melhor plugar um SSD externo via Thunderbolt. Lembra dos meus videos explicando NAS e armazenamento?






Além de tudo isso que expliquei, nem toquei no assunto de áudio direito, mas assim como imagem crua de alta qualidade de câmera se usa o formato RAW, que comprime de forma lossless com alguma variação de LZ77, assim como video tem formato lossless como Apple ProRES, áudio também tem formato crú comprimido lossless como o FLAC ou os antigos WAV e AIFF. Mas também assim como imagem tem formato lossy de consumo como JPEG, video tem formato de consumo H.265, áudio tem alta compressão lossy com MP3 ou AAC, Advanced Audio Coding, que é o que costuma ir com video H.265 ou Blu-Ray. 





No final os conceitos básicos são os mesmos: não tem como guardar a informação analógica original 100%, por isso pegamos samples, como pixels no caso de imagens. Quadros por segundo no caso de video. E sample por segundo no caso de áudio. Ajustamos resolução, frequência, e fazemos transformações pra simplificar os dados quando queremos alta compressão. Ou só tentamos reduzir repetições se não queremos perder informação. 





Tem várias outras coisas sobre compressão que nem mencionei, por exemplo, sistemas de arquivo que suportam compressão. No Windows com NTFS é possível ligar compressão e todos os arquivos no seu sistema vão ser comprimidos. Significa que toda vez que salvar vai levar um tempo a mais pra comprimir, e toda vez que tentar ler um arquivo vai levar outro tempinho pra descomprimir, e isso vai ser o tempo todo. Não sei quanto de overhead isso adiciona, até imagino que é rápido o suficiente pra não se notar na maior parte do tempo, mas considerando que espaço em disco hoje é super barato, não acho que compensa fazer isso. É muito mais inteligente comprar um HD externo USB barato e jogar o que não precisa pra lá em vez de deixar seu sistema inteiro lento o tempo todo por conta de poucos megabytes economizados. E ele provavelmente vai usar o equivalente de um zip na menor compressão pra não demorar demais, então não comprime nem de perto tanto quanto um zip de verdade.






Enfim, o objetivo do video de hoje era usar a desculpa de video pra explicar o básico de tudo que existe sobre compressão de dados, incluindo as peças básicas mais fáceis que você pode treinar em qualquer linguagem de programação como Run-Length, Huffman, Lempel-Ziv, pra comprimir textos e depois ficar curioso pra aprender mais sobre séries de Fourier e transformada discreta de cossenos que, como vimos, você usa diariamente e nem sabia disso. Agora que sabe, se é de ciências da computação, não custa nada ir perguntar pro seu professor de algoritmos ou pesquisar por conta própria. Espero que isso tenha aumentado sua percepção do que acontece por trás dos panos das atividades mais simples que fazemos no dia a dia, como assistir este video no YouTube. Se ficaram com dúvidas mandem nos comentários abaixo, se curtiram o video deixem um joinha, assinem o canal e compartilhem o video pra ajudar o canal. A gente se vê, até mais.

