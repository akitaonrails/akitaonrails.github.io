---
title: "Otimizando o Linux para Computadores Lentos"
date: '2017-01-17T18:15:00-02:00'
slug: otimizando-o-linux-para-computadores-lentos
translationKey: optimizing-linux-slow-computers
aliases:
- /2017/01/17/optimizing-linux-for-slow-computers/
tags:
- linux
- kernel
- arch
- traduzido
draft: false
---

Tenho pesquisado bastante sobre Linux no Desktop ultimamente, como você pode ver nos meus posts sobre [Fedora 25](http://www.akitaonrails.com/2017/01/06/customizando-o-fedora-25-para-desenvolvedores) e [Arch Linux](http://www.akitaonrails.com/2017/01/10/arch-linux-a-melhor-distro-de-todas) (recomendado!).

Há algumas coisas importantes para ter em mente na hora de migrar para sistemas Linux.

Mesmo que você tenha um Intel Core i7 Kaby Lake de última geração, 32GB de RAM e SSDs M.2 de 2TB, ainda é possível se beneficiar das otimizações que vou discutir aqui.

Um dos melhores recursos disponíveis é a [página da Wiki do Arch Linux sobre "Improving Performance"](https://wiki.archlinux.org/index.php/Improving_performance). Você não precisa aplicar tudo que está lá, mas é uma referência completa que qualquer entusiasta deveria ler.

![htop and iotop](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/607/Screenshot_from_2017-01-17_16-55-46.png)

### É sobre Responsividade, não performance!

A maioria das pessoas se preocupa primeiro com performance, e isso é um erro. O Linux é rápido o suficiente, mas para muita gente ele não parece assim no Desktop.

Ao configurar um servidor, faz todo sentido ajustar para performance e alto throughput. É aí que as configurações do Linux realmente se destacam sobre a concorrência: elas já vêm mais ajustadas para extrair o máximo de configurações de servidor.

Mas num Desktop, você não quer isso. Por exemplo: você está copiando um arquivo de 20GB para um pen drive velho, ou descomprimindo um arquivo grande, ou compilando um pacote pesado do código-fonte, ou deixou o Dropbox sincronizando gigabytes de arquivos em segundo plano. Ou você não está fazendo "nada" (pelo menos no primeiro plano, mas o Gnome Tracker está indexando seus arquivos pesadamente em background) e o ambiente trava, fica pendurado por alguns segundos, e continua fazendo isso de tempos em tempos.

E você fica se perguntando por que o Linux é tão ruim comparado ao Windows ou macOS, onde esse comportamento não ocorre em hardware similar.

> Existe um termo ainda mal compreendido: **tempo real**.

Ser real-time não significa "computar muito rápido", significa "ser previsível". Se algo precisa acontecer em uma certa frequência, não importa se cada ciclo leva 1 segundo — desde que consistentemente leve sempre esse mesmo 1 segundo, em todos os prazos. Se você tem uma máquina "rápida" que processa em 10 milissegundos por ciclo, mas de vez em quando trava aleatoriamente por alguns segundos, isso não é tempo real. E para criação de mídia, é um desastre.

Existe o hard real-time, onde um único pico ou vale pode ser considerado uma falha catastrófica, e o soft real-time, onde você consegue tolerar alguns picos, mas não muitos. Requisitos de hard real-time são raros — a menos que você esteja desenvolvendo sistemas para usinas nucleares, você pode perder alguns prazos sem consequências graves.

A maioria dos problemas de responsividade está relacionada a situações de soft real-time. Você consegue lidar com alguns picos esporádicos aqui e ali, mas não com muitos. E é assim que você deve conduzir sua pesquisa: não procurando "linux performance" no Google, mas sim "linux real-time" ou "linux responsiveness".

Você também vai descobrir que existem profissionais de nicho com distros especiais apenas para gravação e edição de áudio, como [AVLinux ou KXStudio](http://libremusicproduction.com/articles/advantages-choosing-audio-orientated-linux-distribution).

O macOS é particularmente bom para criadores de mídia justamente porque é altamente ajustado para soft real-time, algo crítico para softwares como o Logic Pro. E pelo mesmo motivo, é um péssimo sistema operacional para servidores. Você vai notar que a gravação de tela padrão do Quicktime é extremamente fluida, raramente aparece qualquer engasgo.

Mas você não precisa usar uma distro específica para áudio ou um kernel hard real-time. Distros de áudio crítico não usam PulseAudio, mas usuários comuns não precisam se preocupar com isso. Dá para ajustar e encontrar um bom equilíbrio entre responsividade e performance. Se quiser ir fundo no tema, leia o [Linux Audio Wiki sobre Real Time](http://wiki.linuxaudio.org/wiki/real_time_info), mas isso foge do escopo deste artigo.

### Quais são os Gargalos de Verdade?

Um computador "lento" não é necessariamente aquele com CPU antiga. Estou fazendo meus testes em um Lenovo Thinkcentre Edge 71z bem antigo. Ele tem uma CPU Intel Core de 2ª geração, 2.4GHz, 4 núcleos, arquitetura SandyBridge. Acabamos de ver o lançamento dos processadores de 7ª geração Kaby Lake, então alguém poderia imaginar que nada rodaria bem em uma CPU tão antiga — mas estaria errado.

A CPU normalmente não é um gargalo sério, a menos que você esteja fazendo computação realmente intensiva, como compressão de vídeo, ciência de dados, genética, redes neurais, etc.

Para um usuário casual ou mesmo um desenvolvedor pesado, qualquer processador melhor que a 1ª geração Intel Core já é suficiente.

A GPU também raramente é gargalo, a menos que você jogue muito ou faça renderizações em 4K. Na maioria das vezes, você não precisa de uma GTX 1080 dedicada de USD 7000.

Aliás, isso não é necessário na maioria dos sistemas, mas por precaução, faça o seguinte:

```
sudo pacman -S mesa-demos
glxinfo | grep direct
```

Você deve ver `direct rendering: Yes`. Se não aparecer, consulte a documentação da sua distro, pois isso significa que você não está fazendo composição pela GPU e está desperdiçando ciclos de CPU para renderizar a tela!

Se você tentar medir o uso de CPU e GPU, vai perceber que na maior parte do tempo eles estão ociosos! É isso mesmo: você está subutilizando os núcleos da sua máquina.

O gargalo geralmente se resume a I/O.

### RAM vs SWAP

Digamos que você abra o Chromium. Qualquer pessoa navegando por alguns minutos abre uma média de uma dúzia de abas ou mais, sem esforço algum.

É muito fácil consumir todos os 8GB de RAM de uma máquina comum. Quando isso acontece, o sistema operacional precisa começar a descarregar dados para o disco, que é ordens de magnitude mais lento.

Se os dados de um aplicativo forem descarregados para o disco e você fizer alt-tab para ele mais tarde, o sistema vai atingir um "page fault" e precisará carregar do disco, da partição ou arquivo de swap. E novamente, isso terá o efeito de bloquear suas ações. O ambiente pode travar por um segundo ou mais, tornando-se **irresponsivo**.

A primeira coisa que você pode querer fazer é instalar uma extensão como o [The Great Suspender](https://chrome.google.com/webstore/detail/the-great-suspender/klbibkeccnjlkjkiokjodocebajanakg?hl=en). Ela simplesmente fecha todas as abas exceto a que você está lendo agora. Quando você muda para outra aba, ela recarrega. O efeito é que você não está usando RAM para algo que não está usando ativamente.

![The Great Suspender](https://lh6.googleusercontent.com/PCpWlL8C4bi0yPT1zvOmRwZFd1BaweIiwSw9hmJoUZ4BDA9InMR_fEaC4XNrFTyWW2m_yC8HIw=s640-h400-e365)

Essa extensão sozinha pode economizar alguns GIGABYTES de RAM, o que é bastante significativo se você tem 8GB ou menos.

O outro ponto a considerar é que o Linux vem pré-configurado para equilibrar o descarregamento de dados de aplicativos para o swap com o cache do sistema de arquivos. Então, se você está descomprimindo um arquivo grande, parte desses dados vai para o cache em RAM e os dados dos aplicativos vão para o disco. Quando você termina de descomprimir e faz alt-tab para os aplicativos: page faults, travamentos.

A solução é configurar o sistema para manter mais agressivamente o estado dos aplicativos em RAM, e [é assim que se faz](https://rudd-o.com/linux-and-free-software/tales-from-responsivenessland-why-linux-feels-slow-and-how-to-fix-that):

```
sudo tee -a /etc/sysctl.d/99-sysctl.conf <<-EOF
vm.swappiness=1
vm.vfs_cache_pressure=50
EOF
```

Ainda no tema de armazenamento, alguns kernels mais antigos deixam a máquina irresponsiva ao lidar com [dispositivos de armazenamento lentos](http://unix.stackexchange.com/questions/107703/why-is-my-pc-freezing-while-im-copying-a-file-to-a-pendrive/107722#107722), como pen drives ou cartões SD. Veja como ajustar:

```
sudo tee -a /etc/sysctl.d/99-sysctl.conf <<-EOF
vm.dirty_background_bytes=16777216
vm.dirty_bytes=50331648
EOF
```

Se não quiser reiniciar agora, execute isso no terminal:

```
sudo sysctl -w vm.swappiness=1
sudo sysctl -w vm.vfs_cache_pressure=50
sudo sysctl -w vm.dirty_background_bytes=16777216 
sudo sysctl -w vm.dirty_bytes=50331648
```

Não exagere nos ajustes. Por exemplo, nunca desabilite o journaling do sistema de arquivos. Isso aumenta performance ao custo de colocar seus dados em risco de corrupção.

### Schedulers

Por que o "Linux não estava pronto para o Desktop" há alguns anos?

Porque demorou tempo demais para começar a tratar latência baixa, troca de threads eficiente e melhor scheduling. Há muito a agradecer a [Con Kolivas](https://en.wikipedia.org/wiki/Con_Kolivas), [Ingo Molnár e Thomas Gleixner](https://en.wikipedia.org/wiki/Ingo_Moln%C3%A1r). O desenvolvimento do kernel Linux é notoriamente difícil e Con Kolivas foi uma de suas vítimas, mas seu trabalho sobreviveu e nos permite ter experiências melhores no Desktop hoje.

Existem Process Schedulers e I/O Schedulers. O primeiro é responsável por gerenciar a [Preempção](https://rt.wiki.kernel.org/index.php/RT_PREEMPT_HOWTO) do kernel, como ele alterna entre diferentes tarefas computacionais — o equivalente em baixo nível do "alt-tab" entre apps.

Os I/O Schedulers lidam com o compartilhamento de recursos lentos de I/O entre processos concorrentes que precisam ler do disco, escrever na RAM, etc.

A história recente do process scheduler para Desktop se resume ao trabalho de Con Kolivas em fair scheduling, que levou ao Completely Fair Scheduler (CFS) de Ingo Mólnar — padrão na maioria das distros hoje — e ao trabalho contínuo de Kolivas no Staircase, Rotating Staircase Deadline, Staircase Deadlineee, Brain Fuck Scheduler (BFS), e o mais recente Multiple Queue Skiplist Scheduler (MuQSS).

No lado dos I/O Schedulers, você vai lidar principalmente com o Completely Fair Queueing (CFQ). A maior parte do desenvolvimento nessa área é atribuída a Jens Axboe, também responsável pelo Deadline Scheduler e pelo Noop Scheduler. Depois veio a evolução controversa chamada [Budget Fair Queueing](http://algo.ing.unimo.it/people/paolo/disk_sched/bfq-history.php) (BFQ).

Com SSDs (e é por isso que você quer SSDs), você provavelmente escolherá NOOP (ou [Deadline](https://wiki.debian.org/SSDOptimization#Low-Latency_IO-Scheduler)), porque não faz sentido desperdiçar tempo de processamento gerenciando filas complexas de I/O para SSDs — eles conseguem lidar facilmente com dezenas de milhares de operações de I/O simultâneas sem dificuldade.

Mas se você precisa usar HDs mecânicos, especialmente os antigos e lentos de 5.400rpm, vai querer gerenciar a fila de I/O de forma eficiente, tocando os pratos girantes o mínimo possível. Nesse caso, você vai querer usar algo como BFQ (ou pelo menos deixar no CFQ padrão).

Você pode verificar qual I/O Scheduler está ativo assim:

```
$ cat /sys/block/sda/queue/scheduler
noop deadline cfq [bfq] 
```

No exemplo acima, `[bfq]` é o ativo, mas você pode mudá-lo em tempo real para testar, se quiser.

Para aproveitar esses schedulers mais modernos e otimizar computadores lentos, a melhor aposta é instalar o kernel Linux Zen, uma versão do [Liquorix](https://liquorix.net/). Ele inclui o scheduler MuQSS em vez do CFS e o BFQ em vez do CFQ, além de outros ajustes de responsividade como QoS adequado sobre TCP para evitar congestionamento.

No Arch Linux é simples:

```
sudo pacman -Sy linux-zen
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

Para Ubuntu, consulte a [página de instalação do Liquorix](https://liquorix.net/#install), pois depende da sua CPU. Mas na maioria dos casos em máquinas 64-bit:

```
sudo apt-get install liquorix-keyring
apt-get install linux-image-liquorix-amd64 linux-headers-liquorix-amd64
```

### O GNOME 3 é lento demais?

Sempre ouvi que GNOME e até o KDE são lentos demais, que você deveria usar XFCE (ou LXQt, ou MATE).

E sempre me pareceu uma daquelas coisas que as pessoas simplesmente repetem até virar cânone oficial.

Como engenheiro, não gosto de pensar assim. Questionar o cânone é exatamente o que um engenheiro deveria fazer.

O GNOME 3.22 é um ambiente em constante evolução. Por padrão já tem uma boa aparência, sem necessidade de muito ajuste. E vem com várias comodidades embutidas como GNOME Online Accounts, Tracker para indexar arquivos e facilitar a busca, GNOME Photos que sincroniza do Google Photos, e assim por diante. Tudo aquilo que gostamos num sistema como macOS.

Conveniência é um trade-off de performance e responsividade. Máquinas de ponta se beneficiam das comodidades; máquinas antigas sofrem com o "bloat" extra em segundo plano.

Como manter parte da conveniência em hardware antigo?

Novamente, você precisa entender o que está acontecendo. A primeira coisa a instalar é **htop** e **iotop**. O primeiro ajuda a ver quais processos em background estão consumindo CPU ou RAM. O segundo mostra quais processos estão sobrecarregando as filas de I/O com operações de arquivo ou rede em background.

No meu sistema, encontrei 2 grandes vilões: Dropbox e Tracker.

![iotop](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/606/Screenshot_from_2017-01-17_16-15-32.png)

O Dropbox é opcional, mas a maioria das pessoas usa hoje em dia. Por padrão, é um monstro horroroso — um dos piores softwares com os quais você é obrigado a conviver.

Na primeira vez que você instala e ele precisa baixar tudo, sua máquina vai aos joelhos. Não há muito o que fazer — lembre-se de instalar na sexta à noite e deixá-lo rodando no escritório durante o fim de semana.

Depois, edite `/usr/share/applications/dropbox.desktop` e substitua a linha `Exec=dropbox` por:

```
Exec=ionice -c 3 -n 7 dropbox start -i && cpulimit -b -e dropbox -l 10
```

Isso "deve" reduzir o Dropbox ao mínimo de tempo de CPU e I/O apenas quando o sistema estiver ocioso.

Outra opção é instalar o [Ananicy](https://github.com/Nefelim4ag/Ananicy/blob/master/README.md). É um daemon que promete definir automaticamente o NICE e IOCLASS de processos selecionados, exatamente como o `ionice` e `cpulimit` acima. No Arch, instale assim:

```
sudo pacaur -S ananicy-git
```

E se você fizer `cat /etc/ananicy.d/dropbox.rules`, verá uma regra assim:

```
# Dropbox client: https://www.dropbox.com
NAME=dropbox       NICE=19     IOCLASS=idle
```

Que é basicamente o que fizemos no ajuste da linha `Exec`. Não testei o Ananicy o suficiente, mas se fizer o que promete, é ainda mais fácil — já vem com regras pré-configuradas para aplicações como make, VLC, transmission, etc.

Depois, tem o **Tracker**. A finalidade dessa ferramenta é indexar seus arquivos para que você possa buscá-los rápida e facilmente através de aplicações GNOME como o Nautilus.

Novamente, na primeira vez que você instala o ambiente GNOME, será muito custoso construir o índice inicial, especialmente se você estiver baixando toneladas de arquivos do Dropbox. Faça isso numa sexta à noite!

Mas você também deve configurá-lo para rodar apenas quando o sistema estiver ocioso. Execute Alt-F2 e digite `tracker-preferences`, então configure conforme a imagem abaixo:

![tracker-preferences](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/605/Screenshot_from_2017-01-17_15-32-38.png)

No mesmo applet, configure-o também para ignorar diretórios `log` e padrões de arquivo `*.log`!

Só essas 2 coisas já devem deixar sua máquina MUITO mais responsiva ao usar HDs mecânicos lentos. Percebi que o `gnome-photos` fica rodando em background consumindo algum I/O — provavelmente tentando sincronizar suas fotos online do Google se você configurou o [GNOME Online Accounts](https://wiki.gnome.org/Projects/GnomeOnlineAccounts).

> Dropbox, Tracker e Gnome-Photos vão arruinar sua experiência inicial. Mas se você tiver paciência — e uma conexão rápida com a internet — eles devem se estabilizar após a sincronização pesada inicial.

O GNOME tem outros serviços em background, como:

```
gnome-session
gnome-shell
gnome-settings-daemon
gnome-online-accounts
evolution-data-server
gjs-console
```

Dependendo dos apps opcionais instalados, pode haver mais. Gnome-Shell e GJS são facilmente os piores da lista. Você não pode fazer muito sobre eles porque são o núcleo do GNOME. O GJS em particular habilita extensões baseadas em Javascript, e tudo em Javascript é lento. A única coisa que você pode fazer é evitar instalar extensões GNOME demais.

Aliás, se você instalar o XFCE junto com o GNOME, pode se surpreender ao ver que muitos dos mesmos serviços em background vão iniciar mesmo assim! Instale um ou outro, não os dois no mesmo sistema.

Por outro lado, uma instalação mínima do Arch com o pacote XFCE4 vai iniciar consumindo cerca de 150MB de RAM. Mas claro, você perde todas as comodidades que vêm pré-instaladas no GNOME. E claro também: abra o Chromium, algumas abas, e lá se vai toda a RAM de qualquer jeito.

Se o seu objetivo é apenas economizar recursos, a escolha não é entre XFCE ou LXQt — é entre ter o Facebook aberto permanentemente numa aba do navegador ou não. A realidade é que o principal consumidor de RAM é a Web como um todo. Meia dúzia de abas e você consome mais de 1 Gigabyte, e continua subindo. Por isso minha primeira recomendação é instalar o The Great Suspender.

Você vai rodar apps muito piores no primeiro plano. Spotify, Franz, Atom, para citar alguns. Se for um app híbrido que carrega um browser para carregar uma aplicação web, vai ser pesado.

E eu escolheria um [gerenciador de desktop voltado para o futuro](https://wiki.archlinux.org/index.php/wayland#Window_managers_and_desktop_shells) que já suporte Wayland/Weston em vez do X11. Você quer se livrar do [legado ruim do X11](http://www.phoronix.com/scan.php?page=article&item=x_wayland_situation&num=1) o quanto antes.

### Resumo

Para um TL;DR mais curto, lembre-se de fazer o seguinte:

* Ajuste as configurações de swappiness e pressão de cache para evitar page faults ao usar aplicações em primeiro plano. É um trade-off entre performance e responsividade.
* Instale os kernels Linux-Zen ou Liquorix (dependendo da sua distro) para ter acesso ao melhor scheduler de processo MuQSS e ao scheduler de I/O BFQ. Se estiver usando SSD, verifique se está usando os schedulers de I/O NOOP ou Deadline. Também verifique o [suporte a TRIM](https://wiki.archlinux.org/index.php/Solid_State_Drives#TRIM).
* Faça o Dropbox e o Tracker se comportarem. Configure ambos para rodar apenas quando você não estiver usando o sistema (quando ocioso). Instale o Ananicy se quiser facilitar.
* Não escolha um Desktop Manager por preocupações de performance. Se você usa Chromium ou outras aplicações web, já está "condenado" de qualquer jeito. Então não entre em pânico e use o GNOME 3.22.

Quando instalei tanto o Fedora 25 quanto o Arch Linux, os achei lentos. Quando usei Ubuntu 14.04 por meses em hardware melhor, também o achei lento comparado ao macOS em hardware similar — mas nunca tinha tentado esse nível de otimização antes.

O principal motivo é a sincronização inicial pesada de aplicações como Dropbox, Tracker e Gnome-Photos.

O segundo motivo é o melhor ajuste do scheduling de I/O e das configurações de Swap por causa do uso de HD mecânico. Se você usa SSD, provavelmente não sofre nem de perto tanto.

Conclusão: se puder, compre um bom SSD. Se tiver PCI Express x4, vá além e compre um SSD M.2 como o [Samsung 950 EVO M.2](http://www.samsung.com/semiconductor/minisite/ssd/product/consumer/950pro.html). A melhor coisa que você pode fazer é ter mais de 8GB de RAM (16GB é um bom ponto de equilíbrio) e um SSD realmente rápido (de preferência com um barramento que não sofra os gargalos do SATA 3).

Com todos esses ajustes e otimizações, fico feliz em reportar que meu velho Lenovo tower está rodando tão bem quanto possível — responsivo o suficiente mesmo em cargas mais altas, com esse HD mecânico lento. E como bônus, se você optar por ficar no GNOME 3, instale o tema [Flat Plat](https://github.com/nana-4/Flat-Plat), fortemente inspirado no Material Design, e os ícones [Paper](https://snwh.org/paper) ou [Moka](https://snwh.org/moka).
