---
title: "[Akitando] #122 - Detecção e Correção de Erros | Introdução a Redes Parte
  2"
date: '2022-07-13T10:50:00-03:00'
slug: akitando-122-detecao-e-correcao-de-erros-introducao-a-redes-parte-2
tags:
- hamming
- reed-solomon
- checksum
- burst error
- raio cósmico
- cosmic ray
- eleição
- votos
- NAS
- RAID
- redundância
- akitando
draft: false
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/3W-8TQJwuWY" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Apesar de ser Parte 2 da mini-série de redes, vou falar pouco sobre redes propriamente ditas e focar em um aspecto que tem a ver com mais coisas que só rede: detecção e correção de erros.

Já se fez essa pergunta? Dados são transmitidos como ondas eletromagnéticas por cabos de cobre ou sem fio. Bits são gravados magneticamente em mídias como HDs ou Blu-Rays. Como que nenhum bit nunca é gravado ou transmitido errado? E se é, como poderíamos saber se 1 único bit é entendido errado?

Mas não se preocupem, apesar de não ser diretamente "redes" é importante saber o episódio de hoje, mas no próximo episódio vou realmente mostrar mais de "redes".

## Conteúdo

* 00:00 - Intro
* 01:20 - Recapitulando RAID-0 e RAID-1
* 05:37 - Bit Rot, Bit Flip e Raios Cósmicos
* 10:37 - Hamming Code
* 15:11 - Hamming e Cartões Perfurados
* 15:53 - Eficiência de bits de paridade
* 19:37 - Checagem de erros em rede
* 20:51 - Usernet e Par2
* 24:23 - M-Discs
* 27:27 - Data Scrubbing
* 28:40 - Conclusão
* 29:43 - Bloopers


## Links

