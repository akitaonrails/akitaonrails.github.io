---
title: "[Off-Topic] Dicas de Mac para Palestrantes"
date: '2010-10-31T00:32:00-02:00'
slug: off-topic-dicas-de-mac-para-palestrantes
description: "Para evitar problemas no palco, o autor recomenda testar projetor, cores, slides, áudio e bateria, usar um controle USB confiável, desligar redes e gravar demos em vez de depender da internet."
tags:
- comunicacao
- apple
- off-topic
draft: false
---

Em todo evento que eu vou, vejo alguém sofrendo com alguma configuração de Mac na hora de apresentar. Já é hora de compilar algumas dessas dicas.

![](http://s3.amazonaws.com/akitaonrails/assets/2010/10/31/Screen%20shot%202010-10-31%20at%2012.30.53%20AM_original.png?1288492285)

Se você faz palestras, isso aqui pode ajudar bastante.


## Monitores e Projetores

A primeira coisa: Macs não têm aquela tecla de função (tipo fn + F4) dos notebooks PC. Basta conectar o adaptador VGA/DVI e o OS X detecta o segundo monitor automaticamente, já configurando tudo.

Esse segundo monitor funciona de duas formas: independente, com resolução própria, ou em espelho (“mirror”), repetindo o que está no monitor principal. O modo independente é melhor para slides. O espelho é melhor para demonstrações ao vivo.

Ele também pode ser tela primária ou secundária. A diferença é qual delas fica com a barra do topo do Mac. Tudo isso se configura em “System Preferences” ➔ “Displays” ➔ “Arrangement”.

![](http://s3.amazonaws.com/akitaonrails/assets/2010/10/30/MirrorDisplays_original.jpeg?1288489269)

Na imagem acima, o modo espelho está habilitado. Clique em “Mirror Displays” para desligar. Se aparecerem duas telas independentes, você troca o monitor primário arrastando a barra branca do topo de uma para a outra. É essa barra que define o primário.

Tem também o “Gather Windows”. Com um segundo monitor, o Mac abre uma janela de preferências para cada tela, para você ajustar resolução e cor de forma separada. Às vezes essa segunda janela fica inalcançável; clicando nesse botão, as duas voltam para o mesmo monitor.

Quando os monitores não estão espelhados, dá para controlar a resolução de cada um separadamente. O ideal costuma ser manter o primário no notebook e o secundário no monitor externo. E vale lembrar: a maioria desses projetores baratos de mercado suporta só até 1024×768.

Agora um truque. Esses projetores em geral vêm preparados para PC, e o perfil de cor do PC e do Mac pode ser diferente. Um efeito comum é o Mac aparecer mais escuro e com menos contraste, o que atrapalha na hora de ler texto em fundo escuro. Para corrigir, mexa no Color Profile.

Na mesma janela, ao lado de “Arrangement”, tem a aba “Color”. Desmarque “Show profiles for this display only” e procure o perfil **“sRGB IEC61966-2.1”**. Ele costuma clarear as cores da projeção e deixar tudo mais legível. Se não resolver, teste outros perfis.

![](http://s3.amazonaws.com/akitaonrails/assets/2010/10/30/ColorProfiles_original.png?1288489652)

Perfil de cor não é assunto trivial. Até o Mac OS X 10.5 Leopard, a correção Gamma era 1.8; a partir do 10.6 Snow Leopard passou a ser 2.2, igual ao Windows.

Fora isso, imagens bem feitas costumam trazer o próprio perfil de cor, e o Mac sabe transicionar de um perfil para outro corretamente. Esse [artigo de suporte](http://web.archive.org/web/20101205233628/http://support.apple.com/kb/HT3712) da Apple explica melhor.

Por fim, os técnicos costumam alinhar a projeção usando um PC. Isso é péssimo. Peça para alinharem com um Mac. Faz diferença: mal calibrado, parte do seu slide acaba saindo para fora da tela.

## Apple Keynote

Muita gente usa Mac justamente por causa do Keynote, do Apple iWork. Para mim é de longe o melhor software para montar apresentações de qualidade, deixando no chinelo qualquer PowerPoint da vida.

Uma das melhores funcionalidades é o “Presenter Display”, uma tela que só o apresentador vê: as anotações do slide atual, o próximo slide, o tempo já decorrido. É informação fundamental para calibrar o ritmo em tempo real. Dá para configurar os elementos dessa tela em “Preferences”, nesta aba:

![](http://s3.amazonaws.com/akitaonrails/assets/2010/10/30/Screen%20shot%202010-10-30%20at%2011.54.26%20PM_original.png?1288490142)

Eu particularmente gosto de usar esta configuração:

![](http://s3.amazonaws.com/akitaonrails/assets/2010/10/30/Screen%20shot%202010-10-30%20at%2011.54.49%20PM_original.png?1288490155)

Sempre teste o notebook antes de subir ao palco. Ao tocar o Keynote (Command + Option + P), veja se o “Presenter Display” está saindo no seu notebook ou no projetor. Dá para inverter onde ele aparece na última opção dessa tela de “Preferences”.

![](http://s3.amazonaws.com/akitaonrails/assets/2010/10/30/Screen%20shot%202010-10-30%20at%2011.54.54%20PM_original.png?1288490148)

Sobre os slides, alguns lembretes:

- use cores de bom contraste entre frente e fundo: fundo branco com letra preta, ou fundo bem escuro com letra bem clara. Fugir disso, usando a mesma cor em tonalidades parecidas para fundo e letra, é garantia de slide ilegível no projetor.

- para mostrar código, use corpo **grande**. Numa apresentação montada em 800×600 (é o tamanho que sempre prefiro), a fonte mínima é 21, idealmente 24. Use monoespaçadas como a clássica Monaco ou a atual Menlo. Fuja das monoespaçadas serifadas, como o horrível Courier New, e das de corpo muito fino, como o Consolas.

- use o bundle [Copy as RTF](https://github.com/drnic/copy-as-rtf-tmbundle). Ele copia o código do TextMate junto com as cores do tema escolhido; daí é só colar no Keynote e ajustar o tamanho. No TextMate, o tema mais legível no projetor é o Mac Classic (fundo branco, letra preta). Um dos piores é o famoso Vibrant Ink (fundo preto, letra clara).

- deixe margens largas em todas as direções e não encoste nada importante nos cantos, código principalmente. E não use screenshot do TextMate como slide de código. O Keynote é independente de resolução, mas imagem bitmap não é, e se comporta mal conforme a resolução muda. Use fontes de verdade.

- código ou não, qualquer fonte menor que 21 fica ilegível a distância. Se você precisou diminuir mais que isso, o slide já está ruim, com texto demais ou texto irrelevante. Repense o slide. O ideal é poucas palavras em tamanho 72, 96 ou até 144, como faço em muitos dos meus.

- muita gente configura o Keynote para editar em 1024×768, mas acho desnecessário: edito tudo em 800×600. Como já falei, o Keynote é independente de resolução. Na configuração abaixo, a primeira opção manda escalar o slide para caber na tela inteira. Assim fica mais confortável editar em 800×600 mesmo no monitor do meu MacBook Pro.

![](http://s3.amazonaws.com/akitaonrails/assets/2010/10/30/Screen%20shot%202010-10-30%20at%2011.54.54%20PM_original.png?1288490148)

## Controle Remoto

Se você pretende palestrar com frequência, um bom controle remoto é essencial. São baratos e dão mobilidade, e ficar parado atrás do notebook nunca é bom. Em alguns lugares, pela disposição dos equipamentos, o notebook acaba longe do palco, fora do alcance para eu controlar na mão.

Alguns Macs vieram com o Apple Remote, o antigo branco e o atual de alumínio. São bonitos, mas na minha opinião uma grande porcaria, um dos piores acessórios da linha, junto com os antigos Mighty Mouse.

O motivo é o infravermelho: o controle só funciona apontado direto para o receptor do MacBook. Se tiver qualquer coisa na frente, ou se o notebook estiver de costas para você, ele não responde.

O mercado tem várias opções sem fio. Alguns usam Bluetooth, e desses eu fujo. Minha experiência foi instável, e ainda por cima eles não são fáceis de configurar.

[![](http://s3.amazonaws.com/akitaonrails/assets/2010/10/31/41lQtbJoayL._SL500_AA300__original.jpeg?1288491341)](http://web.archive.org/web/20101121185443/http://www.amazon.com/Kensington-33374-Wireless-Presenter-Pointer/dp/B000FPGP4U)

Os melhores têm o próprio conector USB e, ao ligar no Mac, se comportam como um teclado (o Mac acha que é teclado mesmo). Estou usando um da Targus no momento e não gosto dele. De longe o melhor que já usei, e o que recomendo, é o [Kensington 33374 Wireless Presenter with Laser Pointer](http://web.archive.org/web/20101121185443/http://www.amazon.com/Kensington-33374-Wireless-Presenter-Pointer/dp/B000FPGP4U).

Não seja mão-de-vaca com esse tipo de aparelho. Por causa de meros US$ 10 ou US$ 20, você fica com um controle bem pior, que vai te deixar na mão justamente no palco. Um sintoma de controle ruim é apertar o botão e pular dois slides de uma vez. É péssimo, e eu já passei por isso.

## Extras

Outra coisa importante: não use o app de controle remoto do Keynote para iPhone, que comanda o Mac via Wi-Fi. Wi-Fi de evento é sempre ruim e você não pode depender dele. Aliás, recomendo desligar Bluetooth e Wi-Fi do Mac antes de começar.

Já tive dois problemas assim. Num deles, não tenho certeza, mas acho que alguém estava tentando controlar meu Mac com algum aparelho remoto, talvez um Apple Remote infravermelho ou algo via Bluetooth. Por isso recomendo desativar o infravermelho também, em “System Preferences” ➔ “Security”.

![](http://s3.amazonaws.com/akitaonrails/assets/2010/10/31/Screen%20shot%202010-10-31%20at%2012.19.58%20AM_original.png?1288491621)

A opção é “Display remote control infrared receiver”. E a razão de desligar o Wi-Fi: no meio de uma palestra sofri uma colisão de IP, e o Keynote saiu do meu slide para exibir um aviso do sistema dizendo que alguém estava com o mesmo IP que o meu. Vergonhoso.

Outra: ligue o notebook na tomada e não apresente na bateria, mesmo cheia. O segundo monitor puxa bateria rápido, e em alguns casos nem liga fora da tomada.

Por fim, nunca, jamais, dependa da internet do local do evento. Como falei, isso é utopia. Se você tem demonstração ao vivo, cuidado. Grave sempre um screencast com ferramentas como o excelente [ScreenFlow](https://www.telestream.net/screenflow/overview.htm) ou o próprio QuickTime X, que já grava a tela do Mac; veja como neste [tutorial da MacMost](https://www.youtube.com/watch?v=5NSydKTCNx0).

E quando for gravar, nunca use a resolução cheia do notebook. Parece óbvio, mas a maioria dos iniciantes grava em 1440×900 e depois encolhe tudo para caber num slide de 1024×768. Pior ainda: abrindo o Terminal com fonte tamanho miserável 11.

As regras dos slides valem para os screencasts. Configure o terminal com fundo branco, letra preta e corpo 18 ou maior. Veja meu iTerm, já ajustado para as apresentações:

![](http://s3.amazonaws.com/akitaonrails/assets/2010/10/31/Screen%20shot%202010-10-31%20at%2012.27.08%20AM_original.png?1288492050)

Uso o iTerm porque deixo ele pronto para apresentar, mas no dia a dia fico no Terminal comum, que está configurado de outro jeito. Existem várias técnicas para gravar um bom screencast que não vou detalhar aqui, mas isso já dá para começar.

A vantagem do screencast é a garantia: mesmo que você mexa na máquina depois (atualize o Java, o Ruby, desinstale o MySQL), a demonstração funciona 100% das vezes. E o melhor: quando você narra por cima da gravação, muita gente nem percebe que é gravado.

A última dica é sobre som, um problema que já me pegou três vezes. Se você vai mostrar vídeo ou áudio em estéreo, teste antes de apresentar.

Nas três vezes o culpado foi provavelmente cabo podre ou má configuração (ou má vontade do técnico), e só um dos canais saía. Numa delas, perdi justamente o canal com a voz. Um truque é configurar o som do Mac para sair tudo em mono, ou tudo à esquerda, ou tudo à direita:

![](http://s3.amazonaws.com/akitaonrails/assets/2010/10/31/Screen%20shot%202010-10-31%20at%2012.38.42%20AM_original.png?1288492749)

Em “System Preferences” ➔ “Sound” ➔ “Output”, selecione a saída certa e teste jogar tudo para um lado só.

No fim, o que mais importa é a qualidade do conteúdo e a sua capacidade como orador: carisma, linguagem corporal, empatia com a plateia. A parte técnica só garante que um slide mal feito não estrague uma boa apresentação.
