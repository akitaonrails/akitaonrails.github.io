---
title: "[Akitando] #137 - Games em Máquina Virtual com GPU Passthrough | Entendendo
  QEMU, KVM, Libvirt"
date: '2023-02-01T08:00:00-03:00'
slug: akitando-137-games-em-maquina-virtual-com-gpu-passthrough-entendendo-qemu-kvm-libvirt
tags:
- qemu
- kvm
- libvirt
- virt-manager
- virtio
- nvidia
- passthrough
- evdev
- ddcutil
- iommu
- spice
- virtualização
- virtualization
- virtual machine
- akitando
draft: false
---

{{< youtube id="IDnabc3DjYY" >}}

Este episódio levou literalmente MESES pra eu conseguir fazer. Entre atualizar o hardware da minha máquina, testar todo tipo de combinação de configuração, até conseguir rodar jogos da Steam, num Windows virtualizado, a quase mesma velocidade que nativo.

Hoje vamos entender o que é QEMU, KVM, Libvirt, como passar uma GPU da NVIDIA diretamente pra dentro de uma VM, e como garantir a máxima performance na virtualização, incluindo entender como diversos componentes de hardware e do Linux funcionam.

Este conteúdo vai ser DENSO, então não deixem de usar os capítulos abaixo pra se orientar e consultar todos os links que deixei listado aqui.

## Capítulos

* 00:00:00 - Intro
* 00:00:44 - Cap 1: Meu Setup (até 2024, senão podem pular)
* 00:05:51 - Cap 2: Introdução à Virtualização | Por que não Dual Boot?
* 00:08:26 - Cap 3: O que é IOMMU | Setup das GPUs
* 00:13:46 - Cap 4: Redes Virtuais | Minha placa 10 Gigabits
* 00:17:57 - Cap 5: Criando a Máquina Virtual | Virt-Manager
* 00:19:51 - Cap 6: Recapitulando UEFI | O que é OVMF?
* 00:23:06 - Cap 7: Entendendo CPUs | Pinagem de CPUs
* 00:33:01 - Cap 8: O que é QEMU? E KVM? | Libvirt
* 00:38:58 - Cap 9: Limitando CPUs do Host | Cgroups
* 00:43:06 - Cap 10: Configurações de Performance | Features Importantes
* 00:45:32 - Cap 11: Monitor Virtual e Streaming | SPICE e QXL
* 00:47:22 - Cap 12: Configurando Áudio | Pulseaudio e Pipewire
* 00:50:01 - Cap 13: PCI Passthrough | NVIDIA GPU
* 00:50:27 - Cap 14: Keyboard, Video, and Mouse | KVM via EVDEV
* 00:52:47 - Cap 15: Instalando Windows em Disco VirtIO | Fedora VirtIO ISO
* 00:57:15 - Cap 16: Demonstrando Performance com Games | GPU Passthrough
* 00:57:53 - Cap 17: Anti-Cheat em Elden Ring | Dual Boot
* 01:00:24 - Cap 18: Lidando com Monitor com 2 Inputs de Video | Escolhendo Inputs
* 01:03:08 - Cap 19: Lidando com Suspend do Host | Desligando Suspend
* 01:05:04 - Cap 20: Conclusão | Mais Coisas
* 01:07:49 - Bloopers

## Links


* https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF
* https://wiki.gentoo.org/wiki/GPU_passthrough_with_libvirt_qemu_kvm
* https://github.com/virtio-win/kvm-guest-drivers-windows
* https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.229-1/
* https://github.com/rockowitz/ddcui
* https://github.com/rockowitz/ddcutil/issues/35
* http://www.ddcutil.com/commands/
* https://github.com/olavmrk/usb-libvirt-hotplug
* https://getlabsdone.com/how-to-install-windows-11-on-kvm/#Add-the-windows-11-virtio-driver
* https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/virtualization_administration_guide/sect-virtualization-adding_storage_devices_to_guests-adding_hard_drives_and_other_block_devices_to_a_guest
* https://linuxhint.com/install_virtio_drivers_kvm_qemu_windows_vm/
* https://www.tecmint.com/manage-kvm-storage-volumes-and-pools/
* https://passthroughpo.st/simple-per-vm-libvirt-hooks-with-the-vfio-tools-hook-helper/
* https://www.libvirt.org/hooks.html
* https://archlinux.org/packages/extra/x86_64/qemu-emulators-full/
* https://unix.stackexchange.com/questions/30106/move-qcow2-image-to-physical-hard-drive
* https://libguestfs.org/virt-resize.1.html
* https://www.cyberithub.com/resize-qcow3-image-with-virt-resize-kvm-tools/
* https://loc-clan.com/files/win10
* https://www.reddit.com/r/VFIO/comments/l8g6iy/pc_suspends_itself_while_in_vm_due_to_suspend/
* https://www.linaro.org/blog/the-evolution-of-the-qemu-translator/
* https://github.com/foxlet/macOS-Simple-KVM
* https://github.com/foxlet/macOS-Simple-KVM
* https://passthroughpo.st/explaining-csm-efifboff-setting-boot-gpu-manually/
* https://passthroughpo.st/explaining-csm-efifboff-setting-boot-gpu-manually/
* https://github.com/vanities/GPU-Passthrough-Arch-Linux-to-Windows10
* https://github.com/rockowitz/ddcutil/issues/35#issuecomment-337919874

## SCRIPT

Olá pessoal, Fabio Akita

  
  

Video de hoje vai ser mais pra mim do que pra vocês. Quem me acompanha no Insta sabe o que eu ando mexendo e alguns meses atrás viram que eu estava brincando com upgrade no meu PC, NAS e, principalmente, PCI passthrough da GPU pra máquinas virtuais. Quero mostrar como ficou, como estou usando, mais ou menos os principais conceitos envolvidos. Embora não seja um passo a passo, vou explicar coisas que normalmente não se vê numa instalação normal de Linux e detalhes sobre como um PC funciona. Mais importante, vou explicar todos os componentes pra rodar máquinas virtuais em Linux e como elas funcionam. Se queria aprender mais sobre virtualização, hoje é o dia.

  
  
  

(...)

  
  
  
  
  

Eu já fiz dois videos falando do meu setup anterior então assistam depois. Mas agora estou com um PC bem potente, com CPU AMD Ryzen 9 5950X de 16 núcleos ou cores e 32 threads, 2 pentes de memória DDR4 de 4 Ghz funcionando com perfil XMP, ou seja, com overclock, da G.Skill, placa mãe Aorus X570S. Não é a melhor placa mas dá conta do recado. Ela tem 2 slots M.2 pra NVME que é SSD muito mais rápido, um Samsung 970 Evo Plus de 2TB onde tá instalado Windows 11 nativamente como dual boot e outro NVME primário Samsung também de 1 TB onde está meu Manjaro GNOME.

  
  
  
  
  
  

Além deles preenchi 3 slots SATA com SSDs normais Samsung modelos 860 e 870 de 1 TB que uso só pra cache do DaVinci Resolve, outro de 4TB que era meu antigo drive pra jogos da Steam e que recentemente encheu então comprei um de 8TB pra mover tudo pra lá. Vou fazer esse de 4TB ser meu novo cache pro DaVinci por enquanto. Óbvio que não precisa de tudo isso só pra cache, mas não tenho outro uso pra ele por enquanto, então beleza.

  
  
  
  
  
  
  

O Linux boota usando a GPU primária da AMD, um modelo fraquinho que é o RX 6400. Essa placa não é muito melhor que uma antiga NVIDIA GTX 1050 de 2016. Mas é mais do que suficiente pra coisas como tocar video 4K sem perder frames, renderizar aplicativos de produtividade como terminal ou editor de texto. Só pra programar e navegar na Web é muito mais do que suficiente. Mas obviamente é  imprestável pra games mais pesados que um CS:Go. 

  
  
  
  
  
  

Pra renderização pesada de video quando edito os episódio do canal com DaVinci Resolve, ou pra brincar de modelagem 3D com Blender ou pra jogos pesados como God of War da vida, aí tenho uma GPU secundária que fica desligada no Linux. A NVIDIA RTX 3090 com 24 Gigabytes só de memória de video. Esse sim é um monstro. 

  
  
  
  
  
  

Recentemente saiu a RTX 4090 que tem quase o dobro da performance da minha, mas também custa o dobro do preço, usa muito mais energia e ocupa quase o dobro do espaço dentro do gabinete, e pra funcionar decentemente o certo seria trocar minha placa mãe pra uma que suporte memória DDR5 e trocar minha CPU da série 5000 pra nova série 7000 que também acabou de sair pra não ter gargalo. Na prática o custo-benefício ainda não compensa. Vou fazer esse upgrade só daqui mais uns 2 anos.

  
  
  
  
  
  
  
  

Falando em resolução, eu uso setup de dois monitores, a principal é a Asus ROG TUF de 31", resolução de 2160 por 1440 pixels, ou seja, 2K a 144 hz. O topo de linha pra gamer seria um monitor de micro LEDs 4K de 300 hz HDR+, mas pro meu uso tá mais que bom. Eu não participo de esports então mais que 1440p e 144hz eu nem ia perceber tanta diferença e só ia pesar mais na GPU. Nessa configuração consigo jogar qualquer jogo pesado da Steam em Ultra High com Ray Tracing e ainda ter mais de 100 frames por segundo.

  
  
  
  
  
  
  
  

Meu monitor secundário é um Samsung de 29" 4K e 60hz. Esse eu exagerei um pouco. É o monitor que uso na vertical pra deixar coisas como meu Discord, Gmail, gráficos da bolsa e coisas assim pra ficar dando uma olhada. Poderia ser um monitor de 24" e não precisava ser 4K porque uso em 1440p pra ficar igual ao principal. Enfim, o resto não é importante pro video de hoje mas só pra ficar completo, tenho um microfone BM 800 e uma webcam Logitech Brio de 1080p de resolução. Não sou, nem quero ser podcaster nem streamer. Pra calls de Zoom tá mais que bom.

  
  
  
  
  
  
  
  
  

Pra áudio, em vez de usar o que vem na placa mãe liguei um DAC externo da Topping via USB. DAC é um conversor digital pra analógico. Ele recebe o áudio digital via USB e converte em onda pra mandar pra um pre-amp, que pega esse áudio analógico convertido com sinal baixo e amplifica pra nível de linha pra mandar pras caixas de som ou fone de ouvido. As caixas de som não nem nada de especial, são 2 Edifier. Pra usar na mesa perto de mim é o suficiente. Já o fone que uso é um Sennhaiser HD 650 que é um modelo de entrada pra quem quer um som de referência, não modificado.

  
  
  
  
  
  
  
  

