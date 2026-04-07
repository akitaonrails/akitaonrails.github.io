---
title: "Começando com Blender"
date: '2017-06-21T17:32:00-03:00'
slug: comecando-com-blender
translationKey: starting-with-blender
aliases:
- /2017/06/21/starting-with-blender/
tags:
- off-topic
- blender
- traduzido
draft: false
---

O Blender é uma fera. Uma verdadeira maravilha do que o software open source pode alcançar — você deveria aplaudir de pé todos que ajudaram a construir algo que funciona tão bem quanto isso. Ele rivaliza com as opções comerciais mais caras do mercado, do Maya ao venerável Renderman da Pixar.

A comunidade do Blender é tão apaixonada e comprometida que frequentemente produz [curtas-metragens](http://archive.blender.org/features-gallery/movies/) de alta qualidade, com nível quase hollywoodiano, usando o próprio Blender — justamente para estressar a ferramenta, identificar gargalos e problemas de usabilidade num fluxo de trabalho real.

Este post é, principalmente, para o "eu do futuro" poder voltar a uma lista de recursos centralizada. Como modelagem 3D não é meu trabalho em tempo integral, vou ter longos intervalos entre as sessões com o Blender, e eu sei que vou me arrepender se não descarregar o que aprendi num post enquanto ainda está fresco :-)

### Primeiros Passos para Iniciantes

Antes de mais nada: se você está neste blog, provavelmente é programador. E deixa eu te dizer que o pessoal de gráficos tem uma visão de "usabilidade" bem diferente da nossa. A quantidade absurda de customizações, opções, atalhos e combinações rivaliza até com usuários de Vim e Emacs.

