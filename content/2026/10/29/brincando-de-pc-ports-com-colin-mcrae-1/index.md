---
title: "Brincando de PC Ports com Colin McRae 1"
date: '2026-10-29T22:00:00-03:00'
translationKey: brincando-de-pc-ports-com-colin-mcrae-1
description: "Usei REA para adaptar o Colin McRae Rally de 1998: um launcher roda a versão original em 4K, widescreen e 60 fps, sem exigir a novela de configuração antiga."
tags:
- games
- retrocomputacao
- linux
- engenharia-de-software
draft: false
---

Tenho brincado bastante com engenharia reversa usando o [REA](/2026/10/13/engenharia-reversa-com-ia-a-adobe-morreu/). Expliquei naquele artigo que ele junta Ghidra, Hopper, IDA, Frida e outras ferramentas numa interface que um agente consegue operar, mantendo evidência e procedência do que encontrou.

Isso ajuda muito. Só não confunda ajuda com botão mágico. Você não escreve *"REA, decompila este jogo"* ou *"porta isso pra Windows"* e vai tomar café enquanto ele termina. Precisa entender a arquitetura, o formato do binário, as APIs antigas, o que observar em runtime, qual ferramenta usar e como provar que a reconstrução bate com o programa original.

O trabalho de pensar continua com você. O REA acelera a coleta de evidências e dá braços extras pra quem sabe conduzir a investigação. Sem conhecimento técnico, o resultado continua sendo um amontoado de pseudocódigo plausível.