Meu mouse é um Logitech MX Master 3 sem fio, o melhor mouse de produtividade que existe. Super confortável e excelente pra trabalhar em edição de video por exemplo. Ele não é feito pra jogar, embora nada impeça. Um mouse gamer tem metade do peso desse Logitech Mas como falei, não participo de esports e também não jogo FPS. Não curto Valorant, Apex Legends, Overwatch nem nada disso. Só jogo single player e com gamepad. E gamepad os meus preferidos são o de Xbox One X, depois o modelo SN30 pro+ da 8BitDo que compartilho com meu notebook, e o de PS4 pra emuladores como Dolphin ou CEMU pra jogos da Nintendo porque gamepad de PS4 tem acelerômetro e giroscópio, coisa que do Xbox não tem.

  
  
  
  
  
  
  
  

Todo mundo que acompanha o canal sabe que sou um sommelier de teclados e meu favorito até hoje é o Moonlander da ZSA. Dá bastante trabalho pra treinar e se acostumar, mas depois que aprendi realmente a usar um teclado split, separado no meio, com layout ortolinear, não consigo mais voltar pra um teclado normal. Eu sofro um pouco quando preciso usar do notebook. Quem não sabe o que é isso, assista meu terceiro video sobre teclados, que explico em detalhes.

  
  
  
  
  
  
  
  
  

O objetivo hoje é eu conseguir instalar uma máquina virtual Windows em cima do meu Manjaro e passar a GPU da NVIDIA inteiramente pra ele. Meu Manjaro continua funcionando normalmente via a GPU da AMD, e na máquina virtual a RTX 3090 vai ficar exclusiva só pro Windows virtualizado. Muitos podem se perguntar "ué, mas não é mais fácil só fazer um dual boot?" E sim, é mais fácil mesmo. Mas vejam esta tela do programa Virt Manager que eu instalei. 

  
  
  
  
  
  
  
  

Tudo isso são máquinas virtuais. Eu tenho uma instalação de Garuda que é outra versão de Arch Linux mais voltado pra gamers. Eu tenho um Ubuntu que uso pra testes e eu tenho 4 instalações de Windows 11. Uma que está como dual boot, instalado numa NVME e outras 3 que rodam num disco virtual em rede. Eis porque eu não queria só depender de dual boot: queria poder instalar outros Windows pra tarefas ou testes diferentes em separado, sem ter que reparticionar meu SSD toda hora e ficar reconfigurando dual boot. Do jeito que fiz, posso instalar um novo OS virtualizado a qualquer momento, ou destruir também, sem afetar a estabilidade do meu sistema.

  
  
  
  
  
  
  
  

Veja que tenho um MacOS também. Infelizmente é lento porque Apple parou de dar suporte pra GPU da NVIDIA faz alguns anos. Só GPUs antigas da NVIDIA funcionariam, como a GTX série 1000 de mais de 5 anos atrás, e só até o MacOS Mojave de 2021. Simplesmente não existem drivers pra usar a RTX 3090 num Mac. Pra conseguir acelerar esse MacOS virtualizado precisaria passar a GPU da AMD, mas como é minha principal, que o host Manjaro usa, ia ficar complicado então por enquanto não vai rolar Mac.

  
  
  
  
  
  
  
  

Falando em suporte de hardware e abrindo a página de PCI passthrough do ArchWiki, a primeira coisa que ele vai explicar é que precisa checar se o meu hardware suporta o que precisa. A primeira coisa é mais óbvia, minha CPU precisa suportar instruções de virtualização o VT-x ou VT-d. Tem que entrar na BIOS e checar se tá ativado. Muitas vezes vem desligado. Hoje em dia toda CPU suporta sem problemas, mas CPUs de uns 5 anos ou mais pra trás, é bom checar. No Wiki também fala sobre modelos de placa mãe. Mas de novo, só se preocupa com isso se seu hardware for muito velho.

  
  
  
  
  
  
  

Os passos 1, 2 e 3 do Wiki podem ser automatizados por essa ferramenta `gpu-passthrough-manager`, instala com `yay` ou `pacaur` ou seja lá qual gerenciador de AUR você usa. Eu gosto do `yay`. Ele vai fazer duas coisas importantes: configurar a linha de comando que carrega a kernel no boot pra habilitar IOMMU e depois que rebootar, vai separar a GPU da NVIDIA pra não carregar mais os drivers no boot, já que precisa estar desligado pra passar pra máquina virtual. Vamos entender.

  
  
  
  
  
  
  

IOMMU, ou Input Output Memory Management Unit é um recurso que ligamos na kernel e que a CPU por baixo precisa suportar. A grosso modo é assim, a CPU e dispositivos como teclado ou placa de video, normalmente se comunicam via endereços de memória direta entre um e outro. O problema é que se a CPU de verdade já está falando com o dispositivo, não teria como outra CPU virtual compartilhar os mesmos dispositivos. 

  
  
  
  
  
  
  

Em vez disso o controlador de IOMMU cria endereços virtuais que mapeiam pros reais e esses endereços virtuais podem ser passados pra máquinas virtuais, dando acesso direto aos dispositivos sem ter que passar pela CPU host pra intermediar essa comunicação. Isso é crucial pra máquina virtual conseguir falar diretamente com a GPU ou com outros dispositivos, por exemplo se colocar uma segunda placa de rede de verdade no PC, poderia passar inteira pra máquina virtual.

  
  
  
  
  
  
  

O Wiki explica como ligar isso, mas depois pede pra criar um script com esse código aqui e executar. O resultado vai ser algo parecido com isso aqui. Esses são os diversos grupos de IOMMU que meu sistema organiza. O que me importa é este Grupo 30 que tem só dois dispositivos, a RTX 3090 e um controlador de áudio também da NVIDIA. E o importante é que não tem mais nenhum outro dispositivo compartilhando o mesmo grupo. Se tivesse, na hora de passar a NVIDIA pra máquina virtual precisaria passar o outro dispositivo nada a ver junto, e dependendo do que fosse, poderia ter problemas. O ideal é estar assim: o que eu quero passar, isolado num grupo separado. Significa que passamos pelos pré-requisitos, meu hardware suporta o que quero fazer.

  
  
  
  
  
  
  
  

Até esse ponto, se fizer uma instalação normal de Manjaro, o identificador de hardware acha tanto minha AMD RX 6400 quanto a RTX 3090 e carrega os drivers dos dois. Mas pra poder passar pra máquina virtual, preciso que no boot, o driver da NVIDIA não seja carregado. Pra isso vamos usar um truque: carregar um driver dummy, de mentira, que vai se pendurar e bloquear a GPU. Pra isso usamos um driver VFIO que é um módulo que vem na kernel do Linux. Aquela ferramenta que falei antes, o `gpu-passthrough-manager` vai fazer isso pra gente, só selecionar os dois dispositivos da NVIDIA e deixar ele fazer o trabalho. Na Wiki tem o jeito manual também, mas vou pular.

  
  
  
  
  
  
  
  

Agora chegou a hora de instalar e configurar o software de virtualização propriamente dito. Precisamos dos pacotes `qemu-desktop`, `libvirt`, `edk2-ovmf` e o `virt-manager`. Pra rede precisa do pacote `dnsmasq`. Quando instalar tudo, só habilitar o libvirt pro SystemD carregar no boot com `sudo systemctl enable libvirtd` e já dar start nele também. Pronto, do ponto de vista de preparo e instalação já tá tudo pronto. Agora é a parte divertida, configurar a máquina virtual propriamente dita.

  
  
  
  
  
  
  

Uma máquina virtual vai se conectar com os mesmos dispositivos que seu Linux Host, o que boota nativamente de verdade, no caso o meu Manjaro. Coisas como os NVME  posso deixar outra máquina usar, se e somente se, não estiverem montadas. Lembra a diferença? Uma coisa é um dispositivo como `/dev/nvme1n1` outra coisa é o ponto de montagem `/mnt/blabla` que aponta pra uma partição no device. Se ficou confuso é porque você pulou meus videos de Linux onde explico isso. Se não sabe como Linux boota e como funciona por baixo, não vai entender nada deste video também. 

  
  
  
  
  
  
  

Enfim, o ponto é que é possível passar dispositivos de armazenamento entre meu host e o guest contanto que só um deles tenha pontos de montagem. Aliás, pra facilitar, vou dizer host sempre que me referir ao meu Manjaro principal, e guest ou convidado é a máquina virtual. Continuando, dispositivos USB como teclado, mouse, hubs e tudo mais suportam hot swap. Isso deve ser intuitivo, podemos desconectar e reconectar que o OS reinicializa a quente, sem precisar rebootar. Quando ligamos um dispositivo USB no guest, é como se estivéssemos tirando o cabo do host e ligando no guest.

  
  
  
  
  
  
  
  

Placa de video só dá pra passar via grupo de IOMMU e se estiver descarregado, ou seja, com o driver stub de VFIO bloqueando. O driver VFIO é como se fosse um plugue esperando a tomada da máquina virtual ligar nele, saca? Só aí que a placa mãe vai ser ativada. Os monitores, por sua vez, via cabo HDMI ou DisplayPort estão conectados fisicamente nas placas de video e não na placa mãe, então quem controla os monitores são as placas de video. 

  
  
  
  
  
  
  

Cada monitor suporta ligar vários cabos de entrada neles. Normalmente só ligamos um, mas já devem ter visto este menu que permite selecionar input sources diferentes, as diferentes portas na parte de trás. É assim que dá pra compartilhar um monitor com mais de um computador e ficar alternando os sinais de entrada. Meu monitor secundário vertical, o Samsung, tá ligado na placa da AMD. Meu monitor principal, o Asus, também tá ligado no AMD, então no boot o Wayland vê os dois e configura setup de extensão do meu desktop. 

  
  
  
  
  
  
  
  

Antes que alguém pergunte, pra ter papel de parede que enche os dois monitores desse jeito uso um programa chamado HydraPaper. Ele funciona via esse programa gráfico mas também dá pra chamar via linha de comando, daí não é difícil fazer um script pra colocar no cron e assim mudar o papel de parede de tanto em tanto tempo. Fica de exercício pra vocês. Voltando, esse monitor Asus também tem outro cabo HDMI ligado nele, que se conecta com a placa de video da NVIDIA, que neste momento permanece desligado. Já já vamos acordar ele.

  
  
  
  
  
  
  
  
  

