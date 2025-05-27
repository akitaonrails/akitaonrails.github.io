---
title: "[Akitando] #80 - O Guia +Hardcore de Introdução à COMPUTAÇÃO"
date: '2020-06-04T09:44:00-03:00'
slug: akitando-80-o-guia-hardcore-de-introducao-a-computacao
tags:
- Nintendo
- nes
- '6502'
- assembly
- breadboard
- akitando
draft: false
---

{{< youtube id="8G80nuEyDN4" >}}

## DESCRIÇÃO

Errata:

* em 53:46 eu falo "1 1" mas era "aa"

Se tem um tema que eu queria fazer desde que abri o canal é apresentar algumas das fundações da computação, tanto do ponto de vista de história e da evolução, mas principalmente dos fundamentos básicos que eram vários 60 anos atrás e ainda são válidos até hoje.

O video de hoje vai abrir com um tema de videogames, mas vamos descer bem fundo no cérebro do Nintendinho pra criar um vocabulário que eu vou usar na Parte 2, quando de fato vou mexer num emulador de Nintendo. E esse vocabulário vai servir não só pra videos futuros meus como pra tudo que você for fazer em computação. Esta é a base, sem esta base tudo que você tentar aprender de avançado depois vai ser mais difícil.

Infelizmente é muito difícil empacotar estes temas de uma forma que não seja maçante. Espero ter conseguido pelo menos interessar vocês no assunto.


Canais:

* Ben Eater: https://www.youtube.com/user/eaterbc
* Retro Game Mechanics Explained: https://www.youtube.com/channel/UCwRq...


Playlist:

* Build a 65c02-based computer from scratch: https://www.youtube.com/watch?v=LnzuM...
* Building an 8-bit breadboard computer!: https://www.youtube.com/watch?v=Hyznr...


Links:

* Ben Eater “Build a 6502 Computer” Kit: https://eater.net/6502
* VASM A portable and retargetable assembler: http://sun.hasenbraten.de/vasm/


## SCRIPT

Olá pessoal, Fabio Akita


Se você está cético sobre este episódio porque não tem nenhum interesse por videogames, não se preocupe, a intenção de hoje é apresentar muitos dos conceitos fundamentais pra você entender melhor o que é programação. Este vai ser mais um daqueles episódios que você vai ficar se perguntando "mas onde diabos esse japonês quer chegar" mas com paciência as peças se encaixam. E já aviso que esse também vai ser um vídeo bem complexo. Pausa, volta e assiste de novo. Não é um conteúdo que dá pra entender 100% assistindo só uma vez.





Com tudo isso fora do caminho vamos lá. Quem me acompanha nos Instagram da vida sabe que um dos meus hobbies favoritos é jogar videogames. Além dos jogos Triple A eu também gosto bastante de voltar aos jogos da minha infância, de Alex Kidd a Sonic a Super Mario. Eu não faço coleção de cartuchos porque não teria espaço físico pra tudo. São milhares e milhares de jogos. Felizmente hoje é muito simples. Basta baixar uma das dezenas de emuladores e carregar a ROM dos games. Por exemplo, posso carregar este Retro Arch que tenho no meu desktop e boom, Super Mario.







A idéia deste video veio quando eu tava assistindo dois dos meus canais de YouTube favoritos. O primeiro é o Retro Game Mechanics Explained. O cara é muito bom. Por exemplo, pra quem gosta do Pokemon original de GameBoy, ele explica bit a bit o mistério do elusivo MISSINGNO, recomendo que assistam. Mas o video que eu tava assistindo me relembrou de outro dispositivo que existia durante os anos 90.






Muitos de nós gostamos de games só que mais como passatempo, e não somos tão obsessivos em completar 100% dos jogos ou fazer speedruns pra bater o recorde de quem acaba no menor tempo, e só porque um jogo é antigo não quer dizer que é fácil. Muitos tinham dificuldade maior e mais brutal que jogos da atualidade. Tentem jogar coisas como o Megaman original ou Battletoads do Nintendinho pra ver o que quero dizer. Fora que antigamente nem todo jogo tinha uma bateria pra salvar o progresso, então se dava game over você realmente tinha que recomeçar do zero.







Então surgiram dispositivos que possibilitavam "cheats". Quem joga online conhece essa palavra e os diversos software anti-cheat pra evitar que jogadores trapaceiem com hacks. Anti-cheats que vira e mexe criam polêmica, como no recente caso do jogo Valorant, cujo software anti-cheat foi acusado de causar até estragos de hardware.






Enfim, nos anos 90 a tecnologia era mais simples. Existiam diversas marcas diferentes como Action Replay, Game Shark ou o mais famoso, o Game Genie. Funcionava assim, você plugava o cartucho na parte de cima e daí plugava o conjunto no console. O Game Genie ficava entre o cartucho e o console. Ele engana o console. Por exemplo, o console pergunta pro cartucho, com quantas vidas que o Super Mario tem que começar? Daí tá gravado em algum lugar no cartucho o número 3, mas aí se você colocar um código mágico no Game Genie, como AATOZE, ele devolve 9 pro console no lugar de 3 e o jogo começa com 9 vidas.




Eu vou explicar o game genie em mais detalhes na Parte 2 deste video, de uma forma complementar que o Retro Game Mechanics explica. Mas antes de chegar nisso vou fazer uma longa tangente hoje com meu segundo canal favorito, o Ben Eater. O canal do Ben é hardcore, ele explica todas as fundações eletrônicas da computação, em particular exatamente a arquitetura por trás de computadores como o nintendinho. Eu vou usar muito material do canal dele e condensar num único video pra tentar fazer vocês finalmente enxergarem a mulher de vermelho no código do Matrix.




(intro)






O nintendinho roda o famoso processador MOS 6502 de 8-bits, derivado do desenho do Motorola 6800 e fabricado pela MOS Technologies a partir de 1975. Esse processador foi usado não só no nintendinho mas em dezenas de outros consoles e computadores pessoais dos anos 80 incluindo coisas como o lendário Apple II, o avô dos Macintosh, ou o concorrente Atari, e os britânicos Commodore e BBC Micro. Ele foi um dos componentes que ajudou a iniciar a revolução dos computadores pessoais dos anos 80. Exatamente por isso é um bom ponto de partida pra entender a computação de hoje em dia.








Apesar de internamente processar em 8-bits, ele possui uma interface de comunicação de 16-bits. 16-bits em hexadecimal, que são 2 bytes, se representa com 4 caracteres. Já um valor de 8-bits, ou 1 byte, se representa com dois caracteres. Como o código mágico AATOZE que falei tem 6 caracteres então já começa a ficar fácil de entender o que está acontecendo aqui. Muito provavelmente é um endereço de 16-bits e um valor de 8-bits, exatamente o que o 6502 entende. E de fato esse código se transforma no endereço 906A e no valor 09, que dá as 9 vidas ao Super Mario.







É importante que vocês entendam como enxergar binários e hexadecimais. Se você já sabe disso, pode pular pra este tempo aqui em baixo. De qualquer forma, tudo em computação é binário. Este vídeo que você tá assistindo é uma stream de bits. O jogo do Super Mario é um punhado de bits. Um arquivo de texto ou código em Javascript é um arquivo de bits. Muita gente acha que arquivos texto e binário são diferentes. Mas não, ambos são binários. A diferença é como você representa esse binário depois de abrir, pra mostrar pro usuário.






Deixa eu mostrar. Na maioria dos sistemas operacionais existem editores de texto, seja o miserável Notepad no Windows ou o moderno VS Code. Se eu abrir um arquivo que contém texto, qualquer um vai abrir sem nenhum problema. Mas se no mesmo editor eu tentar abrir o arquivo da ROM do Super Mario, vai aparecer esse monte de lixo na tela. Isso porque um editor de textos só sabe interpretar um sub-conjunto de binários que, por convensão, representa letras, números e símbolos.






Se eu abrir um editor e escrever a palavra "Hello World" e gravar, podemos abrir o binário cru com um visualizador de binário, como o comando `xxd -b` e pronto, isto é o que tá gravado no arquivo. Veja este primeiro bloco de 8 bits é a letra "H", vejam estes dois blocos repetidos, são os dois "L" e assim por diante. Claro que ler bit a bit assim é bem inconveniente, então podemos pedir pra ferramenta converter esses bits em uma representação hexadecimal, rodando o mesmo comando xxd sem o parâmetro -b temos os seguite.






Agora sim, aquele bloco de bits é o número 48 em hexadecimal, que não é a mesma coisa que 48 em decimal. Já vou explicar. Essa é a letra "H". Depois temos 6c e 6c que obviamente é o código hexadecimal pra letra "L". E assim por diante. Quem disse que 48 é H ou que 6c é L? É uma convenção internacional conhecida como Unicode. É um conjunto de tabelas e regras que mapeiam cada caracter em todas as línguas num código de 1 ou mais bytes. Emojis também, cada um tem seu código. Tudo é número. A tabela mais antiga e mais simples que ainda acabamos usando é a ASCII.









Pra quem não sabe, o que chamamos de "ROM" em retro gaming são os bits que vem gravados num cartucho e que extraimos pra dentro de um arquivo, é isso que um emulador de nintendinho lê no lugar do cartucho de verdade. Com o mesmo comando `xxd` mas passando com um pipe pro `more` pra podermos ver as primeiras linhas, temos o seguinte. Deixa eu explicar melhor o que é essa representação do comando xxd. Aliás, existem diversas ferramentas que conseguem abrir binários, um dos mais usados é o `hexdump` mas prefiro mostrar o xxd pra dar outra alternativa. A diferença dos dois é que o hexdump só mostra o binário na forma de hexadecimal, o xxd faz a mesma coisa mas consegue também gravar de volta pro binário. Por isso se somar o xxd com o vim você consegue editar qualquer binário diretamente.










Bom, a coluna da direita são os endereços, seguido de uma linha de 16-bytes organizados em grupos de 4 letras, cada um com 2 bytes, num total de 8 blocos de 4 letras. Cada 1 letra é um byte em hexadecimal. Você começa no endereço 0 e vai contando até 15 que é a letra F, dai na segunda linha o endereço começa em 16 que é o hexadecimal 10. Conta mais 16 elementos, agora chega no elemento 32 que em hexa é 20 e assim por diante.






