---
title: "[Akitando] #81 - Aprendendo sobre Computadores com Super Mario (do jeito Hardcore++)"
date: '2020-06-18T10:00:00-03:00'
slug: akitando-81-aprendendo-sobre-computadores-com-super-mario-do-jeito-hardcore
tags:
- nintendo
- nes
- famicom
- '6502'
- assembly
- cc65
- game genie
- micro mages
- morphcat
- dotemu
- wonderboy
- tectoy
- fceux
- mesen
- tasvideos
- speedrun
- super mario
- steam
- akitando
draft: false
---

{{< youtube id="hYJ3dvHjeOE" >}}

### DESCRIÇÃO

Errata: em 17:12 eu disse certo mas na equação faltou mostrar dividindo tudo por 2. Em 13:00 eu claramente faltei na aula porque 278 x 7 é 1946 😅

Você não precisa ter assistido o video anterior pra entender este, mas certamente ajuda.


Hoje vou acelerar na missão de fazer vocês entenderem como computadores em geral funcionam por baixo dos panos usando um Nintendinho e o Super Mario como guias nesta jornada.


Não tentem entender tudo na primeira assistida. Eu mesmo não conseguiria. Assista até o fim pra ter a visão completa depois retorne pra partes específicas pra pegar em mais detalhes.


Já aviso que os primeiros Vinte Minutos podem parecer um pouco devagar, porque vou complementar o que comecei no video anterior, mas garanto que depois disso vem o filé mignon do filé mignon. Vamos ver como se constrói um emulador, como cartuchos funcionam, como começar a editar jogos e a entender como se começa a pensar em fazer jogos retrô, e vamos até falar de speedrun e hackear bugs de jogos. Tudo isso num único episódio!



Links:

* Super Mario Bros. 3 - Wrong Warp (https://www.youtube.com/watch?v=fxZuzos7Auk)
* A Comprehensive Super Mario Bros. Disassembly (https://gist.github.com/1wErt3r/4048722)
* Lembra deles? Confira jogos brasileiros do Master System lançados pela Tectoy! (https://blogtectoy.com.br/lembra-deles-todos-jogos-brasileiros-do-master-system-lancados-pela-tectoy/)
* Free NES assembler (https://bisqwit.iki.fi/source/nescom.html)
* Micro Mages (https://morphcatgames.itch.io/micromages)
* Nes Dev Wiki (https://wiki.nesdev.com/w/index.php/Nesdev_Wiki)
* Computer Archeology - The Legend of Zelda (https://www.computerarcheology.com/NES/Zelda/)
* 6502 Instruction Set (https://www.masswerk.at/6502/6502_instruction_set.html)
* An introduction to 6502 math: addiction, subtraction and more (http://retro64.altervista.org/blog/an-introduction-to-6502-math-addiction-subtraction-and-more/)
* Explain Half Adder and Full Adder with Truth Table (https://www.elprocus.com/half-adder-and-full-adder/)
* Build a multiplying machine using NAND logic gates (https://codegolf.stackexchange.com/questions/12261/build-a-multiplying-machine-using-nand-logic-gates)
* Tool Assisted Game Movies (http://tasvideos.org/)
* RETRO INSECTIVORES: FINDING AND ELIMINATING BUGS IN NES DEVELOPMENT (https://megacatstudios.com/blogs/press/retro-insectivores-finding-and-eliminating-bugs-in-nes-development)
* FCEUX (https://sourceforge.net/projects/fceultra/)
* Zelda Screen Transitions are Undefined Behaviour (https://gridbugs.org/zelda-screen-transitions-are-undefined-behaviour/)
* NES Emulator Debugging (https://gridbugs.org/nes-emulator-debugging/)
* Two's Complement Multiplication (http://pages.cs.wisc.edu/~david/courses/cs354/beyond354/int.mult.html)
* NES Hello World (https://www.embed.com/nes/hello-world.html)
* DF Direct: CRT Displays - Was LCD A Big Mistake For Gaming? (https://www.youtube.com/watch?v=tvRyVZWuvQ4)
* DF Direct! Modern Games Look Amazing On CRT Monitors... Yes, Better than LCD! (https://www.youtube.com/watch?v=V8BVTHxc4LM)
* Mod pra Wonderboy II Turma da Monica (https://www.youtube.com/watch?v=zQCm_y31SC0)


* Meu fork do emulador de NES em Go (https://github.com/akitaonrails/nes)
* Meu código do decodificador de código de Game Genie (https://github.com/akitaonrails/gamegenie)


Assinem estes canais:

* Retro Game Mechanics Explained (https://www.youtube.com/channel/UCwRqWnW5ZkVaP_lZF7caZ-g)
* One Lone Coder (https://www.youtube.com/channel/UC-yuWVUplUJZvieEligKBkA)

### SCRIPT

Olá pessoal, Fabio Akita



O tema do video da semana passada é um buraco de coelho de Alice no País das maravilhas. Estou demorando pra soltar videos porque cada assunto que eu esbarro vou pesquisar e abro mais uma dúzia de abas. Daqui a pouco vou encher meus 32GB de RAM só de abas. Computação retro é uma área gigantesca. Vocês não imaginam quantas comunidades existem não só colecionando itens antigos mas ainda desenvolvendo em assembly de MOS 6502 e outros processadores antigos como Z80, Intel 8088 e isso só no mundo dos 8-bits. Se entrar em 16-bits vai cair em processadores como o 65C816 do Super NES.






Eu reescrevi o script de hoje várias vezes, numa das versões eu estava gastando páginas e páginas só pra tentar explicar o problema da multiplicação em processadores antigos. Mas ficou muito fora do escopo do canal. Só pra dar um gostinho, no último video comecei a mostrar um pouco do Assembly do 6502 e algumas instruções básicas como LDA ou STA pra dar load no acumulador ou store do acumulador pra algum outro lugar.






Avançando pra operações aritméticas temos instruções como ADC ou SBC pra adição e subtração. Você já começaria coçando a cabeça quando precisasse somar números maiores do que 255, que é o limite que cabe em 1 byte, ou 8-bits. Lembra que o 6502 é uma CPU de 8-bits? Então todas as instruções só conseguem trabalhar com 8-bits de uma só vez. Pra trabalhar com números maiores a gente particiona o número e calcula 1 pedaço de 1 byte de cada vez. Vamos entender um pouco mais disso.







Como todo mundo pelo menos já deve ter ouvido falar, chips como o 6502 são feitos de componentes menores, como um transistor. Um transistor, em sua essência é um componente que funciona como um switch, ou interruptor. Acho que essa é a imagem mais simples de ter na cabeça. Você pode comprar transistors individualmente empacotados como um componente mais fácil de manipular num protoboard como esse aqui (video). 







Aliás, no video anterior eu chamei isso de breadboard que é como falam nos Estados Unidos, mas aqui se chama protoboard. Enfim, usando transistores é possível criar alguns dos circuitos mais simples de todos, as portas lógicas, que são peças fundamentais sobre as quais todo o resto é montado. Por exemplo, você pode montar uma porta lógica NOT num protoboard com um transistor, um resistor, um led pra ver a resposta, uma bateria e fios pra conectar. Uma porta NOT quando você manda 0 ele responde 1, ou quando manda 1 ele responde 0. Uma porta NOT pode ser feito com dois transistors, por exemplo.






Além de NOT podemos montar outras portas fundamentais como OR, AND, NAND, XOR que é exclusive OR e assim por diante. E com essas portas podemos montar coisas mais complicadas como uma CPU inteira. Com outras construções como flip flops, podemos montar memória, e por aí vai. À primeira vista é difícil de entender como operações simples como inverter bits pode ser útil. Vamos pensar numa operação um pouco mais complicada que queremos ter numa CPU, por exemplo somar dois números.






Assumindo que todo mundo sabe somar. Pense uma conta besta, somar 28 mais 22. Você começa somando 8 com 2, vai dar 10, coloca zero embaixo e sobe 1. A mecânica interessante aqui é esse "sobe um". Agora soma esse 1 que subiu com 2 do 28 e 2 do 22 e vai ter 50. Pra somar em binário é exatamente a mesma coisa. Pra converter um número decimal em binário, você vai dividindo por dois. 28 dividido por 2 é 14, resto 0. 14 por 2 é 7, resto 0, 7 por 2 é 3, resto 1, 3 divido por 2 é 1, resto 1. Então fica 11100. Pra ser 8 bits só completar os 3 zeros à esquerda. 








Fazendo mesma coisa com 22 fica 0001 0110. Números pequenos uma hora você lembra de cabeça, mas pra números maiores qualquer calculadora do Windows mesmo converte pra você. Ou em qualquer linguagem de programação tem uma função de formatar strings onde você passa um inteiro e diz que quer formatar com base 2. Num javascript basta chamar o método .toString com argumento 2 num número.






Pra somar esses dois binários, você começa da direita pra esquerda também, zero mais zero é zero. Depois zero e um é um. 1 e 1 é 2 que em binário é 1 0, então coloca zero e sobe 1. 1 mais 1 mais zero, mesma coisa, coloca zero e sobe mais um. 1 + 1 + 1 é 3, coloca 1 e sobe 1. 1 mais zero mais zero é 1. E o resto é zero. Então o resultado final é 0011 0010. Só parece difícil porque você ainda não tá acostumado a enxergar zeros e uns, mas a regra é a mesma e usa a mesma mecânica do "sobe um".






A máquina de adição mais simples que soma 2 bits é chamado de half adder ou meio somador. Você liga uma porta AND com uma porta XOR e vai ter a soma e o carry bit. Carry é o bit onde grava o "sobe 1". O meio somador vai fazer exatamente o que eu fui descrevendo agora. Se passar 0 e 0 a soma é 0. Se passar 1 e 0 ou 0 e 1 a soma é 1. Se passar 1 e 1 a soma é 2, então baixa 0 e sobe 1 pro Carry bit. A versão completa se chama full adder ou somador completo. 






Um dos jeitos de montar um somador completo pode ser ligando duas portas XOR, duas portas AND e uma porta OR. Ou melhor ainda, ligando dois meio somadores. A diferença é que além dos 2 números pra somar ele também recebe o carry bit de entrada e com isso podemos cascatear múltiplos circuitos de somador completo um embaixo do outro, ligando o carry bit de saída de um somador na entrada do outro. Se quisermos somar com números de 4-bits adicionamos 4 somadores completos em cascata. Pra 8-bits precisamos de 8 somadores. E com isso adquirimos um somador completo de 8-bits! (som de zelda)







Um circuito de somador completo pode ser montado de maneiras diferentes e com isso varia o número de transistors, mas pense que na média vai ser alguma coisa na faixa de 10 transistors pra cada somador. Pra somar números de 8 bits vamos precisar de no mínimo uns 80 transistors. Pra hoje em dia isso não parece grande coisa já que um processador A13 Bionic dos iPhone 11 Pro tem 10 bilhões de transistors. Um AMD Ryzen 7 3700X tem quase 6 bilhões de transistors e um AMD Epyc Rome, que é pra servidores, tem mais de 39 bilhões de transistors. Lembrando que são todos chips de 64-bits.







Nosso pobrezinho MOS 6502 de 8-bits tem na faixa de 3500 transistors, lembrem-se que estamos falando do meio dos anos 70. O que viemos fazendo depois, além de aumentar mais e mais a densidade de transistors por centímetro quadrado, foi adicionando novas funcionalidades como SIMD que são instruções de single instruction multiple data pra computação paralela, instruções de virtualização como VT-X ou AMD-V, instruções pra criptografia como AES, sem contar que os chips hoje são multi-core então é como se fossem múltiplas CPUs apertadas no mesmo chip. Mas as instruções fundamentais como somar bytes, carregar acumulador, incrementar contador de programas, atualizar apontador de pilha, e coisas assim que vimos no hello world da semana passada ainda é  similar.







Um primeiro insight é que os chips hoje são na ordem de 10 milhões de vezes mais densos de transistors que os chips dos anos 80 pra trás. Porém isso não se traduz necessariamente em programas 10 milhões de vezes melhor. Pegue o melhor da geração 8-bits que foi Super Mario 3 e compare com New Super Mario Bros rodando no Switch cujo SoC Tegra X1 tem na faixa de 7 bilhões de transistors com 4 cores ARM Cortex A57 ativos.







Vamos descer um pouco mais hardcore pra dar mais contexto com o tipo de CPU que estamos trabalhando. Adição eu disse que fazemos mais ou menos do mesmo jeito que você faria no papel somando digito a digito e subindo 1 quando precisa. Se hoje em dia temos transistors de sobra nas CPUs, nos 3500 que tinha num 6502, cada transistor contava. Então só era implementado o estritamente necessário. Somadores completos numa cadeia de 8 bits está implementado na instrução ADC.







Se recapitularmos sobre o pouco que aprendemos sobre assembly do 6502, pra realizar uma adição de números de 8 bits, faz de conta, o número 1 mais 2 poderíamos fazer assim.

```
	LDA #$01
	ADC #$02
	STA $6000
```



Começa com LOAD do número 1 no acumulador, ADC que é adição com carry onde passamos 2 e ele vai somar com o número 1 que já tava no acumulador, daí armazena ou Store do resultado que fica no A pra algum endereço na memória, como o endereço $6000 que, no video anterior, ia mandar pro chip de trava e de lá pro LCD. Isso é uma coisa que hoje em dia você não se preocupa porque as linguagens de programação já cuidam disso, mas o 6502 faz cálculos com números de 8-bits. O valor máximo que cabe em 8 bits sem sinal é FF ou 255. O que acontece se eu tentar somar 255 + 255? Precisamos de mais bits.







Só porque uma CPU é de 8-bits não quer dizer que não podemos calcular números maiores, mas pra fazer isso precisamos particionar o número e lidar com pedaços dele. Por exemplo, digamos que tivéssemos uma CPU decimal mas que só faz conta com números de 2 dígitos de cada vez, então de 0 até 99. Se somarmos 99 + 5 teríamos 104. Precisaríamos gravar o 1 separado do zero quatro. No caso da soma, eu disse que todo somador completo lida com 1 bit do número. A instrução ADC é como se fossem 8 somadores completos em cadeia pra 8-bits.







Uma nomenclatura que às vezes você vai esbarrar é high order e low order. Quando lidamos com 16-bits, temos 2 bytes. O primeiro byte à esquerda chamamos de high byte e o último à direita de low byte. Dentro de cada byte tem 8-bits o bit mais à esquerda é o MSB ou Most Significant Bit e o último bit é o LSB ou Least Significant Bit, literalmente bit mais significativo e menos significativo. Lembra quando expliquei sobre little endian no episódio anterior? É pegar os 2 bytes e inverter, assim o low byte é lido antes do high byte. 







Voltando pra soma, toda vez que tiver um "sobe 1" ele vai ser gravado no registrador C. Antes de toda soma o certo é usar a instrução CLC, literalmente Clear C, pra limpar esse registrador. Mas podemos não limpar também. Lembra que falei que registradores funcionam como varíaveis globais? Várias instruções deixam efeitos colaterais pra trás, deixando registradores com a sobra do que foi processado. E podemos usar isso a nosso favor, começar somando a primeira metade do número até 8-bits, e depois somar a segunda metade que vai usar o carry no C e continuar a soma com o resto dos bits. Por exemplo, digamos que temos um número grande, de 24-bits tipo o número 2 milhões. Seriam 3 pedaços de 8 bits cada que podemos chamar de high, medium e low byte.







Declaramos então os 3 pedaços do primeiro número A como A hi, A mid e A lo, depois B hi, B mid e B lo. Começamos limpando o registrador C, fazemos a soma dos bytes low, que é dar load no A low, adicionar com B low e guardar esse resultado parcial em B low; depois mesma coisa com os bytes medium e high. A soma final é a junção dos três pedaços de B. 


; ex: 8 milhões = $7A 12 00, A_hi = $7A, A_mid = $12, A_low = $00
A_hi,  A_mid,  A_lo 
B_hi,  B_mid,  B_lo


START:  CLC         ; Clear C only to start.
        LDA  A_lo
        ADC  B_lo
        STA  B_lo

        LDA  A_mid  ; Note that here we don't re-clear C, but just
        ADC  B_mid  ; let it do its job of adding the 9th bit that
        STA  B_mid  ; didn't fit in the result of the previous byte's
                    ; addition.
        LDA  A_hi
        ADC  B_hi
        STA  B_hi




Pense na sua linguagem favorita, você nunca se preocupa com isso, simplesmente escreveria `A + B`. Como você tem processamento e memória de sobra e seus programas nunca são particularmente complicados, mesmo que tenha desperdícios, não chega a ser um problema. Mas quando seus recursos são extremamente limitados, desperdiçar bits é um problema real. Desperdiçar ciclos também, porque cada instrução gasta alguns ciclos de clock. Nada sai de graça. Um processador moderno roda na faixa de 2Ghz a 5Ghz hoje em dia, mas um 6502 roda entre 1 a 3 Mhz.







Portanto em máquinas pequenas como o 6520 queremos tanto economizar a quantidade de memória usada quanto o número de instruções pra não desperdiçar clocks. Literalmente podemos fazer dezenas de milhões de instruções a menos por segundo num 6502 do que num processador moderno de qualquer smartphone hoje. Fazer programas simples num computador excessivamente poderoso é muito fácil, qualquer um faz. Eu sempre digo que você sabe quando um programador é bom quando ele consegue programar num sistema com restrições, porque a arte de programar é conseguir tirar o máximo que o hardware oferece.







Vamos dar outro exemplo besta. Já sabemos como CPUs fazem adição. Subtração e multiplicação é a mesma coisa. Podemos desenhar circuitos como no caso do somador completo e implementar com transistors. Como falei antes, no 6502 temos a instrução ADC pra adição e também temos SBC pra subtração, mas não tem multiplicação. 







Digamos que você, que nunca estudou nada de engenharia ou ciências da computação pense numa forma de implementar multiplicação só usando operações básicas que falamos até agora como adição, o que você faria? Eu aposto como a solução mais imediata que a maioria pensaria seria via adições sucessivas. Por exemplo se quisermos multiplicar 278 vezes 7, você iria somando 278 sete vezes até dar 1148. Seriam só 7 adições e não parece tão ruim assim. Aquele famoso caso de "testei aqui e no meu computador funciona".








Mas e se quisermos multiplicar 10 mil vezes 10 mil? Agora precisa fazer 10 mil somas pra chegar no resultado. Isso é consideravelmente mais devagar e com números maiores só vai piorando. Vamos usar tempos hipotéticos só pra ilustrar. Pra somar cada bloco de 8 bits digamos que precisariamos gastar uma instrução de LOAD, uma de ADC e outra de STORE, cada um custando uns 5 ciclos de clock. 10 mil é um número que podemos representar em 2 bytes ou 16 bits. Então são pelo menos 2 loads, 2 adc e 2 stores pra cada rodada. 







Então temos 6 instruções custando uma média de 5 ciclos de clock, ou seja 30 ciclos. Em 1 Mhz podemos ter no máximo umas 33 mil sequências dessa por segundo. Mas se precisamos executar 10 mil sequências de soma dessas gastaríamos 1/3 de segundo ou pelo menos 300 milissegundos. Lembrando que estou considerando condições ideais de temperatura e pressão, como a gente falava no colégio, mas provavelmente gastaria mais ciclos que isso. Parece pouca coisa mas 300 milissegundos é mais tempo que leva pra você pedir uma página num site, ele processar, retornar o HTML e seu navegador renderizar. Aliás, se sua aplicação web demora 300 milissegundos pra responder, isso é considerado lento quase parando.







Pra variar, não existe uma fórmula universal de multiplicação que tem 100% de melhor performance pra todos os casos. O bom senso é o contrário: fórmulas universais costumam ser lentas. Isso é uma coisa que, como programador, você precisa entender: existem fórmulas que funcionam melhor pra casos diferentes. Por exemplo, no episódio anterior eu já disse como faz multiplicação por 2: basta fazer um shift left, que é o equivalente a adicionar um zero no final do binário e pronto, tá multiplicado numa única instrução.






Você não conhece formas diferentes de multiplicar? Deixa eu contar um diferente. Existe um método ensinado no primário de escolas Russas que ficou famoso porque a gente associa tudo que é russo com excelência em matemática. Na real é um método bom pra números pequenos e não é particularmente bom pra computadores. É chamado de método do camponês russo. Vou explicar de curiosidade.








O método é assim: dobre o primeiro fator, divida o segundo fator pela metade. Se o segundo fator for par ignore e repita. Se o segundo número for ímpar, some o primeiro fator com o anterior. Por exemplo, digamos que eu quero multiplicar 278 por 7 como falamos antes. Primeiro dobramos o primeiro fator. Multiplicar por 2 todo mundo consegue fazer de cabeça e vai dar 556. Daí 7 divido por 2 é 3. 3 é impar então somamos 556 com 278 e temos 834. Agora dobramos 556 de novo e vamos ter 1112. No segundo fator temos 3 dividido por 2 que é 1, que é impar, então somamos com 834 com 1112 e vamos ter 1.946. Como o segundo fator chegou a 1 acabamos e a resposta é 1.946. Pode abrir uma calculadora aí e checar.







Não é difícil implementar isso em Assembly. Existe um site excepcional que é a fonte de referência de qualquer um que quer implementar um emulador de NES que é o Wiki Nesdev e quando fala de multiplicação ele implementa justamente esse algoritmo do camponês russo que fica assim:


https://wiki.nesdev.com/w/index.php/8-bit_Multiply

```
;;
; Multiplies two 8-bit factors to produce a 16-bit product
; in about 153 cycles.
; @param A one factor
; @param Y another factor
; @return high 8 bits in A; low 8 bits in $0000
;         Y and $0001 are trashed; X is untouched
.proc mul8
prodlo  = $0000
factor2 = $0001

  ; Factor 1 is stored in the lower bits of prodlo; the low byte of
  ; the product is stored in the upper bits.
  lsr a  ; prime the carry bit for the loop
  sta prodlo
  sty factor2
  lda #0
  ldy #8
loop:
  ; At the start of the loop, one bit of prodlo has already been
  ; shifted out into the carry.
  bcc noadd
  clc
  adc factor2
noadd:
  ror a
  ror prodlo  ; pull another bit out for the next iteration
  dey         ; inc/dec don't modify carry; only shifts and adds do
  bne loop
  rts
.endproc
```


Você dá load do multiplicador no acumulador, load do multiplicando no registrador Y e roda essa rotina e ele vai gravar o low byte do resultado no endereço $0000 e o high byte em A. Lembra que números maiores que 8-bits fica particionado em múltiplos bytes? O resultado de uma multiplicação costuma ser um número com o dobro de bytes dos fatores, então multiplicar 2 números de 8 bits dá um resultado de 16 bits.







Esse algoritmo gasta em torno de 150 ciclos. Se seu programa for ter poucas multiplicações pode ser suficiente. Mas qualquer operação que gasta mais que 100 ciclos num 6502 não é exatamente rápido. Existem maneiras mais rápidas que isso. E aqui vem outro insight que como programador você precisa ter na cabeça. Algoritmos costumam ser um balanço de dois fatores: se você quiser economizar memória vai acabar gastando mais ciclos de processamento. Se quiser velocidade economizando ciclos provavelmente vai gastar mais memória. Por exemplo, vamos pensar um pouco mais: como você faria multiplicações rápido no primário, sem calculadora?









Pra números pequenos você provavelmente teria que ter decorado a tabuada, lembram disso? Tenho certeza que a maioria odiava ter que decorar a tabuada. Mas lembrem de uma coisa, a tabuada é uma tabela pré-calculada. Você procura o multiplicando e o multiplicador e instantaneamente tem a resposta. Imagine uma tabela pré-calculada pra todos os números que cabem em 8-bits. Daí basta achar a posição na matriz com o resultado direto. Você vai gastar ciclos pra pré-calcular a tabela da primeira vez ou pode ler direto a tabela de uma ROM. O problema dessa solução é que fácil fácil ela vai ocupar 16 kilobytes de espaço ou mais. Considerando que um Super Mario Bros inteiro cabe em 40 kilobytes estamos falando em gastar 1 terço disso só numa tabela de números, o que seria um enorme desperdício.








Uma tabela pré-calculada é o que chamamos de lookup table e isso é uma técnica usada em todos os lugares da computação. Você que faz desenvolvimento web provavelmente já usou ou vai usar isso. Por exemplo quando faz cache com um Redis ou Memcache, é um lookup table. Quando cria índices numa tabela de banco de dados, isso é um tipo de lookup table. O problema é que se essa tabela for grande demais, o tempo pra procurar na tabela também pode começar a ser um problema, fora desperdício de espaço caso você não planeje direito.








Mas como seria uma maneira melhor então? E aqui a matemática nos ajuda. Se você estudou Álgebra e trigonometria não vai achar estranho o que vou dizer a seguir. Uma multiplicação de dois fatores a e b pode ser descrita de maneiras diferentes. Por exemplo, ela pode ser a exponencial da soma dos logaritmos de a e b. Se quiser ser mais complicado pode ser a soma do cosseno de x mais y com o cosseno de x menos y, tudo dividido por 2. Sendo que x é o arco cosseno de a que também é chamado do cosseno inverso. Arco cosseno é usado pra determinar o ângulo do cosseno em radianos. Y da mesma forma é o arco cosseno de b.







Continuando, a vezes b pode ser também o quadrado de a mais b, menos o quadrado de a, menos o quadrado de b, tudo dividido por 2 ou, finalmente, pode ser o quadrado de a mais b menos o quadrado de a menos b tudo dividido por 4. E essa opção final é que nos interessa, pois podemos reduzir a fórmula pra ser a subtração de a mais b aplicado numa função F, com a menos b na mesma função F, sendo essa função F o quadrado do número que passarmos dividido por 4. 







A parte importante é que decompomos o problema da multiplicação numa adição dos fatores, subtração dos fatores e subtração do resultado da tal função F. E a essa função reduz o tamanho do lookup table pra em vez de ser todos os possíveis resultados da multiplicação de todos os números de 8-bits, pra simplesmente ter uma tabela só com o resultado da multiplicação do quadrado dos números. Ou seja, de 1 vezes 1, de 2 vezes 2, de 3 vezes 3 e assim por diante, que é uma quantidade pré-calculada ordens de grandeza menor, caindo dos 16 kbytes que eu falei pra talvez meio kbyte.






E pra calcular o quadrado de todos os números também vai ser rápido porque existe a propriedade que o quadrado do número é o quadrado do número anterior mais um número impar. Quadrado de 1 é zero mais 1. Quadrado de 2 é o 1 anterior mais o próximo impar que é 3, resultado 4. Quadrado de 3 é 4 mais o próximo impar 5 que dá 9. Quadrado de 4 é 9 mais o impar 7 que dá 16. Quadrado de 5 é 16 mais o próximo impar 9 que dá 25 e assim por diante. 






E como eu disse no começo, dá pra ir longe estudando sobre assembly. Outros assuntos que tava pensando em cobrir neste episódio incluíam o conceito de complementar de dois, números inteiros com sinal pra lidar com negativos, algoritmo de Booth pra multiplicação e muito mais. Mas é teoria demais pra um único video, por hoje vou parar por aqui. Mas eu queria gastar pelo menos um pouco de tempo mostrando essa linha de raciocínio pra vocês entenderem que não, hoje em dia você dificilmente vai gastar tempo implementando uma multiplicação na mão. Toda CPU já implementa as melhores fórmulas em hardware e pra quem precisa de casos específicos existem bibliotecas voltadas pro campo científico que otimizam os piores casos.









Mas é importante você entender que tudo que uma linguagem te oferece, cada pequena coisinha insignificamente como aquele mero asterisco de multiplicação teve milhares de horas homens de pesquisa, experimentação, otimizações. Literalmente muito suor e lágrimas até chegar no estado da arte que você usa hoje sem nem pensar. É isso que significa subir nos ombros de gigantes, porque é com o conhecimento testado e acumulado de centenas de anos de matemática que esse asterisco de multiplicação se tornou possível e você consegue multiplicar dois números de praticamente qualquer tamanho em microssegundos.








E também é pra entender que muita coisa hoje ainda não tem uma fórmula perfeita. Eu disse que temos CPUs com dezenas de milhões de vezes mais transistors que um 6502 mas ainda assim não temos programas dezenas de milhões de vezes melhores. Isso porque muitas partes do software que usamos ainda não tá rodando da melhor forma possível. Grande parte do que é o trabalho de um programador é não ignorar os problemas e parar pra tentar encontrar formas mais inteligentes de fazer o computador processar.








Muito bem, vamos voltar ao nosso nintendinho. Assim como no exemplo do protoboard do Ben Eater, o PCB que é sigla pra Printed Circuit Board ou placa de circuito impresso, contém o cérebro que é o 6502 e diversos outros chips como chip de RAM, chip de VRAM que é memória de vídeo, e outros componentes como pra ligar seus controles. Tem a PPU que é o Picture Processing Unit ou unidade de processamento de imagens que é a versão primitiva do que hoje você chamaria de GPU. E tem o APU ou audio processing unit pra gerar som.






O nintendinho já foi tão dissecado nas últimas décadas que temos documentação super completa de cada componente em detalhes suficiente pra ter muita gente fabricando chips e PCB novos. Você consegue literalmente comprar um hardware moderno de nintendinho hoje se quiser, e ele vai ser 100% compatível com qualquer cartucho que você tenha guardado. 






Mas pro que me interessa, a documentação é tão boa que é possível criar emuladores em software que se comportam exatamente como o hardware. Eu não sei se vocês conseguem entender a beleza disso. Todo hardware tem a capacidade de simular o comportamento de outro hardware via software. E praticamente toda linguagem de programação consegue representar qualquer hardware.








Tendo documentação tão completa como o Wiki Nesdev que eu mencionei antes, poderíamos escrever nosso próprio emulador. E como alguém faria isso? É um processo mais trabalhoso do que difícil porque você precisa ter o trabalho meticuloso de implementar cada detalhe que tá nas documentações, mas por exemplo, podemos começar criando um projeto vazio, digamos usando a linguagem Go. Aliás, como o nintendinho é bem antigo, qualquer linguagem hoje consegue simular um 6502 e os outros componentes.







Não existe "O" jeito correto de se escrever um software. Se você pegar diferentes emuladores de nintendinho vai ver que eles são organizados e escritos de maneiras diferentes. Só com experiência e muitos testes você vai chegar no que é o melhor balanço entre legibilidade e eficiência. Mas pra ser simples podemos pensar nos componentes principais que eu listei. O primeiro elemento que queremos emular é o console, então começamos criando um arquivo chamado console.go e dentro definimos o tipo Console como uma estrutura. E não se preocupe se você nunca viu Go, não é relevante entender cada linha do código hoje, só o raciocínio. Estude depois com calma.







Essa estrutura vai declarar ponteiros pra CPU, pro APU, pro PPU, pro cartucho, pros dois controles, pra um troço que vou explicar depois chamado Mapper, e delimitamos a RAM que é só um array. Lembram todos aqueles hexadecimais que eu falei no video anterior? Pense nesses números como posições no array. Memória é isso: uma listona de bytes. Agora precisamos criar arquivos pra cada um desses componentes e definir as estruturas de cada um. O próximo é o arquivo cpu.go.






A estrutura CPU vai ter muitos dos elementos que eu expliquei no vídeo anterior. Começamos definindo uma referência pra uma estrutura de Memory que vou explicar depois. Daí definimos PC que é o contador de programa como um inteiro gigante de 64-bits, e nem precisava ser tão grande porque ele só aponta pro endereço da próxima instrução, então 16-bits bastava. Vamos definir o SP que é o apontador de pilha como um inteiro de 16-bits. Daí os registradores todos de 8 bits, ou seja 1 byte. Temos o acumulador A, o X, o Y, o C, Z, I, D, B, U, V, N. E por fim temos uma última estrutura importante, um array de instruções.






Lembra que cada instrução como LDA tem um hexadecimal associado, que é basicamente o endereço da localização dessa instrução? Pois é, precisamos colocar cada opcode na posição correta nessa lista. Quando quisermos achar a instrução 0xa9 que é o LDA vamos pra posição 0xa9 que é a posição 169 nessa lista. Daí vamos encontrar a referência pra uma função de Go. Agora precisamos implementar cada uma dessas funções.





Por exemplo, o nosso LDA sabemos que vai escrever o valor no registrador A que é o acumulador. Então em Go é simplesmente associar o valor do argumento na variável A da CPU. 

Sabemos também que JSR é o Jump pra uma subrotina, o que ele faz é empurrar o endereço no contador de programas pra pilha e sobrescrever o contador de programa com o endereço da subrotina pra onde tem que pular.







E assim vai, tem que escrever uma função pra cada instrução que existe de acordo com a especificação na documentação do 6502. Uma vez feito tudo isso podemos criar o inicializador NewCPU que vai alocar a estrutura que definimos. Esse inicializador recebe uma referência pra estrutura de console que criamos antes pra passar pra essa nova estrutura chamada Memory. Deixa esse Memory de lado que ainda não é hora pra ele. Em seguida criamos e populamos a tal tabela com referências pras instruções que criamos. Finalmente criamos uma rotina de reset.






Reset é o que você pensou mesmo: o equivalente a você apertar o botão reset que todo console e computador tem. A idéia é limpar o contador de programas pra apontar pro endereço 0xFFFC, lembra no episódio anterior que quando o 6502 inicializa a primeira coisa que ele faz é ir no endereço 0xFFFC procurar a primeira instrução do programa? Pois é. E em seguida limpamos o apontador de pilha pra iniciar em 0xFD. Isso é pra relembrar a importância desses dois registradores, porque é com eles que conseguimos executar um programa.






Tem mais coisas que precisam ser feitas pra CPU ficar completa mas por agora vamos pular pra essa tal de Memory criando um arquivo memory.go. A estrutura em si é muito simples. Ela só vai apontar pra uma referência à estrutura de Console que já definimos antes. A parte importante começa com a função de leitura Read. Ele recebe um endereço e vai devolver algum valor que teoricamente está em alguma lugar na tal memória.






Aqui começa a diferença de um nintendinho e outros computadores que usam o processador 6502 como um Atari ou Apple II, o mapa de memória. No episódio anterior eu expliquei que temos endereços de 16-bits então podemos mapear do endereço 0x0000 até 0xFFFF, daí dividimos esse espaço e por exemplo a CPU ia procurar no EEPROM se passássemos endereços acima de 0x8000. Ou seja, arbitrariamente definimos que certos chips respondem a certos endereços.






A grosso modo, do endereço 0x0000 até 0x07FF temos 2 kilobytes de RAM. Nos endereços de 0x2000 a 0x2007, que é bem curto, temos registradores pra PPU. De 0x4000 a 0x4017 acessamos a APU e registradores de I/O como os controles e só de 0x8000 a 0xFFFF temos o equivalente a uns 32 kilobytes reservados pra endereços que mapeiam pra algum lugar do cartucho. Em particular se acessarmos acima do endereço 0x6000 temos esse negócio que colocamos no código chamado Mapper. Agora vocês precisam entender os truques que eram usados em consoles com cartuchos.







Se sua história com games começa só depois do Playstation 1, você tá acostumado a ter os games em CDs, DVDs, Blu-Ray ou instalados no HD do seu computador. É de praxe que toda vez tem que esperar o famoso "Loading", que é o tempo do computador começar a carregar os primeiros bytes do jogo na RAM pra só depois conseguir começar a jogar. Daí a cada fase tem que carregar novos bytes pra RAM e jogar fora os bytes da fase anterior que não vai precisar mais. Isso é necessário porque não cabe todo o jogo na memória. Um computador muito bom hoje tem 16 GB, mas qualquer jogo moderno tem 30 GB, 40GB, alguns jogos podem ter absurdos 100GB. Obviamente não cabe tudo na RAM então precisa ir carregando e descarregando de pedaço em pedaço. 









Com cartuchos é diferente. O que tem num cartucho são chips de ROM, como expliquei no episódio anterior. Então quando você pluga o cartucho no console, não existe loading, não tem que carregar nada e ele pode iniciar imediatamente porque a CPU acessa os endereços diretamente da ROM, sem precisar carregar o jogo em memória. O cartucho "É" a memória. Entenderam? Diferente de CD ou HD, a ROM do cartucho já tem velocidade máxima de acesso, igual da RAM. Da mesma forma que a CPU consultaria um endereço na RAM, no caso pedindo endereços de 0x0000 a 0x07FF, quando ele precisa de dados do jogo ele pede nos endereços acima de 0x8000 até 0xFFFF. 








Por isso jogos de consoles antigos carregam instantaneamente e não tem loading entre fases e tudo é rápido. Um dos maiores gargalos ainda não resolvidos em games modernos de fato é a lentidão do I/O, não só do HD mas de toda a cadeia que carrega dados, incluindo barramento, controlador e tudo mais. Inclusive é isso que a nova geração de consoles PS5 e Xbox Series X estão tentando combater colocando os SSDs e controladores mais rápidos do mercado pra minimizar ao máximo o tempo de carregar coisas do disco. Mesmo assim o tempo nunca vai ser zero como era nos cartuchos.







Vou repetir o que eu disse antes: programação é sempre um trade off, uma troca. Cartuchos tem tempo quase zero de acesso porque ele é direto um chip de memória. O problema é que chips de ROM são muito mais caros de produzir comparado a discos de HD ou Blu-Rays. É bem mais caro. A comparação mais óbvia foi na transição dos cartuchos pro CD quando saiu o Playstation 1 e o concorrente na época era o Nintendo 64 que preferiu usar cartuchos pelas razões que eu acabei de falar.







Jogos de Playstation podiam ter videos e muito mais conteúdo porque num CD daquela época era possível colocar até 650 megabytes de dados. Em comparação um dos maiores cartuchos de Nintendo 64 era Conker's Bad Fur Day que tinha enormes 60 megabytes, ou seja mais de 10 vezes menos espaço e o cartucho ainda custava mais caro. Os lendários Zelda Ocarina of Time e Majora's Mask eram cartuchos de menos de 30 megabytes. Por isso jogos de Nintendo 64 raramente tinham algum video e também por isso preferiam usar o mínimo de texturas nos modelos em 3D, porque texturas são imagens bitmap que consomem muito espaço. 








Voltando pra era dos 8-bits. Um cartucho como do Super Mario original tem 40 kilobytes, portanto male male encaixa no nosso espaço de endereços reservados pra ROM. Mas um Super Mario 3 tem 385 kilobytes, quase 10 vezes mais bytes que o original. Um dos jogos mais pesados do nintendinho é Kirby's Adventure e se você rodar vai ver um dos games mais bem elaborados pro nintendinho, chega perto do que seria um jogo de Super Nintendo. Também pudera, o cartucho dele tem quase 800 kilobytes, perto de 1 megabyte.







Mas como é possível endereçar isso tudo de bytes só com endereços de 16-bits? Agora vem o segundo grande fato sobre cartuchos: eles não tem só chips de ROM. Na realidade um cartucho é uma placa de expansão, um PCB completo. Quando falo em placa, pense mesmo como quando você compra uma placa gráfica como um novo NVIDIA RTX e espeta no slot PCI Express na placa mãe do seu computador. Encaixar um cartucho no console é a mesma coisa.






Num PCB você pode plugar não só ROM como qualquer outro componente. Por exemplo, você pode colocar um chip de SRAM e uma bateria de lítio e boom, você acabou de ganhar a capacidade de salvar o jogo. Só que isso torna o cartucho ainda mais caro, por isso nem todo jogo podia salvar. Um dos chips mais famosos se você jogou Super Nintendo foi o chip Super FX, que literalmente era uma placa primitiva 3D que permitiu jogos como Star Fox. O processo é o mesmo, o chip vem no PCB do cartucho.







Você literalmente poderia enfiar um nintendinho inteiro dentro de um cartucho. Mas só isso não responde a pergunta de como fazia pra um Kirby ter quase 1 mega de dados. Não basta só enfiar mais chips de ROM se não temos endereços suficientes pra passar de 32 kilobytes. Endereços funcionam como o nome diz, é como se tivéssemos uma rua de casas e só tivesse 32 números, da casa 33 em diante ficaria sem números. Se o carteiro precisasse entregar alguma coisa nessas casas como ele encontra?







E se nessa rua colocássemos um síndico? Que separasse a rua em blocos? Daí teria casa de 1 a 32 no bloco A, casas de 1 a 32 no bloco B e assim por diante. Continua só tendo 32 números mas dependendo do bloco sempre encontraríamos uma casa diferente. E é exatamente isso que o nintendinho faz. No cartucho, além de vir mais ROM ele vem com um síndico, um controlador que chamamos de Mapper. 





Como o nome diz, Mapper é um mapeador. Em vez de blocos na rua do nosso exemplo a memória ROM é dividida em Banks ou bancos. E a técnica pra enxergar mais memória se chama Bank switching. A CPU continua só conseguindo enxergar dos endereços 0x8000 a 0xFFFF mas ele pode pedir pro Mapper trocar os banks, assim como no exemplo dos blocos da rua. Os banks costumam ter 16 kilobytes de tamanho e podemos ter vários banks, então se montarmos o cartucho com ROM suficiente pra 50 banks de 16 kilobytes, vamos ter os quase 800 kilobytes do jogo Kirby.







Agora vem a parte cabeluda pra fazer emulador de NES: não basta só escrever código que representa o console, precisa também emular os chips que vem nos cartuchos, em particular esses mappers. Você poderia imaginar que deve ter alguns poucos modelos de mappers. Mas que nada, se olhar a biblioteca toda de games de nintendinho existem 407 mappers que foram encontrados e documentados. Por sorte, se você cobrir os mappers da própria nintendo e alguns de marcas famosas como Konami, já cobre a maior parte dos jogos. Muitos mappers só existem em jogos muito obscuros, feitos na China ou lugares assim.







Se você olhar de novo no wiki da nesdev vai encontrar o código que vem no cartucho que identifica qual mapper ele tem. No arquivo de Memory ele vai selecionar um Mapper baseado nesse código identificador que ler da ROM. Daí precisamos de cada um dos Mappers, que precisam responder às mesmas funções. Por isso no nosso arquivo de mapper vamos definir uma interface que todos os mappers vão ter que implementar. Basicamente definimos o que um Mapper precisa obrigatoriamente fazer, que é ler da ROM, gravar na RAM e coisas assim. 







No inicializador pegamos o cartucho associado no console. Depois que carregarmos uma ROM ele vai preencher esse campo Mapper com seu código identificador, e com isso podemos checar qual mapper vamos ter que carregar. Neste pequeno emulador em Go vai ter só alguns dos principais. De curiosidade esse último mapper código 225 é que permite aqueles cartuchos de 52 jogos em 1 que você já deve ter visto por aí. Um cartucho desses tinha 6 chips de ROM com meio megabyte cada.






Não vou entrar no detalhe de cada um, senão a gente fica aqui até o ano que vem, mas só pra mostrar um, podemos criar um arquivo pro mapper 2. Lembrando que no nosso caso, usando máquinas modernas, não temos esses limites pequenos de 16-bits. Podemos carregar a ROM de um cartucho como um arrayzão contínuo de bytes, seja lá quantos bytes tiver porque temos espaço pra mapear tudo. Então recebemos o endereço que o CPU manda e mapeamos com esse arrayzão. 






No caso, o que nos interessa é que quando carregamos a ROM os bytes são identificados como regiões distintas, sendo as duas principais o PRG e CHR. PRG são bytes de programa. CHR são os bytes de caracteres, que é a área onde normalmente estão os tiles. Eu sempre chamo de tiles mas se for traduzir é como se fossem azulejos. Tiles, azulejos, caracteres, são termos que significam a mesma coisa.





O princípio de tiles é simples. Um CPU como o 6502 não fica dando instruções pra escrever pixel a pixel na tela. Ele pede pra escrever tiles. Pense num nintendinho como um editor de textos. Um editor não escreve pixel a pixel na tela, ele escolhe uma letra de alguma família de fontes, digamos Arial, e passa o código que representa ela. E o Windows ou MacOS da vida que vai se encarregar de realmente desenhar os pixels.







No nintendinho quem se encarrega de desenhar os pixels é o chip chamado de PPU que eu falei que é a unidade de processamento de pixels. O CPU não entende pixels, ele entende tiles. Significa que o PPU tem que trabalhar bastante pra desenhar pixel a pixel. Inclusive o clock do PPU é maior que do CPU. Mas a CPU só precisa mandar um byte pra identificar blocos de 8 por 8 pixels de uma vez só, em vez de mandar 64 comandos independentes pra cada um desses pixels.







Se você é de web front-end já lidou com algo assim, é como os sprites de CSS. Aliás a técnica de sprites de CSS não é novidade, isso é uma técnica antiga. Outra técnica antiga são fontes com imagens, como a Font Awesome que todo site hoje usa pra desenhar icones. A memória CHR da ROM que eu falei é como se fosse uma Font Awesome, literalmente caracteres. Cada caracter, ou fonte, é um tile. Acho que assim vocês conseguem visualizar na cabeça. Consoles antigos assim sequer tem fontes ou tabela de letras. Cada jogo define suas fontes e o código das letras, não tem um padrão como ASCII ou Unicode.








A PPU enxerga a resolução máxima de 256 por 240 pixels, e a CPU só enxerga uma grade de 16 por 15 espaços onde cabem os tiles. É parecido com um computador DOS antigo que tem resolução de 640 x 480 mas em modo DOS só enxerga 80 colunas por 25 linhas de texto. O PPU também só consegue enxergar 8 kilobytes de tiles de cada vez, então toda vez que precisamos de tiles diferentes, o CPU pede pro Mapper trocar o banco por outro. Existem dois excelentes emuladores pra quem quer aprender a programar jogos de verdade de nintendinho. Um deles é o FCEUX que acho que é o mais conhecido e o outro é o Mesen que eu acho que tem ferramentas mais modernas.







Vocês entenderam o que fizemos até agora? Eu fui estruturando o nintendinho como código de Go. Cada aspecto dele são estruturas de dados normais como arrays e bytes. Bytes na memória que sabemos exatamente onde estão e com isso podemos consultar a qualquer momento. Seja o emulador feito em Go, em C ou C++ vai ser a mesma coisa. O emulador Mesen implementa de forma parecida mas além de só emular ele expõe essas estruturas de forma visual em tempo real. Por exemplo, podemos abrir um visualizador da memória da PPU e organizar pra vermos os bitmaps.






E olha só o que tem na memória da PPU, esses são os tiles. Cada tile é um quadrado de 8 por 8 pixels. Se eu não estou enganado, podemos associar até 4 cores pra cada um, dentre 12 cores de uma paleta, num total de 4 paletas que posso escolher. Em outra aba podemos ver as 12 cores da paleta de background e outras 12 cores da paleta pros sprites. Se você já brincou de front-end, HTML e CSS certamente já viu código de cores em hexadecimal, é a mesma coisa.






Como a localização dessa área CHR na ROM é conhecida, podemos editar o que tem lá. Os tiles são bitmaps não comprimidos. Hoje em dia você tá acostumado a lidar com imagens comprimidas como JPEG que usa um algoritmo lossy, ou seja, que perde detalhes da imagem pra reduzir o tamanho. Um bitmap é exatamente o que o nome diz, um mapa de bits, nas posições exatas pra formar a imagem e sem  compressão.






Só pra mostrar como podemos afetar o jogo, com o Mesen rodando podemos editar as cores da paleta de background e trocar a cor do céu de azul pra outra cor. Ou podemos mexer na paleta de sprites e trocar a cor do Mario. Você pode mudar completamente a aparência do jogo só de ajustar as cores dessa forma.






Repetindo, pense na tabela de tiles como se fosse uma tabela de fontes de letras. Aliás, o nintendinho sequer tem fontes. Ele não tem um sistema operacional, o jogo começa rodando direto no hardware, sem nenhuma camada intermediária pra ajudar. Então se um jogo quer escrever textos na tela, ele próprio precisa embutir tiles de fontes. E de fato você vai ver que normalmente começando no endereço zero dessa área CHR costuma ter letras, números e símbolos. Aqui o número zero é a posição zero mesmo, o número um é posição um e assim por diante. E começando do zero até a letra F fica bonitinho de 0 a F em hexadecimal.







Lembra quando usamos no Linux a ferramenta hexdump ou xxd e na terceira coluna ele tenta interpretar bytes que mapeiam pra tabela ASCII como letras e às vezes aparecem textos mesmo? Numa ROM de videogame isso não funciona porque os códigos das letras não seguem a tabela ASCII. Mesmo entre jogos diferentes a posição das letras na ROM não é a mesma. Por isso em emuladores com debug como o Mesen e FCEUX podemos carregar nossa própria tabela que mapeia código das posições dos tiles pra letras, como essa na tela que é um arquivo texto com extensão TBL. Assim podemos tentar reconhecer algum texto no meio do binário.








Vejam no espaço PRG da ROM que não dá pra identificar nada. Mas carregando a tabela começamos a reconhecer quais bytes são textos. E com isso posso editar o texto, por exemplo trocando de MARIO pra FABIO. Resetamos o jogo e olha só como aparece meu nome. Podemos trocar todos os textos num cartucho e salvar o binário por cima, contanto que o texto novo caiba no mesmo espaço usado pelo texto antigo. Esse é o hacking mais simples de todos e que todo mundo que já brincou com binários já fez na vida. É assim que muita gente traduziu cartuchos japoneses pra inglês, por exemplo. Se tiver filhos pequenos imagino que eles vão gostar de ver os nomes deles nos jogos.









E podemos editar o binário não só do texto como dos tiles. Por exemplo, existem programas como o Tile Layer Pro. Se abrirmos a ROM do Super Mario, no começo vamos ver um monte de sujeira que são bytes de programa, mas se descermos vamos encontrar os tiles do jogo. Pra enxergar melhor podemos mudar a paleta e rapidamente vamos começar a reconhecer alguns, como os tiles que formam o personagem. Pra ver melhor, podemos arrastar os tiles pra esta outra janela e montar como um quebra cabeça. O Mario grande é formado por seis tiles. Na ROM tem a sequência pra cada posição da animação, seja correndo ou pulando. 







Podemos fazer mais, podemos editar cada tile e mudar o jogo completamente. É um puta trampo editar tile a tile mas se tiver paciência fazendo isso eu poderia pegar os bits de tiles de um Zelda ou Megaman e mudar o Mario pra ser o Link, ou qualquer outro personagem que caiba em seis tiles ou menos. E só com as técnicas eu mostrei aqui você poderia fazer um novo jogo usando um que já existe como base.






Sabe quem já fez isso? A Tectoy aqui no Brasil. Por causa deles nós somos o único país no mundo que ainda produz Master System novo até hoje. O Master System foi o concorrente do nintendinho nos anos 80. Também é um console de 8 bits mas no papel ele era tecnicamente superior. Em vez do MOS 6502 de 1.8 Mhz o Master System vinha com o Zilog Z80 que ia até 3.5 Mhz, quase o dobro de clock. Em vez de 2k de RAM e 2k de VRAM ele vinha com 8k de RAM e 16k de VRAM. Em vez de ser limitado a ter só 16 cores na tela, ele podia ter 32 cores, por isso jogos de Master System sempre parecem mais coloridos e vivos








Essa discussão de especificações e jogos sempre foi uma constante nas rodas de gamers. Um Xbox One X é tecnicamente mais poderoso que um PS4 Pro, mas o Playstation continua tendo alguns dos melhores jogos exclusivos como God of War ou Spiderman. Nos anos 80 não era diferente. O Master System era mais poderoso mas as marcas que chamavam mais atenção estavam no Nintendinho.






De qualquer forma o Master System conseguiu um público cativo aqui no Brasil e a Tectoy começou não só a licenciar e distribuir jogos estrangeiros como começou a lançar jogos brasileiros. Um grande exemplo que eu lembro que me impressionou na época foi o jogo da Turma da Mônica. 




Esse jogo na realidade é o Wonder Boy II com textos e sprites editados pra encaixar numa história da Turma da Mônica. Se nunca viram olhem lado a lado.





A Tectoy produziu vários jogos usando essas técnicas como Geraldinho, Sapo Xulé, TV Colosso. Mas fazendo isso eles foram aprendendo como de fato programar no Master System e começaram a produzir jogos mais elaborados. Por exemplo, um dos melhores jogos de Master System sem dúvida é Castle of Illusion. Daí a Tectoy pegou emprestado elementos desse jogo e fez um terceiro jogo na sequência do também excelente Land of Illusion, com fases novas e inimigos novos e chamou de Legend of Illusion. É bem claro onde são sprites dos jogos anteriores e quais são sprites desenhados do zero. A parte artística ainda tava bem primitiva, mas já é uma evolução.







Mas quando você treina e vai aprimorando as coisas melhoram. Por exemplo, eles começaram a experimentar com a idéia de pegar jogos de Mega Drive, que é um console bem mais poderoso que o Master System, pegar os sprites e elementos visuais e diminuir detalhes, diminuir cores, diminuir frames de animação pra tentar fazer caber no Master System. E fazendo isso eles de fato conseguiram alguns jogos interessantes. Mesmo a jogabilidade não sendo nada boa, eu acho interessante pela tentativa. Só no Brasil existem jogos como Street Fighter, Mortal Kombat, Ecco the Dolphin e A Pequena Sereia pra Master System.








Tem vários videos no YouTube contando a história da Tectoy. Tem até vários canais gringos descobrindo a Tectoy só agora e ficando impressionado de ver o Master System e Mega Drive sendo fabricados por aqui até hoje, recomendo darem uma olhada, é uma parte da história da nossa indústria brasileira que infelizmente ficou parado nos anos 90 e não conseguiu evoluir. Aliás, recentemente lançaram um remake HD do Wonderboy II que ficou bem bacana e tá em lojas como Steam. E claro, alguém fez um mod pra ele relembrando o jogo da Turma da Mônica. Então você tem uma versão HD disso também! Vale conferir só pela nostalgia se você jogou o original no começo dos anos 90.








Bom, vamos voltar pro nintendinho. O que eu mostrei do código do emulador é só o começo do esqueleto. Na verdade eu não escrevi um emulador não, esse foi um projeto que achei aleatoriamente no Github. Vocês podem baixar a versão completa no link que vou deixar nas descrições abaixo. E pra mostrar que ele funciona vamos compilar e executar.


(nes)





Um último insight que eu queria aproveitar pra falar é sobre o PPU. Como expliquei ele era o equivalente aos nossos GPUs de hoje só que muito mais primitivo. Se havia um chip que trabalha incessantemente no nintendinho era o PPU, desenhando 60 quadros por segundo sem parar. Na verdade são dois insights. Vamos lá. Pra começar eu disse que o MOS 6502 roda a meros 1.8 Mhz que é milhares de vezes mais lento que qualquer CPU de hoje. 






Antigamente jogos tentavam usar o máximo que a CPU podia oferecer e o timing de tudo era atrelado ao clock do sistema. Hoje em dia não fazemos isso, em vez de atrelar ao clock atrelamos a outras coisas como framerate que é a taxa de quadros por segundo ou vsync que sincroniza com a frequência de atualização do monitor. Ou seja, se temos como alvo rodar o jogo a 60 quadros por segundo, vamos calcular tudo pra caber na faixa de 60 quadros por segundo. Mesmo se o clock aumentar ou diminuir, a referência vai ser os quadros por segundo. Se a CPU for lenta demais vamos ser obrigados a cortar quadros. Se a CPU for rápida demais vamos dar pausas pra esperar. Estou simplificando, claro.







Mas jogos antigos não tinham o luxo de esperar, cada clock contava. Por isso se programava em assembly pra ter controle absoluto do hardware. Daí quando os CPUs evoluiram na geração seguinte e pularam de 1Mhz pra digamos 40Mhz os jogos ficaram rápidos demais. Até por isso nos 386 de antigamente tinha um botão Turbo. A idéia desse botão era diminuir o clock do sistema pros programas não rodarem rápidos demais. Se você tentar rodar um jogo dos anos 80 num PC moderno vai ver que ele roda rápido demais ao ponto de ser injogável.






Um dos desafios mais difíceis nos emuladores de consoles antigos é literalmente adicionar pausas em cada passo pro jogo rodar exatamente como seria antigamente, se não tiver esse controle de pausas o jogo rodaria rápido demais. E nosso emulador precisa levar isso em conta. Por isso temos que editar o arquivo do CPU e adicionar outra informação importante: uma lista dizendo quantos ciclos cada instrução consome. Lembra que falei que um Load, Adição e Store consomem em média uns 5 ciclos? Não pode ser aproximado assim, tem que ser a quantidade exata de ciclos. Então vamos adicionar a lista, onde cada posição é o endereço da instrução como declaramos na estrutura table.







O segundo insight que falei tem a ver com timing de velocidade. O PPU é ocupado demais, ele não pode parar de desenhar na tela. Ele roda com clock 3 vezes mais rápido que a CPU e precisa de uma rotina pra sincronizar. A coordenação entre CPU e PPU é um assunto fascinante em si só mas a parte importante é que a CPU não pode interromper a PPU a qualquer momento. Ela vai estar escrevendo pixels na tela numa frequência precisa e se você interromper, vai quebrar toda a renderização.






Significa que do lado da CPU digamos que você detecte que um botão foi pressionado no controle. Digamos que foi um botão de salto. Você iria querer imediatamente mostrar isso na tela acionando a animação de salto do Mario por exemplo. Então você processa esse estado e envia o comando pro PPU atualizar o sprite do Mario. Mas isso vai quebrar a renderização, então como faz?







A característica importante do PPU é que ele escreve na tela uma linha horizontal de cada vez. Isso se chama ScanLine e é derivado de como monitores de tubo funcionam. Se você nunca viu ele não escreve pixels em qualquer coordenada. No fundo do tubo existe um canhão, que vai atirando eléctrons na tela de fósforo na frente dele uma linha horizontal de cada vez e fazendo um zigue zague pra próxima linha. Diferente de LCDs modernos que tem uma quantidade fixa de linhas, monitores de tubo podem ter quantas linhas quiser, basta o canhão distanciar ou aproximar essas linhas. Por isso bons monitores de tubo tendem a ter imagens melhores do que LCDs. Recomendo ver esse video da Digital Foundry que explica sobre a qualidade esquecida dos CRTs e como eles ainda superam os LCDs.







De qualquer forma, o PPU do nintendinho vai desenhar 240 linhas visíveis e depois vai entrar num período entre as linhas 240 a 260 em que ele não desenha nenhuma linha visível. Isso se chama Vertical Blank ou Vblank. Isso acontece 60 vezes por segundo, uma vez depois de desenhar cada frame. É nessa pequena janela de 20 ScanLines que o PPU tem a oportunidade de ser interrompido e receber ordens da CPU, por exemplo, dizendo o que tem que desenhar no frame seguinte.







De novo, se você é de front-end, uma das boas práticas que deve ter aprendido, principalmente se usa frameworks como um React é nunca escrever direto no navegador. Você acumula todas as modificações e escreve tudo de uma vez depois. E como você faz isso? Em vez de mandar ordens de desenhar direto na árvore de elementos HTML do navegador, o famoso DOM, você manda escrever numa cópia desse DOM que só existe em memória, o famoso Virtual DOM. Então se você modificou 50 elementos nesse VDOM, você não precisou interromper o navegador 50 vezes. Você guarda essas modificações em memória e só interrompe o navegador uma vez pra desenhar só o que mudou, uma vez só.







E é quase isso que se faz no nintendinho também. A idéia de separar lógica da  apresentação não é novidade. É assim que se programa desde pelo menos os anos 80. Então do lado da lógica do jogo na CPU ele faz as modificações em RAM e durante o Vblank o PPU puxa essas modificações e avança pro próximo frame, e com isso temos uma separação de responsabilidades. 







Como cada jogo monta estruturas diferentes pra representar o que precisa mandar pra PPU. Mas um jogo que é visualmente fácil de acompanhar é o Super Mario Bros 3 porque ele mantém a estrutura completa da tela com cada elemento aberto na RAM. Se você procurar por memory map e o nome do jogo no Google facilmente vai achar a documentação que várias pessoas gastaram horas garimpando e com isso sabemos que a partir do endereço 0x6000 na RAM vai ter os dados de montagem de cada tela da fase.





Vamos abrir no Mesen e vou colocar lado a lado pra vocês verem. Se procurarmos na RAM depois do endereço 0x6000 rapidamente vamos encontrar padrões que se assemelham à tela que estamos, e na sequência vai tendo todas as outras telas dessa fase. Olhem os códigos internos de cada bloco dessa tela e veja como o código muda quando eu modifico um objeto, por exemplo batendo nele.




E se você é adepto de Mario Maker, esse é o Mario Maker raíz. Vamos olhar algumas telas pra frente. Por tentativa e erro sabemos que essas "arrobas" representam moedas. Vamos criar um monte .... e agora vamos até essa tela. ... Olha que bonito. E de novo vejam como cada vez que vou pegando as moedas o código se modifica na RAM.






De novo usando a analogia com front-end, isso é o equivalente a você dar um inspect no navegador e sair editando os elementos. E aproveitando que estamos no Mesen, vamos abrir primeiro o Super Mario de novo. E esses são todos os tiles que tem no cartucho, somente um único bank de 16 kbytes. Pense que o jogo inteiro, que não é curto, é desenhado somente com esses tiles. É impressionante se considerar que antes dele você só tinha jogos nível pacman bem simples e eles conseguiram esticar pra múltiplas fases que parecem diferente mas que são basicamente os mesmos tiles com paletas diferentes de cores.







Mas se abrirmos o Super Mario 3 de novo, que vem com o Mapper conhecido como MMC5, ele vai ter bem mais banks como eu expliquei. E olha só no visualizador de novo. Podemos ir explorando os diferentes banks que são os conjuntos de tiles. E por isso o Super Mario 3 tem visuais bem mais elaborados e diferenciados de mundo pra mundo. Não é só uma mudança de paleta de cores mas de diversidade de tiles. E no último olha como só a tela de entrada com título grande ocupa um bank quase inteiro. Por isso quando tem imagens bitmap grande que ocupam a tela inteira a gente sabe que é um jogo caro porque literalmente ele tá usando uma parte considerável do chip só pra guardar essa uma imagem que só aparece uma vez.







Recentemente teve uma ressurgência de games independentes publicando nos Steam da vida que tentam emular o visual pixel art pra ter aquela vibe de jogo retro. Um bom exemplo disso é o excelente jogo Celeste, considerado um dos melhores jogos de plataforma pra speedrun pela nuance nos controles e como ela recompensa quem consegue combinar timing com movimentos avançados do jogo pra percorrer as fases. Outros exemplos são os já classicos Meat Boy ou Shovel Knight também. Mas o que esses jogos tem em comum é que eles são modernos mas só escolheram um estilo artístico de pixel art pela estética e não porque foram obrigados a isso.







Entendam, jogos antigos não são pixel art porque o povo gostava do estilo mas sim porque a resolução da tela era de meros 256 pixels na horizontal por 240 pixels na vertical. Isso é um quarto da resolução de um monitor full HD que tem 1080 pixels na vertical. Cabe literalmente 16 telas de nintendinho numa tela full HD. Mas agora você entende também que não é só a resolução, todo o design do jogo, das fases, inimigos e outros elementos dependem muito do espaço na ROM. Quanto mais ROM se adicionava no cartucho mais caro ele ficava. Por isso a maioria dos jogos se mantinha nos limites de 40 kilobytes que o Super Mario original usava. Em comparação, a instalação do jogo Celeste tem mais de 700 megabytes.







Existem vários programadores hoje explorando programar no hardware limitado do nintendinho. Um grande exemplo é o jogo Micro Mages da Morphcat Games. Dois anos atrás eles soltaram um mini documentário mostrando como as limitações do console e do cartucho influenciaram as decisões de design do jogo. Eles se colocaram no desafio de fazer um jogo de verdade, bem feito, escrevendo em Assembly de 6502 e ainda suportando 4 jogadores simultâneos.







O jogo é excepcional, eu paguei pra ter a ROM e recomendo que comprem também, são 10 dólares bem gastos. A mecânica é muito simples, lembra um pouco a idéia do Celeste. É um jogo vertical onde a tela vai subindo lentamente e você precisa alcançar o fim da fase antes que a tela te alcance. E falando em fases, vale um parêntese pra explicar mais uma estrutura de dados que o nintendinho usava, os nametables. Em resumo hiper resumido, é um espaço na memória do PPU que organiza o equivalente a 4 telas, duas em cada linha.







Se você está num Mario que é plataforma horizontal, ele vai mantendo a próxima tela no espaço à direita. Olha como a memória vai atualizando conforme vamos avançando pelas telas. 


Se for plataforma vertical como Kid Icarus ele mantém a próxima tela no espaço pra cima e você pode trabalhar os modos desse namespace se precisar de algo mais complexo como num Mario 3 que é horizontal mas quando você pega a folha pode voar vertical.





No caso do Micro Mages ele vai usar um modo semelhante ao do Kid Icarus. Jogando um pouco, veja lado a lado como o próximo nivel vai se montando nesse espaço de memória de nametables.





No video da Morphcat ele começa explicando o que eu já falei, que gráficos são divididos em duas tabelas CHR. Ele chama tiles de sprites mas é a mesma coisa, eu chamo sprites os tiles que estão na tela neste momento. Ele continua repetindo que cada tile é um quadrado de 8 por 8 pixels e que pode escolher até 3 cores da paleta. E que juntamos tiles pra formar o que ele chama de meta-sprites que é o objeto completo. Continuando, ele explica que só dá pra ter até 4 paletas de cores e que as cores são reusadas pra outros objetos como inimigos porque não dá pra ter cores diferentes pra cada coisa, é tudo as mesmas paletas.






Outra limitação do PPU que eu não mencionei ainda é que ele só consegue desenhar 8 sprites por scanline. Como cada personagem é formado por duas linhas de dois tiles cada, nesse exemplo vai ter 10 tiles por linha em vez do máximo de 8. Se tiver mais que 8 os sprites seguintes simplesmente não são desenhados. Por isso um truque muito usado é escolher 8 tiles dos 10 e desenhar num frame, daí no próximo frame você esconde 2 que foram desenhados no anterior e troca por 2 que ainda não tinham sido desenhados, e vai permutando de frame a frame. Por isso muitos jogos de nintendinho parece que os personagens ficam piscando na tela. Isso acontece quando eles se movimentam e na mesma linha acaba ficando mais de 8 sprites.







Por causa dessas limitações, a primeira decisão da Morphcat foi criar personagens que precisam só de um tile pra formar o sprite em vez de 4 ou mais. Além de economizar em espaço, isso também evita o flicker, aquelas piscadas, porque vai ser mais difícil ter mais de 8 sprites por scanline. Falando só em espaço, de volta à tabela de tiles CHR na ROM, esse é o espaço ocupado por todos os tiles que formam as animações do Mario, que nós já vimos antes. E agora o espaço ocupado por todas as animações dos magos nesse novo jogo. Veja como economiza espaço escolhendo fazer personagens menores que cabem num único tile. E não só isso, também conseguimos adicionar mais quadros na animação, tornando a movimentação mais fluida. 







Outro desafio são os chefões, que costumam ser sprites grandões. Por exemplo, esses são todos os frames de animação de um dos chefões. O problema é que se você tentar encaixar todas essas imagens no que restou do espaço CHR, simplesmente não vai caber. E isso é só um chefão. Agora vem a parte onde a programação e o design precisam andar juntos, porque o designer tem que fazer um chefão cujos quadros podem ser divididos em partes, no caso três, que podem ser animados independentemente. 



Olhando só os quadros que fazem a animação da cabeça, dividimos em tiles, e vemos se tem repetições. E de cara você pode ver que a primeira metade em todos os três quadros é igual, então só precisa armazenar uma versão, que pode ser reusada em todos.







Não só isso, se um tile é o espelho de outro tile, você guarda só uma versão e pede pro nintendinho inverter horizontalmente, e assim pode economizar mais um pouco. E fazendo isso, só na cabeça otimizamos de 16 tiles pra 4 que realmente precisam existir na ROM. 



Pra parte do meio, fazemos a mesma coisa: procuramos todos os tiles repetidos, todos que podem ser invertidos e diminuímos mais ainda. 




E a última parte tem 5 animações mas de cara as duas últimas são inversões das duas primeiras. E fazendo todas as mesmas reduções, removendo tudo que é repetido, compare os tiles que sobraram com os que originalmente eram necessários sem otimizar. 





O video deles continua mostrando como aplicaram outras técnicas pra reduzir ainda mais a quantidade de memória necessária pra montar as fases. Mas eu vou pular pra não ficar extenso demais, por isso recomendo que assistam e também comprem o jogo.






Falando em programar seus próprios jogos, como você faz isso? Simples, se pesquisar no Wiki da Nesdev vai encontrar sobre ferramentas, tem vários fóruns ainda ativos onde o povo troca dicas e informações sobre as melhores técnicas e ferramentas, mas o mais básico é o cc65 que vem com o montador ca65 e o disassembler da65. E se procurar num Github vai encontrar vários exemplos, de hello world a joguinhos completos feitos do zero como o Micro Mages. Se você já pensou em programar games e não quer ser só mais um mero clonador de Flappy Bird, programar em hardware restrito como um nintendinho é um excelente exercício pra aprender todos os fundamentos de um bom design de games.







Por exemplo, baixei este projetinho que faz todo o setup do ambiente, carrega o mínimo de tiles e tudo mais pra ter fontes e com isso consigo fazer um hello world da vida rapidamente em C. E sim, é possível programar em C e compilar com o cc65 pra binário de 6502 específico de nintendo. A desvantagem de programar em C é que ele vai gerar um binário menos otimizado do que um bom programador faria na unha direto em assembly. Por outro lado, como estamos em ambiente emulado você sempre pode mexer no emulador pra ter uma CPU mais rápido do que o nintendinho original e quantos banks de ROM quiser. 





Aliás, sobre o hello world, considere o seguinte: o nintendinho não tem um sistema operacional, sequer vem com fontes numa ROM, o jogo tem que fazer tudo, então pra fazer um hello world, você precisa primeiro armazenar suas próprias fontes no espaço CHR da ROM. Só depois pode escrever alguma coisa.







Falando nisso vale a pena mostrar como subir um pouquinho o nível da linguagem pra não ficar tão tedioso fazer só assembly puro. Não é um compilador ainda, tá longe disso, mas muitos assemblers tem capacidade pra macros. Pra quem não sabe, macro é como um template. Um procesador de Markdown é tipo um macro de HTML. Quando eu digito asterisco o processador vai pegar o texto seguinte e colocar entre as tags de bold por exemplo. Macro é uma forma de reduzir copy e paste de trechos de código.







O ca65 que é o assembler mais recomendado pra programar pro nintendinho já vem com vários macros que adicionam algumas construções mais modernas como ifs, whiles e outras coisas, assim você consegue ter mais dicas visuais do que cada trecho faz em vez de ver só um linguição de instruções. Some isso a subrotinas com JSR que mostrei no video anterior e é possível programar sem ficar completamente doido no processo. Mas pense assim: é assim que se programava games de verdade. O grande lance de programar em consoles é tirar o máximo que o hardware consegue oferecer.







Outra coisa interessante. Hoje em dia não existe mais o código fonte da maioria esmagadora dos games. Muitas empresas da época até faliram e muito material se perdeu. Mas isso não tem problema. Você sempre consegue reabrir o código a partir do binário. Pra isso serve a ferramenta da65 que vem no mesmo pacote. Você pode fazer o desassembly e voltar aos mnemônicos. Obviamente não vai ter o nome correto das subrotinas, labels, constantes e variáveis. Mas se você tiver experiência com o hardware vai saber por exemplo que se tiver alguma coisa mexendo com o endereço a partir de 0x8000 está acessando a ROM, se mexer com o endereço 0x4016 ou 0x4017 está falando com os controles.







Daí você pode fazer a engenharia reversa que é adicionando as etiquetas e nomes das coisas mais óbvias primeiro e fazer o caminho inverso. Ah, se esse trecho mexe com o endereço 0x4016 deve ser o trecho que decide o que fazer quando aperta um botão. Além disso você pode fazer tracing, visualizar o que acontece em cada registrador e na memória a cada instrução pra determinar do que se trata cada subrotina. É super trabalhoso mas fazendo isso você consegue encontrar praticamente tudo. Diversos jogos já foram mapeados assim.





E de fato, se procurar no Github você vai achar um disassembly do Super Mario praticamente completo com todos os nomes de subrotinas, etiquetas e constantes. É o mais próximo que se chegou do código fonte original. E em cima disso você pode modificar o jogo como quiser no nível do código em vez de se limitar a só modificar os bytes no nível da ROM como fizemos com textos e tiles. Podemos adicionar tiles novos ou fazer textos mais longos e reprogramar a lógica porque o assembler vai conseguir recalcular todos os endereços corretamente e gerar um novo binário que funciona.







Finalmente, vou completar a maior tangente que fiz até hoje. Vocês vão se lembrar que o episódio anterior começou só porque eu vi um video falando sobre o Game Genie. Como expliquei antes, Game Genie é um hardware que fica entre o cartucho e o console. E agora sabemos que o cartucho responde a uma faixa de endereços bem específico entre $8000 e $FFFF. Também sabemos que endereços que a CPU pede não correspondem à localização exata nos cartuchos por causa do sistema de mappers e bank switching.







Existem duas formas de adicionar cheats, ou trapaças nos jogos. Uma delas é alterando o valor carregado na memória RAM e a outra é alterando direto o binário na ROM. Com bastante paciência você consegue visualizar o conteúdo da RAM usando emuladores como o FCEUX e o Mesen, gravar dumps da memória entre uma parte do jogo e outro e comparar os bits pra ver o que mudou. Por exemplo, gravar a RAM antes de morrer e depois de morrer pra ver qual byte diminuiu e ele é um candidato pra ser o local na memória que representa quantas vidas você tem, daí você pode testar esse valor.







Com tantas décadas de gente escovando bits, existem bancos de dados inteiros com diversos cheats pra cada jogo. Você facilmente consegue encontrar código pra tudo. Num emulador como o RetroArch tem até funcionalidades pra sincronizar com esses bancos de dados daí você nem precisa digitar os códigos manualmente. Só escolher o jogo, selecionar em cheats, carregar e já era.







Resumindo o video do canal Retro Game Mechanics Explained o que o hardware do Game Genie faz é receber um endereço de 16-bits e um ou dois valores de 8 bits cada. Isso forma códigos de 6 ou de 8 letras. Quando o código tem 6 letras é fácil porque os primeiros 4 dígitos representam o endereço na RAM e os dois últimos digitos representam o valor que o Game Genie vai devolver e pronto. Quando estamos falando de jogos usando o Mapper mais simples, como num Super Mario original que só suporta ROMs com 40 kilobytes, isso é tudo que precisamos.







Agora que você entende bank switching, sabe que no mesmo endereço da RAM pode estar apontando dados em banks diferentes da ROM. Depende de qual bank tá apontando no momento. Então o Game Genie não pode responder com um valor fixo  toda hora, só quando um determinado bank tá selecionado. Pra isso serve o código de 8 digitos. De novo, os primeiros 4 formam o endereço na RAM. Agora os dois dígitos seguintes representam qual é o valor que esperamos encontrar na RAM, ou seja, o valor que ele carregou do bank. Se for diferente do que passamos é porque o console tá olhando um bank diferente do que queremos. Mas quando o valor voltar igual, é porque ele mudou pro bank que queremos, e aí devolvemos o valor fixo que tá no ultimos dois dígitos do código.







A forma como o Game Genie monta os códigos é só um embaralhamento arbitrário que ele faz sei lá porque, talvez só pra deixar o código um pouco mais legível. É só uma obfuscação simples. Pra isso primeiro você pega os bits do endereço e dos dois valores, daí embaralha os bits pra outras posições, e no fim substitui cada bloco de 4 bits por uma letra de acordo com uma tabela arbitrária. Pra cada console tem uma regra de embaralhamento e tabela de mapeamento de letras diferentes.







Eu fiz um programinha bem besta na linguagem Crystal que pega o código do Game Genie, traduz de volta em bits, desembaralha os bits e devolve o endereço e os valores. Eu fiz em Crystal só porque eu quis, nenhuma razão especial, podia ser em qualquer linguagem. Vou deixar o link pra esse código nas descrições abaixo. Talvez eu termine de fazer o desembaralhamento das versões de game genie pros outros videogames mas eu queria um executável simples pro meu teste.






Eu fiz algumas coisas do jeito menos otimizado, estilo "o que funciona primeiro", então não xinguem. Pelo menos tem testes unitários direitinho. Veja esse por exemplo, eu garanto que eu passo um código de Game Genie e ele vai gerar o binário que eu quero. Daí no outro spec eu garanto que dado esse linguição de bits vai gerar a representação em hexadecimal direitinho também. 






O código em si é muito simples. Ele começa pegando o código de 6 ou 8 letras do game genie, processa letra a letra e troca pela representação binária. Eu não estou lidando com o número binário e sim com a representação em texto mesmo pra ficar mais fácil. Depois de montar esse binário, o próximo passo é desembaralhar, e isso é arbitrário do game genie, só trocar bits de posição. Finalmente, com os bits rearranjados, faço um outro loop besta pegando de 4 em 4 bits e transformando em hexadecimal. 







Vocês vão notar que eu fiz de um jeito meio tosquinho aqui criando um array pra mapear cada conjunto de bits no hexadecimal em vez de converter a string num número e depois usar um formatador pra hexa, mas foi mais porque eu não achei fácil o jeito de fazer isso em Crystal ainda. Quando descobrir eu mudo. Mas pros meus propósitos esse código tá suficiente. Com isso eu posso compilar um binário e ... pronto, posso chamar o binário, passar o código de game genie e ele devolve o hexadecimal certo.







O próximo passo foi mexer no emulador feito em Go. A grande maioria dos emuladores mais maduros e populares tem suporte a códigos de game genie. Mas esse emulador mais simples não tinha, por isso achei que seria um exercício interessante. Pra começar eu resolvi modificar o arquivo do console adicionando uma estrutura chamada Cheat que vai ter só dois elementos, o valor de condição pra comparar com o que tá no bank da ROM selecionado nesse instante, e o valor trapaceado que eu quero devolver. Daí eu adiciono na estrutura do console uma nova estrutura, um Map de Cheats. Map é o que algumas linguagens chamam de dicionário ou de hash. É uma lista que vai mapear um número inteiro, que no caso, é o endereço com uma instância da estrutura de Cheat.







Agora precisamos ler os cheats de algum lugar. No caso escolhi ler de um arquivo. Eu não estou mostrando, mas estou seguindo o padrão que esse emulador já fazia pra fazer saves dos jogos, criando um hash md5 do binário. O nome do arquivo que eu vou buscar é o hash md5 do Super Mario numa pasta .nes/cheats. Essa função readCheats recebe o caminho pra esse arquivo e só vai lendo linha a linha e gravando numa lista. Assim podemos ter múltiplos arquivos pra com códigos específicos de cada jogo que queremos.





A função seguinte vai interpretar essa lista. A função LoadCheats vai usar a readCheats acima passando o caminho do arquivo e recebendo a lista que ele ler. Daí eu passo um caminho fixo mesmo por enquanto, pro executável daquele programinha que eu fiz em Crystal. Ele vai passar os códigos pra esse programinha pra decodificar o endereço e valores.






Com o que ele devolver, checo se é um código de 6 ou 8 digitos, e isso serve pra preencher ou não aquele campo de condição na estrutura de Cheat. Feito isso associamos o endereço devolvido com a estrutura de Cheat e jogamos no dicionário na estrutura do Console. Com isso o console tá ciente dos códigos. 






Pra de fato aplicar o cheat o lugar mais óbvio pra procurar é a estrutura de Memory, lembram dele? É nesse arquivo que tem a lógica pra escolher qual mapper o cartucho carregado precisa. Mas ele abstrai os mappers e a gente não precisa se preocupar. Os Mappers vão se encarregar de ler da ROM nos banks corretos. Então o que vamos fazer é, em vez de devolver o valor lido, vamos gravar temporariamente numa variável e passar pra uma nova função chamada replaceWithCheat.





Essa função recebe o endereço consultado e o valor devolvido. Agora acessamos o dicionário de Cheats que tá na instância do Console e procuramos por esse endereço. Se não achar nada, devolve o valor real original. Caso encontre ele checa se precisa comparar com a condição do Cheat.





Se não tiver condição ou se a condição bate com o valor real, então ele devolve o valor falsificado. E pronto, é só isso que precisa pra implementar um game genie num emulador. Com isso o console vai receber o valor falsificado em vez do valor real e nosso Super Mario vai começar com mais vida. Podemos testar isso. 



Veja o arquivo de cheats com o código. Agora executamos o emulador passando a ROM do jogo, esperamos carregar e olha só, 9 vidas!!





Mas digamos que a gente é ruim em Super Mario e o tempo sempre acaba, quero que comece com 900 segundos em vez de só 400 e se procurar no Google descubro que o código pra isso é VGYOKK, então vamos editar o arquivo de trapaças e adicionar o código. Reiniciamos o emulador e ... veja só que bacana, 9 vidas e 900 segundos pra terminar a fase.






Mas digamos que a gente é tão ruim, mas tão ruim que morre toda hora. Malditos Goombas! Mas não se preocupem, existe um código pra isso. Vamos editar de novo o arquivo e adicionar SSASSA. Agora vamos reiniciar o emulador e corremos de cara pra um Goomba. E olha só, invencibilidade!!







Vocês vão notar no terminal que toda vez que eu encosto num inimigo o programa busca o endereço 0xD88D pra checar se é pra perder vida ou não, daí se devolver 0xD5 ele sabe que é invencível. E é assim que trapaceamos pra chegar até o final fácil! E com isso finalmente consegui fechar o assunto que comecei no video anterior, fazer meu próprio Game Genie de Nintendinho. Com tudo que expliquei desde o vídeo anterior agora vocês entendem exatamente como tudo funciona.







E pra finalizar o episódio de hoje quero mostrar como vocês vão ter uma noção melhor pra entender videos de outros canais também. No próprio canal do Retro Game Mechanics Explained, alguns dos videos mais divertidos é a explicação de diversos bugs que esses jogos tem, e como podemos tirar vantagem disso. Uma das categorias de gamers mais escovadores de bits são os speedrunners. São jogadores que competem pra bater o recorde de quem acaba o jogo no menor  tempo. Tem várias sub-categorias. Uma das mais divertidas é quando eles encontram bugs que permitem, por exemplo, saltar todas as fases e ir direto pro final.








Antes de falar desse bug preciso falar de uma última ferramenta que emuladores mais avançados como o FCEUX tem, se chama TAS ou Tool Assisted Speedrun. Lembram no nosso código em Go que eu associo controles na estrutura de console? Obviamente nós conseguimos ler o que vem do controle pra poder codificar o que cada botão apertado vai fazer no jogo. E naturalmente eu posso fazer o que quiser com esses dados, inclusive salvar num arquivo. Mais do que isso, como eu controlo a PPU também consigo saber exatamente em que frame cada botão foi apertado.







Então eu também consigo ler esse tal arquivo que diz em que frame foi apertado qual botão e com isso podemos dar replay no jogo inteiro repetindo exatamente tudo que que foi apertado com precisão de 1 frame. E é exatamente assim que esses jogos são arquivados em sites como o tasvideos.org, que mantém registros de todos os recordes. E você pode baixar o arquivo formato .fm2 ou .fm3 que contém exatamente essa sequência, rodar no seu emulador e assistir o speedrun exatamente como a outra pessoa jogou. 








Então eu vou abrir o FCEUX, carregar a ROM do Super Mario 3, abrir o TAS Editor e carregar o arquivo .fm2 que baixei do site tasvideos. 



Pronto, agora é só despausar e assistir. Vou pular as primeiras fases porque ele usa outros truques conhecidos pra ir pulando de warp zone em warp zone até chegar no mundo 7. Nesse ponto a maioria dos speedrunners ia pro Dark World normalmente, mas nessa corrida eles vão pelo Pipe World porque é de lá que dá pra acionar o bug. Assistam primeiro.



(glitch run)




Foda né, vocês não entenderam nada eu imagino, mas deu pra ver que eles fazem uma sequência bem absurda de coisas no Pipe World, daí começa tudo a descer pra um monte de sujeira de tiles e de repente ele chega na princesa direto. Agora que vocês tem uma idéia de como as coisas funcionam, dá pra entender que o bug aciona alguma coisa que faz a tela descer por um pedaço de RAM com bytes aleatórios que ele manda pro PPU que mapeia os tiles correspondentes, montando uma fase toda bagunçada e com comportamento incerto. E em algum momento dá um JUMP. O truque é simples, vamos usar a posição dos sprites na RAM pra montar um assembly em tempo real e dar um jeito de executar. 






O código em si que precisa ser escrito é JSR 0x8FE3. Se conseguir fazer o jump esse é o endereço pra subrotina que inicia a sequência final da princesa. Então precisamos de 3 bytes consecutivos num lugar especial na RAM, os bytes sao 0x20 que é o JSR, e depois 0xE3 e 0x8F que é o endereço com os bytes invertidos por causa de little endian, que vocês já sabem como funciona.






A posição X dos inimigos, especialmente dos koopa troopers ficam sempre no mesmo lugar e não apagam mesmo quando o sprite some da tela. Por isso esses bytes são bons candidatos pra usar. Mas não adianta sair matando qualquer koopa. Precisamos que eles estejam na posição correta nessa lista e também que estejam numa posição X específica. Pra isso precisamos tentar fazer com que eles apareçam numa determinada ordem primeiro. A lógica é que novos sprites sempre vão aparecer primeiro na posição mais alta livre da lista primeiro. Então usamos essa informação pra fazer eles aparecerem numa ordem em particular.



Ao matar essa tartaruga e ir pro cano enquanto ela ainda está na tela, podemos forçar as plantas piranha pra aparecer nos slots 2 até 4 e o próximo koopa no slot 5.


Matamos as plantas pra elas não reaparecerem mais tarde quando voltarmos pra essa parte.


Agora o koopa entre os blocos de interrogação vai estar no slot 4 e o parakoopa no slot 3. Pegamos a casca dessa tartaruga e matamos jogando ele no bloco. Isso fixa o byte na posição fixa 0xE3 que precisamos.




Daí ficamos exatamente nessa posição em cima do cano e damos uma rabada no parakoopa quando ele estiver exatamente alinhado com o topo do outro cano pra garantir que a casca aterrisse na posição X hexadecimal 0x20, e com isso temos o byte que representa o jump. Agora vamos pra baixo, agarramos a casca desse koopa e voltamos ao comeco do nível. 




Nesse ponto precisamos realizar o bug do cano apertando pra baixo no controle ao mesmo tempo que faz um clip na parede no canto desse cano. Às vezes o Mario consegue fazer um clip numa parede, tipo passar por ela, se estiver rápido o suficiente e bater bem na beira do grid de 16 pixels, é um movimento bem preciso e às vezes precisa fazer várias vezes pra acertar. Nessa sequência não tem tanto problema se de vez em quando pisar na casca pra tartaruga não acordar.





Uma vez entrando no cano inicia uma sequência de bugs porque não tava programado pra ter como ele entrar no cano nesse ponto, dai vai descendo por todo esse lixo aleatório que tá na memória. O PPU vai simplesmente mapeando o lixo que vai recebendo com os tiles na tabela CHR e mostrando na tela. Por isso fica essa bagunça visual.







No final tem que pular com muito cuidado com a casca e alinhar com o fundo bem nessa posição. Tem um detalhezinho que se notar que esse bloco de música estiver parcialmente cortado, talvez precise mover o Mario um pixel pra direita pra compensar a posição da camera. Deixamos o koopa reaparecer nas nossas mãos e desaparecer no fundo da tela, e essa posição onde ele desaparece nos dá o último byte que precisávamos, valor 0x8F. Finalmente caímos aqui e pulamos pra ativar a instrução. E se tudo foi configurado exatamente como mostrado aqui, vamos pular direto pra princesa e terminar o jogo.







Pra entender o que aconteceu vamos usar tudo que aprendemos até agora. Essa fase vertical é mapeada entre os endereços 0x6000 e 0x6EFF, que é suficiente pra 16 telas. Mas aquele cano que entramos depois de clipar pela parede manda o Mario pra tela 19 que obviamente não existe. Então acontece um transbordamento, um overflow da memória e começamos a acessar áreas da RAM que não era pra acessar.




E pra piorar, além de visualmente aparecer essa zona, a rotina de desenho falha e o que estamos vendo pode não estar de fato lá, por isso o Mario consegue subir numa plataforma invisível. A coincidência é que o final desse cano deixa o Mario do lado de um bloco de nota invisível e é batendo nesse bloco que ativa os bytes de Jump que configuramos.





Quando batemos num bloco de musica o tile é temporariamente removido e outra versão do sprite aparece pra fazer a animação. E claro, o índice nos dados da tabela de fase tá todo zoado quando procura por esse tile e ele pega o endereço 0x9C70 pra atualizar, que não é nem de longe perto da tabela de dados. Pior esse endereço simplesmente não existe na RAM.





Recapitulando o que já vimos sobre os endereços que nintendinho entende, temos a RAM entre 0x0000 e 0x1FFF e temos Work RAM entre os endereços 0x6000 e 0x7FFF e já sabemos que de 0x8000 até 0xFFFF é a região reservada pra ROM, ou seja, pro cartucho. Então aquele índice errado do bloco de musica tenta escrever na ROM. Mais do que isso, esse endereço na verdade fala com o Mapper do cartucho. E você sabe o que é um Mapper.






Por acaso quando tentamos escrever nesse endereço 0x9C70, é o mesmo que dizer pro Mapper fazer uma troca de banco, pra apontar pra outros bancos da ROM. Recapitulando, já sabemos que entre os endereços 0x8000 e 0xFFFF só cabe 32 kilobytes de dados, mas a ROM de programa do Super Mario 3 tem 256 kilobytes. Obviamente não cabe e por isso durante o jogo ele vai pedindo pro Mapper ir trocando os bancos pra apontar pra outras regiões da ROM.







Então esse trecho tá fazendo seu trabalho feliz e contente, achando que tá atualizando um tile na tela pro bloco de musica, mas em vez disso quando executa a instrução no endereço 0xDD1A, a ROM de 0xA000 a 0xDFFF é trocado pelo mapper do nada. Ele literalmente atira no próprio pé e as próximas instruções foram trocadas pelo que tá no novo banco que o Mapper trocou.





O apontador de pilha nesse momento da execução é 0xFD, que sabemos que quer dizer que a pilha tá quase vazia, lembra do video passado e do código de Reset da CPU que fizemos antes? Lembra que a instrução RTS vai retornar pro último endereço que estiver na pilha? E por acaso na pilha tem só um endereço nesse momento. E de fato essas instruções novas que vieram na troca do bank pelo Mapper, ele continua executando e uma hora bate num RTS fazendo ele pular pro endereço 0x8F4D.




Agora caímos no meio de uma nova rotina com uma pilha vazia, coisa que ele não esperava. Daí ele continua executando e uma hora vai bater num RTS, vai olhar pra pilha pra saber pra onde retornar. Mas a pilha tá vazia então quando isso acontece o ponteiro faz um wrap, ele circula como se a pilha estivesse totalmente cheia, lembra de quando falei de stack overflow no video anterior?





Lembrando que a pilha fica entre os endereços 0x0100 e 0x01FF, mas praticamente nunca a pilha enche totalmente então alguns programas acabam usando o topo da pilha pra outra coisa e no caso o jogo mantém informação da fase em 0x0100. Lá vai ter o valor 0xC0 se forem fases horizontais e 0x80 em fases verticais. E como o ponteiro circulou pro topo da pilha ele pega o valor que tá lá, subtrai 1 e retorna o endereço 0x0081.






Beleza, então o RTS vai pular pra 0x0081 e isso é endereço da RAM que tem um monte de dados voláteis sobre as propriedades da fase. Por exemplo em 0x007E a 0x0086 tem propriedades sobre os sprites carregados nesse momento, tipo o timer de quando as plantas piranha tem que aparecer dos canos, ou como os parakoopas voam. Dos endereços 0x0087 a 0x008F tem o high byte da posição Y de cada sprite, que é o número da tela onde eles estão.








Agora chegamos onde queríamos porque dos endereços 0x0090 a 0x0098 estão os low bytes da posição X de cada sprite na tela, que são as posições que viemos manipulando no começo e configuramos o JUMP. Os bytes antes disse são dados, mas o processador não sabe disso e tenta executar como se fossem instruções. Por coincidência nenhuma das tentativas de executar esses dados termina num crash e ele consegue chegar até nosso jump. Como esses dados anteriores podem ser qualquer coisa que representa os tais elementos na tela que falei, poderiam ser bytes que representam instruções que crasheiam, então essa sequência toda que fizemos não é garantido que funciona sempre, mas funciona vezes o suficiente.






Chegando no nosso JSR 0x8FE3 ele pula pra um programa que fica num bank que nunca é trocado pelo mapper então garantidamente sempre vai estar lá e é a rotina pra carregar o quarto da princesa.




Pra fechar, a sequência pra montar a instrução de jump pode ser feita de várias formas contanto que a posição X dos inimigos certos entre na sequência correta nos slots da memória. Esse é o recorde mundial usando esse bug do MitchFlowerPower onde ele termina o jogo em 3 minutos e 9 segundos. Ele mesmo jogou manualmente e gravou seus comandos.






E com tudo isso dito, finalmente chegamos ao final do episódio! Tudo que eu queria era explicar como o Game Genie funciona, mas pra realmente entender era necessário entender cada componente de como um computador funciona. Com isso eu espero que se você é iniciante tenha conseguido ter uma visão um pouco mais abrangente do que significa fazer um hardware funcionar. 






Pra mim isso é programação. Programação nunca foi sobre seguir receitas e procedimentos prontos e sim encontrar um cenário de restrição e com conhecimento de verdade usar as ferramentas disponíveis pra conseguir soluções criativas. Nenhum livro, nenhum curso, nenhum tutorial jamais vai ensinar essas coisas. Só quando você encara problemas difíceis é que conhecimento de verdade começa a aparecer. Eu tenho certeza que vocês nunca imaginaram que tinha tanta coisa que podia ser dito sobre um videogame obsoleto dos anos 80.





Se você ficou empolgado pra escrever seu próprio emulador recomendo que acompanhem outro canal, o do One Lone Coder que está desenvolvendo um emulador de NES em C++ e explicando passo a passo no seu canal. Vou deixar o link nas descrições abaixo. O próprio canal do Retro Game Mechanics Explained na realidade tem videos detalhados explicando o funcionamento do Super Nintendo. Como funcionam os gráficos e cores, como funciona a memória, como funciona o lendário Mode 7. Tem bastante coisa pra aprender.





Se vocês pensam que eu acabei todos os assuntos, tão enganados. Descer nesse buraco de coelho me levou a rever um monte de coisas do passado em relação a emuladores e estou pensando em fazer um episódio mais leve do que esses pra explicar o ecossistema atual de emuladores. Pra variar eu vou descer mais no detalhe em alguns deles então aguardem pelo próximo. Como vários assuntos eu tive que resumir ou mesmo pular pra não ficar confuso demais, se você também é entusiata desses assuntos, não deixem de complementar nos comentários abaixo. Se curtiram o video mandem um joinha, assinem o canal e cliquem no sininho. E principalmente ajudem o canal compartilhando os videos com seus amigos. A gente se vê na próxima, até mais!






Links:

* Super Mario Bros. 3 - Wrong Warp (https://www.youtube.com/watch?v=fxZuzos7Auk)
* A Comprehensive Super Mario Bros. Disassembly (https://gist.github.com/1wErt3r/4048722)
* Lembra deles? Confira jogos brasileiros do Master System lançados pela Tectoy! (https://blogtectoy.com.br/lembra-deles-todos-jogos-brasileiros-do-master-system-lancados-pela-tectoy/)
* Free NES assembler (https://bisqwit.iki.fi/source/nescom.html)
* Micro Mages (https://morphcatgames.itch.io/micromages)
* Nes Dev Wiki (https://wiki.nesdev.com/w/index.php/Nesdev_Wiki)
* Computer Archeology - The Legend of Zelda (https://www.computerarcheology.com/NES/Zelda/)
* 6502 Instruction Set (https://www.masswerk.at/6502/6502_instruction_set.html)
* An introduction to 6502 math: addiction, subtraction and more (http://retro64.altervista.org/blog/an-introduction-to-6502-math-addiction-subtraction-and-more/)
* Explain Half Adder and Full Adder with Truth Table (https://www.elprocus.com/half-adder-and-full-adder/)
* Build a multiplying machine using NAND logic gates (https://codegolf.stackexchange.com/questions/12261/build-a-multiplying-machine-using-nand-logic-gates)
* Tool Assisted Game Movies (http://tasvideos.org/)
* RETRO INSECTIVORES: FINDING AND ELIMINATING BUGS IN NES DEVELOPMENT (https://megacatstudios.com/blogs/press/retro-insectivores-finding-and-eliminating-bugs-in-nes-development)
* FCEUX (https://sourceforge.net/projects/fceultra/)
* Zelda Screen Transitions are Undefined Behaviour (https://gridbugs.org/zelda-screen-transitions-are-undefined-behaviour/)
* NES Emulator Debugging (https://gridbugs.org/nes-emulator-debugging/)
* Two's Complement Multiplication (http://pages.cs.wisc.edu/~david/courses/cs354/beyond354/int.mult.html)
* NES Hello World (https://www.embed.com/nes/hello-world.html)
* DF Direct: CRT Displays - Was LCD A Big Mistake For Gaming? (https://www.youtube.com/watch?v=tvRyVZWuvQ4)
* DF Direct! Modern Games Look Amazing On CRT Monitors... Yes, Better than LCD! (https://www.youtube.com/watch?v=V8BVTHxc4LM)


* Meu fork do emulador de NES em Go (https://github.com/akitaonrails/nes)
* Meu código do decodificador de código de Game Genie (https://github.com/akitaonrails/gamegenie)


Assinem estes canais:

* Retro Game Mechanics Explained (https://www.youtube.com/channel/UCwRqWnW5ZkVaP_lZF7caZ-g)
* One Lone Coder (https://www.youtube.com/channel/UC-yuWVUplUJZvieEligKBkA)