Mas não é só com placa de video que preciso me preocupar. Esqueci de mencionar, mas minha placa mãe X570S vem com uma placa de rede embutida de 2.5 Gigabits por segundo, que é excelente já que a maioria dos PCs e notebooks no máximo vem com placa de 1 Gigabit. E lembrando que 1 Gigabit é mais que suficiente pra maioria das pessoas porque a conexão de internet de provedores ainda é faixa de 100 megabits, ou seja, 1 Gigabit é 10 vezes mais banda do que precisa pra uma pessoa assistindo YouTube. Mas pra editar video via rede é pouco. Eu explico sobre isso nos videos da mini-série de redes vejam lá depois.

  
  
  
  
  
  
  
  
  

Eu queria poder guardar os videos que gravo pro canal, que são em 4K formato DNxHR, que é pouco comprimido pra manter qualidade, no NAS e apontar o DaVinci Resolve direto pra uma pasta de rede aberto nesse NAS. Assim não preciso ficar copiando os arquivos pro meu PC e depois copiando de volta pro NAS. Pra isso a velocidade entre os dois precisa ser alta. Por isso resolvi comprar um switch e uma placa de video PCI Express de 10 Gigabits, que é 1000 vezes mais rápido que seu plano de internet de 100 megabits.

  
  
  
  
  
  

Eu não vou passar essa placa diretamente pra máquina virtual porque uso ela no host também. Como quero compartilhar a mesma placa entre duas máquinas, preciso tipo criar uma placa de rede virtual, como o dispositivo TAP que expliquei no episódio de VPN e uma rede entre a placa virtual ou a placa real, aí tenho algumas opções. Vamos abrir o aplicativo Virt-Manager, que é uma interface gráfica que facilita configurar as coisas. Essa interface é opcional porque tudo que vou mostrar graficamente pode ser feito via linha de comando usando o comando virsh. Por exemplo, no meu terminal posso digitar `sudo virth net-list --all` e mostra as duas redes virtuais que já tinha configurado na minha máquina: default e network.

  
  
  
  
  
  
  

Voltando pro Virt-Manager, posso abrir no menu "Edit" e "Connection Detail" e olha só as mesmas duas redes aparecendo. Clicando em "+"  posso criar uma nova rede virtual, mas não preciso porque já tenho essa daqui que chamei de "network", podia ser um nome mais criativo. Mas o importante é o nome do dispositivo virtual, a placa de rede de mentira, que dei o nome de "virbr1" porque na rede "default" já tinha "virbr0". Configurei pra ser uma rede usando NAT pra sair pela minha placa real cujo nome é "enp4s0". E como sei esse nome?

  
  
  
  
  
  
  

Lembram dos videos de rede? No terminal posso usar o comando "ip" pra mexer na rede. Se fizer `ip link show` mostra todos os dispositivos de rede. Lembram que falei que minha placa mãe já vinha com rede embutida de 2.5 Gigabits, esse é o dispositivo "enp8s0" que aparece logo embaixo do loopback. Estou escondendo o MAC Address deles, claro. Em seguida temos o "enp4s0" que falei que é a placa externa de 10 Gigabits. Em seguida temos dispositivos virtuais, "virbr0" e "virbr1". No fim tem um "wl" alguma coisa que é o Wi-Fi que não uso, mas também veio embutido.

  
  
  
  
  
  
  

Do ponto de vista do sistema operacional, tanto "enp4s0" quanto esse "virbr0" são placas de rede. Posso criar quantos dispositivos virtuais quiser. Posso criar um separado pra cada máquina virtual ou conectar várias máquinas na mesma placa. E cada placa pode usar diversas estratégias pra se conectar na rede. Vamos entender essa opção "mode". Olha só, isolated é fácil, impede a placa virtual de se conectar na rede e na internet. Só vai conseguir enxergar outras máquinas virtuais, mas como o nome diz, ficam isoladas do resto do mundo.

  
  
  
  
  
  
  

Todas as outras permitem acessar tanto a rede interna quanto a internet. Se escolher Bridge, vai se comportar como se fosse uma nova máquina de verdade conectada na rede. Vai procurar e encontrar o DHCP do modem da Vivo, igual meu PC de verdade faz no boot, pegar um IP e navegar normalmente. Se escolher NAT, como eu fiz, ele pega um IP privado atrás do meu PC de verdade e usa NAT pra falar na rede e acessar a internet. 

  
  
  
  
  
  

Routed nunca precisei usar então não sei os detalhes e Open acho que é se quisesse que a máquina virtual ficasse exposta diretamente na internet pública, que não é nosso caso. Então na prática ou escolho Bridge ou NAT. Tecnicamente, Bridge deveria ser mais performático, já que não precisaria passar por um NAT intermediário. Mas não lembro se tive problemas ou se não senti nenhuma diferença, mas vale testar entre os dois.

  
  
  
  
  
  
  
  

Pronto. Rede tá ok. Agora podemos começar o processo de criar a máquina virtual. É com esse ícone de "mais" no topo. Escolho a primeira opção pra procurar a ISO de instalação do Windows. Ele detecta corretamente. Caso fosse uma distro de Linux que não detectasse,  precisaria escolher manualmente o mais próximo, mas pra agora vamos pro próximo passo. 

  
  
  
  
  
  
  

Agora posso escolher quanto de RAM e quantas threads da minha CPU quero dar pra máquina virtual. Não vou mexer aqui porque isso vou mudar mais pra frente, então vamos pro próximo passo. E agora é a parte pra criarmos um HD virtual ou apontarmos pra um SSD de verdade na máquina. Vou só criar um HD virtual. 

  
  
  
  
  
  

Nos meus videos, como de WSL, mostrei como faz pra criar um HD virtual formato de VMWare ou Hyper-V que é o formato VHD ou VHDX, literalmente Virtual HD. Mas o QEMU gosta de usar outro formato, o QCOW2 que significa QEMU Copy-On-Write versão 2.

  
  
  
  
  

COW permite que esse HD virtual seja usado simultaneamente por duas ou mais máquinas virtuais diferentes, cada uma vai continuar criando blocos novos tipo num snapshot diferente. Isso também significa que esse HD virtual suporta snapshots, suporta voltar pra versões anterioes, mesmo se dentro não estivermos usando BTRFS. O formato QCOW2 acho que é mais avançado que um VHD. Além de snapshots também suporta compressão e encriptação.

  
  
  
  
  
  

Posso escolher deixar gravar no diretório padrão, mas prefiro criar num diretório que separei só pra isso no meu NAS. Então escolho "Manage" e nessa janela escolho um pool, que é um diretório e mando criar um novo volume, dou um nome qualquer, formato qcow2 e uns 100 gigabytes. Tanto faz o tamanho porque esse arquivo é dinâmico, na realidade só vai realmente gastar o que precisar, então no começo não ocupa espaço nenhum. Ele não precisa já pré-reservar o espaço todo. E agora no último passo mando deixar customizar mais antes de fazer o primeiro boot.

  
  
  
  
  
  
  
  

Esta é a tela mais detalhada que mostra tudo que vai ter nesta nova máquina virtual. Vamos um a um nos itens que importam. Logo no Overview tem uma mudança importante. Precisamos garantir que estamos com o Chipset Q35 em vez do antigo legado i440FX e que o Firmware seja UEFI mas a versão OVMF com secboot, que é secure boot. Fodeu, um monte de letrinhas né? Vou explicar. Chipset, como o nome diz, é o conjunto de chips na placa mãe que controla memória, processador, I/O e tudo mais. Queremos os chips mais novos.

  
  
  
  
  
  
  

UEFI já expliquei nos videos de armazenamento. Muita gente ainda chama de BIOS, mas UEFI é a evolução da BIOS. Dentre outras coisas,  é quem dá suporte a HDs com partições GPT, que permite partições de tamanho superior a 2 terabytes e um número enorme de partições. Toda UEFI moderna nem precisa de um bootloader como Grub. Se a partição tiver uma pasta EFI, vai conseguir bootar direto. Na minha placa-mãe, por exemplo, é só apertar F12 no boot que me dá um menu pra escolher de qual partição quero bootar, o que facilita fazer dual boot.

  
  
  
  
  
  
  
  

OVMF significa Open Virtual Machine Firmware. É um firmware, o UEFI propriamente dito, ou seja o software que boota primeiro logo que liga o computador e é responsável por checar e inicializar todos os dispositivos do sistema, achar o bootloader da kernel do sistema operacional em alguma partição GPT e passar o controle pra continuar o boot. Numa placa mãe de verdade esse firmware costuma ser mais complexo porque tem uma interface gráfica. Meu Aorus por exemplo, se apertar a tecla Delete no boot, abre essa tela gráfica fancy aqui. O OVMF tem telas em modo texto bem mais simples e com bem menos opções, porque é pra máquinas virtuais.

  
  
  
  
  
  
  

Escolhi a versão com Secure Boot porque Windows 11 passa a exigir a existência de um chip de segurança TMP e o firmware precisa ter suporte pra conseguir falar com esse chip. Pronto, podemos confirmar e agora precisamos adicionar uma versão virtual desse chip. Só adicionar novo hardware, escolher TPM, que vai ser emulado, mas selecionar as opções avançadas pra ser modo TIS e versão 2.0 que é o que o Windows 11 não vai reclamar. 

  
  
  
  
  
  
  

Um secure enclave como esse TPM, no mundo real, é um chip separado da CPU que vai conter coisas como chaves privadas que jamais vai dar pra ler diretamente, incluindo outras credenciais como certificados digitais. Também vai ter gravado a configuração da sua máquina que a firmware vai informar pra ele, assim nos próximos boots dá pra detectar se alguém modificou o hardware, que é o que normalmente se reclama com Secure Boot. 

  
  
  
  
  
  
  
  

Muitos gamers odeiam Secure Boot e TPM não porque eles são ruins, mas porque software de Anti-cheat, de detecção de trapaças que muitos jogos instalam justamente fazem modificações muito semelhantes ao que um vírus, malware ou rootkit faria na kernel do sistema. O problema é a existência de anti-cheats mau feitos. 

  
  
  
  
  
  

Enfim, isso é assunto pra outro dia. O importante é que temos como adicionar um TPM virtual pro Windows achar a aceitar. Mas já aproveito pra avisar que o anti-cheat de alguns jogos, como o Easy usado no Elden Ring, conseguem detectar que está rodando em máquina virtual e não permite entrar online, só dá pra jogar offline. Pra mim isso não é problema, mas pra alguns pode ser.

  
  
  
  
  
  
  

