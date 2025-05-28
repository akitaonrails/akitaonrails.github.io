---
title: Meus Teclados Modernos Favoritos
date: '2024-10-24T11:05:00-03:00'
slug: meus-teclados-modernos-favoritos
tags:
- zsa
- keychron
- gizmo
- corne
- hillside
- qmk
- zmk
- moonlander
- voyager
- gk6
- q15
- teclado
- ortolinear
- colunar
- staggered
- teclas
- switches
draft: false
---

Pra quem acompanhou meu canal no YouTube, deve ter visto a trilogia de videos onde contei a história por trás de teclados, desmistifiquei os teclados mecânicos, os diversos componentes, modelos mais populares da época. E hoje estou de volta pra terminar falando dos meus teclados modernos mais interessantes e qual eu realmente uso todo dia.

Se não assistiu, recomendo que assista a trilogia de videos depois:

* [Entendendo Teclados Mecânicos | Minha coleção - Parte 1](https://www.youtube.com/watch?v=tEXX1jdpZN8)
* [Teclados Mecânicos Exóticos | Minha coleção - Parte 2](https://www.youtube.com/watch?v=57axLgXkS_M)
* [Caminho pro Melhor Teclado do Mundo!](https://www.youtube.com/watch?v=78aw1muYWQM)

**Primeiro Aviso:** antes que os chatos comentem. Sim, teclados mecânicos são caros. MUITO CAROS. Sim, dá pra escrever livros inteiros num teclado de 50 reais da Multilaser comprado na Kalunga. Não precisa ter switches mecânicos, não precisa de tecla PBT double-shot. Não precisa mudar de layout, qwerty staggered tradicional funciona muito bem. Não precisa de unibody de alumínio. Não precisa de RGB. Não precisa gastar R$ 2.500 num modelo topo de linha. Definitivamente não precisa. Quem faz a obra-prima é o autor e não o teclado.

Isso dito, sim, dá pra ir de São Paulo pra Bahia num Fusca. Ele vai servir sua função de levar do ponto A ao ponto B, como meu pai faria quando era jovem, como meu avô faria na época dele. Funciona perfeitamente bem. Mas, alguns de nós preferem fazer o mesmo trajeto com ar-condicionado, poltronas ergonômicas, som de qualidade, mais velocidade e mais segurança. Nada disso é obrigatório. Ir do ponto A ao ponto B pode ser feito de várias formas diferentes. Se pra você isso não inclui investir em carros caros, não precisa. Use seu Fusca e seja feliz. Este artigo é somente pra quem gosta de Porsche e vê valor nisso.

**Segundo Aviso:** a maioria das fotos que mostro no artigo estão em alta resolução original. Pra ver mais detalhes, botão direito e "abrir imagem e nova aba". Faz bastante diferença.

**Terceiro Aviso:** sim, o artigo é SUPER longo, por isso dá pra navegar pras seções principais usando os links abaixo:

* [Layouts e QMK](#layouts-qmk)
* [Treinamento](#treinamento)
* [Soluções DIY](#solucoes-diy)
* [Ortolineares - GK6](#ortolineares-gk6)
* [Ortolineares - Q15](#ortolineares-q15)
* [Meu Teclado Favorito - Voyager](#voyager)
* [Ortolinear vs Colunar](#pulso)
* [O Futuro - Framework](#framework)

Fim dos avisos. No terceiro video eu começo a explicar a diferença pro melhor tipo de teclado do mundo: os ortolineares ou colunares. Não vou explicar tudo de novo, mas em resumo, eles se livram do legado histórico do layout limitado pelas máquinas de escrever mecânicas e repensam o que seria o melhor layout pensando na posição de verdade dos seus dedos, inclusive levando em conta que você tem dedos mais longos e dedos mais curtos (os colunares pensam nisso, os ortolineares não).

Naquele video eu tinha acabado de migrar pra um [ZSA Moonlander](https://www.zsa.io/moonlander). Até hoje ainda é um dos melhores teclados que eu já experimentei. Mas tem dois problemas fundamentais: primeiro que é extremamente caro, faixa de USD 400. Pra nós, brasileiros, é pior ainda porque vai incidir quase 100% de impostos mais transporte, então estamos falando de um teclado de pelo menos USD 800, mais caro que um PS5, quase o preço de um iPhone 16 Pro comprado nos EUA, faixa de preço de um notebook completo.

Mesmo se dinheiro não for um empecilho pra você, o segundo problema, é que ele é fisicamente gigantesco. Ocupa um espaço absurdo na mesa. Mesmo que tenha uma mesa espaçosa, ele vai ser um "trambolhão", olha só como é:

![Moonlander](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/jn6bce1tishe4tgocps39gtvlvlq)

Mas como disse, a construção da ZSA é de extrema qualidade, os materiais usados incluem metais como alumínio, portanto é tudo muito firme. Os plásticos também são de ótima qualidade. Os switches são removíveis então você pode experimentar um conjunto silencioso como Reds lineares ou barulhentos como Brown ou Blue.

Note também como ele tem inclinação ([tenting](https://www.youtube.com/watch?v=oGQhiURh6Tw)), que faz o meio ser mais alto, pra evitar pronação dos seus pulsos (um dos maiores ofensores em LER ou tendinite), e por isso também tem apoio pros punhos embaixo. É de longe o mais ergonômico. Além disso tem buraco pra parafuso padrão igual de câmera fotográfica, o que permite encaixar em tripés, caso queira experimentar estilos mais exóticos de postura.

![Moonlander perfil](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/1l8uo8a8opjlj7ova41ld96idhca)

O canal do [Ben Vallack](https://www.youtube.com/@BenVallack) explica melhor isso. Lembrando que o canal dele é extremo, não é pra todo mundo, precisa de muita dedicação pra conseguir se acostumar ao estilo dele, mas é legal ter com referência o que é possível fazer pra casos especiais.

{{< youtube id="II3Wm5P6fOU" >}}

Portanto sim, se pra você o tamanho e o preço não importam, este é de longe o teclado mais customizável, ergonômico e de melhor qualidade possível. Muitos vem me perguntar de modelos como o Kinesis - que também é gigante - mas eu prefiro o Moonlander, nessa categoria. Se formato do Kinesis, em particular, for importante, no final vou falar dele rapidinho.

<a name="layouts-qmk" />
## Layouts e QMK

Mas o Moonlander tem um problema praqueles que querem mesmo cruzar a linha da ergonomia extrema: digitar sem tirar os dedos da "home row" a linha do meio, onde ficam as teclas "F" e "J". O ideal é ter apenas 3 linhas, uma linha pra cima e outra pra baixo da "home row", mas o Moonlander tem 2 linhas acima e 2 linhas abaixo, além de dois thumb-clusters enormes de 4 teclas cada, o que garante que, se tentar usar todas as teclas, vai acabar movendo a mão pra cima e pra baixo mais do que deveria, perdendo o ritmo e velocidade e, principalmente, a ergonomia.

Este passo não é pra todo mundo, mas depois de muito treinar e experimentar, acabei concordando que o formato mais "balanceado" pra maioria das pessoas que tem intenção de otimizar pra melhor, é o **Corne colunar staggered 40%**.

Se trata de um teclado colunar, ou seja, as teclas estão alinhadas verticalmente, em vez de zig-zaguear entre as linhas, como num convencional. Também são staggered, mas na vertical, ou seja, segue mais ou menos a proporção vertical de comprimento dos dedos. A coluna do meio vai mais pro alto porque o dedo médio é mais longo. Ortolineares são colunares que não são staggered. Já falo mais deles na próxima seção.

Um Corne 40% tem 40% das teclas que um teclado grande convencional - que costuma ter por volta de 103 teclas. Portanto umas 42 teclas. Como são split, divididas no meio, 21 teclas pra cada lado. Alguns preferem remover as duas últimas colunas de teclas nos dois lados mais extremos do teclado, onde ficam "tab" ou "ctrl", reduzindo o total pra 18 teclas de cada lado, ou 36 teclas. E tem alguns como o Ben Vallack que conseguem ir ainda abaixo disso, mas já acho extremo demais e pouco prático pra maioria das pessoas.

Mas como usa um teclado com tão poucas teclas? Como faz pra caber tudo? E esse é o ponto: não faz. Em vez de tentar ter todas as teclas, divide-se em camadas virtuais, com uma tecla modificadora que muda a função de cada tecla. Por exemplo, a maioria dos firmwares de teclados bons hoje são baseados em padrões como QMK ou ZMK. Não quero entrar em detalhes, veja o repositório no GitHub do [QMK Firmware](https://github.com/qmk/qmk_firmware), mas podemos usar sites como o [QMK Configurator](https://config.qmk.fm/) pra editar o arquivo JSON de layout, visualmente. Por exemplo:

![corne layer 1](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/08zvubti1x2noddivb97pu7678j2)

Este é o layer 0, sem fazer nada, se só sair digitando no meu teclado, são essas as teclas configuradas por padrão. Aqui nada de novidade, mas note embaixo, no "thumb cluster", onde fica o dedão, tem uma tecla dizendo "MO(1)" que significa *"Momentarily Turn Layer On"*, ou seja, se deixar essa tecla apertada, enquanto estiver apertada, ele vai mudar pro layout na camada 1, que está configurada assim:

![corne layer 1](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/6wwjkn4ei6qltt4mbk8g1d1xo50o)

Tá vendo? É assim que, no meu caso, eu tenho acesso a teclas como "page up" ou "page down" ou setas de direção. Quem é de NeoVIM deve ter notado que é a configuração de setas de VIM. Se eu tirar o dedão daquela tecla "MO(1)", volta pra camada 0 anterior, e lá, tem outra tecla modificadora, a "MO(2)" que muda pro seguinte layout:

![corne camada 2](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/0igkt6wac5u5tfdsg2ws3glkbwul)

É nesta camada que tenho acesso a caracteres especiais como "@" ou "&", sem precisar esticar meu mindinho até o shift no canto, como se faz num teclado convencional. Uso meu dedão. E com o dedão também tenho acesso a acentos e pontuações. Isso é muito subjetivo e cada um pode configurar como quiser, mas preferi fazer meu dedão trabalhar mais. Num teclado convencional, o dedão esquerdo serve pra dar espaço, mas o dedão direito não serve pra nada. E eles são os dedos mais fortes da sua mão. Por outro lado os dois mindinhos ficam encarregados por shift, acentos, pontuação e, em português, é ainda pior que em inglês, porque temos muito mais acentos.

Digitar em português é, na média, mais lento do que em inglês por conta de acentos e palavras mais longas. Mas no meu caso, dividi melhor e dei mais trabalho pro dedão. Veja meu thumb cluster, na camada 0:

![camada 0 thumb cluster](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/hfnc3l660frcoayvq8oiz110h1kd)

Além de barra de espaço, que coloquei na direita, os dedões ainda tem a função das teclas modificadoras "MO(1)" e "MO(2)" além de delete, backspace e enter. Isso tira muito trabalho dos mindinhos, e me parece uma divisão de trabalho mais justa, que leva em conta a força dos dedos. Essa é a principal vantagem de usar um teclado customizável com firmwares como QMK. 

Existem dezenas de sugestões de outros layouts, mas leve em consideração que português, por ter acentos, não pode ser igual aos recomendados por norte-americanos. Onde você vai configurar acentos, vai mudar a velocidade e quantidade erros de sua digitação.

O problema é que precisa ter a mente aberta. Aceite que sua memória de teclados convencionais vai ser inutilizada e vai precisar treinar do zero. Então, em vez de tentar colocar teclas onde já está acostumado, pense em mudar pra onde faz mais sentido pro seu workflow. Por exemplo, alguém de data science ou contabilidade, pode querer colocar as teclas numéricas no formato de calculadora, como num teclado convencional grande, e isso pode ser feito numa das camadas extras. Eu tinha uma camada virtual somente com combinações de teclas pra Da Vinci Resolve, pra acelerar meu workflow de editar videos. O mesmo pode ser feito pra programar específicos como Photoshop ou Premiere.

<a name="treinamento" />
## Treinamento

Pra aprender, não tem outro jeito, precisa treinar, horas e horas, dias e dias. Ajustar as teclas em cada camada não é uma coisa que se faz uma só vez. É um processo. Você muda, começa a treinar e vê se realmente está numa posição adequada. Se não estiver, muda, regrava o firmware, e treina mais algumas horas. Até ficar bom pras suas mãos. Esse processo leva dias. Não tente só copiar layouts de outras pessoas. Use de inspiração, mas pense no seu uso particular.

E treinar não é usar 1 hora e acabou. Migrar de teclado staggered convencional, pra colunar, e com layout diferente, vai levar **no mínimo** 40 horas de treino. Se você vai dividir 8 horas de treino por 5 dias ou 20 horas de treino em 2 dias, não importa, mas ninguém consegue ficar bom em menos de 40 horas. Pra maioria das pessoas, pense mais em torno de 50 a **100 horas**.

Eu digo isso porque muitos usam só alguns minutos e já falam *"ah, isso não é pra mim, nunca vou conseguir".* Lógico, alguns minutos não é suficiente. Só depois de umas 10 horas você começa a sentir se quer ou não continuar, antes disso é pura frescura e preguiça. 

No começo, logo que migrei, não conseguia digitar mais que 20 palavras por minuto. Treinando mais de 20 horas em 2 dias, num fim de semana, consegui subir pra 70 palavras por minuto e ao final da primeira semana, consegui voltar à minha média antiga de 90 a 100 palavras por minuto (wpm).

E eu tenho mais de 40 anos. Não tem nada a ver com idade. Tem a ver com dedicação em treinar. Isso dito, como treinar? Recomendo os mesmos sites que todo mundo, começando pelo bom e velho [Monkey Type](https://monkeytype.com/).

{{< youtube id="ivWq2jwQOM0" >}}

Esse site é excepcional, dá pra treinar em quase todas as línguas do mundo. Em inglês dá pra treinar com vocabulário simples e evoluir pra dicionários de palavras bem mais avançadas, dá pra mudar o layout de teclado, cores, temas, tudo. Vale fuçar bastante as opções dele.

Outro site bem conhecido é o [KeyBr](https://www.keybr.com/) que é parecido com o MonkeyType mas não sei porque, parece que sempre vou mais lento aqui. Também tem bastante customização e vale fuçar. É bom quando estiver cansado de olhar pra cara do MonkeyType e quiser novos ares pra variar.

![keybr](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/5owpsnfs2vq75a3nm9k6651xifql)

E quando estiver se sentindo confortável (especialmente quando conseguir achar posições rápidas pra teclas de acento), experimente competir com outros usuários no bom e velho [Type Racer](https://play.typeracer.com/):

![Type Racer](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/mu5h5g2lez67fj6zzw1c1sb4qumv)

Diferente do MonkeyType e KeyBr, que não se preocupam tanto com textos que façam sentido e nem pontuação, aqui eles usam trechos de livros e artigos online. Então são trechos de textos de verdade. Também dá pra escolher diversas línguas diferentes. Inicia uma corrida, espera outros usuários aparecerem, e depois de uns 10 segundos já começa a competir.

![Type Racer Resultado](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/mlmhl8g24q3wr0wqdxgfh7d84gbl)

Em inglês normalmente se fala em WPM ou "palavras por minuto", que é uma métrica que eu não gosto muito, porque palavras em inglês são muito mais curtos que em português, então 100 wpm em português é muito mais rápido do que 100 wpm em inglês. Já o TypeRacer usa "CPM" que é "caracteres por minuto", que eu já acho mais justo. 

E mesmo assim, em português, parte dos caracteres requerem duas teclas, uma pro acento e outro pra sílaba. Uma palavra como "coração" tem 7 caracteres, mas precisou de 9 toques no teclado pra escrever. Lembrem-se disso se forem treinar mais em português.

Finalmente, existem vários jogos gratuitos pra navegador, em javascript, pra treinar digitação e na Steam tem dois jogos pagos que recomendo pra brincar:

[![Jogos Steam](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/n3wytx0g7tfs93kcpdm2vh952qu7)](https://store.steampowered.com/curator/24395108-Typing-Games/?appid=393330)

**Epistory** é bem bonitinho, uma aventura pra relaxar, dá pra crianças jogarem de boa e vai servir pra incentivar a aprender a digitar direito. Já o **The Typing of the Dead Overkill** é um clássico que tinha nos arcades japoneses (e tinha teclado no arcade!!) e teve versão pra Dreamcast, com um teclado pro console, feito pela Sega e agora dá pra jogar no seu PC. É levinho e divertido e tem muito gore, então não é pra todo mundo. Ambos são baratinhos, por isso recomendo.

<a name="solucoes-diy" />
## Soluções DIY

Infelizmente, teclados ortolineares, colunares, mecânicos no geral, são muito caros. Por isso já explico: não, usar um teclado desses não vai fazer ninguém digitar 10 vezes mais rápido, nem nada disso. É uma opção de conforto, você tem que se importar com isso pra investir. Se pra você um tecladinho genérico da Multilaser já atende, e não sente vontade de mudar, tá ótimo. Continue lendo só pra saber que existem opções, mas não se sinta mal por não estar mudando hoje. Quem sabe mais pra frente.

Pra quem realmente quer mudar mas quer gastar o mínimo possível de dinheiro, precisa gastar mais tempo pesquisando. Lógico, tudo que custa mais caro está embutido o preço da conveniência, já vem tudo montado, bonitinho, é só ligar e usar. Mas quem quer gastar pouco, tem que aprender a opção "DIY" (*Do It Yourself*) e montar o seu.

Faz algum tempo que eu recomendo as redes sociais do **Felipe/Tupinikeebs**, tanto no [X](https://x.com/neversaytop) quanto no [Instagram](https://www.instagram.com/tupinikeebs/). Ele manja tudo sobre montagem de teclados, sabe como e onde pedir todas as peças e, se pagar um extra, faz o serviço todo de encomendar, montar e te mandar já montado. Nas redes sociais dele dá pra achar tudo que é tipo de modelo diferente e exótico.

[![Tupinikeebs](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/lnwgh8q6ywg4w5maxmenpps4chkd)](https://www.instagram.com/tupinikeebs/)
Segue ele, dá uma pesquisada no que já postou, e se quiser encomendar, manda DM. O cara é gente boa. Não incomoda com bobagem, por favor, ele tem mais o que fazer.

![corne, hillside](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/71dok29u4vw25bxyuazu7sfy1pce)

Na foto anterior temos 3 modelos similares. Dois **Cornes** e um **Hillside** (que é tipo um Corne com espaço pra um Rotary, que é aquele cilindro que dá pra girar, como pra volume).

Os dois primeiros usam teclas de impressora 3D, acho que de resina na verdade, uma com perfil mais de Cherry, mais alto e gordo. O segundo mais low profile e fino. O terceiro são teclas Choc low profile comerciais mesmo. Apesar de todos serem bons, eu realmente prefiro teclas industrializadas, de preferência PBT double shot. Não entendeu nada? É porque não assistiu os videos do meu canal (!!)

Só o do meio fui eu que montei meio que do zero, o primeiro e o terceiro foram o Felipe quem me mandou. Você pode tentar assistir tutoriais no YouTube e pesquiser em sites como o [BoardSource](https://www.boardsource.xyz/products/Corne). Daí comprar diretamente todos os componentes pra montar. Tem que ficar de olho porque nem sempre tem estoque de todos os componentes.

O primeiro e segundo Corne da foto acho que usam o controlador **Nice!Nano 2.0** e o terceiro, o Hillside, usa controlador **RP2040**, que é mais novo e mais avançado. Eu não sou especialista em todos os modelos, mas isso é importante porque varia o tipo de firmware que suportam. Modelos mais parrudos aguentam firmwares mais complexos, com mais customizações. Por isso é bom pesquisar a respeito. O Hillside, por exemplo, tem os rotary, daí precisa ter suporte a tecla que rotaciona.

Quando faz clone do projeto **QMK Firmware** do GitHub, tem um diretório "keyboards" com todos os modelos conhecidos. No meu caso, fui em "keyboards/hillside/48/keymaps/akitaonrails" e editei o "keymap.c" pra ter este trecho:

```c
/* The encoder_update_user is a function.
 * It'll be called by QMK every time you turn the encoder.
 *
 * The index parameter tells you which encoder was turned. If you only have
 * one encoder, the index will always be zero.
 *
 * The clockwise parameter tells you the direction of the encoder. It'll be
 * true when you turned the encoder clockwise, and false otherwise.
 */
bool encoder_update_user(uint8_t index, bool clockwise) {
  /* With an if statement we can check which encoder was turned. */
  if (index == 0) { /* First encoder */
    /* And with another if statement we can check the direction. */
    if (clockwise) {
      /* This is where the actual magic happens: this bit of code taps on the
         Page Down key. You can do anything QMK allows you to do here.
         You'll want to replace these lines with the things you want your
         encoders to do. */
      tap_code(KC_PGDN);
    } else {
      /* And likewise for the other direction, this time Page Down is pressed. */
      tap_code(KC_PGUP);
    }
  /* You can copy the code and change the index for every encoder you have. Most
     keyboards will only have two, so this piece of code will suffice. */
  } else if (index == 1) { /* Second encoder */
    if (clockwise) {
      tap_code(KC_UP);
    } else {
      tap_code(KC_DOWN);
    }
  }
  return false;
}
```

O código não é importante agora, só pra vocês terem uma idéia. Isso foi neste caso específico. Na maioria dos casos mais simples, só precisa editar um JSON, e ajuda ter um editor visual como o **QMK Configurator** via Web que falei antes. Daí coloca o JSON no diretório do seu modelo de teclado e segue a documentação pra compilar o binário do firmware. Não quero ter que explicar passo a passo aqui, mas tem tutorial em todo lugar, depois dêem uma fuçada no Google e YouTube.

Na dúvida, hoje em dia acho que o padrão é comprar [Pro Micro](https://pandakb.com/products/parts/others/promicro-nrf52840/) e só se não tiver o [Nice!Nano v2.0](https://nicekeyboards.com/nice-nano/). Esses chips são o que na foto aparecem no centro de cada teclado. É onde fica o cérebro que controla tudo, onde se conecta o cabo USB e o cabo de áudio P1 que conecta as duas metades. Também é onde se ligaria Wi-fi e bateria em alguns modelos. Aí faz mais diferença porque quanto mais potente, mais bateria gasta, menos tempo dura. Então precisa balancear se realmente precisa do chip mais potente.

![Controlador Nice!Nano](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/cgdxylg28aexie1wk6xpvtg2hiwo)

Olha o meu acima, é wireless, e tem bateria pequena instalada embaixo, acho que é uma Nice!Nano. O acabamento dos fios não ficou grande coisa. Está usando tanto switches Choc quanto teclas low profile estilo Choc, são lineares red, bem finos. Tem gente que prefere um teclado mais alto, eu prefiro mais baixo quanto possível.

![case impressão 3d mais grosso](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/3vrmkf4dxd51zn9hj34sg6r2w1g4)

Olha essa que o Felipe montou pra mim, com case feito em impressora 3D, bem mais grosso, com switches e teclas de tamanho normal, bem mais alto. O certo é ter apoio de pulso ou acostumar a digitar sem encostar os pulsos na mesa, senão vai dar tendinite rapidinho com essa altura. E tem esses dois buracos na direita onde dá pra colocar parafusos altos, pra fazer "tenting", que nem expliquei no Moonlander. Então é boa opção pra quem não quer ou não pode pronar os pulsos (que é justamente onde "pinça" o nervo e dá tendinite).

![hillside de perto](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/itiib5ic6pyv5w97566ya6bre7wc)

Essa Hillside, na verdade, tinha vindo com as teclas low profile pretas. A minha de antes era que estavam com as teclas brancas low profile Choc, mas fiquei trocando pra experimentar (maus Felipe!! kkkk). Na real, esse conjunto de teclas brancas são as que mais gosto. Note o case mais "lean" roxo que o Felipe fez pra esse board, e o principal, o botão giratório rotary. Dá pra programar pra muita coisa, no momento é só volume, mas acho que dá pra customizar em apps como Photoshop ou edição de video e coisas assim. Eu mesmo não cheguei a tentar, mas pra quem tem essa necessidade, é uma ótima opção.

<a name="ortolineares-gk6" />
## Ortolineares - GK6

Moonlander, Corne, Hillside e outros são todos teclados colunares, staggered, e split. Eu recomendo fortemente acostumar a usar split. Primeiro porque não precisa aproximar as duas mãos, elas podem ficar afastadas, que é o mais natural.

Segundo, pra aprender a fazer cada mão usar as teclas corretas de cada metade, sem uma mão ficar invadindo a metade da outra. Novamente, faz parte do treino forçar isso. É outra vida quando cada dedo aprende a usar a tecla certa. Muito menos esforço, muito menos cansaço, muito menos dores e ainda aumenta velocidade e diminui quantidade de erros. Só tem vantagem.

Na época que fiz meu video, só tinha um modelo ortolinear que era razoável, o **Planck**. Planck acho que é o nome do layout, mas tinha mais de um fabricante, como a Drop (antiga MassDrop) e a própria ZSA.

{{< youtube id="TYTnjGOQrdU" >}}

Se quiser comprar as peças separadas pra montar você mesmo, compre a versão [Drop + OLKB](https://drop.com/buy/planck-mechanical-keyboard?defaultSelectionIds=988297). E acho que vai ser a única opção porque a ZSA anunciou em Agosto de 2023 que [vai parar de fabricar os Planck EZ](https://blog.zsa.io/2307-goodbye-planck-ez/), o que é uma pena. Parece que não vendia o suficiente pra justificar continuar fazendo.

A única vantagem dele frente aos outros que mostrei até agora, é a **mobilidade**. Ele é todo de plástico. É muito bem feito e bem construído, não tem cara de plástico barato. Mas por isso é bem leve, e super compacto. De dimensões, se compara a um Nintendo Switch, só mais grosso. Então é muito fácil de carregar numa mochila.

Assim como seu irmão maior, o Moonlander, mas diferente dos Cornes e outros modelos mais baratos, o Planck EZ tinha LEDs coloridos em cada tecla. Parece bobagem, mas agora que você entendeu que dá pra configurar diversas camadas, imagine como é mais intuitivo de encontrar o que procura se, quando apertar um modificador como o "MO(1)", acender em cores customizadas que te ajudam a lembrar o que era o que.

Por exemplo, no video acima, dá pra ver uma camada que acende parecendo uma calculadora. Veja como acendem embaixo dos 9 números principais, daí 3 teclas na direita e 3 na esquerda com funções como adição, multiplicação, etc, igual à configuração que fiz no Oryx abaixo, entenderam a utilidade?

![Oryx, calc](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/en1vwj0ukc98fvddja8jgnzijsxz)

O problema é que uma vez que se acostuma com split, voltar pra um monolito como esse é muito chato. Trazer as mãos pra perto e ter que angular os pulsos é cansativo. É exatamente o cansaço que se tem todo dia num teclado convencional. Seus pulsos não foram feitos pra serem nem dobrados e nem rotacionados. Um teclado convencional faz exatamente tudo que seus pulsos odeiam.

**A solução é tenting e split**. Mesmo se tenting ocupar muito espaço, no mínimo split já vai fazer muita diferença. Mas enfim, existe esse meio do caminho entre teclado convencional e teclado colunar, que não exige se acostumar ao split logo de cara. É esse layout **ortolinear**, que é um colunar não-staggered, ou seja, onde linhas e colunas estão perfeitamente alinhadas, ortogonais e alinhadas (orto-linear, entenderam?), sem levar em consideração o diferente comprimento de cada dedo.

Nessa categoria existem dois modelos que gostei muito. O primeiro é da [Gizmo Engineering, o GK6](https://www.gizmo.engineering/). No meu caso, o modelo Imperial Panda. Todo fã de anime dos anos 2000 gosta do esquema de cor de Panda, como em Initial D.

![Moonlander vs GK6](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/xifzigq5wf3c1h1ykwo31co4bcy5)

Na foto coloquei embaixo do Moonlander, pra demonstrar o que falei antes: uma das desvantagens do Moonlander é ser um trambolho na mesa, e não é exagero. Agora, esse GK6, é extremamente bem construído, uma obra de arte na mesa.

O case dele é um unibody de alumínio, nível Apple de qualidade. Internamente tem espuma pra "dampening" do som (não vir aquele "ping" oco), as teclas são de extrema qualidade, dá pra sentir nos dedos a diferença. Cada posição de switch na placa mãe tem LED RGB. O único problema é que esses materiais todos são pesados. No final o teclado tem mais de 800g, **quase 1 quilo**, e dá pra sentir. Pra carregar na mochila já dá pra sentir bem mais pesado. É quase o dobro do peso do antigo Planck EZ que era quase todo de plástico.

Em termos de layout, comparado com o Corne que é 40%, este é 60%, tem 59 teclas, porque a barra de espaço ocupa dois espaços - dá pra tirar o estabilizador e dividir em duas teclas, se quiser. A diferença principal pro Corne é que tem uma linha a mais no topo, a linha de teclas numéricas. Pra quem está acostumado a usar teclados **Tenkey-less** (teclado convencional sem teclado numérico, como da maioria dos notebooks), tende a não ter tanto problema pra se adaptar a este layout.

![GK6 close up](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/x7d1hlkksi7an3i4iyl2eb4o657r)

É possível usar assim, mas recomendo mudar as teclas de lugar. Como um bom teclado moderno, o GK6 tem firmware que podemos customizar. Está tudo documentado [nesta página](https://www.gizmo.engineering/firmware) no site deles e, claro, é baseado em QMK, então podemos mudar coisas que não fazem sentido, como o "backspace" que fica no canto superior direito e jogar, por exemplo, pra uma das teclas do dedão, economizando seu mindinho direito. Tem gente que não gosta de fazer isso, mas recomendo tentar. Mesma coisa o enter/return, mudar pra um dos dedões.

O maior problema do GK6 é que sempre está fora de estoque, e o preço é bem salgado: USD 250, sem contar transporte nem impostos. Tem várias cores muito boas pra escolher, então, fiquem de olho pra quando voltar o estoque.

![GK6 bottom](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/zjhjrzuvtd4azlf61v613oi7me0u)

Sério, olha essa foto, a traseira deste teclado é mais bonita do que a frente da grande maioria dos teclados comerciais. Isso é unibody de alumínio com o nome do teclado esculpido em relevo baixo.

<a name="ortolineares-q15" />
## Ortolineares - Q15

Mas se não tem paciência e tem dinheiro sobrando, sempre tem a opção da **Keychron**, que se estabelece com a marca de teclados com a maior variedade de todas. Pense num estilo, eles tem. De todos os tamanhos, de todas as qualidades, mas todos muito caros. Pelo menos, sempre costuma ter estoque.

E na linha ortolinear, temos que ver o [Keychron Q15 max](https://keychronbrasil.com.br/products/keychron-q15-max-qmk-teclado-mecanico-custom-wireless) que tem no Brasil mas está a bagatela de nada menos que R$ 2.229,00, quase USD 400 dólares. É BEM caro.

![Keychron Q15 Max](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/dkrgad9ki9irl5v51erlbff2q3h3)

Mesma coisa, comparando o tamanho com o monstruoso Moonlander. Mas veja que também é compacto. Em termos de dimensões é muito próximo do Gizmo GK6. Mas muito mais pesado, em vez de 800g, esse tem **1.2 quilo**. É 50% mais pesado e dá pra sentir carregando. Este, definitivamente seus ombros vão chorar quando carregar na mochila. É literalmente o peso de um Macbook Air inteiro!

Ele é mais caro e mais pesado porque realmente tem muito mais material. Faz o GK6 parecer teclado de hobbista. Também tem case em unibody de alumínio, múltiplas camadas, design double-gasket, espuma de dampening, camada de latex, etc. Olha isso, direto do site deles:

![Q15 layers](https://cdn.shopify.com/s/files/1/0578/7815/1346/files/Q15-Max-structur.jpg?v=1723147312)

Além disso tem **dois rotary**, um em cada canto superior, que nem o Hillside que o Felipe tinha montado pra mim, mas este tem acabamento bem profissional. Serve não só pra controlar volume, mas é muito desejável em workflows de Photoshop, Premiere, Da Vinci Resolve. Toda vez que precisar lidar com timelines, gradientes, coisas que modificam ranges de valores com precisão. Pra isso esses rotary são muito melhores do que só mouse ou combinação de teclas.

![Q15 close up](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/4oja3or2pjk97ex482s7a8dont6k)

Além disso, notem como tem teclas duplas e triplas. Ele vem com teclas extras, e essas teclas maiores tem estabilizadores, dá pra tirar e dividir em mais teclas menores. Dá pra customizar de vários jeito diferentes e, pra variar, também tem firmware baseado em QMK e um aplicativo visual pra ficar mais fácil de mudar o layout só com mouse, em vez de ter que editar um arquivo JSON.

![Q15 bottom](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/t0wr29gfjxsw0av8vjd9tkh6l7z5)

Eu elogiei a traseira do GK6, mas o Q15 Max não fica atrás. Novamente, unibody de alumínio. Parafusos de bronze, se não me engano. Textura impecável. É uma obra de arte também. E dá pra ver a grossura extra desse teclado, é um pouco mais alto no topo, então é um pouco inclinado em vez de totalmente reto com o GK6. Este teclado já começa a exigir um apoio de pulso.

Agora, esse peso todo, e tantas camadas, também resultam num som muito mais encorpado e robusto, ouçam só:

{{< youtube id="l-dLYSNyDKk" >}}



Ouviram o barulho do peso do Q15 no chão? E conseguem entender a diferença nos sons? O Q15 não ecoa nada, o "dampening" dele é muito bom. O som é grave e encorpado. O GK6 também é muito bom, mas tem menos camadas. Em comparação dá pra sentir um pouquinho de eco no fim. Já os últimos dois são mais ocos por dentro, sem espuma, com materiais menos robustos, aí já tem um barulho um pouco mais agudo e ecoado. O ideal é o som do Q15. Nenhum deles é particularmente ruim, mas o Q15 é superior mesmo.

<div class="video-container">
<video controls preload="auto"> <source src="https://cdn.shopify.com/videos/c/o/v/8f053eebc79f4e07a923e477e38d04d0.mp4" type="video/mp4"> Your browser does not support the video tag. </video>
</div>

O exemplo acima é do próprio site da Keychron, mostrando como eles tem um aplicativo visual pra editar os layouts, parecido com o Oryx da ZSA também. Apesar de ser bom ter a liberdade de fazer o que quiser no nível da linguagem C com o QMK, pra teclados, eu realmente prefiro que exista uma opção visual assim. Nem todo mundo que vai comprar é programador e vai saber configurar terminal, python, git, etc. O ideal é ter as duas opções, mas o default ser plug-and-play, só plugar na USB, o aplicativo sobe o firmware e já era.

<a name="voyager" />
## Meu Melhor Teclado - Voyager


Apesar de todos os elogios que vim fazendo a todos os teclados anteriores, eu não uso nenhum deles hoje em dia. Na verdade, recebi o Q15 Max e não tinha nem tirado da caixa até ter que tirar as fotos pra este artigo. Um dos problemas desse tipo de teclado é que já me acostumei ao meu layout, com minhas próprias camadas customizadas, então todo novo teclado, preciso passar pelo cansativo processo de editar layouts tudo de novo. Aí não tive paciência e acabei nem usando.

Se nenhum dos modelos comerciais existisse, o teclado ideal seria alguma variação de Corne. São pequenos e compactos, não ocupam quase nenhum espaço na mesa. Somado a switches e teclas Choc, ficam bem low profile. O PCB (placa controladores) não exige uso de case, pode ficar direto na mesa porque não tem nada embaixo que dá curto. Isso o torna  extremamente "flat" na mesa, não precisando usar nenhum tipo de apoio de pulso.

Além disso, é colunar staggered, que leva em consideração comprimento diferente dos dedos, e é split, que permite deixar as duas mãos bem separadas, evitando rotações desnecessárias. Finalmente, é totalmente customizável via QMK, onde posso colocar todas as camadas do jeito que eu quero. Ou seja, é o teclado perfeito.

Mas a ZSA, fabricante do descontinuado Planck EZ e do monstruoso Moonlander, resolveu criar um novo modelo, o [Voyager](https://www.zsa.io/voyager). Eu acho que muito desse modelo veio do feedback de pessoas com o Ben Vallack. Sério, maratonem os videos do canal dele onde mostra passo a passo a pesquisa que fez pra determinar como o teclado perfeito deveria ser. E até vai além do ponto, ao extremo de criar um teclado com nada menos do que míseras 18 teclas (!!) 

Não é prático, mas é ultrapassando os limites que sabemos onde está o limite:

{{< youtube id="c18vkHG_7tY" >}}

Ele começou a fazer os protótipos usando o Moonlander como base, removendo teclas, fazendo experimentos. E chegou à conclusão que o Moonlander seria ainda mais ergonômico e muito mais produtivo se fosse muito menor e com muito menos teclas. E a ZSA ouviu.

![Moonlander vs Voyager](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/wr7r2w8spl4kitmtr8oyg3si21tw)

Ele tem mais ou menos as mesmas dimensões do GK6 ou Q15, mas em formato "split", dividido ao meio, o que possibilita mais flexibilidade e ergonomia. Note que a cor branca vai encardindo com o tempo. Ainda não sei o que é melhor pra limpar, mas o meu já está amarelando de tanto usar. Recomendo comprar a versão preta. 

O Voyager é o Moonlander 2.0, um Corne comercial. É um pouco maior do que um Corne 40% porque tem a linha superior numérica. Eu acho que nem precisaria, mas não chega a atrapalhar. Ao contrário do meu Corne montado de forma caseira, o Voyager é "slick", com cara de algo que a Apple construiria. Plásticos duros de alta qualidade, placa de metal atrás dando suporte, peso e rigidez, mas sem aumentar demais o peso total. Espessura fina, usando switches e teclas low profile, parecidas com as Choc que falei que gosto, e ainda com LEDs RGB em cada tecla. Tem tudo que gosto no Corne e mais um pouco.

Claro, assim como tudo nessa categoria, o Voyager também é bem caro. USD 365, sem contar transporte nem impostos. É a mesma faixa de preço do Q15 Max. Por isso falei: se preço menor for importante, um Corne montado manualmente faz a mesma coisa, e pode custar metade do preço ou menos! Falem com o Felipe!

Em comparação com o Corne, tem 2 teclas a menos em cada thumb-cluster. Isso foi um pouquinho chato no começo de me acostumar, mas hoje eu acho que foi a decisão certa: cada dedão não precisa de mais do que duas teclas. Este é um caso onde limitações são libertadoras. O senso-comum diz que ter mais teclas é melhor, mas os dedos precisam se mexer mais e é mais fácil de errar.

Isso vale a pena explicar. Vamos revisar o layout do meu Corne:

![camada 0 thumb cluster](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/hfnc3l660frcoayvq8oiz110h1kd)

Aqui cada dedão precisa lembrar a posição de 3 teclas. As mais usadas são backspace e barra de espaço, por isso coloco mais na ponta. Assim eu sempre sei que precisa esticar o dedão e nunca vou errar. Já "delete" e "enter¨ se usa um pouco menos, deixo no meio, onde é só abaixar o dedão, sem esticar. Era assim que eu usava no Moonlander, Planck, Corne e outros.

Mas o Voyager só tem 2 teclas em cada dedão, como faz?

![oryx camada 0](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/r0jooa947kshzk2gc35wphqlem2m)

Esta é a camada 0 (zero) do meu Voyager. Tem só backspace e espaço nas teclas maiores do thumb-cluster, mas note que acima tem as teclas "hold", que é a mesma coisa que o "MO(1)" e "MO(2)" do QMK, lembram? Servem pra deixar apertado e mudar pra outra camada virtual. Se apertar esse "hold 1", vai virar o seguinte:

![oryx camada 1](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/gn29nzx8jwsoakjf3em29d3dxg2t)

Agora sim, com o "hold 1" apertado na esquerda, posso apertar "enter" com dedão direito. 

![oryx camada 2](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/05xfa8qfyjt7hpebv6ru9rmyxkf0)

Por outro lado, se deixar apertado "hold 2" com dedão direito, agora o backspace vira "delete" na esquerda. E com isso as mesmas funções estão disponíveis, mesmo tendo fisicamente menos teclas. É só aprender isso de camadas.

Mais do que camadas, tem coisas não uso tanto, com *"tap-to-hold"*. Você Dá pra apertar rápido uma vez e depois segurar a mesma tecla, e isso dá gatilho em outro evento. No caso da ferramenta de configuração Oryx, da ZSA, tem opções de configurar o que acontece só quando aperta e tira o dedo (*"held"*), ou quando aperta rápido duas vezes (*"double-tapped"*), ou quando aperta rápido uma vez e aperta de novo (*"tapped and then held"*) e deixa segurando. Ou seja, dá pra configurar no mínimo **3 ações diferentes em cada tecla, em cada camada, e dá pra ter múltiplas camadas!** São centenas de opções!

![Oryx Voyager](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/qou3zcgjw79mawagyatme0b0mbc2)

Assim como a Keychron, a ZSA também tem um aplicativo visual via web. É muito mais cômodo do que editar um arquivo JSON. Ele tem já embutido botão pra compilar o firmware e, quando conectar seu teclado no modo de upload, o navegador consegue detectar e é plug-and-play pra subir o firmware. Não precisa instalar nada extra na sua máquina. É esse tipo de poimento comercial que uma opção mais barata como Corne não vai ter. O mais próximo é o QMK Configurator.

E diferente do Corne, o Voyager também tem LEDs RGB. Tá vendo no Oryx como tem opção de *"set color"*? Assim fica muito mais fácil pra lembrar onde que tá qual tecla, em qual camada. Até pra saber em que camada estamos neste momento. Muito melhor do que ter que memorizar tudo e não ter feedback nenhum. Acho muito importante o hardware ter alguma forma de comunicar seu estado atual.

Portanto, a experiência do software me faz querer experimentar mais com o Voyager ou Moonlander do que o GK6 que é QMK puro, por exemplo.

![Voyager close up](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/ss2jz5lwpi19mwivpxj0mq4iqhkv)

Novamente, olhem na minha mão como é fino. Cada metade tem pouco mais de 200g. Com os cabos, o total é menos de **700g**. É próximo do GK6, metade do Q15, mas parece ainda mais leve. O balanço do peso é muito bom.

![Voyager bottom](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/dco0ukkdnhi17i4y77x6mk80kbhp)

A traseira do Voyager não chega a ser tão elegante quanto do GK6 ou Q15, mesmo assim é bonito o suficiente e funcional, uma vibe mais industrial, com metal e parafusos à mostra e pontos de montagem pra anexar em suportes, caso queira usar em tripé, braço de cadeira ou em "tenting". Eu não tentei nenhuma dessas opções, prefiro reto na mesa mesmo.

Mas tem [sub-reddits](https://www.reddit.com/r/ErgoMechKeyboards/comments/17fwd57/zsa_voyager_tenting_experiment/) com projetos de impressão 3D e coisas assim pra quem quiser experimentar tenting no Voyager. Veja um exemplo de lá:

[![Voyager tenting](https://preview.redd.it/zsa-voyager-tenting-experiment-v0-kdfxc7d4x9wb1.jpg?width=640&crop=smart&auto=webp&s=5615ebece5db23212ce5fda464039f6847cfcfc9)](https://www.printables.com/model/597882-zsa-voyager-stand)
Tem esta outra opção usando um tripé chamado ["Manfrotto"](https://preview.redd.it/voyager-tenting-with-manfrotto-pocket-tripods-v0-49xxqiada5sb1.jpg?width=640&crop=smart&auto=webp&s=bb095a3a9c18da455e661400e082e0cbaff513f3):

![Manfrotto tripod](https://preview.redd.it/voyager-tenting-with-manfrotto-pocket-tripods-v0-49xxqiada5sb1.jpg?width=5712&format=pjpg&auto=webp&s=cac876389d4ff94206b6b120446a90ae260db688)

Essa é uma opção que me vejo usando. E tem [mais opções](https://www.reddit.com/r/ErgoMechKeyboards/comments/16k7p4x/voyager_tenting/). Eu gosto de tenting, é a única coisa que só o Moonlander faz de fábrica. Eu sentiria mais falta se ainda precisasse digitar muito todos os dias, mas como não preciso mais, prefiro o Voyager puro pra ser mais bonito e ocupar menos espaço na minha mesa.

![minha mesa com voyager](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/ducayps3ys884gq2hucn7nl19ppf)

Esta é minha mesa em Outubro de 2024 e como tem sido por pelo menos 1 ano. Eu troco por outros teclados pra testar, mas sempre acabo voltando nesta configuração, por tudo que já expliquei antes. Eu uso o mouse na mão esquerda (porque minha mão direita dói mais, então me acostumei a usar com a esquerda pra doer os dois igual kkkk). Tenho um Apple Touchpad na direita pra coisas que exigem "scrolling" (dói muito menos do que "scroll-wheel" de mouse). E note como uso as duas metades do teclado bem afastados. Essa é uma distância boa, mas dá pra abrir bem mais se quiser.

<a name="pulso" />

## Ortolinear vs Colunar

Pra ficar claro, achei melhor ilustrar o que significa esse papo todo de pulso. Veja como ficam suas mãos num teclado de uma única peça, um monolito:

![pulso rotacionado](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/44ia6l5v13w8z5wz9vyhi8hda0c4)

Está claro? Quando o teclado não é split, somos obrigados a trazer as duas mãos super pra perto. Obviamente a única forma de posicionar assim é dobrando os pulsos de uma forma não-natural. Somado à rotação (por não ser tenting), estamos pinçando os nervos e causando micro-lesões, todas as vezes.

Sim, pra quem usa pouco, esporadicamente, não faz diferença mesmo. Isso é pra nós, programadores, escritores, pessoas que digitam horas seguidas. Se você não for essa pessoa não me venha comentar *"ain, eu não sinto isso"*. Lógico, você digita pouco. 

![voyager, perto](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/8aab5kmzzyym6wr1dq4q8j365d8y)

Se a intenção for construir um teclado monolito pelo fato de ser mais fácil de carregar na mochila ou algo assim, no mínimo, as duas metades deveriam estar num ângulo, como na foto acima. Dessa forma as mãos teriam que continuar próximas, mas não seria necessário dobrar os pulsos.

![Voyager, afastado](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/rpe3wdfjduwim2aihulb2pf8sb4h)

Claro, o ideal é split: duas metades que podem ser afastadas. Assim seus braços podem permanecer numa posição natural, reta, sem precisar dobrar nada, sem fazer esforço desnecessário. Isso permite ficar horas digitando sentindo pouca ou nenhuma dor. Se somar a um suporte embaixo, pra elevar o meio do teclado, criando tenting, aí sim, os braços ficam na posição mais neutra possível. E é por isso que eu prefiro este tipo de teclado: **split-colunar-staggered**.
<a name="framework" />
## O Futuro - Framework

Este artigo foi só porque eu estava com esses teclados parados aqui. E não, não adianta mandar no comentário pra sortear, vender, nem nada disso. São parte da minha coleção, eu deixo na minha prateleira porque acho bonito e posso usar quando der na telha. Não vou me desfazer de nenhum. Não insistam!

Mas se tem uma coisa que me frustra são notebooks. Nenhum tem opção ortolinear. Então sempre preciso conectar um externo via USB ou então digitar mais devagar usando o layout convencional. Mas minhas esperanças aumentaram quando surgiu a empresa Framework.

<div class="video-container">
<video controls preload="auto"> <source src="https://customer-gbu4wsrjcdamtxzc.cloudflarestream.com/864433f3f504c98ddc2d5837b4f081f9/downloads/default.mp4" type="video/mp4"> Your browser does not support the video tag. </video>
</div>

Eles só tem dois modelos, o Laptop 13 e o Laptop 16. Meu ideal seria um 14" com formato 3:2 como os Surface, mas o de 13" é mais que suficiente. Eu conheci eles pelo canal **Linus Tech Tips**, pois o Linus Sebastian se tornou um dos primeiros patrocinadores/sócios do projeto.

A ideia parece simples, mas até hoje ninguém conseguiu fazer algo que não só funcione, mas dure anos. Esse laptop é todo modular. E não só nas coisas triviais como trocar uma porta HDMI externa por uma porta Ethernet ou USB 4. Mas também fazer upgrade de memória, e até de placa-mãe, GPU, monitor e ... teclado!!

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Jack at <a href="https://twitter.com/OrtholinearKB?ref_src=twsrc%5Etfw">@OrtholinearKB</a> prepared a mockup of an ortholinear keyboard module for the Framework Laptop 16! Modularity opens up some incredible possibilities. <a href="https://t.co/hKqT3AMU7t">pic.twitter.com/hKqT3AMU7t</a></p>— Framework (@FrameworkPuter) <a href="https://twitter.com/FrameworkPuter/status/1648371892062130176?ref_src=twsrc%5Etfw">April 18, 2023</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

Olha só isso. Parece que já faz pelo menos um ano que estão trabalhando numa opção ortolinear! Isso seria meu sonho de consumo! Um teclado de notebook não é mais que um teclado com USB interno. Deveria ser simples de trocar, é mais uma questão de design industrial do que de tecnologia.

Eu estou quase já comprando um Framework Laptop 13 quando for pros EUA este ano, e quando sair o teclado, posso importar só ele (vai custar impostos, óbvio, mas pelo menos vai ser só o teclado). Aí eu terei o notebook definitivo pra digitadores profissionais!!

Esta é a última coisa que falta. Espero que realmente lancem logo e inspirem outros fabricantes a pensar em opções assim: destacáveis e modulares.

Como expliquei nos meus videos, em particular no primeiro video da trilogia, até hoje usamos layouts de teclados absolutamente ruins pras nossas mãos, pulsos e braços. Muitos que trabalham o dia todo digitando vão sofrer com LER e tendinite, mais cedo ou mais tarde. Tudo porque todo mundo tem preguiça de aprender coisas modernas.

Todos acham que é muito difícil, mas é só **preguiça** mesmo. Eu aprendi com mais de 40 anos. Não precisa ser um adolescente pra aprender essas coisas. É só parar de achar que não vai conseguir e fazer, sem pensar nas consequências. Melhor: se conseguir, a consequência é que vai digitar mais rápido, com menos erros e sem forçar suas mãos, evitando dores e doenças ortopédicas.

A Apple, o ápice do que usamos como referência quando pensamos em tecnologia moderna, só tem uma parte que tem fedor de velho: o teclado. Se ela fosse realmente corajosa, como Phil Schiller achava que era, o Macbook tinha que ser assim:

![Macbook Ortolinear](https://preview.redd.it/concept-ortholinear-apple-silicon-macbook-pro-v0-kw2duliaxrea1.png?width=2440&format=png&auto=webp&s=e899a4e2029b24620ecb3c34a1d0ab03ad7dda97)

Isso sim, seria um Macbook do século 21, deixando as limitações do layout de máquina de escrever do começo do século 20 pra trás. Por agora, já me dou por satisfeito com meu ZSA Voyager, que é meu "daily-driver" e faz tudo exatamente do jeito que preciso. Não pretendo descer abaixo dos 40% e ficar fazendo malabarismo. 

![Coleção](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/015nq7sqccm833ttzeqymrbxe3j8)

Eu falei de "Corne", mas é só porque é o nome mais popular. Falei que o Felipe me fez um Hillside que é um Corne com rotary, mas existem dezenas de variações como Lily58, Skeletyl, CRKBD, Scylla, Sofie, Totem e muito mais. 

Sabe onde consegue ver várias delas? No perfil de Instagram do amigo [Felipe/Tupinikeebs](https://www.instagram.com/tupinikeebs/). Ele sempre posta um *keeb* novo por lá, então fique de olho, leve em consideração tudo que falei sobre tamanho, peso, mobilidade, bateria, layouts, 60% vs 40% vs 30%, tenting, split, e encontre a combinação que faz mais sentido pro seu uso particular.

Modelos diferentes existem porque cada pessoa tem usos diferentes. Um escritor de livros é diferente de um programador que é diferente de um contador que é diferente de um cientista de dados e assim por diante. Não existe um teclado universal que funciona perfeitamente pra todo mundo. Sem contar a estética, cores, RGB, tipos de switch, materiais de teclas, etc. Não seja limitado, seja aberto às opções.

Novamente, praqueles que vão insistir em comentar sobre o lendário **Kinesis**, ele é diferente de todos que já mostrei. Eu sei. Tem o formato de uma bacia no centro de cada metade, É uma outra forma de otimizar pra comprimentos diferentes em cada dedo. Em vez de Corne, o que vocês querem é o **Scylla**. Adivinha quem já postou sobre isso? O Felipe:

[![Scylla](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/ch3u7epuje0xfk395jikxi95jijy)](https://www.instagram.com/p/DBHSdDrR_bR/?utm_source=ig_web_button_share_sheet&igsh=MzRlODBiNWFlZA==)
E por hoje é isso aí, espero que tenham gostado. Não deixem de assistir os videos da trilogia onde explico muito mais detalhes de tudo isso. Só depois pensem em mandar perguntas nos comentários!