Na 3a coluna ele mostra "." (ponto) quando o byte não tem representação em texto. Quando tem, ele mostra o que seria o código na tabela ASCII. Vocês vão notar que nos primeiros 3 bytes temos aparecendo o texto "NES" nessa terceira coluna. NES é como o Nintendinho é chamado nos Estados Unidos, o Nintendo Entertainment System. Obviamente não é coincidência, todo cartucho distribuídos nos Estados Unidos começa com esse código.







Isso é só uma etiqueta arbitrária pra facilitar identificar o que é esse binário. Muitos outros formatos de arquivo fazem a mesma coisa. Se eu abrir uma imagem formato PNG com o xxd olha só, aparece um código 89 e depois os códigos ASCII que forma a palavra PNG. Se abrirmos uma imagem JPEG todos começam com FF D8 FF E0 e alguns bytes pra direita aparece JFIF que é sigla pra JPEG File Interchange Format. Se listar um binário compilado com extensão .class de Java olha o que aparece. O identificador de todo binário Java é o hexadecimal que forma as palavras "cafe babe".







Se não ficou claro, o que estamos vendo na tela com o xxd não é o binário de verdade, assim como um editor de textos como Notepad mostra uma representação em forma de texto legível dos números binários reais, o xxd mostra os binários de uma forma que seja fácil da gente conseguir acompanhar. Essas colunas da esquerda e direita não existem. E não existe quebra de linha. Um binário são os bits escritos um atrás do outro numa única linha contínua até o fim. Pense num arquivo binário como um rolo de fita. Entendem agora porque você vê computadores antigos gravando dados num rolo de fita? Ou num cassette? É assim mesmo que funciona até hoje. Se você já programa em alguma coisa, pense num binariozão com um Array.







Existem vários sites e videos que ensinam em detalhes como converte e faz contas em binário e hexadecimal então vou resumir hiper resumido. Basicamente sistema decimal representamos números que vão de 0 a 9. Em hexadecimal representamos números indo de 0 a F, onde A é 10, B é 11, até F que é 15. Todas as regras aritméticas de soma, subtração etc funcionam igual. Quando você faz F + 1, coloca zero e sobe 1, daí o hexadecimal 1 0 equivale a 16. Sim, você precisa se acostumar a manipular números em hexadecimal. Até mesmo quando trabalha com front-end e CSS sabe que as cores são mapeadas em números hexadecimais e você faz conta com elas pra fazer degradê de cores por exemplo, você subtrai pra tornar todas as cores mais escuras ou faz soma pra elas ficarem mais claras.






Voltando pro cabeçalho do Java, o primeiro "C" não é a letra do alfabeto "C" e sim o número 12 em hexadecimal. Já brincaram com calculadora de cabeça pra baixo? Por exemplo, você digita 07734 e vira a calculadora e temos "HELLO" ou digitamos 376006 e de cabeça pra baixo temos Google. Todo mundo já brincou disso e o CAFE BABE do java é parecido só que como em hexadecimal temos de verdade as 6 primeiras letras do alfabeto, dá pra representar palavras. Mas é só uma brincadeira mesmo.







Agora, voltando ao binário. Computar em bits tem algumas vantagens pro computador fazer alguns tipos de conta. Em particular multiplicar por 2 e dividir por 2. Pegue o número 4 que em 4-bits seria 0 1 0 0. Se eu mover 1 pra esquerda vira 1 0 0 0 que é 8. E pra dividir? Oposto, só mover tudo pra direita então o 4 que é 0 1 0 0 vira 0 0 1 0 que é 2. Estou simplificando, claro, porque se dividir um número ímpar, eu não vou ter o resto assim. Aliás, isso que eu falei de mover pra esquerda ou direita é o que se chama de operador bitwise em qualquer linguagem moderna, o shift left que é << e shift right que é >>.






Se abrir qualquer navegador e inspecionar um elemento, você abre o tal console de Javascript. E aqui podemos exercitar o que eu acabei de falar. Por exemplo, se eu quiser representar um número em binário começo digitando 0b daí por exemplo 0 1 0 0 que é 4. E é exatamente isso que ele mostra. Vou criar um texto chamado "palavra" e dentro colocar "hello world" que tem 11 letras. Se eu quiser pegar a décima primeira letra dessa palavra posso fazer `palavra[10]` e 10 porque em programação tudo começa de 0. Então 0 é 'h', 1 é 'e' etc e a posição 10 é a letra "d".






Podemos chegar na mesma letra se fizermos `palavra[0x0A]` lembram que eu falei que A em hexa é 10? Pro Javascript saber que isso na verdade é um número colocamos 0 x antes. Pra ficar mais hardcore podemos fazer `palavra[0b1010]` e esse 0 b é pro Javascript saber que é um número binário. Tanto o 0xA quanto 0b1010 são formas diferentes de escrever o mesmo número 10. É tudo o mesmo número, só que podemos representar de formas diferentes. Internamente sempre é tudo um número binário. As linguagens de programação só facilitam e nos deixam usar números em decimal ou mesmo letras.






Se eu fizer 10 shift right 1 é divisão por 2, e eu posso fazer `palavra[0xA >> 1]` onde A é 10 em hexa, shift right 1 que é divisão por 2 e ele devolve espaço que é o que tem na posição 5 naquele hello world.






Entendido isso, vamos pular pra outro conceito. Todo mundo ouve falar sobre computadores 32 bits ou 64 bits. Se você pensar em base decimal dá impressão que estamos só dobrando de 32 pra 64. O que isso significa? Em resumo significa que internamente o computador consegue fazer cálculos e processar números de 32 ou 64 bits de comprimento de uma só vez. Até agora eu fiz exemplos com números de 4 bits que dá pra contar só até 255. Lembra que eu falei que cada 1 bit que eu adiciono pra esquerda eu estou multiplicando o número todo por 2? Então 5 bits já é o dobro de 4 bits. 6 bits é o dobro de 5 bits. 33 é o dobro de 32 bits e 64 é 32 bits ao quadrado. A metade de 64-bits não é 32 e sim 63-bits.









Em 32 bits podemos representar até quase 4.3 bilhões. Em 64-bits podemos representar um número gigante 1.8 x 10 elevado a 19, ou seja, um numerozão de 19 casas. É a casa dos quintilhões. Entendam essas relações de dimensão. A vantagem de usar hexadecimal é que esse numerozão de 64-bits pode ser representado por 16 caracteres. Mesmo que você ainda esteja coçando a cabeça neste ponto, veja que não é coincidência que o numerozão de quintilhões de 64-bits fica bonitinho tudo com FFFFF... em hexa. Isso porque propositalmente usamos números derivados da base 2. Por isso um megabyte não é 1000 bytes e sim 1024 bytes. Em hexa seria 4 0 0. Tendemos sempre a usar números que são redondos em hexadecimal.









De qualquer forma 64-bits é um número difícil de visualizar na cabeça. Não se preocupe, eu acho que até o final do video vocês vão começar a se acostumar com isso. Mas eu acho que a forma mais fácil de entender como as coisas funcionam hoje é ver como funcionava ontem, porque o que temos hoje são mais ou menos camadas extras em cima da mesma base de antigamente. Componentes mais modernos, métodos de fabricação melhores, mas a fundação ainda é exatamente a mesma. Por isso quero voltar pros anos 70, mais especificamente pra 1975 e olhar mais de perto o cérebro do nosso nintendinho.








Se abrirmos o nintendinho, esta é a placa mãe com os diferentes chips. Mas por agora vamos nos focar neste aqui, o MOS 6502 que eu falei antes. Se eu quisesse mostrar o nível zero de verdade da fundação, precisaria começar com o básico em eletrônica. Mas eu também só sei o básico. É o que você aprenderia em Engenharia Elétrica ou Engenharia da Computação e não em Ciências. Mas eu quero resumir pelo menos, e pra isso resolvi pegar emprestado material de outro dos meus canais favoritos, do Ben Eater, que eu falei no começo do video.








Uma das playlists dele mostra como você constrói um processador de 8-bits do zero. E outra playlist dele, por acaso é como fazer um hello world com o 6502, o mesmo CPU do nintendinho. Só pra mostrar um Hello World ele levou meses produzindo uns 9 videos com mais de mais hora cada. São horas de video e eu vou resumir tudo em alguns minutos, então depois eu recomendo assistirem os videos dele com calma. Como eu disse daria pra descer no nível da física elétrica mas eu acho que a partir do nível que eu vou mostrar neste video é o mínimo suficiente pra se ter um desenho na cabeça pra conseguir visualizar o que um programa de fato está fazendo no hardware. Eu acho muito mais difícil aprender a programar sem entender o que acontece por baixo.







Quem está iniciando em eletrônica hoje em dia tem bastante material da hora pra treinar. Uma dessas ferramentas se chama breadboard, que é uma placa feita pra montar protótipos de circuitos eletrônicos sem precisar ficar soldando os componentes, você só encaixa os chips e fios na placa, liga a força, normalmente de 5V e pronto. Fazer circuitos integrados é literalmente programação de baixo nível. Ele inclusive vende kits com todos os componentes que você vai ver. Se tiver como investir, recomendo como bom aprendizado. É como se fosse brincar de Lego, mas bem mais interessante.






A lógica por trás de linguagens de programação modernas seguem os mesmos princípios da lógica em nível de hardware. Se você já ouviu falar isso de "ter que saber lógica pra programar" mas nunca entendeu onde começar, comece entendendo portas lógicas e máquinas de estado.



https://www.youtube.com/watch?v=LnzuMJLZRdU (part 1)




Pra começar veja o diagrama do 6502. Todo chip tem essas perninhas ou pinos, nelas, você liga ou desliga corrente em alguns pinos pra se comunicar com o chip, e os traços recebem corrente quando o chip quer enviar dados. Numa placa de verdade com solda e tudo, o que liga um pino de um chip a outro são traços condutores. Num breadboard se usa fios de metal mesmo pra facilitar. Agora vamos ver o diagrama de pinos, e a primeira coisa que quero chamar a atenção são esses pinos que vão de A0 até A15 e os pinos que vão de D0 até D7. Não é coincidência que são 16 pinos A e 8 pinos D.








