---
title: "Consertei vários jogos de corrida antigos usando IA: Colin McRae 1, 3, 4, Sega Rally Revo e Outrun 2006, até a trilogia Screamer"
slug: "consertei-varios-jogos-de-corrida-antigos-usando-ia"
date: '2026-11-02T09:00:00-03:00'
draft: false
translationKey: consertei-varios-jogos-de-corrida-antigos-usando-ia
description: "O launcher do Colin McRae 1 deu tão certo que repeti a receita: em pouco mais de um dia saíram mais seis launchers, pro Colin McRae Rally 3, 04 e DiRT, OutRun 2006, Sega Rally Revo e a trilogia Screamer. Explico por que esses jogos abandonados não rodam mais sem gambiarra, como cada launcher religa gráfico, controle e tela usando Wine, DXVK, dgVoodoo e um dosbox modificado, e o que dá pra melhorar depois: 4K, widescreen Hor+, fps, filtragem anisotrópica, escaladores, correção de cor no CMR3 e texturas HD geradas por IA no CMR1. Tem os links, vídeos, instruções pra Linux e Windows, e quanto tempo cada um levou."
tags:
- games
- retrocomputacao
- emulacao
- linux
---

> **TL;DR:** fiz launchers que instalam e rodam Colin McRae Rally 1, 3, 04 e DiRT, OutRun 2006, Sega Rally Revo e a trilogia Screamer em PC moderno, com 4K, widescreen e controle de Xbox, no Linux e no Windows. Se você só quer baixar e jogar, pule direto pra [lista dos jogos](#os-jogos), com os links das releases, vídeos e instruções.

No [artigo anterior](/2026/10/29/brincando-de-pc-ports-com-colin-mcrae-1/) eu mostrei os meus dois projetos em cima do Colin McRae Rally de 1998: o **recomp** em Rust, que tenta reconstruir o jogo do zero, e o **launcher**, uma camada fina em volta do executável original que faz ele rodar em 4K, widescreen e 60 fps num PC moderno.

O resultado do launcher me agradou muito, e o mais interessante foi perceber como a receita era fácil de repetir. Então resolvi trazer mais abandonware de volta pra era moderna. Entre a noite de 31 de outubro e a madrugada de 2 de novembro saíram mais seis launchers, cobrindo oito jogos de corrida:

- **Colin McRae Rally 3** (2003)
- **Colin McRae Rally 04** (2004 no PC)
- **Colin McRae: DiRT** (2007)
- **OutRun 2006: Coast 2 Coast** (2006)
- **Sega Rally Revo** (2007)
- a trilogia **Screamer** (1995 a 1997), da era do MS-DOS

Todos substituíram as instalações manuais que eu mantinha no meu projeto [distrobox-gaming](/2026/04/19/retrogames-de-corrida-favoritos-no-distrobox/). Por enquanto o objetivo foi só um: instalação fácil e reproduzível, com o jogo rodando bem.

## O problema do abandonware

Existem centenas de jogos em estado de abandonware: não tem nenhuma forma oficial e suportada de jogar hoje. Eles não estão na Steam, não estão nem na GOG. E mesmo alguns que estão na GOG só rodam direito depois de muito ajuste manual. A trilogia Screamer é um exemplo: a GOG vende o Screamer e o Screamer 2 (o Screamer Rally não está lá), e a versão dela vem com um stub de Glide pra Windows que simplesmente não funciona no DOS.

O motivo é que a compatibilidade quebrou em camadas.

Jogos de MS-DOS precisam de emulador. Jogos de Windows 95/98 falam com DirectDraw e Direct3D 5, APIs que o Windows moderno mantém só por compatibilidade, com bugs e limitações que a Microsoft não prioriza mais. Jogos de Windows XP de 32 bits dependem de proteções de disco como o SafeDisc e versões antigas do SecuROM, que a Microsoft [bloqueou em 2015](https://www.pcworld.com/article/2985806/windows-vista-7-8-update-prevents-some-old-cd-rom-games-from-running.html) por questão de segurança. No Windows 10 e 11, a maioria desses jogos não sobe sem configuração manual, e no Linux a lista de ajustes é ainda maior.

### Dois exemplos do que era preciso fazer

O **Colin McRae: DiRT** de 2007 era assim no meu setup antigo:

1. Rodar o instalador InstallShield de 2007 de forma interativa, porque ele não tem modo silencioso confiável.
2. Aplicar a cadeia de patches oficiais na ordem: 1.1, 1.2, 1.21 e 1.22, cada um com seu assistente.
3. Descobrir que o jogo abre os menus, mas **trava ao carregar qualquer corrida** num processador com 32 threads. O motor EGO monta mapas de distribuição de trabalho por número de núcleos, e os mapas originais não sabem lidar com tanta thread.
4. Aplicar um fix da comunidade, o MTFix, que corrige isso mas apaga o cache de configuração e reseta todas as opções gráficas.
5. Lembrar que, depois de mudar a resolução, o botão "reiniciar agora" do jogo só fecha o jogo.

O **Sega Rally Revo** de 2007 tinha outra lista:

- um microstutter permanente em toda corrida, causado por dois bugs de tempo empilhados que o patch 4.060 introduziu;
- uma chave de registro obrigatória, sem a qual o jogo não abre;
- um configurador em .NET que não funciona direito no Wine;
- o menu principal crashando se dois arquivos de save não existirem;
- vídeos de logo que faziam a inicialização parecer travada;
- tela cheia exclusiva falhando em monitor de 240 Hz, e tela preta em PC com duas GPUs, a integrada e a dedicada.

> A maioria das pessoas simplesmente não vai fazer nada disso. Elas desistem do jogo, e o jogo morre um pouco mais.

## Decomp, recomp e por que eu fiz só launcher

O hype do retrogaming hoje está nos **decomps** e **recomps**. Um decomp reconstrói, a partir do binário, um código-fonte equivalente ao original, que compila pro mesmo binário, como foi feito com o [Super Mario 64](https://github.com/n64decomp/sm64) e com o Ocarina of Time, que virou o [Ship of Harkinian](https://github.com/HarbourMasters/Shipwright). Um recomp traduz o binário automaticamente pra C e compila isso como código nativo, como o [N64Recomp](https://github.com/N64Recomp/N64Recomp) faz com jogos de Nintendo 64, que [gerou ports de PC com ultrawide e fps alto](https://tomshardware.com/video-games/nearly-all-nintendo-64-games-can-now-be-recompiled-into-native-pc-ports-to-add-proper-ray-tracing-ultrawide-high-fps-and-more).

A vantagem dos dois é enorme: você deixa de depender do binário original e consegue compilar o jogo pra qualquer plataforma, de ARM e Android a Mac. É o que eu tentei com o recomp do Colin McRae 1, e é trabalho de meses.

Pra mim, a coceira era outra. Eu queria que os jogos que eu gosto fossem fáceis de instalar e de manter no meu distrobox. Pra isso, um launcher basta.

## O conceito: religar o jogo nas bordas

Todos os launchers seguem a mesma ideia. O jogo original continua igual, e o que muda são as bordas dele com o mundo, as partes que envelheceram:

- **gráfico**: a API de 1998 ou de 2003 passa a conversar com uma API moderna;
- **entrada**: controle de Xbox, gatilho analógico e rumble no lugar de teclado e joystick de porta de jogos;
- **áudio e arquivos**: registro do Windows, arquivos de configuração, saves e caches escritos certo antes de o jogo abrir;
- **tela**: escolher o monitor certo, a resolução certa e o modo de janela que não quebra.

Cada launcher identifica o executável, por hash ou por assinatura de bytes, recusa versões desconhecidas, e trabalha numa **cópia privada** do jogo. A pasta original nunca é modificada; qualquer patch vai só na cópia.

### As peças de compatibilidade

Quase nada disso eu escrevi do zero. Os launchers orquestram ferramentas que a comunidade levou décadas construindo:

- **Wine**: a camada que implementa a API do Windows no Linux. Os launchers dos jogos de Windows levam o próprio Wine 11.20 dentro de um AppImage.
- **DXVK**: traduz Direct3D 8, 9, 10 e 11 pra Vulkan. É o que deixa jogo de DirectX 9 rodar rápido no Linux.
- **dgVoodoo 2**: um wrapper do desenvolvedor Dege que pega APIs gráficas antigas (Glide da 3dfx, DirectDraw e Direct3D das primeiras versões até a 9) e traduz pra Direct3D 11 ou 12. É como fazer um jogo de 2003 achar que está numa placa da época enquanto roda em placa moderna.
- **dosbox-staging**: um emulador de DOS moderno, com emulação da placa 3dfx Voodoo.
- **gamescope**: o compositor da Valve que roda o jogo numa tela própria e faz o escalonamento pro monitor.
- **patches e ferramentas da comunidade**: SilentPatch pro Colin McRae 3, OutRun2006Tweaks pro OutRun, o fix de stutter do Sega Rally, e o Xidi, que apresenta controles XInput pros jogos que só leem DirectInput.

E o [REA](/2026/10/13/engenharia-reversa-com-ia-a-adobe-morreu/), a minha ferramenta de engenharia reversa, entra onde não tem ferramenta pronta: achar a função do jogo que calcula a projeção, o formato do arquivo de perfil do controle, o lugar certo pra um hook.

## Os que exigiram mais engenharia reversa

### Colin McRae Rally 04: três camadas de tradução

O CMR04 usa Direct3D 9, mas é hostil a widescreen: sem patch, o 16:9 não mostra mais cenário dos lados. E o menu gráfico do jogo só lista modos até 2048x1536, reescreve o registro e trava.

O pipeline final ficou com três camadas no Linux: o Direct3D 9 do jogo passa pelo **dgVoodoo 2.80**, que converte pra Direct3D 11, o **DXVK** converte o Direct3D 11 pra Vulkan, e o Wine roda tudo por baixo. No Windows, fica só o dgVoodoo. A versão mais nova do dgVoodoo crashava, e a 2.80 nem está mais disponível completa no site oficial, então o repositório guarda só a DLL testada.

Pro widescreen, a engenharia reversa achou a função de projeção e a matemática dela: o patch de 16:9 da comunidade só funciona se o jogo renderizar em 4:3 e a imagem for esticada depois. Renderizar direto em 16:9 com o patch deixava os carros 25% mais estreitos. Então o launcher renderiza em 4:3 na altura da tela e o dgVoodoo estica pra 16:9 com a geometria certa.

E teve detalhe de todo tipo:

- o jogo ignora o Alt+F4: a função da janela devolve zero pra mensagem de fechar e o loop principal ignora a de sair, então o launcher injeta um hook que fecha o processo;
- o perfil do controle fica num arquivo binário de quase 1 MB, e o launcher escreve os bytes certos pra o controle já vir configurado, conferido byte a byte contra o arquivo que o próprio jogo salvou;
- num monitor principal em retrato, a imagem saía numa faixa de 3829x682, então o launcher escolhe o maior monitor em paisagem.

![Colin McRae Rally 04 rodando em 16:9 com controle](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/jogos-corrida-ia/cmr04-game.jpg)

### Sega Rally Revo: corrigindo o stutter em Rust

O stutter do Sega Rally tem uma correção da comunidade, mas ela é um patch binário pronto. Em vez de distribuir os bytes de terceiros, o launcher reimplementa a mesma correção em Rust, com um montador de x86 minúsculo que escreve três "code caves" no executável da cópia privada:

- uma trava que impede o jogo de criar a thread de ritmo duplicada a partir da segunda etapa;
- um relógio de corrida que lê o relógio mestre em vez do valor truncado em milissegundos;
- uma atualização desse relógio a cada frame.

Cada ponto de hook é conferido byte a byte antes de escrever, e o resultado reproduz exatamente o hash do executável corrigido de referência. O mesmo esquema aplica o patch de aspecto pra 21:9 e 32:9, achando as tabelas por padrão de bytes.

O resto foi lidar com o Wine: o jogo roda sempre num desktop virtual isolado, o launcher fixa a GPU NVIDIA em máquina com duas placas, e configura o driver de controle do Wine pra o XInput nativo do jogo funcionar.

### A trilogia Screamer: hackeando o próprio emulador

A trilogia Screamer é de MS-DOS, então o caminho foi outro: um **dosbox-staging modificado**, com uma biblioteca em Rust ligada estaticamente dentro do emulador.

- **3dfx Glide de verdade.** O Screamer 2 e o Screamer Rally carregam o `GLIDE2X.OVL` do DOS, que conversa com a Voodoo 1 emulada pelo dosbox. O Screamer 2 da GOG traz um stub de Windows que não funciona; com o Screamer Rally na mesma pasta, o launcher usa o OVL genuíno de DOS dele.
- **Um bug do próprio jogo.** O código de upload de texturas tinha um erro na fronteira de 2 MiB, corrigido com um patch de três instruções.
- **Controle analógico.** Com o emulador rodando na velocidade máxima, a leitura de joystick da porta de jogos termina antes de o capacitor emulado descarregar, e o controle não funciona. A solução foi achar na memória do jogo os registros de controle e escrever direção, acelerador e freio direto neles, em 10 bits.
- **Widescreen e distância de desenho** vieram de patches no executável Watcom: a matriz de câmera ganha um campo de visão maior antes da projeção, e os limites de distância dos objetos aumentam.

Uma primeira versão usava `LD_PRELOAD` pra interceptar o relógio do sistema e travava o SDL, porque rodava em várias threads do emulador ao mesmo tempo. Por isso o hook acabou dentro do loop principal do dosbox.

![Launcher da trilogia Screamer, com a seleção do Screamer de 1995](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/jogos-corrida-ia/screamer-launcher-play.png)

## Depois de rodar, melhorar

Com o jogo rodando de novo no Linux e no Windows, dá pra ir além do original. É aqui que o launcher vira mais que um instalador.

### Resolução e aspecto

Jogo de 1998 foi feito pra 640x480 ou 800x600 em monitor 4:3. Renderizar em 4K é a parte fácil, quando a API permite.

O difícil é o aspecto: esticar uma imagem 4:3 pra 16:9 deixa tudo largo. O certo é o **Hor+**, que mantém a altura e mostra mais cenário nas laterais, aumentando o campo de visão horizontal. Isso exige mexer na projeção da câmera, e foi o que eu fiz no Colin McRae 1 e no Screamer. No Colin McRae 3, o SilentPatch já entrega Hor+ em qualquer proporção.

### Taxa de quadros

Muitos jogos antigos amarram física e renderização no mesmo relógio, e destravar o fps acelera o jogo inteiro. O Colin McRae 1 tem física num tick fixo de 25 Hz e interpola os quadros, então chega a 60 fps sem mexer na física. O Screamer não: a física lê uma tabela de 50 posições indexada pelo tempo do quadro, e passar de 50 fps faz os carros voarem na largada ou derruba o jogo.

Pro Screamer, o launcher tem um modo experimental de **geração de quadros** a 100 fps: entre dois quadros reais ele desenha um quadro intermediário, com uma busca de movimento simples feita num shader. Funciona, mas custa uns 10 ms de atraso, e por isso fica desligado por padrão.

### Filtragem anisotrópica

Quando uma textura é vista quase de lado, como o asfalto lá na frente, a filtragem comum borra tudo, porque amostra a textura como se ela estivesse de frente. A **filtragem anisotrópica** amostra mais pontos na direção em que a textura está inclinada, e o asfalto e as placas ao longe ficam nítidos. Nos jogos de Direct3D 9, como o Colin McRae 3 e o OutRun, dá pra forçar até 16x.

### Escaladores

Quando o jogo renderiza numa resolução e a tela tem outra, alguém precisa escalonar a imagem. No Linux, quase todos os launchers usam o gamescope, que oferece:

- **nearest**: repete pixels inteiros, ideal pra quem quer a cara original;
- **pixel**: mantém os pixels nítidos mas suaviza a borda entre eles, bom pra arte em pixel numa escala que não é inteira;
- **linear**: interpola entre os pixels, suave, mas borra;
- **FSR**: o FidelityFX Super Resolution 1.0 da AMD, que reconstrói bordas e aplica nitidez, bom pra subir de 1080p pra 4K;
- **NIS**: o equivalente da NVIDIA, usado no CMR04.

O Screamer tem um FSR próprio, escrito como shader dentro do dosbox, e um "superscale" 2x da Voodoo emulada: o emulador renderiza a placa 3dfx no dobro da resolução, multiplicando as coordenadas dos triângulos.

### Cor e gama no Colin McRae 3

O Colin McRae 3 sempre teve uma imagem lavada. Medindo um quadro em 4K, a imagem inteira ficava entre uns 25 e 160 numa escala de 0 a 255: preto que não é preto, branco que não é branco.

O launcher gera uma **LUT**, uma tabela de conversão de cores em 3D, que reajusta ponto preto, ponto branco, gama e saturação, e aplica ela com o vkBasalt por cima do DXVK, junto com um filtro de nitidez. Tem dois perfis, "Colour" e "Cinematic", ambos opcionais e por enquanto só no Linux.

![Colin McRae Rally 3 antes e depois da correção de cor e gama](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/rea-colin-mcrae-3-cinematic-before-after.jpg)

### Texturas HD geradas por IA no Colin McRae 1

O projeto que mais me divertiu foi o pacote de arte HD do Colin McRae 1. O jogo guarda as imagens num formato próprio, e uma ferramenta em Rust extrai todas, inclusive as que ficam dentro dos modelos 3D: céus, pinturas dos carros, placas na beira da pista.

A primeira tentativa foi o Real-ESRGAN, um upscaler clássico. Ficou ruim: inventou textura de couro rachado na fibra de carbono e contornou as letras. Daí em diante, cada tipo de imagem ganhou um método:

- **arte chapada** (HUD, logos, bandeiras, ícones) passa por um algoritmo determinístico de despixelização, sem IA, e depois é travada na paleta original;
- **o resto** é redesenhado em 4K pelo modelo de imagem do Google, o Gemini 3.1 Flash Image, com um modelo de visão conferindo se cada palavra e número do redesenho é real. Se nenhuma tentativa passa, fica a imagem original.

Os erros da IA foram didáticos: o "50" do mostrador virou outro "60", "SNR" virou "SMX", apareceu "New ZeZealand", carros ganharam estepe e entrada de ar que não existiam. A regra que ficou: nunca confiar nas cores do modelo, pegar a melhor de três tentativas, e comparar cada resultado com o original.

O pacote 4 cobre o HUD, os menus, os céus de todas as etapas, 124 das 164 placas e 247 das 370 texturas de carro. A arte bruta tem uns 800 MB; comprimida, fica em uns 47 MB. No jogo, um hook troca cada textura original pela versão HD na hora de desenhar, sem mudar o layout.

## Os jogos

Todos seguem o mesmo esquema de instalação, então explico uma vez. **Você precisa ter a sua própria cópia do jogo**, na versão que cada launcher pede, e nenhum deles distribui arquivos do jogo.

- **Linux**: baixe o AppImage da release, dê permissão de execução e rode. Ele já traz o Wine, e o DXVK nos jogos de Direct3D 9; o do Screamer traz o dosbox modificado. Se o gamescope estiver instalado, quase todos usam.
- **Steam / Steam Deck**: adicione o AppImage como jogo não-Steam, ou o executável de Windows do launcher com um Proton forçado. O Screamer roda nativo, sem Proton.
- **Windows**: baixe o zip, descompacte e rode o executável do launcher.

Na primeira execução, aponte a pasta onde o jogo está instalado, escolha um perfil visual e aperte Play.

```bash
chmod +x CMR4Launcher-*-x86_64.AppImage
./CMR4Launcher-*-x86_64.AppImage
```

### Colin McRae Rally (1998)

[Release v0.7.0](https://github.com/akitaonrails/rea-colin-mcrae/releases/tag/v0.7.0) · precisa da versão em CD, atualizada pra EU v1.5.

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/01/colin-mcrae-rally/showcase-h264.mp4" poster="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/01/colin-mcrae-rally/showcase-poster.jpg" >}}

- 4K, widescreen Hor+ e 60 fps, com a física original a 25 Hz;
- pacote de arte HD gerado por IA no HUD, menus, céus, placas e carros;
- filtragem trilinear com mipmaps, distância de desenho estendida, buffer de profundidade de 24 bits;
- pedais nos gatilhos, rumble e layouts de botão modernos.

![Launcher do Colin McRae Rally](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/jogos-corrida-ia/cmr1-launcher.png)

### Colin McRae Rally 3 (2003)

[Release v0.1.2](https://github.com/akitaonrails/rea-colin-mcrae-3/releases/tag/v0.1.2) · precisa da versão oficial 1.1.

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/rea-colin-mcrae-3-demo-v012.mp4" poster="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/rea-colin-mcrae-3-demo-v012-poster.jpg" >}}

- SilentPatch com widescreen em qualquer proporção e interface HD em 4K;
- conversão do executável oficial 1.1 pro executável sem DRM das reedições;
- filtragem anisotrópica até 16x, campo de visão ajustável, sombras nítidas ou suaves;
- correção de cor e gama opcional no Linux;
- gatilhos como pedais e o controle já configurado no perfil novo.

![Aba de imagem do launcher do Colin McRae Rally 3](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/jogos-corrida-ia/cmr3-launcher-picture.png)

### Colin McRae Rally 04 (2004)

[Release v0.2.0](https://github.com/akitaonrails/rea-colin-mcrae-4/releases/tag/v0.2.0) · precisa da sua instalação do jogo, com o `cmr4.exe` original.

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/colin-mcrae-rally-04/showcase-h264.mp4" poster="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/colin-mcrae-rally-04/showcase-poster.jpg" >}}

- 16:9 com a geometria correta, via dgVoodoo;
- escolha automática do monitor em paisagem e fechar a janela funcionando;
- gatilhos analógicos como pedal combinado e perfil do controle pré-configurado;
- limite de fps e vsync opcionais.

### Colin McRae: DiRT (2007)

[Release v0.1.1](https://github.com/akitaonrails/rea-dirt/releases/tag/v0.1.1) · precisa da versão oficial 1.22.

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/dirt-launcher/showcase-h264.mp4" poster="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/dirt-launcher/showcase-poster.jpg" >}}

- correção própria do crash em processador com muitas threads, sem resetar as configurações;
- flag Large Address Aware no executável da cópia, pra ele usar mais de 2 GB de memória;
- preset Ultra em 4K, 16:9 nativo do jogo e XInput nativo.

![Launcher do Colin McRae DiRT detectando a versão 1.22](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/jogos-corrida-ia/dirt-launcher.png)

### OutRun 2006: Coast 2 Coast (2006)

[Release v0.1.0](https://github.com/akitaonrails/rea-outrun-2006/releases/tag/v0.1.0) · precisa da sua cópia de PC do jogo.

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/outrun-2006/showcase-h264.mp4" poster="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/outrun-2006/showcase-poster.jpg" >}}

- o OutRun2006Tweaks, que conserta o port de PC e remove o DRM de disco, instalado automaticamente numa versão fixa e testada;
- 4K, filtragem anisotrópica 16x, reflexos em 2048 e distância de desenho maior;
- a música "Rush a Difficulty" com os dois segundos iniciais que faltavam na versão de PC;
- pacote de texturas HD opcional, baixado sob demanda;
- rumble e gatilhos completos pelo SDL.

![Aba de imagem do launcher do OutRun 2006](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/jogos-corrida-ia/outrun-launcher-picture.png)

### Sega Rally Revo (2007)

[Release v0.1.1](https://github.com/akitaonrails/rea-sega-rally-revo/releases/tag/v0.1.1) · precisa da versão 4.0.6.0 de PC.

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/sega-rally-revo-launcher.mp4" poster="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/sega-rally-revo-launcher-poster.jpg" >}}

- correção do stutter reimplementada e conferida byte a byte;
- 4K, qualidade Ultra e ultrawide 21:9 e 32:9;
- limite de 60 ou 120 fps, controle XInput nativo e teste de rumble.

![Launcher do Sega Rally Revo](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/jogos-corrida-ia/srr-launcher-play.png)

### Trilogia Screamer (1995 a 1997)

[Release v0.6.0](https://github.com/akitaonrails/rea-screamer-trilogy/releases/tag/v0.6.0) · precisa do Screamer e do Screamer 2 da GOG ou dos CDs originais; o Screamer Rally só existe em CD.

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/rea-screamer-trilogy/showcase-h264.mp4" poster="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/rea-screamer-trilogy/showcase-poster.jpg" >}}

- 3dfx Glide com o OVL genuíno de DOS e superscale 2x da Voodoo;
- FSR em shader, widescreen Hor+ e distância de desenho estendida;
- controle analógico de verdade, inclusive no 8BitDo Ultimate 2;
- trilha de CD funcionando e geração de quadros experimental a 100 fps.

## Windows e Linux ao mesmo tempo

Fazer o mesmo launcher funcionar nos dois sistemas exige algumas escolhas:

- **um executável só.** Os launchers dos jogos de Windows são escritos em Rust, com interface em egui, e compilados como executável de Windows. No Windows ele roda direto; no Linux, o mesmo executável roda dentro do Wine;
- **o AppImage leva tudo.** No Linux, cada launcher de jogo de Windows empacota um Wine 11.20, e o DXVK quando o jogo precisa, com o próprio prefixo, sem depender de nada instalado na máquina;
- **o gráfico muda por sistema.** No Windows o jogo usa o Direct3D nativo; no Linux, o DXVK traduz pra Vulkan, e o Colin McRae 1 usa o wined3d do próprio Wine;
- **o Screamer é nativo nos dois**, porque o dosbox-staging compila pra Linux e Windows.

Teve pegadinha nisso também. O linker do GNU binutils 2.47 descartava parte da tabela de importação do executável de Windows, e o launcher crashava logo ao abrir. A correção foi trocar pro linker do LLVM no OutRun e no Sega Rally, e a CI do Sega Rally passou a conferir as importações.

> Todos os launchers foram testados de ponta a ponta no Linux (com Wine 11, ou com o dosbox no caso do Screamer), numa RTX 5090 e com controle estilo Xbox. **No Windows nativo eles ainda não foram testados.** Se você tem algum desses jogos e um PC com Windows, teste e abra uma issue no repositório, com o SHA-256 do executável e o log. Contribuições são muito bem-vindas.

## Quanto tempo levou

Pelo histórico do git, somando as sessões de trabalho, e contando o trabalho antes do primeiro commit pelas datas dos arquivos do projeto:

| Launcher | Commits | Trabalho estimado |
| --- | ---: | ---: |
| Colin McRae Rally (desde o artigo anterior) | 39 | ~17 h |
| Trilogia Screamer | 29 | ~12 h |
| Colin McRae Rally 3 | 27 | ~7 h |
| Colin McRae Rally 04 | 9 | ~5,5 h |
| Colin McRae: DiRT | 3 | ~4,5 h |
| OutRun 2006 | 17 | ~4,5 h |
| Sega Rally Revo | 6 | ~4,5 h |

Vários foram feitos em paralelo: o CMR04 e o DiRT na mesma tarde, o OutRun e o Sega Rally na mesma noite. Somando, são umas 38 horas de sessões de trabalho nos seis launchers novos, mas como eles andaram em paralelo, tudo coube em pouco mais de um dia de calendário.

### O que deu errado no caminho

- **A versão nova nem sempre é a melhor.** O dgVoodoo 2.87 crashava no CMR04; a 2.80, que funciona, nem está mais disponível completa.
- **O jogo também tem bugs.** O Screamer tinha um bug de upload de textura, e o DiRT tem mapas de threads incompletos pra 6 núcleos.
- **Código que parece morto pode estar vivo.** No Screamer, uma área de "preenchimento com zeros" usada pra um patch era código alcançável, e o jogo fechava no meio da corrida.
- **Diagnóstico errado custa caro.** No CMR3, um controle virtual criado por outro script na minha máquina me fez caçar um bug de mapeamento que não existia.
- **O Wine tem as suas manias.** O EGL do Wine 11 caía pra renderização por software na NVIDIA, a tela cheia escolhia o monitor em retrato, e um crash do player de vídeo travava o jogo atrás de um depurador invisível.

## Ferramentas velhas, velocidade nova

Nada aqui é técnica nova. Wine existe desde 1993, o DOSBox desde 2002, o dgVoodoo e o DXVK há anos, e os patches da comunidade foram feitos por gente que passou noites com depurador e editor hexadecimal. Ghidra, disassembler, `winedbg`, xdelta: tudo ferramenta de décadas.

A diferença é que agora um LLM opera essas ferramentas comigo. Ele lê a documentação, escreve o hook, roda o jogo, compara o resultado e tenta de novo, enquanto eu decido o que vale a pena consertar e reconheço quando a estratégia está errada. O REA dá a ele acesso estruturado à engenharia reversa, e o resto é a caixa de ferramentas que a comunidade de preservação já tinha construído.

> Portar abandonware de volta pra era moderna costumava levar semanas por jogo, e por isso quase ninguém fazia. Com LLMs operando ferramentas que existem há décadas, cada jogo virou trabalho de algumas horas, e eu fiz seis em pouco mais de um dia.

Os launchers são experimentais e vão continuar mudando. Se o seu jogo favorito está preso no passado, a receita está aberta nos repositórios.
