---
title: "[Akitando] #93 - Hello World Como Você Nunca Viu! | Entendendo C"
date: '2021-03-06T10:00:00-03:00'
slug: akitando-93-hello-world-como-voce-nunca-viu-entendendo-c
tags:
- Linguagem C
- Estrutura de Dados
- GCC
- akitando
draft: false
---

{{< youtube id="Gp2m8ZuXoPg" >}}

## DESCRIÇÃO

Se você nunca viu C ou como um programa funciona de verdade no baixo nível, hoje é sua chance de ver todo o básico de uma só vez!


Vou desde tipos primitivos, strings, arrays, stacks, heap, alocação de memória, structs, até minimamente entender o que está por baixo do que você chama de linguagem "orientada a objetos".


ERRATAS 

- em 00:06:50 falei errado o range de INT, o certo é de -128 a 127
- em 00:06:06 eu falei certo e deixei a correção escrita errada. 64 bits, se você não precisar, desperdiça 7 bytes
- em 00:40:54 eu falei que 255 bytes é 1/4 de 1 megabyte, mas é de 1 KILObyte.
- em 00:45:41 eu coloquei `hello` no sizeof e ele pegou o sizeof do endereço e não do array. 
- em 00:38:40 eu não sei como deixei passar, mas quando falo de passar o string pras funções `f1`, `f2` não está duplicando toda a string e sim a referência pra ela. Se fossem valores primitivos como `int` sim, mas array só o endereço duplica mesmo.
- em 00:57:55 quando dei copy e paste pro createPerson, eu esqueci de usar os argumentos pra fazer `person.age = age` por exemplo e ficou hardcoded. Viram?? Por isso copy e paste é perigoso, especialmente meia noite depois de estar cansado de passar 3 dias editando kkkkk

LINKS:


- Integer (Wikipedia) (https://en.wikipedia.org/wiki/Integer_(computer_science))
- Two’s Complement (Wikipedia) (https://en.wikipedia.org/wiki/Two%27s_complement)
- How numbers are encoded in JavaScript (https://2ality.com/2012/04/number-encoding.html#:~:text=JavaScript%20numbers%20are%20all%20floating,binary%20format%2C%20in%2064%20bits.)
- FLOATING POINT VISUALLY EXPLAINED (https://fabiensanglard.net/floating_point_visually_explained/)
- What Every Computer Scientist Should Know About Floating-Point Arithmetic (What Every Computer Scientist Should Know About Floating-Point Arithmetic (oracle.com))
- IEEE-754 Floating Point Converter (IEEE-754 Floating Point Converter (h-schmidt.net))
- Number.MAX_SAFE_INTEGER (Number.MAX_SAFE_INTEGER - JavaScript | MDN (mozilla.org))
- Signed Binary/Decimal Conversion Using the Two's Complement Representation (Signed Binary/Decimal Conversion (ubc.ca))
- C - Pointer arithmetic (C - Pointer arithmetic - Tutorialspoint)
- Why Discord is switching from Go to Rust (https://blog.discord.com/why-discord-is-switching-from-go-to-rust-a190bbca2b1f)



## SCRIPT

Olá pessoal, Fabio Akita


Seguindo meus episódios com o tema de fita de bits que venho explicando desde os episódios de introdução à computação até a história de Turing e Von Neumann, no penúltimo episódio eu expliquei sobre a diferença entre arquivos binários executáveis como os de formato ELF e arquivos texto e como tudo são fitas de bits ou o que eu chamei de linguição de bits. E hoje quero tentar explicar como podemos representar dados e manipular bits nessa linguiçona pra vocês conseguirem enxergar um pouco melhor como linguagens de programação lidam com dados. 







Se você foi direto aprender uma linguagem de alto nível como Python ou Javascript, sem ter aprendido linguagens de baixo nível, vai eternamente ter dúvidas de "o que" exatamente a linguagem tá fazendo. Por que certos comportamentos estranhos acontecem do nada. Eu aprendi programação no começo dos anos 90 com linguagens de alto nível também, no caso foi Basic e depois dBase. Eu só fui entender como as coisas funcionavam quando comecei a estudar Ciências da Computação. Muita gente resolveu pular essa etapa e por isso vai ficar travado muito em breve. No video de hoje eu quero tentar abrir as portas pra coisas que você raramente vai encontrar num curso qualquer por aí.







Infelizmente é impossível eu resumir anos de ciências da computação num video só, então você vai precisar complementar o que eu disser hoje com a ajuda do seu professor da faculdade, ou pelo menos alguém mais experiente que você. Aliás, sei que tem vários professores que assistem os vídeos, então este é um episódio onde seus alunos vão precisar de ajuda. 






Eu fiquei me indagando se devia quebrar este episódio em dois ou três mas resolvi entuchar tudo em um só mesmo pra tirar isso do caminho, então já aviso que vai ser super denso e bem difícil mesmo se você for iniciante. É normal não entender tudo só assistindo uma vez. Mesmo se você já sabe C, talvez goste de rever alguns conceitos de novo e até ajudar o povo nos comentários. Com tudo isso dito, respirem fundo, peguem papel e caneta pra anotações e vamos lá!







(...)







O objetivo hoje é destrinchar o linguição de bits de Turing e mapear o que acontece numa linguagem de programação de verdade. Vamos seguir o buraco de coelho e tentar enxergar a mulher de vermelho na Matrix. E a primeira coisa pra relembrar: na fita de bits, a máquina de Turing, ou o tal programa tem tanto binários que representam instruções pra sua CPU como também valores e dados, tudo junto um atrás do outro. Por exemplo, num hello world da vida, vai existir o valor "hello world" como uma cadeia de caracteres, o que chamamos de um String, e junto vai ter instruções pra mostrar esse String na tela de alguma forma.









String, em inglês é tipo um barbante, uma corda ou um fio. A forma mais simples de String é uma cadeia de bytes terminada com nulo de C. Se a gente encodar o "hello world" usando ASCII ou UTF-8, cada letra será representada por um código de 8-bits que é 1 byte. Então serão 11 bytes de tamanho mais o nulo no final. Mas se for em japonês "haroo waarudo", isso é uma String de 7 símbolos, cada símbolo no alfabeto katakana vai ocupar 3-bytes, então serão 21 bytes de tamanho. Como expliquei no episódio anterior, quantos bytes cada símbolo ocupa depende da tabela de conversão entre glifos e caracteres. Esse é o encoding.








Uma String com caracteres ocidentais de 8-bits é particularmente interessante porque é igual a um Array de bytes. Array em inglês é tipo uma série ou conjunto de coisas. Uma lista sequencial, com cada elemento do array um atrás do outro na memória, sem buracos no meio. Essa distinção é importante e já vou voltar a falar de arrays daqui a pouco, mas antes precisamos falar de números.







Em algumas linguagens você vai ver duas palavras distintas, um byte e um char. Se o char for ASCII de 8-bits, então um char é a mesma coisa que um byte na prática, como é em C. Mas em C# ou Java cada char representa um caractere UTF-16 que tem 16-bits ou 2 bytes, portanto é um double byte. Não se pode achar que um char é sempre um pra um com um byte, só quando falamos de C. Como hoje só vou falar de C, então considere um char sendo 1 byte.







Cada linguagem suporta um certo número do que chamamos de tipos primitivos. Char é um exemplo de primitivo, que é um pequeno pacote de bits, sem metadados. Outro exemplo são números. No mundo real estamos acostumados a pensar em números como os inteiros indo de menos infinito até mais infinito, mas em computadores os números são limitados por seus tipos e temos diversos tipos de inteiros.







Na maioria das linguagens de programação a gente costuma lidar com Inteiros de 8, 16, 32 ou 64-bits, respectivamente Int8, Int16, Int32 ou Int64. Na linguagem Rust, por exemplo, é exatamente assim que é dividido e eles são chamados de i8, i16, i32 e i64. E o Rust ainda tem o i128 também. Um int8 é basicamente um byte ou um char de C. 






No caso de C# o Int16 é chamado de Short, o Int32 é o Inteiro propriamente dito e Int64 é chamado de long. No caso do C é mais complicado porque se eu não estou muito errado o int dependia da arquitetura do CPU, então um int num computador de 16-bits era o Int16, mas num computador de 32-bits, se você recompilasse o mesmo programa, o int passava a ser 32-bits.










À primeira vista parece uma boa idéia, porque assim toda vez que as CPUs evoluem, bastaria recompilar o programa e ele automaticamente teria acesso a mais memória. Mas na prática isso pode levar a diversos tipos de bugs inesperados. Então quem decide o tamanho dos inteiros de C é o compilador. Mas nas linguagens mais modernas como C# ou Rust a declaração fica mais explícito qual tipo de inteiro você tá usando.







A razão de ter diferentes tipos de inteiros é a eficiência. Se você sabe que no seu programinha não vai precisar de números maiores que duzentos e cinquenta cinco, basta alocar um int8, ou 1 byte, e vai ser suficiente. Se você alocar um int64 sem precisar, vai desperdiçar 7 bytes que não vão servir pra nada. Se for uma variável só, não faz diferença, mas se for um array com milhares ou milhões de elementos, você vai rapidamente desperdiçar megabytes ou até gigabytes à toa.







Números inteiros ainda tem outra característica importante. Eles podem ser signed ou unsigned, ou seja, ter sinal ou não ter sinal. Se declarar um inteiro unsigned, sem sinal, ele pode ser usado pra números de 0 até hexa FF que é duzentos e cinquenta e cinco. Mas se for signed pode ir de negativo 127 até positivo 128. Quase a metade. Nesse caso o primeiro bit, que é chamado de bit mais significativo, e costuma ficar à esquerda dependendo do endianness do processador, é onde vai ficar o sinal. Se o primeiro bit for 0 então é um número positivo. Se for 1, então é negativo.









Daria pra fazer um video inteiro só falando de inteiros negativos e porque eles são interessantes, e isso é uma das coisas que recomendo pesquisarem a respeito depois. Mas vamos dizer o seguinte. Pra subtrair dois números com sinal, como 15 e 5, o computador primeiro vai enxergar eles em binário. Em 8-bits, no caso de 15 seria o binário 0000 1111. No caso de 5 seria 0000 0101. Você já aprendeu que subtrair um número é o mesmo que somar com seu negativo. Então poderíamos usar a máquina de somar que já mostrei como funciona no episódio de introdução mais hardcore a computadores. Reveja se não lembra mais.










Computadores usam o que se chama de método de complemento, que é a ideia de fazer uma subtração virar uma soma e usar o mesmo circuito de soma. Pra fazer isso ele transforma o segundo número no seu complemento de dois, ou two’s complement. Esse é um tema que você pode perguntar pro seu professor se ele não explicou. Pra achar esse complemento é simples, basta flipar todos os bits e somar 1, então o número 5 que é 0000 0101 vai virar 1111 1010 + 1 que é 1111 1011. O porquê de ter esse 1 extra no final é um dos motivos pra você estudar a teoria completa de two’s complement depois. Por agora vamos somar o 15 com esse 5 negativo.










Da direita pra esquerda, vamos lá, 1 mais 1 dá 2 que é 1 e 0 então fica zero e sobe um. Agora 1 mais 1 mais 1 é 3 que é 1 e 1, então fica 1 e sobe 1 de novo. 1 + 1 é 1 e 0 então fica zero e sobe um. De novo 1 mais 1 mais 1 é 3 então fica 1 e sobe 1. Agora tá fácil, 1 mais 1 fica zero e sobe 1. De novo, 1 mais 1 fica zero e sobe 1. Fica zero e sobe um. Fica zero e sobe um. 






O último um que subiu a gente descarta. E o que fica no final é 0000 ou seja, como o primeiro bit é zero, o número é positivo e depois 1010 que é 8 mais 2 que dá 10. Exatamente 15 menos 5, como você já sabia. E com isso demonstramos que é possível subtrair números inteiros com sinal usando o método de complementos e reusando o mesmo circuito da máquina de somar binário.

```
11111 111
 0000 1111
+1111 1011
 ---------
         0
        1
       0
      1
     0
    0
   0
  0
```



As CPUs são feitas de tal maneira pra tirar vantagem de ser base 2 em vez de base 10 pra conseguir calcular de forma mais eficiente do que fazemos com número decimais. Multiplicar e dividir é mais complicado e se tiverem interesse estudem o algoritmo de multiplicação de Booth. Mas tudo isso foi só pra dizer que existe diferença entre inteiros com sinal e sem sinal.







Já expliquei que dentro da CPU existem diversos registradores, que é como se fossem variáveis globais fixas no hardware. No 6502 do Nintendinho tinha o registrador A, X, Y e outros, todos de 8-bits. E quando falamos de um Intel ou AMD moderno, eles têm registradores e instruções de 64-bits. Mas e quando precisamos fazer contas com números extraordinariamente grandes, acima dos exabytes que 64-bits comportam? Isso não é incomum, principalmente num mundo de Big Data e data science. Pra isso existem tipos compostos como o BigInteger, que tecnicamente não tem limites. 








Se você tentar colocar um número de 128-bits num registrador de 64-bits vai dar overflow, ou seja, transbordar. Daí esse número seria truncado e metade seria perdido. Em vez disso, alocamos memória na RAM pra guardar esse número e, a grosso modo, fazemos a soma com a primeira metade, depois com a segunda metade e concatenamos o resultado. E sim, você pode fazer a soma de um número grande como duas somas de números menores, basta carregar o carry bit pra segunda soma. 






Então precisaria de pelo menos 2 instruções de adição numa máquina de 64-bits pra somar dois BigInteger de 128-bits, mas é possível. Só vai custar pelo menos 2 vezes mais caro do que somar números menores de 64-bits. Tudo em computação tem um custo, não é automático nem tudo igual.







Isso dito, falei um monte de nomes que podem parecer complicados mas só precisa lembrar que são convenções de como representar números inteiros decimais em formato binário, com limites que vão de 8 até 64-bits dependendo da arquitetura nativa da CPU, ou mais se usarmos abstrações como BigInteger. E com esses números podemos fazer praticamente tudo que precisamos. Aliás, pense que a geração de microcomputadores de 8 e 16 bits foi quase inteira baseada só em números inteiros. Todo joguinho de nintendinho até mega drive é feito usando números inteiros.







A tela de um jogo tem 320 colunas por 240 linhas de resolução, que é um número inteiro. Um sprite de nintendinho tem 8 por 8 pixels ou 8 por 16 pixels. Pra mover um sprite de lugar basta ir somando de um em um pixel. Os sprites podem escolher entre paletas de 4 cores dentre 54 disponíveis. Pontuação de jogos, quantidade de vidas, número de fases, são todos números inteiros.








E fora dos games, em aplicativos de produtividade, seja planilhas, processadores de texto, tudo é baseado em números inteiros. Quantidade de letras ou palavras num texto é um número inteiro. Mesmo se você mexer com coisas como preços, que têm frações da moeda em centavos, basta multiplicar por 100 e fazer contas com inteiros e só no final dividir por 100 e truncar depois de 2 casas decimais. Então preços de produtos, salários, impostos, tudo pode ser calculado facilmente e mais importante, rápido, porque o hardware tem circuitos pra somar números inteiros.








Foi principalmente com o advento de coisas como computação gráfica, animação em 3D, que números fracionados começaram a fazer diferença no mundo comercial. Claro, na computação científica já precisavam fazer cálculos fracionados com muita precisão. Em previsões de meteorologia ou laboratórios. Mas isso era em nichos mais isolados e restritos com acesso a hardware especializado. Desde o começo do século XX já haviam formas de calcular números fracionados. O Z1 de Konrad Zuse, que mencionei na história de Turing e Von Neumann, já tinha esses conceitos. Inclusive seu Z4 foi o primeiro computador comercial nos anos 1940 a ter suporte a números fracionados.








Mainframes como o UNIVAC ou os da IBM dos anos 60 tinham suporte a calcular números fracionados também. Mas foi só quando começamos a adotar arquitetura de 32-bits no começo dos anos 80 que os diversos padrões começaram a convergir pro que viria a se tornar o padrão IEEE 754. E só a partir do meio dos anos 80 que começamos a adotar em microcomputadores domésticos. 






Nos CPUs de 8-bits como o 8086 a Intel começou a desenvolver o que se chamaria de co-processadores matemáticos, como o 8087. Até a era do 386 a gente tinha opção de adicionar um segundo chip, como o 80387 que custava caro pra caramba e poucos programas usavam. Não lembro se foi já a partir dos 486 ou só nos Pentiums que paramos de precisar de co-processadores porque as instruções passaram a vir na própria CPU.








Precisamos entender pra que serviam esses co-processadores. Eu disse que até agora estávamos indo bem com números inteiros. Os CPUs dos anos 80 eram bons em processar números inteiros. Mas eventualmente a gente precisa lidar com números fracionados, com decimais. Em particular, números irracionais, ou seja, números que não podem ser representados por uma fração de números inteiros. Raíz quadrada de 2, o número Pi e muito mais. O Pi é o inteiro 3, depois tem uma vírgula e começa uma cadeia infinita de números um, quatro, um, cinco, nove, dois, seis, cinco, três e assim vai sem padrão nenhum até o infinito.








Se um número com decimais pode ser representado por uma fração, podemos usar números inteiros. Por exemplo, o número 0 vírgula 33333333 ad infinitum, é o inteiro um dividido pelo inteiro três. Assim muitos números com casas decimais infinitas podem ser representadas claramente com números inteiros finitos. Mas o mesmo não acontece com números irracionais como Pi. E computadores não tem memória infinita, então não temos como representar perfeito. Daí precisamos de uma aproximação. E a palavra importante aqui é “aproximação”, o que significa que ele não vai ser armazenado na memória como você acha que deveria e sim algo perto disso.








Essa aproximação é a especificação IEEE 754 que define o que chamamos de ponto flutuante. Esse tema é super chatinho e levaria um curso inteiro pra explicar e mesmo assim você vai ter dificuldade de entender, então vou simplificar grosseiramente hoje. Agora pouco eu expliquei como podemos ter inteiros com sinal e sem sinal. E quando tem sinal reservamos o primeiro bit mais significativo pra ser o sinal. Se for zero é positivo e se for 1 é negativo. Mas podemos reservar mais bits pra outras coisas também. Bits são o que a gente quiser que elas sejam. 








Em países como Brasil as casas decimais são separadas por vírgula, mas nos Estados Unidos e em outros lugares se usa ponto em vez de vírgula. Por isso falamos em ponto flutuante e não vírgula flutuante. Você já deve ter ouvido falar do tipo `float`. O ponto separa a parte inteira do número da parte decimal e num computador fazemos esse ponto flutuar pra aumentar ou diminuir a precisão. Mas isso não é a história toda.







O IEEE 754 define vários tipos de float. O mais conhecido hoje é o binary64 que é um número de 64-bits ou 4 bytes. O primeiro bit é igual de um inteiro com sinal, ele define o sinal. Depois vêm 11 bits que representam o número do expoente e os demais 52 bits representam a mantissa. E o que é isso? É notação científica, mas na base 2. Na base 10 pra representar um número como 15000 poderia ser 1.5 x 10^4 ou 1.5e4, e esse “e” é de “expoente”. 1.5 é a mantissa e 4 é o expoente na base 10.







Um float é a mesma coisa, só que seria o primeiro bit de sinal pra positivo ou negativo, daí 2 elevado ao expoente armazenado nos próximos 11 bits, multiplicado pelo número representado nos 52-bits seguintes, que é a mantissa. O número inteiro máximo que pode ser representado nesse formato é 2 elevado a 53 que dá o número 9 quadrilhões e alguma coisa, que em particular, se você é de Javascript, é o que você já conhece como MAX_SAFE_INTEGER que, em binário, é representado assim aqui do lado: zero pro sinal pra ser positivo, o expoente só com o último bit flipado e a mantissa inteira de uns.

```
0
00000000001
1111111111111111111111111111111111111111111111111111
```



Da mesma forma, o que no Javascript você chama de MIN_SAFE_INTEGER que é o menor número que se pode representar assim, é só flipar ou inverter todos os bits do expoente e o primeiro bit significativo do sinal que temos o 9 quadrilhões e tanto negativo.

```
1
11111111110
0000000000000000000000000000000000000000000000
```



O grande lance é que não conseguimos representar em notação científica de base 2 exatamente o número que normalmente queremos de decimal, sempre vai ter um erro de conversão. Por exemplo, podemos ir no site do link abaixo, que eu vou deixar nas descrições, que mostra essa conversão pra gente. Se tentarmos converter 0.1 na realidade vai dar zero ponto um zero zero sete vezes um quatro nove etc que é esse binário aqui do lado. É uma aproximação na base 2. Ou seja, depois do 1 vai ter uma pequena sujeira por isso tecnicamente é diferente de 0.1 exato, embora bem próximo se arredondar.






Mesma coisa se tentarmos converter 0.2 em binário, vai virar zero ponto dois, zero zero sete vezes de novo, dois nove oito etc. E esse numero float em binário é esse outro numerozão aqui do lado. E pra finalizar, 0.1 mais 0.2 deveria ser 0.3 se fosse base 10, mas 0.3 em binário vai ser esse numerozão aqui do lado. Com o erro de conversão na verdade vai ser zero ponto três zero zero seis vezes um um nove dois etc. Sempre vai sobrar uma sujeirinha em vez de ser zero zero zero só zero.






Se somarmos o 0.1 e 0.2 na instrução de soma binária do CPU, com os erros de precisão da conversão em binário, o resultado vai dar zero ponto três zero zero sete vezes, depois quatro quatro sete etc. Mas a conversão do 0.3 pra float dá zero ponto três zero zero só seis vezes em vez de sete e depois um um e não quatro quatro. É por isso que no Javascript e em diversas outras linguagens como Python, se você fizer 0.1 + 0.2 e tentar comparar com 0.3 vai dar false. Porque de fato quando converter de decimal pra float na base 2 ele vai ganhar essas sujeirinhas de erro de precisão na conversão e quando se faz conta com essas precisões ligeiramente erradas, a precisão do resultado também vai ser ligeiramente errado.



`0.100000001490116119384765625 + 0.20000000298023223876953125
00111101110011001100110011001101 + 00111110010011001100110011001101
0.3 = 0.300000011920928955078125 = 00111110100110011001100110011010
0.1 + 0.2 = 0.300000004470348358154296875`






Quem já tentou fazer muitas contas com float já se deparou com isso. E pra ser justo não é só em Javascript. Se você fizer a comparação de 0.1 mais 0.2 com 0.3 vai encontrar que é falso em Ruby, em Rust, em Python. Se não me engano, C# é uma linguagem que se dá ao trabalho de ajustar esse erro de precisão e devolve verdadeiro, mas no resto, que só faz a conversão direta pra binary64 do IEEE 754, vai ter esse problema nada intuitivo se você só pensar na base 10 e não na base 2. Você faz 0.1 mais 0.2 e no final não é exatamente 0.3. E isso é pior no Javascript por outra razão.







Em Javascript o único tipo numérico que existe é o float binary64. Não existem inteiros primitivos como mostrei antes. Então, em vez do inteiro máximo de dois elevado a 64, o máximo vai ser dois elevado a 53 como declarado no tal MAX_SAFE_INTEGER. Que é um número grande, mas não é o máximo que sua arquitetura suporta. E se você fizer conta com dinheiro, tipo desconto em produtos, ou calcular saldo baseado num extrato de conta, não faça contas com float, porque esse erro de precisão uma hora vai dar ruim. Pequenas sujeiras de precisão, em volume grande de contas, uma hora vai afetar bastante. No mínimo multiplique o valor por 100 pra trabalhar com centavos ou trunque depois de duas casas pra não ter essa sujeira final. 







Melhor ainda, justamente por conta de bugs de precisão como esse, existe outro tipo de dado. Semelhante ao BigInteger que falei antes, a maioria das linguagens tem um tipo chamado BigDecimal. Assim como o BigInteger, pra fazer contas aritméticas, vai ser mais lento, porque vai precisar quebrar o numero em segmentos, fazer aritmética das partes e depois dar um jeito de concatenar o resultado, porque o numerozão não cabe nos registradores de 64-bits. No caso do BigDecimal, mesma coisa, ele vai permitir mais precisão e cuidar pra evitar essa sujeira de conversão.








A linguagem Javascript não tem um BigDecimal nativo, então você precisa baixar uma biblioteca que ofereça isso. Na verdade esse é um dos pontos onde Javascript é corretamente criticado. Todo número nele, seja um inteiro ou seja um float, em binário, é representado como um float binary64, o que eu pessoalmente acho tosco. Existe uma classe Number e ela deveria converter nos tipos corretos internamente, até pra pesar menos toda vez que precisa fazer cálculos. Dependendo de que versão da história você ver, esse é um dos efeitos colaterais da linguagem ter sido criada tão às pressas. E depois que já foi adotado assim, você tem dificuldade de voltar atrás agora. Pesquise sobre isso depois.








Enfim, o float que a maioria das linguagens usa é o tal binary64, de 64-bits que eu expliquei. Mas antigamente o que era chamado de float em C era a versão binary32. E a versão 64-bits era chamada de double. Então se algum dia você ver double, é o float de 64-bits. De qualquer forma, o importante era explicar que existia essa forma de se representar números e existem outras, como pra representar números complexos, mas não é importante pra hoje. Lógico, que fique de lição de casa pra vocês depois.













Agora vamos voltar ao tal do Array. Array é um conjunto que contém elementos do mesmo tipo, sequencialmente, um atrás do outro na fita de bits, como por exemplo array de números int8 ou float. Quando associamos uma variável a um array na realidade estamos apontando pro endereço do primeiro elemento desse array. E toda vez que tentamos acessar uma posição específica dentro desse array, basta pegar o endereço inicial e somar pelo tamanho do tipo do elemento que ele contém.






O importante de Arrays e Strings é entender que a sequência de bytes ou chars é necessariamente um atrás do outro, sem intervalos no meio. Se a gente aloca um array de 100 elementos int8, que é de 1 byte de tamanho, o array vai usar cento e um bytes de memória contígua. Esse um a mais é o byte nulo no final da sequência que indica o término dela, no caso de Strings. A beleza é que pra acessar qualquer elemento dessa sequência, sabendo a posição, basta pegar o endereço do primeiro elemento, o comprimento de cada elemento, no caso 1 byte, e multiplicar pela posição pra ter o endereço do que estamos procurando.







No exemplo do "hello world", é um array de chars de 12 bytes contando o nulo no final. Se eu quiser puxar a 7a letra, basta pegar o endereço do primeiro elemento que é o "h" do hello, e somar por 7 bytes, já que cada char tem 1 byte de comprimento, e nesse 7o endereço vai estar a letra "w", de "world", como esperado.






Agora, isso só funciona porque cada elemento tem exatamente o mesmo comprimento, a mesma quantidade de bits. O requerimento de todo array é que todos os elementos dentro devem ser do mesmo tipo. Se quisermos armazenar números long, que tem 4 bytes, então todos os outros elementos precisam ser long. Daí um array de 100 elementos long vai ter 400 bytes de tamanho. E um outro problema disso é que um array tem tamanho fixo. Uma vez alocado, não tem como ser expandido.







Daí você pode ficar confuso, porque num Javascript e outras linguagens, se o array inicial tem 100 elementos e eu quiser adicionar mais, basta acessar direto a posição 101 e escrever lá. Por exemplo, vamos abrir o console de Javascript em qualquer navegador e declarar um array chamado `lista` com umas cinco letras, como nosso "hello". Se eu tentar acessar a posição 4, vamos pegar a última letra "o", e é 4 porque todo array que se preza começa da posição 0. Se eu tentar pegar a posição 5, vai vir undefined porque passei do fim do array. Mas eu posso tranquilamente gravar uma nova letra como "exclamação" nessa posição e boom, o array automaticamente “expande” pra comportar a nova letra, mas como isso é possível se eu falei que arrays tem tamanho fixo?









Na maioria das linguagens mais alto nível que C, tem estratégias, do grego estrategia. Se eu não disser o tamanho exato que quero, ela vai pré-alocar um espaço maior do que preciso. Dessa forma, se precisar de mais elementos depois do fim, tem espaço livre sobrando. E é uma estratégia quando você sabe que tem mais RAM do que precisa. Mas, se eu realmente chegar ao fim do espaço que a linguagem alocou pro meu array, o que ela vai fazer é alocar um novo array maior, copiar elemento a elemento pro novo array e descartar o antigo. 







De novo, você não tá sabendo, mas tá acontecendo um custo extra de processamento por baixo dos panos. No dia a dia você nem percebe porque normalmente mexe em poucos arrays, mas em operações que tenham milhares ou milhões, aí você vai querer tomar mais cuidado com operações que fiquem mudando o tamanho dos arrays. Mesmo que a operação na linguagem seja só uma linha, por baixo dos panos ela vai fazer diversas outras, como duplicar seu array, que você nem fica sabendo e aí não entende porque a performance ficou tão ruim sem motivo aparente.








Mais ou menos a mesma coisa acontece com Strings. No C, sem bibliotecas extras, um String é literalmente declarado só como um array de chars. Em linguagens mais modernas o String é um tipo separado do Array, mas internamente a maioria usa Arrays, só que o tipo extra dá um suporte maior a coisas como conversão de encoding e tudo mais. Na prática, tanto arrays quanto strings, uma vez declarados e preenchidos, são fixos. E aumentar o tamanho deles pode envolver criar um novo array e copiar o conteúdo do antigo em cima do novo. Por isso um Java tem classes extras como StringBuffer pra lidar com strings que você vai precisar crescer depois.








Agora, tudo isso que eu vim falando até agora, array, string, ints ou floats, todos ocupam algum lugar numa memória, seja RAM, ROM, SSDs ou qualquer outra coisa. É tudo uma fita de bits, onde cada posição tem um endereço. Zero, um, dois, e assim vai. Cada valor em uso pode ser encontrado nessa fita com um endereço, é uma localização. O conceito importante aqui é entender que tudo tem um endereço nessa fita, que pode ser qualquer tipo de memória. Pode parecer complicado só porque endereços em máquinas de 64-bits podem ir até numerozões do tamanho de exabytes. E pra piorar escrevemos esses endereços como hexadecimais. Mas endereços são só isso: números.







Eu sei que tô andando bem rápido e já soltei bastante coisa até agora, mas se segurem que agora que a coisa vai ficar interessante. Recomendo que depois assistam tudo de novo com calma se isso é novo pra vocês, mas agora é uma boa hora pra eu descer mais ainda na escovação de bits. Uma coisa que não é claro pra iniciantes é onde ficam todas essas variáveis ao longo da execução de um programa. Então vamos partir de um exemplo bem besta em C. E não se preocupem se você nunca usou C, mesmo assim você deve ser capaz de acompanhar. 







Em outros episódios eu já mostrei como isso funciona. A gente abre um editor de textos, escreve o codigozinho em C e usa o compilador `cc` que é o GCC pra ler esse código e dar output ou saída num binário executável em formato ELF, que o Linux consegue entender e executar. Se não sabe o que é isso, pelo menos assista o episódio da diferença de arquivos binário e texto, onde eu mostro como isso funciona. 






O binário ELF tem um endereço específico onde fica a primeira instrução que vai começar a executar. No caso é o hexa 0x1000. Esse endereço é gravado no registrador chamado PC, que é o program counter ou contador de programa. É a partir disso que o CPU vai executando a instrução que tá apontado nesse contador. Uma vez executado o contador incrementa o endereço e aponta pra próxima instrução na fita de bits.







Bem a grosso modo, só pra ficar mais fácil de explicar, é como se esses endereços fossem os números da linha do código C no nosso editor de textos. Claro que não é, porque o que tá no binário não é o código que digitamos e sim o que o compilador traduziu pra linguagem de máquina, o linguição de bits. Mas pra facilitar a explicação, pense que no tal endereço 0x1000 ele pula ou dá JUMP pro endereço da função `main` do C e vai executando uma linha de cada vez dessa função. Sempre que eu me referir a endereço de programa como sendo o número da linha, é só uma metáfora pro endereço hexadecimal da instrução equivalente na memória de verdade.




```
#include <stdio.h>

void f2(char hello[]) {
    printf("from f2: %d\n", &hello);
    printf("%s\n", hello);
}

void f1(char hello[]) {
    printf("from f1: %d\n", &hello);
    f2(hello);
}

void main() {

    char hello[] = "Hello World";
    printf("from main: %d\n", &hello);
    f1(hello);

    return;
}
```




A função `main` é o ponto de partida de qualquer programa em C. Neste exemplo vai alocar uma String "hello world". Daí pegamos a referência dessa variável com esse & comercial na frente. Isso pega o endereço onde a string tá armazenada pra podermos imprimir na tela. Daí passamos a variável pra outra função que vamos chamar de `f1` e colocar no começo do arquivo. Aqui parece qualquer outra linguagem que você já usou, chamando uma função e passando um argumento entre parênteses. E precisamos declarar a função `f1` antes da `main` porque em C, pra usar uma função embaixo, ela precisa estar definida antes. Em outras linguagens isso não é verdade, depende do compilador. Mas no caso de C é assim.







Daí nessa função `f1` vamos receber como argumento um array de chars de novo e dentro vamos imprimir o endereço onde a variável desse argumento foi armazenado, e depois repassar essa variável pra outra função `f2`. De novo, definimos acima a função `f2` que, mesma coisa, vai receber um argumento de array de chars, imprimir o endereço da variável e por último imprimir o valor da variável que é o "hello world". É um exemplo super besta, só fomos passando o mesmo valor algumas funções pra frente. Vamos sair do editor e usar `gcc` ou `cc` pra compilar esse código no tal executável ELF, e podemos rodar.








Agora a gente vê primeiro o endereço da primeira vez que declaramos a variável `hello` na função main. Vou repetir caso tenha ficado confuso. Se eu der `printf` direto na variável `hello` iria imprimir o valor “Hello World”. Mas como colocamos esse & comercial na frente da variável, na realidade ele vai acessar o endereço onde o Hello World está gravado na memória. Tudo tem um endereço e em C, diferente de outras linguagens, temos acesso direto a esse endereço com essa notação. 







Eu já falei do endereço de cada instrução do executável e na mesma memória estão valores que vamos criando, como essa String. Então executar um programa é executar a instrução que tá em algum endereço. E os valores que cada instrução vai usar, por sua vez, também estão em algum endereço na memória. E com esse & comercial na frente da variável podemos fuçar o endereço. Pense no Hello World como o conteúdo de um arquivo texto e esse endereço como sendo uma URL de uma página web tipo http://hello.com.







O segundo numerozão que aparece é o endereço do argumento de dentro da função `f1`, quando passamos o `hello` pra ela. Veja que o endereço é diferente, apesar do valor ser o mesmo. Ou seja, ao passar a variável pra função ela foi duplicada. E a terceira linha é a mesma coisa, outro endereço diferente que foi impresso de dentro da função `f2`. Porque quando a `f1` passou sua variável pra `f2` como argumento, essa variável foi duplicada de novo. 







No final criamos 3 cópias desse String na memória ao longo do caminho, cada uma com endereços diferentes. Você pode ver que toda vez que damos `printf` passando a referência da variável ela imprime um número diferente. Toda vez que se passa uma variável de tipo primitivo como argumento de uma função, ela é duplicada. E isso não é só em C, mas na maioria das linguagens. Isso tem um nome, se chama “passagem por valor”, que é diferente de “passagem por referência”, que eu vou mostrar já já. A vantagem é que se a gente modificar o valor do argumento dentro da função, por exemplo a `f1`, o valor original antes de ser duplicada, por exemplo, na função `main`, não vai mudar depois que a `f1` der return.








Outro detalhe, o endereço é impresso negativo na tela porque o binário desse endereço começa com 1 e a função `printf` interpreta como sendo um integer com sinal, que como eu expliquei agora pouco, se começa com 1 ele acha que é um número negativo. Mas também por começar com 1 sabemos que se trata de um endereço na metade mais alta dos endereços da memória. Considere que o endereço mais baixo é o binário zero zero zero etc sessenta e quatro vezes e vai incrementando de um a um até o endereço um um um um sessenta e quatro vezes que é o endereço mais alto.








O espaço de memória que um programa enxerga é segmentado segundo alguma convenção. Pra facilitar a vida, num Windows da vida, ele começa a alocar memória pra drivers e coisas do sistema no final da metade alta, ou seja, começa no endereço binário um um um etc ou hex FFFF etc e vai diminuindo. Já programas de usuário, tipo seu navegador, o Spotify e tals, começa no início da metade baixa, mais próxima dos endereços que começam com zero. 









Um adendo. Um computador antigo de 32-bits suportava um máximo de RAM de dois elevado a 32 que é pouco mais de 4 gigabytes. Quando passamos a adotar arquiteturas 64-bits, não dobramos de memória, mas sim elevamos ao quadrado. Por isso o máximo teórico é mais de 16 exabytes. Porém, nenhum chip comercial que a Intel ou AMD fabricam de fato suportam mapear esse tanto de memória ainda. Internamente as instruções lidam com valores de 64-bits mas nenhum hardware que você conseguir comprar, nem os AMD EPIC Threadripper da vida suporta tudo isso. Eles costumam ser capados em 42 ou 48 bits de endereços em vez de 64, ou seja, pouco mais de 280 terabytes. Que é coisa pra caramba, claro, mas só pra você saber que ainda não chegamos no máximo dos 64-bits em hardware comercial.









De qualquer forma, isso é a memória real. Mas como expliquei nos episódio de gerenciamento de memória, um processo rodando enxerga memória virtual, que é o sistema operacional mentindo pros nossos programas como se eles tivessem acesso a toda a memória teórica de 64-bits. É o que chamamos de memória virtual. Dentro desse espaço virtual, os endereços que começam do zero e vão subindo é o que chamamos de memória dinâmica, ou "heap" que é pra onde vai a maioria dos dados que seu programa carrega. Quando você carrega um arquivo em memória, ou quando se conecta num servidor de API e puxa JSON, ou quando pede dados no banco de dados, tudo vai pro heap. Heap em inglês é um montão, um amontoado.








Repetindo, lá no topo, nos endereços que começam com bit 1, é onde fica o segmento de memória reservada pra kernel, que é uma área exclusiva pra endereços de coisas do sistema operacional, mas o próximo segmento é o que chamamos de pilha ou "stack". Se eu não tô muito enganado, todo processo começa com pelo menos 8 megabytes de memória alta reservada pra stack e ela pode expandir decrementando endereços pra baixo. Pode consumir até uns 2 gigabytes. 






A heap é a mesma coisa mas do outro lado, começa na memória baixa já com pelo menos 1 megabyte reservado e se precisar de mais vai incrementando endereços pra cima. Lembre-se que o stack de um nintendinho de 8-bits tinha meros 255 bytes, que é do endereço hexa $0100 até $01FF.








Eu explico pra que serve essa stack no episódio da introdução mais hardcore a computadores mas vamos resumir usando o exemplo do hello world que fiz agora. Eu tenho 3 funções, a main, a f1 e a f2. Cada uma delas aloca espaço pra duplicatas da string hello world, daí imprimem o endereço onde a variável foi alocada e no final sai fora e retorna pra função que chamou ela. Aliás, em C, se uma função tem como tipo de retorno um `void` que é tipo `nada` em C, então nem precisa dar return, porque não estamos retornando nenhum valor. Vamos na ordem. 








Ao executar o binário ele pede pra kernel do sistema operacional alocar espaço pro novo processo e inicializar seja lá o que ele precisa. A kernel vai usar o gerenciador de memória e alocar o mínimo necessário pro programa rodar e depois vai dando memória real pra ele à medida que for pedindo.








Depois ele pula pra primeira função que é a `main`. Agora cria a variável `hello` que é um array de chars com 12 bytes de tamanho. Isso é alocado na Stack. Agora eu chamo a função do C chamado `printf`. Não vou explicar como o `printf` funciona, mas vamos aproveitar pra explicar a mecânica dessa tal stack ou pilha. Toda chamada de função começa guardando o endereço atual de execução, o que está no tal contador de programas. No nosso pseudo-exemplo de endereços seria o número da linha do nosso código onde chama a função.








No momento que a função `main` chama a função `printf` ele faz tipo um bookmark do contador de programa e coloca no stack. Daí podemos substituir o endereço no contador de programa pelo endereço da função que tá chamando, no caso o endereço pra `printf`. Agora, dentro da `printf` vai alocar outras variáveis, faz de conta, umas variáveis x ou y quaisquer, que vão sendo colocadas na stack. 







Finalmente imprime na tela o que precisava e no final dá `return`. Esse return começa a desempilhar o que alocou na stack até achar o último endereço que a `main` gravou, o tal bookmark do contador de programas, e dá jump, ou seja, pula pra ela. E pular significa colocar de volta esse endereço mais um no contador de programa, daí ele pode continuar da próxima linha depois de chamar a função. É mais ou menos isso que faz um `return`. O que tinha sido colocado na stack pelo `printf` foi liberado e voltamos a executar na próxima linha.









De volta ao `main` a próxima linha chama a nossa função `f1`. Mesma coisa, vamos empilhar o endereço dessa posição na stack. Como eu disse antes, ao passar a variável `hello` como argumento, estamos duplicando a variável, então vai empilhar essa duplicata na stack também. Dentro de `f1` vai chamar `printf` de novo pra imprimir o endereço dessa duplicata, por isso temos valores diferentes de endereços. 






Já sabemos como isso funciona, então vamos pular os detalhes de `printf` pra não ficar repetitivo. Pode assumir que empilhamos e desempilhamos `printf`. Em seguida o `f1` vai chamar a `f2`, e novamente o endereço dessa linha vai ser empilhado na stack, a variável hello vai ser duplicada e empilhada na stack também, e de novo vamos chamar `printf`. por fim vai ter um return.










Esse `return` vai desempilhando até ver o endereço de volta à função `f1` e dar jump pra ela. Agora no `f1` não tem mais nada a não ser outro `return`, então continua desempilhando até o último endereço gravado da função `main` e dá jump de volta pra ela. E finalmente na `main` também temos um return. Agora é o último de todos, então ele sai do programa inteiro, daí o sistema operacional vai fazer a limpeza da memória desse processo e tudo termina com sucesso.







A razão dessa explicação longa foi pra mostrar no nível mais básico o que significa chamar funções e como variáveis são gerenciadas na stack. Toda vez que você chama funções e passa argumentos pra ela, esse registro de execução vai sendo empilhado na stack, que é uma pilha. Pilha é uma estrutura de dados super importante e uma das mais fundamentais junto com Queues, que é inglês pra filas. Elas são parecidas, mas não vou falar de queues hoje. E pilhas existem dois tipos, FIFO e LIFO. 








A pilha que estamos usando aqui é do tipo LIFO, ou seja, Last in, first out. Então o último elemento que empilhamos é o primeiro que vai ser desempilhado. Esse é mais um tema que você precisa estudar em detalhes, como é implementada e como funciona em todos os casos. É uma das lições da matéria de Estrutura de Dados e Algoritmos que qualquer faculdade ensina e mesmo se você for autodidata deveria estudar. 







De qualquer forma, você vai se lembrar que eu falei que essa stack costuma começar com um tamanho de 8 megas e pode expandir até uns 2 gigas. Isso é bastante pra programas de qualquer tamanho. Repetindo, um jogo de Nintendinho inteiro, seja Super Mario, Zelda ou Final Fantasy conseguia se virar com uma stack de meros 255 bytes, isso é um quarto de um mísero megabyte. Estourar esse stack é sinal de má programação e acredite, não é difícil estourar a stack. E quando ela estoura, seu programa crasheia.








O jeito mais fácil de estourar é via recursão. Recursão é uma função ficar chamando ela mesma sem parar. Vamos dar um exemplo, podemos fazer uma função chamada `f3` como essa aqui do lado, e ela ficar chamando ela mesma. Além disso, nessa função `f3` vou ficar passando o argumento hello toda vez. Cada chamada a `f3` vai duplicar a string de hello world na stack. Daí vamos imprimir o endereço que cada uma delas tá ocupando na stack. 








Se compilar e executar notem como os endereços seguem uma sequência decrescente um atrás do outro. Não são números aleatórios. Como eu disse, a stack começa nos endereços mais altos, depois do espaço da kernel na memória. À medida que vamos empilhando novas chamadas de f3 e duplicando a variável hello como argumento, os endereços vão diminuindo. Ela vai do fim em direção ao meio da memória.








E no final, boom, o programa crasheia porque acabou a stack. A função `f3` fica chamando ela mesma infinitamente até bater no limite que o sistema operacional permite. No caso do linux dá um segmentation fault. Esse erro é bem genérico mas significa que você tentou acessar memória que não existe, ou que não te pertence, ou qualquer tipo de acesso a memória que o sistema não sabe como lidar. No nosso caso, por ter acabado a memória da stack. Se pegarmos o primeiro endereço impresso na tela e o último e subtrair um pelo outro, podemos saber quanto de memória da stack foi ocupada antes do crash.








Como expliquei antes, esse primeiro número é negativo porque em binário começa com o primeiro bit mais significativo sendo 1, que o `printf` entendeu como integer com sinal negativo. Mas se convertermos de volta pra hexa temos esse linguição aqui, hexa F nove sete D dois zero A oito. Mesma coisa fazemos com o último endereço que foi impresso na tela e vamos ter hexa quatro um zero nove três sete zero oito. Fazendo um menos o outro temos esse numerozão, que se formos dividindo por mil e vinte e quatro, vai dar exatamente 2 gigabytes. Então podemos estabelecer que nosso stack durou até bater 2 gigabytes.


```
-109240152 = 0xF97D20A8 = 11111001 01111101 00100000 10101000
1091122952 = 0x41093708 = 01000001 00001001 00110111 00001000
```






Recursão é extremamente importante na programação e você precisa garantir que uma hora essa recursão vai parar antes da stack encher. Existe um caso especial de recursão que não enche a stack agressivamente desse jeito e ela simplesmente vai fazer jump de volta pra algumas instruções pra trás sem ficar enchendo a stack a cada chamada recursiva. Isso se chama Tail Recursion e vou deixar de lição de casa pra vocês estudarem caso nunca tenham ouvido falar disso. A maioria das boas linguagens suporta tail recursion e isso diminui bastante os casos de estourar a stack.








Mas além da recursão temos outro problema nesse exemplo besta. Toda vez que chamamos a função `f3` recursiva, passamos a string de hello world e ela é passada por valor, ou seja, é duplicada. Cada chamada recursiva que fazemos, no mínimo, tá empilhando o endereço pra onde o return vai dar jump de volta, que é um endereço de 64-bits ou 4 bytes, “mais” a duplicata de hello world que custa 12 bytes. Só isso são no mínimo 16 bytes a cada chamada.








Ou seja, dos 2 gigabytes de stack, talvez uns 3 quartos tão ocupados só com duplicatas de hello world, que é um grande desperdício. Uma string idealmente deveria ser imutável. Quando precisamos modificar a String ou concatenar mais texto nela, aí sim precisaríamos fazer uma duplicata. Mas se a variável vai permanecer sempre a mesma como uma constante, não precisaríamos ficar duplicando toda vez que passamos pra outra função. Imagina se em vez de hello world essa string fosse um texto enorme, uma ou mais páginas da Wikipedia, ocupando 1 mega, ou talvez 1 giga. Em duas chamadas de função duplicando a variável passando por valor ia acabar a stack. Então o que fazemos?








Vamos nos lembrar que eu falei que a stack é só um dos segmentos da memória total. A memória virtual total de 64-bits caberia até 16 exabytes de dados. Meros 1 giga não é nada. Eu poderia duplicar um texto de 1 gigabyte trilhões de vezes até acabar a memória toda. Mas no nosso caso o segmento da stack acaba em 2 gigabytes. Então como fazemos?







Agora vem a parte mais complicada. Vou tentar explicar pra vocês o temido Pointer ou apontador. Parece difícil mas o básico é bem simples, na real. Em vez de alocar espaço na stack pra guardar meus strings ou mesmo qualquer outro array gigante, vamos alocar ela no heap. Já expliquei antes que o Heap é o segmento da memória total que começa nos endereços mais baixos perto de zero e cujos endereços vão incrementando. 







Repetindo, enquanto os endereços da stack começam do endereço mais alto e vão decrementando em direção ao começo, os da heap começam no endereço mais baixo e vão incrementando em direção ao fim. O sistema operacional vai garantir que um não cruze os limites do outro no meio. Tecnicamente os endereços da heap podem ir incrementando até o limite de não ultrapassar os endereços do stack, entenderam?







Quando você instancia um objeto numa linguagem como Python, Javascript, Ruby, Java, C#, o bloco de memória que contém todos os dados do objeto ficam no heap. E na stack fica só endereço, ou a referência que aponta pra esse objeto, que numa arquitetura de 64-bits vai ter sempre o tamanho fixo de 4 bytes, independente de quanta memória foi alocada pro objeto no heap. O truque é simples, vamos voltar ao hello world e em vez de alocar na stack, vamos mover pro heap.




```
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void main() {

    char hello[] = "Hello World";
    printf("from main: %d\n", &hello);

    char *hello2 = malloc(sizeof(hello));
    strcpy(hello2, hello);
    printf("hello2: %x\n", hello2);

    char *hello3 = hello2 + 6;
    printf("from hello2: %s\n", hello2);
    printf("from hello3: %s\n", hello3);

    return;
}
```





Em C precisamos incluir o cabeçalho `stdlib.h` que nos dá acesso à famosa função `malloc` que significa “memory allocation”. O argumento que passamos é quantos bytes queremos que ela reserve no heap. No caso, podemos usar outra função chamada `sizeof` que, como o nome diz, mede o tamanho de alguma coisa. E como parâmetro pra essa função passamos a variável hello que alocamos na stack, que é 12 bytes. 








Poderíamos passar direto o número 12, também. Mas o que o `malloc` vai fazer é procurar um segmento contínuo de 12 bytes no heap e passar pra gente o endereço que ele reservou no heap. E essa nova variável `hello2` vai guardar esse endereço, que é um número de 4 bytes. Então esse `hello2` é um ponteiro porque seu endereço aponta aonde vai estar o string na Heap. É só isso.








Aqui a coisa pode ficar mais cabeluda ainda, então prestem atenção. Com esse endereço em mãos podemos usar outra função do C, o `strcpy` ou string copy, passando como argumentos esse endereço e a variável hello antiga pra copiar o hello world pra esse novo espaço na heap. Essa é a única duplicata que vamos ter a partir de agora. A parte importante é entender que na variável `hello2` nós não temos a string hello world e sim o endereço pro primeiro byte na heap onde vamos encontrar essa cópia do hello world.







Sendo o hello2 um ponteiro com um endereço e sabendo que cada char da string tem exatamente um byte e sabendo que ela acaba quando encontramos o caracter NULO, se fizermos outro ponteiro chamado `hello3` que é `hello2` mais 6, agora vamos ter só a palavra `World` se dermos `printf` nela. Vamos compilar e rodar pra ver. Olha como imprime na tela o Hello world do ponteiro hello2 e só world do ponteiro hello3. Mas a gente não criou ou duplicou uma nova string, estamos apontando pro mesmo espaço na memória só que 6 bytes mais pra frente.







Essa sintaxe ou notação de asterisco é pra indicar à linguagem que essa variável é um ponteiro e queremos acessar o valor gravado no heap, nesse exato endereço. Se não colocarmos o asterisco, vemos direto só o endereço. Se colocarmos o asterismo ele trás o valor pra onde esse endereço tá apontando. Tanto as variáveis `hello2` quanto `hello3` parecem representar um string diferente mas na verdade são só endereços ou, mais corretamente, referências, ao mesmo string, só apontando pra posições diferentes no mesmo string. Pra acessar o string em si, usamos asterisco hello2 e asterisco hello3.








Seja um string ou seja um array, já que string é um caso especial de array, a variável `hello` não contém "O" array e sim o endereço pro primeiro elemento do array. Se eu quiser pegar um elemento no meio do array, primeiro pego o endereço e somo a quantidade de bytes que leva ao elemento que eu quero. Se for um array de chars, que é uma string, onde cada char tem 1 byte; pra pegar a 6a letra, basta somar 6 bytes ao primeiro endereço. 





Quando fazemos aquela notação que tem em toda linguagem, com brackets ou colchetes, com um número no meio, a linguagem tá traduzindo por baixo em uma soma de endereço, como eu mostro aqui no código. É o endereço inicial, mais o tamanho de cada elemento multiplicado pela posição. Vejam que estou repetindo essa operação pra tentar deixar bem claro esse funcionamento.











Tem uma última estrutura de dados que eu quero explicar pra vocês hoje. Como eu repeti de propósito várias vezes até agora, arrays são listas que tem sempre os mesmos tipos de elementos, ou mais corretamente, que tem elementos de mesmo tamanho. Se for um string, é um array onde cada elemento tem 1 byte, se for um array de inteiros de 64-bits, todo elemento tem exatamente 4 bytes. E eu vim repetindo a mesma coisa sobre elementos iguais por causa do seguinte: e se eu quiser uma sequência onde cada elemento tem tamanhos diferentes?








Pra isso, em linguagens de alto nível tipo Python existe a tupla ou tuple, ou no caso de C existe Struct. Em conceito não são a mesma coisa, mas pra hoje pense que é. Vou explicar porque. Diferente de um array onde cada elemento em sequência tem o mesmo tamanho, num struct ou tupla podemos declarar tipos diferentes que vão ser concatenados um atrás do outro no linguição de bits. 





```
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <inttypes.h>

struct Person {
    char nome[10];
    uint8_t age;
    uint8_t height;
};

void main() {
    struct Person person;
    strcpy(person.nome, "Fabio");
    person.age = 43;
    person.height = 172;

    printf("%x\n", &person);

    return;
}
```




Por exemplo, podemos declarar uma Struct ou estrutura chamada Person, cujo primeiro elemento vai ser um array de chars de 10 bytes, um nome curtinho. O segundo elemento vai ser um int de 8 bits, ou 1 byte, chamado age, pra ser a idade dessa pessoa. E finalmente o terceiro elemento vai ser a altura ou height, que vai ser um inteiro de 8 bits também.









Essa estrutura define um tipo de dados novo, chamado Person, cujo tamanho total sempre vai ser de 12 bytes. Agora eu posso criar uma variável que vai ser esse tipo e o C vai preencher os valores que vamos passar na sequência correta na fita de bits. Se eu fizer `person.age` igual a 43, `person.height` igual a 172 e `person.name` igual a "Fabio", a cadeia de bits vai ficar exatamente assim em hexadecimal. Lembrando que cada dois dígitos em hexa representa 1 byte, começamos com o hexa quatro seis que é a letra "F", daí 0x61 que é "a" daí chega uma sequência de zeros porque "Fabio" tem menos de 10 bytes.


`46 61 62 69 6f 00 00 00 00 00 2B AC`




O penúltimo hexa 2B é a idade 43, e o último hexa AC é 172. A Struct meio que serve como um molde, que encaixa exatamente nessa sequência de bits e quebra os valores pra dentro dos campos que criamos. No caso de idade e altura, como são inteiros de 8 bits sem sinal, sabemos que podemos ter idades de zero até duzentos e cinquenta e cinco e alturas de no máximo duzentos e cinquenta e cinco centímetros, e tirando alguma raríssima exceção, tipo se você for mais alto que o Hulk, isso cobre qualquer pessoa do mundo. 








Única coisa nesse trecho de código que talvez deixe você confuso é porque podemos fazer `person.age` igual 43 mas não podemos fazer `person.name` igual "Fabio" e em vez disso eu usei a função que copia strings de duas posições da memória, que é essa `strcpy`. Só entenda que é assim que se faz em C, mas em outras linguagens como Javascript você faz do jeito mais simples de só usar "igual". Coisas desse tipo que linguagens de mais alto nível facilitam. É o que eu chamaria de ergonomia da linguagem.









Mas com o que eu expliquei até agora, você conhece os principais tipos numéricos primitivos como integers e floats, arrays e strings, e agora structs. Um Tuple é como se fosse um Struct anônimo, sem nomes e etiquetas, parecido com um array. Aliás, toda vez que você ver um Tuple num Python da vida, vai achar que é a mesma coisa que um array. Uma Tupla é um conjunto imutável com elementos de tipos diferentes, só isso. Um Array é um conjunto mutável de elementos do mesmo tipo. Pra extrair os elementos de uma tupla, você precisa de um molde que declara qual o tamanho de cada elemento, um molde que vai ser parecido com um Struct.








Estamos chegando no final, e agora com tudo que aprendemos, só falta mais um truque pra vocês começarem a entender melhor como os programas funcionam. Vocês meio que já devem ter entendido que funções nada mais são que sequências de instruções que ficam localizados em algum endereço na memória. A CPU vai executando “linha a linha” e quem dita qual linha é o tal contador de programas. Daí quando uma função chama outra, ela primeiro faz bookmark desse contador na stack, e dá JUMP pro endereço dessa outra função. 








Repetindo, é como se cada uma dessas linhas de código ficasse num endereço na memória. Estamos simulando como se fossem as linhas do código no editor de textos. Quando na função `main` lá embaixo eu chamo a função `f1`, e o compilador do C gera o binário, ele vai substituir por algo semelhante a um `jump` ou mesmo `goto` em linguagens mais antigas, pro endereço da linha da função `f1`.  No comentário é um pseudo-código de como seria se o C tivesse uma função chamada `jump`.






E isso é uma das razões de porque precisamos de compiladores. Ia ser chato pra caramba ter que ficar lembrando o endereço de cada função que precisamos. E aí a gente resolve mexer na função, muda de lugar, e isso muda o endereço, daí tem que mudar todo lugar que chama esse endereço na mão. Puta trampo. Em vez disso usamos nomes que representam esses endereços, como nomes de função e nomes de variáveis, e deixamos o compilador traduzir isso em endereços no binário final.








Isso é outro conceito importante: nomes de coisas não precisam existir no binário. Se a gente quiser podemos dizer pro compilador manter os símbolos pra debug. Símbolos são esses nomes. Os campos nome, idade e altura não existem no binário onde estão os valores. É só um linguição de bits e só. Linguagens de mais alto nível às vezes guardam esses símbolos por padrão. São metadados ou dados que explicam os dados, e metadados ocupam espaço. 







Mas como não são necessários pra rodar o programa e sim pra debugar depois, não é bom guardar tudo porque seria um desperdício de espaço. Se você já mexeu com coisas como XML ou JSON, eles são grandes e desperdiçam bastante espaço, primeiro porque representam tudo como strings e segundo porque levam os metadados de tudo junto com os dados. Mas isso é um detalhe que vou explorar em outro episódio. Aliás, é por isso que um Google inventou coisas como Protobufs, se você estiver interessado em mais um assunto pra estudar.









No caso do texto do código, nós declaramos símbolos, ou nomes pra endereços e cadeias de bits, pra facilitar a vida do programador de ler o código ou debugar depois, mas a máquina em si não se importa com nada disso. Pro computador é tudo uma cadeia de bits e só. O computador não dá a mínima pra como você chama as coisas ou o significado que dá pra elas. Um código é feito pra outros programadores entenderem. Computadores só entendem os binários sem nomes e sem significados. Entenda esse conceito.








A parte importante é que tudo tem endereços, não só variáveis mas funções também. Em particular, em C, podemos pegar a referência de uma função e passar como argumento pra outra função, da mesma forma como eu passei o endereço da variável `hello` pro `printf` imprimir na tela, lembra? Por exemplo, vamos reorganizar esse código de criar struct numa função nova chamada `createPerson` onde passamos como argumentos o nome, idade, altura e um último argumento que é um ponteiro pra uma função que não retorna nada, então `void` mas tem como argumento um struct de Person.





```
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <inttypes.h>

struct Person {
    char nome[10];
    uint8_t age;
    uint8_t height;
};

void createPerson(char name[],
  uint8_t age,
  uint8_t height,
  void(*function_pointer)(struct Person)) {
    struct Person person;
    strcpy(person.nome, "Fabio");
    person.age = 43;
    person.height = 172;

    (*function_pointer)(person);
  }

void printPerson(struct Person person) {
    printf("Person: %s %d %d\n",
        person.nome, person.age, person.height);
}

void printPerson2(struct Person person) {
    printf("nome: %s age: %d height: %d\n",
        person.nome, person.age, person.height);
}

void main() {
    createPerson("Fabio", 43, 172, &printPerson);
    createPerson("Fabio", 43, 172, &printPerson2);
    return;
}
```



Dentro dela fazemos igualzinho antes, onde declaramos a struct Person, preenchemos os campos mas no final executamos a função que veio nesse endereço chamado `function_pointer`. Entenda isso. a variável `function_pointer`, assim como aquela `hello2` vai ser só uma referência, um endereço pra alguma função que tem as características que declaramos, que retorna `void` ou seja, nada, e tem uma struct Person como argumento. Ao colocar um asterisco na frente dela, é como se estivéssemos dando copy e paste do nome da função de verdade aqui e executando ela.








A seguir vamos declarar a função pra passar pra esse `createPerson`. Vamos chamar de `printPerson`, que retorna `void` e recebe um `Person` de argumento e dentro é só um `printf` como fizemos antes. Mas note que diferente de antes, onde precisamos declarar acima as funções que vamos usar embaixo, estamos declarando o `printPerson` abaixo da função `createPerson` porque ela ainda não sabe que é essa função que vamos usar. 




Ela só sabe que vai receber uma referência que pode ser pra qualquer outra função. Se a `createPerson` chamasse direto a `printPerson` ela precisaria ter sido declarada antes. Mas vamos ver a seguir como eu passo a referência dessa função pra `createPerson`.








Na função `main` chamamos a `createPerson` passando os mesmos valores de antes, "Fabio", 43 e 172 e em seguida & comercial e `printPerson`. Aqui estamos pegando a referência, o endereço da função e passando como argumento. Quando compilamos e executamos vemos que a saída na tela é igual antes. 







Esse & comercial `printPerson` tá pegando o endereço onde a função tá declarada e passando como argumento pra `createPerson`. É só um integer que faz cast pra uma função. Cast é a ação de declarar que tipo esse número representa pro compilador do C saber o que fazer com ela. Mas só isso não tem graça, vamos declarar uma segunda função `printPerson2` pra ver como podemos passar uma referência diferente.







Lá em cima, fazemos uma cópia do `printPerson`, chamamos de `printPerson2` e vamos só mudar o jeito que o `printf` mostra os dados. De volta lá embaixo vamos chamar o `createPerson` de novo, mas passando a referência pra esse novo `printPerson2`. Depois de compilar e executar, veja que imprime essa nova versão também. 




A função `createPerson` aceita qualquer função compatível, que tenha a mesma assinatura, ou seja, o tipo de retorno e os tipos de argumentos que ele espera. Isso é o que chamamos de assinatura de uma função. Ela só recebe a referência pra função que estiver nesse endereço. Basta essa função ter a assinatura correta, ou seja, aceitar a struct de Person e retornar void, ou nada.








Isso de uma função ser passada como referência pra outra função é o que você já deve ter ouvido falar como um `callback`. É uma função que vai ser chamada "call" de volta "back". Qualquer um que tenha se interessado por programação funcional sabe que uma característica importante é ter funções que recebem outras funções como argumento. A função `createPerson` é o que em funcional o povo chama de "High Order Function". 







Quando em Javascript, Python ou Ruby você usa funções como `forEach`, `map`, `filter`, `reduce` e outros, eles recebem como argumento a referência pra outra função, normalmente uma função anônima, ou seja, que não tem nome e é declarada dentro dos parênteses de argumento. E com isso você entendeu o primeiro passo pra ter uma linguagem funcional.







Na teoria, sim, você poderia escrever código C do jeito “funcional”, mas ninguém faz isso porque não é prático. Mas com isso você pode imaginar como C poderia ser usado pra criar uma linguagem funcional como um Lisp da vida. É assim que a gente começa a manipular uma linguagem pra aceitar paradigmas que ela não foi projetada pra fazer. E com o que aprendemos até agora eu já posso mostrar mais um passo adiante.






Vamos entender o primeiro passo que leva C pra uma linguagem orientada a objetos como C++ ou Objective-C. O que eu vou mostrar a seguir não é a implementação da verdade, mas só um rascunho de como poderia ser. Quando eu penso em orientação a objetos só penso em duas coisas: um ponteiro pra uma struct e ponteiros pra funções cujo primeiro argumento, o que você aprendeu num Python ou Javascript como `self` ou `this`, sendo um ponteiro de volta pra mesma struct.








Vamos refatorar a `createPerson` primeiro. Até agora ela tá declarando a struct na stack e quando chama a `printPerson` tá duplicando por causa da passagem por valor. Em vez disso, vamos criar a struct no Heap e economizar espaço no stack fazendo passagem por referência. Pra isso precisamos usar `malloc` passando o tamanho da struct como parâmetro. E isso pra mim é o que significa `instanciar um objeto na memória`. Basicamente alocar espaço na heap pra uma struct. 







No caso de C, quando criamos qualquer coisa no Heap, precisamos colocar asterisco na frente da variável que guarda essa referência pra acessar o valor, mas no caso de struct em C basta trocar essa notação de "ponto" pra uma seta com tracinho e sinal de maior. Se você é de C++ ou PHP já viu essa notação e eu acho que ela deriva disso em C mesmo. Pra acessar os campos de uma struct de C que foi alocada na heap, sem precisar usar parênteses e ponto, basta usar a setinha, é a mesma coisa.







Agora vamos tirar o argumento de ponteiro de função do final do `createPerson`. Em vez disso, vamos mover pra struct de Person. Um novo campo que é um ponteiro de função chamado `show`. Dentro da `createPerson` declaramos que o campo `show` desse person que instanciamos no heap vai apontar pra referência da função `printPerson` que a gente já tinha. Finalmente, vamos mudar o tipo de retorno da função pra devolver o ponteiro dessa struct e no final podemos dar return do person que acabamos de criar e configurar.



```
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <inttypes.h>
#define Class struct

Class Person {
    char nome[10];
    uint8_t age;
    uint8_t height;
    void(*show)(Class Person *);
};

void person_print(Class Person *self) {
    printf("nome: %s age: %d height: %d\n",
        self->nome, self->age, self->height);
}

Class Person * newPerson(char name[],
  uint8_t age,
  uint8_t height) {
    Class Person *self =
      (Class Person *) malloc(sizeof(Class Person));
    strcpy(self->nome, "Fabio");
    self->age = 43;
    self->height = 172;

    self->show = &person_print;
    return self;
  }

void main() {
    Class Person *person2 = 
      (Class Person *) newPerson("Fabio", 43, 172);

    person2->show(person2);

    return;
}
```



Quem já programa orientado a objetos em alguma linguagem pode estar achando isso familiar. Eu chamaria essa função `createPerson` de “construtor”. Um constructor é uma função responsável por alocar espaço pra um objeto na memória Heap e configurar os valores iniciais desse objeto, retornando o endereço, ou referência, pra esse objeto.






Agora vamos usar isso na função `main`. Primeiro vamos armazenar o ponteiro que a `createPerson` vai criar numa variável que é um ponteiro, um asterisco person. E passamos os valores que queremos como argumento a esse construtor. E pra imprimir esses valores na tela podemos chamar direto o método deste “objeto”. E pra quem não sabe, “método” é o nome que damos a funções associadas a um objeto. O método `show` já foi configurado no construtor pra ser um ponteiro pra `printPerson`. 







A última refatoração que precisamos fazer é mudar a função `printPerson` pra usar essa variável `self` pra acessar os campos de nome, idade e altura. Se você é de Python, deve estar começando a se sentir em casa porque métodos de objetos de Python tem explicitamente o primeiro argumento recebendo `self`. E é o que estou simulando aqui em C. 






Em Javascript e outras linguagens orientadas a objetos, em vez de `self` chamamos de `this` mas é mais ou menos a mesma coisa, só que o primeiro argumento é implícito, você não precisa declarar ela. Mas faça de conta que a linguagem tá botando ela lá pra você. Então, só chamando `person` setinha `print` e passando `person` como o argumento `self` vai tudo funcionar. Qual seria um próximo passo pra ficar mais parecido com uma linguagem orientada a objetos?







Pra quem não sabe, em C tem uma coisa chamada `pré-processamento`, que é reescrever o código antes de compilar. Se você é de Javascript pense como um “transpiler”. Por exemplo, lá no topo do arquivo podemos declarar uma cerquilha `#DEFINE` e dizer que toda vez que achar escrito `Class` pode trocar pra `struct` antes de compilar. Onde tá `struct Person` podemos substituir como `Class Person`. Vamos lá usar a função de procurar e substituir do editor e boom. Olha só como de repente parece que estamos lidando com uma linguagem orientada a objetos de verdade. 








Se você aguentou até aqui, espero que tenha conseguido minimamente visualizar o que são os diferentes tipos de dados, as diferenças entre inteiros e floats, arrays,  tuples e structs. Como dados são alocados na stack que é a pilha e como a execução de um programa com funções que chamam outras funções vai sendo empilhado e desempilhado da stack. Como tudo tem endereços ou referências, incluindo funções. 






Algumas linguagens expõem referências a funções, mas não permitem manipular essas referências pra apontar pra outras regiões de memória. Javascript é assim. Um Java lá atrás só tinha referência a objetos, por isso a única forma de passar funções pra outras funções era primeiro encapsular numa classe anônima, instanciar e passar a referência do objeto como argumento pra outras funções. Por baixo dos panos é assim que as coisas funcionam.








Pra complementar, recomendo rever os vídeos sobre gerenciamento de memória. Quando fazemos programinhas simples, que alocam poucos dados e não tem nenhuma recursão maluca, o stack é mais que suficiente. E você não precisa lidar com o heap. O problema de alocar coisas no heap é que quando termina a função que fez a alocação, o ponteiro sai do stack, mas o que foi alocado no heap continua lá ocupando espaço se você não der `free` pra liberar explicitamente. Memória na heap não se desempilha sozinha. Por isso surge a necessidade de um garbage collector ou outros truques como o ARC de Swift pra limpar o heap.










Só que garbage collector não faz milagres. Ele sempre vai reservar mais memória do que realmente precisa e sempre vai causar pausas na execução do programa pra fazer essa limpeza de tempos em tempos. Mesmo se você tiver memória sobrando pra desperdiçar, essas pausas pra limpeza sempre vão ser um problema. E é o que linguagens como Swift ou Rust ou C tentam evitar. Por isso são melhores pra fazer coisas como sistemas operacionais, drivers ou coisas de mais baixo nível que vão ser eficientes no uso de recursos e evitar pausas de manutenção o máximo possível. O mesmo não se pode dizer de Java, C# ou Go.







Linguagens interpretadas como Javascript, Python, Ruby, PHP são extensões bem pesadas em cima de C. Elas adicionam diversas funcionalidades pra facilitar a programação, mas por baixo dos panos o que faz elas funcionarem mais rápido e mais eficiente são bibliotecas escritas em C. Uma biblioteca escrita só em Python ou Javascript nunca vai ser nem tão rápida nem tão eficiente. Por isso, funções como criptografia, funções de I/O pra lidar com arquivos ou pacotes de rede, funções matemáticas e tudo mais é tudo escrito em C. Eu chamo elas de linguagens "cola". 







Você só escreve a cola em Python, que é uma sintaxe mais simples, pra mexer com funções mais complicadas que estão escritas em C ou C++. Por exemplo, em machine learning, Python não é importante porque as funções de um Tensorflow são todas escritas em C++. Se você usar SciPy pra computação científica, de novo as funções são todas em C++ ou Fortran. Nenhuma linguagem cola é rápida o suficiente pra essas coisas. São boas como cola, pra consumir essas coisas mais fácil.








Se você mexe em machine learning em Python, você é só um consumidor de ferramentas escritas em C++ ou C e faz cola em Python. Não tem nenhum problema nisso, e na prática a maioria de vocês assistindo nunca vai precisar de mais que isso. Linguagens que são "cola" nunca vão ser boas pra fazer o que eu chamo de "sistemas". Coisas como drivers, criptografia, processamento massivo de dados como um banco de dados ou mesmo protocolos de rede eficientes.







Elas sempre vão ser só a cola pra sistemas feitos em C++ ou C. Por isso eu recomendo que você saiba no mínimo uma linguagem de mais baixo nível como C ou Rust. E junto uma linguagem cola pra ter produtividade como Javascript ou Python. Quem só sabe linguagens "cola" sempre vai achar que o que acontece no baixo nível é "mágica".







E com o episódio de hoje eu espero ter conseguido quebrar um pouco dessa "mágica" e fazer vocês enxergarem suas linguagens favoritas com outros olhos. Claro, tudo que eu falei rápido em um episódio é o que se ensina em no mínimo um semestre em ciências da computação, talvez um ano ou até mais. 





Eu só mencionei estruturas de dados simples, não falei de listas ligadas, árvores, red black, AVL e nem cheguei a falar dos algoritmos pra lidar com essas estruturas. Quem sabe em outro episódio no futuro, mas entenda que tudo que eu falei hoje é o básico em ciências da computação. 







Se você se considera programador e nunca viu nada do que expliquei hoje, considere estudar e treinar mais. Isso vai te ajudar a subir pro próximo nível na programação. Se ficaram com dúvidas mande nos comentários abaixo, inclusive se já sabem de tudo que eu disse aqui, ajudem a responder às dúvidas dos colegas nos comentários também. Não deixem de assinar o canal e clicar no sininho pra não perder os próximos episódios. Compartilhem o video pra ajudar o canal. A gente se vê, até mais!

Links: 

* Integer (Wikipedia) (https://en.wikipedia.org/wiki/Integer_(computer_science))
* Two’s Complement (Wikipedia) (https://en.wikipedia.org/wiki/Two%27s_complement)
* How numbers are encoded in JavaScript (https://2ality.com/2012/04/number-encoding.html#:~:text=JavaScript%20numbers%20are%20all%20floating,binary%20format%2C%20in%2064%20bits.)
* FLOATING POINT VISUALLY EXPLAINED (https://fabiensanglard.net/floating_point_visually_explained/)
* What Every Computer Scientist Should Know About Floating-Point Arithmetic (What Every Computer Scientist Should Know About Floating-Point Arithmetic (oracle.com))
* IEEE-754 Floating Point Converter (IEEE-754 Floating Point Converter (h-schmidt.net))
* Number.MAX_SAFE_INTEGER (Number.MAX_SAFE_INTEGER - JavaScript | MDN (mozilla.org))
* Signed Binary/Decimal Conversion Using the Two's Complement Representation (Signed Binary/Decimal Conversion (ubc.ca))
* C - Pointer arithmetic (C - Pointer arithmetic - Tutorialspoint)
* Why Discord is switching from Go to Rust (https://blog.discord.com/why-discord-is-switching-from-go-to-rust-a190bbca2b1f)