Eu disse que o 6502 é um processador de 8-bits então quando você quer ler o resultado de algum processamento que ele fez, serão valores de 8 bits de comprimento, e eles vão trafegar por esses pinos D0 até D7. E quando o processador quer enviar um endereço pra buscar na memória RAM por exemplo, ele pode mandar um número de até 16-bits, que trafega por esses pinos de A0 até A15. Digamos que eu quero mandar o número em hexa `a9` pelos pinos de dados. Em binário seria 1 0 1 0 1 0 0 1, e cada um desses bits vai em um pino de D9 a D0.








Cada componente que coloca no Breadboard sempre vai ligar um pino de força e outro pino em ground ou Terra, é como você passa energia pro componente. Daí ele vai ligar outros pinos, por exemplo pra habilitar a CPU, outro pra conectar no clock. Um clock é exatamente o que o nome diz, é um componente com um cristal de quartzo que oscila, enviando um sinal elétrico numa frequência precisa e constante. Todo componente que processa alguma coisa no computador precisa estar ligado no mesmo clock pra tudo funcionar sincronizado. Um computador é uma grande orquestra de componentes e o clock é o maestro. Muitas instruções do CPU demoram mais de um clock, mas tudo é alinhado de acordo com a frequência desse clock. A menor unidade de processamento num computador é esse pulso que eu vou ficar chamando de clock durante o video.








Um clock de sistema convencional é pequeno como esse de 1 megahertz, ou 1 milhão de pulsos por segundo, que o Ben está mostrando, mas ele vai usar um mais feinho que ele mesmo construiu em outro video. A vantagem é operar mais devagar e dar a opção de poder pausar o clock e manualmente soltar um pulso de cada vez. todo componente do computador, incluindo a CPU, vai pausar junto e rodar um ciclo de clock de cada vez. Um processador 6502 original não suportava uma pausa dessas, mas esse que ele está usando é uma versão mais moderna que é fabricado até hoje e tem mais funcionalidades.






Continuando ele precisa ligar o pino que indica pro CPU rodar que é o RDY ou ready, depois o pino que liga com um botão de reset que é o RESB, daí liga o pino de clock e ligamos a placa do clock com força e terra na placa principal.





Só de fazer isso e ligando a placa principal numa tomada de 5V a CPU já tá funcionando e fazendo alguma coisa. Uma forma simples de monitorar pinos de dados é ligar LEDs direto em cada um deles, por exemplo ligando os pinos A0 a A4 em 5 LEDs pra gente ver se tem alguma coisa acontecendo. E de fato tem alguma coisa, mas bem aleatório.





Pra monitorar melhor, o Ben montou um sistema de monitoramento com Arduino em outro video e vai usar aqui. Um Arduino é um microcontrolador que tem algumas dezenas de pinos que servem tanto como entrada de dados ou saída. Então ele vai ligar primeiro os pinos de A0 a 15 da CPU com os pinos 22 a 52 no Arduino. O Arduino é programável, e podemos escrever programinhas simples e enviar pra ele executar. E é isso que o Ben vai fazer. Não se preocupe se você nunca viu um programa de Arduino, o código dessa demonstração é hiper simples, só prestar atenção que dá pra entender sem nenhum problema.






Primeiro vamos declarar uma lista com quais pinos do Arduino vamos trabalhar, e vai ser de 22 a 52.
Daí fazemos um loop lendo número a número e mandando um comando pra dizer que vamos ouvir o que vier nesse pino, ou seja, eles são INPUT
Agora fazemos outro loop pela mesma lista pra ir lendo o que vem em cada pino. Essa função devolve true ou false então quando vier true devolvemos o número 1 e quando vier false devolvemos 0 e escrevemos na tela
Daí escrevemos uma quebra de linha com print line e repete tudo de novo.
Finalmente não podemos esquecer de declarar a velocidade que vamos trafegar dados que vai se 57600 bauds, não se preocupe com esse número mágico.








Transmitimos o programa pro Arduino via essa interface, e abrimos o Monitorador de Sistema pra ver o resultado desse programa rodando. E vemos um monte de números binários, 16 bits no total que é o número de pinos que estamos monitorando. Entenda o que está acontecendo, o CPU está processando alguma coisa e setando bits nos pinos de endereço. Esses pinos estão ligados no Arduino que está lendo esses bits. Daí estamos num loop infinito puxando esses bits constantemente e imprimindo na tela. Mas não estamos ligados ao clock então ele vai ficar que nem doido lendo e imprimindo sem parar, sem qualquer ordem. Pra melhorar podemos sincronizar o Arduino ao mesmo clock também.





Eis um exemplo de porque os componentes precisam estar sincronizados com o clock. O Arduino não sabe quando ele precisa ler dos pinos, então fica lendo que nem doido e não faz sentido nenhum. Ligando ao clock, ele vai ler só uma vez a cada pulso. Entao em vez de fazer um loop infinito vamos ligar o código de leitura ao evento de um pulso do clock. Assim, se pausarmos o clock o programa também vai pausar, porque nenhum evento vai ativar o código de leitura.






Podemos ligar o clock em qualquer lugar, mas o Ben decidiu ligar no pino 2 do Arduino e com isso também precisamos configurar o pino 2 como entrada, pra ler o pulso que vier de lá.





A forma de ligar um evento no Arduino é criando uma interrupção pro clock. Quando o clock pulsa e enviar um sinal elétrico no pino 2, isso vai interromper o sistema e chamar essa função onClock que estamos definindo. Se você já programou front-end ou javascript já viu o mesmo conceito que é orientação a eventos. O conceito existe desde a invenção dos computadores, só pra saber.



Agora movemos o código do loop de leitura pra dentro do evento onClock.

Aproveitamos pra declarar também os pinos de 39 a 53 onde vamos ligar os pinos de dados D0 a D7 do CPU, pra poder monitorar o que acontece lá também.


Agora copiamos o mesmo código que lê dos pinos de endereço da CPU pra ler os pinos de dados da CPU, é o mesmo loop, só muda os números dos pinos.


Também copiamos o mesmo código de inicialização pra configurar os pinos 39 a 53 como INPUT pro Arduino receber bits.


E copiamos o mesmo código no evento de onClock pra ler os pinos de dados e imprimir na tela. Só que ficar mostrando os 24 bits de zeros e uns dos pinos não ajuda muito pra saber o que tá acontecendo. Mesmo gente experiente não consegue ler um monte de blocos de bits e entender exatamente o que tá rolando.



Então vamos converter de bits pra hexadecimal e imprimir do lado. Pra fazer isso inicializamos uma variável com número 0, dai pra cada pino que lemos nesse `for`, damos um shift pra esquerda e adicionamos o novo bit no final, faz shift pra esquerda, adiciona no final, faz shift e adiciona, e é assim que se monta um número lendo do binário.



Fazemos a mesma coisa com os pinos de dados.



Agora vamos usar uma função que é comum em quase todas as linguagens que serve pra formatar números em strings. Queremos formatar o número em uma string hexadecimal de 4 bytes pra representar o endereço de 16-bits, e como 2 bytes o valor de dados.




Os pinos de dados podem tanto receber dados quanto enviar dados e pra isso serve esse outro pino do lado, pra dizer qual o modo, se é read ou write. Então ligamos ele no pino 3 do arduino pra sabermos se o CPU está querendo ler ou escrever.




Como fizemos com os outros pinos, declaramos no codigo como 3 que é onde vamos ligar o pino RW do CPU. Dizemos ao Arduino pra ler desse pino, ou seja, input. Quando ler do pino, se devolver true escrevemos "r" pra leitura, se devolver false, escrevemos 'W' pra indicar write.




Pronto, agora iniciamos o clock. No monitor podemos ver que o CPU tá cuspindo alguma coisa nos pinos de endereço e de dados mas tá difícil de entender o que tá acontecendo. Isso porque não tem nada enviando dados ao CPU, daí quando ele tenta ler alguma coisa dos pinos de dados vem lixo, e tenta rodar esse lixo e fica soltando lixo, por isso parece aleatório.





Agora que temos o CPU ligado e monitorado, vamos enviar o primeiro dado de verdade pra ele. Lembrem-se, enviar ou receber dados é literalmente aumentar ou diminuir voltagem nos pinos. Envie 5 volts no pino D0 e o CPU vai ler o bit 1 do pino D0, corte a voltagem do pino D1 e o CPU vai interpretar como 0 no pino D1. Então se quisermos mandar um valor constante nos pinos de dados, podemos ligar resistores. Se quisermos o bit 0 ligamos o resistor no terra, se quisermos o bit 1 ligamos o resistor nos 5 volts da placa. E com isso configuramos o binário 1 1 1 0 1 0 1 0.





Voltando ao monitor, resetamos e veja que na última coluna vem `ea` que é o hexadecimal do binário que acabamos de configurar. Como não mandamos o CPU gravar, o pino de Read/Write tá só Read, e note como nos pinos de endereço, a cada clock ele vai incrementando o endereço. Vamos ver com mais calma passo a passo.





Esse clock simples do Ben tem a opção de pausar e manualmente soltar um pulso de clock de cada vez clicando num botão. Segundo o manual do processador os primeiros 7 clocks é uma rotina de inicialização do CPU então podemos ignorar.






Logo em seguida o contador de programa carrega o vetor de reset dos endereços FFFC e FFFD. Como o único dado que conectado é o 0xEA dos resistores, ele vai ler o endereço 0xEA e 0xEA e montar o endereço 0xEAEA que é pra onde o CPU vai procurar a primeira instrução do programa pra executar.





Ele vai colocar 0xEAEA nos pinos de endereço e a única resposta que  vai ter continua sendo 0xEA, de novo porque é o único dado fixo nos pinos de dados. O Ben escolheu 0xEA de propósito porque é um opcode válido do 6502, se olharmos qualquer documentação dessa CPU vamos descobrir que é o opcode NOP ou No operation, que é literalmente um comando que não faz nada por 2 ciclos.






Quando o primeiro NOP terminar, o contador de programa aponta pro próximo endereço que é 0xEAEB e de novo, nos pinos de dados só vai ler só 0xEA. Daí o CPU executa NOP e o contador de programa agora vai pra OxEAEC e assim por diante infinitamente.







