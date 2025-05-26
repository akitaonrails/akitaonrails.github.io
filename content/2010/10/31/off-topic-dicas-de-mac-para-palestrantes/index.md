---
title: "[Off-Topic] Dicas de Mac para Palestrantes"
date: '2010-10-31T00:32:00-02:00'
slug: off-topic-dicas-de-mac-para-palestrantes
tags:
- learning
- beginner
- mac
draft: false
---

Existem algumas configurações de Mac que em todo evento que eu vou vejo alguém com problemas. Acho que já é hora de compilar algumas dessas dicas.

![](http://s3.amazonaws.com/akitaonrails/assets/2010/10/31/Screen%20shot%202010-10-31%20at%2012.30.53%20AM_original.png?1288492285)

Se você faz palestras, essas dicas podem te ajudar bastante.


## Monitores e Projetores

A primeira coisa é que Macs não tem aquela tecla de função (como fn + F4) que notebooks PC tem: basta conectar o adaptador VGA/DVI que o OS X automaticamente detecta a presença de um segundo monitor e configura de acordo.

Um segundo monitor pode funcionar de duas formas: independente, com sua própria resolução; ou em espelho (“mirror”), mostrando a mesma coisa que seu monitor principal. O primeiro é melhor para mostrar slides o segundo é melhor quando você quer fazer demonstrações ao vivo.

Além disso o segundo monitor pode funcionar como tela secundária ou primária. A diferença é quem tem a barra principal do topo do Mac. Você pode configurar essas coisas em “System Preferences” ➔ “Displays” ➔ “Arrangement”.

![](http://s3.amazonaws.com/akitaonrails/assets/2010/10/30/MirrorDisplays_original.jpeg?1288489269)

Da forma como está na imagem acima, o modo “espelho” está habilitado. Clique em “Mirror Displays” para desabilitar isso. E se estiver aparecendo duas telas independentes, mude quem é o monitor primário arrastando a barra branca no topo de um deles para outro, é isso que determina quem é o primário.

Outra coisa é o “Gather Windows”. Quando há um segundo monitor, aparece uma janela de preferências para cada monitor, para controlar resolução e cor de forma independente. Mas às vezes essa segunda janela está inalcançável, então clicando nesse botão, as duas janelas vão se juntar num monitor só. Lembre-se: quando os monitores não estão espelhados, você pode controlar as resoluções de cada monitor de forma independente. Normalmente o ideal é manter o primário no seu notebook e o secundário como o monitor externo. E no caso de um projetor lembrar que a maioria desses projetores baratos de mercado suportam só até 1024×768.

Agora vem um truque, normalmente esses projetores estão preparados para aceitar PCs e os profiles de cor entre PC e Mac podem ser diferentes. Um dos efeitos é que os Macs aparecem mais escuros e com contraste mais baixo, ficando mais difícil ler textos em fundos escuros. Para tentar ajustar isso tente mudar o Color Profile.

Ainda na mesma janela de configuração, ao lado de “Arrangement”, você tem “Color”. Desmarque a opção “Show profiles for this display only” e procure pelo perfil **“sRGB IEC61966-2.1”** , isso deve melhorar as cores da projeção tornando as coisas mais claras e legíveis. Tente outros perfis se for o caso.

![](http://s3.amazonaws.com/akitaonrails/assets/2010/10/30/ColorProfiles_original.png?1288489652)

Perfil de Cor não é algo trivial. Lembrando que até o Mac OS X 10.5 Leopard a correção Gamma era de 1.8 e a partir do 10.6 Snow Leopard passou a ser 2.2, como em Windows. Além disso lembrar que imagens bem feitas costumam vir com seu próprio perfil de cor e os Macs são capazes de transicionar corretamente de um perfil para outro. Leia este [artigo de suporte](http://support.apple.com/kb/ht3712) da Apple para entender isso melhor.

Finalmente, os técnicos de projetor fazem o alinhamento da tela usando um PC. Isso é péssimo: mandem fazer o alinhamento usando um Mac. Faz diferença e isso pode significar parte do seu slide saindo pra fora da tela se estiver mal calibrado.

## Apple Keynote

Outra coisa importante é que todos usam Macs justamente por causa do famoso Apple iWork Keynote, de longe o melhor software de criação de apresentações de qualidade, deixando no chinelo qualquer Powerpoint ou menores.

Uma das excelentes funcionalidades é o “Presenter Display”, uma tela especial que somente o apresentador pode ver com as anotações dos slide atual, o próximo slide, quanto tempo já se passou. Informações fundamentais para calibrar sua apresentação em tempo real. Você pode configurar os elementos dessa tela acessando “Preferences” e chegando nesta aba:

![](http://s3.amazonaws.com/akitaonrails/assets/2010/10/30/Screen%20shot%202010-10-30%20at%2011.54.26%20PM_original.png?1288490142)

Eu particularmente gosto de usar esta configuração:

![](http://s3.amazonaws.com/akitaonrails/assets/2010/10/30/Screen%20shot%202010-10-30%20at%2011.54.49%20PM_original.png?1288490155)

Sempre teste seu notebook antes da apresentação. Ao tocar o Keynote (Command + Option + P) cheque se o “Presenter Display” está saindo no seu notebook ou no projetor. Você pode inverter onde aparece mudando a última configuração desta tela do “Preferences”

![](http://s3.amazonaws.com/akitaonrails/assets/2010/10/30/Screen%20shot%202010-10-30%20at%2011.54.54%20PM_original.png?1288490148)

Sobre os slides, lembrar o seguinte:

- use cores de contraste entre a frente e o fundo, por exemplo, slide de fundo branco com letra preta, slide de fundo muito escuro com letra muito clara. Não use a mesma cor apenas com tonalidade diferente para ambos o fundo e a letra, é garantia de um péssimo slide no projetor.

- quando for mostrar código, use tamanho **grande**. Numa apresentação montada em 800×600 (eu sempre prefiro montar nesse tamanho), use uma fonte mínima 21 ou idealmente 24. Para código-fonte, use fontes monoespaçadas como a tradicional Mônaco ou a atual Menlo. Não use fontes monoespaçadas serifadas com o horrível Courier New, nem com corpo muito fino como o Consolas.

- use o Bundle [Copy as RTF](http://github.com/drnic/copy-as-rtf-tmbundle). Ele permite copiar o código do seu Textmate incluindo as cores do tema que está escolhido. Daí basta colar no Keynote e ajustar tamanho. Aliás, em Textmate o melhor tema para ser legível no projetor é o Mac Classic (fundo branco, letra preta). Um dos piores é justamente o famoso Vibrant Ink (fundo preto, letra clara).

- deixe margens largas em todas as direções: não deixe nada importante encostado em nenhum dos cantos, especialmente código. Também não use screenshot de textmate como slide de código. O Keynote é inteligente e é independente de resolução, porém imagens bitmaps não são e vão se comportar mal dependendo da resolução usada. Por isso use fontes de verdade.

- sendo código ou não código, qualquer fonte menor que 21 é ilegível à distância. Se você está precisando usar uma fonte menor do que essa é porque seu slide já está ruim, com texto demais ou texto irrelevante. Pense melhor no seu slide. Idealmente você estará usando apenas poucas palavras em tamanho 72, 96 ou mesmo 144 como eu faço em muitos slides.

- muitos podem querer configurar o Keynote para editar slides em 1024×768, mas eu digo que isso é desnecessário, eu edito tudo em 800×600. Como eu disse antes, o Keynote é independente de resolução. Na configuração abaixo, a primeira opção diz para escalar o tamanho do slide para caber na tela toda. A vantagem é que é mais confortável para editar em 800×600 mesmo no monitor do meu Macbook Pro.

![](http://s3.amazonaws.com/akitaonrails/assets/2010/10/30/Screen%20shot%202010-10-30%20at%2011.54.54%20PM_original.png?1288490148)

## Controle Remoto

Se você pretende fazer várias palestras, é essencial ter um bom controle remoto. Eles são baratos e permitem melhor mobilidade. Não é bom ficar parado atrás do notebook. Além do mais, em alguns lugares, devido à disposição dos equipamentos, o notebook já teve que ficar afastado do palco, ou seja, fora de distância para que eu possa controlá-lo.

Alguns Macs já vieram com o Apple Remote, tanto o antigo branco quanto o atual de alumínio. Apesar de bonitos eu digo que eles são uma grande porcaria, um dos piores acessórios da linha de Macs junto com os antigos Mighty Mouse.

Digo isso porque ele usa infravermelho e o problema é que para funcionar o controle precisa estar apontando diretamente pro receptor no Macbook. Se por acaso tiver algo na frente, ou se o notebook precisar ficar posicionado de costas pra você, aí ele não vai funcionar.

No mercado existem diversas opções de controles remotos sem fio. Alguns deles usam Bluetooth: evite-os. Minha experiência com eles não foi muito estável, além disso eles não são trivialmente configuráveis.

[![](http://s3.amazonaws.com/akitaonrails/assets/2010/10/31/41lQtbJoayL._SL500_AA300__original.jpeg?1288491341)](http://www.amazon.com/Kensington-33374-Wireless-Presenter-Pointer/dp/B000FPGP4U/ref=dp_cp_ob_e_title_0)

Os melhores são os que tem seu próprio conector USB e que, ao se ligarem nos Macs, reagem como se fossem teclados (o Mac acha que é um teclado). Eu atualmente estou usando um da Targus mas não estou gostando. De longe, o que tive melhor experiência até hoje e recomendo é o [Kensington 33374 Wireless Presenter with Laser Pointer](http://www.amazon.com/Kensington-33374-Wireless-Presenter-Pointer/dp/B000FPGP4U/ref=dp_cp_ob_e_title_0)

Não tente ser mão-de-vaca com esse tipo de dispositivo, por causa de meros $10, $20, você vai acabar com um controle muito pior e que vai te deixar na mão justamente quando você mais precisa: no palco. Um dos sintomas de controles ruims é você clicar no botão e ele salta dois slides de uma vez em vez de um. É péssimo, acreditem, eu já passei por isso.

## Extras

Aliás, outra coisa importante, não use o controle remoto via software do Keynote que você pode instalar no iPhone e controlar o Mac via Wi-Fi. Todo mundo já devia saber que Wi-Fi de evento sempre é ruim, você não pode depender disso. Na verdade, eu recomendo desligar tanto o Bluetooth quanto o Wi-Fi do seu Mac antes de começar a apresentar.

Eu já tive dois problemas, um deles não sei se era isso mesmo, mas acho que alguém estava tentando controlar meu Mac com algum dispositivo remoto, não sei se um controle infravermelho da Apple ou via Bluetooth. Inclusive, recomendo desativar o infravermelho do seu Mac. Isso fica em “System Preferences” ➔ “Security”.

![](http://s3.amazonaws.com/akitaonrails/assets/2010/10/31/Screen%20shot%202010-10-31%20at%2012.19.58%20AM_original.png?1288491621)

A opção é o “Display remote control infrared receiver”. Além disso o importante de desabilitar o Wi-Fi é porque no meio da minha palestra eu sofri uma colisão de IP e o Keynote saiu do meu slide para mostrar uma tela do sistema avisando que alguém estava com o mesmo IP que o meu. Vergonhoso.

Outra coisa: ligue seu notebook na tomada, não apresente via bateria, mesmo se ela estiver cheia. O segundo monitor consome sua bateria mais fácil e alguns casos nem liga se não estiver na força.

Finalmente, nunca, nunca dependa de internet disponível no lugar do evento. Como disse antes, isso é utopia. Se você tem demonstrações ao vivo, cuidado. Sempre grave um screencast usando ferramentas como o excelente [ScreenFlow](http://www.telestream.net/screen-flow/overview.htm) ou mesmo o próprio Quicktime X que hoje consegue gravar seu Mac, veja como neste [tutorial da MacMost](http://www.youtube.com/watch?v=5NSydKTCNx0&feature=player_embedded).

Aliás, quando gravar um screencast nunca grave usando a resolução total do seu notebook! É óbvio, mas a maioria dos iniciantes grava um screencast com resolução cheia de 1440×900 e daí diminui para caber num slide de 1024×768. Pior: abrindo coisas como o Terminal usando fontes com tamanho miserável 11!! As mesmas regras pros slides valem pra screencast: configure seu terminal para ter fundo branco, letra preta e tamanho de 18 ou mais. Veja meu iTerm que está configurado para minhas apresentações:

![](http://s3.amazonaws.com/akitaonrails/assets/2010/10/31/Screen%20shot%202010-10-31%20at%2012.27.08%20AM_original.png?1288492050)

Eu uso iTerm porque já deixo ele configurado para apresentações, mas no dia a dia uso o Terminal, que pode estar diferente. Existem diversas técnicas para se gravar um bom screencast que não vou mencionar neste artigo, mas isso já deve servir.

A vantagem de usar um screencast é que mesmo que você mexa na sua máquina (atualize a versão do Java, do Ruby, desinstale o MySQL ou coisas desse tipo) a apresentação vai funcionar 100% das vezes. E o mais legal: quando você narra em cima da sua gravação, muita gente não percebe que se trata de uma gravação.

A última dica de um problema que já me aconteceu três vezes (!) é o som. Se você pretende mostrar vídeos ou áudio e esse áudio estiver em estéreo, teste antes de apresentar! Por 3 vezes sofri provavelmente com cabos podres ou má configuração (má vontade do técnico) e o que acontecia é que apenas um dos canais estava saindo. Num dos casos eu perdi o canal que tinha voz! Um truque é configurar o som no seu Mac para soltar tudo em Mono ou tudo pra esquerda ou tudo pra direita:

![](http://s3.amazonaws.com/akitaonrails/assets/2010/10/31/Screen%20shot%202010-10-31%20at%2012.38.42%20AM_original.png?1288492749)

Em “System Preferences” ➔ “Sound” ➔ “Output” selecione a saída correta e teste empurrar tudo pra esquerda ou direita.

Mas o mais importante, no entanto, é a qualidade do seu conteúdo e suas capacidades de orador, carisma, linguagem corporal, empatia com a platéia. A parte técnica apenas garante que um slide mal feito estrague uma boa apresentação.

