---
title: "[Off-Topic] Comprei meu primeiro Mac, e agora? (Edição 2012)"
date: '2012-04-20T19:15:46-03:00'
slug: off-topic-comprei-meu-primeiro-mac-e-agora-edicao-2012
tags:
- learning
- beginner
- mac
draft: false
---

Um dos artigos mais lidos do meu blog é o [Comprei meu primeiro Mac, e agora?](http://akitaonrails.com/2009/07/19/off-topic-comprei-meu-primeiro-mac-e-agora). Escrevi em Setembro de 2009. Já atualizei uma vez mas eu sempre achei que precisava atualizar novamente. Veja o artigo inteiro atualizado no link original acima. Mas para quem já havia lido, a seguir está somente o que acrescentei de novo hoje.

Se você tem outras boas dicas como essa, não deixem de comentar para compartilhar com todos. A idéia não é um artigo para desenvolvedores (eu assumo que bons desenvolvedores sabem encontrar seu caminho sozinhos) mas para usuários normais e mesmo Power Users. Outra boa utilidade: seu amigo não-desenvolvedor comprou um Mac e fica te perturbando toda hora _“como faz isso? como faz aquilo?”_, agora você pode passar o link acima para o artigo inteiro para auxiliá-lo :-)

Aproveitem!


## Edição 2012

- Se não me engano, da mesma forma como é no Windows e outros OS, no Mac a velocidade de digitação do teclado é configurada por padrão pra ser meio lenta. Por exemplo, experimente abrir um editor de texto qualquer e usar as setas para posicionar o cursor, vai notar que é demorado. Eu prefiro que a velocidade seja máxima. Para isso vá em “System Preferences, opção Keyboard” e deixe a opção “Key Repeat” para “Fast” e “Delay Until Repeat” em “Short”. Você vai me agradecer:

![](http://s3.amazonaws.com/akitaonrails/assets/2012/4/20/Screen%20Shot%202012-04-20%20at%206.02.32%20PM_original.png?1334956028)

- Antes do Lion, existia uma função de encriptar seus arquivos em tempo real. Essa funcionalidade se chamava FileVault e era ruim o suficiente para ser ignorada. Porém a partir do Lion, surgiu o **FileVault 2** e ela é completamente diferente e desta vez é tão boa que seria estupidez não usá-la. Abra o “System Preferences, Security & Privacy”, aba “FileVault” e abilite a encriptação total do seu HD. **MUITO CUIDADO:** ele irá gerar chaves seguras que permitem descriptografar os dados. Anote num local seguro e **nunca perca**. Uma dica é ligar seu iPhone ou qualquer smartphone com câmera e tirar uma foto da tela quando ele fornecer as chaves.

![](http://s3.amazonaws.com/akitaonrails/assets/2012/4/20/Screen%20Shot%202012-04-20%20at%206.29.06%20PM_original.png?1334957491)

- A partir do Lion existe a funcionalidade [Mission Control](http://www.apple.com/br/macosx/whats-new/mission-control.html) que você ativa colocando quatro dedos no touchpad e arrastando pra cima. Ele é um “substituto” do antigo Exposé e é realmente prático quando se acostuma. Aplicativos, quando “maximizados”, se tornam seu próprio “Space” paralelo e você pode navegar entre eles arrastando 3 dedos no touchpad, pra direita ou pra esquerda. Porém, a configuração padrão é que esses Spaces se rearrangem dinamicamente baseado no uso. Eu particularmente acho isso ruim porque eu gosto de ter meus aplicativos e desktops sempre na mesma posição (no Mission Control você pode arrastar os Spaces de lugar para deixar onde gosta mais). Para desabilitar esse rearranjo forçado, vá em “System Preferences, opção Mission Control” e desabilite a opção “Automatically rearrange spaces based on most recent use”.

![](http://s3.amazonaws.com/akitaonrails/assets/2012/4/20/Screen%20Shot%202012-04-20%20at%205.57.35%20PM_original.png?1334955644)

- Também a partir do Lion, mudou muito a forma como você salva arquivos. Existe agora o recurso de “Auto Save”. Desta forma, se acontecer um crash inesperado, você precisar desligar a máquina forçadamente ou qualquer situação mais drástica onde você vai perder o que estava editando nos seus aplicativos, não precisa se preocupar porque o Lion está salvando automaticamente. Porém, existe uma situação incômoda onde o arquivo às vezes “trava” ou seja, recebe um “Lock” que impede editá-lo. Você pode escolher desbloqueá-lo manualmente mas como disse, é incômodo. Prefiro desligar isso indo em “System Preferences, Time Machine”, clique no botão “options” e desabilite a opção “Lock documents”. Aproveite para ver na foto abaixo onde fazer isso e também o que eu coloco na minha lista de exclusão do Time Machine, coisas que eu prefiro não fazer backup seja porque não é importante (Software Images, por exemplo) ou porque eu prefiro manualmente fazer backup (iPhoto).

![](http://s3.amazonaws.com/akitaonrails/assets/2012/4/20/Screen%20Shot%202012-04-20%20at%206.38.10%20PM_original.png?1334958088)

- Ainda sobre a nova forma do Lion lidar com documentos e versões, entenda que agora no menu dos aplicativos novos você tem a opção “Save a version” que permite que você grave momentos no tempo caso ache que precise retornar e recuperar o que tinha feito antes. Pense nisso como um “mini Time Machine” ou um backup granulado. Uma opção que não existe mais é o “Save As” que permitia você salvar o mesmo arquivo com outro nome. Em vez disso a operação ficou mais chatinha, tendo que fazer primeiro “Duplicate” (tudo no mesmo menu principal “File”) e depois “Save” para gravar com outro nome. Acostume-se, é chato no começo mas depois fica trivial.

- O [HomeBrew](https://github.com/mxcl/homebrew) é o melhor instalador de softwares de código-livre como MySQL, PostgreSQL, Redis, Git, Android SDK e muito mais. Alguns casos ele chega a baixar diretamente o binário pra Mac mas na maioria das vezes ele baixa o código-fonte, aplica patches necessários e compila. Para isso você precisa de compiladores e outras ferramentas. A maneira mais simples é usar a **App Store** para comprar e baixar o XCode. Esta dica é mais para desenvolvedores de software, se você não for, pode ignorar.

- O Lion é a versão mais prática do ponto de vista de se recuperar de desastres. Não existe mais DVD de boot. Agora todo Mac tem uma partição escondida onde está o instalador caso seja necessário reinstalar ou checar discos e outras coisas. Basta realizar um boot deixando as teclas (Command-R) ⌘-R pressionada ou deixar a tecla (Option) ⌥ pressionada durante o boot para aparecer um menu com as partições disponíveis e escolher “Recovery HD”.

[![](http://s3.amazonaws.com/akitaonrails/assets/2012/4/20/commandr_original.jpg?1334958455)](http://www.apple.com/macosx/recovery/)

### Aplicações

Alguns dos aplicativos listados a seguir se encontram no Mac App Store e recomendo sempre escolher de lá primeiro. Senão vá nos links e baixe manualmente. No fim desta seção tenho uma dica sobre como manter seus aplicativos sempre atualizados.

- Se tiver um iPad, você pode usá-lo como se fosse um segundo monitor, ligado ao seu Mac via Wi-Fi (precisam estar na mesma rede). Para isso compre o programa [Air Display](http://avatron.com/apps/air-display).

- Se tiver um novo Apple TV (o modelo pequeno preto), você pode espelhar as telas do seu iPhone 4S, iPad 2 ou superior via Wi-Fi usando a função [Air Play](http://support.apple.com/kb/HT4437?viewlocale=pt_PT&locale=pt_PT) que o iOS possui. A próxima versão do Mac, Mountain Lion, vai permitir fazer o mesmo com seu Mac. Mas até lá, você ainda pode espelhar seu Mac numa HDTV via Apple TV comprando o programa [Air Parrot](http://airparrot.com/). É a forma mais simples de assistir filmes e vídeos do seu Mac direto na sua TV.

- Eu particularmente gosto muito de ler diversos feeds de RSS, Atom que estão cadastrados na minha conta de Google Reader e o melhor aplicativo de Mac e iOS é sem dúvida o [Reeder](http://reederapp.com/mac/).

- Com tanto conteúdo na internet, você baixa muita coisa, mas nem sempre sabe onde estão seus arquivos que estão consumindo mais o espaço em disco. Para encontrá-los mais facilmente (dica: na maioria das vezes, o que consome mais espaço são seus vídeo podcasts no iTunes) existem excelente aplicativos pagos como o [DaisyDisk](http://www.daisydiskapp.com/) mas eu ainda gosto do aplicativo gratuito [GrandPerspective](http://grandperspectiv.sourceforge.net/).

- O OS X sozinho se vira com formatos de arquivos comprimidos como zip, gz. Mas para conseguir descompactar formatos mais interessantes como 7-zip, rar, não deixe de instalar o [The Unarchiver](http://wakaba.c3.cx/s/apps/unarchiver.html)

- A última dica é criar uma conta no site [MacUpdate](http://www.macupdate.com/) e depois baixar o software [MacUpdate Desktop](http://www.macupdate.com/desktop/). De vez em quando abra o software e ele vai lhe dizer tudo que está desatualizado na sua máquina, permitindo que você escolha o que quer atualizar:

![](http://s3.amazonaws.com/akitaonrails/assets/2012/4/20/Screen%20Shot%202012-04-20%20at%206.14.40%20PM_original.png?1334956624)