Até aqui você acabou de aprender alguns dos principais elementos que tem em qualquer CPU. Primeiro que ele tem pinos pra enviar endereços, segundo que ele tem pinos pra enviar e receber dados, que ele tem um contador de programa que aponta pra endereço da próxima instrução do programa. Terceiro que instruções e dados são tudo binário, e que não existe diferença entre um byte de dados e um byte de instrução.



Mas só deixar um valor fixo com resistores não é muito interessante. Pra ficar melhor, precisamos de alguma coisa que consiga enviar uma sequência maior de bytes, formando um programa.



https://www.youtube.com/watch?v=yl8vPW5hydQ (part 2)




Pra isso o Ben escolheu uma EEPROM do mesmo fabricante desse clone de 6502 que estamos usando, pra facilitar. Vale explicar o que é isso. RAM acho que todo mundo tem noção do que é, o que chamamos de memória. Podemos escrever e ler dados da memória e quando o computador desliga o que está na RAM apaga. Daí temos ROM que é sigla de Read only memory, ou seja é uma memória que só dá pra ler o que tem dentro e não é possível sobrescrever nem apagar.





Só pra ter um modelo simplificado na cabeça, pense na ROM como se fosse uma grade. Pense em cada linha dessa grade como um endereço, de 0 até X. E digamos que cada linha dessa grade tenha 8 cruzamentos. Quando um cruzamento está aberto, podemos dizer que é o bit 1, quando um cruzamento estiver queimado, pense queimado mesmo, ou seja que não tem como recuperar e mudar o bit. Podemos dizer que é o bit 0. O conteúdo de uma ROM é fixo, não tem como regravar. Você só consegue enviar endereços e ler o que estiver nesses endereços.






Agora, EEPROM é um circuito mais complicado. Quando ligamos num computador ele simula uma ROM, ou seja passe um endereço e ele devolve um dado. Porém, usando um gravador especial, ele permite que a gente escreva nela. Na prática uma evolução desse EEPROM são chips de memória flash usados em pendrives ou SSDs por exemplo. EEPROM é sigla pra Electronically-erasable programmable ROM. Nos anos 90 eu usava EEPROMs pra gravar um boot em computadores da rede da faculdade pra bootarem dessa ROM e se conectarem na rede pra baixar o sistema operacional de verdade. Dá pra usar EEPROMs pra muita coisa. Seria como bootar de um pendrive hoje mas a vantagem na época é que era difícil de pular esse boot obrigatório.







Diferente de RAM, mesmo quando desligarmos a força, o conteúdo não vai se apagar, igual um pendrive. Tanto nos videos do Ben quanto aqui vamos ficar toda hora chamando isso de ROM porque é mais curto, mas lembre-se que é uma EEPROM. E no caso é um modelo até grandinho, de 32 kilobytes.







Se olhar o diagrama vemos que a pinagem é muito simples, ele tem pinos de IO0 a IO7 pra devolver dados e pinos de A0 a A14 pra receber endereços. E porque vai só até A14 e não até A15. Porque ele só tem 32 kbytes que é metade de 64 kbytes. Com 16-bits conseguimos contar de 0 até 64kbytes, com 15-bits, que é metade conseguimos mapear os 32 kbytes que tem nessa ROM, por isso não precisa de mais 1 bit. Tão começando a se acostumar com essa história de bits? Basta associar bit com um pino num chip desses.








Repetindo, com 16-bits podemos mapear de 0x0000 até 0xFFFF.
Prestem atenção no comprimento dessas palavras. Cada dígito representa 4-bits. Cada 2 dígitos é um byte. 16-bits é a mesma coisa que 2 bytes, por isso 4 dígitos. Metade de 16-bits é só 1 bit a menos, o que nos dá os endereços de 0x0000 até 0x7FFF.
Se o CPU tentar mandar um endereço de 0x8000 pra cima, o primeiro bit é ignorado e o restante é igual à primeira metade, então ele devolve a mesma coisa que devolveria com o endereço de primeiro bit 0. Por exemplo, se ele pedir o endereço 0x8004 é a mesma coisa que pedir o endereço 0x0004.









Note outra vantagem de usarmos hexadecimais. Como eu sei exatamente qual é o numero do meio entre 0 e 65353?
Eu disse que pra dividir um numero por dois é só fazer shift pra direita, daí 1111, por exemplo, vira 0111. E esse é o numero do meio. E em hexa? qual a metade de F? É 7 porque F é 15, então metade de FFFF é 7FFF. Que é até onde vai o endereço nessa ROM. Tão vendo porque usamos hexa? Com decimal não é intuitivo de trabalhar. Aliás, em decimal, 7FFF em hexa seria 32767.







Como o CPU consegue entender qualquer endereço entre 0x0000 e 0xFFFF não queremos que a ROM responda em todos. Aqui é uma decisão de engenharia, mas pra manter a lógica simples, podemos escolher fazer a ROM responder à primeira metade dos endereços ou à segunda metade. E o Ben resolveu fazer responder à segunda metade, ou seja, quando o primeiro bit do endereço for "1". Isso porque já vimos que o CPU procura logo de cara nos endereços FFFC e FFFD que ficam na segunda metade dos endereços, logo é mais conveniente mapear direto pra lá.







Pra fazer isso funcionar queremos responder somente a endereços que comecem com primeiro bit sendo "1", ou seja, quando o pino A15 por "1". Aliás, se vocês não perceberam a ordem dos bits é o inverso da numeração dos pinos, acostumem-se com isso. Além disso, pra ROM ficar habilitado ele precisa receber baixa voltagem no pino de chip enable ou CE. É como um botão de liga e desliga da ROM, pra ele responder precisa estar habilitado também.







Isso é simples, colocamos um inversor entre o A15 e CE assim quando A15 estiver em alta voltagem, ou seja, representando o bit 1 - porque queremos todos os endereços que começam bom 1 -, o inversor vai reverter e enviar baixa voltagem, ou 0, pro CE que vai habilitar a ROM. O resto dos pinos podemos ligar direto da CPU pra ROM um pra um, A14 da CPU pra A14 da ROM, D0 da CPU pro IO0 da ROM e assim por diante.






Coisas como esse inversor que mencionei pode ser montado com uma porta lógica chamada NAND. Eu mencionei portas lógicas no começo do episódio de Supremacia Quântica, mas o canal do Ben tem videos detalhados explicando como transistores funcionam e como podemos montar portas lógicas como NAND num breadboard também. Pro protótipo de hoje ele usa um chip pré-pronto com portas NAND embutidas. Mas entenda que todos os chips que você estão vendo são montados com transistores. Imagine transistores como peças de lego e chips como sendo um conjunto de transistores conectados.






Como falei antes, é com a relação de como montamos circuitos com transistores que nasce a base da tal "lógica". Como conectamos portas pra chegar no resultado que precisamos. Neste exemplo simples, queremos uma resposta sempre que o pino A15 estiver em alta, com bit 1. Mas a ROM precisa do pino CS em baixa, ou bit 0 pra ativar. Portanto, colocamos alguma coisa que inverte o sinal entre elas, um inversor ou porta NAND, e assim vamos completando o quebra cabeça.






Com a ROM conectada e pronta precisamos carregar algum programa nela. Pra isso o Ben vai usar Python pra criar um arquivo binário. Poderíamos usar o próprio `xxd` pra escrever na mão. Mas qualquer linguagem de programação também consegue fazer a mesma coisa, use o que você achar mais fácil, mas vamos seguir no código dele que é simples de entender.





Relembrando que antes a CPU recebia somente o valor fixo dos registradores, o  hexadecimal 0xEA que é a instrução ou opcode NOP. Vamos gerar um binário que devolve exatamente a mesma coisa.






Primeiro declaramos uma variavel que vai ser um array de bytes. O conteúdo vai ser 0xEA 32 mil 768 vezes que é o total de bytes que dá exatamente 32 kilobytes.



Agora vamos abrir um arquivo pra escrever em modo binário. Com o arquivo aberto, escrevemos o array de bytes direto e isso vai gerar o arquivo "rom.bin"



Se fizermos um hexdump podemos ver que só tem 0xEA. Quando tem um asterisco é a ferramenta `hexdump` querendo dizer que o mesmo conteúdo se repete até o fim, que é o endereço 7FFF, o último em 32 kilobytes.



Lembrando que a CPU vai pedir endereços a partir de 0x8000 mas como a ROM não recebe o primeiro bit, só recebe os 15-bits restantes do endereço, então o endereço 0x8000 vira automaticamente endereço 0, como já expliquei.



Agora podemos pegar o arquivo binário e usar o programa `minipro` que envia os bits pro gravador de EEPROM. Isso é só um detalhe relevante se você for usar um gravador de EEPROM como na demonstração do Ben, mas é assim que se grava, se você tinha curiosidade.



Finalmente colocamos a EEPROM de volta na placa. E ligamos o Arduino de novo pra monitorar.


Podemos usar o mesmo script do Arduino de antes e ligar o Monitor e como esperado tá recebendo só 0xEA.


Pra ver passo a passo damos um reset e pausamos o clock. Agora podemos ir passo a passo. Os primeiros 7 clocks é a inicialização do CPU, depois disso ele lê dos endereços fffc e fffd e lê 0xea como antes. E com isso ele pula pro endereço 0xeaea e continua lendo só 0xea. Até aqui replicamos exatamente o que os registradores estáticos faziam. Vamos fazer algo um pouco mais útil.




Voltamos pro programa em python e depois de ter o array de bytes com 0xea, acessamos a posição 0x7ffc e colocamos o valor 0 e na posição 0x7ffd colocamos o valor 0x80. Duas coisas, lembram na explicação de binário que eu mostrei exemplos de Javascript, que expliquei que podemos acessar posições num array tanto com números decimais quanto com números direto em binário? Escrever 0x7ffc é a mesma coisa que escrever 32764.





E repetindo, por que 0x7fffc e não 0xfffc que é o que o CPU vai procurar? Porque a CPU vai mandar o endereço 0xFFFC pra ROM, mas o primeiro bit é ignorado? Lembra como o endereço 0x8000 vira 0x0000? Então é só fazer 0xFFFC - 0x8000 e voilá temos 0x7FFC. Não entendeu? 0xF em hexa é 15, subtrai 8 e temos 7.




