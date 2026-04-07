---
title: Instalando Omarchy 2.0 do Zero - Anotações Pessoais
date: "2025-08-29T16:00:00-03:00"
slug: new-omarchy-2-0-install
tags:
  - arch
  - omarchy
  - btrfs
  - timeshift
  - lazyvim
draft: false
translationKey: new-omarchy-2-install
---

Eu tenho recomendado o [Omarchy 2.0](https://omarchy.org/) do DHH pra qualquer um que queira um ambiente de desenvolvimento leve, bonito e totalmente equipado. É um conjunto de configurações pra Hyprland rodando em cima de Arch Linux e vem com padrões inteligentes prontos pra usar. Assista o [video tour](https://www.youtube.com/watch?v=TcHY0AEd2Uw) mostrando as principais funcionalidades.

![meu omarchy](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250828_043020.jpg)

No meu caso, eu passei 10 anos usando Manjaro GNOME como meu daily driver. Manjaro que é um derivado de Arch. A razão era a instalação mais simples e configurações pré-prontas. Mas hoje em dia, com [archinstall](TODO), acho que não vale mais a pena. Sei que existem outros derivados, mas é melhor ficar no original mesmo.

Pra quem é de Ubuntu ou derivados de Debian, Fedora, etc, vai ter uma pequena curva de aprendizado no gerenciador de pacotes, Pacman e Yay em vez de Apt ou Dnf, mas quando entenderem o AUR, nunca mais vão querer outra coisa. Tem literalmente tudo que você precisa, sem ter que lidar com repositórios de terceiros.

Demorei pra testar o Omarchy porque eu já usava Hyprland antes do Omarchy ter sido criado. O DHH já tinha o Omakub antes, que era um conjunto de scripts pra customizar um Ubuntu pra ser um bom ambiente de desenvolvimento. Eu gostava dele mas como preferia Manjaro, fiz um fork chamado Omakub-MJ. Depois disso resolvi desinstalar o GNOME e GDM e instalar um outro conjunto de scripts chamado [ML4W](https://www.ml4w.com/), que deixa o Hyprland bem bonito também. Então o Omarchy não tinha tanta novidade, pra mim.

Só que eu uso o mesmo Manjaro já faz anos. Tinha um monte de configs e scripts velhos misturados. Meu Manjaro GNOME já não tinha mais GNOME. Meu Hyprland era Frankenstein. A única barreira era minha configuração de **QEMU/Libvirt** pra rodar Windows com [GPU passthrough](https://akitaonrails.com/2023/02/01/akitando-137-games-em-maquina-virtual-com-gpu-passthrough-entendendo-qemu-kvm-libvirt/), que era o que eu usava pra editar videos quando ainda postava no meu [canal do YouTube](https://www.youtube.com/@Akitando).

Mas como parei de editar videos, esse Windows também não é mais tão importante. Eu tinha outra máquina virtual Windows com GPU passthrough pra games. Mas atualmente tenho um mini-PC separado com Windows que uso só pra games. Também tinha outra VM com outro Linux só pros meus experimentos de I.A., mas desde então migrei pra rodar nativo isolando tudo com Docker. Ou seja, minhas VMs já não são mais importantes. Veja meus blog posts anteriores pra saber sobre I.A. em Docker.

Com o lançamento do Omarchy 2.0, parece uma boa hora pra reinstalar Arch do zero com Omarchy por cima e recomeçar com tudo limpo e bonito.

## 1 - Meu Setup

![meu PC](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250829_113734.jpg)

Cada caso vai ser diferente. Este post tem como principal função servir como minha referência pessoal pro futuro, se eu precisar reinstalar tudo de novo.

Não, não vou usar **NixOS**. Eu realmente não acho que compensa. Só vale a pena se você é administrador de sala de computador ou infraestrutura de servidores e seu dia a dia é ter que reconstruir setups idênticos de maneira confiável. Pra um usuário normal, que só vai reinstalar a cada 2 ou 3 anos, não vale nem um pouco a curva de aprendizado nem o trabalho de manutenção. É perda de tempo. Eu vou gastar dias aprendendo agora, terminar o setup, passar 2 anos e já vou ter esquecido tudo. Arch Linux sozinho já é estável o suficiente pra eu não precisar disso.

Meu setup ainda é o mesmo da época que estava editando videos pro canal. É um **Ryzen 9 7850X3D** com 16 cores, 32 threads, pico de 5Ghz. Ainda é um excelente CPU que tem poder de sobra pros meus usos, por isso não me vejo querendo atualizar tão cedo. São raras as vezes que eu consigo saturar tudo isso de core ao mesmo tempo nessas velocidades. Melhor ainda: ele tem GPU integrada AMD que torna instalar Linux mil vezes mais fácil do que se eu tivesse NVIDIA.

Mas, eu também tenho uma GPU discreta, separada, a **NVIDIA RTX 4090** (não, não preciso de uma 5090, tem o mesmo tanto de VRAM). Ela vai ficar pra tarefas secundárias e não pra carregar meu ambiente gráfico. Coisas como render de Cycles no Blender, ou rodar LLMs com ollama da vida. Antes eu usava GPU passthrough pra uma VM em QEMU/Libvirt pra rodar Windows em parelelo ao Linux. Tanto pra editar video quanto pra games.

Como não edito mais videos, não preciso desse setup complicado então nem vou me preocupar mais em instalar Libvirt de volta. Se eu precisar de Windows, vou deixar em dual boot. Se precisar editar video, hoje em dia temos DaVinci Resolve Studio que roda nativo em Linux (mil vezes melhor que Adobe Premiere). Pra games eu tenho um mini PC separado com uma RTX 4060 ligado na minha TV. Melhor coisa é ter um PC totalmente separado pra games.

Então este setup é pra ser um Linux puro, com acesso ao meu **NAS Synology DS 1821+** de 100TB. Única coisa extra que vou precisar é configurar mounts de NFS, como já detalhei [neste outro post](https://akitaonrails.com/2025/04/17/configurando-meu-nas-synology-com-nfs-no-linux/).

Um detalhe é que eu tenho **4 NVMEs** neste PC. 2TB pro meu Linux antigo. 2 TB pro dual boot/VM de Windows. 2 TB só como drive de Steam e 1 TB pra coisas aleatórias. Como vou limar a VM de Steam, também não preciso mais dedicar um NVME inteiro só pra isso. Em vez disso vou fazer o diretório "/home" do novo Linux ser esses 2 TB inteiro.

Isso vai me permitir não me preocupar mais com Docker enchendo meu drive e travando meu sistema inteiro com falta de espaço. Da última vez eu tinha "resolvido" isso fazendo um [drive remoto com iSCSI](https://akitaonrails.com/2025/04/17/configurando-meu-nas-synology-com-nfs-no-linux/) no meu NAS (que tem espaço infinito). Faz tirando minha VM de Steam vou ganhar 2TB então resolvo o problema localmente e com menos configurações.

RAM eu tenho de sobra, **96GB de DDR5**. Com isso também não preciso me preocupar com partição de swap. Swap só é importante caso você tenha menos de 32GB de RAM, se estiver rodando muito Docker e ficar batendo no máximo de consumo de RAM muito rápido. Ou, se estiver usando notebook e quer ter a opção de hibernação (poder gravar a RAM em disco, dar power off completo na máquina e conseguir voltar depois exatamente de onde parou - que é diferente de suspender, que ainda usa energia).

Se quiser hibernar precisa ter um pouco mais do que o tamanho da sua RAM. Então se tem 32GB é bom deixar uma margem, uns 34GB ou mais de Swap. Como meu PC é desktop em casa, não preciso de hibernação, só ativar **ZRAM** pros raros casos onde tiver um pico acima de 96GB (que é ultra raro). Fora que é mais fácil eu simplesmente subir pra 128GB de RAM se precisar muito. Swap pra compensar RAM só vale a pena em notebooks que já não tem espaço pra mais RAM de verdade.

## 2 - Por que Omarchy?

Como falei, já sou usuário de Arch faz uma década e não vejo nenhum repositório de pacotes maior e mais completo do que o **AUR**. O único outro repositório que compete, de fato, é do NixOS. Mas como Nix está descartado pro meu caso de uso, o AUR continua imbatível.

Arch tem Pacman como gerenciador de pacotes. Pra acessar o AUR precisa de um segundo gerenciador. Existem vários como os antigos Pacaur, Paru e vários outros. Mas o melhor, na minha opinião, é o Yay. Ele tem exatamente a mesma sintaxe que o Pacman e substitui o Pacman. Na prática só usamos Yay pra tudo.

Pra procurar pacotes por nome é só fazer `yay -Ss spotify`.

Pra remover pacotes é só fazer `yay -Rns spotify`.

Pra atualizar todos os pacotes do sistema é só fazer `yay -Syu`

Pra remover pacotes órfãos que sobram ao longo do tempo é só fazer `sudo pacman -Rns $(pacman -Qdtq)`

E esses são os comandos que eu mais uso 99% do tempo.

Eu já usei tudo que é tipo de desktop manager, seja GNOME (que tem mais comportamento de Mac), KDE (que tem mais comportamento de Windows pra power users), XFCE (que baseado em GTK e é mais leve), Cinnamon (também baseado em GTK), i3 (que é sistema de tiling windows), Sway (como i3, também tiling mas se não me engano já foi feito pensado em Wayland).

Na prática, todo mundo usa aplicativos de dois jeitos: janela em tela cheia ou 2 janelas verticais dividindo o monitor no meio (editor de um lado, navegador do outro), ou 3 janelas (um editor vertical ocupando metade do monitor, um navegador ocupando 1/4 e um terminal ocupando outro 1/4). Daí organizamos mais apps abertos em desktops virtuais/workspaces. Esse é o jeito mais fácil de trabalhar.

![layout ideal](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-08-29_12-12-58.png)

Significa que poder arrastar janelas flutuantes é perda de tempo. Eu prefiro que as janelas já abram dimensionadas num desses layouts que falei acima. Dá pra configurar GNOME ou KDE pra fazer isso. Mas tem cheiro de gambiarra. Em vez disso realmente é melhor usar i3 ou Sway.

Deixando as [controvérsias](https://x.com/LundukeJournal/status/1942389827518808384) de lado (sim, tenho um pouco de pé atrás com Wayland e gosto da existência de XLibre). Mas é um fato que **X11** ficou pra trás e é uma arquitetura muito velha e complicada. Wayland de fato tem um "appeal" melhor, apesar de ter demorado bastante pra arredondar coisas básicas como compartilhamento de tela (OBS, Zoom). Mas já faz alguns anos que uso Wayland sem ter dores de cabeça. Hoje em dia eu diria que está bem estável. Eu já usava GNOME sobre Wayland faz muito tempo. Eu não deixo de usar coisas por ter pé atrás: com tecnologia vou ser sempre absolutamente promíscuo e usar tudo.

Sabendo que vou usar **Wayland** e sabendo que quero layouts automáticos de janelas, e não preciso de janelas flutuantes, o melhor é um desktop manager com sistema de **tiling windows** (tiles são "azulejos" e estamos falando de azulejos ficarem lado a lado e nunca um em cima do outro), que organize as janelas lado a lado de forma inteligente e automática.

![janelas lado a lado](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-08-29_12-19-25.png)

Nesse caso só temos 2 opções: **Sway** ou **Hyprland** (qualquer uma das duas é boa). O Hyprland, instalado do zero, é totalmente pelado, não tem absolutamente nada. Precisamos configurar tudo através de arquivos em `.config/hypr`. É até simples, mas dá trabalho.

A única opção boa que se tinha pra ter um Hyprland pré-configurado e bem feito era o **ML4W**, que eu já usava. Mas agora temos o Omarchy que justamente instala e pré-configura tudo pra funcionar redondo no Hyprland. Essa é a melhor opção que temos hoje em dia.

Além de já configurar Hyprland pra funcionar com **Waybar**, Rofi e outros componentes, ele tem um sistema próprio pra trocar temas e estilos e deixar o sistema com o _"look and feel"_ que quiser (e todos que já vem nele são super bonitos), mas também já instala coisas que eu uso faz tempo como Neovim com o pacote **LazyVim** (na minha opinião, o jeito mais fácil de fazer o Neovim não deixar nada a desejar comparado a um VS Code), **Mise** (a melhor forma de organizar ambientes de desenvolvimento pra conseguir ter múltiplas versões da sua linguagem de programação favorita).

Se estiver instalando uma distro do zero, as únicas duas coisas que precisa ter são Mise e LazyVim. Além de Docker e LazyDocker. É o suficiente pra começar um ambiente de desenvolvimento produtivo. E o Omarchy já trás tudo isso pré-configurado. Ninguém "precisa" do Omarchy, mas ele já trás tudo integrado e bonito. Então, pra que me dar ao trabalho de fazer tudo do zero pra ficar quase igual?

Além disso, isso é Linux. Não gostou de 1 dos componentes? Só trocar.

## 3 - Faça Backup

A grande maioria de tudo que tenho já fica no servidor remoto, meu NAS Synology de 100TB. Isso já facilita muito. Mesmo assim ainda tem bastante coisa localmente no meu PC, então a primeira coisa a fazer é copiar tudo pro NAS. Se não tiver um NAS, então um HD externo. Qualquer coisa server, o importante é garantir que não vai perder nada antes de instalar um novo OS do zero.

Não esquecer diretórios como `.config` ou `.local`. Melhor fazer um `rsync -avz --progress .config /mnt/nas/backup/`, por exemplo, e copiar tudo. Mesmo o que achar que não vai precisar. Melhor copiar a mais do que faltar coisa. Via de regra, o ideal é copiar tudo que estiver na sua `$HOME` pra um drive externo ou NAS.

Só pra garantir que não vou esquecer nada importante, também vou gravar uma lista de todos os pacotes que tenho instalado no meu sistema antigo:

```
yay -Q > pacotes.txt
flatpak list > flatpak.txt
```

Também garantir que não vou perder configs velhas de serviços que eu fiz no systemd então também copiar tudo de `/etc/systemd/system`. Vale também gravar coisas como `/etc/fstab`. Também não esquecer de fazer backup de suas chaves de SSH com `tar cvfz ssh.tgz ~/.ssh`!!

Se como eu, usava QEMU/Libvirt pra VMs, é bom salvar as configs das máquinas virtuais que usava. Normalmente a ferramenta pra gerenciar VMs é o virsh então eu só fiz:

```
sudo virsh list --all
sudo virsh dumpxml <vmname> > <vmname>.xml
```

Se eu quiser recriar as máquinas no futuro, já vai estar tudo no backup. No meu caso mantenho todos os drives virtuais no meu NAS, mas caso os seus estejam locais, também precisa salvar esses arquivos que ficam em `/var/lib/libvirt/images/`

```
rsync -avh --progress /var/lib/libvirt/images/ /backup/libvirt-images/
```

## 4 - É difícil instalar Arch?

Arch, menos que um Gentoo, sempre teve reputação de ser a distro Linux mais brutal pra um iniciante instalar. Isso não é mentira, mas a verdade é que Arch é simultaneamente a distro mais difícil e também a mais fácil.

Baixe [a ISO oficial](https://archlinux.org/download/) e grave num pen drive (em Windows, usando **Rufus** ou Balena Etcher). Agora aperte F12 (depende da sua BIOS) ou configure na BIOS direto pra bootar do pen drive. Fazendo isso ele carrega o live environment do Arch que é literalmente cair numa linha de comando. Sem mais nenhuma ajuda.

A partir deste ponto tem que seguir o [Wiki de Instalação](https://wiki.archlinux.org/title/Installation_guide) do excelente ArchWiki e aprender a instalar um Linux do absoluto zero usando somente linha de comando, passo a passo, na tentativa e erro (mais errando do que acertando) e, ao final, você vai ter um "feeling" muito melhor de como uma distro Linux funciona de verdade.

Eu não fiz video de Arch mas fiz videos de [Slackware](https://www.youtube.com/watch?v=iQkBbRPkASo) pra explicar como um gerenciador de pacotes funciona. Também fiz um video de [Gentoo](https://www.youtube.com/watch?v=cSyTjCUFx2A) pra mostrar como uma distro que compila tudo do zero funciona. E fiz um video de como o [Boot do Linux Funciona](https://www.youtube.com/watch?v=5F6BbhgvFOE) pra entender onde fica a kernel e como ela é estruturada. Mas não fiz video de Arch porque sempre deixei como exercício pra iniciantes.

O jeito manual é viável, mas se está acostumado a um instalador gráfico, como o **Calamaris**, que tem na maioria das distros mais populares como Ubuntu ou Fedora, você vai ficar totalmente perdido. Mas aqui vem o bônus: não precisa passar por tudo isso pra ter um Arch Linux na sua máquina.

Pra isso existe o [**archinstall**](https://wiki.archlinux.org/title/Archinstall).

Quando bootar o pen drive do Arch e cair na linha de comando, basta digitar archinstall e pronto, só seguir o passo a passo que ele dá - que eu considero ainda mais simples do que Calamaris - e ele vai instalar e configurar tudo de forma automática pra você, do mesmo jeito que é instalar Fedora ou qualquer outra distro. Sério, não é pra demorar mais que 15 minutos.

O archinstall tem esta cara:

![archinstall](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250828_045255.jpg)

Basta entrar em cada um dos ítens da esquerda e preencher suas escolhas. Configure coisas como layout de teclado (normalmente eu escolho 'us-acentos'). Edite o hostname da sua máquina. Escolha "NetworkManager" em configuração de rede (ele vai configurar tanto ethernet quanto wifi pra você), adicionar suporte a Bluetooth e Audio (escolha "Pipewire"). Escolha o tipo "desktop" em vez de "minimal" pra já ter os principais pacotes necessários pra um desktop. Escolha a timezone ("America/Sao_Paulo" no meu caso).

Recomendo também escolher a opção de Hyprland acho que em Applications ou Adicional Packages. Ele já vai instalar o SDDM pra ter um login gráfico.

Só tem duas opções que precisa de mais atenção: pra bootloader, muitos vão ficar tentados a usar um **Limine**, que é mais moderno e leve. Mas eu recomendo ainda usar **GRUB**, já explico porque.

A segunda opção importante é "Disk Configuration". Não se preocupe, diferente de fdisk, ele é super intuitivo. Basta escolher o drive correto onde quer instalar (se tiver dual boot, cuidado pra não apagar seu Windows). Daí deixe ele fazer o layout automático das partições (só edite manualmente se tiver alguma necessidade muito especial). O mais importante, escolha [**BTRFS**](https://wiki.archlinux.org/title/Btrfs) em vez do tradicional ext4.

![btrfs](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250828_045312.jpg)

Todo Linux sempre formata suas partições Linux com ext4, que é o mais antigo, mais estável e mais bem documentado file system. Hoje em dia eu recomendo BTRFS, é muito mais moderno, mais seguro (tem sistemas de proteção contra corrupção melhores), usa menos espaço (aprenda sobre CoW - **Copy on Write**), e o principal: tem suporte a snapshots baratos (pense o Apple Time Machine, só que melhor). Tem a maioria das funcionalidades de um sistema de arquivos dedicado pra servidor de arquivos mas muito mais simples e intuitivo de usar do que o monstro que é o ZFS (não recomendo pra usuários normais).

Ele tem algumas necessidades de manutenção que é bom ler no Wiki pra aprender. Mas no geral é plug and play, instala e esquece. Nas próximas seções vou mostrar algumas coisas que precisa saber, mas vai por mim: escolha BTRFS.

Eu sei que o Omarchy 2.0 tem opção de uma [ISO pré-configurada](https://iso.omarchy.org/omarchy-online.iso) que imagino que seja o Arch normal com archinstall e já o Omarchy por cima tudo de uma só vez. Mas eu não sei se eles permitem essa escolha por isso preferi ir direto no Arch puro antes. No final o efeito é o mesmo. Depois comentem abaixo se a ISO do Omarchy também tem as mesmas opções. Só garanta que no final tenha BTRFS. O futuro você vai te agradecer.

## 5 - HOME separada

Como expliquei antes, eu usava um dos meus 4 NVMEs pra ser o drive de Linux. Mas agora liberei outro NVME e quero mover minha $HOME pra lá e ter 2 TB dedicado só pra user space.

Não vou explicar como particionar e formatar esse outro drive. É simples: basta usar [fdisk](https://wiki.archlinux.org/title/Fdisk) ou depois instalar **Gparted** que é a versão gráfica da ferramenta [parted](https://wiki.archlinux.org/title/Parted) que dá pra usar pela linha de comando. São várias opções. O importante é só zerar minha partição antiga Windows e formatar também com BTRFS.

Cada um vai ter nomes de dispositivos e partições diferentes do meu. Pra saber quais são os seus use o comando `lsblk`. Veja o meu exemplo:

![lsblk](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-08-29_12-54-42.png)

No meu exemplo `nvme1n1` é o drive de 1TB pra coisas aleatórias. `nvme2n1` é meu novo Arch Linux. `nvme0n1` é o drive de dual boot de Windows antigo. `nvme3n1` é o drive de Steam que formatei com BTRFS pra virar meu novo drive de HOME.

Se não entendeu, HOME é o diretório `/home/akitaonrails`. Ele vai ficar num drive separado. Depois que o archinstall terminar e eu bootar no novo Linux, é só fazer o seguinte:

```
sudo mount -t btrfs /dev/nvme3n1p1 /mnt
sudo btrfs subvolume create /mnt/@home
rsync -aAXHv /home/ /mnt/@home/
sudo umount /mnt
```

Isso vai montar a nova partição, daí usamos o comando "btrfs" pra criar um novo sub-volume chamado "@home" (de novo, leia o Wiki de BTRFS pra entender conceitos como sub-volumes).

Os comandos acima criam o sub-volume e copiam tudo que estava na HOME antiga pra nova. Agora precisamos que, no boot, o `/home` seja montado nessa nova partição. Pra isso precisamos saber o UUID dessa partição:

```
~ ❯ sudo blkid /dev/nvme3n1p1
/dev/nvme3n1p1: LABEL="HOME" UUID="84e9a1b7-a30e-...
```

O comando `blkid` devolve o UUID único de cada partição e, com isso, podemos editar o arquivo `/etc/fstab` usando `sudo nvim` ou `sudo nano` ou o editor que preferir:

```
# /etc/fstab
...
# /dev/nvme2n1p2
# UUID=da3aea43-...-aeaf8c7224d7 /home      btrfs      rw,relatime,ssd,discard=async,space_cache=v2,subvol=/@home 0 0

# /dev/nvme3n1p1
UUID=84e9a1b7-...-7a6a17fd0395 /home      btrfs      rw,relatime,ssd,discard=async,space_cache=v2,subvol=/@home 0 0
...
```

Veja como comentei a linha antiga que montava o `/home` e adicionei a nova linha com o novo UUID. O resto é tudo igual. E é só isso, basta bootar e a partir de agora meu `/home` vai montar no novo drive. Agora eu tenho 2 TB dedicados só pros meus downloads lixo kkkkkk 🤣

Mas não só isso, também tenho espaço pra coisas grandes como imagens de Docker ou modelos de LLM, sem correr o risco de encher o drive do sistema operacional e correr o risco dele não bootar mais por falta de espaço - como já me aconteceu várias vezes no passado. Sempre lembre de dar manutenção em Docker e LLMs e apagar coisas velhas.

Falando nisso, BTRFS tem suporte a snapshots. E um dos erros básicos é esquecer que diretórios de Docker ou LLM podem acabar nos snapshots e ficar ocupando espaço sem você saber. Pra evitar isso é melhor marcar esses diretórios pra não entrarem nos snapshots. Pra isso temos que dizer ao BTRFS pra ignorar esses diretórios.

A forma correta é criando subvolumes separados pra eles. Pra isso vou montar aquela minha mesma partição no drive separado onde montei minha $HOME:

```
~ ❯ sudo mkdir /mnt/temp
~ ❯ sudo mount -o subvolid=5 -t btrfs /dev/nvme3n1p1 /mnt/temp

~ ❯ ls /mnt/temp
 @home   timeshift-btrfs

~ ❯ sudo btrfs subvolume create /mnt/temp/@docker
Create subvolume '/mnt/temp/@docker'

~ ❯ sudo btrfs subvolume create /mnt/temp/@ollama
Create subvolume '/mnt/temp/@ollama'

~ ❯ sudo umount /mnt/temp
```

Agora é só editar o `/etc/fstab` pra montar corretamente igual fizemos com a HOME:

```
# /etc/fstab
...
# /dev/nvme3n1p1
UUID=84e9a1b7-...-7a6a17fd0395 /home      btrfs      rw,relatime,ssd,discard=async,space_cache=v2,subvol=/@home 0 0
UUID=84e9a1b7-...-7a6a17fd0395 /var/lib/docker      btrfs      rw,relatime,ssd,discard=async,space_cache=v2,subvol=/@docker 0 0
UUID=84e9a1b7-...-7a6a17fd0395 /var/lib/ollama      btrfs      rw,relatime,ssd,discard=async,space_cache=v2,subvol=/@ollama 0 0
...
```

Pronto, subvolumes limpos. Mais importante no meu caso: movi diretórios que tem tendência a crescer sem controle pra fora da partição do sistema operacional, tornando mais difícil acabar com um sistema inacessível por causa de falta de espaço. Faça a mesma coisa com outros diretórios parecidos com coisas como Kubernetes por exemplo. Qualquer coisa que fique baixando arquivos grandes, como imagens de sistemas.

Agora é só montar e trazer as coisas de volta:

```
# toda vez que edita o fstab, rode isso:
sudo systemctl daemon-reload

# crie os mount points
sudo mkdir /var/lib/docker
sudo mkdir /var/lib/ollama

# monte
sudo mount /var/lib/docker
sudo mount /var/lib/ollama

# copiar o conteúdo do diretório antigo de volta
sudo rsync -aHAX --inplace /var/lib/docker.old/ /var/lib/docker/
sudo systemctl start docker
```

Além de gerenciamento de espaço, qual a outra vantagem de fazer subvolumes separados? Porque a próxima seção vai ser pra tornar o sistema ainda mais robusto adicionando capacidade de snapshots e rollback pra snapshots do passado. E o ideal é tirar arquivos gigantes de snapshots que vão ficar no passado. Imagens de Docker são fáceis de recuperar: só dar `docker pull` de novo, não precisa fazer backup.

## 6 - Instalar Omarchy

Essa é a parte mais fácil. Quando terminar de instalar com archinstall, se escolheu a opção de Hyprland, vai aparecer o SDDM pra fazer login. E quando entrar você vai ficar chocado com quão **cru** é o Hyprland. Não dá pra fazer basicamente nada.

Pra isso não virar um dia inteiro de configuração na mão, usaremos o Omarchy. Clique "Super Enter" pra abrir o terminal e não ligue pra quão feio as coisas estão agora. Vai melhorar.

No terminal só faça isso:

```
curl -fsSL https://omarchy.org/install | bash
```

Só seguir as instruções na tela e deixar ele fazer o resto. E pronto, acabou, não tem próximo passo.

Recomendo MUITO que leia o [MANUAL ONLINE DO OMARCHY](https://learn.omacom.io/2/the-omarchy-manual) que o DHH fez. É muito limpo, simples e direto. Todas as combinações de tecla, por exemplo, estão na [seção HOTKEYS](https://learn.omacom.io/2/the-omarchy-manual/53/hotkeys). Gaste uma hora lendo o básico pra conseguir operar. Mas a essa altura você já tem praticamente tudo que precisa: Alacritty como terminal, Chromium como navegador (pode instalar Brave se preferir, como é meu caso).

"Super Alt Space" abre o menu principal do Omarchy. "Super Space" abre o Rofi pra digitar o nome do app que quer abrir. "Super Enter" abre o terminal. "Super B" abre o navegador e assim por diante.

## 7 - Customizando Omarchy

O Omarchy é um Hyprland customizado. Podemos editar o que quisermos diretamente em `~/.config/hypr`. E como eu estava acostumado com ML4W, resolvi mexer um pouco pra ficar bom pro meu setup. Seu setup vai variar dependendo das suas necessidades.

Logo que terminei de instalar Omarchy e tentei usar Gparted pra particionar aquele meu segundo NVME pra HOME, ele deu problema de autenticação. Não lembro se esta foi a solução mas é bom garantir que tenha Polkit instalado:

```
# make sure polkit + agent exist
sudo pacman -S --needed polkit polkit-gnome xorg-xhost

# Hyprland: export full env to systemd user bus once
dbus-update-activation-environment --systemd --all
```

Voltando, a primeira coisa que eu preciso resolver é que eu tenho 2 monitores. Um Asus 32" 1440p 144fps como principal e outro Samsung 24" 4K 60fps na vertical do lado esquerdo. A forma de configurar isso no Hyprland é editando um arquivo como `~/.config/hypr/monitors.conf` que normalmente é carregado pelo `~/.config/hypr/hyprland.conf`.

Em vez de fazer isso manualmente, prefiro instalar:

```
yay -S nwg-displays
```

![nwg-displays](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-08-29_13-46-04.png)

Aqui eu configuro coisas como transform 90 graus pra girar o monitor vertical, scaling de resolução, suporte a 10-bits de cor, etc.

Ele vai salvar dois arquivos: `~/.config/monitors.conf` e `~/.config/workspaces.conf`. O Omarchy não carrega esse segundo arquivo então temos que editar em `~/.config/hypr/hyprland.conf` pra ficar assim:

```
...
# Change your own setup in these files (and overwrite any settings from defaults!)
source = ~/.config/hypr/monitors.conf
source = ~/.config/hypr/workspaces.conf`
...
```

Já aproveitei pra adicionar algumas configurações extras nesse arquivo:

```
...
# animation
animations {
  enabled = yes
  bezier = easeOutQuint, 0.23, 1, 0.32, 1
  animation = workspaces, 1, 4, easeOutQuint, slide
  # optional extras:
  animation = specialWorkspace, 1, 4, easeOutQuint, slide
  animation = windows, 1, 4, easeOutQuint, popin 80%
  animation = fade, 1, 4, easeOutQuint
}

xwayland {
    force_zero_scaling = false # careful with mixing scaling wayland and x11
}

input {
  numlock_by_default = true
}

# dialogs/splash/utility ONLY
windowrulev2 = float,  xwayland:1, windowtype:^(dialog|splash|utility)$
windowrulev2 = center, xwayland:1, windowtype:^(dialog|splash|utility)$

# never center menus/tooltips
windowrulev2 = tile,   xwayland:1, windowtype:^(popup_menu|dropdown_menu|tooltip)$
```

Tem gente que não gosta mas eu gosto de ter uma animação rápida quando mudo de um workspace pra outro, por isso adicionei o bloco `animations`.

Quando se usa aplicativos feitos pra X11, eles vão rodar em cima do XWayland. Uma coisa chata é que alguns deles abrem "dialog boxes", que são janelas flutuantes. E eles podem acabar em lugares difíceis de clicar, especialmente num setup com múltiplos monitores. Por isso adicionei blocos como `xwayland` e regras `windowrulev2` pra forçar esses dialog boxes a sempre aparecerem centralizados na tela.

FInalmente, eu tenho um teclado numpad da 8bitdo conectado via Bluetooth, mas ele não liga com numlock carregado. Pra corrigir isso tem esse bloco `input`.

Voltando ao layout de monitor. Depois que o nwg-displays gerou os arquivos, ainda precisei modificar um pouco por meu caso, assim:

```
# ~/.config/monitors.conf
# Generated by nwg-displays on 2025-08-28 at 14:30:17. Do not edit manually.

#monitor=HDMI-A-3,2560x1440@143.97,1080x407,1.25,bitdepth,10
#monitor=DP-5,3840x2160@60.0,0x0,1.875,bitdepth,10
#monitor=DP-5,transform,1
#monitor=DP-1,0x0@60.0,-1x-1,1.0
#monitor=DP-1,disable

monitor=HDMI-A-3,2560x1440@143.97,2813x948,1.0,bitdepth,10
monitor=DP-5,3840x2160@60.0,1373x350,1.5,bitdepth,10
monitor=DP-5,transform,1
monitor = DP-1,disable
```

O arquivo de monitor não precisei mexer nada, na real, só lembrar de desabilitar esse DP-1 que aparece no meu monitor principal (acho que é a DisplayPort dele, mas eu uso HDMI, então tem que desabilitar a DP-1).

```
# ~/.config/workspaces.conf
# Generated by nwg-displays on 2025-08-28 at 13:07:02. Do not edit manually.

workspace=5,monitor:DP-5,persistent:true
workspace=1,monitor:HDMI-A-3,persistent:true
workspace=2,monitor:HDMI-A-3,persistent:true
workspace=3,monitor:HDMI-A-3,persistent:true
workspace=4,monitor:HDMI-A-3,persistent:true
```

Esta também não precisei mudar muito, no próprio nwg-displays eu disse quais workspaces eu quero em cada monitor. Na minha preferência pessoal prefiro deixar o monitor vertical somente com a workspace 5 e os outros no monitor principal. A diferença aqui foi que adicionei essas opções `persistent:true` em todas, pra garantir que vai tudo funcionar direito com as workspaces "pinadas" nos lugares corretos. Workspaces em Hyprland são bem dinâmicos, vale ler a documentação depois, caso queira casos mais complicados.

Isso resolve meu setup de dois monitors do jeito que eu prefiro. Experimente mexer em coisas como scaling até ficar tudo ok pro seu setup.

Na sequência eu precisava resolver as hotkeys (key bindings). Eu estou acostumado com algumas combinações que vinha no ML4W então resolvi copiar de lá direto em `~/.config/hypr/bindings.conf`. Primeiro, trocar o chromium pelo Brave:

```
# Application bindings
$terminal = uwsm app -- alacritty
$browser = brave # omarchy-launch-browser
...
```

Daí adicionei um tanto de binds no final do mesmo arquivo:

```
unbind = SUPER, V
bind = SUPER, V, swapsplit
bind = SUPER, M, fullscreen, 1                                                           # Maximize Window
bind = SUPER, T, togglefloating                                                          # Toggle active windows into floating mode
bind = SUPER SHIFT, right, resizeactive, 100 0                                           # Increase window width with keyboard
bind = SUPER SHIFT, left, resizeactive, -100 0                                           # Reduce window width with keyboard
bind = SUPER SHIFT, down, resizeactive, 0 100                                            # Increase window height with keyboard
bind = SUPER SHIFT, up, resizeactive, 0 -100                                             # Reduce window height with keyboard

# Display
bind = SUPER SHIFT, mouse_down, exec, hyprctl keyword cursor:zoom_factor $(awk "BEGIN {print $(hyprctl getoption cursor:zoom_factor | grep 'float:' | awk '{print $2}') + 0.5}") # Increase display zoom
bind = SUPER SHIFT, mouse_up, exec, hyprctl keyword cursor:zoom_factor $(awk "BEGIN {print $(hyprctl getoption cursor:zoom_factor | grep 'float:' | awk '{print $2}') - 0.5}") # Decrease display zoom
bind = SUPER SHIFT, Z, exec, hyprctl keyword cursor:zoom_factor 1 # Reset display zoom

# Workspaces
bind = SUPER, 1, workspace, 1 on HDMI-A-3 # Open workspace 1
bind = SUPER, 2, workspace, 2 on HDMI-A-3  # Open workspace 2
bind = SUPER, 3, workspace, 3 on HDMI-A-3 # Open workspace 3
bind = SUPER, 4, workspace, 4 on HDMI-A-3 # Open workspace 4
bind = SUPER, 5, workspace, 5 on DP-5 # Open workspace 5

bind = SUPER SHIFT, 1, movetoworkspace, 1  # Move active window to workspace 1
bind = SUPER SHIFT, 2, movetoworkspace, 2  # Move active window to workspace 2
bind = SUPER SHIFT, 3, movetoworkspace, 3  # Move active window to workspace 3
bind = SUPER SHIFT, 4, movetoworkspace, 4  # Move active window to workspace 4
bind = SUPER SHIFT, 5, movetoworkspace, 5  # Move active window to workspace 5

bind = SUPER, Tab, workspace, m+1       # Open next workspace
bind = SUPER SHIFT, Tab, workspace, m-1 # Open previous workspace

bind = SUPER CTRL, 1, exec, $HOME/.config/hypr/moveTo.sh 1  # Move all windows to workspace 1
bind = SUPER CTRL, 2, exec, $HOME/.config/hypr/moveTo.sh 2  # Move all windows to workspace 2
bind = SUPER CTRL, 3, exec, $HOME/.config/hypr/moveTo.sh 3  # Move all windows to workspace 3
bind = SUPER CTRL, 4, exec, $HOME/.config/hypr/moveTo.sh 4  # Move all windows to workspace 4
bind = SUPER CTRL, 5, exec, $HOME/.config/hypr/moveTo.sh 5  # Move all windows to workspace 5
```

Note que o último bloco de scripts precisa de um script pra mover todas as janelas de uma só vez pra outro workspace. Eu copiei este [moveTo.sh](https://github.com/mylinuxforwork/dotfiles/blob/main/dotfiles/.config/hypr/scripts/moveTo.sh) do GitHub do ML4W e coloquei em `~/.config/hypr` direto. Não esquecer de dar permissão de execução com `chmod +x moveTo.sh` depois.
Os vários de workspace abaixo é como eu prefiro mover workspaces e mover apps pra diferentes workspaces.

Omarchy já vem com "SUPER J" pra mudar a orientação das janelas, por exemplo, se está duas janelas na horizontal um em cima do outro, com SUPER J eles ficam verticais, mas faltava o "SUPER V" que adicionei pra "swapsplit" que é trocar as janelas de lugar.

Eu também gosto de "SUPER M" pra temporariamente fazer uma das janelas ficar em tela cheia, e "SUPER T" pra temporariamente fazer uma janela ficar flutuante (como uma calculadora, por exemplo). Tive que dar unbind no SUPER M anterior que abria o Spotify, mas eu quase não uso Spotify no desktop então não preciso dela. Quando quero abrir esse app, vou no SUPER SPACE pra abrir o Rofi e escrevo lá.

Se tiver dúvidas sobre as combinações padrão, o Omarchy tem "SUPER K" pra abrir uma janela com uma ajuda pra todas.

Ainda não modifiquei combinações pra aplicativos específicos. Os que vem no Omarchy já são muito úteis como SUPER A pra abrir o ChatGPT como se fosse um app separado ou SUPER CTRL A pra abrir o Grok numa janela separada. SUPER O pra abrir o Obsidian também é muito útil pra mim. Recomendo brincar com esses binds pra fazer bindings específicos e, de novo, ler o manual pra aprender tudo mais que já vem nele. Mas até aqui é o suficiente pra deixar o Hyprland do jeito que eu gosto de usar.

## 8 - Timeshift, Snapshots e GRUB

Lembram que eu falei pra escolher GRUB no archinstall? É pra agora. O objetivo: deixar o sistema fazer snapshots periódicos do sistema e, caso instale algum pacote corrompido ou faça coisas no seu sistema que impeçam ele de bootar, em vez de ter que recorrer a um pendrive pra tentar bootar e diagnosticar o erro, é mais fácil só bootar, escolher um snapshot logo antes da operação destrutiva e voltar intacto.

Antes de prosseguir, um ajuste que acho importante: meu monitor 4K faz o GRUB ficar com letras pequenas demais pra eu conseguir ler. Prefiro letras maiores. Felizmente o GRUB usa fontes bitmap então posso usar qualquer uma. Eu fiz o seguinte:

```
sudo grub-mkfont -s 48 -o /boot/grub/fonts/caskaydia48.pf2 /usr/share/fonts/TTF/CaskaydiaMonoNerdFont-Regular.ttf
```

Isso vai gerar uma fonte no formato que o GRUB consegue carregar. Escolha qualquer uma que gostar, o Omarchy já pré-instala várias muito boas como as da JetBrains. Se tamanho 48 for muito grande, diminua pra 32, experimente até ficar do jeito que gosta.

Daí é só editar `/etc/default/grub` pra, no final ter esta linha:

```
GRUB_FONT=/boot/grub/fonts/caskaydia48.pf2
```

E agora é só regerar o bootloader:

```
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

Toda vez que o `yay -Syu` trouxer atualização de kernel ou drivers, o GRUB vai ser regerado com a mesma fonte. Olha como ficou pra mim, acho que está bem melhor (isso é um monitor 4K):

![Grub Font](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250828_124009.jpg)

Agora a razão toda pra ter escolhido GRUB: permitir escolher snapshots de BTRFS pra poder bootar no passado, antes de alguma operação destrutiva, como mostra na foto acima. Pra isso precisamos do seguinte:

```
pacman -S timeshift grub-btrfs
yay -S timeshift-autosnap
systemctl enable --now grub-btrfs.service
```

Pronto. A partir de agora, toda vez que o GRUB for reconstruído, vai ter uma nova opção pra escolher snapshots. Só precisamos criar esses snapshots automaticamente e, pra isso, temos o app Timeshift. Abra e siga o passo a passo dele. O importante é escolher a opção de BTRFS (sim, dá pra usar RSYNC se estiver em ext4, mas isso ocupa muito espaço, porque ele vai literalmente ficar fazendo cópias dos arquivos do seu sistema inteiro. A beleza de BTRFS é que snapshots dele não duplicam arquivos).

![Timeshift Schedule](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-08-29_15-37-52.png)

Eu deixo ele fazendo snapshots e acumulando versões das últimas horas, últimos dias, últimas semanas e meses. Se lá na frente eu lembrar _"puuuuts, tinha aquele arquivo que eu apaguei mês passado mas agora eu preciso"_ Basta abrir o Timeshift e explorar um snapshot do mês passado. Igual povo de Mac faz com Time Machine, mas ocupando quase nada de espaço extra.

Além disso, todo upgrade de pacotes vai gerar um snapshot antes. Assim, se por acaso vier um pacote corrompido ou que quebre alguma configuração sua importante, dá pra voltar exatamente como era antes da atualização. E se quebrar de forma catastrófica, onde seu Linux não boota mais, basta ir no menu extra do GRUB e bootar do snapshot anterior, que funcionava. E tudo volta igualzinho como estava antes.

![Timeshift Snapshots](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-08-29_15-38-24.png)

Não existe nada mais importante pro seu sistema do ter snapshots automáticos e que não ocupam quase nada de espaço extra. Só isso já torna o BTRFS superior a qualquer outra alternativa.

**Isso não substitui Backup externo!!**

Esse rollback e capacidade de recuperar coisas de forma fácil é bom pra acidentes do dia a dia. Mas digamos que seu NVME quebre de alguma forma, ou seu PC quebre de alguma forma. Pra isso servem backups externos (seja HD externo, seja NAS, seja Cloud). Você quer ter certeza que, numa situação catastrófica, ainda seja possível recuperar seus arquivos.

Eu tenho todas as camadas de proteção: snapshots locais via BTRFS e Timeshift, backups feitos remotamente pro meu NAS, e backup de partes mais importantes do meu NAS na [Amazon Glacier](https://aws.amazon.com/pt/s3/storage-classes/glacier/) que, diferente de Amazon S3 é pra guardar backup, onde o custo de armazenamento é ultra baixo mas o custo de transferência é mais alto (S3 o armazenamento é mais caro mas a transferência é barata, por isso serve pra servir assets de websites).

Eu gosto de estar preparado pra, caso minha casa pegue fogo, eu não perca nada importante.

## 9 - NFS no NAS

Falando em NAS, uma coisa que configurei diferente - já que uso primariamente Linux em vez de Windows - foi habilitar servidor de NFS.

Mas cuidado que alguns NAS tem uma característica que pode incomodar: o seu usuário no NAS vai ter UID e GID diferente de 1000!

Quando se cria um usuário em qualquer Linux, o padrão é atribuir o UID 1000 pro primeiro usuário, 1001 pro segundo e assim por diante. Mas como no NAS Synology o primeiro usuário recebe UID 1026, se eu montar com NFS (que transparece as permissões de UNIX), vou ter problemas de autorização.

Existem duas soluções: tentar mudar o UID no NAS de 1026 pra ser 1000. [Eu tentei isso](https://akitaonrails.com/2025/04/17/configurando-meu-nas-synology-com-nfs-no-linux/) e já adianto que é perda de tempo, você pode acabar quebrando as configurações do NAS de forma catastrófica.

É muito mais fácil mudar o usuário do seu novo Linux local pra ser 1026 e pronto. É bem fácil.

Primeiro, precisamos deslogar e sair do Hyprland e voltar pra tela de login do SDDM. Daí precisamos mudar pra outro TTY com **CTRL + ALT + F3** (pra ir pra tty3, por exemplo). De lá temos que fazer login como **root**.

Agora rodamos: `systemctl isolate multi-user.target` pra rodar em modo de recuperação isolado, onde nenhum outro usuário tem processos rodando. Já que vamos mexer no usuário, ele não pode estar ativo.

```
usermod -u 1026 akitaonrails
groupmod -g 1026 akitaonrails
chown -R 1026:1026 /home/akitaonrails
```

Com os comandos acima mudamos de 1000 pra 1026 e acertamos as permissões nos arquivos locais pra refletir essa mudança. Agora sim, podemos editar o `/etc/fstab` pra montar os diretórios compartilhados no NAS com NFS:

```
# NFS
192.168.0.x:/volume1/GIGACHAD /mnt/gigachad nfs4 _netdev,noauto,nofail,bg,x-systemd.automount,x-systemd.requires=network-online.target,x-systemd.after=network-online.target,x-systemd.idle-timeout=60s,noatime,nodiratime,async,rsize=65536,wsize=65536,actimeo=1  0 0
192.168.0.x:/volume1/TERACHAD /mnt/terachad nfs4 _netdev,noauto,nofail,bg,x-systemd.automount,x-systemd.requires=network-online.target,x-systemd.after=network-online.target,x-systemd.idle-timeout=60s,noatime,nodiratime,async,rsize=65536,wsize=65536,actimeo=1  0 0
```

Não esquecer de criar os mount points:

```
mkdir /mnt/gigachad
mkdir /mnt/terachad
```

Pronto, só rebootar e tudo vai funcionar corretamente. As permissões dos arquivos no NAS - que estão pro UID 1026 e GID 1026 - vão ser acessíveis pro usuário local sem problemas.

## 10 - Utilitários

Aqui são as últimas dicas pequenas pra ficar tudo num lugar só. A primeira é substituir o comando `ls` pelo `eza` que oferece uma cara mais bonita, com ícones e tudo mais, assim:

![eza](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-08-29_16-50-25.png)

Só fazer `yay -S eza` e adicionar isto no seu `.zshrc` ou `.bashrc`:

```
alias ls='eza --icons --color=auto --group-directories-first'
alias ll='eza -l --icons --color=auto --group-directories-first'
alias la='eza -la --icons --color=auto --group-directories-first'
```

Segunda dica é instalar [Atuin](https://atuin.sh/). Pra quem mexe com infra, isso é extremamente importante: backup de toda o histórico de comandos que você usou no seu terminal até hoje.

Instale com `yay -S atuin` e faça:

```
atuin login
atuin sync
```

Leia o site oficial, mas primeiro precisa criar uma conta e uma chave de encriptação secreta - sim, você pode rodar localmente num servidor na sua casa, mas a opção cloud deles é bem cômoda e segura porque fica toda encriptada, então não tem problema se subir senhas do seu histórico.

Só precisa colocar isso no seu `.zshrc`:

```
export ATUIN_NOBIND=true
eval "$(atuin init zsh)"
bindkey "^R" atuin-search

# incremental history search with arrow keys
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward]]
```

Se estiver usando ZSH, o auto-complete dele vai funcionar normalmente mas, se digitar CTRL+R, vai abrir o histórico do Atuin. Ele vai guardar todos os seus comandos num SQLite e sincronizar. Assim você pode sincronizar diversas máquinas e servidores que usa no dia-a-dia ou, como no meu caso, recuperar o histórico todo numa nova instalação.

E pra ficar melhor, podemos configurar ele pra auto-sincronizar:

```
mkdir -p ~/.config/atuin
sed -i 's/^#\?auto_sync.*/auto_sync = true/; s/^#\?sync_frequency.*/sync_frequency = "30m"/' ~/.config/atuin/config.toml 2>/dev/null || \
printf 'auto_sync = true\nsync_frequency = "30m"\n' >> ~/.config/atuin/config.toml
```

Terceira dica: como temos Docker já instalado e configurado, eu gosto de usar o [**SGPT**](https://github.com/tbckr/sgpt) na linha de comando pra quando quero lembrar a sintaxe de algum comando que uso pouco, em vez de abrir um app ou navegador. Basta adicionar isto no meu `.zshrc`:

```
export OPENROUTER_API_KEY="sk-or-v1-8b8...17"
export OPENAI_API_KEY="sk-or-v1-db...f3"
export OPENAI_API_BASE="https://openrouter.ai/api/v1"

alias sgpt='docker run --rm -e OPENAI_API_BASE=${OPENAI_API_BASE} -e OPENAI_API_KEY=${OPENROUTER_API_KEY} ghcr.io/tbckr/sgpt:latest txt '
```

Eu uso [OpenRouter](https://openrouter.ai/) pra ter acesso a diferentes LLMs comerciais numa única API, mas você pode só usar sua chave da OpenAI. Feito isso eu usaria no terminal parecido com isto:

```
~ ❯ sgpt "what is the pacman command in Arch to find out if a particular file came from an installed package?"
To find out if a particular file came from an installed package in Arch Linux, you can use the following pacman command:

``bash
pacman -Qo /path/to/file
``

Replace "/path/to/file" with the actual path to the file you want to check. This command will show the package which owns the file, or report that the file does not belong to any package if that is the case.
```

Se quiser, ele suporta sessões, então vai lembrar da conversa a cada nova chamada. Leia o Github do projeto.

Como fiz backup do meu `~/.config` antigo, coisas como abas abertas do meu navegador Brave abriram normalmente nessa nova instalação de Omarchy e posso continuar fazendo minhas coisas exatamente do ponto onde parei. Não perdi nada. Mesma coisa vale pra todos os outros apps como emails que faço backup local via Thunderbird. Não preciso mandar baixar tudo de novo.

![Audio Output](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-08-29_15-59-34.png)

Se como eu, você tem vários dispositivos de saída de áudio, é possível que logo que terminar de instalar note que parece que não tem som. Mas não é um problema porque pode ser só que a saída está apontando pro dispositivo errado ou no perfil errado. Use SUPER ALT SPACE pra abrir o menu do Omarchy, escolha SETUP e AUDIO pra abrir esse programa que é em modo texto (eu gosto de programas em modo texto).

No meu caso, uso um DAC Topping D70 pra processar meu áudio e o perfil "Default" não funciona mas mudando pra "Pro Audio" funcionou. Também cuidado que tem configuração de volume global e controle individual de volume por programa. No geral, graças ao Pipewire, tudo deve funcionar normalmente.

Eu testei apps como Discord, Blender, Bambu Studio, VLC e tudo funcionando perfeitamente bem. Só VLC que precisei instalar os codecs de um pacote separado:

```
yay -S extra/vlc-plugin-ffmpeg
```

Blender também, o melhor é instalar deste pacote:

```
yay -S blender-bin
```

Se usar o pacote "blender" normal, alguns add-ons dele não instalam direito. Eu tive esse problema com MACHIN3Tools e MESHMachine, por exemplo.

Falando em Blender, ele é um app X11. Wayland roda aplicativos X11 usando uma camada adaptadora chamada **XWayland**. Eu tive vários problemas com posicionamento de menus e dialog boxes, mesmo adicionando `windowrule`. Uma coisa que sei lá porque funcionou foi instalar Blender e Bambu Studio via Flatpak:

```
yay -S flatpak
flatpak install org.blender.Blender
flatpak install com.bambulab.BambuStudio
```

Finalmente, se você é novo em LazyVim, não esqueça de rodar o comando [`:LazyExtras`](https://www.lazyvim.org/extras) pra instalar os plugins extras pras suas linguagens favoritas, como LSP, Linter, syntax highlight, snippets e mais. O LazyVim puro já é completo mas sem suporte a muitas linguagens pra não ficar pesado desnecessariamente, você precisa instalar separado depois.

Também aprenda a usar [**Mise-en-place**](https://mise.jdx.dev/dev-tools/). No menu do Omarchy tem uma opção pra instalar suporte a várias linguagens e ele vai usar Mise, que é a forma correta de gerenciar suas linguagens.

Mise é muito fácil, no geral, de dentro do diretório do seu projeto, é só fazer algo como:

```
mise use ruby@3.4.3
```

Com isso, só dentro do seu projeto vai estar disponível Ruby 3.4.3, mas fora pode estar outra versão global. Não esquecer de ativar no seu `.zshrc`:

```
eval "$(mise activate zsh)"
```

## Impressões e Conclusão

Comparado ao meu Manjaro antigo, muita coisa que não precisei configurar mais. Por exemplo, por causa do tanto de espaço que Docker e LLMs precisavam, eu tinha configurado um drive iSCSI no meu NAS só pra isso. Mas como eu liberei 2 TB de NVME local, não preciso mais lidar com isso, basta usar os novos sub-volumes de BTRFS que criei acima.

Também não preciso mais configurar QEMU/Libvirt porque não preciso mais usar Windows junto com Linux lado a lado. Mantive o NVME com as partições Windows e posso fazer dual boot pra ela se precisar muito de alguma coisa. No geral nunca preciso, então é menos uma configuração complicada.

Eu passei meses usando apps via Flatpak, com o intuito de ser mais seguro e isolado do sistema. É como rodar apps via Docker. Mas é chato demais. Por ser isolado significa que ele não obedece os temas do sistema, no final sou obrigado a ficar abrindo permissões pros apps. E se for pra ficar abrindo, é mais fácil instalar nativamente via `yay` e tudo funciona perfeitamente.

Acho que isso completa minhas anotações de tudo que precisei fazer pra deixar o Omarchy exatamente do jeito que eu gosto. Como falei repetidas vezes, o que funciona pra mim não quer dizer que vai funcionar pra você. Pra isso existe documentações como o [ArchWiki](https://wiki.archlinux.org/title/Main_page) que é "O" melhor lugar pra aprender tudo que sobre Linux. Use e abuse dessa documentação.

Como podem ver, não teve tanta coisa assim que eu customizei no Omarchy, por isso eu gosto dele: 95% do caminho ele já fez pra mim, só precisei mexer em poucos ajustes pra deixar do jeito que eu preciso. E agora sem o tanto de lixo que foi acumulando no meu Manjaro velho. Recomendo que todo mundo instale Omarchy como primeiro Linux e aprenda a usar de verdade.