Ah, e a propósito: você vai precisar de um mouse com 3 botões de verdade. Touchpad não serve pra nada no Blender. O mouse do Mac é horrível no Blender. [Qualquer mouse barato de PC resolve.](http://www.dell.com/br/mouse) E, por padrão, o botão principal é o da direita, não o da esquerda como estamos acostumados! Mude isso nas [preferências do usuário](https://docs.blender.org/manual/en/dev/preferences/input.html) para selecionar com o botão esquerdo. Aí as coisas começam a fazer sentido. Enquanto estiver lá, habilite também a emulação do Numpad. Aliás, vale muito a pena ter um teclado com numpad ou até um numpad separado. Você pode usar a fileira de números do teclado normal, mas o Blender foi projetado tanto com um mouse de 3 botões invertido quanto

[![Preferências de Input](https://docs.blender.org/manual/en/dev/_images/preferences_input_tab.png)](https://docs.blender.org/manual/en/dev/preferences/input.html)

Se você nunca estudou Blender antes, não vai conseguir descobrir nada explorando a interface por conta própria. A UI é inútil até alguém te ensinar o básico. Há centenas de termos que você simplesmente não vai entender, como Meshes, Edges, Seams, Nodes, Viewport, Subsurface, Modifiers, etc.

A coisa mais importante que você PRECISA fazer antes de continuar é assistir essa série completa de 9 partes do Blender Guru, chamada [Blender Beginner Tutorial Series](https://www.youtube.com/watch?v=VT5oZndzj68&list=PLjEaoINr3zgHs8uzT3yqe4iHGfkCmMJ0P). Opcionalmente, você pode fazer depois, com calma, os [Intermediate Blender Tutorials](https://www.youtube.com/watch?v=Mwzz-Y6t-v8&list=PLjEaoINr3zgEgoyYWE0Yit-cVoZ60WGtt).

A série para iniciantes vai te ensinar o suficiente para você finalmente começar a se sentir confortável com a interface e as ferramentas. E não esqueça de imprimir e pendurar esse ["cheat sheet"](https://www.blenderguru.com/articles/free-blender-keyboard-shortcut-pdf) bem útil — você não vai acreditar como a vida fica mais fácil quando você incorpora os atalhos de teclado mais importantes.

### Configurações Padrão Melhores

Por razões históricas, algumas configurações padrão não são as ideais. O conhecimento na área de renderização 3D evolui muito rápido.

A primeira coisa a fazer: [trocar](https://wiki.blender.org/index.php/Doc:2.6/Tutorials/Rendering/Cycles) o motor de renderização padrão de Blender Render para o Cycles Raytracing Engine.

Depois, tratamento de cor. O sRGB EOTF padrão é basicamente errado. Você precisa baixar a configuração [filmic-blender](https://sobotka.github.io/filmic-blender/) do Sobotka. No Arch Linux, basta fazer:

```
pacaur -S filmic-blender-git
```

Criei um script em `~/bin/filmic-blender` com o seguinte:

```
env OCIO=/usr/share/blender/2.78/datafiles/filmic-blender/config.ocio blender
```

E sempre inicializo o Blender pelo terminal assim:

```
optirun ~/bin/filmic-blender
```

Isso faz duas coisas: primeiro, pré-configura o OpenColorIO para usar o substituto Filmic. Segundo, habilita a GPU externa do meu notebook para uso no Blender. Leia meu post ["Enabling Optimus NVIDIA GPU on the Dell XPS 15 with Linux, even on Battery"](http://www.akitaonrails.com/2017/03/14/enabling-optimus-nvidia-gpu-on-the-dell-xps-15-with-linux-even-on-battery) para mais detalhes. No Windows ou Mac isso não é necessário, mas você ainda vai precisar carregar a configuração filmic.

Na aba Scene, você deve reconfigurar o "Color Management" assim:

![Color Management](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/636/Screenshot_from_2017-06-21_16-31-05.png)

Em seguida, configure o Cycles. Se você está no Linux com o Optimus instalado corretamente como expliquei antes, a opção CUDA deve aparecer nas preferências do usuário:

[![Preferências do sistema](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/637/Screenshot_from_2017-06-21_16-43-29.png)](https://docs.blender.org/manual/en/dev/preferences/system.html)

Na aba Render, você deve ter algo assim:

![Configuração de Render](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/638/Screenshot_from_2017-06-21_16-45-32.png)

Na seção Dimensions, você vai ver que está configurado para Full HD (1920x1080 px) mas com apenas 50% (ou seja, vai renderizar metade do tamanho). Aumente para 100%. Se quiser um shot em 4K, ajuste as dimensões para 3840x2160 px. O 4K torna a renderização 4 vezes mais lenta que o 1080p, obviamente.

Na seção Performance há 2 campos para "Tile size". O Blender vai dividir sua imagem em tiles. Cada tile vai renderizar em paralelo num core de CPU ou GPU disponível. Meu notebook tem 8 cores de CPU. 64 é um bom tamanho porque vai renderizar 8 tiles de 64 pixels cada em paralelo. Quanto menos cores você tiver, maior deve ser o tile. Para minha GPU NVIDIA, só tenho 2 cores disponíveis (e não muita memória de vídeo!), então vale aumentar os dois campos para 512. Na GPU ela só vai renderizar 2 tiles por vez, então tiles maiores otimizam a renderização.

Como você provavelmente já adivinhou, o Blender Guru tem um tutorial muito útil: ["18 ways to speed up Cycles Rendering"](https://www.youtube.com/watch?v=8gSyEpt4-60&t=204s).

Isso cobre o básico das configurações padrão.

### Você Precisa Pensar como Fotógrafo!

Você vai querer assistir MUITOS tutoriais online, porque realmente não é óbvio como usar melhor as ferramentas. Outro canal que gosto bastante é o [BornCG](https://www.youtube.com/watch?v=lY6KPrc4uMw&list=PLda3VoSoc_TR7X7wfblBGiRz-bvhKpGkS) e o [CG Masters](https://www.youtube.com/channel/UCCxay0KiyLlawfgoZ2mVnNQ). Pegue alguns vídeos deles para ter uma visão mais aprofundada de ferramentas específicas, técnicas de modelagem e por aí vai.

E de verdade: você precisa praticar o máximo possível enquanto estuda. Uma área importante é a Fotografia. Isso é o que você vê quando seleciona a aba Camera:

[![Configurações de câmera](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/639/Screenshot_from_2017-06-21_16-55-09.png)](https://docs.blender.org/manual/en/dev/render/blender_render/camera/object_data.html)

Tem muita customização disponível aqui, mas, por exemplo: Focal length: 35.00. Isso é o que os fotógrafos conhecem como lente de 35mm. É uma boa escolha padrão. Você pode usar grande angular de 200mm ou 300mm também. Shots internos, em salas pequenas, podem usar 24mm ou até 18mm. O artigo ["Understanding Color Lenses"](http://www.cambridgeincolour.com/tutorials/camera-lenses.htm) cobre o básico.

Depois, você precisa entender "Profundidade de Campo" (Depth of Field). Isso pode ser feito nessa configuração antes de renderizar, ou simulado após a renderização (se você escolheu separar o render em camadas), no [Compositor](https://wiki.blender.org/index.php/Doc:2.6/Tutorials/Composite_Nodes/Setups/Depth_Of_Field).

Falando nisso, outra forma de controlar a Profundidade de Campo é reconfigurar o "f-stop", que é a medida de exposição, ou abertura. O padrão é "128.0", ou seja, "f/128". Como referência, a câmera do iPhone 7s tem abertura f/2.2. Novamente, vamos estudar mais sobre isso começando pelo artigo ["What's the Best F-Stop?"](https://www.bhphotovideo.com/explora/photography/tips-and-solutions/what%E2%80%99s-best-f-stop)

Tirar uma foto (ou renderizar um still, no nosso caso) é muito mais do que simplesmente apontar e clicar. Você também precisa se preocupar com técnicas adequadas de composição, como a [Regra dos Terços](http://www.photographymad.com/pages/view/rule-of-thirds), a [proporção áurea](http://www.makeuseof.com/tag/golden-ratio-photography/), e por aí vai. Você pode configurar isso no combo box "Composition Guides" mostrado acima.

![Composição com Proporção Áurea](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/641/3911f4657078a19b4f3677a304e7451d.jpg)

Vale muito a pena se aprofundar no campo da Fotografia para melhorar o resultado final dos renders. Sou um amador e é muito empolgante conseguir aplicar técnicas do mundo real na renderização 3D.

### Design de Materiais e Physically-Based Render (PBR)

O padrão ouro em modelagem e renderização 3D é certamente o [Disney/Pixar RenderMan](https://renderman.pixar.com/view/renderman). Todos os filmes premiados da Pixar foram feitos com ele.

Mas o Blender aprende rápido. Todo paper da Pixar eventualmente vira parte do próprio Blender. Por exemplo, o design de materiais é um aspecto que sempre foi bastante trabalhoso no Blender. Fiz alguns dos tutoriais eu mesmo, e criar materiais com as características corretas do mundo real — Fresnel adequado, dielétrico vs. metálico certo, etc. — era um desafio.

Se você assinou o canal do Blender Guru, assista os tutoriais ["How to Make Photorealistic PBR Materials - Part 1"](https://www.youtube.com/watch?v=V3wghbZ-Vh4&t=2668s) e ["Part 2"](https://www.youtube.com/watch?v=m1PkSViBi-M). E você vai acabar com essa configuração complicada de Nodes para materiais PBR:

![Materiais PBR - Node Editor](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/640/Screenshot_from_2017-06-21_17-25-46.png)

E o Blender Guru acabou de postar um novo vídeo apresentando uma funcionalidade nova para o próximo Blender 2.79 (ainda no 2.78 na época), a implementação do paper ["Physically-Based Shader at Disney"](https://disney-animation.s3.amazonaws.com/library/s2012_pbs_disney_brdf_notes_v2.pdf) como um novo shader nativo e otimizado chamado "Principled Shader". É literalmente o [Shader Definitivo](https://www.youtube.com/watch?v=4H5W6C_Mbck), pois torna a criação e personalização de materiais realistas **muito** mais fácil, além de ser compatível com Renderman e Substance.

### Conclusão

Ainda sou iniciante no Blender, tem uma estrada muito longa pela frente. Mas é um ambiente muito empolgante e estou aprendendo coisas novas e úteis o tempo todo. Todo mundo deveria experimentar!

Com o tempo, espero encontrar espaço para integrar o fluxo de trabalho do Blender com outras ferramentas como Unreal Engine ou Unity3D para criar coisas interativas também.

Esse post não é de forma alguma um tutorial completo ou referência definitiva. A ideia foi destacar algumas coisas que não são imediatamente óbvias quando você começa com o Blender e que podem te dar uma noção mais ampla do que ele é capaz de fazer.

Se quiser se aprofundar de verdade nas configurações, assista esse vídeo de setup do CG Master:

{{< youtube id="-_BZasG_UDA" >}}