Agora uma coisa que eu deixei pra explicar só agora. O CPU vai pedir o valor do endereço 0xFFFC e vai encontrar 0x00 e daí vai pedir 0xFFFD e vai encontrar 0x80 e esses dois valores vão formar o endereço 0x8000. Essa forma de ordenar os bytes "ao contrário" se chama Little endianess. Outros processadores como um Intel ou AMD ou mesmo os ARM de celulares também são little endian. O processador IBM PowerPC dos Macs anteriores a 2006 eram Big Endian, então os bytes iam aparecer na ordem natural que nós humanos lemos. Mesmo os processadores ARM de hoje são bi-endian, quer dizer que ele suporta ambos mas a maioria é usado como little endian.






Parece meio estranho, porque eu ia querer ler números de mais de um byte em ordem reversa? Na realidade parece estranho porque a gente lê da esquerda pra direita, mas quando implementamos em hardware é mais simples ler da direita pra esquerda, requer menos ciclos pra fazer contas. Sem entrar em detalhes do hardware vamos dar um exemplo onde a ordem natural pode não facilitar nossa vida. Imagine datas no formato brasileiro com dia, mês e ano. Mande um computador ordenar. Podemos usar o comando `sort` que tem em todo linux. Porém coloque as mesmas datas agora em formato japonês, que é ano, mês e dia e tente ordenar da mesma forma. E veja só, só de mudarmos a ordem dos elementos das mesmas datas, a ordenação funcionou muito mais fácil.






Aliás isso é um insight que todo programador precisa ter. Boa parte do que é programação é retrabalhar os dados pra ficar mais fácil de computar o que queremos. Little endian no nível do processador é algo parecido na hora de fazer contas. Pra agora só assuma que quando você vê dois bytes que representam endereço de 16-bits, eles vão estar invertidos e 0x0080 vai ser 0x8000.


01012000
01031998
02071999
03042003
05052005


20030403
19980301
19990702
20050505
20000101



Uma vez eu justamente precisei fazer um pequeno protocolo de rede binário pra trafegar dados entre computadores Intel e PowerPC. Acho que eu estava usando um Macbook G4 antigo. E eu recebia lixo no lado do Intel. Até que me dei conta "puts, PowerPC é Big Endian", daí eu inverti os bytes no meu protocolo antes de mandar e do lado do Intel passou a receber direitinho. Você não vê isso porque se o único protocolo que já usou foi HTTP na camada de baixo no nível do TCP ele se vira pra reverter os bytes se trafegar entre processadores com endianess diferentes. Se você já usou algo como Google Protobufs, a biblioteca se encarrega de converter se precisar.






Isso tudo explicado, vamos fazer um programinha agora. Lembrando, um CPU tem registradores e pode guardar dados de 8-bits, ou 1 byte neles. Pense em registradores como se fossem variáveis globais numa linguagem de programação qualquer. Elas vão ser uma ordem de grandeza mais rápidas de acessar do que se tiver que sair do CPU e pedir memória pra um chip de RAM por exemplo. Registradores que podemos usar no 6502 incluem o A, X, Y e outros. Cada registrador vai ter um comando de LOAD pra jogar um valor nele e um comando de STORE pra tirar o valor do registrador e jogar em algum outro lugar na memória, se tiver RAM por exemplo.





Vamos só fazer um LOAD em A que é o opcode LDA. Assim como em linguagens modernas existe o conceito de polimorfismo, ou seja, a mesma função responder pra argumentos diferentes, no nível de máquina o mesmo comando LDA na verdade é representado por diferentes hexadecimais pra cada variação de argumentos. Por exemplo existe a instrução 0xAD, mas a versão que queremos é a que aceita só um valor simples e não um endereço de memória como argumento, então o hexadecimal da instrução LDA queremos é o 0xA9.






De volta ao python se acessarmos o primeiro valor do array, posição 0x00, colocamos o valor 0xA9 que é o comando LDA e na sequência colocamos o argumento dessa instrução que pode ser qualquer valor de 1 byte, aqui colocamos 0x42 arbitrariamente. A instrução completa são esses dois bytes. Dependendo da instrução pode ter mais argumentos, usando mais bytes na sequência. O CPU sabe quantos bytes cada instrução precisa. Tudo tem tamanho fixo em bytes na CPU, e assim ele sabe qual byte é uma instrução e quais bytes são dados.




Como agora temos um valor no registrador A podemos fazer alguma coisa com isso, tipo escrever nos pinos de dados. Pra isso usamos o STORE from A ou Grave a partir de A, que é o comando STA e ele recebe um argumento de 2 bytes que é o endereço pra onde queremos enviar o valor de A.





Então acessamos a posição 2 do array e colocamos o binário 0x8D que é a instrução STA. Agora nas posições seguintes queremos enviar esse dado pro endereço 0x6000, como já expliquei queremos o inverso disso então na posição 3 do array colocamos 0x00 e na posição 4 colocamos 0x6000.





Essa sequência de 3 bytes vai fazer o seguinte: escrever o valor que está no registrador A nos pinos de dados, mudar o bit no pino de read write pra escrever e mudar os pinos de endereço pra 0x6000.




Rodamos o script python pra gerar o novo binário, gravamos na EEPROM com o minipro de novo, recolocamos a ROM na placa e ligamos a energia e o monitor do Arduino.



Fazemos reset com clock pausado, e vamos manualmente clock a clock. Mesma coisa de antes, ignoramos os 7 primeiros clocks que é a inicialização. A CPU pede os valores de 0xfffc e 0xfffd que puxa da ROM o endereço 0x8000, esse é o reset vector e a CPU pede o que tem nesse endereço, que sabemos que é o endereço 0 da ROM e tem a instrução LDA que é 0x9a.





O contador vai incrementando a partir de 0x8000 e pede o que tem em 0x8001 que é o valor 0x42. A instrução está completa e a CPU grava no registrador. Agora o contador pula pra 0x8002, e de lá tem a próxima instrução STA que é 0x8d. O CPU vai incrementar o contador e ler os proximos dois bytes, que vai ser primeiro 0x00 e depois 0x60, esse é o endereço 0x6000.







Tudo funcionando conforme esperamos mas ao configurar os pinos pra gravar, não tem ninguém no barramento que responde a essas ordens, e nada acontece. No próximo ciclo esse dado vai sumir do barramento. Precisamos de alguma coisa pra segurar esse dado enquanto a CPU fica livre pra fazer outras coisas. Esse seria um componente chamado "Latch" que acho que podemos traduzir pra "Tranca". Pra esse protótipo o Ben escolheu um chip que foi feito pelo mesmo fabricante desse clone de 6502 e é um adaptador que serve pra muitas coisas incluindo trancar alguns valores. Pense como se fosse um mini-memória.






Por acaso, os pinos desse adaptador são muito parecidos com o da ROM que já estamos usando, e tem espaço pra gravar até 2 dados de 8 bits no que ele chama de "Portas". Tem uma Porta A de 8-bits e uma Porta-B de 8-bits. Por isso você tem pinos de PA0 a PA7 e pinos PB0 a PB7. A essa altura vocês já devem ter entendido a idéia de pinos serem cada um 1 bit né?







Diferente da ROM não precisamos de 16 pinos pra endereço porque esse chip só consegue armazenar no 2 valores. Sabemos que queremos ativar esse chip quando passarmos endereços que comecem com 0x60 que em binário é 0110 0000. Resumindo o que o Ben explica no video dele, ele vai ligar os endereços A15 a A13 com os pinos de chip select que são CS1 e CS2 e colocar um inversor e outra porta NAND no meio deles pra configurar o chip corretamente. Os detalhes não importam pra onde eu quero chegar, mas recomendo que assistam o episódio dele pra entender os detalhes.







O importante é entender que quando a CPU colocar endereços como 0x6000 ou 0x6001 ou 0x6002 e assim por diante, esse chip vai entender os primeiros 3 bits, ligar e receber o dado de 8 bits dos pinos de dados e gravar na Porta A ou Porta B. Quem indica a operação é o segundo byte do endereço. Entenda, o CPU chama os pinos de endereço, mas são bits, podemos ligar esses pinos com qualquer outra coisa pra montar nossa lógica.






No chip de Tranca, segundo a documentação ele espera receber 4 bits de configuração em 4 pinos registradores diferentes. Podemos ligar esses pinos aos pinos A0 até a4 que são os últimos bits do endereço de 16-bits. Se mandar 0 0 1 0 que é o número 2 ele direciona pra Porta B e se depois mandar 0 0 0 0 ele manda gravar efetivamente na Porta B, portanto a CPU precisa mandar o endereço 0x6002 pra ao mesmo tempo habilitar e configurar a direção e depois mandar o endereço 0x6000 pra de fato gravar o que estiver nos pinos de dados na Porta B. Parece complicado mas é bem simples, vamos ver.




Pra ver isso em funcionamento podemos ligar alguns LEDS nos pinos da Porta B. Assim quando o valor for trancado, ele vai ligar os LEDs correspondentes.




De volta ao python mas antes de continuar, é uma boa hora pra refatorar esse código pra ficar mais legível. É assim que se programa, primeiro fazemos a coisa mais simples que funciona primeiro. Agora vemos padrões no código que dificulta continuar, então pensamos em formas de tornar o código mais fácil de manusear.





Um das formas de fazer isso é definir um novo array de bytes em cima do array cheio de 0xEA's, esse array vai conter nosso programa exatamente igual antes. É só colocar os bytes que estávamos posicionamento manualmente embaixo, em sequência em cima e apagar o que tava embaixo.





Agora o array de ROM vai ser esse novo array de código mais o array preenchido com 0xea, só que em vez de ser vezes 32768, vai ser 32768
menos o comprimento do novo array de opcodes. Assim o array do binário vai ter exatamente o mesmo comprimento de antes e isso é importante porque tem que ser tudo preciso.





Escrever tudo numa linha só ou dividir em multiplas linhas pro python não faz nenhuma diferença, só faz diferença pra gente conseguir ler mais fácil. E de proposito colocamos dois bytes numa linha porque o primeiro é o hexa da instrucao LDA seguido do seu argumento. E na segunda linha colocamos 3 bytes onde o primeiro é a instrucao STA seguido de 2 bytes que formam o endereço pra onde gravar o conteudo de A.





