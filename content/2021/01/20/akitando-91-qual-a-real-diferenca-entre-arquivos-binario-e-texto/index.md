---
title: "[Akitando] #91 - Qual a REAL diferença entre Arquivos Binário e Texto?? \U0001F914"
date: '2021-01-20T10:00:00-03:00'
slug: akitando-91-qual-a-real-diferenca-entre-arquivos-binario-e-texto
description: "Com hello.c, ELF, JPEG, ASCII, shells e shebangs, Akita mostra como o sistema interpreta sequências de bytes. Texto e executáveis são binários, mas seguem formatos diferentes."
tags:
- ciencia-da-computacao
- programacao
- akitando
draft: false
---

{{< youtube id="oSCVb4Ts-G4" >}}

## DESCRIÇÃO

Um arquivo texto É um binário! 😲

E como um sistema operacional diferencia entre os dois? Porque ele sabe executar um binário compilado de C, sabe executar um script de Python, mas também sabe dar erro se tentamos executar um texto qualquer? 

Como isso funciona de verdade por trás dos panos?

Hoje é dia de escovar bit, e entendermos o que é ASCII, o que é ELF e muito mais!


ERRATA: 
- em 05:29 eu falo "porque 10 em decimal é A" mas eu quis dizer "10 em HEXAdecimal é A"
- em 13:53 eu falo que depois de 69 é 70, mas tá errado, em hexa depois de 0x69 é 0x6A, depois 0x6B e assim por diante até 0x6F e só depois seria 0x70


ÍNDICE:

* 00:00 - Intro
* 01:14 - Hello World
* 04:30 - arquivos texto
* 04:59 - arquivos binários
* 06:13 - como um computador boota?
* 08:44 - fontes num Nintendinho
* 13:29 - ASCII
* 17:24 - segurança: homografia
* 19:21 - binários executáveis (ELF)
* 25:44 - binários JPEG
* 27:20 - Shells (REPL)
* 30:10 - Encerramento



LINKS:

* Techquickie: The Magic Behind RAM (https://www.youtube.com/watch?v=UKTc9toqgU0)
* Cyrillic (Unicode block) (https://en.wikipedia.org/wiki/Cyrillic_(Unicode_block))
* IDN homograph attack (https://en.wikipedia.org/wiki/IDN_homograph_attack)
* Memory Prices 1957+ (https://jcmit.net/memoryprice.htm)
* Introduction to the ELF Format Part II : Understanding Program Headers (Introduction to the ELF Format Part II : Understanding Program Headers (k3170makan.com)) 
* Characters, Symbols and the Unicode Miracle - Computerphile (https://www.youtube.com/watch?v=MijmeoH9LT4)
* The 8-Bit Guy - Commodore History (https://www.youtube.com/watch?v=eP9y_7it3ZM&list=PLfABUWdDse7Y6LLPlfsHKcvBCgqaudzVY)

## SCRIPT

Olá pessoal, Fabio Akita


Dois videos atrás comecei a falar sobre segurança, mas pra continuar eu preciso começar a complementar o assunto de  introdução a computadores com um pouco mais de escovação de bits. Se você assistiu todos os meus vídeos pelo menos já sabe um pouco de como um computador funciona. Como você pode carregar um programa via uma ROM por exemplo, como ele vai instrução a instrução, preenche registradores com resultados, depois você pode endereçar coisas na RAM e assim por diante.









Nos episódios que falei da máquina universal de Turing e a arquitetura de Von Neumann, você já sabe que uma característica importante é o fato de programas e dados compartilharem o mesmo espaço numa fita e como o computador vai lendo um bit de cada vez dessa fita, seja lendo ou escrevendo nela. Todo iniciante sabe que computadores lidam com bits e bytes. Mesmo assim muitos tem dificuldade de entender o que de fato isso significa. Hoje vou falar um pouco sobre formatos de arquivos, mais especificamente sobre qual a relação de arquivos binários ou textos planos, e no final espero que vocês tenham uma noção melhor de como as coisas funcionam por baixo dos panos. Hoje vamos literalmente escovar bits.




(...)





Vamos começar com uma coisa muito simples, o famoso Hello World, mas escrito em C, que é esse codigozinho idiota aqui do lado. Em C a gente declara dependência ao arquivo stdio.h ou standard i/o ponto header, porque é um arquivo de cabeçalho. Todo programa em C inicia nessa função `main` e dentro temos a chamada da função `printf` que só existe porque incluímos o stdio.h antes. Passamos a string `Hello World` e finalmente retornamos 0 que indica pro sistema operacional que o programa terminou com sucesso. E é só isso, depois desse ponto o programa termina e sai.





Eu escrevi esse código usando um editor de textos, no caso o Vim no meu Linux. E salvei num arquivo chamado hello.c. Se você for total iniciante poderia pensar "ah, isso é um programa, portanto posso tentar rodar esse programa né?" É uma pergunta válida. E se tentarmos "rodar" esse arquivo? Você começou a estudar um pouco de Linux, pra executar alguma coisa que tá no mesmo diretório pode simplesmente escrever ponto barra pra dizer que não é pra procurar no PATH e sim no diretório atual, daí hello ponto c e ... permission denied, fuck.










Mas você sabe como resolver! Google! E como mostra no primeiro link, claro, precisa dar permissão pra execução nesse arquivo. No Windows basta que alguma coisa termine em ponto exe ou ponto bat que executa, mas no Linux precisa fazer `chmod +x hello.c` e agora dá pra tentar de novo e ... what the fuck, vários erros. “Essa porra de C é difícil mesmo, melhor voltar pro CSS” (ba dum). 







Não, tô zoando. Esses erros não são de C. Quando você tenta executar um arquivo de texto na realidade ele tá fazendo o shell executar. Isso é o mesmo que executar `bash` e passando `hello.c` como parâmetro. Bash ou Zshell ou Fish ou Powershell são interpretadores, que recebem comandos direto que você digita direto na linha de comando ou via um script, que é o que o bash tá achando que é esse hello ponto c. Os erros que estamos vendo não é de C e sim de Bash.










Já já volto pra interpretadores, mas falando sério, eu espero que a esta altura você saiba que C primeiro precisa ser compilado, que em resumo é transformar esses comandos que eu escrevi num binário compatível com o processador por baixo. E pra isso podemos usar clang ou gcc, mas pra ser old school vou usar gcc. Um simples `gcc hello.c -o hello`. E pronto, agora posso executar ponto barra hello e boom, Hello World, que era o que eu queria.









Se você já é programador isso deveria ser trivial, mas vamos pensar como iniciantes. Porque isso que eu fiz funciona? No Linux temos comandos como `cat` que lêem o conteúdo de um arquivo e imprime na tela. Se eu der `cat hello.c` aparece o que eu escrevi. Mas se eu der `cat hello` vem esse monte de lixo. O que é esse monte de lixo? Pra entender isso temos que dar um passo pra trás. 






Relembrem o computador de Turing. Ele entende uma fita de bits. Toda memória, seja RAM ou ROM, todo SSD ou HD ou pen drive ou, no nosso caso, arquivo texto ou arquivo binário é só isso: uma fita de bits. O comando `cat` que usamos na verdade faz mais do que só ler um arquivo: ele traduz o conteúdo de um arquivo. E ele é burrinho, a única coisa que ele faz é tentar converter uma fita de bits em uma representação de texto.













Uma coisa que hoje é meio padrão é que representamos texto humanamente legível usando uma tabelona chamada UNICODE. Até pouco tempo atrás, antes de UNICODE se disseminar, usávamos uma tabela menor chamada ASCII. Unicode é um assunto super cabeludo que tem vários posts e videos já explicando por isso não vou detalhar demais, entenda que é complexo. Se você acha que entende tudo de Unicode, você não entende Unicode. 








Em vez de usar o comando `cat` vamos usar o comando `xxd` que se não me engano já mostrei no video de aprendendo sobre computadores com super mario. Se fizermos `xxd -b hello.c` vamos ver a fita de bits organizado em colunas de 8 bits que é um byte, 6 bytes de cada vez pra caber na tela. Na esquerda temos a posição desses bytes, contado em hexadecimal, não confundir com decimal. Podemos contar assim: começa na posição zero, daí um, dois, três, quatro, cinco, daí pula pra próxima linha começando na posição seis, continua, sete, oito, nove, “A”, porque dez em hexadecimal é A, daí onze é B e pula de linha e continua na linha seguinte na posição C e assim por diante.










Na coluna da direita temos a tradução desses bytes usando a tabela ASCII. Então vemos o segundo byte por exemplo, zero um um zero um zero zero um que é a letra "i". Note que temos outro "i" na palavra `stdio` e esse "i" está no segundo byte da linha que começa no endereço "C" que falei antes. Viu? Olha como o primeiro "i" e o segundo "i" é a mesma sequência zero um um zero um zero zero um. A gente traduz os bytes em letras que conseguimos ler, mas o computador só vê isso, uma fita de bits. Por convenção quebramos a fita em blocos de 8 bits, que chamamos de bytes. E 1 byte, na tabela ASCII, traduz pra uma letra.








O que é uma tabela ASCII? Todo computador hoje vem equipado com essa tabela pré-instalada. Entenda assim: uma CPU sozinha não faz nada. Você liga a energia e ela fica só lá sentada esperando. Relembre o video do Guia mais hardcore de introdução à computação. Nele eu mostro como gravamos um programinha num chip de EPROM e a CPU sempre vai procurar alguma coisa num certo endereço de memória pra começar a executar. De forma simplificada, num computador moderno esse chip de EPROM é o que chamamos de “firmware” ou BIOS. Por iss,o se você já atualizou o firmware sempre vem avisos de não interromper o processo no meio. Porque se falhar a atualização do firmware, o computador vai ficar sem o programa que inicia tudo.









BIOS é acrônimo pra sistema básico de entrada e saída. E firmware é uma classe específica de programas que oferece funções que chamamos de baixo nível. Por exemplo, seu Windows ou Linux tá instalado num HD, mas pra saber que o HD existe e como ler bits do HD e depois identificar que tem pentes de RAM e carregar o Linux na RAM, você precisa de um programa antes. Esse programa é o firmware, que oferece funções básicas pra se comunicar com dispositivos de entrada e saída, como a memória. 







Se você assiste canais de montagem de PCs como o Linus Tech Tips, vai ver eles sempre se preocupando num tal de POST depois que o computador liga. POST é acrônimo pra Power On Self Test ou auto-teste depois de ligar. É a BIOS rodando e identificando corretamente todo o hardware. Depois desse teste é que ele começa a sequência de boot do sistema operacional, procurando numa ordem específica tipo pendrive antes do HD por exemplo. E se for HD procurando numa posição específica do HD. No caso do formato antigo MBR ou Master Boot Record, são os primeiros 512 bytes da primeira partição do HD.










Enfim, sem dar muita tangente, uma das coisas que a BIOS carrega é uma tabela de conversão de bits pra letras que um ser humano consegue ler. Essa é a tabela ASCII, por isso logo que você liga o computador, ele tem a habilidade de escrever textos na tela pra mostrar o boot antes mesmo do sistema operacional iniciar. É o que ele usa pra montar a tela de configuração da BIOS quando você aperta F12 por exemplo. Se não ficou claro a importância disso, lembram do episódio de video game? Um videogame bem antigo, tipo nintendinho de 8-bits da vida? Então, essa é uma época onde chips de memória eram bem caros. Um chip de 64 kilobytes podia ser tão caro quanto hoje é um pente de 64 GIGABYTES. Por isso você não podia desperdiçar um byte.










Uma das formas de economizar memória é que a BIOS de um videogame antigo é tão simples que ele sequer sabe converter bytes em letras. Aliás, um console de 8-bits eu acho que nem tinha equivalente de BIOS, bootava direto do cartucho. Já notou que todo jogo antigo tem fontes diferentes? Não é porque o sistema vem com várias fontes, que nem hoje você tem Arial ou Verdana ou Times pra escolher. As tais "fontes" precisavam vir na ROM do cartucho, de cada jogo. E pra economizar espaço eles só colocavam as letras e símbolos que de fato o jogo fosse usar. Se tivesse alguma letra não precisava, ele pulava. Vamos dar um exemplo, vamos abrir a ROM de um jogo antigo como o Super Mario original com o emulador Mesen.






Só um parêntese aqui, o Mesen é um excelente emulador se você quiser escovar bit de binário de cartuchos porque ele tem várias ferramentas de debugging, você pode escrever assembly de 6502 e ele vai converter pro binário e inserir onde você quiser, pode colocar pontos de parada, vasculhar valores nos registradores e tudo mais. Vale a pena pra quem quiser fuçar mais a fundo. Mas pra agora vamos usar uma ferramenta que mostra o conteúdo de segmentos de sprites do cartucho de forma visual.








Vamos direto pra região de memória do cartucho que, por convenção, se chama CHR ou characters. Olhem aqui as letras desenhadas do jogo, literalmente caracteres. Como eu expliquei no outro video um Nintendo de 8-bits lida com sprites em vez de pixels individuais, que são conjuntos de oito por oito pixels. Por acaso o caracter"1" está na posição 1, a "2" está na posição 2 e assim por diante. Pense nessa região de memória como hoje seriam as fontes True Type ou Open Type que você de front-end e CSS tá cansado de ver. Fontes modernas carregam em alguma região específica da memória e ocupam espaço.






O problema é que pra representar as letras de oito por oito pixels em memória, só de zero a nove e de A a Z são oito vezes oito vezes trinta e seis letras, o que dá dois mil e trezentos bytes ou mais de 2 kilobytes. A ROM do Super Mario inteiro ocupa 40 kilobytes, então 5% do cartucho já tá ocupado só com essas letras. Por isso evita-se fazer letras maiores, opções de maiúscula e minúscula, porque só de fazer isso ia quase dobrar o espaço usado. 









Pra entender a importância de economizar espaço, por volta de 1982, 1 megabyte custava mais de 4 mil dólares. Só esses 2 kilobytes representavam pelo menos 7 a 10 dólares! Consegue imaginar isso? Uma moeda de um quarter ou 25 centavos pra cada letra que eu acabei de mostrar. Em 1990, quase 10 anos depois, o mesmo megabyte caiu de 4 mil dólares pra menos de 100 dólares. E é por isso que só a partir dos anos 90 começa a ficar viável fazer coisas que desperdiçam memória massivamente como interfaces gráficas e fontes variadas pré-instaladas. Nos dias de hoje, 1 megabyte é super insignificante, é só uma fração de centavo, de Real.








Quando os microcomputadores começaram a se popularizar, uma coisa que era meio necessário era ter um mínimo de fontes pré-instaladas pra podermos digitar alguma coisa e pro computador conseguir nos mostrar mensagens na tela. E com o tempo passamos a adotar a convenção da tabela ASCII, pra ser possível transferir um arquivo texto de um computador pra outro de outro fabricante. Se cada fabricante usasse tabelas diferentes, o arquivo texto só ia conseguir ser lido num outro computador do mesmo fabricante.







No caso dos videogames com cartucho como Super Mario que eu mostrei, o código 1 representa o símbolo gráfico 1. Pra escrever meu nome, AKITA, eu representaria na memória como os códigos hexadecimais 0A, 14, 12, 0D e 0A de novo. Isso ocupa 5 bytes, porque cada número em hexadecimal representa 4 bits, dois números são 8 bits, portanto 1 byte. Meu sobrenome tem 5 letras, portanto 5 bytes. Em um byte é possível ir de 00 até FF que seria 256 opções. Mas no nosso caso a tabela termina no código 24. Depois da última letra, do código 25 pra cima ele mapeia pra outros sprites que são os desenhos tipo dos blocos que o Mario quebra, dos sprites que formam personagens como o próprio Mario ou os Goombas.







Pra ter uma imagem na cabeça, o que hoje eu chamaria de tabela de fontes, de uma Arial ou Times, no cartucho de um nintendo é essa área de memória da ROM chamada CHR e as fontes são todos os sprites do cartucho. É como se fizéssemos um jogo só com as letras que aparece no seu teclado, que o povo fazia mesmo, em DOS antigo. Mas num console ou microcomputadores dos anos 80 como os Vic-20, ZX Spectrum, a gente substituia os caracteres de texto pra caracteres “gráficos”. Por isso em teclados de VIC-20 ou Commodore 64 você até já tinha uma tabela alternativa de caracteres, e com eles você podia desenhar na tela sem precisar especificar pixel a pixel toda hora. Pode ser meio complicado de visualizar se você nunca viu isso, então recomendo assistir o canal do 8-Bit Guy, em particular sobre os computadores da Commodore.








Voltando ao nosso exemplo do hello.c, vamos abrir o binário do arquivo texto em formato hexadecimal. É a mesma coisa. Note que o segundo caracter é a letra "i" que a gente viu em binário agora pouco, em hexadecimal é o código 69. Daí na mesma linha temos o "i" da palavra "stdio" que é a terceira letra da direita pra esquerda e, claro, temos o código 69. Na tabela que temos pra representar as letras, o código 69 é "i", então o código 70 vai ser "j", 71 vai ser "k" e assim por diante até Z. Por acaso todo PC usa a mesma tabela e o nome dessa tabela é a tal ASCII.








ASCII é abreviação pra American Standard Code Information Interchange. Essa conversão se iniciou na época dos telégrafos, então é lá pelo meio do século XX. E foi estabelecido um padrão de 7-bits pra trocar textos. 7 bits é suficiente pra armazenar 2 elevado a 7 ou seja 128 caracteres. Contando 10 números, mais 26 letras do alfabeto em maiúscula, mais 26 letras em minúscula, já ocupamos metade da tabela. O resto é ocupado por símbolos como os aritméticos de adição ou subtração, parênteses, colchetes e assim por diante. 7-bits é suficiente pra maior parte dos textos escritos em inglês e sobra algum espaço ainda pra alguns caracteres acentuados.









Claro, ASCII, sendo um padrão americano, funciona bem pra qualquer língua próxima do inglês. Português usa uma variação que encaixa coisas como cedilha. Espanhol precisa no “N” com til e interrogação ao contrário. Outros países adotaram tabelas alternativas. Imagina no Japão por exemplo. 128 caracteres não cabe nem uma fração de todos os símbolos que se precisa como os famigerados Kanjis. Pra comportar mais caracteres precisamos de mais bytes e daí nasceram extensões como o padrão EUC que é Extended Unix Code e pro Japão em particular tem o EUC-JP. Pra China tem EUC-CN, pra Coréia tem EUC-KR e assim por diante. 










Tecnicamente um EUC-JP é mais compatível com ASCII porque em códigos que começam com 0, ou seja de 7-bits, ele corresponde aos mesmos códigos da tabela ASCII e por isso foi usado em coisas como UNIX versão internacional. No Japão surgiram mais de uma tabela. Apesar da EUC-JP ser mais simples pra usar em conjunto com caracteres ASCII não foi a mais usada. A que eu mais vejo é a Shift-JIS que foi criada, ironicamente, pela ASCII Corporation do Japão e pela Microsoft. Quando se usa caracteres de 2 bytes, o Shift-JIS é uma dor de cabeça quando mistura caracteres ASCII porque tem ambiguidade do mesmo código ser usado pra símbolos diferentes dependendo de como foi codificado.









O importante é entender que línguas como chinês, coreano ou japonês são formados por ideogramas, e não sílabas com consoantes e vogais. Então precisa haver uma forma de mapear milhares de símbolos. Com um único byte podemos mapear não mais que 256 caracteres. Pra manter 1 byte precisam ser usados tabelas diferentes pra mapear o mesmo número pra símbolos diferentes. Você imagina a dor de cabeça de ficar trocando entre tabelas diferentes. Quando usamos 2 bytes, aí as possibilidades aumentam pra 2 elevado a 16, que dá mais de 65 mil símbolos possíveis e aí já cabe quase tudo que precisa. Em Unicode temos UTF-8 pra linguagens ocidentais que se aproxima da tabela ASCII e UTF-16 ou UTF-32 pra outras línguas por exemplo. Quanto mais bytes se usa por caracter, mais espaço é desperdiçado num arquivo de texto.









Agradeça por ser programador num país ocidental que pode usar só ASCII ou UTF-8, porque coisas simples como gravar um arquivo texto é simples. Em chinês ou japonês, especialmente se tiver que lidar com tabelas antigas como EUC-CN em vez de só Unicode, você ia chorar lágrimas de sangue. Imagine fazer coisas como algoritmos de procura de palavras, algoritmos de ordenação de palavras, algoritmos de encontrar palavras similares. Coisas que mesmo em inglês ainda não é perfeito como transcrever um áudio em palavras. É muito mais complicado.









Aproveitando essa tangente vale falar de problemas de segurança que apareciam quando você entende que tá num mundo que representa letras diferente do padrão ASCII. Os símbolos em pixels que desenha na tela, que num nintendinho chamamos de sprites, no mundo de fontes chamamos de glifos. Agora, a letra maiúscula "A" em latim, ou a mesma letra em cirílico, ou a mesma letra em grego, todas têm a mesma imagem ou glifo de "A" nosso, mas cada um é um código diferente nas tabelas Unicode. No caso são respectivamente os códigos 41, 410 e 391. Porque isso é importante? Porque eu poderia registrar um domínio que já existe, digamos example ponto com e trocar o código UTF-8 do "a" minúsculo ASCII pro “a” minúsculo em cirílico. Humanos vão enxergar escrito "example" mas são duas palavras diferentes, com códigos diferentes.










Não entendeu? Em binário, via UTF-8 ou ASCII, é assim que a palavra `example` é representado: `65 78 61 6d 70 6c 65 0a` mas e se trocarmos pelo "а" em cirílico, que é o alfabeto russo? Ele fica diferente e 1 byte mais longo, assim `65 78 d0 b0 6d 70 6c 65 0a` esse `d0b0` é a letra "a" em cirílico. Se abrirmos com o `xxd`, que tenta representar segundo a tabela ASCII, ele não sabe que letra é, então bota pontos no lugar. São dois bytes que não representam nada na tabela ASCII e isso quebra a palavra pra gente. 








Mas num navegador que entende Unicode, você abre no gmail um e-mail com um link que claramente diz facebook ponto com. Mas o "a" não é o código 61 e sim o 430 em cirílico. Mas você não tem como saber a diferença só olhando pro glifo. Esse tipo de ataque era possível antigamente mas hoje em dia não mais porque os registras filtram quando você tenta registrar. Era um tipo de spoofing via registro de domínios fakes. É semelhante a um typosquatting que é quando você registra domínios que soam parecido com o original mas com um errinho que pode passar batido se você lê rápido, ou tá acostumado a falar que nem uma criança, por exemplo `santader.com` em vez de `santaNder.com`.








Voltando ao nosso exemplo original do hello world. Aprendemos que nosso arquivo `hello.c` é o que chamamos de um arquivo plain text, ou texto plano, que é um arquivo que contém apenas binários que mapeiam pra algum caracter numa tabela como ASCII. Mas pra todos os efeitos práticos, um arquivo texto também é um arquivo binário. A extensão não modifica nada no arquivo, é só uma convenção. Dentro dele tem uma fita, uma cadeia de bytes onde cada byte, de acordo com a tabela UTF-8 ou ASCII mapeia cada byte pra um glifo, um desenho de uma letra, número ou símbolo qualquer.








Eu estou sendo bem demorado nessa explicação porque vocês precisam entender desde cedo que o que você enxerga como “texto” é apenas uma representação do shell ou do editor de textos, o arquivo que ele abre é um binário como qualquer coisa no sistema. Tudo é binário. O que popularmente chamamos de “binário” é um tipo específico de binário, os executáveis. E agora vou mostrar qual a diferença do arquivo `hello.c` que é um binário pra texto do binário executável `hello` que foi gerado pelo `gcc` compilando o código que escrevemos dentro desse `hello.c`.








Se usarmos o mesmo comando `xxd hello` vamos ver um monte de sujeira na tela. Diferente do arquivo texto que nós digitamos, aqui tem só umas letras e símbolos jogados. Mas note que lá no começo, o arquivo começa com um código hexadecimal 7f e depois escreve ELF. Isso indica que este é um binário formato ELF que significa Executable and Linking Format, um formato padrão de executável que data da era dos UNIX originais. 







Quando tentamos executar esse binário o sistema operacional, no meu caso o Arch Linux, vai identificar esses primeiros bytes e começar a checar se é um executável ELF válido. Pra isso vai validar o cabeçalho do arquivo, que ocupa um espaço específico de bytes no começo do arquivo. Tem um endereço especial pra identificação de cada coisa. Por exemplo, no 5o byte se tiver o valor 1 significa que é um binário de 32-bits, se for 2 significa que é 64-bits e de fato, temos 2, portanto é 64-bits. 











Se você nunca entendeu o que é um protocolo binário, esse cabeçalho é um tipo de protocolo. Ele delimita campos dentro de uma cadeia de bytes. Por exemplo, do byte 0 até o byte 4 precisa ter a palavra `ELF` em ASCII, no byte 5 temos identificação de 32 ou 64-bits, e assim por diante. Cada campo tem um endereço de começo, um endereço de fim e alguns valores específicos e arbitrários que se espera encontrar nesse espaço, segundo a definição do protocolo ELF.








É tudo só um linguição de bytes, mas se satisfazer esse protocolo, essas regras de posição e valores, vai ser um executável ELF de Linux por exemplo. Um protocolo de rede é a mesma coisa, um linguição de bytes que tem certos campos em certas posições. Uma hora ainda vou falar sobre redes, mas isso deve dar uma noção pra agora. Lembre-se, é um computador de Turing, programa e dados estão todos misturados na mesma fita de bytes.








Continuando, tem um tanto de lugares vazios pra poder adicionar informações extras se precisar numa futura nova versão de ELF, mas o programa de verdade só começa a partir do endereço hexadecimal 0x1000. O que tinha antes eram meta-dados, ou dados que descrevem os dados do binários. E é isso que queremos dizer com dados e programas serem a mesma coisa. É tudo uma fita de dados. Aqui você vê que fica mais denso de bytes diferentes. 







Mas note o primeiro, hexadecimal f3 depois 0f daí 1e e fa. é um comando em assembly de Intel x86 64-bits, o comando `endbr64`. Assim como tínhamos uma tabela de caracters como ASCII, pra saber sobre esse assembly, você precisa saber outra tabela, a que mapeia hexadecimais com comandos de assembly. Cada arquitetura de processadores tem uma diferente. Mesmo no mundo Intel, temos instruções diferentes entre 32-bits e 64-bits, a maioria é compatível mas em 64-bits obviamente temos mais funcionalidades diferentes. Tudo em computadores é sempre mapear bytes pra alguma coisa. Por isso quanto antes você se acostumar a conviver com hexadecimais, melhor.









Diferente de um arquivo texto onde os bytes são traduzidos da tabela UTF-8 pra imprimir os glifos na tela pra gente poder ler, quando o Linux detecta que é um executável ELF, ele valida os metadados do cabeçalho e a partir do endereço 1000 começa a mandar as instruções pro processador. Pra ficar menos complicado de enxergar, em vez do comando `xxd` podemos usar outra ferramenta que vai traduzir o hexadecimal pros mneumônicos de assembly, no caso o `objdump`.







Ele já pula o cabeçalho todo e vai direto pro endereço 1000 e veja os mesmos f3 0f 1e fa que é comando endbr64 que falei. Daí começa uma sequência de iniciação que vai executar essas instruções `sub` de substrair, `mov` de mover e assim por diante. Mas e um executável de Windows? Se a gente copiar o executável do Mesen que eu tava usando agora pra dentro do Linux podemos ver o conteúdo binário dele com o mesmo `xxd`.









Olha como é diferente, primeiro ele não começa com `ELF` e sim com `MZ`. O cabeçalho é totalmente diferente. A gente não precisa também ficar tentando ler byte a byte do cabeçalho pra saber o que são as coisas. Todos as distribuições de Linux tem um comando chamado `file` que justamente sabe reconhecer diversos tipos de cabeçalhos de binários e identificar de uma forma que humanos consegue entender. Por exemplo, se fizermos `file hello` veja que ele identifica corretamente como um executável ELF Intel de 64-bits. Se fizermos `file Mesen.exe` vemos que identifica como um PE32 ou Portable Executable de 32-bits Intel, em particular é um assembly de .NET Mono.








Todo arquivo no sistema é um linguição de bytes. Se forem bytes que existem na tabela UTF-8, provavelmente é um arquivo texto, como o código do `hello.c`. Quando compilamos com o `gcc` ele gera outro linguição de bytes, mas vai ter o formato ELF que é executável de Linux. Daí quando mandamos executar `hello` ele vai identificar o cabeçalho, validar, descer até o endereço 1000 do arquivo e achar as instruções assembly pra começar a mandar pro processador. Por outro lado temos diversos outros tipos de linguição de dados, por exemplo, uma imagem JPEG que todo mundo conhece, como as fotos que seu smartphone tira.









Vamos abrir um arquivo com `xxd` pra ver como é. Novamente, temos um linguição de bytes, mas em particular esse começa com ff d8. Se formos até o fim do arquivo temos ff d9. Todo arquivo JPEG começa e termina do mesmo jeito. Indo até o fim, esse ff d9 indica quando o arquivo acaba porque em nenhum lugar ele indica o tamanho total. Mas voltando pro começo, a partir do byte 6 vemos que o `xxd` reconheceu quatro códigos que mapeiam na tabela ASCII pra JFIF que significa JPEG File Interchange Format. Os bytes ff d8 já identificam o arquivo como JPEG mas tem esse JFIF porque também existe o EXIF que é Exchangeable Image File Format que é um formato similar feito por fabricantes de câmeras digitais de antigamente.










Essa é uma das formas que o sistema operacional reconhece que tipo de arquivo estamos lidando. Se for um binário que tem um linguição de bytes que encaixa no formato ELF, é um executável e, se tiver permissão de execução, tenta executar. Se for um binário com cabeçalho de JFIF é uma imagem JPEG e um programa de ver imagens vai saber os endereços dentro que precisa pra localizar a imagem propriamente dita. E assim por diante pra todo tipo de arquivo. Zips, video, áudio. 







E no caso de arquivos texto, eles são binários também, cujos cabeçalhos não são nenhum dos anteriores e podemos tentar mapear byte a byte pra uma tabela como UTF-8. Caso venha só um texto quebrado com lixo no meio de letras, que não parece com palavra nenhuma, pode ser um encoding diferente, digamos um texto antigo em japonês e, nesse caso, se usar a tabela EUC-JP ou Shift-JIS, podemos encontrar palavras em japonês, se o programa que estivermos usando souber usar os glifos do alfabeto japonês.








Por último, vale falar do problema inicial. Por que não podemos executar o código do arquivo `hello.c` diretamente sem compilar? Primeiro, ele não é um binário ELF nem PE então não contêm instruções em assembly pra passar pro processador. Mas por que eu consigo executar direto um arquivo de Python, ou Perl, ou Javascript? Isso porque normalmente ele tem duas coisas. No caso específico de Linux, vai ter permissão de execução e segundo, na primeira linha vai conter o caminho no sistema pra um interpretador. Chamamos essa linha de shebang ou simplesmente bang. Se abrir um script de Python, você vai ver que costuma ter essa primeira linha neles.








Se só tiver permissão de execução mas não tiver shebang, quem vai tentar executar esse arquivo texto, que agora chamamos de shebang, vai ser o shell onde estamos neste instante. Por exemplo, quando eu abro um Terminal do Arch Linux, configurei pra iniciar o Zshell. Se for um Linux normal ou um Terminal no MacOS, sem configurar nada extra, normalmente vai abrir o famoso Bash. Um Windows vem por padrão com o Powershell. Existem vários interpretadores de terminal. Eu explico mais no episódio sobre WSL 2.








Essa linha de comando é um ambiente de programação. Podemos escrever programinhas. Então toda vez que você cai na tal linha de comando, pode imediatamente escrever código sem abrir um editor de textos separado. Em microcomputadores antigos dos anos 80 como um MSX ou Apple II ou Commodore 64, o equivalente shell deles era o Basic. E como toda linguagem de programação ele tem uma sintaxe, funções e comandos específicos dessa linguagem que, por acaso, não tem nada a ver com a linguagem C. E por isso quando você tenta executar o `hello.c` ele vai dizer que tem erros de sintaxe. Claro, não é a mesma linguagem. Você mandou essa shell que, digamos, é brasileiro, tentar ler um texto em chinês e aí ele buga mesmo.








A mesma coisa acontece quando você abre o console do Python, ou um console qualquer de Javascript ou Ruby. Daí vai ser um outro shell rodando em cima do shell original, Bash ou Zshell. Todo mundo de Ruby por exemplo conhece o IRB que abre uma linha de comando onde podemos executar direto comandos de Ruby. IRB é um acrônimo pra Interactive Ruby Shell. Está no nome, ele é um shell. Mais especificamente um REPL ou Read-Eval-Print Loop, ou traduzindo, um Loop de leitura, execução e impressão. Ou seja, um programa que fica em loop infinito sempre esperando ler um comando, daí tentar executar, que é um evaluate ou `eval` desse comando, e imprimir o resultado na tela. É um shell.








Confunde um pouco pra quem está começando porque é difícil distinguir o que são funções nativas dos shells como Zshell ou Bash e o que são binários executáveis que parecem funções. Por exemplo, todo mundo conhece o comando `echo` que imprime o string que passamos pra ele na tela. Mas fora no Zshell, ele é um executável que fica em barra usr barra echo. Os shells tem bem poucas funções nativas, por exemplo `cd` pra mudar de diretório ou `alias` pra criar atalhos. 











E por hoje vamos ficar por aqui. Eu acho que uma das coisas que mais facilita a vida de um programador é o quanto antes ele se tornar íntimo do computador que usa. Muitos passam anos só trabalhando com linguagens de alto nível e evitam ao máximo lidar com binários, hexadecimais, pacotes, streams, porque parece uma coisa bizarra, tipo tentar ler chinês. Só que isso limita suas capacidades como programador. E limita bastante. Ser um programador não é receber peças de Lego e sair juntando que nem um idiota, em breve é bom você mesmo saber fazer suas próprias peças de Lego. Se curtiram o video deixem um joinha e compartilhem o video com seus amigos, não deixem de assinar o canal e clicar no sininho pra não perder os próximos. A gente se vê, até mais!



