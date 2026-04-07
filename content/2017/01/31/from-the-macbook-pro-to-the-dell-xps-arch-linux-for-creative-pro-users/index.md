---
title: "Do MacBook Pro para o Dell XPS: Arch Linux para Usuários Criativos"
date: '2017-01-31T18:26:00-02:00'
slug: do-macbook-pro-para-o-dell-xps-arch-linux-para-usuarios-criativos
translationKey: macbook-to-dell-xps
aliases:
- /2017/01/31/from-the-macbook-pro-to-the-dell-xps-arch-linux-for-creative-pro-users/
tags:
- linux
- archlinux
- nvidia
- blender
- darktable
- bumblebee
- traduzido
draft: false
---

Como venho relatando em vários posts anteriores, estou migrando para Linux em tempo integral. Neste artigo quero mostrar como configurar o Arch Linux para que ele seja adequado para Usuários Criativos **Pro**, onde o acesso à GPU secundária é fundamental.

Se você é um Usuário Criativo Pro, não dá para rodar Final Cut Pro X (com Motion e Compressor), Logic Pro, Photoshop da Adobe e afins. Então você vai precisar mudar seu fluxo de trabalho se quiser entrar no ecossistema Linux. Felizmente, para muitos fluxos os aplicativos Linux amadureceram bem e dá para trabalhar sem precisar se contentar com software de baixa qualidade ou gambiarra.