Esse código é exatamente igual o que tínhamos antes, mas agora temos a Tranca que exige primeiro uma instrucao pra dizer a direçao pra saber qual porta usar. Então precisamos mandar o endereço 0x6002. Mas também precisamos mandar algum dado pelos pinos de dados. Se mandar tudo 0 ele habilita a porta B pra ser input e se mandar tudo 1 ele habilita a porta B pra ser output e gravar o que receber.





Enviar tudo 1 em 8 bits é o hexa 0xFF. Então mudamos o nosso array de código pra em vez de carregar aquele 0x42 vamos carregar com o número 0xFF. E em vez de mandar esse valor pro endereço 0x6000, vamos mandar pro 0x6002, e com isso setamos a direção do chip pra porta B e pra ela ser output.




Na sequência podemos fazer o que queríamos antes, travar um valor, digamos o hexa 0x55. Agora é só mandar a instrução STA pro 0x6000. Por acaso 0x55 em hexa é 0101 0101 e isso vai ligar os leds alternando o primeiro apagado, o segundo aceso e assim por diante.





Pra ficar mais legal podemos agora repetir os comandos, e mandar armazenar 0xaa em hexa que é 1010 1010 em binario, alternando os bits com o valor anterior, dai os leds apagados vao acender e os acesos vao apagar. Só uma brincadeira pra mostrar como podemos controlar alguns LEDs.





Pra finalizar seria legal colocar essas duas sequências num loop pros leds ficarem piscando sem parar, repetindo essas sequências. E a forma de se fazer loop, segundo a documentação do 6502 é com um jump que é a instrução JMP. Ele manipula o contador de programa pra apontar pra outro endereço qualquer, fazendo o CPU continuar incrementado de lá.




Então podemos fazer JMP pra 0x8000 que é o endereço 0 na ROM e começar do zero, mas não tem necessidade de reiniciar tudo. Um jump pro endereço 0x8005 é suficiente, ou seja, pulando os primeiros 5 bytes. Agora podemos rodar o script, gerar o novo binário, gravar na EEPROM, ligar e testar. E pronto, LEDs piscando como esperado.




https://www.youtube.com/watch?v=oO8_2JJV0B4 (parte 3)




Se você chegou até este ponto e tá entendendo mais ou menos, no mínimo já deve tá ficando meio ansioso de ver esse monte de bytes num array. Neste ponto o Ben resolveu explicar uma forma menos feia de gerar esse binário. Obviamente ninguém escreve código em binário direto assim.




Mas considere por um instante que nos anos 50 pra trás era exatamente assim que precisava escrever. E a forma de fazer isso era com fios. Sabe os pinos de dados e endereço que ligamos registradores e agora ligamos a ROM? Antigamente era um patch panel. Lembra aqueles seriados ou filmes antigos dos anos 50 que mostra uma telefonista conectando uma ligação colocando ou tirando fios de um painel? É algo parecido. Configura os bits e manda pro computador, um conjunto de bits de cada vez.





Se você já leu alguma mini biografia do Bill Gates e do Paul Allen, vai lembrar que o primeiro computador comercial pra qual eles escreveram Basic foi o Altair 8800 que vinha com o processador Intel 8080 de 8-bits. Isso foi um ano antes de aparecer o processador Motorola 6800 que foi a base pro 6502 que estou mostrando aqui. Se você nunca viu um Altair veja esta foto, tá vendo esses switches no painel? A etiqueta em cima deles tá escrito D0 a D7 e embaixo A0 a A15. Agora você já sabe pra que serve esses switches.







Você tinha que escrever bit a bit subindo ou descendo esses switches, um a um os bits de dado e os bits de endereço e depois puxar o switch de "DEPOSIT NEXT" que tem nesse painel pra registrar na memória e fazer isso instrução a instrução, que é o equivalente do nosso array de bytes. Se você tá achando tedioso o que estamos fazendo, imagina escrever um programa inteiro só com esses switches, bit a bit, e sem errar nenhum bit. Essa é a verdadeira definição de "escovar bits". Felizmente os computadores caseiros que vieram depois ganharam teclados e monitor e  isso facilitou ordens de grandeza a programar.






De qualquer forma, havia uma opção um nível acima de escrever binários direto, e é escrever em Assembly. E é assembly com "y" no final, que é escrever usando mnemônicos como usar a palavra LDA em vez de escrever o binário pra 0xa9.




Em vez de escrever direto 0xa9 0xff podemos escrever LDA # $ F F. O dólar indica que estamos escrevendo um número hexa e o hash significa que é um valor imediato e não um endereço. Quando compila sem o hash apesar do mnemonico ser LDA, temos um tipo de polimorfismo como já expliquei. Se passarmos um valor com hash vamos escolher o 0xa9, mas sem o hash, FF é um endereço e o opcode é diferente, o 0xa5.




Continuando em vez de 0x8d 0x00 0x60 podemos escrever STA $6000, ou seja, também não precisamos nos preocupar com a inversão de little endian como falei antes e escrever na ordem natural de leitura humana.



Nas linhas seguintes fazemos lda 55, sta 6000,
lda 11, sta 6000, jmp 8005




É exatamente a mesma coisa que fizemos no binário. Pra declarar que o início do programa é o endereço 0x8000 colocamos um indicador no começo do arquivo `.org 8000` que declara a origem. Lembre-se, na ROM o endereço inicial vai ser 0x00 mas do ponto de vista do CPU esse é o endereço 0x8000.





No final do código colocamos um novo `.org fffc` que é o primeiro endereço que o CPU sempre vai pedir pra buscar qual é o próximo endereço onde tem a primeira instruçao do programa, já repetimos isso várias vezes. E aí colocamos um word 0x8000 que indica o endereço inicial pro CPU buscar. Word é como chamamos um conjunto de 2 bytes.





Salvamos esses comandos num arquivo texto e agora podemos passar isso pra um Assembler, com "er" no final, que vai traduzir esse texto em binário. Em inglês Assembly que termina em "y" significa "montagem", que é a instrução de montagem, ou o código-fonte. E Assembler que terminar com "er" é o montador, que vai pegar essa instrução de montagem e montar o binário propriamente dito.





Pra gerar o binário correto precisamos do Assembler específico pro 6502. Na maioria dos Linux basta instalar o pacote `vasm`. Pra quem tá em Windows ou Mac vou deixar o link do site nas descrições abaixo e o video do Ben explica em detalhes como usar.





Existem vários assemblers diferentes pra família 6502, do Apple II é diferente do Atari que é diferente do 6502 genérico. O assembler que precisamos se chama `vasm6502_oldstyle`. Se abrirmos o binário que ele gera com hexdump e compararmos com o nosso produzido com o script de python, vemos que é idêntico ao array de bytes que estávamos escrevendo na mão.





Pra completar os 32k vemos que faltou só 2 bytes no final, pra isso só adicionamos um novo word no fim com 2 bytes pra completar. Mas agora que estamos escrevendo em Assembly podemos usar funcionalidades do Assembler Vasm que melhoram um pouco nossa qualidade de vida de programação em baixo nível. A maioria dos Assembler implementam macros e outras coisas pra evitar que a gente tenha que ficar fazendo repetições ou decorando endereços de cabeça.





Por exemplo, lembra que temos um JUMP pra um endereço fixo 0x8005? E se colocarmos mais instruções antes disso? Toda hora ia precisar ficar atualizando esse endereço na mão. Em vez disso podemos adicionar um label e fazer o jump pular pra esse label e deixar o assembler calcular qual é o endereço certo.




A diferença no código é que precisamos sempre identar com espaços ou tab, e labels começam na primeira coluna sem identação. Só de fazer isso já nos livramos de um número hard-coded. Números mágicos como aquele sempre são ruins e em Assembly isso não é diferente.




Ainda dá pra melhorar o codigo. Podemos deliminar a região de reset com um label e só pra brincar, vamos mudar o valor 0x55 pra ser 0x50. No loop vamos tirar o que tinha antes e colocar uma instrução nova que é o ROR ou rotate right. Lembra o conceito de shift pra direita? Pense que 0x0050 é `0 0 0 0  0 1 0 1` daí quando der shift right vai virar `1 0 0 0  0 0 1 0` e a cada loop ele vai dar shift e rotacionar pra direita. Significa que vai ter só dois leds acesos a cada clock e eles vão se "movimentando" pra direita.





Podemos compilar com o Vawm pra gerar o binário, gravar na EEPROM e fazer o de sempre, colocar a ROM na placa, ligar força, resetar e ver se funciona. No caso ele tá rotacionando pra esquerda porque a placa tá de ponta cabeça no video, mas você entendeu.



https://www.youtube.com/watch?v=FY3zTUaykVo (parte 4)




Com os LEDs fazendo o que esperávamos, sabemos que a trava está funcionando e gravando o dado na porta certa. Então podemos ir um passo além. Essa trava pode funcionar como um buffer pra uma tela e o Ben conseguiu uma tela de LCD simples. Novamente, vamos pular a configuração do hardware mas a parte importante é que ele recebe 8 pinos de dados como a ROM e o latch, e assim como o latch ele tem 3 pinos de controle onde podemos ativar configurações.





Em resumo o LCD pode ou receber instruções ou receber dados, que seriam as letras que queremos que apareça na tela. Instruções são coisas como limpar a tela, mudar a posição, configurar um cursor e assim por diante. O manual da tela tem os detalhes de cada configuração mas vou mostrar o valor que vamos mandar no Assembly. Pra receber dados vamos conectar os pinos de dados do LCD com os pinos da Porta B do latch, e pra configurar os 3 pinos de controle vamos ligar em 3 pinos da Porta A do latch.




Vamos refatorar o código de novo criando alguns simbolos ou constantes pro codigo ficar um pouco mais legivel. Criamos PORTB = 6000 e PORTA = 6001.
DDRB é a direção se vamos escrever na porta B o endereço é 6002
mas se quisermos escrever na PORTA temos que setar DDRA que é 6003




0xff significa tudo 1 em hexa, podemos deixar mais claro escrevendo o número em binario, bit a bit. Dizemos pro Assembler que isso é um número binário colocando % (porcento) no começo e ; (ponto e vírgula) é comentario, que não aparece no binário final.



Agora os pinos de controle do LCD, pra isso vamos setar só os primeiros 3 bits que são os que conectamos nos pinos de controle da tela. Agora é uma sequência específica desse modelo LCD, então não se preocupem tanto com os detalhes dessa parte.