* WHAT CONNECTS AN INCIDENT IN 2003 WITH SPACE, ASSEMBLY ELECTIONS, INTEL, AEROSPACE AND ELECTRIC CARS? (https://www.linkedin.com/pulse/what-connects-incident-2003-space-assembly-elections-intel-jogani/)
* How An Ionizing Particle From Outer Space Helped A Mario Speedrunner Save Time (https://www.thegamer.com/how-ionizing-particle-outer-space-helped-super-mario-64-speedrunner-save-time/) 
* COSMIC RAY FLIPS BIT, ASSISTS MARIO 64 SPEEDRUNNER (https://hackaday.com/2021/02/17/cosmic-ray-flips-bit-assists-mario-64-speedrunner/)
* Bit Rot: What It Is and How To Stop It From Destroying Your Data (https://getprostorage.com/blog/bit-rot-stop-destroying-your-data/)
* How to send a self-correcting message (Hamming codes) (https://www.youtube.com/watch?v=X8jsijhllIA)
* Hamming codes part 2, the elegance of it all (https://www.youtube.com/watch?v=b3NxrZOu_CE)
* What is error correction? Hamming codes in hardware (https://www.youtube.com/watch?v=h0jloehRKas)
* Reed–Solomon error correction (https://en.wikipedia.org/wiki/Reed%E2%80%93Solomon_error_correction)

## SCRIPT

Olá pessoal, Fabio Akita


No episódio anterior eu quis trazer algumas noções de como dados trafegam por redes cabeadas ou wireless. Isso porque ultimamente andei brincando com coisas como meu novo NAS. Mas antes de poder falar dele e coisas que andei prometendo como Docker, achei que finalmente chegou a hora de falar um pouquinho sobre redes. Como já tinha falado antes, estou longe de ser especialista de redes, então quero explicar as coisas do ponto de vista mais de alguém que é programador e usa a rede mais do que monta redes.






No episódio de hoje quero explorar o motivo de porque eu montei um NAS: evitar perder dados. A maioria das pessoas hoje tá acostumado a um mundo plug and play, sempre conectado, serviços de cloud e tudo mais e tem muito menos preocupação com seus dados. Na real, a maioria não tem dados tão importantes que se perder vai ser um grande problema mesmo. Por isso acho que não tem problema. Se perder, perdeu. Se doeu, deveria ter se precavido. Mas programadores eu acho que deveriam ter um pouco mais de cuidado, especialmente porque lidam com dados dos outros.






Sobre isso tem dezenas de assuntos que poderíamos falar, como segurança de dados, mas hoje quero falar só sobre os blocos mais básicos de como erros podem acontecer e como a ciência da computação vem resolvendo esses problemas desde pelo menos os anos 60.




(...)







Veja meu NAS. Ele está construído numa configuração RAID-6. Mas vamos falar de novo do formato mais simples, só 2 HDs. Se ainda não assistiu minha playlist de armazenamento, vou resumir só essa parte de novo. Com dois HDs eu posso fazer 2 coisas: escolher segurança ou escolher performance. Se eu for um gamer que posso baixar tudo de novo da Steam caso perca os HDs, talvez faça sentido colocar em modo RAID-0. Nesse modo o sistema operacional vai enxergar os dois HDs num único volume lógico. Se os HDs tem 1 terabyte cada, em RAID-0 o volume lógico, o meu "C:" no Windows, vai ter 2 terabytes inteiros e vou ter quase o dobro de performance, porque posso escrever nos dois ao mesmo tempo.









Lembram o que já expliquei antes sobre arquivos e transmissão de dados em geral? A maioria das pessoas olha um Windows Explorer e assume que a menor unidade são arquivos. Os sistemas operacionais escondem os detalhes e mesmo programadores só lidam no máximo com arquivos na maior parte do tempo. Mas isso é ineficiente. HDs não são dispositivos de arquivos, são dispositivos de blocos. Por isso o serviço da Amazon onde posso instalar um HD virtual na minha máquina virtual do EC2 se chama EBS ou Elastic Block Store. Ele nos dá um dispositivo de blocos. Eu explico isso nos videos sobre armazenamento, assistam lá depois.







No episódio passado eu falei que comunicação de redes usa hoje em dia comutação de pacotes. Pacotes são essencialmente blocos de bits. Por isso tenha na cabeça que tanto arquivos no seu sistema como transfência desses arquivos pela rede, acontecem de forma fragmentada, um pacote de cada vez e não um arquivo inteiro de uma vez. Por isso tenho o dobro de performance num RAID-0. Se o sistema só enxergasse arquivos, quando fosse gravar, gravaria o arquivo inteiro só em um HD, daí a velocidade máxima seria só desse HD.







Mas como na realidade a partição é uma tabela que tem um registro dizendo "arquivo hello.mp3 tem 2000 blocos de 4 kilobytes cada, e os blocos de ID 1 até 1000 estão no HD 1 e os blocos de 1001 até 2000 estão no HD 2", daí ele pode mandar gravar os blocos nos dois HDs ao mesmo tempo, e por isso eu tenho mais velocidade tanto pra ler quanto pra gravar, porque o arquivo pode ser segmentado nos dois HDs. Mas também por isso esse sistema de RAID-0 tem um grande calcanhar de aquiles: e se um dos HDs sofrer um defeito e morrer?







Se um HD morrer, você perdeu tudo dos dois HDs. Entenderam? Por que alguns blocos dos arquivos no HD que está vivo estavam no HD que morreu, então você ficou com um monte de arquivos quebrados que não servem pra nada. Por isso que você nunca deve usar RAID-0 se os dados que tiver sejam importantes. Se era só pra games que você pode recuperar tudo depois, beleza. Compra outro HD, remonta o RAID-0, formata tudo, reinstala o Windows do zero e baixa tudo de novo da Steam. A importância aqui era a performance e os dados tinha backup fora, então ok.








Mas se vai misturar com trabalho, e coisas que se perder vão te dar prejuízo, e só puder comprar dois HDs, então coloque eles em RAID-1. Esse é o sistema de espelhamento. O seu sistema operacional vai enxergar os dois HDs de 1 terabyte como se fosse um único HD de 1 terabyte. Toda vez que mandar gravar um arquivo, o sistema vai mandar todos os blocos pros dois HDs e fazer uma cópia idêntica, bloco a bloco. Então a performance vai ser a de 1 único HD, um pouco menos até porque agora vai ter o trabalho de gravar no outro HD também. Quando ler, não vai ter quase diferença. Em termos de performance, vai perder um pouco, então, qual a vantagem?







A vantagem é que se um dos HDs morrer, o sistema automaticamente elege o outro como HD primário e na prática você nem vai notar. Seu sistema não vai crashear e vai poder continuar usando tudo como antes. Zero perda de dados. Agora é só comprar outro HD, substituir o que falhou, e no próximo boot o sistema vai copiar tudo do HD que sobrou pro HD novo, criando outra cópia espelho. Aqui trocamos um pouco de performance e metade do espaço por segurança.







Pra entender os outros níveis de RAID com mais HDs, de novo, veja minha playlist sobre armazenamento pra entender mais sobre isso de blocos e redundância de HDs, mas pra hoje eu precisava que vocês tivessem na cabeça esse modelo de tradeoff de performance, segurança e redundância. Isso porque poderia parecer que um RAID-1 é perfeito e vai deixar seu sistema protegido. Isso é verdade até certo ponto. É muito raro de se ver, mas um evento que acontece é bit rot ou degradação de bit ou simplesmente bit flip.







Entenda, qualquer sistema de armazenamento, seja um HD mecânico, seja um SSD que usa chips NAND flash como também SD cards ou pendrives, seja memória RAM, tudo está sujeito a uma hora sofrer algum tipo de degradação. O melhor é quando a falha é bem aparente e ele pára de funcionar totalmente. O problema é quando ele continua funcionando mas os bits armazenados não são mais confiáveis. Tudo é gravado magneticamente. Informação é um linguição de bits. Bits são cargas eletromagnéticas, armazenadas ou transportadas num fio de cobre ou em ondas pelo ar. Qualquer tipo de interferência eletromagnética poderia flipar bits aleatoriamente.






Por isso existe blindagem e todo um processo de fabricação pra evitar ao máximo qualquer tipo de interferência externa, mas nada é perfeito. Escrevendo sobre isso me lembrou de duas historinhas que seria legal vocês saberem. Em 18 de maio de 2003 aconteceu a primeira eleição com voto eletrônico da cidade de Schaerbeek em Bruxelas. Milhões votaram eletronicamente pela primeira vez. Tudo correu conforme esperado até o dia de contar e checar os votos.






Aí a comissão da eleição notou duas coisas fora do comum. Primeiro porque uma candidata razoavelmente desconhecida ganhou milhares de votos a mais do que seria esperado. Mas a segunda coisa que foi mais absurda é que o total de votos foi maior do que o total de pessoas que votaram! Claramente isso é um problema e obviamente vocês imaginam o tanto de gente apontando o dedo um pro outro atrás de fraude. Teve diversas investigações pra entender o que aconteceu, se foi um bug ou manipulação, mas uma coisa chama a atenção. O excesso de votos contados dava exatamente 4096 votos. 







Pra todo mundo, 4096 é só um número, mas pra gente de computação, 4096 é um número muito específico. Se vocês não sentiram alguma coisa quando ouviram o número, precisam praticar mais, porque é exatamente 2 elevado a 12. Lembra quando eu falo que vocês precisam se acostumar a converter números decimais e pensar em binário? Um número é uma cadeia de bits, digamos de 32 bits. Se você flipar o bit na posição 13, vai dar esses 4096 a mais se lá estivesse zero. Não quer dizer que não houve fraude, mas é muita coincidência alguém que fosse fraudar pensar num número exatamente assim.







O objetivo não é detalhar o caso, então depois Googlem pra saber como foram as investigações, de fato encontraram bugs de segurança e coisas assim no software. Todo software de votação, ainda mais na primeira vez, ainda mais se não foi visto e revisto, testado e retestado e auditado por diferentes grupos de programadores independentes, certamente tem bugs importantes. Não é talvez, é certeza absoluta. Mas mesmo assim, nenhum dos bugs encontrados conseguia explicar esse acidente em particular. E uma hipótese que não dá pra provar, mas tem chances de acontecer, é que esse bit foi flipado por raios cósmicos.







Pois é, caso você não saiba, estamos o tempo todo sendo bombardeados por milhares de partículas subatômicas que vieram de explosões de Supernovas, que caem na Terra como raios cósmicos. Muitos experimentos delicados são feitos abaixo da terra, com muita blindagem, pra tentar minimizar o efeito desses raios, onde qualquer mínima variação da ordem de um elétron, pode mudar os resultados. Dependendo do estudo que achar pode encontrar que é possível ter 1 bit flip por gigabyte de memória por ano. Sabe aquela tela azul de Windows que só aconteceu uma vez e nunca mais e não teve motivo nenhum? Talvez tenha sido um bit flip de raios cósmicos.






Tem muito mais histórias do que essa das eleições e só mais uma que eu achei interessante porque é um assunto que eu gosto, foi num speedrun de 2013 de Super Mario 64, do usuário DOTA_Teabag. Speedrun pra quem não sabe é competição pra ver quem consegue acabar um jogo no menor tempo possível. Durante esse speedrun, ele esbarrou num glitch considerado impossível sem manipular o jogo. Num determinado pedaço da fase, ele tava simplesmente pousando numa plataforma e fez um warp pra cima do teto sem nenhuma razão. 







Todo mundo da comunidade tentou replicar isso, usando emuladores, replicando exatamente os passos do Teabag frame a frame com scripts, mas ninguém conseguiu replicar esse efeito. Isso porque pra realizar esse warp requer o que se chama de um single event upset que é fora do controle do jogador. A única forma de replicar o warp é fazendo um bit flip no número que representa o peso do Mario. Se você flipar 1 bit mudando de C5 pra C4 hexadecimal isso dá o peso exato pra fazer o warp pra cima naquele exato momento.







De novo, é impossível dizer que foi isso, mas a hipótese de novo é que raios cósmicos fliparam esse 1 bit naquela hora, causando o warp. Mas o ponto é que bit flips acontecem, e raios cósmicos é só mais um fator numa enorme lista de fatores que podem levar à corrupção de dados. Em particular quando usamos mídias magnéticas pra armazenar e transportar dados. E se tudo isso ainda não te convenceu, não precisa ir muito longe: quantos de vocês lembram da época de CDs piratas de games e como vocês gostavam de esfregar o disco na camiseta e mesmo o disco tendo vários riscos, ele ainda funcionava. Como pode essas coisas?








Isso é tudo pra vocês entenderem que erros e corrupção de dados são inevitáveis e se vocês nunca notaram isso é um testamento de como a ciência da computação já conseguiu resolver a grande maioria desses problemas e pra todo mundo, tudo simplesmente só funciona. Vamos recapitular. Imagine um arquivo de imagens como esse gato. Obviamente é sempre um gato. Mas o que a gente vê é a representação visual de um linguição de bits. Eu expliquei isso no episódio sobre compressão. Só por conveniência pra mostrar aqui na tela posso representar essa linha contínua de bits quebrando em várias linhas, digamos, em linhas de 11 bits. E eu posso organizar mais ainda cada linha de 11 bits como um bloco.







Em particular, vou organizar os 11 bits da primeira linha num bloco de 16 posições, numerado de zero a quinze. As posições 0, 1, 2, 4, e 8 vamos reservar e eu preencho as 11 posições seguintes com meus bits de dados. Agora vamos olhar metade dos bits e checar o que chamamos de paridade. Paridade é literalmente se temos um número par ou número ímpar de bits 1. Nesse caso temos 2 bits 1, então é par. E assim preenchemos o bit de paridade na posição 1 com zero. 







Agora olhamos o próximo grupo e checamos a paridade. Temos 3 bits 1, é ímpar então na posição 2 preenchemos esse outro bit de paridade com 1. Agora que vimos os grupos de colunas na vertical, vamos checar grupos na horizontal. Esse próximo grupo também tem número ímpar de bits 1. Portanto no bit de paridade da posição 4 preenchemos com 1. E finalmente checamos o último grupo, que também tem número ímpar de bits 1, portanto preenchemos o bit de paridade da posição 8 com 1. 







Finalmente, checamos a paridade do bloco inteiro. Temos 8 bits 1, é par, então o bit de paridade da posição 0 vai ser zero. Pode parecer complicado mas aguentem até o final do exemplo pra eu explicar o que estamos montando aqui. Nesse momento criamos um bloco de 16 bits pra carregar 11 bits de dados e 5 bits de checagem de paridade. Agora faz de conta que estamos transmitindo esse bloco pela internet, sujeito a todo tipo de interferência eletromagnética, erros de burst, degradação do material do fio e tudo mais, e um ou mais bits desse bloco vai ser flipado no meio do caminho. Mas na outra ponta a gente não sabe disso.








Agora a outra ponta recebeu esse bloco. Duvido que vocês lembrem de cabeça como era o bloco original, então vamos checar a paridade. Checamos o primeiro grupo e vemos número par de bits 1, então o bit de paridade na posição 1 está correto com zero e sabemos que a 2a e 4a colunas parecem ok. O próximo grupo tem um número par de bits 1 mas no bit de paridade na posição 2 está 1, o que é um problema. Sabemos que tem um erro em algum lugar nessas últimas duas colunas. Mas como já sabemos que a quarta coluna tava ok, o problema tá em algum lugar na 3a coluna.








Checando o próximo grupo, temos um número ímpar de bits 1 então o bit de paridade na posição 4 está correto sendo 1, portanto sabemos que a 2a e 4a linha estão ok. E no último grupo temos um número par de bits 1 mas o bit de paridade na posição 8 está 1 em vez de zero. Então temos algum problema nessa duas últimas linhas. Mas já sabemos que a 4a linha tava ok pela checagem anterior, portanto o erro tem que estar na 3a linha. E como já sabemos que tem algum erro na 3a coluna, cruzando as duas sabemos que deve ter um erro na posição 10. Esse bit foi flipado.







Mais do que isso, olhando o bloco inteiro, vemos que a paridade é impar, então no bit de paridade do bloco deveria estar 1 em vez de zero. Isso nos dá confiança de saber que só houve 1 bit flip e não dois, portanto só o bit da posição 10 foi flipado. E se mudarmos de 1 pra zero, jogarmos fora os 5 bits de checagem, temos o bloco correto original de 11 bits que foi enviado.








O que fizemos aqui foram duas coisas: nós tivemos a capacidade de checar a existência de um bit flip, e ainda tivemos a capacidade de recuperar o bit que foi danificado e recuperar o bloco inteiro. O que vocês acabaram de ver foi o algoritmo de correção de erros Hamming Code, nomeado depois de seu criador Richard Hamming. E essa é uma das formas que temos hoje pra correção de erros.







Essas animações devem ser familiares, porque peguei emprestado do excelente canal 3Blue1Brown, que fez dois videos excelentes dois anos atrás explicando exatamente como funciona o Hamming Code. E ele fez isso em conjunto com outro canal que vocês já viram eu mostrar aqui, o do Ben Eater, que implementou Hamming Code em protoboards, em hardware, pra demonstrar como é possível colocar correção de erros em hardware. Eu altamente recomendo que assistam os videos deles pra saberem em detalhes como que isso funciona. Eu assisti esses videos dois anos atrás e tava esperando uma oportunidade pra encaixar eles nos meus videos. Quem seguiu minha recomendação de seguir os canais deles já deve ter visto.








Richard Hamming é um pesquisador da época que se programava em cartões perfurados. Imagina você levar dias escrevendo um programa nesses cartões daí leva pra uma máquina mecânica que vai ler esses cartões através dos furos. Mas vira a mexe ele erra um furo e registra a informação errada. Se até hoje aquelas porcarias de máquinas de refrigerante não conseguem identificar seu dinheiro, imagina uma máquina mecânica velha que tem que ler centenas de cartões sem errar nenhum furo. Isso acontecia tanto que deixou o Hamming putaço. E não existe melhor forma de invenção do que não se acostumar com problemas e sim coçar a própria coceira. E assim ele fez, e inventou todo esse sistema de paridade do Hamming Code pra checar e corrigir erros. 








A gente usa Hamming Code até hoje em coisas como memória ECC ou Error Correction Code em RAM de workstations e datacenters. A memória que você tem no seu PC provavelmente não é ECC, mas o servidor de cloud que armazena seus dados certamente tem ECC. E é por isso que coisas como raios cósmicos não são aparentes no nosso dia a dia. Outra forma de correção de erros é o Reed-Solomon Code, que é usado em CDs e Blu-Rays e é por isso que mesmo você riscando o disco, esfregando na sua camiseta, ainda é possível ler os dados.








Mas o mais astuto entre vocês assistindo poderia pensar. Peraí, você tá me dizendo que pra um bloco de 11 bits eu precisei reservar mais 5 bits pra redundância. Ou seja, 45% do espaço e banda de transferência foi desperdiçado pra isso? Então num Blu-Ray de 40 gigabytes eu precisaria ter quase 20 gigabytes a mais só pra redundância? 






Mas o mais astuto do mais astudo entre vocês talvez tenha notado que eu fui fazendo checagens naquele bloco de metade em metade. Toda vez que em ciência da computação você vê procuras feitas de metades de metades deveria vir à cabeça procura binária. Lembra os episódios onde falei de árvores e porque árvores são uma das coisas mais importantes que todo programador deveria ter em mente?







Checamos 2 paridades de 2 grupos de colunas verticais, depois 2 paridades de 2 grupos de linhas horizontais. Num bloco pequeno de 16 bits precisamos fazer 4 perguntas de paridade pra localizar e corrigir o bit flipado. Mas e num bloco bem maior, de 256 bits? Vamos precisar fazer só 8 perguntas de colunas e linhas, e pra isso precisamos reservar só 8 bits de redundância. Ou seja, só 3% do tamanho dos dados e não 45% como era no bloco de 16 bits. Quanto maior for o bloco, menor vai sendo a quantidade de bits de redundância necessário. Esse é o poder da procura binária. E eis porque vocês precisam estudar algoritmos e estruturas de dados.







Estamos usando blocos de 16-bits só porque é mais fácil de colocar aqui na tela ou pra você ver no seu celular. Mas um bloco de sistema de arquivos costuma ter pelo menos uns 4 kilobytes de dados. Um bloco de rede costuma ter pelo menos 1500 bits. Mas em rede não se usa nem Hamming e nem Reed Solomon. Só pra coisas como programa espacial da Nasa, onde o Voyager por exemplo usa Reed Solomon Code pras transmissões. Hoje em dia se usa variações de Reed Solomon pra fitas magnéticas, CDs, Blu-rays e toda mídia de armazenamento, incluindo HDs. Você nem sabe disso, mas toda vez que um bloco de dados é gravado no disco, o sistema calcula esses bits de redundância e grava no lugar apropriado no HD.







Então tá resolvido tudo então? Só usar Hamming ou Reed Solomon em tudo que tá tudo certo? Mais ou menos. Por mais que eles sejam altamente eficientes e não gastem tantos bits assim, ainda assim são bits extras, pra cada bloco de bits. A indústria de HDs por exemplo vem pesquisando outras formas que sejam quase tão eficientes quanto Reed Solomon, mas perdem em 0.1% dos casos, como o LDPC code. Reed Solomon tem complexidade O(n^2) o que significa que pra discos gigantes de dezenas de terabytes leva muito tempo pra corrigir erros. Particularmente ruim em data centers que tem arrays com centenas de HDs. Um LDPC atinge 99.9% de recuperação comparado com Reed Solomon mas com complexidade O(n). É uma área ainda com pesquisas ativas.









Recuperar erros não só gasta bits extras de armazenamento como exige processamento pra fazer essa correção. Imaginem agora switches de rede em escala de internet. Por isso eu acho que em rede não se fala tanto em correção de erros e sim em checagem de erro. É muito menos trabalho identificar que tem um erro, mas não recuperar esse erro. Se você tá fazendo aquele download longo e vê a velocidade cair porque a internet da sua região é bem instável, não é tentativa de correção de erros que tá acontecendo e sim repetição de pacotes.








Em rede, funciona mais ou menos assim. Seu arquivão de download é quebrado em vários pacotes, enviados um atrás do outro. Seu PC vai recebendo esses pacotes e remontando o arquivo. Mas ele faz uma checagem antes. Essa checagem é parecida com a checagem de bits de paridade do Hamming Code, mas um pouquinho só mais sofisticado. No caso de internet falamos de checksum, em particular, Internet 16-bits. Esse checksum é uma soma dos bits do bloco dividido por palavras de 16-bits. Existem formas melhores como Fletcher's checksum ou CRC, que é Cyclic Redundancy Check. Mas eu acho que ainda se usa Internet 16-bits mesmo.








De qualquer forma, entenda que existe essa checagem via checksum pra cada pacote. Se for detectado que houve um bit flip ou coisas como burst, que é comum, o pacote é rejeitado e seu PC manda aviso de volta pro servidor, "olha, o pacote ID xpto veio cagado, manda de novo". Esse é NAK que falei antes. Daí o servidor manda o mesmo pacote outra vez. É um dos motivos de porque você vê a velocidade de download caindo e flutuando. No caso de rede é mais barato pedir o pacote de novo do que tentar corrigir ele. Correção é mais importante quando você não tem pra quem pedir uma cópia original, como arquivos no seu HD, que só você tem.







No começo da internet a gente usava um serviço chamado Usenet, que usava o protocolo NNTP. Pensa tipo um sistema de fóruns. Assim como o protocolo SMTP de email ou HTTP de web, era outro protocolo baseado em texto puro de 8 bits. Ele foi feito pra transmissão de texto e não arquivos binários. Pense em usenet como Wordpress que povo tenta entuchar mais coisa do que ele foi planejado pra fazer. Usenet foi feito pra sincronizar artigos de texto entre diferentes servidores Usenet. Mas obviamente, a gente achou jeitos de entuchar arquivos binários pra fazer pirataria. Estamos falando de uma era anos antes de bittorrent.








Eu mesmo fiz muito isso na faculdade. A gente baixava imagens, software e tudo mais da Usenet. O problema é que por diversas razões, os arquivos podiam acabar corrompidos. Erros de conversão. Erros nos discos rudimentares dos servidores da época e tudo mais. Mas o problema é que invariavelmente eles acabavam corrompidos. Primeiro, a gente precisa resolver o problema de trafegar arquivos binários num protocolo de textos.






Os mais astutos já tem a resposta na ponta da língua. Base64. É uma forma de transformar binários em textos de 7-bits. Base64 não é encriptação de jeito nenhum. O problema é que se você tentar abrir um arquivo binário num notepad, não tem como dar copy e paste em outro notepad e salvar o arquivo, vai corromper tudo, porque um editor de textos não reconhece todos os símbolos binários. A solução é converter o binário num sub-conjunto de ASCII que um editor de textos entenda e depois converter de volta num binário. O custo disso é gastar um pouco mais de espaço. 







Cada dígito de Base64 representa exatamente 6 bits de dados. Então 3 bytes de 8 bits cada do arquivo, ou seja, 3 x 8 ou 24 bits, podem ser representados por 4 dígitos de 6 bits, que dá 24 bits também. Isso significa que a versão Base64 do arquivo vai ser 133% maior do que o original. Um arquivo binário de 100 megabytes vai virar 133 megabytes em Base64.








Como arquivos podem ter tamanhos variados, como um filme longo por exemplo, ou o instalador do Photoshop ou coisas assim, pra Usenet não reclamar, a gente quebrava esse binários primeiro em múltiplos binários usando o bom e velho formato rar ou WinRar, porque assim como Zip ele compactava o arquivo, mas diferente de zip, ele permitia quebrar em múltiplos arquivos com final .rar2, .rar3 e assim por diante. E depois que baixava todos os rars, o WinRar conseguia remontar e descompactar o original.







Então o processo era simples: faz vários arquivos rar, converte em texto Base64, na época usando a ferramenta uuencode do UNIX, que significa unix to unix encode. Postava cada pedaço em um artigo da Usenet. Do outro lado a gente baixava o base64 de cada pedaço, usava uudecode pra conseguir os binários de volta, e usava um equivalente WinRar pra descompatar os arquivos originais. Era assim que a gente fazia antes de Google Drive, Mega ou BitTorrent.






Como disse antes, a Usenet não foi feita pra transportar arquivos, e por inúmeras razões, incluindo defeitos nesse monte de passos que a gente tinha que fazer, alguns bits acabavam corrompidos. Então a gente precisava de uma forma de garantir que dava pra recuperar de alguma forma após o download, caso notássemos que o arquivo veio corrompido. E aí surgiu a idéia do Parchive ou arquivos .par ou a versão melhor que foi o Par2. Agora você podia baixar os arquivos rar e também os arquivos par2, que era bem menores. E se o rar estivesse corrompido na hora de descompactar, podia experimentar recuperar usando os arquivos .par2.







E o que é Par2? É basicamente aqueles bits de redundância como no exemplo do Hamming Code, só que são os bits pra Reed Solomon Code, como eu disse que funciona pra CDs. Os primórdios da Internet era muito legal porque a gente era obrigado a aprender essas coisas se quisesse baixar pirataria. Eu me lembrei disso porque recentemente decidi fazer backup dos videos originais aqui do canal em M-Discs ou Millennial Disc, a evolução dos discos Blu-Ray. É tecnologia nova, de 2010 pra cá. E me perguntaram se não era bom eu fazer parchives pra gravar junto, eu até fiz, mas acho que não precisava.









De curiosidade pra quem não sabia, CDs, DVDs e Blu-rays comerciais comuns, vem com uma camada de proteção pra proteger contra riscos leves, aquela esfregada leve na camiseta. Porém, essa camadinha é feita de material orgânico que reage com oxigênio e umidade do ar. Significa que mesmo que você guarde com todo cuidado possível, eventualmente essa camada vai degradar e você pode acabar com um disco que não dá mais pra ser lido. Pode demorar 10 anos, demorar um pouco mais, mas é questão de tempo. Sua coleção de CDs não vai durar pra sempre a menos que esteja numa câmara a vácuo com zero umidade e temperatura controlada. E mesmo com os bits de redundância de Reed Solomon, você vai perder dados se essa camada danificar o suficiente.








Por isso escolhi M-Discs. Eles são basicamente Blu-rays só que a camada de proteção é feita de material inorgânico, não reagente, não oxidante. Só pra ter uma imagem, pensa uma camada de proteção feita de pedra. Em testes de mais de 250 horas sob temperaturas de 90 graus Celsius, 85% de umidade, mesmo assim os discos permanecem intactos. Por isso se chamam millennial discs, são discos feitos pra durar mil anos, sob condições adversas. Perfeitos pros meus backups. Alguns vieram sugerir fitas magnéticas, mas nesse mesmo nível de durabilidade, custam ordens de grandeza mais caro por gigabyte.






E eu disse que não precisava ter manualmente criado arquivos par2 com os bits de Reed Solomon Code porque um Blu-ray por padrão já tem esses bits. Hoje em dia tem poucos motivos pra se preocupar com bits de redundância porque a maioria dos sistemas de armazenamento modernos tem esse cuidado, incluindo seu SSD e seu HD. Só sua RAM que ainda não porque memória ECC é bem mais cara. Mas como no mundo caseiro a gente dá refresh nessa RAM porque bootamos toda hora, a chance de um bit flip causar problemas é muito baixa. De vez em quando, uma tela azul de Windows sem motivo nenhum, é a rara consequência que você vai encontrar.








Hoje em dia não precisamos baixar arquivos par pra recuperar downloads corrompidos, mas muitos sites de downloads você já deve ter visto um código md5 ou sha1 junto pra checar a integridade do binário. Eu já expliquei sobre isso no episódio de criptografia, mas um sha1 é um algoritmo de hashing, um tipo de checksum. Se baixarmos a ISO de uma distro de Linux, e tiver sequer um bit flip, passando por sha1 o hash resultante vai ser completamente diferente do hash original que deveria ser. Por isso é um mecanismo importante pra sabermos se não houve bit rot ou mesmo manipulação no meio do caminho. Sha1 é muito superior a uma mera checagem de paridade, mas também custa mais caro pra processar.







Menciono isso porque já que comecei falando de NAS, em sistemas de RAID como o Linux Raid ou sistemas de arquivos realmente modernos como Btrfs ou ZFS que expliquei no último episódio da série de armazenamento, eles oferecem proteção contra erros e exigem rodar uma tarefa em background com alguma periodicidade chamada Data Scrubbing. No ZFS tem um comando justamente chamado `scrub` pra isso, detectar e corrigir data rot.







No meu NAS também tem essa opção de agendar um data scrubbing a cada 3 meses ou o período que eu quiser. Não precisa rodar sempre. Mesmo o HD tendo suporte a Reed Solomon Code, nem isso garante que vai estar tudo ok. Checar e corrigir erros é uma tarefa que custa processamento e tempo, por isso não se roda toda hora. Ele vai usar coisas como checksum de cada arquivo, equivalente ao que falei de checar o hash depois de um download, pra ver se o arquivo está intacto. Isso exige ler e calcular em cima de todos os bits do arquivo. 

Por isso custa processamento. Se coisas como o checksum ou paridade não baterem, ele usa a cópia redundante do RAID pra reconstruir o pedaço com danificado. E vai fazendo isso arquivo a arquivo. Se tiver poucos erros é fácil de consertar, mas se deixar acumular por chegar num estado que é impossível recuperar, por isso se roda data scrubbing periodicamente.







Como disse antes, pra maioria de vocês, tudo isso é invisível. Se um pacote na rede é corrompido, seu sistema pede pro servidor reenviar os pacotes. Se um arquivo é levemente corrompido na hora de gravar no seu HD, ele tem sistemas pra se auto corrigir. Com exceção de desastres graves, você raramente tem problemas de ver corrupção de dados. Seu streaming sempre funciona, as páginas que carrega sempre vem inteiros, e tudo isso porque pesquisadores como Hamming, Reed, Solomon, Shannon e muitos outros criaram as bases pra que tudo isso funcione. Mas de qualquer forma é bom saber porque as coisas funcionam num ambiente hostil onde corrupção de dados deveria ser o normal. 








O objetivo desse episódio era complementar o que falei nos episódios de armazenamento, no episódio sobre compressão, e o anterior onde comecei a falar sobre transmissão de dados e redes. Viemos muito longe desde um simples telefone de copinho e barbante e agora você sabe porque. Se ficaram com dúvidas mandem nos comentários abaixo. Se curtiram o video deixem um joinha, assinem o canal e compartilhem o video pra ajudar o canal. A gente se vê, até mais.