Agora chegou a hora de configurar a CPU. Problema que essa interface gráfica não permite modificar tudo que preciso. O que vou fazer é abrir a configuração de outra máquina que já tenho, copiar o XML do trecho de CPU e colar nessa nova máquina. Olha só, por padrão tenho uma linha pra quantas vcpus, depois o OS que é o firmware que acabamos de configurar, daí temos features da CPU e modo da CPU. Tudo isso precisamos mexer. Abrindo outra máquina que já tenho, começo copiando essas configurações de vcpu e cputune. 

  
  
  
  
  
  
  

VCPU é simples: quantas threads vou dar pra máquina virtual. Como  tenho uma Ryzen 5950X, posso dar bastante. Decidi dar metade, ou seja, 16 threads pra máquina virtual. O que é essa configuração longa que colei aqui? Eu dei 16 threads, e se não colocar esse bloco de "cputune", essas threads vão ser controladas pelo scheduler de threads do Linux Host por baixo. É ineficiente porque no Windows ou outro OS guest do lado de dentro já tem um scheduler e por baixo vai ter outro scheduler e no final as 16 threads vão ficar embaralhadas entre as 32 totais, podendo mudar dependendo se o Host tiver alguma carga pra processar. 

  
  
  
  
  
  
  

Essa configuração depende do uso. No meu caso, se estou com um guest aberto, normalmente não estou fazendo nada pesado no host. 16 threads pra cada dá e sobra na real. Mas essa pinagem de vcpu pra thread real não é aleatório. De onde vem esses números? Pra isso preciso saber a topologia de núcleos e caches deste processador em particular.

  
  
  
  
  
  

Vamos lá, quando falamos CPU, estamos falando deste quadradinho aqui. Seja da Intel ou da AMD, é o processador central. Porém, quando o sistema operacional fala em "CPU" está se referindo a um único núcleo ou a uma única thread. Vocês já devem ter visto que a CPU do seu PC ou notebook pode ter 4 núcleos e 8 threads. Isso porque a maioria das CPUs modernas suporta um troço chamado HyperThreading, onde cada núcleo é compartilhado por até 2 threads. As duas ao mesmo tempo não conseguem funcionar em capacidade máxima, claro. 

  
  
  
  
  
  
  

Só uma única thread consegue saturar um núcleo. Mas no dia a dia, raramente você está saturando tudo, então 2 threads conseguem compartilhar os recursos de um núcleo e simular 2 processamentos paralelos. Enfim, quando ver em Linux falar em CPU pense que é a thread. Meu Ryzen 9 tem 16 núcleos e 32 threads ou 32 CPUs. Isso porque bem antigamente, de fato uma CPU era só um núcleo. Só dos anos 2000 pra cá que começamos a explorar múltiplos núcleos no mesmo die, ou processador, que é o quadradinho na minha mão.

  
  
  
  
  
  
  

Aproveitando, num terminal todo mundo sabe que se digitar `ls` vai listar os arquivos no diretório, certo? Mas sabiam que existem vários programas `ls` -alguma coisa? Faz o teste, abre um terminal, digita `ls` e dá "tab". Olha no meu, vários comandos diferentes. Nos videos de Linux já mostrei o `lsblk` lembram? Que lista os dispositivos de bloco do sistema, no caso seus HDs ou SSDs. Olha só os meus. E se você usa Snap pra instalar programas vai ter essa poluição de dispositivos de loop aqui, mas pode ignorar isso.

  
  
  
  
  
  
  

Pra agora nos interessa `lscpu` com a opção "-e". Ele lista todas as threads disponíveis no meu processador, o clock máximo e mínimo que aguenta e o clock atual no final. Não sei se sabiam disso mas hoje em dia os clocks são controlados dinamicamente. Eles aumentam ou diminuem dependendo da carga que mandarmos. Isso é importante pra economizar energia. Se estamos fazendo quase nada, o chip elege deixar as threads em clock mais baixo.

  
  
  
  
  
  

Alguém poderia pensar: "boa, quer dizer que quando eu mandar fazer coisas pesadas como renderizar video, vai subir todo mundo pra esse máximo aqui então?" E na realidade não. Depende do governador do sistema operacional, depende dos algoritmos e sensores de Precision Boost da AMD ou Turbo Boost da Intel. Eles tentam ser mais inteligentes do que só subir tudo pro máximo ou desligar tudo pro mínimo. 

  
  
  
  
  
  

Se eu forçasse todos pra ficar em 5Ghz, não ia aguentar muito tempo, porque todos os núcleos iam consumir mais energia, e esquentar muito mais. E todos atingindo temperaturas altas demais, tipo mais de 90 graus Celsius, o processador vai entrar em modo de proteção e fazer o que se chama de throttling, que é diminuir a energia e diminuir o clock pra conseguir resfriar.

  
  
  
  
  
  
  

Por isso que parece contra o bom senso, mas muitos fazem undervolting. Que é limitar a energia e evitar de chegar em clocks tão altos. Mas qual a vantagem disso, não fica mais lento? Pensa assim, é melhor todas as threads funcionarem por mais tempo abaixo de 4Ghz do que ir pra 5Ghz, esquentar demais, e daí a CPU forçar todo mundo pra baixo de 2Ghz até esfriar. Entenderam? Devagar e sempre é melhor que pico rápido e cansa rápido. Em notebook que não tem espaço, undervolting é a única solução. Em PC com espaço a solução é colocar um cooler melhor.

  
  
  
  
  
  
  

Enfim, clocks não importam pra hoje, mas se não conheciam é legal estudar as configurações de Precision Boost ou Turbo Boost que tem na UEFI da sua placa mãe. Placas baratas não permitem mexer muita coisa, mas as placas mais avançadas e mais caras costumam dar mais opções de tensão, corrente, e tudo mais que afetam os clocks. Mas vamos voltar pro `lscpu`. Pra fazer a tal pinagem de VCPU pra CPU real precisamos saber o número real das CPUs que é a primeira coluna, de 0 até 31. Mas os núcleos ou cores de verdade é a 4a coluna. Veja como cada núcleo tem 2 threads como expliquei agora pouco.

  
  
  
  
  
  
  

Mas e aí, é só pegar 16 quaisquer, colocar lá naquele XML e já era? Não, pra saber baixamos o pacote hwloc. Execute `lstopo` no terminal e vai aparecer uma janela gráfica parecida com essa. No lado direito mostra os dispositivos conectados em pistas ou lanes de PCI. São coisas como SSDs. Isso também não interessa, o importante é bloco maior na esquerda. Entenda, pra uma CPU, uma thread, funcionar de forma eficiente, ela precisa ter acesso aos dados que vai processar no momento em que for processar.

  
  
  
  
  
  
  

Se toda instrução tiver que pausar e esperar procurar na RAM e trazer pra CPU, tudo seria lento, a CPU ia desperdiçar clocks não fazendo nada além de esperar. Isso porque RAM é super lenta comparado com um registrador, que é quase instantâneo. Mesmo minha CPU rodando na média a 3.4Ghz e estar usando DDR4 de 4 Ghz, não é só o clock. O barramento é lento, tem distância física da CPU até os pentes de memória, tudo isso afeta o desempenho. Inclusive é uma das razões de notebooks modernos soldarem RAM na placa mãe: pra diminuir a distância física.

  
  
  
  
  
  
  
  

Pra evitar que uma CPU fique com fome de dados e pause, cada uma delas tem um pequeno cache L1, nesse caso de 32 kilobytes e um cache L2 de meio megabyte. Parece pouco, mas é bastante coisa pra uma única CPU e elas ficam literalmente grudados a milimetro de distância só. Se tudo correr bem, esses caches vão ter os dados que as CPUs precisam, na hora que precisam e nada pausa. L1 é a memória mais rápida e mais cara de todas, por isso tem tão pouco. L2 é um pouco menos rápido, e L3 é mais lento que L2. Preste atenção nesse diagrama.

  
  
  
  
  
  
  

A parte importante é que diferente de L1 e L2 que são exclusivos por CPU, o cache L3 é compartilhado com um grupo de CPUs, no caso temos dois blocos de L3 de 32 megabytes cada, compartilhado entre 8 núcleos cada. Digamos que tem uma thread de C ou Java rodando no núcleo 0. Por alguma razão o scheduler do Linux gostaria de usar o núcleo 0 pra outra coisa e resolve mover a thread que ainda não acabou do núcleo 0 pro núcleo 3. 

  
  
  
  
  
  

Como ambas compartilham o mesmo cache L3, se o estado dessa thread, quer dizer, imagine as variáveis dentro da thread, estiverem no L3, basta parar a thread do núcleo 0 e reiniciar no núcleo 3 que vai continuar de onde parou sem problemas. Mas digamos que o scheduler do Linux fosse burro e mandasse pro núcleo 15, o último.

  
  
  
  
  
  
  

Antes de conseguir iniciar a thread no núcleo 15, ele precisa primeiro copiar o bloco de memória do 1o cache L3 pro segundo cache L3, senão a nova thread não sabe como continuar o trabalho. Sacaram? Um scheduler de threads tem que ser inteligente pra gerenciar esse tipo de coisa. E essa é a dica pra podermos pinar, ou seja, reservar CPUs pra nossa máquina virtual: queremos pegar todas as CPUs embaixo do mesmo cache L3. No meu caso, os núcleos de 0 a 7 ou de 8 a 15. Vamos voltar pro terminal e ver a saída do comando `lscpu` de novo.

  
  
  
  
  
  
  
  

Eu arbitrariamente escolho usar os núcleos de 8 a 15 e nessa listagem significa pegar as threads de 8 a 15 e de 24 a 31. Agora vamos voltar pra configuração XML. Estão vendo aqui os atributos "cpuset"? São exatamente as threads de 8 a 15 e de 24 a 31. Eu mapeei pras CPUs virtuais ou VCPUs de 0 a 15. Essa configuração vai variar se eu quiser passar menos CPUs, ou se o processador tiver menos núcleos e com outra topologia de caches L3, por isso precisa usar os comandos `lscpu` e `lstopo` pra decidir no seu sistema. Cada um vai ser diferente dependendo do modelo de processador.

  
  
  
  
  
  
  
  
  

Essa opção "emulatorpin" é pra dizer pro controlador da máquina virtual onde rodar as tarefas que permitem a máquina virtual funcionar. Mas até aqui só dissemos pra máquina virtual, quais CPUs usar. Meu host Manjaro ainda enxerga todas as 32 threads e pode querer usar as mesmas que mandei o guest usar. Como fazer pro host só usar os núcleos do primeiro cache L3? De 0 a 7? Vamos de volta pra Wiki.

  
  
  
  
  
  