Pra inicializar a tela começamos mandando 00111000. O primeiro bit seta modo 8-bits, o segundo seta 2 linhas na tela e o 3o  seta fonte de 5 por 8 pixels. Por fim um STA mandando pra PORTB.




Carregamos zero com LDA e mandamos Porta A com STA pra limpar os pinos de controle RS, RW e E. RS é o pino que seleciona se estamos mandando instruções ou dados pra tela, RW se estamos lendo ou escrevendo e E se tá habilitado pra receber comandos.



Agora queremos habilitar com LDA do valor E e depois desligamos esse enable. É uma sequencia bem burocrática mesmo, a maioria dos hardware tem alguma sequência de controle assim mesmo, mas é o que a documentação do LCD diz que precisa fazer. Mas já tá quase acabando.




Cada nova instrução que queremos mandar precisa copiar toda essa sequencia. Agora mandamos `0000 1110`. De novo 3 bits, mas agora é pra ligar o display, ligar o cursor e não fazer blink que é ficar piscando na tela.



Copiamos todo o bloco de controle e colamos embaixo. A última configuração é mandar `0000 0110` que é dizer pro LCD que pra cada nova letra que mandarmos é pra incrementar a posição e não fazer nenhum tipo de scroll.


E tem que copiar todo o bloco de controle de novo.



Finamente podemos enviar a letra que queremos escrever no LCD. Poderíamos dar LDA do número em binário ou hexa que representa a letra na tabela ASCII. Mas como estamos usando um Assembler, ele sabe converter sozinho então podemos escrever o string "H" entre aspas que ele se vira.


Daí mandamos pra Porta B com STA.



O bloco seguinte é um pouco diferente do que fizemos antes. Em vez de zerar os pinos de controle temos que ligar o pino que seleciona o registrador pra em vez de receber instrução, receber dado, entao configuramos com a constante RS que tínhamos declarado antes.



Na sequência, além de só habilitar com a constante "E", tem que mandar junto o bit de RS. Pra isso usamos o operador bitwise de OR que é uma barra vertical. O que isso faz? Ele faz um OR bit a bit. De novo, isso é lógica. Na prática o resultado é mesclar os bits de RS e de E. Como RS é 0010 e E é 1000 o resultado vai ser 1010. Aqui valeria uma tangente mas como já está comprido só quero deixar um lembrete que essa é uma técnica muito usada especialmente pra quem mexe com protocolos de rede. Isso é como trabalhamos Bit Fields, procurem sobre isso no Google. É uma forma eficiente de enviar várias características de alguma coisa embutido num único byte em vez de ter um byte separado pra cada valor.





Por fim zeramos o bloco de loop pra quando chegar nele ficar num loop infinito e não fazer nada. Assim ele termina de escrever na tela e não faz mais nada.


Compila, grava a eeprom, e testamos. E aparece o "H" na tela como queríamos.


Pra escrever o resto das letras do hello world, por agora vamos fazer do jeito mais porco e sujo só pra ver o resultado rápido. Ou seja, copy e paste nervoso de toda a sequência da letra "H" pra cada uma das outras letras. Isso é obviamente péssimo de se fazer. Pra testar a primeira vez quando você ainda não sabe se vai dar certo tudo bem, mas obviamente vamos voltar e melhorar isso depois.




Vamos compilar e não só o código Assembly ficou longo, mas o binário reflete isso. Olha como o binario no hexdump ficou gigantesco com mais de 300 bytes só pra escrever um mísero hello world. Escrever código longo e sujo além de feio e ruim de manter, também gera instruções redundantes e aumenta o tamanho do binário.




Agora podemos transferir pra ROM, ligar na placa e, como esperávamos, temos um Hello World aparecendo. Se o objetivo for só escrever Hello World do jeito mais feio do mundo, já acabamos, mas podemos só acrescentar uma última coisa pra melhorar muito esse código.



https://www.youtube.com/watch?v=xBjQVxVxOxc (parte 5)




Vamos aumentar nosso arsenal de Assembly aprendendo o conceito de sub-rotinas, que é uma forma primitiva de funções. Aliás, pra quem já é programador e já ouviu falar do conceito de "GO TO" isso é o Jump pra um endereço fixo que mostramos com o mnemônico JMP. Mas nem em Assembly é obrigatório usar só jumps.




Pra refatorar esse codigo vamos criar uma subrotina chamada `lcd_instruction` que manda os comandos pra escrever os dados na tela depois do LDA. Toda aquela sequência que demos copy e paste várias vezes no começo do código.




Já sabemos que JMP pula pra um endereço fixo. O problema é que uma vez que você pula, não tem mais como voltar pra trás. Pra ter esse recurso podemos usar o opcode JSR que é Jump Sub Routine, que pula pra uma subrotina e grava o endereço atual do contador de programas. Daí, no final da subrotina usamos o comando RTS que é tipo `return` num Javascript, que vai pegar o ultimo endereço gravado pelo JSR e colocar de volta no contador de programas, e com isso o CPU continua na instrução logo depois do JSR.






Essa é a forma mais rudimentar de uma função em linguagem de máquina. Fazemos a mesma coisa criando uma subrotina `print_char`, chamamos JSR depois do load da letra e no final da subrotina colocamos RTS pra voltar pro byte seguinte da instrução de jump.




Depois de recompilar podemos comparar o tamanho dos binários, o anterior sujo tinha 333 bytes. Agora ficou bem menor em tamanho. Só que isso não sai de graça. A versão anterior era maior mas era pouca coisa mais rápido porque agora a CPU vai executar um monte de Jump e Return que não tinha antes. Cada uma dessas novas instruções usa clocks pra executar. Porém é aquele caso em que o ganho de performance não compensa a sujeira do código. Via de regra você sempre deve preferir código legível do que otimização prematura.






Isso faz parte do dia a dia de um programador: ter que escolher quando você escreve um pouco mais sujo pra ganhar performance e quando o ganho de performance é tão pequeno que não compensa. Não existe uma receita, só com experiência você vai saber. Mas via de regra você só toma essa decisão depois de conseguir testar o código e mensurar se o ganho vale a pena ou não. Nunca  ache que só porque um código rodou a primeira, já tá pronto e nunca mais vai mudar. Neste exemplo besta já refatoramos o código várias vezes, imagina num código grande de verdade.






Gravamos na ROM, testamos e ....  nada acontece, o programa parece que travou. Por que? Pra descobrir vamos ligar o monitor de Arduino de novo, resetar e colocar em clock manual pra ir linha a linha. Vamos acelerar direto pro suspeito mais óbvio que é o JSR.


Temos o LDA que vai configurar a primeira configuração pra tela. Em seguida temos o opcode 0x20 que é o JSR.




Deveríamos ver algo como um 0x20 e depois 0x5d e 0x80 representando o endereço 0x805d que é onde está a subrotina. Mas em vez em disso vemos essa sequencia estranha 5d 80 0e. Aí parece que volta ao normal continuando a instrucao com o 0x80 restante pra formar 0x805d. Ou seja, ele pula pra subrotina e podemos ver que ele segue normalmente.




Seguimos mais algumas instruções e chegamos no opcode 0x60 que é o RTS ou return, mas pra onde ele vai retornar? Deveria ser pra 0x800f que é o próximo endereço depois do último JSR em 0x800e.




Estamos vendo no monitor que o CPU tenta ler alguma coisa em 0x0123 e 0x0124. O lance é que JSR e RTS dependem de algum hardware que responde nesses endereços pra gravar o endereço de retorno, mas no momento nao temos nenhum hardware que responde.






Quando chama JSR ele tenta gravar nesses endereços, mas não tem ninguém esperando isso então o endereço de retorno vai pro limbo. Quando chega no RTS ele tenta recuperar o endereço, e não tem ninguém pra responder, então acaba tendo algum lixo nos pinos e o CPU assume que é um endereço e tenta pular pra lá. No caso veio um lixo 0x8d8d e o CPU vai pra lá mas não tem nada e o programa se perde.





Esses endereços 0x0123 0x0124 são específicos do processador 6502. Segundo a documentação, de 0x0100 a 0x01FF temos o Stack, uma pilha. E temos mais um registrador que ainda não mencionei, chamado SP. Todo CPU tem uma série de instruções implementadas em hardware como o LDA STA JSR e outros. Instruções como LDA grava no registrador chamado "A". Até agora só vimos 2, o registrador A e o PC que é o contador de programa. E o ultimo registrador novo importante pra hoje é esse SP é o Stack Pointer, que guarda um endereço do topo de uma pilha. O SP é quem permite a existência do conceito de sub-rotinas e funções.





Stack ou Pilha é uma estrutura de dados. Lembra a tal fundação que eu sempre falo? Se você estudar estrutura de dados, vai descobrir a Pilha, uma das estruturas mais básicas e que você aprende logo no começo dessa matéria. Todo iniciante tem que saber o que é uma pilha e quando usar ela. Em resumo, é uma cadeia de elementos onde você vai colocando um elemento de cada vez no topo. E toda vez que pedir pra devolver um elemento, vai removendo do topo.





Essa pilha é um tipo particular chamado LIFO, Last In, First Out, ou seja, quem entra por último, sai primeiro. A vantagem de uma estrutura dessas é que basta guardar o endereço do topo. Depois que adiciona um elemento, decrementa o endereço do topo. Pra puxar da fila, devolve o dado do topo e incrementa o endereço no registrador SP. Quando falamos topo, não necessariamente começamos do zero e vamos subindo um a um. No caso do 6502 ele prefere iniciar no meio da pilha, em 0x0124 e vai subindo até 0 e quando chegar no zero ele rotaciona pro fim da pilha em 01FF e continua subindo.






Toda vez que você faz um JSR, ele vai acumular um endereço na pilha. Se você fizer mais que 255 jumps sem fazer um Return, ele vai estourar o tamanho da pilha e vai começar a sobrescrever o primeiro endereço gravado. É isso que se chama de transbordar da pilha ou, em inglês, Stack Overflow. Mesmo com uma pilha pequena dessas é muito difícil fazer 255 jumps sem retorno. Quando isso acontece normalmente é uma recursão mal feita. Recursão é uma sub-rotina que dá JSR pro começo dela mesma. É muito fácil um iniciante errar com recursão.






