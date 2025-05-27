---
title: "[Akitando] #97 - Só Precisamos de 640 kB de Memória? | 16-bits até 64-bits!"
date: '2021-05-13T10:41:00-03:00'
slug: akitando-97-so-precisamos-de-640-kb-de-memoria-16-bits-ate-64-bits
tags:
- ms-dos
- RAM
- ROM
- NES
- '6502'
- PAE
- DEP
- ASLR
- 32-bits
- 64-bits
- EMM386
- akitando
draft: false
---

{{< youtube id="cTVXKfYOYxo" >}}

## DESCRIÇÃO

Um dia nos disseram que 640 kilobytes de RAM é o suficiente pra tudo que a gente precisasse. Isso foi no começo dos anos 80. Hoje quero mostrar como a gente lidava com essa limitação no MS-DOS, como era na geração anterior e como ficou na transição pra 32-bits, depois pra 64-bits, e porque isso é relevante pra você, como programador. 

Hoje vamos ter História!

Conteúdo:

* 00:00 - Intro
* 01:25 - Recapitulando Mappers de 6502
* 08:48 - MS-DOS
* 12:13 - Segmento:Offset = 20 bits
* 18:50 - HMA, UMB, EMS, XMS
* 23:31 - Config.sys
* 27:51 - modo protegido e virtualização
* 31:26 - AWE/PAE
* 32:17 - swap/page faults
* 38:42 - 64-bits
* 41:26 - NX Bit/DEP
* 47:25 - Conclusão

Links:

* Tutorial of ARM Stack Overflow Exploit – Defeating ASLR with ret2plt (https://www.fortinet.com/blog/threat-research/tutorial-of-arm-stack-overflow-exploit-defeating-aslr-with-ret2plt)
* How do ASLR and DEP work? (https://security.stackexchange.com/questions/18556/how-do-aslr-and-dep-work)
* Memory Prices 1957+ (https://jcmit.net/memoryprice.htm)
* Mastering x86 Memory Segmentation (https://www.eejournal.com/article/mastering-x86-memory-segmentation/)
* Configuring your MS-DOS properly (https://www.cubic.org/docs/configuring.htm)
* Autoexec.bat and config.sys information (https://www.computerhope.com/ac.htm)
* 4DOS Introduction and Installation Guide (https://wiki.preterhuman.net/4DOS_Introduction_and_Installation_Guide)
* The  GRUB  MBR (https://thestarman.pcministry.com/asm/mbr/GRUB.htm)
* NES EMULATION (https://people.ece.cornell.edu/land/courses/ece4760/FinalProjects/s2009/bhp7_teg25/bhp7_teg25/index.html)
* 6502 Instruction Set (https://www.masswerk.at/6502/6502_instruction_set.html)
* ROMs and Mappers: Why NES Games Can Be So Different On The Same Hardware (https://abad1dea.tumblr.com/post/187429390285/roms-and-mappers-why-nes-games-can-be-so)

## SCRIPT

Olá pessoal, Fabio Akita



Hoje vai ser um video bem puxado. O pior é que metade dos detalhes técnicos que vou explicar, na prática você nunca precisaria saber, mas quero explicar mesmo assim. Minha idéia é continuar um pouco aqueles vídeos de introdução à computação e videogames onde comecei a explicar sobre a arquitetura de 8-bits de processadores como o 6502 da nintendinho e acelerar em direção a como era nos PCs na era dos 16-bits e o que significa migrar pra 32-bits e depois pra 64-bits do ponto de vista de escovação de bits.




Se alguém tentou programar um pouco no fim dos anos 80, deve se lembrar da barreira dos 640 kilobytes de RAM. Boa parte de hoje vai ser explicar sobre o que era isso e como a gente fazia. Quem já começou hoje, na era de 64-bits, não sabe a sorte que tem de ter endereços sobrando de memória. Pra vocês vai ser bom pra entender porque programador velho fica ranzinza falando que programar hoje é bem mais fácil que antigamente. Vamos entender de onde vem isso.







Como eu falei antes, metade das técnicas que vou falar hoje e metade dos termos que vou falar são legados. Pense mais como curiosidade de museu do que alguma coisa que você deveria saber de cabeça. Mas acho que a noção de como as coisas funcionavam pode dar insights de como você enxerga programação hoje e como as coisas podem evoluir a partir daqui. Então vamos lá.


(...)





Vamos voltar um pouco atrás nos episódios. Vocês vão se lembrar que falamos rapidamente sobre os videogames de 8-bits, que usavam processadores 6502 ou derivados e como eles carregam dados de cartuchos, que são basicamente chips de memória ROM, com um certo range, ou intervalo de endereços. Toda vez que um jogo precisa de mais de 40 kilobytes de memória, o cartucho pode trazer um chip controlador, um mapper.










Eu expliquei isso no episódio sobre o NES, nosso Nintendinho, pra mais detalhes reveja o video no link acima. Mas basta lembrar que o 1o Super Mario é provavelmente um dos jogos mais complicados que se podia fazer dentro dos limites de 40 kilobytes de um cartucho sem mapper, onde temos uns 32 kilobytes pro código do jogo e míseros 8 kilobytes pros gráficos. Por isso as fases do primeiro Super Mario reusam os mesmos gráficos, os tiles e sprites, da primeira fase, mas só mudando a paleta de cores. Os inimigos são sempre os mesmos. E por aí vai.










Se a gente abrir o binário do jogo num emulador como o Mesen e olharmos a região chamada CHR do cartucho, aqui estão todos os gráficos do jogo inteiro. É só isso que tem no primeiro Super Mario. Pra conseguir caber tudo nesse espaço, os programadores tiveram que ser muito criativos. Exemplo famoso é ver esta tela da primeira fase. As nuvens e os arbustos usam os mesmos tiles, só muda a paleta de cores, tão vendo?










Lembram como nos episódios anteriores eu falei que o sistema operacional costuma dividir endereços de memória, segmentar regiões como Heap, Stack e outros? Mesma coisa pro 6502, em particular no NES. Por exemplo, a stack de um NES vai do endereço hexa 01A0 até 01FF, que dá 95 bytes. Aliás, toda vez que tiver dúvidas, abre uma calculadora como essa que vem no Windows em modo programador e faz a conta em hexadecimal, 1FF menos 1A0 e vai dar 5F que convertendo em decimal é 95. Apesar de parecer pouco, todo jogo de nintendinho, até os mais complexos, funcionam nesse espaço.










O código do programa em si fica entre os endereços 8000 a FFFF, divididos em bancos. Os bancos de programa costumam ser chamados de PRG. Se a gente olhar no emulador Mesen, dá pra puxar o que tem na ROM PRG. No visualizador ele começa do endereço 0 e vai até 7FFF. Quer dizer que é o endereço 0 desse banco, dentro desse segmento da ROM PRG. Mas nos endereços globais em vez de 0 é 8000.








De curiosidade, no cartucho do Super Mario o linguição de bytes começa com 78 depois D8 A9 10 8D 00 20 A2 FF e assim por diante. Podemos pegar qualquer tabela de conjunto de instruções de 6502, como esse aqui  pra converter em mnemônicos de Assembler. Daí podemos ver que 78 é a instrução SEI ou Set Interrupt Disable. Ele não tem parâmetros, então o próximo D8 é outra instrução, CLD que é Clear Decimal, também sem parâmetro.








Agora A9 é LDA, que a gente já tinha visto nos outros vídeos. É o Load Accumulator. Ele vai pegar o endereço seguinte, que é FF e carregar o que tiver lá no acumulador. Depois 8D que é a instrução STA ou Store Accumulator que vai pegar o que tiver no acumulador e mandar pro endereço 20 00. Como o 6502 é little endian, ele grava o low byte primeiro, então inverte e a gente lê como 00 20. Esse endereço é da PPU, que é o chip que controla os gráficos.









Em vez de ficar traduzindo assim byte a byte na unha, melhor usar um recurso do emulador Mesen que é o debugger. Ele traduz tudo pra gente. E olha só, veio exatamente o que acabei de falar a partir do endereço 8000. Assim como um binário ELF que é executável de Linux, um cartucho de NES começa com um cabeçalho de 16 bytes que vai dizer pro processador o que ele vai encontrar no cartucho. Por exemplo, os mappers que fazem trocas dos bancos de ROM pra ter mais espaço do que é possível endereçar.










Dependendo do tipo de cartucho, como do Super Mario que não tem mapper, que a gente chama de mapper zero, ele manda dar jump pro endereço 8000 que é onde tem a primeira instrução do jogo. Não dá pra endereçar mais de 40 kilobytes de ROM, mas com um mapper ele vai trocando os bancos de 16 ou 32 kilobytes dinamicamente. Dá pra ter quantos bancos você quiser. Eles respondem nos mesmos endereços, daí quando a gente pede pra trocar, os mesmos endereços passam a retornar dados diferentes. Quando a gente pede o endereço 8000 do banco 1 vai vir uma instrução. Se pedirmos o mesmo endereço 8000 mas do banco 2, vai vir uma instrução diferente. 









Bancos são como se fossem páginas, e endereços são linhas nessas páginas. Um jogo que usa no máximo 32 kilobytes de ROM PRG e 8 kilobytes de ROM CHR é como se fosse uma página de papel, e cada endereço é uma linha. Temos linhas que vão de 0000 até 2000 que costuma ser os 8 kilobytes de CHR e do endereço 8000 até FFFF que costuma ser os 32 kilobytes de PRG.









Com mappers, o jogo tem mais páginas, como um livro. A gente pede a página pro mapper, mas o número de linhas continua o mesmo. Então, a primeira linha da página 1 vai ser diferente da primeira linha da página 2 e assim por diante. Fica mais complicado porque a gente tem que saber de que página pedir dados, mas a vantagem é que mesmo com um número de linhas limitado por página, dá pra ter várias páginas extras e assim podemos ter um Super Mario 3 com mais de 200 kilobytes e jogos ainda maiores como o Kirby Adventure que saiu quase no fim da vida do NES com quase meio megabyte e por isso os gráficos eram quase o que um Super Nintendo faria.










Isso tudo dito, vamos ver os endereços de 0 a 2000, com ou sem banco de mappers. É onde ficam os tiles, os gráficos. Um sprite é feito usando uma combinação de tiles diferentes. E podemos atribuir diferentes paletas de cores. Com isso podemos reusar esses tiles pra coisas diferentes. O exemplo mais citado são os tiles de nuvem, que usam a paleta que faz ficar branco. Se escolher a paleta verde, vira um arbusto. E se o design for feito de maneira criativa, dá pra economizar muito espaço de tiles reusando com cores diferentes.









O objetivo desse exercício todo de endereços, intervalos de endereços, estruturas fixas como tiles e sprites, é pra relembrar que no começo da programação a gente começa lidando com as formas mais simples de representar e mapear dados. Do ponto de vista de uma CPU de nintendinho, a única coisa que ele sabe é manipular memória de 0 até FFFF. No caso do processador 6502, vai reservar alguns desses endereços em conjuntos de segmentos. Vai ser hardcoded que no endereço hexa 4016 é que você vai ler quais botões do controle foram apertados, por exemplo.











Apesar de 0 até FFFF ter um total de 65 kilobytes de endereço, parte desses endereços é reservado pros 2 kilobytes de RAM, pros controles, pro video, pro audio e vai sobrar perto de 32 kilobytes pra programas e 8 kilobytes pra gráficos, por isso eu falei que os primeiros jogos eram limitados em 40 kilobytes. Pra ter mais espaço, precisa usar truques como os mappers. Mas na prática é como se a CPU tivesse acesso a um arrayzão de 0 até 65 mil 535 posições. E se assistiu meu episódio sobre os Hello World, você já sabe como funciona um array.









Antigamente, a quantidade de memória que a gente tinha era super limitada. Hoje temos gigabytes de memória, mas mesmo assim ainda parece pouco. O maior jogo de nintendinho não tinha meio megabyte. Literalmente qualquer foto que você tira num smartphone tem megabytes de tamanho. Por causa disso a gente consegue organizar esses recursos de uma forma mais ergonômica pra programadores. Um desses confortos é não precisar acessar as coisas diretamente em endereços e fazer cálculos de offset de endereços pra achar as coisas.









Num nintendinho, o total de endereços é fixo em 16-bits, sempre vai ser no máximo 64 kilobytes de endereços. Pra ter mais que isso precisa de um mapper, um controlador que vai mapear páginas. É mais ou menos isso que a gente fazia em MS-DOS nos PCs dos anos 80. Todo mundo deve ter ouvido a famosa frase atribuída ao Bill Gates que dizia que PCs não precisam de mais do que 640 kilobytes de memória. Era o máximo que o DOS conseguia endereçar na época. 









Se você tava acostumado com micros de 8-bits com endereços de 16-bits, então o máximo que dava pra enxergar era 64 kilobytes. Em poucos anos ter 10 vezes mais memória parecia impressionante. Mas nós programadores sempre vamos dar um jeito de encher toda memória que tem. Toda vez que alguém disser “ah, o mundo só precisa de X gigabytes de RAM”, sempre vai aparecer um Chrome dizendo “hold my beer”.









No fim o MS-DOS também acabou adotando coisas similares a mappers de cartucho, mas em software. Vocês hoje em dia felizmente nunca vão ter que lidar com DOS, mas se um dia tiver curiosidade de usar um DOSBox ou FreeDOS seja pra rodar programas velhos ou pra games antigos mesmo, vai acabar esbarrando em alguns termos estranhos. O que eu vou explicar a seguir não vale mais pra PCs modernos, mas ter essa noção na cabeça pode ajudar a enxergar arquitetura de computadores de forma diferente, por isso acho que vale a pena. Não se preocupem em decorar números ou nomes que vou dizer, só tenta pegar a idéia geral.









O MS-DOS era um sistema operacional pra máquinas de 16-bits. Dessa geração pensar um Super Nintendo ou Mega Drive. Mas ele era compatível só com processadores tipo Intel 8086 e 8088 e inicialmente rodava no que passou a se chamar de modo real. Nesse modo os programas têm acesso a todos os endereços que era possível endereçar. Lembra que quando falamos em 8-bits ou 16-bits ou 32-bits em CPUs estamos falando do tamanho dos registradores. 







Normalmente o barramento de endereços tem tamanho de bits diferentes. Como no caso do 6502 do NES: era uma CPU com registradores de 8-bits mas que acessava endereços de 16-bits pra ler ou escrever valores de 8-bits na RAM. Eu expliquei como isso funciona em detalhes no video do Guia mais Hardcore de Introdução à Computação. Só lembre que o tamanho do registrador não é diretamente ligado ao tamanho dos endereços.









Com as CPUs saltando de 8-bits pra 16-bits, a gente poderia imaginar que a próxima geração de endereços ia melhorar e saltar dos 16-bits direto pra 32-bits. Isso porque parece que estamos só dobrando os números, mas se lembrem que isso são potências de base 2. O salto não é o dobro, linear, e exponencial. 16-bits endereçava no máximo 64 kilobytes, que mesmo pra época era bem apertado. Mas 32-bits é 2 elevado a 32 que seria 4 gigabytes possíveis. No meio dos anos 80, meros 2 megabytes custavam 600 dólares. 4 gigabytes - se fosse possível comprar - custaria nada mais, nada menos que mais de um milhão e duzentos mil dólares. 2 megas!





Aumentar o barramento de endereços pra 32-bits significa ter 32 pinos, mais transistores e tudo mais, o custo do chip aumenta bastante. Aí provavelmente eles pensaram, “cara, a gente tem um processador com registradores de 16-bits. Pra que dobrar a quantidade de bits nessa geração, se vai levar décadas pra existir 4 gigabytes barato?” 






64 kilobytes é realmente muito pouco. Se carregar uma planilha num Lotus 1-2-3 da vida, ia faltar memória bem rápido. Em vez disso vamos fazer uma gambiarra. Vamos criar novas instruções que peguem pares de registradores de 16-bits e vamos chamar um de segmento e outro de offset e com isso calcular um endereço de 20-bits. Em vez de desperdiçar fazendo um barramento de 32-bits, 20-bits é mais que suficiente.






Com 16-bits você só consegue enxergar até o endereço FFFF, quatro Fs que chega ao máximo de 64 kilobytes. Colocando só mais 4-bits de endereços, temos a capacidade de endereçar até 2 elevado a 20 que dá 1024 bytes ou 1 megabyte de endereços. É 16 vezes mais memória que a geração do Nintendinho. Esse é o poder da exponencial, não se esqueçam disso.






Vamos entender essa gambiarra, não seria um endereço linear de 0 até FFFFF, ou 5 Fs. Porque os registradores eram de 16-bits. Então precisava dar um jeito de usar dois valores de 16-bits pra calcular um endereço de 20-bits. Era horrível programar em baixo nível naquela época. Eu felizmente não precisei, mas tenho dó de quem usava Assembler de 8088.




Os endereços podiam ir de 0000:0000 até FFFF:FFFF, notem os dois pontos. Olhando assim parece um endereço de 32-bits. Mas são só 2 valores de 16-bits um atrás do outro. Na verdade você pega o primeiro segmento e multiplica por 16, hexa 10, que é o mesmo que fazer shift pra esquerda e colocar um zero. Daí você soma com o segundo segmento, que é um offset. É que nem um array, onde você tem o endereço do começo do primeiro elemento e vai somando com um offset pra cada posição. Offset é uma coisa que você vai sempre ver em computação, então vale estudar se ainda não entende.









Essa fórmula é arbitrária. Literalmente tiraram da bunda. Daí um endereço segmentado de FFFF:0010 é igual a FFFF * 16 bits ou 0x10 em hexa, que vai dar FFFF0 mais o offset 0010 que vai resultar no hexa 100000 que é o último endereço do limite de 1 megabyte quando você tem só 20 linhas de endereçamento.






Mas o maior endereço que dá pra representar concatenando dois valores de 16 bits é FFFF com FFFF. De novo, faz o primeiro FFFF shift pra esquerda que dá FFFF0 mais o offset FFFF que vai dar o endereço de 20-bits 10FFEF que é quase 64 kilobytes acima de 1 megabyte. Esses 64 kilobytes no topo dos endereços é conhecido como HMA ou High Memory Area, porque fica na parte mais alta dos endereços.







Nos processadores 8086 e 8088, quando o processador recebia uma requisição pra um endereço acima do 1 megabyte que é FFFF:0010, ele fazia um wrap, ou seja, truncava os primeiros bits mais da esquerda, então 100000 virava 00000, 100001 virava 00001 e assim por diante. É mais ou menos que nem fazer o módulo por 100000. Lembra que nos episódios anteriores falei que era importante ter noção de módulo. 







Se a memória fosse uma fita de papel, com posições numeradas de 0 até 100000, é como se eu pegasse a ponta final dessa fita e grudasse com a ponta inicial 0 e aí viraria um anel. Quando chega no último endereço FFFFF, ele volta pro 0. Por isso nunca chega no endereço teórico máximo que falei agora, o 10FFEF porque truncando os primeiros 4 bits vira 0FFEF. Ele faz isso pra nunca tentar pegar um endereço alto inválido.







Mas os problemas não acabam aí. Se você parar dois segundos pra pensar nesse esquema de cálculo, vai ver que muitas combinações de segmentos e offsets acabam no mesmo endereço de 20bits. Sem pensar muito, peque o endereço 0001:0010 e 0002:0000. Faça a conta. No primeiro é 1 com shift pra esquerda que dá 10, mais 10 do offset vai dar 20. No segundo já é 2 shift pra esquerda que é 20 somado com 0 que é 20. Os dois vão chegar no endereço 00020. Tem mais de 4 mil combinações de segmento e offset que vão conflitar.








Isso é um problema porque você pode pensar que tá escrevendo num endereço e acaba sobrescrevendo em cima de outro errado sem saber. Parecem diferentes porque a notação de segmento e offset são diferentes mas ambos resultam no mesmo endereço real de 20 bits. Pra controlar um pouco a zona, virou uma convenção normalizar a notação. Então dentre essas duas opções que chegam no mesmo endereço, o correto seria escrever olhando a partir do endereço de 20-bits, enfiar os dois pontos entre os dois últimos hexa e chegamos em 0002:0000, que é considerado o endereço normalizado. 




Pensa que zona, na hora de programar ter que ficar calculando essas conversões de cabeça. Óbvio que mais cedo ou mais tarde vai dar pau. Fico imaginando que é um pouco o que engenheiros nos Estados Unidos sofrem se precisam trabalhar em projetos que é em sistema métrico e imperial ao mesmo tempo. Uma hora escreve em polegadas, depois em centímetros, depois em jardas, daí faz temperaturas em Fahrenheit e converte pra Celsius e assim vai até uma hora explodir um foguete.








Independente disso, de fato a gente não precisava de 4 gigabytes de RAM no meio dos anos 80, mas claramente mesmo 1 megabyte sendo 16 vezes mais que os pífios 64 kilobytes de micros como Apple II ou Commodore 64 ou o nintendinho, aplicativos de produtividade como Lotus, Wordstar, dBase, nos fizeram passar a usar mais e mais memória e 640 kilobytes rapidamente começaram a se mostrar insuficientes.






Diferente de micros antigos e consoles de videogame, a gente não tinha a opção de cartuchos em PCs. Primeiro que seriam mais caros. E mesmo ainda sendo caro, era melhor usar RAM. Com disquetes ou HDs, você precisa carregar os bits do programa na RAM pra poder usar. Com cartucho não precisava carregar porque ele já é o próprio chip de memória. Quando pluga o cartucho o programa já tá carregado e pronto pra usar. Por isso que com poucos kilobytes de RAM era suficiente porque não ia ser gasto carregando os programas. Mas em PCs, parte da RAM vai ser sempre usado pra carregar o sistema operacional e os programas e o que sobrar é onde você vai trabalhar seus dados.







Entenda o problema. Independente se a gente colocar mais memória, todo programa, incluindo o sistema operacional tipo DOS e seus clones como DR-DOS, drivers de video, drivers de áudio, tudo carregava na memória convencional de 640 kilobytes. Sobrava bem pouca memória. E os programas ficavam cada vez maiores. Rapidamente 640 kilobytes não ia ser suficiente. Mas a gente não pode usar endereços acima de 640k, ou seja a partir de A0000 até FFFFF, porque são reservados. Do A0000 até CFFFF é memória de vídeo. De F0000 até FFFFF é memória pra BIOS. E como existia a regra de truncar acima do endereço 9FFFF pra voltar pra zero, mesmo plugando mais chips de memória, não ia ter como endereçar eles.







Por isso começaram a pensar em formas de quebrar essa limitação de 640 kilobytes. As primeiras soluções foi fazer algo parecido com os mappers de cartuchos de nintendinho: uma placa pra ligar nos slots ISA da placa-mãe com mais chips de RAM, talvez mais 1 megabyte, e um chip controlador como um mapper que seria carregado em algum lugar nos 640 kilobytes de RAM convencional. Daí você chamaria alguma interrupção ou função do sistema pra fazer bank switching, que é a mesma ideia que já vimos de como ter um cartucho de mais de 40 kilobytes.





O trecho reservado de 384 kilobytes no alto dos endereços acima dos 640 kilobytes convencionais foi chamado de upper memory area ou UMA. E uma das primeiras gambiarras foi usar endereços nesse espaço pra endereçar a memória extra, enfiado entre os endereços de periféricos e da BIOS. Soluções desse tipo, com um hardware especializado, criavam o que a gente chamava de EMS ou Expanded Memory ou memória expandida. Daí a gente podia ter muito mais de 1 megabyte, talvez 8 megabytes, algumas soluções iam até 32 megabytes. Isso no fim dos anos 80, com processadores 8088. 







Se eu entendi direito, EMS usa um intervalo de endereços nessa região de memória alta reservada de 384 kilobytes, criando páginas pequenas, de 16 kilobytes, que é o EMS page frame. Daí seus dados poderiam ser carregados na memória acima de 1 megabyte e o driver de EMS vai fazendo page swaps de 16 kilobytes de cada vez. Bill Gates parece que odiava essa gambiarra. E era mesmo uma gambiarra, que se você entendeu como funciona bank switching de mappers de cartucho de nintendinho, é mais ou menos a mesma coisa. Quando saíram os 80386 aí não precisava mais de hardware especializado e o controle de EMS passou a ser emulado só via software.








Independente do EMS, a partir do 80286, você podia colocar mais pentes de memória e extender memória com endereços acima de 1 megabyte. Não dá pra carregar programas nesses endereços, mas você podia armazenar dados que um programa carregado na memória convencional podia usar. Tipo carregar o Lotus 1-2-3, que era o Excel da época, nos primeiros 640 kilobytes e as planilhas nos endereços acima de 1 megabyte, indo a um máximo de 15 megabytes.






Memória eXtendida é diferente da memória Expandida que falamos agora. Expandida é o EMS, que controla páginas de 16 kilobytes na memória alta e só funcionava com hardware especializado ou com os 80386. Mas nos 80286 passamos a poder acessar a memória acima de 1 megabyte. Pra isso precisava desligar o sistema de truncar endereços acima de 1 megabyte.







Resumindo até agora, a gente tinha memória convencional que são os primeiros 640 kilobytes de RAM onde carregava o DOS e seus programas. Daí tinha os últimos 384 kilobytes que era o UMA ou memória alta. Depois disso, antes do 80286, truncava os endereços. Acima da marca de 1 megabyte ainda tinha uma sobra de 64 kilobytes de endereços que se chama HMA ou high memory area. E com o 80286 agora temos a possibilidade de endereçar acima do 1 megabyte, a XMS ou memória extendida. No 286 ele chamou o esquema de ver memória até 1 mega e truncar como modo real, e pra acessar mais memória criou um conjunto de mecanismos e chamou de modo protegido. Você só podia estar em um desses modos de cada vez.






















Se você achou complicado a idéia de endereços de memória de 20-bits divididos em segmentos de 16-bits, num 80286 em vez de endereços de 20-bits, eles aumentaram pra 24-bits, o que dava pra endereçar um máximo de 16 megabytes. Mas com esse esquema de segmentação, em modo protegido, cada processo recebia um segmento virtual separado de até 8 megabytes. Mesmo se você tivesse 16 megabytes, poderia rodar dois programas, cada um mapeando até 8 megabytes de cada vez.







Pra acessar a memória extendida, XMS, a gente escrevia um arquivo chamado Config.sys que  o DOS carregava logo que bootava. Precisava pelo menos carregar o driver HIMEM.sys que significa High Memory. Hai-mém e não Hímem! Com o HIMEM.sys e colocando a diretiva de DOS = HIGH, UMB, significa que ele ganhava acesso aos endereços da memória alta, o segmento entre 640K e 1 megabyte. UMB significa Upper Memory Block. Isso carregava o sistema operacional nos blocos sobrando nessa memória alta. Daí dava pra carregar alguma coisa lá, economizando a memória convencional, já era um pequeno ganho.








Como era pouco espaço de blocos de memória alta, a gente carregar um gerenciador de memória lá, como o EMM386 da própria Microsoft. Originalmente ele ia servir como software de emulação pra memória expandida, o EMS, fazendo page frame na memória alta pra paginar a XMS. Mas depois passamos a não precisar fazer mais isso, então era só passar o parâmetro NOEMS pra EMM386. Combinando a HIMEM com a EMM386 ganhamos acesso à memória alta e à XMS. Daí tinha diretivas como LH que acho que era Load High e DRIVERHIGH que é literalmente carregar drivers na High Memory Area, que são aqueles últimos 63 kilobytes de endereços depois do 1 megabyte, que processador antigo truncava o endereço. 






Aliás, desde aquela época você vê que programador é bem pragmático pra criar nomes. Mas só no que expliquei até agora a gente tinha HIMEM e motorista bêbado com DRIVER HIGH. Vai vendo.









Raspando o tacho, pegando kilobyte livre onde dava, a gente economizava memória convencional, os primeiros 640 kilobytes onde roda programa, porque o sistema operacional DOS, e a maioria dos drivers como de placa de som, mouse, CD e tudo mais carregava ou na UMB ou na HMA e os programas conseguiam carregar dados na XMS. Economizar os 640 kilobytes era crucial pra carregar programas e jogos que cada vez ficavam maior. E na prática vira e mexe um programa não rodava mesmo porque faltava memória. Então essas otimizações todas não eram opcionais não.




E isso porque eu nem falei do CEMM da Compaq, do QEMM da Quarterdeck, do 386Max da Qualitas e outras soluções concorrentes pra gerenciar essa zona de memória. Entre o MS-DOS 3 até o MS-DOS 5 tinha várias combinações de gerenciadores de memória e alternativas ao MS-DOS como o concorrente DR-DOS da Digital Research. As coisas só ficaram menos ruins pra gente que era usuário quando saiu o DOS 6.2 que já vinha com todas essas ferramentas embutidas, como o EMM386, Memmaker, Scandisk e muito mais. E nesse meio tempo a Microsoft veio introduzindo o Windows 1.0, Windows 2.0.








Você pensa que daí não tinha como piorar, mas depois da introdução do modo protegido nos 80286, que era meio bugado, depois a introdução do modo Enhanced nos 80386, junto com Windows 2.0 pra 286 e Windows 3.0 pra 386, a coisa ficou mais confusa ainda antes de melhorar. Mas à medida que o Windows 3.1 com Enhanced Mode do Intel 386 começou a se popularizar, a necessidade de gerenciar memória na unha começou a diminuir. Com o 386 saltamos da geração de 16-bits pra 32-bits.








A importância de um Windows 95 foi dar um ponto final em uma década de bateção de cabeça da gente tentando extrair kilobytes da maldita limitação de 640 kilobytes de memória convencional, tentando entuchar o máximo possível nos kilobytes acima de 640 e ainda tendo que lidar com o esquema esdrúxulo que a Intel inventou de segmentação de endereços, fazendo aquele cálculo horroroso pra transformar dois registradores de 16-bits num endereço de 20 ou de 24 bits. Só que esse esquema se perpetuou nas APIs de 32-bits também.







Do ponto de vista do hardware, a gente começou no fim dos anos 70 com os processadores 8086 e 8088 com barramento de endereço de 20 pinos, ou 20-bits. Mas só tinha registradores de 16-bits. Em vez da Intel juntar dois registradores de 16-bits e concatenar pra fazer um endereço de 32-bits, fizeram o esquema de segmento e offset. Com offsets de 16-bits a gente tinha que lidar com blocos de 64 kilobytes de cada vez. E os endereços acima de 1 megabyte eram truncados pra dar a volta.








Daí no começo dos anos 80 sai o 80286 que introduz o modo real que é como rodava o 8086 com endereços de 20-bits. E o modo protegido dava opção de memória virtual e protegida, que é a idéia do sistema operacional alocar tabelas pra controlar o endereçamento dos programas. A grosso modo, em vez de todo programa enxergar os mesmos endereços reais, vão enxergar endereços virtuais de uma tabela local, exclusiva pra cada programa, que é controlado pelo sistema operacional, que vai ser o único que enxerga uma tabela global. Um programa que assumia ter acesso a endereços reais de hardware quebrava nesse modo.







Com esse controle de tabelas, a idéia é evitar que um programa escreva em cima do endereço do colega do lado, que é uma coisa que acontecia o tempo todo quando a gente tentava rodar mais de um programa ao mesmo tempo num MS-DOS da vida usando TSR que é como os programas ficam ativos em background. A CPU 80386 foi o divisor de águas e que marca a transição mesmo pro mundo 32-bits. Nela Intel colocou uma funcionalidade de Virtual 8086, que faz programas MS-DOS rodarem em ambiente isolados, onde um não enxerga a memória do outro. 








Num Windows, quando você pede pra abrir programas de DOS ele abre o equivalente a uma máquina virtual. Virtualização, que é uma tecnologia da época dos mainframes, entrou no mundo de microcomputadores nessa época. E mesmo fora do Windows existiam alternativas de controladores de concorrência em modo texto como o ConcurrentDOS ou GEOS e mais, mas no final já sabemos que quem ganhou a concorrência foi o Windows mesmo. 







Hoje em dia não temos mais esse subssistema mas do Windows 3 até o Windows NT, isso era importante porque mesmo indo pra interface gráfica, a maioria dos programas mais importantes rodava em modo texto no DOS. Só a possibilidade de rodar mais de um programa de DOS concorrentemente, sem um crashear o outro, já era um bom motivo pra migrar pra Windows. O outro motivo era a uniformização das APIs pra programadores. Antigamente, tinha uma dúzia de empresas só fazendo gerenciadores de memória. Sem falar em outras coisas como drivers de áudio, drivers de video. Pra áudio precisava programar pra Sound Blaster, Adlib ou Roland. Pra video precisava manualmente tomar conta de modo CGA ou EGA ou VGA. Com Windows era uma API só pra tudo e o Windows lidava com hardware por trás.









Na era 32-bits as coisas ficaram um pouco mais fáceis. Finalmente a gente deixou pra trás essa ideia de ficar manualmente controlando memória segmentada e passamos a lidar com endereços lineares, mais parecido com lidar com arrays em qualquer linguagem. Quer uma posição específica na memória? Vai direto na posição em vez de ficar fazendo conta de segmento e offset. O único problema é que no fim dos anos 80 onde o normal era lidar com no máximo 1 megabyte, pular pra 4 gigabytes parecia tão difícil quanto mandar um foguete pra lua.







Eu disse que no meio dos anos 80, se desse pra comprar 4 gigabytes iria custar mais de um milhão de dólares. Uns 15 anos depois, em 1999, já era possível comprar 4 gigabytes. Apesar de ainda ser caro não era mais um valor impossível. Com menos de 10 mil dólares dava pra comprar. Um usuário doméstico não ia comprar e nem precisava de tudo isso. Mas em corporações que precisavam, agora tinha a opção. Ou seja, em menos de 2 décadas a memória ficou 100 vezes menos cara. E o limite de 32-bits já tava sendo batido em empresas que precisavam rodar bancos de dados, por exemplo.








Pra remediar isso inventaram Address Windowing, que é a técnica de reservar uma janela de memória dentro dos 32-bits pra endereçar mais páginas fora. Parecido de novo com a idéia de mappers de nintendinho ou EMS no DOS. Particularmente o PAE ou Physical Address Extension, implementado nos processadores Pentium. Isso permitia um Windows 2000 Advanced Server acessar até 8 giga de memória real ou um Windows 2000 Datacenter acessar até 32 giga. No boot você passa o parâmetro de `/PAE` pra habilitar isso na CPU. Na prática, cada programa de 32-bits continua só conseguindo enxergar o máximo de 4 giga de memória virtual. Mas se dois programas quiserem realmente encher esse tanto de memória, num Windows 2000 normal ou ia cair pra swap ou ia dar erro.








Aliás, nem falei disso. Em modo real, o programa enxerga a memória real do sistema. Se for 1 megabyte, vai ser só 1 megabyte e o programa que se vire pra usar alguma técnica como memory mapped files, ou seja, tirar pedaços de dados da memória e gravar num arquivo, e quando precisar daquele pedaço, recarregar do arquivo pra memória. Pra fazer isso, num sistema operacional moderno, o gerenciador de memória do sistema operacional divide a memória em páginas. É como se fosse um array de arrays. Mais corretamente, acho que é uma árvore B-Tree, como expliquei dois episódios atrás. Cada node era uma página de memória.






Quando a memória vai acabando, o gerenciador pode pegar algumas páginas pouco usadas e gravar em disco pra liberar espaço. Disco é ordens de grandeza mais lento. Mas entre acabar a memória e crashear ou ficar mais lento, a escolha costuma ser deixar mais lento. Mas aí quando o programa tentar ler uma página que não tá mais lá, vai dar falha de leitura de página, o famoso `page fault`, uma exceção. 






O gerenciador pausa o programa pra tratar essa exceção, se não tiver espaço sobrando na memória, primeiro grava mais páginas em disco pra liberar espaço, e depois carrega a página que você queria do disco de volta pra memória. Feito isso devolve o controle pro programa, e ele continua como se nada tivesse acontecido. É o mesmo conceito que a gente usa pra fazer cache. Se você já teve que otimizar tempo de resposta de aplicação Web com um memcache ou Redis, é o mesmo conceito no gerenciador de memória.







Você troca performance pra poder ter mais espaço do que caberia na memória real. Por isso falamos em memória virtual: o programa acredita que pode usar até 4 gigabytes, usando endereços de 32-bits. Ele pede essa posição de memória pro gerenciador de memória do sistema operacional. E esse gerenciador é que mapeia do endereço virtual pro endereço real. Por isso no 286 começaram a chamar esse esquema de modo protegido, porque quando dois programas enxergavam a mesma memória real, um podia escrever em cima dos endereços do outro. Mas agora eles enxergam uma tabela abstrata que o gerenciador de memória dá pra eles. Eles não tem acesso à memória real mais. Então esse gerenciador garante que um programa nunca vai acessar endereços do outro.







Com PAE é mais ou menos isso, ele tem mais tabelas virtuais e pede pra CPU mais memória, e ele vai dar memória acima do limite de 4 gigabytes. Do 386 em diante a própria CPU passou a ter um MMU que é Memory Management Unit, em hardware, que em CPUs com recurso de PAE vai ter endereço de 40 bits, e isso dá pra mapear memória real até o máximo de 1 terabyte. Só que ficar gerenciando essas tabelas virtuais também gasta espaço na memória. Você usa memória pra gerenciar mais memória, por isso a gente não tenta mapear o máximo teórico que na prática ninguém vai usar, pra não desperdiçar. Por isso o Windows de 32-bits limita de 8 giga até 64 gigas dependendo da versão.








Como expliquei antes, CPUs de 8-bits antigas tinham endereçamento de 16-bits. CPUs de 16-bits começaram tendo endereços de 20-bits, depois 24-bits. Aí saltamos pra processadores de 32-bits com endereços de 32-bits mesmo. Mas com PAE passamos a ter endereços de até 40-bits. Isso quem dá suporte é a CPU. Então um 386 de 32-bits não tinha como acessar mais que 4 gigas. Só com os Pentium de 32-bits e endereços de 40-bits que dava pra ir pra 32 gigas, 64 gigas ou até mais.







Outro problema é que você pensa que um programa tem acesso do endereço 0 até o endereço 4 bilhões e tanto que são os 4 gigabytes, de novo, como se fosse um lista linear. Pra visualizar na cabeça é melhor pensar assim mesmo. Mas internamente a memória virtual é segmentada como eu expliquei nos episódios de estrutura de dados. O sistema operacional precisa manter estruturas de dados como Heap, Stack e muito mais e pra isso ele reserva 2 gigabytes de endereço. Isso no caso do Windows. No Linux você podia compilar configurado pra reservar menos. E nos Windows Server você pode passar o parâmetro "/3" se não me engano, pro sistema operacional reservar só 1 giga pra ele e deixar 3 gigas pro programa.








Lembra que eu falei que tabelas virtuais de PAE usam espaço de memória? Então, esse é um exemplo de porque precisa reservar endereços. Você nunca tem o espaço total de endereços disponíveis. Um banco de dados com o SQL Server, rodando num Windows Datacenter, com PAE, com o flag /3 pra pedir mais memória, ainda assim vai ter no máximo 3 gigabytes. Então o que ele faz é subir mais de um processo, cada um com até 3 gigabytes. Se o servidor da época instalar o máximo de 64 gigabytes que o Windows Datacenter permitia, ele ia precisar subir e coordenar até 20 processos rodando em paralelo pra conseguir usar toda a memória real.






Uma coisa que eu ficava cabreiro naquela época é justamente só ter 2 gigas no máximo e eu ficava pensando: se existe essa opção de bootar com “/3” porque o Windows já não faz isso sempre por padrão pra me dar esse 1 giga a mais? E a resposta é porque nesse espaço reservado do sistema operacional fica mapeado os endereços pra bibliotecas compartilhadas, DLLs de sistema. E mesmo não ocupando os 2 giga ele pode ocupar endereços no fim desses 2 gigas. 







Mesmo tendo espaço vazio no meio, se ele usar os endereços mais pertos do fim, eu não consigo diminuir o espaço que ele reserva. Daí tem o conceito de fazer rebasing das DLLs, que é forçar elas a carregar nos endereços mais do começo pra eu poder diminuir esse espaço com o boot em “/3”. Pra isso precisava carregar o mínimo de DLLs possível. Drivers podiam se carregar em endereços no algo, por isso que só opções de servidor, com drivers controlados, é que costumavam dar essa opção.








Então, gerenciar memória nunca foi algo legal, sempre foi chato. Felizmente, diferente do que a gente precisava fazer com DOS, era menos chato se você programasse no mundo 32-bits porque nesse estágio Windows ou Linux já faziam o grosso do gerenciamento de memória e você só tinha que lidar com a memória virtual disponível por processo que eles dão pra você, mas quando viramos pro século XXI, era da Internet e servidores de bancos de dados, claramente a gente ia precisar de mais memória. 4 gigas pareciam infinitos em 1995, mas em 2005 era altamente insuficiente.







Por isso começou a corrida pros 64-bits no começo do século, com AMD Athlon, Intel Itanium e outros. Mas em resumo, hoje a maioria das pessoas estão em 64-bits, inclusive em celulares. 64-bits dá um total teórico de 2 elevado a 64 endereços que são inimagináveis 16 mil PETA bytes. Assim como em 1985 ninguém conseguia imaginar uma máquina com 4 gigabytes de RAM, em 2021 ninguém consegue imaginar uma máquina com 16 mil Peta bytes. E felizmente hoje, 4 giga DDR4 custa menos de 100 dólares. Nada mal partindo de 10 mil dólares no fim dos anos 90.







Porém, se você for milionário e quiser ir até o limite teórico de 64-bits que são os 16 mil petabytes, precisaria gastar na faixa de 400 bilhões de dólares. Pra dar uma noção, em 2019 se estimava que o Google inteiro tinha pouco mais de mil petabytes de dados, então estamos falando do custo pra guardar todos os dados do Google na RAM de uma única máquina, dez vezes.








Mesmo se você fosse um Jeff Bezos ou Jack Ma da vida pra jogar uns bilhões fora, ainda assim não ia conseguir usar esse tanto de memória. Isso porque ninguém imagina que a gente vai chegar perto desse número tão cedo, talvez nas próximas décadas. Então é desperdício otimizar o chip pra ter esse tanto de pinos de endereço e barramentos e controladores. Então o chip de fato tem registradores de 64-bits pra poder calcular números grandes numa única instrução. Mas o barramento de endereços é de 40 ou no máximo 48-bits, e não 64.










40 bits é um intervalo de endereços que vai de zero até 2 elevado a 40 que é exato 1 petabyte. Isso permite endereçar 16 mil vezes menos memória do que 64-bits. Nenhuma CPU moderna de 64-bits, seja um Intel Xeon, um AMD Epic, um Apple M1, um Qualcomm Snapdragon. Todos são capados na faixa dos 40-bits. Dificilmente alguém vai ter 1 petabyte de RAM numa única máquina. O mais comum em workstations hoje é a faixa de 256 giga. Um Mac Pro pode ir até 1.5 terabytes de RAM, que são 12 pentes de 128 giga DDR4. O custo hoje em 2021 pra isso é 15 mil dólares. 








Com o antigo PAE no mundo 32-bits começamos a pensar um pouco mais na segurança dos dados na memória. Com tudo que expliquei deve ter ficado claro que naquela época a gente precisava ficar caçando kilobytes em tudo que é canto pra carregar drivers. Então adicionar coisas extras como aparatos de segurança não só não era prioridade, como simplesmente não ia caber em muitos casos. Um vírus é minúsculo. Mas um antivírus é bem pesado.







Com a adoção em massa de computadores, especialmente por causa da adoção da Internet, surgiram muitos vírus e malwares e eles sempre tiram vantagem do entendimento de como endereçamento de memória funciona e como conseguir injetar código malicioso em algum endereço que vai ser executado. Pra mitigar isso, junto com o PAE veio a primeira idéia do bit NX, que significa no-execute.







A ideia é marcar certas áreas de endereços de memória virtual que não podem ser executados. Eu não sabia disso, mas parece que nos 80286, com a memória segmentada daquele jeito chato que expliquei, também dava pra controlar isso no nível dos segmentos. Mas em memória com endereçamento linear de 32-bits a partir dos 386, já não tinha mais segmentos nos endereços virtuais. Então eles inventaram esse outro jeito de conseguir saber quais endereços tem dados que não podem ser executados. Até então não existia essa distinção.









Isso é importante porque um programa pode ter instruções pra dar jump pra qualquer lugar. Se ele tiver um bug e tentar pular pra um pedaço de memória que só tem dados, vai dar crash e só. Mas se alguém notar esse comportamento e escrever instruções executáveis neste endereço, quando o bug acontecer e der jump, vai executar o código malicioso sem saber. Mas se o sistema operacional marcar como no-execute, esse código não pode ser executado e se tentar, a CPU vai impedir.








Esse bit NX permite o recurso de DEP de segurança que é Data Execution Prevention, que vai evitar que certas partes da memória sejam executáveis, como a stack dos programas. Em máquinas mais antigas que não tinham o bit NX ainda é possível ter recurso parecido de no-execute. Se os endereços fossem de 32-bits flat, lineares, seria mais difícil, mas isso são os endereços virtuais, como pra calcular o endereço real os chips da Intel precisam fazer aquele cálculo de segmento e offset, dá pra marcar regiões da memória por segmento. Se você entendeu tudo que expliquei hoje já consegue imaginar e vou deixar um link pra uma resposta que achei no site StackExchange que explica em mais detalhes se tiver curiosidade.







Mas pra fechar o assunto de memória, como cheguei até 64-bits, não daria pra finalizar sem pelo menos mencionar ASLR ou Address Space Layout Randomization. A gente escovou bastante bits hoje de propósito pra você entender que tudo funciona baseado em endereçamento. Você entendeu que a memória é segmentada. Segmentos são simplesmente conjuntos de endereços. Do endereço 0 até X fica a stack, do X+1 até Y fica a heap, de Y+1 até Z ficam endereços de periféricos, e assim por diante. Era assim no nintendinho de 8-bits, no 80286 de 16-bits, e assim por diante. 









Lembra toda a conversa sobre o limite de 1 megabyte, memória expandida e tudo mais? Pois bem, pelos motivos de se ter poucos endereços e também pra ser mais fácil de programar em baixo nível, os segmentos tinham endereços fixos. Se você for programar num nintendinho, tem certeza que vai achar a ROM a partir do endereço hexa 4020, por exemplo. Se for programar pra DOS num PC antigo, tem certeza que acima do endereço de 640 kilobytes vai achar os endereços de periféricos. E a mesma coisa se perpetuou em modo protegido, memória virtual e sistemas operacionais de 32-bits.







Eu expliquei que o Windows reserva um pedaço da memória virtual de 4GB pra segmentos internos. O tal  espaço reservado de 2 gigabytes. Lá vai ter coisas como a stack e o heap do programa, mas também DLLs que são bibliotecas compartilhadas do sistema. Quando seu programa precisar de alguma função do sistema, ela vai estar num endereço que você consegue enxergar dentro do seu espaço protegido. O problema é que tudo isso sempre vai estar em endereços fixos e conhecidos.







Se um vírus ou malware se injetar no seu programa, ele vai ter acesso a esse espaço de memória. Pior, se ele souber de um bug como um stack overflow, vai saber exatamente em que endereço fica a stack e vai saber exatamente em qual endereço injetar seja lá que código malicioso pra executar. Em 32-bits isso é muito fácil. Se você é gamer, muitos mods funcionam assim: se injetando nos programas. O jeito mais educado é interceptando chamadas de funções. O jeito bruto é escrevendo direto em endereços fixos na memória do jogo.







Uma forma de dificultar isso é carregar esses segmentos e DLLs em endereços aleatórios. Só na hora que o programa executar que ele vai saber quais são os novos endereços, daí um vírus não poderia assumir um endereço fixo, porque toda vez vai mudar. O problema é que em 32-bits temos pouco espaço e se ficar movendo segmentos de lugar a gente vai fragmentar a memória. Faz de conta que resolvemos colocar uma DLL no meio dos 2 GB que temos. Daí já impede aquele parâmetro “/3” pra gente conseguir ter 3 gigas livres pro programa. Aí pra servidor esse programa já não presta.








Mas acabamos de falar que em 64-bits tem tanto endereço, mas tanto endereço, que na prática os chips de CPUs como da Intel e AMD só vem mesmo com 40-bits de endereços reais. Significa que temos 24-bits de endereços sobrando que não dá pra usar de qualquer jeito. Então ASLR é um recurso que calcula uma posição aleatória dentro de X posições na memória virtual, estrategicamente escolhidas pra não fragmentar a memória de formas absurdas. Toda vez que seu programa iniciar o endereço da stack, da heap, das DLLs compartilhadas vão ser diferentes dentro de 256 possibilidades.







Tem como o vírus descobrir o endereço em tempo real se tiver vazamento de ponteiros no seu programa, mas esse recurso sozinho dificulta uma quantidade grande se não todos os malwares de overflow que existiam até 2004 pelo menos. Isso sozinho não torna seu computador totalmente seguro, só cria uma camada extra de dificuldade. Se estiver interessado em saber formas de burlar essa proteção também vou deixar linkado um artigo de 2020 que mostra como nas descrições abaixo.






Como eu disse no começo, você nunca vai ter que calcular endereços de 20-bits em computadores de 16-bits dos anos 80, felizmente. Em meio a HIMEM.sys e motoristas bêbados, até chegarmos na era dos 64-bits, gerenciar memória era uma tarefa árdua, tediosa, cheia de bugs e exploits. Tinha mais técnicas de gerenciar memória e escovar bit do que existem pokemóns. Mas acho importante entender como a memória funciona, porque mesmo programadores experientes tratam esse assunto mais como astrologia do que como ciência. Daí quando chegamos no limite da máquina e precisamos pensar em formas de otimizar, a discussão parece mais argumentação de horoscopo do que realmente formas práticas.






Parece besteira, mas entender um mapper de nintendinho de 8-bits, faz a gente entender memória expandida em DOS de 16-bits, que faz a gente entender PAE em computadores de 32-bits, até ter uma visão mais realista do que são 64-bits. A forma como gerenciadores de memória lidam com segurança, fragmentação, páginas e swaps, vai ajudar quando você precisar otimizar um sistema. 






Se tiver os conceitos que eu expliquei hoje vai conseguir ler um paper do Google sobre a diferença entre um tcmalloc, jemalloc ou um Scudo hardener. Memória não é tudo igual. Não é uma lista linear. Quanto mais cedo você entender como seus programas realmente usam a memória, mais cedo vai parar de sugerir bobagens pra otimizar seus programas. Se ficaram com dúvidas mandem nos comentários abaixo, se curtiram o video deixem um joinha, assinem o canal, clique no sininho e compartilhem o video com seus amigos. A gente se vê, até mais.