Tem várias formas diferentes,  poderia permanentemente limitar meu Linux a só usar os núcleos de 0 a 7, mas isso seria um desperdício quando não estiver usando máquina virtual. Em vez disso quero forçar o Manjaro a se limitar só quando iniciar a máquina virtual e pra isso  posso usar o SystemD. Lembra que SystemD faz bem mais que só gerenciar daemons no boot? Aqui ele gerencia os cgroups do sistema. Chegou a hora de explicar mais alguns termos que vocês não conhecem.

  
  
  
  
  
  
  
  

Antes de criarmos a máquina virtual falei que precisava instalar os pacotes do virt-manager, que é a interface gráfica pra criar a máquina virtual, mas também instalei qemu e libvirt sem explicar. Tentando ser curto é assim, o emulador propriamente dito é o QEMU que literalmente significa "Quick Emulator". Ele quem vai simular a máquina virtual, rodar os programas virtualizados e passar instrução a instrução pra máquina de verdade por baixo. O equivalente VirtualBox ou VMWare ou Hyper-V seria o QEMU.

  
  
  
  
  
  
  

Na realidade ele faz bem mais que isso. Uma das principais funções é fazer tradução binária dinâmica. Pra quem usa Mac é o equivalente ao Rosetta. E pra quem não usa Mac, o que é Rosetta? 2 anos atrás a Apple saiu fora de usar processadores da Intel, que é padrão x86-64 e passou a usar chips M1 que eles mesmos desenvolveram, derivado de ARM. É meio como pular de um chip que fala português pra outro que fala chinês.

  
  
  
  
  
  

Funciona assim, digamos que eu tenha um programa compilado pra x86. Um trecho desse programa, em assembly poderia ser como esse aqui na tela. Não sei assembly de x86 então pedi pro ChatGPT gerar esse trecho pra mim, de bater o olho parece fazer sentido. Daí pedi pra escrever como seria a tradução que o QEMU faria pra  ARM64 e ele me deu esse outro trecho.

  
  

```

; x86-64

mov rax, [rdi] ; Load the value at the address in rdi into rax

mov rbx, [rsi] ; Load the value at the address in rsi into rbx

cmp rax, rbx   ; Compare the values in rax and rbx

jg greater     ; If rax is greater than rbx, jump to the "greater" label

jmp done       ; Jump to the "done" label

  

greater:

  mov [rdi], rbx ; Store the value in rbx at the address in rdi

  jmp done       ; Jump to the "done" label

  

done:

  ret            ; Return from the function

```

  

```

; arm64

ldr x0, [x1] ; Load the value at the address in x1 into x0

ldr x2, [x3] ; Load the value at the address in x3 into x2

cmp x0, x2   ; Compare the values in x0 and x2

b.gt greater ; If x0 is greater than x2, jump to the "greater" label

b done      ; Jump to the "done" label

  

greater:

  str x2, [x1] ; Store the value in x2 at the address in x1

  b done       ; Jump to the "done" label

  

done:

  ret          ; Return from the function

```

  
  
  

Estão vendo como os mnemônicos são diferentes? Em Intel existe a instrução `mov` pra carregar valores, mas em Arm a instrução se chama `ldr`. Se assistiram meus videos da playlist de Como Computadores Funcionam eu falo mais sobre como Assembly e instruções de baixo nível como esses funcionam, assistam lá depois.

  
  
  
  
  
  
  

Naquele pacote `qemu-desktop` que instalamos vem só dois emuladores: o `qemu-system-x86_64` e o `qemu-system-i386` que são os emuladores de plataforma Intel de 64 bits e 32 bits. Mas existem outros emuladores pra diversas plataformas como ARM. Pra isso tem que instalar o pacote `qemu-emulators-full` ou direto tudo com `qemu-full` e aí ganhamos emuladores como `qemu-system-aarch64` pra ARM, mas olha a lista: tem os antigos MIPS, Alpha ou até Motorola 68000 mas tem coisa nova como Risc V. Quem tem interesse em programar baixo nível pra Risc V, pode criar máquina virtual com esse emulador. Leiam também a página de Wiki específica de QEMU depois pra aprender tudo.

  
  
  
  
  
  
  
  

Traduzir de uma arquitetura pra outra é bem lento mas no caso, pra rodar Windows de Intel em cima de um Linux compilado pra Intel, não tem tradução nenhuma envolvida. Só precisa pegar a instrução da máquina virtual e passar direto pra máquina real embaixo, é bem menos trabalhoso e por isso a performance é quase inteira mantida. Uma CPU virtual funciona uns 15 a 20% mais devagar por conta dessa intermediação do QEMU no meio. Mas sem configurar nada, mesmo de Intel pra Intel, um Windows rodaria lento emulado, e o culpado não é o QEMU.

  
  
  
  
  
  
  

A culpa são dos dispositivos da máquina: memória, HD, rede, e tudo mais é virtualizado em software, porque a máquina virtual não pode acessar o hardware diretamente, só a kernel do Linux rodando de verdade no metal é que pode. Por isso a AMD e Intel criaram as instruções VT-d, pra permitir passar acesso aos dispositivos reais diretamente, sem precisar gambiarrar com software no meio. Por isso lá no começo o Wiki manda checar se seu sistema suporta VT-d e VT-x.

  
  
  
  
  
  
  

Tendo essas instruções agora é tarefa da kernel do sistema operacional usar. No Windows isso é responsabilidade do Hyper-V. No MacOS é o "Hypervisor.framework". Num BSD Unix o nome é bizarro, se chama "bhyve", que significa "BSD Hypervisor". Um hypervisor dá acesso às instruções VT-d e VT-x da Intel ou AMD-V da AMD, permitindo criar e gerenciar múltiplas máquinas virtuais rodando em cima deles. No Linux, o módulo responsável por isso se chama KVM, que significa "Kernel Virtual Machine".

  
  
  
  
  
  
  

Eu detesto esse nome porque KVM também significa Keyboard, Video and Mouse e é uma caixinha onde conectamos, teclado, video e mouse, e podemos ligar em vários PCs diferentes, tipo numa lan house ou data center. Daí é só virar uma chavinha pra escolher qual PC queremos controlar. O nome deve ter sido de propósito porque o Kernel Virtual Machine ou KVM de Linux serve pra justamente gerenciar múltiplas máquinas também, só que virtuais.

  
  
  
  
  
  
  

Só o QEMU sozinho seria lento, pela falta de acesso ao hardware. Mas ele aceita usar aceleradores. E o KVM pode ser usado como acelerador e por isso chamamos a solução de "QEMU/KVM". Entendido isso falta só mais um componente, o tal do "libvirt" que é o daemon que habilitamos no SystemD. KVM não é o único hypervisor que existe no Linux. Um pouco antes dele, existia outro chamado Xen, e tem alternativas comerciais, como o VMWare. 

  
  
  
  
  
  
  

Seria um saco ter que saber os comandos específicos de cada um, e é pra isso que o libvirt serve: ele é o intermediário que fala com hypervisors de Linux. Eu posso controlar qualquer um com o mesmo comando `virsh` que mencionei antes. A interface gráfica "Virt Manager" que usei pra criar a máquina virtual de exemplo, por baixo, provavelmente usa esse comando, e eu poderia ter criado a máquina direto do terminal com esse comando também, só fazer `virsh create ...`

  
  
  
  
  
  

O comando virsh é complexo, posso controlar todos os aspectos de um ambiente virtual come ele. Criar redes virtuais, pools de storage, snapshots e mais. Vale a pena estudar depois, mas pra hoje eu preciso de bem pouca coisa dele. Enfim, agora vocês sabem o que é libvirt, KVM e QEMU.

  
  
  
  
  
  

Antes dessa longa tangente eu tinha parado no problema onde já configuramos a máquina virtual pra só falar com as threads de 16 a 31 e agora precisamos obrigar o scheduler do Linux host a só falar com as threads de 0 a 15. Dessa forma cada sistema tem seu grupo de núcleos isolados. Isso é importante porque senão do nada o guest pode começar a engasgar quando o host ficar roubando as threads do guest.

  
  
  
  
  
  
  

Como falei antes, o libvirt é responsável por falar com o KVM pra fazer coisas como iniciar ou parar uma máquina virtual. Depois que minha máquina estiver configurada direitinho, é só fazer `virsh start` e o nome da máquina e pra desligar forçado, equivalente a apertar o botão de força de um PC, é só executar `virsh destroy`.  Felizmente o libvirt tem eventos e hooks, ou ganchos, onde podemos pendurar scripts. 

  
  
  
  
  
  

A Wiki nos manda criar o script `/etc/libvirt/hooks/qemu`. Toda vez que o QEMU iniciar ou parar, o libvirt vai chamar esse script. Se receber o comando `started` usamos o systemd pra ajustar a propriedade AllowedCPU de 3 cgroups pra permitir usar só as threads de 0 a 15. Dessa forma finalmente garantimos que de 16 a 31 vai mesmo ser só pra máquina virtual. E quando vier o comando "release", ajustamos pra voltar a permitir usar todos os núcleos. Agora é só reiniciar o serviço `libvirtd` e pronto. Isso termina a longa configuração de pinar VCPUs.

  
  
  
  
  
  

Vamos testar pra ver se funciona. Primeiro, sem nenhuma máquina virtual rodando, vou executar o programa GeekBench, que todo canal no YouTube que faz reviews de processador usa, e pular direto pros testes de multi-core. Olha o htop rodando em outro terminal e sim, todas as minhas 31 threads estão sendo trabalhadas. Podemos cancelar e agora abrir uma máquina virtual qualquer que já tenho configurado. Fazendo isso o libvirt vai atirar o evento de started pro hook e executar aqueles comandos de systemd.

  
  
  
  
  
  
  

Pronto, o guest tá carregado, voltamos pro terminal e executamos o GeekBench de novo. Vou pular pros testes de multi-core como antes. Voltamos pro htop: só as threads de 0 a 15 estão saturados. As threads de 16 a 31 estão sem fazer nada, reservados pro guest poder usar sem ninguém atrapalhando. Sacaram? É assim que garantimos que se eu estiver jogando na máquina guest e o Host decidir processar alguma coisa, não vai sequestrar uma thread minha e causar engasgos no meu jogo. Conseguimos controlar o processador com sucesso!

  
  
  
  
  
  
  
  

Mas o que são aqueles system.slice, user.slice e init.scope? São control groups, ou cgroups. Cgroups é um recurso de Linux pra organizar processos em agrupamentos, daí podemos limitar acesso a recursos pro grupo todo. Nesse caso estamos limitando acesso à CPU pra esses 3 grupos e a kernel vai enforçar isso. Aliás, pra quem não sabia, é combinando cgroups com outro recurso da kernel, namespaces, que começa a formar as bases pra containers como Docker. Mas isso fica pra outro episódio.

  
  
  
  