Desenvolvedores de software raramente precisam de mais do que a placa Intel integrada barata, a menos que queiram instalar o [Steam via Wine](https://wiki.archlinux.org/index.php/Steam/Wine) para jogar títulos pesados.

Depois de muita pesquisa (leia-se: [YouTube!](https://www.youtube.com/results?search_query=Dell+XPS+15+9550+review)) fui com o Dell XPS 15" (modelo 9550). É uma máquina com quase um ano de vida, arquitetura SkyLake, usando o NVIDIA Optimus Híbrido Intel + GTX960M.

![Dell XPS 15" 9550](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/612/20170127_133009.jpg)

Até hoje nada supera a coesão entre software e hardware da Apple. Isso não pode ser subestimado. O mundo PC/Windows melhorou bastante, mas ainda é assombrado por BIOS instável, drivers instáveis etc. No Linux, é ainda pior.

Aqui vai o primeiro **protip**: evite modelos super novos — a maioria não tem drivers estáveis nem para Windows 10, quanto mais para Linux. Deixe o pessoal do Windows sofrer os primeiros meses; dê tempo à Dell, à [NVIDIA](http://windowsreport.com/nvidia-driver-crash-windows-10/) e à Intel para corrigir o caos com firmware de BIOS e drivers mais estáveis. Se você realmente quiser comprar um dos modelos Kaby Lake de 2017 que acabaram de sair, está numa roleta russa. Até os primeiros MacBooks costumam [dar problema](http://www.digitaltrends.com/computing/apple-releases-macos-sierra-10123-update/). Regra geral: não compre no dia do lançamento, espere pelo menos 3 meses. Você foi avisado.

Dentre as máquinas de início de 2016 que a maioria das distros Linux suporta razoavelmente bem, as séries [Dell XPS](http://www.anandtech.com/show/10116/the-dell-xps-15-9550-review), [Lenovo Thinkpad X1 Yoga](http://www.anandtech.com/show/10697/the-lenovo-thinkpad-x1-yoga-review) e possivelmente [Asus Zenbook Pro](http://www.digitaltrends.com/computing/dell-xps-15-vs-asus-zenbook-pro-ux501-battle-of-the-plus-sized-premiums/) e [HP ProBook](http://laptopmedia.com/review/hp-probook-450-g3-455-g3-review-what-a-budget-business-notebook-should-look-like/) estão bem.

Mas na maioria das categorias, a série XPS leva vantagem. A Dell fez um trabalho muito bom dessa vez.

O teclado, como na maioria dos PCs, é mediano: plástico, um pouco bamboleante, com curso aceitável mas clique duro e sem resistência suficiente. Para 99% das pessoas é bom o suficiente, mas não é o ideal para quem digita muito rápido.

O touchpad é um dos melhores em qualquer notebook PC, mas vale lembrar que a maioria dos touchpads de PC é vergonhosamente ruim, especialmente com gestos mais complexos do que rolar com dois dedos. Essa continua sendo uma área em que o Mac é imbatível. Dito isso, o da Dell é funcional e deve dar conta do recado, embora a rejeição de palma falhe aqui e ali para te irritar de vez em quando.

O monitor é outra história: o deslumbrante display 4K IPS do XPS 15 é excelente, superando de longe os Retina Displays do MacBook. O SSD Samsung PCIe NVMe M.2 também é o melhor da categoria. A carcaça de alumínio é simples mas bem usinada, e o acabamento em fibra de carbono é um bônus bem-vindo que faz da máquina algo que você genuinamente aprecia carregar.

![Dell XPS Display](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/613/20170124_211855.jpg)

Se você não quer mexer muito na configuração de hardware, a aposta mais segura costuma ser o Ubuntu — e mesmo assim [não vai ser perfeito](https://ubuntuforums.org/showthread.php?t=2317843).

Especialmente com displays HiDPI (acima de Full-HD), o Linux ainda está atrás. GNOME e KDE até suportam, mas outros ambientes desktop têm resultados mistos, e aplicativos mais antigos ainda não se adaptaram direito. Em distros LTS com pacotes velhos, você vai encontrar aplicativos com HiDPI errado. [Libreoffice](https://bugs.documentfoundation.org/show_bug.cgi?id=99508) e [Spotify](https://community.spotify.com/t5/Desktop-Linux-Windows-Web-Player/Linux-client-barely-usable-on-HiDPI-displays/td-p/1067272) são exemplos. E se você for como eu, usando múltiplos monitores com DPIs diferentes, pode esquecer. Ou usa o notebook com a tampa fechada (aí só tem um monitor externo para se preocupar), ou o texto fica minúsculo no monitor HiDPI principal para o DPI ficar certo no segundo monitor externo. Uma saída é configurar o display 4K para escalar para Full-HD (1080p). Mas aí fica a pergunta: qual é o sentido de ter um display 4K se você não consegue usá-lo direito? Então, não compre o 4K sem entender isso.

MacOS e Windows lidam com essa situação muito melhor. No MacOS nunca tive nenhum problema de HiDPI. Nenhum. A Apple foi muito mais eficaz em empurrar um padrão mais alto do que o resto da indústria, e essa coesão — sem precisar fuçar drivers e configurações — tem um valor enorme. Com Mac, você liga e usa. Com Windows, provavelmente vai ficar bem, a menos que apareça algum problema de driver. Com Linux, espere um volume razoável de ajustes para colocar o básico em ordem.

Notebooks PC novos também estão vindo com configurações esquisitas que fazem sentido no Windows, mas que dão trabalho para as distros Linux. Toda vez você começa desativando coisas no BIOS como Secure Boot, mudando para AHCI, etc. Então vamos direto ao ponto.

### Configuração do BIOS

A primeira coisa a fazer é alterar as configurações do BIOS. Pressione F2 na tela do logo Dell para entrar no setup e faça as seguintes mudanças:

* General - Advanced Boot Options - Enable Legacy Option ROMs
* General - Boot Sequence - Legacy (o padrão é UEFI)
* System Configuration - SATA Operation - AHCI (o padrão é RAID On)
* System Configuration - Touchscreen (desabilite, pois é praticamente desnecessário e consome mais bateria)
* Security - Secure Boot - Secure Boot Enable - Disabled
* POST Behavior - Fastboot - Through (o padrão é minimal)

Ao fazer essas mudanças, o Windows 10 pré-instalado não vai mais iniciar — então certifique-se de que não precisa dele antes de prosseguir.

### Ajustes no Kernel

Siga a página do [Wiki do Dell XPS (9550)](http://bit.ly/2jzVAxE).

O display 4K pode apresentar flickering, e para evitar isso edite o arquivo de configuração do Grub `/boot/grub/grub.cfg` e adicione os seguintes flags à linha existente:

```
GRUB_CMDLINE_LINUX_DEFAULT="... i915.edp_vswing=2 i915.preliminary_hw_support=1 intel_idle.max_cstate=1 acpi_backlight=vendor acpi_osi=Linux"
```

Essa linha já existe com alguns flags — não apague, apenas adicione os novos — e não se esqueça de rodar em seguida:

```
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

No mais, tudo deve funcionar bem, mas por precaução instalei também os pacotes [Powertop](https://wiki.archlinux.org/index.php/Powertop) e acpid:

```
sudo pacman -S powertop acpid
```

Fico feliz em reportar que consigo fechar a tampa do notebook e o sistema suspende corretamente, e ao abrir volta do sleep sem problemas — economizando bateria e me poupando de reiniciar todo dia.

### Distros Arch — Manjaro ao resgate

Estou me tornando um entusiasta do Arch, mas configurá-lo para funcionar num notebook moderno dá um trabalho absurdo. Não recomendo tentar se você estiver com pressa. Testei o [Arch Anywhere](https://arch-anywhere.org/), mas ele nem consegue passar pelo particionamento do disco (não gosta da configuração de SSD ou SATA). Testei o [Antergos](https://antergos.com/), mas por algum motivo as Contas Online do Gnome não funcionaram lá, mesmo reinstalando. No final fui com o [Manjaro](https://manjaro.org/), que instalou e funcionou sem grandes problemas.

Existem várias distros baseadas em Arch. Arch Anywhere e Antergos são mais "instaladores" do Arch — os repositórios principais ainda são o Arch vanilla, e eles tentam tornar o processo de instalação mais fácil do que você ter de se virar num shell de linha de comando cru.

O Manjaro é mais uma distro independente, onde as fontes principais apontam para o Manjaro primeiro, para que possam testar os pacotes mais recentes e segurá-los por um tempo antes de liberar, evitando que pacotes problemáticos quebrem seu sistema com frequência. Mas você ainda tem acesso direto aos pacotes AUR. O grande diferencial é um instalador **muito** melhor, com software de particionamento automático mais sofisticado do que o Arch Anywhere, e o próprio software de detecção de hardware [MHWD](https://wiki.manjaro.org/index.php?title=Manjaro_Hardware_Detection_Overview).

No geral funcionou bem, embora eu ainda tenha precisado ajustar a configuração gráfica, pois por padrão ele opta pelos drivers open source Nouveau. Confie em mim: vá para os binários proprietários.

Se você também é desenvolvedor de software, vai querer ler meu [post anterior sobre Arch](http://www.akitaonrails.com/2017/01/10/arch-linux-a-melhor-distro-de-todas).

### Gráficos Híbridos Optimus

O Dell XPS modelo 9550 usa a arquitetura Híbrida **Optimus**. Os drivers **Prime** são para GPUs NVIDIA standalone. A maioria dos notebooks funciona com a placa Intel integrada como única e principal (especialmente ultrabooks leves), e os modelos mais "Pro" conectam isso a uma NVIDIA GTX 960M secundária.

Se você tem apenas uma placa Intel simples, a maioria das distros vai fazer a coisa certa automaticamente e instalar os drivers e configurações corretas.

Agora, se você tem uma máquina de alta performance como este XPS 9550 ou 9560 (Kaby Lake), vai precisar de mais configuração. Primeiro, entenda a terminologia:

- Você precisa instalar o Bumblebee. É um daemon que habilita o acesso à GPU secundária. Só instalar o Bumblebee já resolve a maioria dos problemas.
- Depois instale o Primusrun, que é um back-end para o Bumblebee usado para rodar programas como o Steam de forma que tenham acesso à GPU secundária.
- Às vezes você vai ver referências ao Optirun, que hoje em dia parece usar o Primusrun por padrão (caso contrário, usava um framebuffer X secundário, adicionando overhead extra).

Com tudo instalado, geralmente basta fazer:

```
primusrun kdenlive
```

Por exemplo, para carregar o editor de vídeo Kdenlive usando OpenGL pela GPU Nvidia. Ou para rodar o [Steam via Wine](https://forum.manjaro.org/t/newbie-questions-about-hybrid-nvidia-and-intel-gpu-drives-tutorial/2974/26):

```
primusrun wine ~/.wine/drive_c/Program\ Files\ (x86)/Steam/Steam.exe
```

Como mencionei, o Manjaro provavelmente vai instalar o driver Nouveau, que é open source. Você deve instalar os binários proprietários assim:

```
sudo mhwd -a pci nonfree 0300
sudo mhwd -r pci video-hybrid-intel-nouveau-bumblebee
sudo mhwd -i pci video-hybrid-intel-nvidia-bumblebee
```

Lembrando que estou falando do XPS 9550 com configuração Optimus Intel-Nvidia. Leia a página [Configuring Graphics](https://wiki.manjaro.org/index.php/Configure_Graphics_Cards) do Manjaro sobre o assunto.

Aqui me deparei com um problema estranho. Estou usando o kernel **Linux 4.9**:

```
$ uname -a
Linux arch42 4.9.6-1-MANJARO #1 SMP PREEMPT Thu Jan 26 12:29:20 UTC 2017 x86_64 GNU/Linux
```

Teoricamente o pacote `core/linux49 4.9.6-1`. Mas por algum motivo o comando `mhwd -i` estava instalando os drivers `linux44-nvidia`.

Os módulos da GPU Nvidia nunca eram carregados até eu removê-los manualmente:

```
sudo pacman -R linux44-nvidia
```

E então instalar a versão correta manualmente:

```
sudo pacman -S linux49-nvidia
```

Por precaução, desinstalei o pacote `linux44` e todos os outros pacotes `linux44-*`:

```
sudo pacman -Ss linux44 | grep installed
# sudo pacman -R linux44-(nome do pacote)
```-

Agora tenho isso:

```
$ sudo pacman -Ss linux4 | grep installed
core/linux49 4.9.6-1 [installed]
extra/linux49-bbswitch 0.8-6 (linux49-extramodules) [installed]
extra/linux49-ndiswrapper 1.61-4 (linux49-extramodules) [installed]
extra/linux49-nvidia 1:375.26-6 (linux49-extramodules) [installed]
```

No `/etc/bumblebee/bumblebee.conf` confirmo que está carregando explicitamente o driver `nvidia` correto (o `linux49-nvidia` mencionado acima). Caso contrário, você precisa editar com `sudo vim`:

```
$ cat /etc/bumblebee/bumblebee.conf | grep Driver
# The Driver used by Bumblebee server. If this value is not set (or empty),
Driver=nvidia
```

Ao final, se você abrir o Manjaro Settings Manager, deve ver algo assim:

![Settings Manager](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/614/Screenshot_from_2017-01-31_18-24-34.png)

### Edição 3D e Vídeo Profissional

Para testar esse setup, comecei instalando o [Blender](https://wiki.archlinux.org/index.php/Blender) (uma das melhores ferramentas de edição 3D da indústria). Baixei um modelo 3D e animação gratuitos e tentei renderizar cycles via GPU Compute. Por segurança, instalei também o pacote Cuda:

```
sudo pacman -S blender cuda
```

Com os drivers corretos instalados, o Blender deve detectá-los e habilitar o uso dos cores CUDA:

![CUDA GPU Compute](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/608/Screenshot_from_2017-01-31_17-04-58.png)

Você pode monitorar a placa Nvidia com o comando `nvidia-smi`, que mostra algo assim:

![nvidia-smi monitoring](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/609/Screenshot_from_2017-01-31_16-43-46.png)

Isso cobre a modelagem 3D profissional se você precisar.

![Blender](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/615/Screenshot_from_2017-01-31_17-11-18.png)

Possivelmente o melhor editor de vídeo disponível para Linux é o [Kdenlive](https://kdenlive.org/). É o mais próximo que você vai encontrar do Adobe Premiere ou do Apple Final Cut Pro.

A instalação é assim:

```
sudo pacman -S kdenlive ladspa movit sox ffmpeg frei0r-plugins breeze-icons
```

E para previews em tempo real mais rápidos, ele pode ser iniciado via Primusrun num terminal assim:

```
$ primusrun kdenlive
OpenGL vendor:  "NVIDIA Corporation"
OpenGL renderer:  "GeForce GTX 960M/PCIe/SSE2"
OpenGL Threaded:  true
OpenGL ARG_SYNC:  true
OpenGL OpenGLES:  false
OpenGL vendor:  "NVIDIA Corporation"
OpenGL renderer:  "GeForce GTX 960M/PCIe/SSE2"
OpenGL Threaded:  true
OpenGL ARG_SYNC:  true
OpenGL OpenGLES:  false
```

Se eu iniciar sem o Primusrun, ele detecta primeiro a placa Intel:

```
$ kdenlive
OpenGL vendor:  "Intel Open Source Technology Center"
OpenGL renderer:  "Mesa DRI Intel(R) HD Graphics 530 (Skylake GT2) "
OpenGL Threaded:  false
OpenGL ARG_SYNC:  true
OpenGL OpenGLES:  false
OpenGL vendor:  "Intel Open Source Technology Center"
OpenGL renderer:  "Mesa DRI Intel(R) HD Graphics 530 (Skylake GT2) "
OpenGL Threaded:  false
OpenGL ARG_SYNC:  true
OpenGL OpenGLES:  false
```

Não tenho certeza absoluta, mas acredito que o Kdenlive usa OpenGL para mostrar previews em tempo real dos efeitos aplicados às faixas de vídeo, e isso provavelmente pode ser redirecionado via primus para a placa Nvidia secundária.

Na verdade, o Kdenlive, assim como seu concorrente OpenShot, usa o [MLT Multimedia Framework](https://www.mltframework.org/) — o motor de edição de vídeo não-linear. Por sua vez, o MLT usa o [movit](https://movit.sesse.net/), que são filtros de vídeo de alta performance e qualidade para a GPU. O comando de instalação via `pacman` que mencionei já cuida de instalar esses pacotes opcionais.

![Kdenlive](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/616/Screenshot_from_2017-01-31_18-29-38.png)

E se você quiser aproveitar a GPU Nvidia até no GIMP, existe um esforço em andamento para portar filtros para usar [GEGL/OpenCL](https://wiki.gimp.org/wiki/Hacking:Porting_filters_to_GEGL). Você pode habilitar o GEGL iniciando o Gimp pelo terminal assim:

```
GEGL_USE_OPENCL=yes gimp
```

Depois, você pode usar os plugins portados pelo menu `Tools - GEGL Operation`:

![GEGL Operation](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/610/Screenshot_from_2017-01-31_17-49-30.png)

E se você é fotógrafo profissional, vai querer instalar o [Darktable](http://www.darktable.org/), que é o mais próximo que você vai chegar do Apple Aperture ou Adobe Lightroom. Tem uma aparência bem cuidada e você consegue retocar suas fotos adequadamente.

O Darktable detecta automaticamente o driver Nvidia — não precisa rodar via Primusrun nem passar nenhuma flag especial.

![Darktable](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/617/Screenshot_from_2017-01-31_18-31-04.png)

### Considerações Finais

Você pode verificar se o aplicativo está usando a GPU monitorando com `nvidia-smi`:

```
watch -n 0.5 nvidia-smi
```

Isso mantém o monitoramento da GPU a cada meio segundo. O aplicativo aparece na lista de processos com um PID e você consegue ver o uso de memória (minha GPU tem 2GB de DRAM dedicada), uso de processamento e temperatura — pode chegar perto de 70 graus Celsius renderizando pelo Blender.

Acredito que isso é o máximo que dá para extrair do hardware com aplicativos multimídia de nível profissional. Não sou profissional de Blender, Kdenlive, Darktable ou Gimp, mas é bom saber que posso usá-los para minhas necessidades pontuais. Usuários Pro vão conseguir aproveitar ainda mais essa máquina com essa configuração.

Como disse no começo: se você é realmente um Usuário Pro, sempre em movimento e precisa fazer mudanças rápidas nos seus projetos multimídia on-the-go, provavelmente vai continuar melhor com o stack da Apple — um MacBook Pro com Final Cut Pro. Não esqueça que o Final Cut Pro e os outros softwares Pro da Apple são super otimizados para o hardware Mac, exportando vídeos em velocidades ordens de magnitude maiores do que o Premiere, por exemplo.

Mas você pode ser um Usuário Criativo Pro na indústria de games, desenvolvimento mobile, animação 3D, pós-produção, ou trabalhando num time misto com engenheiros de software. E ter a capacidade de construir seus assets multimídia numa plataforma Linux pode abrir possibilidades interessantes para fluxos de trabalho integrados no futuro.

Mesmo que você seja do mundo Mac ou PC, provavelmente vai querer usar software como o Blender, que é um competidor respeitável ou até complemento de ferramentas premiadas como o Maya.

Então, mesmo que você tenha que enfrentar algumas arestas na instalação e configuração inicial, uma vez feito isso funciona bem.
