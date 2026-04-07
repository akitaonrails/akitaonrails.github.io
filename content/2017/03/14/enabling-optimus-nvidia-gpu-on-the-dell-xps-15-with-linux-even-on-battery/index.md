---
title: "Habilitando a GPU Optimus NVIDIA no Dell XPS 15 com Linux (até na Bateria)"
date: '2017-03-14T14:21:00-03:00'
slug: habilitando-a-gpu-optimus-nvidia-no-dell-xps-15-com-linux
tags:
  - traduzido
translationKey: enabling-optimus-nvidia
aliases:
  - /2017/03/14/enabling-optimus-nvidia-gpu-on-the-dell-xps-15-with-linux-even-on-battery/
draft: false
---

Já faz mais de um mês desde o meu [último post](http://www.akitaonrails.com/2017/01/31/do-macbook-pro-para-o-dell-xps-arch-linux-para-usuarios-criativos) sobre como ajustar o Manjaro no Dell XPS 15.

O Manjaro lançou sua versão mais recente, a [versão 17](https://manjaro.org/2017/03/07/manjaro-gnome-17-0-released/), e o kernel chegou na 4.10. A atualização do Manjaro 16 com kernel 4.9 foi tranquila.

Esses são os pacotes específicos do kernel que estão instalados no momento:


```
$ pacman -Ss 410 | grep installed
core/linux410 4.10.1-1 [installed]
core/linux410-headers 4.10.1-1 [installed]
extra/linux410-acpi_call 1.1.0-0.7 (linux410-extramodules) [installed]
extra/linux410-bbswitch 0.8-0.7 (linux410-extramodules) [installed]
extra/linux410-ndiswrapper 1.61-0.7 (linux410-extramodules) [installed]
extra/linux410-nvidia 1:375.39-0.7 (linux410-extramodules) [installed]
```

Para garantir que tudo estivesse em ordem, removi os pacotes antigos relacionados ao kernel 4.9:

```
sudo pacman -R linux49 linux49-headers linux49-acpi_call linux49-bbswitch linux49-ndiswrapper linux49-nvidia
```

Também atualizei o BIOS do sistema para a [versão mais recente, 1.2.19](http://dell.to/2mWmWDg) (muitos recomendavam ficar na 1.2.18 por enquanto, mas não voltei atrás). A atualização do BIOS é bem simples: basta ter um pen drive formatado em FAT e copiar o arquivo "XPS_9550_1.2.19.exe". Na inicialização, você pressiona F12 e escolhe a opção de atualizar diretamente por lá.

Uma coisa que parou de funcionar foram as teclas de função para controlar o brilho da tela. Não consegui fazer funcionar de volta, mas ainda é possível controlar o brilho manualmente pelo terminal com comandos assim:

```
xbacklight -inc 20 # para aumentar
xbacklight -dec 20 # para diminuir
```

Aí vem a parte mais chata: a placa NVIDIA Optimus.

Suspender o sistema funciona bem na maior parte do tempo. Posso fechar a tampa, abrir no dia seguinte e a bateria está razoavelmente no mesmo nível. Créditos ao time do kernel por dar suporte a isso.

Mas o sistema de gerenciamento de energia desliga a GPU NVIDIA e eu não consigo reativá-la depois que a máquina acorda, nem mesmo se eu reconectar à fonte de energia. Toda vez que tento rodar algo via `optirun` (que força o processamento gráfico pela GPU NVIDIA em vez da GPU integrada Intel principal), aparece esse erro:

```
Could not enable discrete graphics card
```

E a única forma de ter a GPU funcionando era conectar o cabo de energia e reiniciar. Aí conseguia usar a NVIDIA normalmente. Reiniciar não é lento (graças ao SSD rápido), mas é incômodo ter que reabrir cada aplicação toda vez.

Depois de muita pesquisa, finalmente descobri como manter a GPU NVIDIA habilitada mesmo na bateria e após suspender. Primeiro, você precisa saber o ID PCI da placa:

```
$ lspci | grep "NVIDIA" | cut -b -8
01:00.0
```

Depois edite `/etc/default/tlp` e adicione esse ID PCI na lista negra do gerenciamento de energia:

```
# Exclude PCI(e) device adresses the following list from Runtime PM
# (separate with spaces). Use lspci to get the adresses (1st column).
#RUNTIME_PM_BLACKLIST="bb:dd.f 11:22.3 44:55.6"
RUNTIME_PM_BLACKLIST="01:00.0"
```

Reinicie e pronto! Agora dá para rodar aplicações pela placa NVIDIA mesmo sem estar conectado à tomada.

Parece que [existe um conflito](https://github.com/linrunner/TLP/issues/244) entre o TLP e o Bumblebee. A solução foi descrita [nessa thread do reddit de 2 meses atrás](https://www.reddit.com/r/archlinux/comments/5m78zz/bumblebee_nvidia_error_on_optimus_laptop/) e [nessa thread do fórum do Manjaro de 2 semanas atrás](https://forum.manjaro.org/t/bumblebee-could-not-enable-discrete-graphics-card/16728/12), caso queira acompanhar a discussão completa.

A parte mais difícil de usar NVIDIA no Linux é entender toda a terminologia que envolve isso. Nem tenho certeza se já aprendi tudo.

Aqui está o que entendi até agora:

* [Optimus](https://wiki.archlinux.org/index.php/NVIDIA_Optimus) é a tecnologia de gráficos híbridos que usa uma GPU Intel de baixo consumo como placa principal, podendo ser ponte para a GPU NVIDIA secundária — mais potente e mais gulosa em energia — quando realmente necessário.
* `optirun` é o comando usado para fazer essa ponte.
* "NVIDIA" é como chamamos os binários proprietários oficiais. No Arch está disponível no pacote "linux410-nvidia".
* "Nouveau" é o driver open source; usa Primus para fazer a ponte em vez do `optirun`. Para quem precisa de desempenho completo e plena compatibilidade da GPU, o ideal é evitar esse driver por enquanto.
* ["Bumblebee"](https://wiki.archlinux.org/index.php/Bumblebee#Power_management) é um daemon usado para habilitar e desabilitar a GPU NVIDIA. Não faz sentido deixá-la ligada o tempo todo, especialmente na bateria, para não drenar rápido demais.
* ["bbswitch"](https://github.com/Bumblebee-Project/bbswitch) é o módulo do kernel que faz as chamadas ACPI de baixo nível para controlar o estado de energia da GPU NVIDIA.
* ["TLP"](https://github.com/linrunner/TLP) é o sistema geral de gerenciamento de energia do Linux, que controla todos os aspectos do hardware da máquina, incluindo os dispositivos PCI (entre eles a placa NVIDIA).

O que entendi é: você não quer que o TLP intervenha e desligue a placa, porque se fizer isso, o Bumblebee não consegue reativá-la quando necessário (via bbswitch). Então você precisa colocar o dispositivo PCI na lista negra do TLP e deixar o Bumblebee fazer seu trabalho.

Com tudo funcionando corretamente, a GPU NVIDIA fica desligada por padrão. Para confirmar isso via bbswitch:

```
$ cat /proc/acpi/bbswitch
0000:01:00.0 OFF
```

Para forçar alguma aplicação a usar a placa, o comando é:

```
$ optirun -vv glxgears
[ 1817.200384] [DEBUG]Reading file: /etc/bumblebee/bumblebee.conf
[ 1817.200519] [INFO]Configured driver: nvidia
[ 1817.200579] [DEBUG]optirun version 3.2.1-2017-02-27-Format:%h$ starting...
[ 1817.200584] [DEBUG]Active configuration:
[ 1817.200588] [DEBUG] bumblebeed config file: /etc/bumblebee/bumblebee.conf
[ 1817.200592] [DEBUG] X display: :8
[ 1817.200595] [DEBUG] LD_LIBRARY_PATH: /usr/lib/nvidia:/usr/lib32/nvidia
[ 1817.200599] [DEBUG] Socket path: /var/run/bumblebee.socket
[ 1817.200603] [DEBUG] Accel/display bridge: auto
[ 1817.200607] [DEBUG] VGL Compression: proxy
[ 1817.200611] [DEBUG] VGLrun extra options: 
[ 1817.200615] [DEBUG] Primus LD Path: /usr/lib/primus:/usr/lib32/primus
[ 1817.200645] [DEBUG]Using auto-detected bridge virtualgl
[ 1818.163747] [INFO]Response: Yes. X is active.

[ 1818.163757] [INFO]Running application using virtualgl.
[ 1818.163843] [DEBUG]Process vglrun started, PID 9770.
10419 frames in 5.0 seconds = 2083.766 FPS
10671 frames in 5.0 seconds = 2134.041 FPS
```

Isso roda o `glxgears` (um app simples para testar a placa) pela ponte Optimus (em modo verboso, por isso toda aquela informação extra). Se o `glxgears` conseguiu usar a GPU NVIDIA, o FPS reportado deve ser maior que 1.000.

E para confirmar via `bbswitch`:

```
$ cat /proc/acpi/bbswitch
0000:01:00.0 ON
```

Quando você sai do `glxgears` com `Ctrl-C`, ele deve voltar a reportar `OFF`.

Para garantir, é importante verificar que o `/etc/bumblebee/bumblebee.conf` está configurado assim (apenas as chaves relevantes estão listadas abaixo):

```
[bumblebeed]
Driver=nvidia
...
[optirun]
Bridge=auto
...
[driver-nvidia]
KernelDriver=nvidia
PMMethod=bbswitch
...
```

Por enquanto, os únicos problemas pequenos que ainda tenho são:

* As teclas de função não controlam o brilho da tela
* O headset bluetooth Bose conecta sem problemas, mas não vira a saída de áudio principal automaticamente — é preciso trocar manualmente nas configurações de som (as teclas de função para volume e controles de mídia funcionam normalmente)
* Tive que instalar o Manjaro usando o boot BIOS antigo com esquema de partição MBR em vez de GPT com UEFI. Não sei ainda como migrar para GPT/UEFI (estou usando partição criptografada com LUKS)

Mas depois de resolver o problema da GPU NVIDIA após suspensão ou desconexão da energia, os outros problemas são apenas irritações menores.

Estou muito satisfeito usando o Manjaro no Dell XPS. Uso uma configuração com dois monitores e tudo funciona bem. Para quem quiser experimentar, recomendo ficar na versão 9560 (versão Sandy Bridge de meados de 2016) — não vá para as versões Kaby Lake ainda, pois o firmware do BIOS tem bugs e muitos aspectos do hardware ainda não têm suporte adequado ou documentação suficiente.

E para quem está começando com Arch, recomendo começar pelo Manjaro GNOME. É de longe a melhor e mais usável área de trabalho Linux que já experimentei.