O [projeto está no GitHub](https://github.com/akitaonrails/rea-colin-mcrae) e ainda é **experimental e work in progress**. A versão que mostro aqui já permite jogar uma etapa inteira, mas estou construindo a próxima rodada: controle de frame pacing e vsync, filtros bilinear, trilinear e anisotrópico, além de estudar mipmaps sem alterar os dados originais. Também faltam testes em mais máquinas e no Windows nativo. Espere mudanças e releases novas.

Agora assista a isto:

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/10/29/colin-mcrae-rally/showcase-h264.mp4" poster="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/10/29/colin-mcrae-rally/showcase-poster.jpg" >}}

Esse é o **Colin McRae Rally original de 1998** rodando uma etapa inteira da Nova Zelândia. A captura está em 1080p, mas o jogo chega a 4K, em 16:9 real, mostrando mais cenário nas laterais. O HUD foi reposicionado nos cantos, a distância de desenho aumentou e aquele pop-in constante quase desapareceu.

A imagem é apresentada a 60 fps nessa configuração, com a física original no tick fixo de 25 Hz. O jogo já separava atualização e renderização e interpolava os frames. A velha cadeia de DirectDraw/Direct3D 5 só precisava chegar corretamente ao display moderno.

E abaixo está o launcher que fiz pra isso:

![Launcher do Colin McRae Rally, com configuração de resolução, widescreen, draw distance, controle e diretórios](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/10/29/colin-mcrae-rally/launcher.png)

Sim, eu fiz um launcher moderno pro primeiro Colin McRae Rally de PC.

## O jogo que ficou preso em 1998

Muita gente lembra do Colin McRae Rally pelo PlayStation. Era um jogo 4:3 de baixa resolução, feito pro ritmo dos televisores PAL e NTSC da época. Em 2026, ainda dá pra jogar num emulador e subir a resolução interna, porém o resultado continua carregando as limitações visuais e de apresentação do console.

A Codemasters também lançou uma [versão nativa pra Windows em 1998](https://www.pcgamingwiki.com/wiki/Colin_McRae_Rally). Ela foi feita pra Windows 95 e 98, num executável x86 de 32 bits com Direct3D 5 e DirectX 6.

Hoje o jogo está fora de catálogo e é tratado como abandonware pela comunidade. Esse rótulo descreve a realidade de preservação, não concede licença pra redistribuir nada. Meu launcher não leva executável, pista, carro, música ou qualquer asset da Codemasters. Você precisa da sua própria cópia instalada, do CD ou de um backup antigo, atualizada pro patch 1.5.

Encontrar os arquivos virou arqueologia. Eu não vou hospedar nem apontar download de jogo comercial. O projeto aceita hoje duas variantes europeias conhecidas do `Rally.exe` 1.5 e mostra o SHA-256 quando encontra outra versão, justamente pra podermos adicionar suporte sem adivinhar offsets.

## A novela anterior ao launcher

Eu já tinha automatizado o Colin McRae no meu projeto de [retrogames de corrida no Distrobox](/2026/04/19/retrogames-de-corrida-favoritos-no-distrobox/). Funcionava, mas leia a lista do que foi necessário:

- copiar uma instalação portátil e reconstruir no Wine as chaves `CDPath`, `HDPath`, `AVIPath` e `WAVPath` do Registry;
- forçar o perfil de compatibilidade do Windows XP SP3;
- prender um Xwayland rootful numa tela de 800x600, porque o menu abre em 640x480 e a corrida troca de modo;
- forçar o backend GLX e o offload pra NVIDIA, evitando que o Wine escolhesse a iGPU AMD ou `llvmpipe` na minha máquina;
- emular teclado a partir do gamepad, porque o caminho antigo de DirectInput detectava o controle, mas o jogo não aceitava os eixos;
- conviver com a imagem 4:3 esticada e com os becos sem saída de gamescope, dgVoodoo2 e outros wrappers.

Depois de tudo isso, o jogo chegava a **800x600**, 4:3, com a distância de desenho original. O controle precisava estar ligado antes de abrir. Clicar no velho painel de joystick podia deixar a tela preta com a música tocando. Era o tipo de configuração que funciona no meu PC porque eu gastei horas documentando cada gambiarra.

No Windows 11 talvez você consiga montar outra combinação de compatibility mode e wrappers. Eu não testei. A própria [PCGamingWiki](https://www.pcgamingwiki.com/wiki/Colin_McRae_Rally) recomenda compatibilidade com XP SP3 e documenta os problemas da versão de 1998 em sistemas atuais.

> Depender de uma sequência secreta de Registry, Xwayland, Wine e wrapper gráfico reduz a "preservação" a algo que funciona temporariamente no computador de alguém.

## Eu tentei fazer o decomp completo

O [OpenCMR2](https://github.com/pablocpas/OpenCMR2) me animou a tentar algo mais ambicioso. Ele é um port nativo em andamento do **Colin McRae Rally 2.0**, construído sobre o CMR2Decomp, usando SDL3 e os dados da cópia original. É exatamente o tipo de projeto que permite abandonar DirectDraw, DirectInput e outras APIs antigas.

Tentei fazer o equivalente pro primeiro jogo. Comecei a reconstrução no dia 20 de outubro. Quando parei pra revisar a direção no dia 28, depois de oito dias de commits quase contínuos, o experimento já tinha cerca de 250 mil linhas de Rust, 2.922 testes, 2.168 procedures mapeadas no executável, 32.530 símbolos e 2.310 strings catalogadas. O roadmap marcava 117 itens completos de 119.

No oitavo dia, o padrão ficou claro. O REA continuava encontrando funções, relações e evidências locais, e os agentes continuavam transformando cada descoberta em mais código e testes. Só que o processo estava derivando. O volume do repositório crescia, enquanto a distância até um port fiel e utilizável deixava de diminuir.

A parte parcial concentrava justamente a integração mais difícil: colisão e suspensão em runtime, animação de carro e rodas, produtores de marcha e giro, fluxo completo de chegada e pós-corrida, fidelidade de pintura, reflexos, danos e execução equivalente no Windows. Existia um harness dirigível, útil pra provar subsistemas, com partes recuperadas e outras aproximadas. Cada nova camada revelava outros contratos escondidos no executável original.

> Quando o repositório cresce mais rápido que o resultado, está na hora de revisar a estratégia.

Eu tratei aquilo como qualquer spike de engenharia: aprendi o que precisava, reconheci que o caminho estava se afastando do objetivo e parei. Continuar só porque já havia investido oito dias seria custo afundado. O experimento cumpriu sua função ao mostrar onde a reconstrução completa começava a perder convergência.

No dia 28, mudei o plano. O executável original já resolvia física, renderização, áudio, menus e toda a lógica do jogo. A opção mais curta era preservar esse núcleo e corrigir apenas as fronteiras quebradas pelo tempo. Foi daí que nasceu o launcher.

## Um launcher fino em volta do original

O [projeto está no GitHub](https://github.com/akitaonrails/rea-colin-mcrae). A arquitetura ficou bem menor: um launcher em Rust prepara um ambiente privado, valida a versão do jogo, configura o runtime e aplica correções em memória no `Rally.exe`. Uma DLL pequena intercepta os pontos em que resolução e HUD precisam de contexto extra.

Nada é alterado no diretório original. Na primeira execução, o launcher cria uma cópia privada em `%LOCALAPPDATA%\CMRLauncher\Rally`, sincroniza os arquivos e guarda os saves fora da instalação. Isso evita depender de escrita em `Program Files`, VirtualStore e restos de estado de uma tentativa anterior.

O launcher também recria as chaves de Registry que o jogo espera. Ele aponta `CDPath`, `HDPath`, vídeos e áudio pra cópia privada, escolhe o idioma e prepara o hardware. O velho CD deixa de ser uma dependência de execução, desde que a instalação tenha sido feita no modo completo.

As correções ficam associadas ao hash exato do executável. Hoje o projeto conhece a versão europeia 1.5 oficial e uma variante de fan pack. Se o binário não bater, ele recusa aplicar endereços de outra versão. Patch binário por aproximação é uma ótima maneira de transformar um jogo antigo em crash aleatório.

### Compatibilidade básica

O executável começa testando uma coleção de premissas dos anos 90. Eu removi ou substituí as que não fazem sentido hoje:

- o teste do CD e o bloqueio por versão do Windows;
- leituras privilegiadas de portas VGA;
- o caminho de vídeo 8-bit incompatível, trocado pelo frontend de 16 bits que já existia no jogo;
- o comportamento em que fechar a janela ou apertar `Alt+F4` era ignorado;
- um busy-wait baseado num relógio de CPU que se comporta mal em processadores modernos.

Wine e Proton continuam fornecendo DirectDraw, Direct3D 5, WinMM e as outras APIs antigas. Meu trabalho ficou concentrado no contrato entre o jogo e a camada de compatibilidade, sem reescrever um renderer inteiro.

### Controles modernos

O jogo reconhecia controles antigos de DirectInput e esperava eixos de uma época anterior aos triggers analógicos atuais. Agora aceleração e freio podem usar os gatilhos ou o analógico direito, e `Start` pausa.

Também corrigi um bug em que o jogo salvava um controle inexistente, voltava sozinho pro teclado ou carregava uma configuração quebrada e deixava o carro girando. O launcher detecta esse estado e repara o save. Isso elimina a ponte de teclado que eu mantinha no Distrobox.

### Resolução e widescreen

As quatro resoluções originais eram 320x240, 512x384, 640x480 e 800x600. O frontend foi desenhado em 640x480, enquanto a corrida recria o dispositivo gráfico com a resolução escolhida.

O launcher permite 1920x1080, 2560x1440 e 3840x2160. Durante a corrida, toda a interface 2D passa a usar uma tela virtual de 640x480. Sprites, fontes, mensagens, pausa, resultados e loading screen são escalados dessa área virtual; os elementos laterais do HUD ficam ancorados nos cantos da tela real.

O widescreen usa projeção **Hor+**. O centro mantém o mesmo enquadramento do 4:3 e a tela ganha informação nas laterais, em vez de esticar carros e árvores. Eu validei a geometria comparando 1440x1080 com 1920x1080: a faixa central permanece igual.

Os menus continuam sendo desenhados internamente em 640x480 e são ampliados com pixels nítidos. Em 4K essa cópia pode ficar abaixo de 30 fps em algumas máquinas. A corrida não sofre do mesmo problema; 1440p ou 1080p também deixa a navegação mais leve.

### Distância de desenho

As pistas já são carregadas inteiras. O sumiço do cenário vinha do far plane e dos limites de culling gravados nos dados de cada etapa, normalmente entre 100 e 200 metros.

O launcher pode multiplicar essas distâncias em até três vezes. Ele ajusta o far plane, o wedge de objetos, o limite de terreno e o cap especial de algumas etapas. A geometria estava lá o tempo todo; o PC de 1998 só não tinha orçamento pra desenhá-la.

Aumentar demais custa desempenho e pode expor flicker distante por causa da precisão do Z-buffer de 16 bits. Por isso o controle é configurável entre `1.0` e `3.0`, e o padrão não força a melhoria.

### 60 fps sem mexer na física

Esta parte me surpreendeu. A simulação roda em 25 Hz e existe um modo escondido de 50 Hz que muda o resultado da física. Alterar isso seria mudar o jogo.

No modo normal, uma thread de timer atualiza a simulação e o loop principal renderiza tão rápido quanto o `Flip` permite. O código calcula um alpha pelo tempo desde o último tick e interpola carro, câmera e objetos. Em gamescope sem vsync, medi cerca de 190 frames apresentados por segundo em 1080p. Em 4K, o renderer por software ficou perto de 60 fps.

Os 60 fps vêm desse pipeline original de renderização interpolada. Num display real, o jogo apresenta no refresh do monitor, limitado pelo vsync da camada que o hospeda. A física continua a mesma de 1998.

## Como instalar

Você precisa do **Colin McRae Rally de PC de 1998**, com instalação completa e patch europeu 1.5. Dentro da pasta devem existir `Rally.exe`, `Game`, `New_Fe` e `ini`.

Baixe o ZIP na [última release do launcher](https://github.com/akitaonrails/rea-colin-mcrae/releases/latest). Ele vem com `CMRLauncher.exe`, `cmrhooks.dll` e os auxiliares de Linux. Não vem com o jogo.

### Linux com Steam e Proton

1. Extraia o ZIP, por exemplo em `~/Games/cmr-launcher`.
2. No Steam, escolha **Games → Add a Non-Steam Game to My Library** e selecione `CMRLauncher.exe`.
3. Em **Properties → Compatibility**, force GE-Proton. Testei com GE-Proton 11.
4. Em **Launch options**, passe a pasta da sua instalação:

```text
%command% --game "Z:/home/voce/Games/Colin McRae Rally"
```

O caminho fica salvo depois da primeira execução. Também existe um script pra Wine com gamescope e uma interface em Quickshell, a que aparece no screenshot.

### Windows

Extraia o ZIP ao lado de `Rally.exe` e abra `CMRLauncher.exe`. Se preferir deixar o launcher em outro diretório:

```text
CMRLauncher.exe --game "C:\Games\Colin McRae Rally"
```

O código foi preparado pra Windows 10 e 11, mas **eu ainda não testei em Windows nativo**. Tudo que validei até agora foi em Arch Linux, usando Wine e Proton. Quem testar em Windows, outra distribuição, AMD, Intel, outros monitores e outros controles já ajuda bastante.

Ao encontrar um problema, abra uma [issue no GitHub](https://github.com/akitaonrails/rea-colin-mcrae/issues) com o `launcher.log`, hash do `Rally.exe`, sistema operacional, GPU, versão do Wine ou Proton e passos pra reproduzir. *"Não funcionou"* não dá pista suficiente pra corrigir compatibilidade.

## Menos de dois dias

A parte específica deste launcher saiu do primeiro commit de compatibilidade jogável ao vídeo acima em menos de 30 horas. Nesse intervalo eu troquei a estratégia de um port nativo gigantesco por uma camada pequena em volta do executável original, fiz engenharia reversa dos pontos necessários, implementei as correções, testei uma etapa inteira e empacotei a release.

Recomps completos continuam difíceis. Exigem meses ou anos, conhecimento da plataforma, comparação contra o original e uma quantidade enorme de validação. REA ajuda a chegar na evidência; Claude e Codex ajudam a escrever e testar; alguém ainda precisa decidir qual problema vale resolver e reconhecer quando a estratégia está errada.

> Código barato também barateia a decisão de jogar código fora.

Eu descartei uma reconstrução com cerca de 250 mil linhas porque ela não entregava o resultado que eu queria. A solução útil ficou muito menor: preservei o jogo original, substituí as bordas que envelheceram e acrescentei as melhorias que o hardware moderno permite.

Antigamente, fazer isso à mão seria tão demorado que eu provavelmente aceitaria os 800x600, o Xwayland preso e a ponte de teclado. Agora consegui devolver uma experiência moderna a um jogo fora de catálogo em menos de dois dias.

O ganho prático da engenharia reversa com IA está em tornar viável a correção daquelas incompatibilidades pequenas e cumulativas que deixavam software antigo preso ao computador de uma única pessoa. Pedir um PC port completo continua longe de ser suficiente.

O trabalho continua. Frame pacing e escolha de vsync, filtragem anisotrópica, mipmapping quando os dados permitirem, borderless com Alt-Tab seguro, rumble, remapeamento de botões e mais detalhes à distância já estão no plano da próxima rodada. O launcher de hoje é experimental; volte nas releases porque ainda quero tirar bastante coisa desse executável de 1998.