```sh

#!/bin/sh

  

command=$2

  

if [ "$command" = "started" ]; then

    systemctl set-property --runtime -- system.slice AllowedCPUs=0-15

    systemctl set-property --runtime -- user.slice AllowedCPUs=0-15

    systemctl set-property --runtime -- init.scope AllowedCPUs=0-15

elif [ "$command" = "release" ]; then

    systemctl set-property --runtime -- system.slice AllowedCPUs=0-31

    systemctl set-property --runtime -- user.slice AllowedCPUs=0-31

    systemctl set-property --runtime -- init.scope AllowedCPUs=0-31

fi

```

  
  
  

Mais um detalhe, esse hook vai rodar toda vez que qualquer máquina for iniciada ou parada pelo QEMU. No meu caso sempre pretendo criar máquinas virtuais com exatamente os mesmos núcleos pinados, então pode rodar sempre. Mas se você quiser máquinas com mais ou menos núcleos, precisa de um hook diferente pra cada máquina. E isso é simples. Em vez do script anterior de systemd em `/etc/libvirt/hooks/qemu` eu colocaria este outro script mais complicadinho:

  
  
  

```

GUEST_NAME="$1"

HOOK_NAME="$2"

STATE_NAME="$3"

MISC="${@:4}"

  

BASEDIR="$(dirname $0)"

  

HOOKPATH="$BASEDIR/qemu.d/$GUEST_NAME/$HOOK_NAME/$STATE_NAME"

  

set -e # If a script exits with an error, we should as well.

  

# check if it's a non-empty executable file

if [ -f "$HOOKPATH" ] && [ -s "$HOOKPATH" ] && [ -x "$HOOKPATH" ]; then

    eval \"$HOOKPATH\" "$@"

elif [ -d "$HOOKPATH" ]; then

    while read file; do

        # check for null string

        if [ ! -z "$file" ]; then

          eval \"$file\" "$@"

        fi

    done <<< "$(find -L "$HOOKPATH" -maxdepth 1 -type f -executable -print;)"

fi

```

  
  
  

Não vou explicar linha a linha, é um script de shell. Se você entende de Linux é fácil. Toda vez que o QEMU iniciar uma máquina virtual, esse script vai rodar. Vai pegar o nome da máquina, digamos que seja  `win11-video` e vai procurar o esse script `/etc/libvirt/hooks/qemu.d/win11-video/qemu` e lá podemos colocar aquele script anterior de systemd mas agora ajustando exatamente quais CPUs vou permitir pro host pra essa máquina virtual em particular, sacaram?

  
  
  
  
  
  

O perfil de boost da CPU é controlado por uma coisa chamada Governador da Kernel. Sabe nas configurações de energia de qualquer sistema operacional, especialmente em notebooks, que você escolhe Balanceado, Modo de Economia ou Alta Performance? É isso. Normalmente o Linux se configura em perfil Balanceado, mas eu gostaria de forçar pra perfil de performance antes de iniciar meu Windows de games. Pra isso existe o comando `cpupower`. Só rodar `cpupower frequency-set -g performance` e pronto. Estude sobre `cpupower` depois pra descobrir se sua CPU tá em modo balanceado ou economia e você nem sabia. 

  
  
  
  
  
  
  
  

Voltando pra configuração XML, vou copiar e colar vários blocos. Isso tudo tá explicado na Wiki mas não compensa ir um a um. Em resumo, o bloco de features declara quais funcionalidades essa máquina vai ter, como ACPI que é um padrão pra controlar energia da máquina. Relevante aqui é esse trecho de KVM com estado escondido. Isso é uma tentativa do KVM de tentar esconder do sistema virtualizado que ele está numa máquina virtual. Antigamente GPUs da NVIDIA davam erro se descobriam que estavam sendo virtualizados, mas nos modelos mais novos isso não acontece. Talvez se tentar usar algo mais velho que uma GTX talvez precise, e também desse outro atributo de vendor_id em cima.

  
  
  
  
  
  
  

Nos blocos de baixo, importante é deixar CPU em modo "host-passthrough" e checar que a topologia está de acordo com todo o trampo que fizemos no bloco de pinagem antes. Aqui tá certinho, 1 soquete, com 1 processador, 8 núcleos e 2 threads cada, totalizando as 16 threads que pinamos. No meu caso que estou usando AMD Ryzen, precisa dessa feature "topoext", senão não dá pra usar hyperthreading. Em Intel não precisa. E pronto, acho que isso resolve a configuração da CPU. O Virt-manager podia já fazer tudo isso automaticamente pra gente, mas até lá precisa saber esses detalhes todos pra tirar o máximo do processador. Por isso precisa ler a Wiki em detalhes.

  
  
  
  
  
  
  
  

Continuando, o Virt-manager já adicionou alguns dispositivos que podem ser estranhos como esse Display Spice e Video QXL. QXL significa "Qemu eXtended Logical" e é uma placa de video virtual. Podemos escolher outros modelos e eu preferi deixar em Virtio que tem essa opção de aceleração 3D. Não espere nenhuma mágica disso ser capaz de rodar games, mas já é alguma coisa. Esse dispositivo é necessário em máquinas onde não temos ou não queremos dedicar placa de video de verdade só pra ela como estou fazendo.

  
  
  
  
  
  
  

Na real, fiz um teste bem besta. Bootei o Ubuntu virtualizado com Video QXL e testei abrir o firefox e carregar um demo de WebGL. Daí eu desligo, mudo de QXL pra Virtio com aceleração 3D e não faz nenhuma diferença, tenho os mesmos quadros por segundo. Das duas uma, ou o QXL também faz aceleração 3D ou o Virtio não tá acelerando nada, mas seja lá qual for o caso, o resultado parece o mesmo então meio que tanto faz. Até porque o objetivo de usar esses dispositivos virtuais não é fazer nada pesado graficamente como animação 3D ou jogos. Pra renderizar a interface gráfica de janelas, a velocidade é mais que suficiente.

  
  
  
  
  
  
  
  
  

SPICE é um protocolo pra acessar a interface gráfica remotamente, mais ou menos como um VNC ou Remote Desktop de Windows ou mesmo passar X via SSH pra quem é de Linux, mas é mais performático. Nunca vai ser rápido o suficiente pra games, mas pro dia a dia é suficiente. Então, Display SPICE é o monitor virtual que vai mostrar o que sai da placa virtual com Virtio. E vai aparecer aqui nessa aba com ícone de monitor. Deixa eu mostrar como é com outra máquina virtual que já tinha configurado que é um Ubuntu. Nesse Ubuntu não passei minha NVIDIA, então só tem a placa virtual mesmo, já que uso pra testes e não pra jogar nem nada mais pesado. (liga máquina)

  
  
  
  
  
  
  
  
  

No meu caso, salvo pra casos de sistemas de testes como esse Ubuntu, pretendo passar a placa de video real da NVIDIA pra dentro do guest. Então depois que instalar o sistema operacional e os drivers, vou tirar o Video Virtio e o Display SPICE. Mas um terceiro dispositivo que ainda tenho um pouco de dúvidas é o Console PTY. Isso é um terminal virtual de texto que conecta num pseudo-terminal PTY do host. É uma das formas do host se comunicar com o guest e vice-versa. Antes podia arrancar isso fora, mas não sei se teve alguma atualização que sem o console eu não tava conseguindo bootar a máquina virtual direito, então só deixo lá agora.

  
  
  
  
  
  
  
  
  

Agora vem o dispositivo de som. Pra maioria dos casos pode deixar o que vem por padrão já. Ele emula um dispositivo ICH9 que permite entrada e saída em estéreo. Se precisar usar microfone, acho que essa é a melhor opção. Mas se tiver um home theater, no caso um receiver ligado no PC com configuração de surround ou 5.1, que significa duas caixas laterais frontais, duas caixas traseiras surround, um central pra voz e um sub-woofer que é esse .1, daí precisa mudar no XML pro modelo ser "usb". Áudio via USB desse dispositivo suporta saída 5.1 mas não fornece entrada.

  
  
  
  
  
  
  

Áudio em Linux é outro ninho de ratos chato mas no geral, na maioria das distribuições Linux funciona assim: primeiro tem os drivers pro hardware de áudio, seja o que vem embutido na sua placa mãe ou dispositivos externos. Esses drivers são chamados de ALSA, que significa Advanced Linux Sound Architecture. Mas os aplicativos, como um tocador de música ou video, não fala diretamente com esses drivers.

  
  
  
  
  
  
  

Entre os aplicativos e os drivers existe um intermediário que roda em userland que normalmente é o Pulseaudio. Tem também o Jack mas nunca vi o Jack em distros populares. O Pulseaudio é quem permite múltiplos aplicativos acessarem saída de áudio, organiza e centraliza o controle de múltiplos streams. Sabe quando abre a configuração de som num GNOME  e ele deixa controlar o volume independente pra cada aplicativo? É o Pulseaudio. 

  
  
  
  
  
  
  

Eu não acompanhei a evolução, mas parece que o Pulseaudio, sendo um sistema antigo e legado, envelheceu mal pra lidar com o aumento no uso de multimídia de aplicativos modernos, especialmente necessidades profissionais, como editores de música que precisam trabalhar com dezenas ou centenas de streams de áudio de uma só vez e exigem baixíssima latência. Latência em áudio é crucial. Imagina um notebook de DJ no meio de um show enorme, e do nada latência dá um pico, trava e quebra o som no meio do show por 1 segundo. É o tipo de coisa que jamais pode acontecer. É um dos pontos fortes do MacOS, por isso todo mundo usa Macbooks em shows.

  
  
  
  
  
  
  
  

Pra combater isso nasceu um novo projeto, o Pipewire. Algumas distros modernas, como meu Manjaro, já começaram a substituir o Pulseaudio pelo Pipewire. Parece que Pipewire também tem suporte melhor a áudio via Bluetooth, então quem tinha problemas com fones sem fio, deve ter uma experiência melhor agora. Outra vantagem do Pipewire é ter uma camada de compatibilidade de API, daí aplicativos que esperam trabalhar com Pulseaudio conseguem se comunicar com o Pipewire. De qualquer forma, na configuração do QEMU não precisamos mexer nada. No XML que ele nos deu já vem esse canal de áudio apontando pra pulseaudio. Eu estou usando Pipewire no Manjaro e tá tudo funcionando então acho que funciona plug and play.

  
  
  
  
  
  
  
  