Outra coisa interessante de saber é que registradores são literalmente variáveis globais. Se você já trabalhou com C ou Javascript já deve ter ouvido falar de quão tenebroso uma variável global pode ser. Antes de fazer o JSR no nosso código, setamos o registrador A com um valor usando LDA, mas quando pulamos pra subrotina, dentro dela modificamos esse registrador A. Se depois que retornássemos o programa esperasse encontrar o mesmo valor original em A, teríamos problemas.





Como no nosso caso, depois que retornamos não faz diferença porque vamos escrever a próxima letra em cima do A mesmo, então tudo bem, mas se quiséssemos evitar algum efeito colateral num código maior, poderiamos primeiro empurrar o valor de A pro stack também, usando a instrução de push A que é PHA.



E antes de retornar com RTS podemos puxar o valor de A do topo do stack usando pull A ou PLA. Por garantia então devíamos usar isso no começo e fim de toda sub-rotina né? Mais ou menos, esse hardware antigo só tem 255 slots na pilha lembram? Se você souber que não vai estourar, pode fazer isso. Como eu falei, tudo é um trade-off. Se eu quiser garantias demais, os recursos podem acabam cedo demais e podemos acabar ganhando um bug de stack overflow sem querer.





Só por comodidade podemos mudar o registrador SP de 0x0124 pra 0x01FF pra começar do fim da pilha em vez do meio. Pra isso podemos procurar uma instrução como o LOAD A, mas nao tem LOAD pro registrador SP da pilha, e sim TRANSFER que é TXS, que transfere um valor do registrador X pro SP. E aqui aprendemos que existe um registrador chamado X além do A.




Assim como fazemos com o registrador A, primeiro usamos a instrução LOAD to X que é LDX com #$FF e daí transferimos X pra SP com TXS. Note que colocamos FF e não 0x01FF porque os endereços do stack sempre começam com 0 1 em binário entao na pratica estamos contando sempre de 00 a FF. Já expliquei que é um stack pequeno com 255 posições.




Tudo isso entendido, precisamos de algum lugar que tem espaço pra gravar 255 elementos de uma pilha e responde aos endereços de 0x0100 a 0x1FF. Nosso chip de trava só tem 2 portas então não serve. Chegou a hora de adicionarmos um chip de memória RAM. E fica outro insight, memória RAM pode ser opcional se o que você pretende fazer com um hardware são operações simples que sobrevivem só com registradores ou com uma trava simples.



https://www.youtube.com/watch?v=i_wrxBdXTgM (parte 6)



O Ben escolheu um chip de RAM que é muito parecido com a pinagem do EEPROM e da Trava que já estamos usando, então vamos pular a configuração do hardware que é a mesma coisa: liga força, liga terra, liga os pinos de dados e de endereço. Assim como todos os outros chips por acaso tem 3 pinos de controle que importam, um pra write enable que como o nome diz habilita escrita, um pra output enable e outro pra chip select. Write enable é fácil, porque o 6502 tem um pino read write que indica escrita, daí ligamos direto um no outro.





Assim como no caso do ROM e do LCD precisamos definir os endereços que a RAM vai responder. Sabemos que o stack precisa pelo menos dos endereços 0x0100 até 0x01FF. Mas vamos mapear o primeiro 1/4 dos endereços do topo que vai de 0x000 até 0x3FFF que é bem longe dos endereços 0x6000 que o LCD usa e do endereço 0x8000 que a ROM usa.





Isso é suficiente pra 16 kilobytes de RAM. Por acaso este chip moderno tem mais espaço que isso, então vamos desperdiçar um pouco neste protótipo. Pra usar tudo daria mais trabalho pra criar um mapeador de endereços. Mas lembre-se que um nintendinho tinha só 2 kilobytes de RAM e 2 kilobytes de memória de video. E no próximo episódio vou explicar porque não dava pra ter muito mais que isso mesmo.





Existe um pequeno circuito que precisa ser adaptado e vou pular essa explicação, mas em resumo a forma de conectar a RAM na CPU é ligar o A14 da cpu com o A14 da RAM cruzando com o output enable e o A15 da cpu de novo através de um inversor e um nand no chip select. O que precisamos saber é que isso vai habilitar a RAM quando o endereço começar com 0 0 que cobre os endereços que queremos. Pra entender porque a ligação em hardware é dessa maneira, veja o video do Ben.





Feito isso, agora temos RAM ligado e configurado respondem nos endereços que precisamos, então teoricamente já temos uma pilha disponível e com isso o programa deveria funcionar. Se ligarmos e dermos reset, de fato, agora o hello world aparece como deveria.




Tudo resolvido, vamos ligar o Arduino pra entender como o programa se comporta. Fazemos reset e deixamos o clock em manual de novo. Como sempre, vamos ter os 7 clocks pra inicializar a CPU e pulamos rápido até o ponto onde o programa faz o jump JSR que é o opcode 0x20.




Lembrando que configuramos o registrador SP pra começar de 0x01ff, que é o fim do espaço de endereços da pilha, e de fato vemos no monitor que tá escrevendo 0x80 no final do stack em 0x01ff. Daí o cpu atualiza o registrador SP pro próximo endereço ser 0x01fe e escrever 0x11 lá. 0x8011 é o endereço de retorno da subrotina.



Agora ele salta pra subrotina que tá em 0x8060, como já fazia antes, executa a sequência pra escrever a letra no LCE e chega na instrução RTS que é o opcode 0x60.




A instrução de retorno vai desempilhar o primeiro byte do topo da pilha, que está em 0x01fd, e lê 0x11. Daí decrementa o registrador SP e lê 0x80 e isso forma o endereço 0x8011 que é pra onde o programa tem que voltar. E com isso temos o suficiente de hardware pra fazer jumps o que garante que podemos programar praticamente qualquer coisa só com o que temos aqui.






Os dois registradores de controle de um CPU são o contador de programa ou PC que tem o endereço da próxima instrução ou byte que ele tem que ler. E o apontador de pilha ou SP que é o endereço do topo da pilha. Tendo esses dois controle você consegue executar uma instrução após outra e consegue dar jumps pra continuar executando de outro endereço e retornar pro endereço anterior. Ou seja, você tem o equivalente a um loop com WHILE numa linguagem de alto nível. Daí existem instruções de Branch e Compare que servem pra comparar valores e dar jumps dependendo das condições que você configurar, e isso é o equivalente a um IF numa linguagem moderna.




Com essas poucas instruções que vocês viram já dá pra ter o modelo da maioria das funcionalidades básicas de qualquer linguagem: loops, funções e ifs ou branches que não cheguei a mostrar mas acho que vocês já conseguem imaginar como seria. Na série do Ben tem um episódio extra depois que ele configurar o LCD onde ele troca o clock que está montado num breadboard por um clock de 1 Megahertz de verdade. Mas quando ele faz isso o programa pára de funcionar. Tudo funciona quando o clock é bem lento, mas quando o clock fica rápido demais, o CPU envia os comandos pro LCD rápido demais e o LCD não responde a tempo. Pra evitar isso precisa adicionar um comando no CPU pra perguntar pro LCD se já pode mandar a próxima letra.





De qualquer maneira eu queria passar pelos principais pontos dos videos do Ben pra que vocês pudessem ver como um CPU funciona, como ele se comunica com outros componentes como memória RAM ou um LCD simples. Como um CPU carrega um programa e executa. No fim do dia, não importa que linguagem você está usando, ele vai ser convertido em bytes de instruções parecidas como o que acabei de mostrar. Vocês viram que só de pular do binário pra escrever em Assembly já ganhamos algumas conveniências que o Assembler Vasm nos dá.




Quanto mais conveniências uma linguagem adiciona, mais abstrações ele faz e mais lento ele tende a ser. Como falei antes existe um trade off sempre, sempre existe um balanço entre ser conveniente e ser rápido, entre ser rápido e ser seguro e assim por diante. Em outros videos eu vou tentar explicar as diferenças das diferentes linguagens levando em consideração que vocês assistiram este vídeo.




No próximo video eu vou usar o que mostrei aqui de uma maneira mais prática. Eu mostrei a idéia do Game Genie no começo do video mas não fiz nada com ele hoje, é o que vou começar mostrando na parte 2. A parte 2 vai ser bem menos tedioso que esta parte 1, isso eu garanto, porque agora podemos usar tudo que eu mostrei aqui na prática em programas de verdade.




Muitos programadores associam "linguagem de máquina" com algo difícil e inatingível que não foi feito pra eles, mas isso não é verdade. Linguagem de máquina e o hardware em si são razoavelmente simples, peças de lego. Tudo funciona em cima das mesmas peças e você vai ser um programador melhor se pelo menos tiver uma imagem mental de como seu código interage com esses componentes.





Uma coisa parece difícil só porque você nunca viu. É que nem um truque de mágica. Mas depois que a gente revela o truque, as coisas ficam muito mais claras. Se você não entendeu o video todo, não se preocupe, eu literalmente resumi o equivalente a umas 5 horas de aula do canal do Ben Eater aqui. Vou deixar os links pro canal dele nas descrições. Se quiserem adicionar mais a esta conversa não deixem de mandar nos comentários abaixo, se curtiram o video mandem um joinha, assinem o canal e cliquem no sininho pra não perder o próximo episódio e, como sempre, compartilhem o video pra ajudar o canal. A gente se vê na próxima, até mais.





Se tem um tema que eu queria fazer desde que abri o canal é apresentar algumas das fundações da computação, tanto do ponto de vista de história e da evolução, mas principalmente dos fundamentos básicos que eram vários 60 anos atrás e ainda são válidos até hoje.

O video de hoje vai abrir com um tema de videogames, mas vamos descer bem fundo no cérebro do Nintendinho pra criar um vocabulário que eu vou usar na Parte 2, quando de fato vou mexer num emulador de Nintendo. E esse vocabulário vai servir não só pra videos futuros meus como pra tudo que você for fazer em computação. Esta é a base, sem esta base tudo que você tentar aprender de avançado depois vai ser mais difícil.

Infelizmente é muito difícil empacotar estes temas de uma forma que não seja maçante. Espero ter conseguido pelo menos interessar vocês no assunto.
