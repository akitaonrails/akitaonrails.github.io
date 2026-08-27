---
title: "[Off-Topic] Comprei meu primeiro Mac, e agora? (Edição 2012)"
date: '2012-04-20T19:15:46-03:00'
slug: off-topic-comprei-meu-primeiro-mac-e-agora-edicao-2012
description: "A edição 2012 reúne dicas para ajustar um Mac com Lion, ativar o FileVault 2, organizar Mission Control e Auto Save, instalar Homebrew e escolher apps para feeds, espaço em disco e arquivos."
tags:
- apple
- produtividade
- tutoriais
- off-topic
draft: false
---

Um dos artigos mais lidos do meu blog é o [Comprei meu primeiro Mac, e agora?](http://akitaonrails.com/2009/07/19/off-topic-comprei-meu-primeiro-mac-e-agora), que escrevi em Julho de 2009. Já atualizei ele uma vez e sempre achei que precisava atualizar de novo. O artigo inteiro, revisado, está no link acima. Para quem já leu, a seguir está só o que acrescentei hoje.

Se você tem outras boas dicas, comente para compartilhar com todos. O foco aqui são usuários normais e Power Users, já que bons desenvolvedores sabem encontrar seu caminho sozinhos. Serve também para aquele amigo não-desenvolvedor que comprou um Mac e fica te perturbando toda hora com _“como faz isso? como faz aquilo?”_. Agora é só passar o link acima para o artigo inteiro :-)

Aproveitem!


## Edição 2012

- Assim como no Windows e em outros sistemas, no Mac a velocidade de repetição do teclado vem configurada meio lenta por padrão. Abra qualquer editor de texto, use as setas para posicionar o cursor e vai notar como é demorado. Eu prefiro a velocidade no máximo: vá em “System Preferences, opção Keyboard”, deixe “Key Repeat” em “Fast” e “Delay Until Repeat” em “Short”. Você vai me agradecer:

![](http://s3.amazonaws.com/akitaonrails/assets/2012/4/20/Screen%20Shot%202012-04-20%20at%206.02.32%20PM_original.png?1334956028)

- Antes do Lion existia uma função para encriptar seus arquivos em tempo real, chamada FileVault, e ela era ruim o suficiente para ser ignorada. A partir do Lion surgiu o **FileVault 2**, completamente diferente e bom o bastante para virar item obrigatório. Abra “System Preferences, Security & Privacy”, aba “FileVault”, e habilite a encriptação total do seu HD. **MUITO CUIDADO:** ele vai gerar chaves de recuperação que permitem descriptografar os dados. Anote num local seguro e **nunca perca**. Uma dica é pegar seu iPhone ou qualquer smartphone com câmera e fotografar a tela quando ele exibir as chaves.

![](http://s3.amazonaws.com/akitaonrails/assets/2012/4/20/Screen%20Shot%202012-04-20%20at%206.29.06%20PM_original.png?1334957491)

- A partir do Lion existe o [Mission Control](http://web.archive.org/web/20120522082049/http://www.apple.com/br/macosx/whats-new/mission-control.html), que você ativa colocando quatro dedos no touchpad e arrastando pra cima. Ele é o substituto do antigo Exposé e fica bem prático quando você se acostuma. Aplicativos “maximizados” viram seu próprio “Space” paralelo, e você navega entre eles arrastando três dedos no touchpad para a direita ou para a esquerda. O incômodo é a configuração padrão: os Spaces se rearranjam dinamicamente conforme o uso. Eu gosto de manter meus aplicativos e desktops sempre na mesma posição, então desabilito isso em “System Preferences, opção Mission Control”, na opção “Automatically rearrange spaces based on most recent use” (você ainda pode arrastar os Spaces para a ordem que preferir).

![](http://s3.amazonaws.com/akitaonrails/assets/2012/4/20/Screen%20Shot%202012-04-20%20at%205.57.35%20PM_original.png?1334955644)

- O Lion também mudou bastante a forma de salvar arquivos, com o novo recurso de “Auto Save”. Se acontecer um crash inesperado, se você precisar desligar a máquina no braço ou qualquer situação drástica dessas, não perde o que estava editando, porque o sistema salva sozinho. O incômodo é que o arquivo às vezes recebe um “Lock” que impede a edição. Dá para desbloquear manualmente, mas prefiro desligar isso em “System Preferences, Time Machine”, botão “options”, opção “Lock documents”. Aproveite a foto abaixo para ver onde fica e também o que eu coloco na lista de exclusão do Time Machine, coisas que prefiro não incluir no backup por não serem importantes (Software Images) ou por preferir fazer o backup na mão (iPhoto).

![](http://s3.amazonaws.com/akitaonrails/assets/2012/4/20/Screen%20Shot%202012-04-20%20at%206.38.10%20PM_original.png?1334958088)

- Ainda sobre a forma como o Lion lida com documentos e versões: nos aplicativos novos apareceu a opção “Save a version”, que grava momentos no tempo caso você precise voltar e recuperar algo feito antes. Pense nisso como um mini Time Machine, um backup granulado. Em compensação, o antigo “Save As”, que salvava o mesmo arquivo com outro nome, sumiu. Agora a operação é mais chata: primeiro “Duplicate” e depois “Save” (tudo no menu principal “File”) para gravar com outro nome. É chato no começo, mas vira rotina rápido.

- O [HomeBrew](https://github.com/mxcl/homebrew) é o melhor instalador de softwares de código-livre como MySQL, PostgreSQL, Redis, Git, Android SDK e muito mais. Em alguns casos ele baixa direto o binário pra Mac, mas na maioria das vezes pega o código-fonte, aplica os patches necessários e compila. Para isso você precisa de compiladores e outras ferramentas, e a forma mais simples é baixar o XCode pela **App Store**. Esta dica é mais para desenvolvedores; se você não for, pode ignorar.

- O Lion é a versão mais prática na hora de se recuperar de desastres. Acabou o DVD de boot: agora todo Mac tem uma partição escondida com o instalador, caso você precise reinstalar, checar discos e coisas assim. Basta dar boot segurando (Command-R) ⌘-R, ou segurar a tecla (Option) ⌥ durante o boot para abrir o menu de partições disponíveis e escolher “Recovery HD”.

[![](http://s3.amazonaws.com/akitaonrails/assets/2012/4/20/commandr_original.jpg?1334958455)](http://www.apple.com/macosx/recovery/)

### Aplicações

Alguns dos aplicativos a seguir estão no Mac App Store, e recomendo sempre procurar por lá primeiro. Quando não estiverem, use os links e baixe manualmente. No fim da seção tem uma dica para manter tudo sempre atualizado.

- Se tiver um iPad, dá para usá-lo como um segundo monitor ligado ao Mac via Wi-Fi (os dois precisam estar na mesma rede). Para isso, compre o programa [Air Display](http://web.archive.org/web/20120420081551/http://avatron.com/apps/air-display).

- Se tiver um novo Apple TV (o modelo pequeno preto), dá para espelhar a tela do iPhone 4S, iPad 2 ou superior via Wi-Fi usando o [Air Play](http://support.apple.com/kb/HT4437?viewlocale=pt_PT&locale=pt_PT) do iOS. A próxima versão do Mac, o Mountain Lion, vai permitir fazer o mesmo a partir do Mac. Até lá, você ainda pode espelhar o Mac numa HDTV via Apple TV comprando o [Air Parrot](http://airparrot.com/). É a forma mais simples de assistir a filmes e vídeos do seu Mac direto na TV.

- Eu gosto muito de ler os vários feeds RSS e Atom cadastrados na minha conta do Google Reader, e o melhor aplicativo para Mac e iOS é o [Reeder](http://reederapp.com/mac/).

- Com tanto conteúdo na internet, você baixa muita coisa e nem sempre sabe quais arquivos estão consumindo mais espaço em disco. Para encontrá-los com facilidade (dica: na maioria das vezes são os vídeo podcasts no iTunes), existem ótimos aplicativos pagos como o [DaisyDisk](http://www.daisydiskapp.com/), mas eu ainda gosto do gratuito [GrandPerspective](http://grandperspectiv.sourceforge.net/).

- O OS X sozinho dá conta de formatos comprimidos como zip e gz. Para descompactar formatos mais chatos como 7-zip e rar, instale o [The Unarchiver](http://wakaba.c3.cx/s/apps/unarchiver.html).

- A última dica é criar uma conta no [MacUpdate](http://www.macupdate.com/) e baixar o [MacUpdate Desktop](http://www.macupdate.com/desktop/). De vez em quando abra o programa e ele mostra tudo que está desatualizado na máquina, deixando você escolher o que quer atualizar:

![](http://s3.amazonaws.com/akitaonrails/assets/2012/4/20/Screen%20Shot%202012-04-20%20at%206.14.40%20PM_original.png?1334956624)