Áudio é um troço que dependendo do seu caso de uso, pode dar dor de cabeça. No Wiki que estamos seguindo, ele detalha direitinho como configurar pra pulseaudio, pipewire, jack, scream e mais. Se precisar muito tem como configurar na mão coisas como latência, bitrate. Por exemplo, pode dar problemas se no guest o som estiver configurado pra sair em 48 mhz e no host estiver pra 44 mhz. Se tiver sorte, como eu, não vai precisar mexer em nada. Mas só lembrando que se tiver problemas, tem que fuçar essa parte da documentação.

  
  
  
  
  
  
  

Chegamos no evento principal: passar a placa de video real NVIDIA pra dentro da máquina virtual. E se fez tudo direitinho lá no começo com IOMMU e VFIO, agora é só clicar em "adicionar hardware" aqui embaixo, escolher categoria PCI, e selecionar a RTX 3090 que tá separadinha já pra gente. Lembram como no mesmo grupo de IOMMU tinha esse dispositivo de áudio da NVIDIA? Precisa adicionar também, senão a máquina não vai bootar. Mas é só isso. 

  
  
  
  
  
  
  

Comparado com os outros dispositivos que tivemos que configurar, a GPU é a mais fácil. Mais fácil ainda que teclado e mouse, que é nosso próximo passo. O ideal seria ter dois teclados e dois mouses, um conjunto ligado no host, e o outro pra passarmos pra máquina virtual, mas seria bem pouco prático fazer isso. Lembra quando falei sobre o KVM que não é o módulo de virtualização do Linux? O KVM que permite usar um conjunto de teclado e mouse e monitor e ficar chaveando pra mudar de um PC físico pra outro PC físico? É o que vamos fazer.

  
  
  
  
  
  
  

O chaveador virtual de teclado e mouse se chama EVDEV que é acrônimo pra "event device". Olha no Wiki o que ele manda fazer. Temos que listar o que tem no diretório `/dev/input/by-id`. No meu caso tem todos esses aqui, o mais importante são os dois primeiros. Basta no XML, dentro do bloco de "devices" adicionar o seguinte:

  
  

```xml

    <input type="evdev">

      <source dev="/dev/input/by-id/uinput-persist-mouse0"/>

    </input>

    <input type="evdev">

      <source dev="/dev/input/by-id/uinput-persist-keyboard0" grab="all" repeat="on"/>

    </input>

    <input type="mouse" bus="virtio" />

    <input type="keyboard" bus="virtio" />

```

  
  
  

Com isso, posso mover meu teclado e mouse pra dentro do guest ou pra fora no host apertando as teclas control da esquerda e da direita do teclado de uma só vez. No Wiki explica também se quiser mudar essa combinação de teclas. Só que na minha configuração de hardware em particular, o mouse não passa como deveria. Vamos entender porque. No terminal, podemos dar `cat` nesses dispositivos. Olha o que acontece se der `cat` no teclado.

  
  
  
  
  
  

Viram? Toda tecla que digito aparece o código aqui. É isso que o sistema operacional fica recebendo antes de traduzir pra letras. Vamos fazer a mesma coisa no primeiro dispositivo de mouse. Dou `cat`  e mexo o mouse e nada acontece. Isso porque estou usando um receptor sem fio USB que é esse outro dispositivo Logitech USB Receiver aqui em baixo. Tem 4 deles, mas depois de tentativa e erro descobri que é esse que termina com "event-mouse". Só dar `cat` nele e olha só recebendo eventos. Portanto devo mudar o XML pra ficar assim:

  
  

```xml

    <input type="evdev">

      <source dev="/dev/input/by-id/usb-Logitech_USB_Receiver-if01-event-mouse"/>

    </input>

    <input type="evdev">

      <source dev="/dev/input/by-id/uinput-persist-keyboard0" grab="all" repeat="on"/>

    </input>

    <input type="mouse" bus="virtio" />

    <input type="keyboard" bus="virtio" />

```

  
  
  
  

Pronto, agora sim o meu mouse vai funcionar. Por isso precisa entender o que realmente está acontecendo e o que cada configuração significa. Falta só mais uma coisinha pra continuar que é baixar a imagem ISO de CD com os drivers pra todos os dispositivos virtuais que configuramos. Sabe, todo lugar que selecionamos a opção de "virtio"? O que é VirtIO? Como o nome diz é "Virtual I/O", é um nome genérico pra um conjunto de drivers pra esses dispositivos virtuais. O instalador do Windows não tem idéia de que diabos são dispositivos virtio, então precisamos dar os drivers pra ele.

  
  
  
  
  
  

O link vai estar nas descrições abaixo, mas quem mantém esses drivers é a RedHat e tem todas as versões nesta página da comunidade do Fedora. Só escolher a versão mais recente aqui embaixo e agora baixar este arquivo de ISO de 500 mega. Todos os drivers que vamos precisar estão aqui.

  
  
  
  
  
  

Baixado, vamos voltar pra tela de configuração do Virt Manager. Adicionamos um novo hardware de storage, selecionamos o ISO que acabamos de baixar e configuramos pra ser um CD-ROM SATA. Olha aqui que tem outras opções, tem SCSI, tem USB e tem Virtio. Virtio não pode ser, porque Windows não sabe ainda o que é Virtio sem os drivers que estão justamente nesse ISO. USB não sei pra que serve. SCSI também não rola, porque o instalador do Windows também não detecta SCSI. Por eliminação vai ser SATA.

  
  
  
  
  
  
  

Padrão SATA é o mais comum e genérico e até o Windows consegue entender na instalação. Por isso tanto o ISO do instalador de Windows quanto o ISO dos drivers, vamos configurar como dispositivos de CD-ROM SATA. Mas o HD virtual, formato qcow2 que criamos, está como SATA, mas Virtio tem performance melhor, então mudamos. Só que assim o instalador não vai detectar o HD. Não tem problema, pra isso baixamos os drivers. Finalmente, chegou a  hora de bootar essa máquina.

  
  
  
  
  
  
  
  

Olha só como o video sai pelo Display SPICE que mostra aqui na própria janela. É basicamente um streaming do video gerado pela placa de video virtual Virtio. Ele vai detectar o CD-ROM e podemos fazer o boot, exatamente como faria se fosse instalar via pendrive no seu PC de verdade. Vou passar rapidinho essas primeiras telas porque todo mundo já viu isso antes.

  
  
  
  
  
  
  

Pronto, chegamos na parte que o instalador tenta achar o HD pra particionar, formatar e copiar os arquivos. Mas não acha nada, porque como expliquei antes, não tem nenhum HD SATA. Mas tem essa opção de "Load Driver". Podemos navegar pro CD do Virtio e ir pra pasta "amd64" logo no começo. Meio burro que o Windows não vasculhe o CD inteiro pra achar os drivers, mas beleza. E olha só, achou o driver da RedHat de controlador SCSI Virtio. E uma vez carregado, sucesso, agora sim ele acha o HD virtual e vai conseguir formatar e instalar. A partir daqui vou acelerar bastante a instalação pra terminar rápido. Terminando em, 3 ... 2 ... 1 ....

  
  
  
  
  
  
  

Terminou! Eis que estou no novo Windows virtualizado. Mas não acaba aqui. Primeira coisa a fazer é abrir o Gerenciador de Dispositivos. Olha só que coisa feia, um monte de dispositivos que o Windows não tem idéia do que fazer. Pra resolver isso temos que manualmente clicar com botão direito e mandar instalar o driver a partir do CD do Virtio. E pronto, um dispositivo configurado, vamos pros próximos. 

  
  
  
  
  
  

Agora sim, o Windows detectou corretamente tudo que precisava. Esses drivers Virtio são o que chamamos de drivers paravirtualizados. Em uma virtualização completa, o Windows não saberia que tá sendo virtualizado, ele ia ser iludido a achar que tá numa máquina de verdade. E todo driver responderia como se fosse um dispositivo de verdade por baixo e não um arquivo formato qcow2 fingindo ser um HD de verdade. Ou uma ponte com NAT fingindo ser uma placa de rede.

  
  
  
  
  
  

Já drivers paravirtualizados falam pro Windows: "ow, tu sabe que isso não é de verdade né?" e o Windows "porr, sérião? beleza, valeu por avisar, vamos trabalhar juntos nisso então". E sabendo que é virtualizado ele pode se comportar diferente de um driver normal pra otimizar performance. É uma explicação bem grosseira, mas o importante é que o Windows guest sabe que tá numa máquina virtual e vai agir de acordo e cooperar com o host por baixo pra ter mais performance.

  
  
  
  
  
  

A partir daqui é vida normal que segue. Vamos deixar o Windows Update atualizar o que precisa e baixar o resto dos drivers. Enquanto isso podemos ir no site da NVIDIA e baixar o GeForce Experience, que serve pra otimizar as configurações da GPU pra cada jogo. Ele também serve pra monitorar atualizações dos drivers e vamos instalar por ele. De novo, baixar e instalar é demorado então vou acelerar e terminar em 3 ... 2... 1...

  
  
  
  
  
  
  

Com todos os drivers instalados e tudo atualizado, rebootamos a máquina e tá tudo funcionando. O que podemos fazer agora é desligar a máquina e remover a placa de video virtual Virtio e o monitor virtual SPICE. A partir de agora o Windows vai usar direto só a RTX 3090 de verdade. Então vamos fazer isso. Sei lá porque sempre dá erro pra remover esses dispositivos e o mais fácil é entrar na configuração XML e apagar manualmente. Olha só que chato.

  
  
  
  
  
  

Feito isso, vamos bootar de novo. Mas dessa vez vou bootar outro Windows que já tá configurado, com Steam e tudo só pra demonstrar como fica. Nesse caso vou deixar o OBS também rodando por trás pra gravar o jogo.

  

(jogo)

  
  
  
  

O que acham? Isso é um game pesado rodando com velocidade normal como se estivesse num PC de verdade. Mas isso só é possível porque estou usando uma CPU parruda, a Ryzen 9 5950. Estou usando só metade dos núcleos, que são 16 threads, com uns 20% menos performance por thread. Mas isso é quase o equivalente a   rodar um processador Ryzen 5 por exemplo, que já é mais do que suficiente pra maioria dos jogos. 

  
  
  
  
  
  

Agora deixa mostrar um jogo incompatível com máquina virtual por causa do anti-cheat. Vamos carregar Elden Ring, esperar um pouco  e ... olha só, dá pau e fecha. Ainda bem que no caso específico do Elden Ring a gambiarra pra carregar offline é simples. Basta ir com o explorer no diretório do jogo, apagar esse executável que carrega o anti-cheat e renomear o executável do jogo propriamente dito com o mesmo nome. Pronto. Vamos carregar de novo e olha só, não deixa entrar online mas pelo menos posso jogar sozinho, que é o que eu queria.

  
  
  
  
  
  
  
  

Eu não jogo online, mas quem joga uns Valorant da vida, não vai funcionar em máquina virtual pelo mesmo motivo: o anti-cheat vai detectar que tá em máquina virtual e se não tomar cuidado você pode ser banido. Assim como Elden Ring, alguns jogos tem jeitos de burlar isso mas de novo, tome cuidado pra não ser banido. Mas existe uma última saída caso eu quisesse muito jogar isso. Vamos abrir a configuração desta máquina virtual no Virt Manager.

  
  
  
  
  
  
  

Diferente da máquina virtual de testes que tava montando pra esse video, essa outra máquina que mais uso não foi instalado num HD virtual qcow2. Eu já tinha esse Windows em dual boot instalado direto no SSD NVME. Era meu sistema principal antes de instalar o Manjaro. Olha aqui a configuração de armazenamento no Virt-Manager. Em vez de apontar pra um arquivo .qcow2 está apontando direto pro dispositivo `/dev/nvme0n1`. 

  
  
  
  
  
  
  

Digamos que eu queria muito jogar Elden Ring ou qualquer outra coisa que tenha anti-cheat online. Não tem jeito, a única forma é rodar num Windows nativo sem virtualizar. Nesse caso tenho que desligar meu Manjaro, rebootar e no Grub escolho Windows. Vamos acelerar aqui o boot e olha só, notaram? É exatamente o mesmo Windows que tava funcionando virtualizado. Felizmente, até o Windows é inteligente o suficiente pra detectar os dispositivos de verdade e carregar os drivers nativos certos em vez dos VFIO da máquina virtual. Eu posso usar o mesmo Windows tanto em dual boot nativo quanto virtualizado pelo QEMU/KVM.

  
  
  
  
  
  
  

E a partir daqui é um dual boot normal, sem nada de virtualização, com o Windows tendo acesso a 100% da CPU e às minhas duas placas de video. No caso de games, é onde vou ter o máximo possível de performance, caso precise. Mas se precisar de alguma coisa do Linux, preciso fechar tudo e rebootar de novo, um puta saco. Mas vamos voltar pro Manjaro de novo e abrir o Virt Manager, quero mostrar uma última coisa.

  
  
  
  
  
  
  
  
  

Se eu iniciar o Windows virtualizado por aqui, veja no gráfico que tá carregando, mas meu teclado e mouse páram de funcionar e não vejo nada no monitor. Isso porque o EVDEV que configurei sequestra meu teclado e mouse, mas isso é simples, basta apertar as duas teclas de control ao mesmo tempo, e o controle volta pro host Linux, olha só. E o Windows tá mandando sinal de video pela RTX 3090 que liga na segunda entrada de video do monitor. Eu preciso apertar o botão de menu aqui atrás e navegar até achar o lugar que muda qual sinal de HDMI o monitor vai mostrar. Olha só, tá aqui o Windows.

  
  
  
  
  
  
  

Vamos voltar pro cabo que sai da placa AMD e ficar no Linux um pouco. Notaram uma coisa irritante? Toda vez que eu abrir uma máquina virtual que usa a placa da NVIDIA precisa botar a mão atrás do monitor, caçar o botãozinho às cegas e mudar o input. Não, tem que ter jeito melhor, e de fato tem. Pesquisando, esbarrei nesta ferramenta chamada "ddcutil". Vale ler toda a documentação, mas deixa demonstrar o que ela faz.

  
  
  
  
  
  
  

Primeiro, vamos abrir o terminal e rodar `ddcutil detect` com sudo. E  detectou meus dois monitores. O primeiro é o Samsung vertical e o segundo é o Asus principal. Agora posso fazer `ddcutil capabilities --display 2 --verbose` e  lista todos os comandos que meu monitor Asus suporta. Olha só, posso mexer no brilho, contraste, cores, mas o que me interessa é esse comando hexadecimal `60` que é input source.

  
  
  
  
  
  

Teoricamente, se rodar `ddcutil setvcp 60 0x01` deveria mudar pra entrada de DisplayPort e com `0x03` deveria ir pra entrada DVI. Mas por alguma razão essa lista tá errada ou incompleta, porque não listou os HDMIs. Eu não lembro mais onde foi que achei mas pro meu monitor Asus ROG TUF encontrei em algum lugar que os valores corretos são `0x0f` e `0x12`. Olha só, `ddcutil setvcp 60 0x0f`. Viram só? Mudou pra saída da placa NVIDIA. Podemos repetir o comando só que com `0x12`  e olha só, voltou pra saída da placa AMD. 

  
  
  
  
  
  
  

Antes que alguém comente, sim, o que fiz com `ddcutil` teoricamente era pra funcionar com o comando `xrandr` mas por alguma razão não  funciona. Por isso procurei alternativas. Essas porcarias de servidor X.org e Wayland e essa transição até hoje ainda não tá 100%. Aliás, uma das razões de estar usando essa placa pequena AMD RX 6400 é justamente pra conseguir usar Wayland decentemente em vez de X.org. Dizem que NVIDIA já suporta ou vai suportar XWayland, mas ainda não parei pra ver isso. NVIDIA é um dos responsáveis pelo atraso na adoção de Wayland nas distros. Se for usar primariamente Linux, o recomendado é escolher placas de video da AMD.

  
  
  
  
  
  

Por último mesmo, tem um problema. Meu Manjaro eu deixo configurado pra depois de algum tempo, 1 ou 2 horas sem usar, fazer o sistema dormir pra economizar energia. Não gosto de desligar a noite antes de dormir e ter que esperar bootar de manhã. O problema é que enquanto estou usando a máquina virtual, o host tá como se ninguém estivesse usando. Então depois de 1 ou 2 horas, o host resolve que quer dormir. Só que quando isso acontece, congela a máquina virtual, porque o hypervisor vai dormir também, e aí trava tudo e eu preciso forçar um reboot no botão do PC.

  
  
  
  
  
  
  
  

Então criei um script chamado `bin/suspend` que aceita opção "on" ou "off" pra ligar ou desligar a função de dormir do GNOME usando o comando `gsettings`. Tem outras formas de fazer, se estiver em KDE ou outro gerenciador vai ser diferente, mas isso deve dar uma dica pra quem estiver interessado. Com esse comando, antes de ligar a máquina virtual eu rodo `bin/suspend off` e isso vai desligar a suspensão. E quando desligar a máquina virtual rodo `bin/suspend on` pra religar a função de suspensão da máquina e pronto.

  
  
  
  
  
  
  

Aproveitando, resolvi criar um script chamado `bin/vmstart` onde passo o nome da máquina. Olha o que ele faz: primeiro muda o governador das CPUs pro modo de performance. Em seguida desliga a configuração de suspensão do host. Finalmente, usa o comando `virsh start` pra iniciar a máquina virtual. Nesse momento a máquina vai bootar mas não adianta mudar a entrada do monitor já pra placa da NVIDIA porque até o Windows carregar não vai ter nenhum sinal de video. Então forço um sleep de 30 segundos e depois rodo o comando `ddcutil` pra mudar a entrada automaticamente. Vamos ver funcionando?

  
  
  
  
  
  

Rodo `bin/vmstart win11-real` que é minha máquina Windows principal onde tem meu DaVinci Resolve, Photoshop e onde edito os videos aqui do canal. Mais alguns segundos ... e pronto, olha só, Windows carregado. Agora posso iniciar qualquer das minhas máquinas virtuais via linha de comando, sem precisar abrir o Virt-Manager. 

  
  
  
  
  
  
  

Esse video já tá longo pra caramba, e isso porque pulei o que são Huge Pages na configuração de memória RAM, pulei falar de I/O threads e como reservar threads só pra operações de I/O, pulei falar de como dinamicamente mover coisas como meus gamepads USB pra máquina virtual automaticamente via "udev", pulei falar sobre como é mais fácil plugar um hub USB. Enfim, o Wiki tem um montão de detalhes a mais. É uma aula de como configurar seu hardware e mesmo que você não vá montar uma configuração complicada como a minha, recomendo dar uma boa lida com muita atenção.

  
  
  
  
  
  
  
  

Além da página de Wiki do Arch também recomendo ler a página de Wiki do Gentoo. Ele tem informações extras que complementam a do Arch e uns truques e correções importantes. Como eu disse, esses dois Wikis são excepcionais e pra montar configurações complicadas assim, toda informação extra é bem vinda. 

  
  
  
  
  
  
  

Com isso, finalmente consegui fazer uma coisa que vinha querendo faz mais de uma década: ter uma máquina com duas placas de video e conseguir passar uma delas pra máquinas virtuais funcionarem com performance máxima, especialmente pra games. Essa solução é melhor que dual boot porque posso subir quantas instalações de Windows ou Linux quiser, destruir quando não quiser mais, sem me preocupar em estragar o boot ou perder alguma coisa. Meus arquivos de HD Virtual qcow2 ficam no meu NAS que tá conectado com rede de 10 Gigabits, então mesmo bootando remotamente, a performance é muito boa. 

  
  
  
  
  
  
  
  

Como falei no começo, o objetivo era documentar tudo que tive que pesquisar pra montar esse setup antes que começasse a esquecer os detalhes. A partir daqui vou sempre ficar mexendo scripts, coisinhas aqui e ali pra ajustar performance ou conveniência.

  
  
  
  
  
  

O mais bizarro que não vou mostrar no video é que hypervisors suportam nesting, ou seja, máquina virtual rodar outra máquina virtual. Eu consigo virtualizar o Windows e, de dentro dele, instalar WSL e rodar Linux via Hyper-V em cima do Windows que tá em cima do QEMU/KVM. É Inception na veia. Além disso posso rodar o Garuda Linux, abrir o Steam que roda via Proton, que é uma camada que usa Wine e várias outras bibliotecas pra emular Windows. 

  
  
  
  
  
  

E falando em emulador, no outro Windows só pra jogos também instalei vários emuladores como o PCSX2 de PS2 ou RPCS3 de PS3 ou Yuzu de Nintendo Switch e mais. Emulador rodando dentro de emulador. Esse é o nível que eu esperava atingir 21 anos atrás quando comecei a mexer com máquinas virtuais. E por hoje é isso, se ficaram com dúvidas ou tiverem sugestões em cima desse setup, mandem nos comentários abaixo, se curtiram o video deixem um joinha, assinem o canal e não deixem de compartilhar o video com seus amigos. A gente se vê, até mais!
