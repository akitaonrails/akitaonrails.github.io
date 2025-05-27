---
title: Entendendo o Básico de ComfyUI pra gerar imagens com I.A.
date: '2025-04-20T19:30:00-03:00'
slug: entendendo-o-basico-de-comfyui-pra-gerar-imagens-com-i-a
tags:
- comfyui
- unet
- stable diffusion
- flux
- latent
- diffusion models
- controlnet
- loras
draft: false
---

No [post anterior](https://www.akitaonrails.com/2025/04/20/gerando-imagens-com-i-a-ate-estilo-ghibli-com-docker-e-cuda) expliquei meu projetinho de como subir ComfyUI pré-configurado e pré-carregado automaticamente usando Docker Compose. Assumindo que você já tem tudo de pé, agora é entender essa desgraça do ComfyUI um pouco.

Eu também não sou nenhum especialista, mas achei legal explicar alguns conceitos que muitos ignoram.


### Modelos Pré-Treinados

Todo GPT da vida, ou Stable Diffusion ou outros carregam um banco de dados vetorial na memória da GPU, na VRAM, pra processar. São modelos GRANDES, chamados de 7B, 70B, 100B, etc. "B" de "Bilhões de Parâmetros". Parâmetros não tem definição usável fora da matemática, são simples números. Esses números representam "alguma coisa" dentro milhões de dimensões dentro desse arquivão.

Em um jeito BEM GROSSEIRO, eu penso como sendo artefatos de compressão. Você pega PETABYTES de livros, imagens, textos, posts, etc, quebra tudo em tokens e encontra "relacionamentos" de um token com vários tokens e vai "posicionando" no espaço, mas não em 3 dimensões, mas milhões de dimensões. Modelos de I.A. são "Vector Space Models" ou VSMs, mais ou menos como é o índice de um Elasticsearch se você já brincou com procura de texto com relevância, ou qualquer plugin de "Full Text Search" de um Postgres ou MS-SQL. São todos VSMs.

Eu penso assim: é como se o processo de treinamento - a parte SUPER CARA, que leva MESES - pegasse toda informação que é passada e compilasse um novo "dicionário" pra uma nova "língua". Agora, quando você "fala" com um GPT, primeiro ele precisa transformar seu texto da sua língua pra essa "língua interna" dele, isso é o que chamamos de um **"Embedding"**.

Qualquer dado pode ser transformado. Áudio pode ser convertido em texto e de texto em embeddings. Videos podem ser desmonstados em séries de imagens com informação temporal. Imagens podem ser desconstruídas em elementos como luminância, crominância, etc. No fim, tudo pode ser desconstruído em estruturas de dados, não tem mágica.

Modelos de Geração de Imagem são treinados diferente. Tem diversos focos, foco em nitidez de rostos, foco em exatidão de poses, foco em estilos diferentes como cartoon ou pintura, foco em categorias como animais ou objetos. Por isso tem dezenas de modelos por aí e diversos "loras".

Pra gerar uma imagem a partir de um prompt, primeiro precisa decodificar seu prompt num embedding, pra isso servem coisas como um **TEXT ENCODER** no ComfyUI.

No caso específico de I.A. pra imagens, eu entendo que se usa um tal de modelo de "DIFUSÃO" tanto pra desestruturar a imagem original, quanto pra reconstruir uma nova imagem. Não é intuitivo, mas a reconstrução não começa numa tela branca, como seria pra um desenhista humano. Ele começa com uma imagem com barulho aleatório "noise" tipo isso aqui:

![noise](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/rcvhb8m0boe3jetpy72kww2wmucw?response-content-disposition=attachment%3B%20filename%3D%22image-after-gaussian-noise-2.webp%22%3B%20filename%2A%3DUTF-8%27%27image-after-gaussian-noise-2.webp&response-content-type=image%2Fwebp&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001044Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=86bb01f3465f62d210bebb6f8b94c55e72d552194fed1b9ceb2de8d5e5020094)

O modelo começa desse barulho e via um tal processo de DIFUSÃO começa a redesenhar a imagem de trás pra frente, até sair do caos e chegar numa imagem.

O que eu "ACHO", "CHUTO" que aconteça - sem ter lido paper nenhum, preguiça mesmo - é que tentamos influenciar esse barulho inicial. Por exemplo, extraindo funcionalidades da imagem como um mapa de profundidade, que se parece com isso:

![Mapa de Profundidade](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/qj0ba39q5xbs7xyei52h4qmmpr2d?response-content-disposition=inline%3B%20filename%3D%22ComfyUI_temp_tbpnv_00002_.png%22%3B%20filename%2A%3DUTF-8%27%27ComfyUI_temp_tbpnv_00002_.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001045Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=c1216cd31692350fd74556a0e055502b9d45dc959efe7866e68ddb2a8ded4873)

A foto original era assim:

![Original](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/6zionu0khn01gpudd9z0ws2mm8zx?response-content-disposition=inline%3B%20filename%3D%2268685020_1288138464699355_383731310440480768_o%25281%2529.jpg%22%3B%20filename%2A%3DUTF-8%27%2768685020_1288138464699355_383731310440480768_o%25281%2529.jpg&response-content-type=image%2Fjpeg&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001047Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=9ee26a5b42d88d28e19081f8f39a34fac228ee89b8dffe4054fffa183325caa9).jpg)

Extrair um Mapa de Profundidade é um **ALGORITMO** e não "I.A.". Qualquer Photoshop, Premiere da vida conseguem fazer isso com uma mão nas costas. Mas é pra explicar que tem muito mais informação numa imagem que só olhando você - que não é treinado - não sabe que existe. 

Outro tipo de ALGORITMO bem conhecido é o **Canny Edge Detection** que faz um mapa de bordas, pra ficar mais fácil de saber onde alguma coisa começa e onde termina na imagem:

![Canny](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/std6jaroftohqjlc22mii9m7oso6?response-content-disposition=inline%3B%20filename%3D%22ComfyUI_temp_pyyqp_00002_.png%22%3B%20filename%2A%3DUTF-8%27%27ComfyUI_temp_pyyqp_00002_.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001048Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=2da59070f5ddd2cc985ffbd5ce76e3a7a6aaee72c80a5a24536a2f742a5476b9)

Então é mais ou menos assim:

* assim como um texto é "convertido" numa **Embedding**, vetores que capturam a "essência" do significado do texto, dependente da VSM do modelo pré-treinado, uma imagem é "convertida" internamente num **LATENT**, que por ser imagem é um "espaço" (por isso se fala em Latent Space). Latents não temos como "visualizar", porque é uma representação interna que depende da U-NET, o modelo pré-treinado, a rede neural que aprende a "tirar barulho" (denoise) o Latent.
* Uma U-NET de imagens é grosseiramente similar a um modelo de texto como GPT ou LLaMA, o modelo pré-treinado, read-only, que vai ser usado pra produzir o resultado final.
* Uma resposta de GPT é uma continuação do contexto da conversa anterior. Ele não está "respondendo" você diretamente, está só "continuando" o texto da conversa e por acaso, pelo treinamento, o resultado "se parece" com uma resposta. No caso de imagens, começamos com uma imagem aleatoriamente barulhenta (noise) e num processo de tirar e adicionar barulho, ele vai "reorganizando" o Latent numa imagem que conseguimos reconhecer.
* Existe um "Scheduler" que decide quanto barulho é adicionado ou removido a cada passo no tempo. E existe o conceito de **DIFFUSION MODEL** que é mais ou menos o "pipeline" de processamento.
* Podemos controlar o processo adicionando um prompt de texto, que é decodificado numa "embedding" usando um **Text Decoder** normalmente tem nomes como "CLIP" ou propriamente um Transformer (como LLava). Esses embeddings vão pra U-NET usando camadas de atenção cruzada, direcionando o "denoising" em direção ao significado do prompt.
* Além disso temos **CONTROLNET** que é uma segunda rede paralela, que adapta o processo pra condições extras. É uma cópia da arquitetura de U-NET (com pesos congelados) que recebem inputs extras, como o Canny Edges, ou Depth Maps, esqueletos de pose (via OpenPose), etc e aprende pequenos ajustes pra **INJETAR** nos mapas principais da U-NET.
* Durante o processo de denoising, ativações da ControlNet são mescladas às da U-NET, forçando o processo a respeitar as condições que passamos.

Então a U-NET é o "gerador", o Diffusion Scheduler orquestra o processo, text encoder e contronet, ambos influenciam a U-NET, e um VAE é usado no final pra converter um espaço latente em uma imagem propriamente dita que nós, humanos, conseguimos enxergar.

BEM, BEM A GROSSO MODO. É mais ou menos como eu entendo o processo. E eu entendo que o ComfyUI expõe vários desses passos na forma de "NODES PROGRAMÁVEIS", que podemos parametrizar e ajustar pra influenciar como queremos que a imagem final saia.

Além de parâmetros numéricos, esses Nodes também nos deixam escolher quais arquivos de modelos pré-treinados pra cada etapa queremos usar. É tudo um VSM binário, mas pra utilidades diferentes, por isso muitos tem a mesma extensão como eu expliquei, mas ficam em sub-diretórios diferentes. Pra cada Node conseguir achar só o que lhe interessa.

Pegando o exemplo da minha foto, não é isso mas só pra ilustrar, me ajuda a pensar que aqueles mapas que eu mostrei influenciam a imagem "noisy" numa direção não-aleatória, como este que eu peguei numa etapa intermediária do workflow que estou rodando:

![noise](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/yy0yrlrcel015bucfr3z60izt42p?response-content-disposition=inline%3B%20filename%3D%22ComfyUI_temp_tcpal_00002_.png%22%3B%20filename%2A%3DUTF-8%27%27ComfyUI_temp_tcpal_00002_.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001050Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=7bc53158769314ea54bc096c2e91e12920d0003d95c7d1fe243aa1f78bff79a8)

Se forçar seus olhos, consegue ver influência das imagens anteriores, e o modelo de Difusão vai fazendo o "denoising", sendo "atrapalhado" pela ControlNet. Como se você estivesse desenhando e tivesse uma pessoa do lado que de vez em quando apaga o que você fez, ou desenha por cima, e você vai se adaptando. Então no final vira um trabalho "colaborativo" entre os dois. Se fosse só a U-NET, ele ia gerar uma nova imagem bem diferente da original, mas a ControlNet é o "cliente" que fica toda hora de buzinando na orelha "não é assim que eu quero, muda", até chegar num resultado aceitável.

Além disso, uma U-NET não é boa pra gerar imagens de altíssima resolução. O ideal é gerar imagens pequenas, 512 pixels, 1024 pixels, mas nada maior. Mas isso seria inútil pra usar profissionalmente. Pra isso servem **UPSCALE MODELS**. Se leu meu artigo de ontem sobre [Video2K](https://www.akitaonrails.com/2025/04/19/aumentando-resolucao-de-anime-velho-pra-4k-com-i-a) eu explico que escolho um modelo lá que é bom pra coerência temporal de video. Mas tinha outros modelos que são melhores pra "IMAGENS ESTÁTICAS", ou fotos. E podemos usar eles no ComfyUI.

Depois que a nova imagem pequena é gerada pela U-NET, depois podemos usar ela como entrada pra um segundo passo de "UPSCALE" usando um modelo como RealERSGAN, e sair de uma imagem de 1024 pixels pra 2160 pixels, essencialmente 4K. É diferente de aumentar a imagem num Photoshop, onde fica tudo "soft" borrado. Como também é outro modelo de I.A. ele é treinado pra "redesenhar" em mais resolução. E podemos adicionar isso no workflow do ComfyUI também.

Mais do que isso, o ComfyUI também suporta Nodes com modelos como o HunyuanVideo da Tencent, que apresentei no outro artigo de ontem, sobre [FramePack](https://www.akitaonrails.com/2025/04/19/gerando-videos-de-ate-2-min-a-partir-de-uma-foto-com-i-a). Na verdade, podemos fazer a mesma coisa que o FramePack faz mas a partir de um workflow de ComfyUI: gerar um video a partir de uma imagem, usando o mesmo modelo. O FramePack é infinitamente mais fácil de usar, mas o ComfyUI é a faca suíça de I.A.: ela faz **TUDO**, por isso também é infinitamente mais complicada e precisa se dedicar bastante pra aprender a usar.

Entendendo até aqui, olhem o workflow que eu usei (está com zoom out, dá pra aumentar o zoom dinamicamente):

![workflow](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/rrtdjr0sq5vsl3xnm08w3sz459w8?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-04-20%2018-43-50.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-04-20%252018-43-50.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001052Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=4db526f7aff60e20d4f5cc5d7ce2fc8225d6d1125b4be8ca7d04ae617b0f453b)

Dá pra ver esses passos intermediários usando Nodes de **PREVIEW** então é mais ou menos assim que podemos usar o ComfyUI pra fazer muita coisa avançada. Como falei, eu mesmo ainda não comecei nem a arranhar a superfície.

Vamos resumir alguns dos conceitos usados no ComfyUI agora:

### **1. Checkpoints (Modelos Base)**

**O que são**:  
São os modelos principais do Stable Diffusion (ex: SD 1.5, SDXL, Flux). Contêm toda a arquitetura do modelo:

- Text Encoder (CLIP)
    
- Modelo de Difusão (U-Net)
    
- VAE (Decoder de imagens)
    

**Para que servem**:  
Gerar imagens a partir do zero. Cada checkpoint tem um "estilo" diferente (realista, anime, etc).

**Exemplos**:  
`flux.safetensors`, `realisticVisionV60.safetensors`, `anythingV5.safetensors`

### **2. VAE (Autoencoders Variacionais)**

**O que são**:  
Componente que decodifica as imagens do espaço latente (formato que o modelo entende) para pixels visíveis.

**Para que servem**:

- Melhorar detalhes e cores
    
- Alguns checkpoints requerem VAEs específicos
    

**Exemplos**:  
`vae-ft-mse-840000.safetensors`, `animevae.pt`

### **3. Text Encoders (Codificadores de Texto)**

**O que são**:  
Modelos que convertem seu prompt de texto em representações numéricas que a IA entende.

**Tipos comuns**:

- **CLIP**: Padrão para a maioria dos modelos
    
- **OpenCLIP**: Versão alternativa usada no SDXL
    
- **T5**: Modelos maiores para prompts complexos
    

**Exemplos**:  
`clip_vision.safetensors`, `openclip.safetensors`

### **4. CLIP Vision**

**O que são**:  
Modelos especializados em análise visual (ao contrário do CLIP normal que é texto→imagem).

**Para que servem**:

- Criar descrições de imagens existentes
    
- Ferramentas como "Image Prompt" (usam a imagem como input)
    

**Exemplo**:  
`clip_vision_g.safetensors`


### **5. Diffusion Models (Modelos de Difusão)**

**O que são**:  
Parte específica da arquitetura (U-Net) responsável pelo processo de difusão (adição/remoção de "ruído").

**Para que servem**:

- Treinamento de LoRAs
    
- Workflows avançados de reutilização
    

**Exemplo**:  
`unet.safetensors`


### **6. LoRAs (Adaptadores Leves)**

**O que são**:  
Pequenos arquivos que modificam o comportamento do checkpoint principal sem substituí-lo.

**Para que servem**:

- Adicionar estilos específicos (ex: anime)
    
- Criar personagens consistentes
    
- Ajustar proporções corporais
    

**Exemplo**:  
`epiNoiseOffset.safetensors`, `add_detail.safetensors`


### **7. ControlNet**

**O que são**:  
Modelos que impõem controle sobre a composição da imagem (poses, profundidade, bordas).

**Tipos comuns**:

- OpenPose (poses humanas)
    
- Canny (bordas)
    
- Depth (profundidade)
    

**Exemplo**:  
`control_v11p_sd15_openpose.safetensors`

### **8. Upscale Models (Modelos de Upscaling)**

**O que são**:  
Modelos para aumentar resolução e detalhes de imagens geradas.

**Tipos**:

- **ESRGAN**: Para detalhes realistas
    
- **Anime6B**: Especializado em arte anime
    

**Exemplo**:  
`4x_NMKD-Superscale-SP_178000_G.pth`


### **9. Embeddings (Textual Inversions)**

**O que são**:  
Pequenos arquivos que adicionam conceitos novos ao vocabulário do modelo.

**Para que servem**:

- Estilos artísticos específicos
    
- Objetos personalizados
    
- Correções de artefatos
    

**Exemplo**:  
`bad_prompt.pt`, `easynegative.safetensors`

### **10. Style Models**

**O que são:**  
Modelos especializados em aplicar estilos visuais ou “filmes” de arte sobre a imagem gerada, sem alterar de fato a estrutura básica do conteúdo.

**Para que servem:**

- **Colorização temática** (ex: paleta de aquarela, sépia, croma‑key)
    
- **Simular técnicas artísticas** (óleo, guache, traço de mangá)
    
- **Unificar estética** em séries de imagens (mesmo “clima” de cor e luz)
    

**Exemplo de arquivos:**

- `flux1-redux-dev.safetensors` (estilo “Flux Redux”)
    
- `watercolor_v2.safetensors` (pinceladas de aquarela)
    
- `film_grain_vintage.safetensors`


### **11. SAMs (Segment Anything Models)**

**O que são:**  
Redes de segmentação gerais capazes de isolar objetos ou regiões de interesse em uma imagem, produzindo máscaras binárias ou ponderadas.

**Para que servem:**

- **Criar máscaras de objetos/pessoas** para aplicação seletiva de filtros ou composições
    
- **Guiar ControlNets** (ex: aplicar difusão apenas dentro ou fora de uma região)
    
- **Pré‑processar referências** (recortar fundo, separar camadas)
    

**Exemplo de arquivo:**

- `sam_vit_b_01ec64.pth` (SAM ViT‑B, modelo base de segmentação)
### Resumo Visual

```
models/
├── checkpoints/        ➔ Modelos principais (Stable Diffusion)  
│     └── *.safetensors, *.ckpt  
├── diffusion_models/   ➔ Modelos de difusão alternativos  
│     └── *.safetensors, *.gguf  
├── loras/              ➔ Adaptadores de estilo (LoRAs)  
│     └── *.safetensors  
├── controlnet/         ➔ Controles de composição (ControlNets)  
│     └── *.pth, *.safetensors  
├── vae/                ➔ Decodificadores / Encoders do VAE  
│     └── *.pt, *.safetensors  
├── clip/               ➔ Encoders CLIP de texto  
│     └── *.safetensors, *.pt  
├── clip_vision/        ➔ Encoders CLIP de visão  
│     └── *.safetensors  
├── text_encoders/      ➔ Encoders de texto avançados  
│     └── *.safetensors, *.bin  
├── upscale_models/     ➔ Modelos de super‑resolução  
│     └── *.pth  
├── sams/               ➔ Modelos Segment Anything (SAM)  
│     └── *.pth, *.onnx  
├── style_models/       ➔ Modelos de estilo visual  
│     └── *.safetensors  
└── embeddings/         ➔ Embeddings / conceitos personalizados  
      └── *.pt, *.safetensors  

```

Tem que baixar as coisas certas nos lugares certos. E pra dificultar, como já falei, os arquivos costumam ter a mesma extensão. Então é muito fácil confundir e jogar um text encoder no diretório de clip ou vice-versa. De novo, por isso encorajo que atualize o arquivo ["models.conf"](https://github.com/akitaonrails/ComfyUI-Docker-CUDA-preloaded/blob/master/models.conf) e coloque as URLs certas nas listas certas, assim fica bem mais organizado e o meu Docker vai puxar as coisas pros lugares certos quando inicializar.

Ainda assim pode ter algumas outras dúvidas que eu também tive no começo. Por exemplo **"Por que a U-NET é chamada de Checkpoint?"**
### **Checkpoints ≈ Sistema Operacional Completo**

- **Semelhança**: Assim como um commit no Git captura um estado específico do código, um checkpoint é um "snapshot" completo de um modelo treinado em um estágio específico.
    
- **Diferença**: Checkpoints são **autocontidos** (não são "diferenças" como commits), cada um é um modelo completo que pode funcionar independentemente.
    
- **Melhor Metáfora**: Pense em checkpoints como diferentes versões do Windows (XP, 7, 10) - cada um é um sistema operacional completo, não incremental.

Então checkpoints meio que se assemelham, em conceito, a um "git commit" - se você for desenvolvedor. Ou snapshots de BTRFS ou ZFS - se você for de infra/devops.

### **LoRAs ≈ Plugins/Extensions**

- **Semelhança**: Assim como um PR adiciona funcionalidades a um código base, um LoRA modifica o comportamento do modelo base.
    
- **Diferença**: LoRAs não são "merged" no checkpoint original, mas sim **aplicados dinamicamente** durante a inferência.
    
- **Melhor Metáfora**: São como extensões do Chrome (ex: AdBlock) - adicionam comportamentos específicos sem modificar o navegador em si.

Pense assim: um modelo tem Checkpoints, como se fossem commits, assim dá pra "continuar" o treino por cima se precisar. Ao mesmo tempo, não precisamos mexer no modelo principal, podemos criar camadas separadas, as chamadas LoRas. Por exemplo, digamos que um modelo esteja com dificuldades de gerar o seu rosto, não importe que prompt use ou que Nodes configure.

Em vez disso podemos usar o "dicionário" do modelo pré-treinado, como Flux ou SDXL e fazer um treinamento com nossas fotos pessoais e gerar um LoRa específico meu. Então podemos adicionar um Node de LoRa no workflow e isso vai resultar em imagens muito melhores com seu rosto em particular.

Existem comunidades online inteiras dedicadas a isso. Um exemplo. No site [Civit A.I.](https://civitai.com/) vamos encontrar diversos modelos baseados em modelos pré-existentes, como este [Mistoon](https://civitai.com/models/24149/mistoonanime) que é baseado no SDXL. 

[![Mistoon Civit.ai](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/a4s6zs7oq6rtwto79lqk5itgd4or?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-04-20%2018-57-16.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-04-20%252018-57-16.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001053Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=36531f67189e7367704b0cd8c92f4f4a7625265af57427df7d72bd78800630e5)](https://civitai.com/models/24149/mistoonanime)

É um checkpoint. Podemos nos cadastrar no site e e baixar o arquivo `mistoonAnime_v10Noobai.safetensor` e colocar no diretório `models/checkpoints`.

![Mistoon Checkpoint Node](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/17z9fbwbzkg5kwoxzrcivpwwd74c?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-04-20%2018-55-16.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-04-20%252018-55-16.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001055Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=f65d9998c9d4bc43da9cdd04ce4f4ad7aa22ed76039c84aba67a37f08fbc3170)

Agora, em todo workflow que tiver o Node "Load Checkpoint" temos a opção de escolher esse modelo. Mas digamos que esse modelo não esteja conseguindo gerar uma personagem com uniforme colegial como em vários animes. Vasculhando o site, encontramos esta **LoRa**:

[![Mistoon LoRa](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/xlvhozw5u90xx9130a1kin5dl0da?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-04-20%2018-56-50.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-04-20%252018-56-50.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001056Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=b2f10a77d0386fa5f53a1ca3cf87b4f6c40e2a145a4fc57af83b5f914a62ad33)](https://civitai.com/models/115968/mistoonanime-school-uniform)
O modelo Mistoon é grande, uns 6.6GB mas essa LoRa - chamada `Mistoon_Anime\ school\ uniform.safetensor` que devemos mover pra `models/loras` tem menos de 290 MB, é muito menor porque é um treinamento específico só em imagens de uniformes colegiais.

Agora podemos ligar o Node de "Load Checkpoint" a este outro Node de "Load LoRa" e escolher essa LoRa que sabemos que é compatível:

![LoRa Node](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/8ahr2bgdxe5jg3xg4y2wcie3qzvs?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-04-20%2019-00-10.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-04-20%252019-00-10.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001103Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=a439e9e26fa4247bce547f12752696cc727ccd937b7d48ad8ac15a81b42ed918)

LoRas tem que ser escolhidas pra usar com os modelos em que elas foram baseadas. Como falei antes, pense no modelo como uma "língua", se fizermos um LoRa em alemão, não adianta misturar com um modelo chinês, a grosso modo. Mas essa é uma forma de fazer fine-tuning pro modelo que você gosta entregar resultados que nenhum outro consegue.

Um problema que eu tenho com o site Civit A.I. é que só dá pra fazer download quando está logado no site. Por isso não coloquei nenhum modelo ou lora deles no meu script de instalação automática. Infelizmente no caso deles precisa manualmente baixar os arquivos e mover pros diretórios certos, anotar em algum lugar, pra em outra máquina baixar e mover tudo de novo. É um saco que eu ainda não parei pra resolver. Se alguém quiser contribuir uma solução pra isso (sem expor cookies de login de ninguém, mandem Pull Request).

### Um Exemplo Real

Seu dia a dia com Comfy, sendo um novato como eu vai ser mais ou menos assim: começa indo no Google e procurando "best workflow image to anime ComfyUI". Primeiros links costumam ser alguma thread de Reddit:

![Reddit](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/zhnvm94r6ze0279obqq9k0wd6t9c?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-04-20%2019-09-26.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-04-20%252019-09-26.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001104Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=464dfb7454fcbdb825fabbf3232211858590be180b7c90dc961d121ef506a73b)

Sub-Reddits como [r/comfyui](https://www.reddit.com/r/comfyui) ou [r/StableDiffusion](https://www.reddit.com/r/StableDiffusion) costumam ter novidades e workflows como esse. Daí vamos direto pros primeiros comentários:

![Reddit Comentários Links](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/n3y2qd1vxw4uldxlrs5bjsewt9vn?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-04-20%2019-11-27.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-04-20%252019-11-27.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001105Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=985fee0f09a8c3091523684aa72eff0e4ea5600f5ede8960aa3d60a0ced75afb)

Ou isso, ou abrimos o workflow direto no ComfyUI e vasculhamos os Nodes, um a um:

![Nodes Check](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/b6hu6k4ygjpjdcq0chzv6mt1kx9w?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-04-20%2019-12-35.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-04-20%252019-12-35.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001107Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=08c0debbecbe9d9c473d05cc8ba37385f9a473386f227072ffac566c444ecb96)

Já temos talvez um problema: o Node veio pré-configurado pra carregar um LoRa chamado "SDXL_aidma-niji_jini.safetensors" mas o link no comentário do Reddit baixa um "SDXL_Niji_V6_DLC_LoRa_V4.safetensors". Procurando especificamente pelo anterior no Google, eu não acho. Mas parece "seguro" usar esse outro, pelo menos os nomes são muito parecidos, ambos são derivados de SDXL então teoricamente são compatíveis pelo menos. Esta á a página desse modelo no Civit A.I., então tem que baixar manualmente e mandar pro diretório `models/loras` a mesma coisa pro Checkpoint AniToon no Node acima. Baixa manualmente e move pra `models/checkpoints`.

[![LoRa Niji](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/m8u6e9hc0vyrd41pdru0c26akolr?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-04-20%2019-15-25.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-04-20%252019-15-25.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001108Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=a609c0ff5475ab5eb6fac12724b484bb4758167dd078a979c4fceca24c11d606)](https://civitai.com/models/541460/sdxlnijiv6dlclora)

Note que nessa página ele explica que esse LoRa foi feito pra funcionar com o modelo SDXL_Niji_V6 e não com o AniToon como o Workflow que baixei sugere no Node de Load Checkpoint. Vale testar com ambos. De qualquer forma, já que estamos no site, vamos baixar o modelo sugerido também:

[![SDXL Niji](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/zrkk8wr9v1z24s5f5fgyv01uui4g?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-04-20%2019-17-02.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-04-20%252019-17-02.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001110Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=beb8206838ed01f99c70ae615543a6b9eced4534d41f4b941cb1e976a3c64960)](https://civitai.com/models/120765)

Arquivo `sdxlNijiSeven_sdxlNijiSeven.safetensors` de 6.5GB, move pra `models/checkpoints`, tão entendendo o processo? Baixa, move pro lugar certo, recarrega o workflow no navegador e agora aparece, selecionamos:

Aliás, acho que é intuitivo mas pra quem não entendeu se abriu a interface do ComfyUI:

* botão esquerdo do mouse seleciona Nodes
* botão do meio arrasta a tela
* scroll faz zoom na interface

Agora sim, vamos escolher esses dois pra testar:

![Nodes Niji](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/m7bzo57hfez23vazar5ct4j5kndq?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-04-20%2019-20-35.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-04-20%252019-20-35.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001117Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=7daa41726469f0b2f11f6a9ce7addfff8a771e3e28c8babf690928c1e0237a66)

Aproveitando essa mesma imagem, note no canto esquerdo um Node de Florence2 que é uma LLM da Microsoft (e meu script de Docker já instala pra você). Não dá pra mostrar todos os Nodes relacionados mas estes são os principais de pra que isso serve:

![Florence](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/8pjx9pr8x0jsmz7bhouz5zcft1zt?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-04-20%2019-22-49.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-04-20%252019-22-49.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001118Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=9b997cce2b5d131f1978f7e727a698d1965747144f299bb7b8d8e423d12f504f)

O ideal em geração de imagem é fazer o prompt mais longo e bem detalhado sobre a imagem original que você conseguir, mas a maioria das pessoas só escreve alguma porcaria como "pessoa sorrindo de pé" e acha que é suficiente. O modelo Florence2 é feito pra ler uma imagem e descrever ela em texto.

Agora tem outro detalhe: muitos checkpoints ou Loras são treinados com alguma palavra-chave de ativação. Assim ela só influencia se você digitar essas palavras no seu prompt. Então esse workflow não precisa digitar prompt manualmente, o Florence2 vai fazer isso e toda vez o texto dele começa como "The image ... bla bla bla", daí temos um Node de "Text Find and Replace" que troca esse "The Image" pelas palavras chaves do Anitoon ou Niji: "aidma-niji, niji". 

Essas são as palavras certas? **EU NÃO SEI** kkkkk 

O workflow já trouxe essas palavras, mas nas páginas do Civit A.I. - onde deveria estar documentado, não está!! Então estamos realmente **CHUTANDO** que deve ser "niji" já que é o nome do modelo e do lora. Preste atenção na palavra-chave, é importante, senão você adiciona o lora e nada acontece de diferente e é porque faltou isso no prompt!!

![ControlNet](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/4i1n0fc3uvvy85nr17x6imee33bh?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-04-20%2019-29-11.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-04-20%252019-29-11.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001119Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=b1e368d034e95953b93d4f34f01f23e08993c92b85584c5956afaf78fbad9d33)

Tem mais, tem que checar se os Nodes de coisas como VAE, ControlNet, Canny e tudo mais estão populados com arquivos que temos. Normalmente se usa a mesma meia dúzia e eu já pré-instalei no Docker os principais. Na imagem, veja que ControlNet é o `contronet-union-sdxl-1.0-promax.safetensors`, compatível com SDXL e estamos usando Niji que é feito em cima de SDXL. Vamos chutando assim.

Também notem que ele usa Zoe Depth Map pra tirar o Mapa de Profundidade e Canny pra tirar o Mapa de Bordas como no outro workflow. Dá pra configurar, nesse workflow note que o Mapa de Bordas pegou alguns artefatos esquisitos no fundo, dá pra ajustar pra tirar isso. Por isso que no exemplo anterior também a imagem final apareceu uma janela, o modelo achou que era uma janela! Mas por enquanto deixa assim mesmo.

Agora podemos rodar:

![Run Comfy](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/29nzuo5t1nr6mn4wss0t77at94no?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-04-20%2019-32-40.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-04-20%252019-32-40.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001121Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=e911ab57c89283373bccfe3a856f163774e8f267a209ffa65bdec3e73c6d1b9e)

Tem um botão enorme "RUN" em azul lá embaixo. Se estiver tudo configurado certo, você vai ver que um trabalho foi colocado na fila. A interface é inteligente o suficiente pra deixar você trabalhar em outros workflow e só ir enfileirando trabalhos enquanto a GPU sua processando. Não precisa ficar esperando, só deixar vários enfileirados e ir dormir.

Ao rodar, na interface os Nodes que estão processando neste momento vão ficar com uma borda verde, o que é bom pra você saber em que etapa do processo ele está. E se algum Node tiver erro - porque faltou arquivo, por exemplo - ele vai ficar com borda vermelha, daí precisa corrigir e rodar de novo.

E no final, eis um dos resultados:

![Resultado Niji](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/7mbzamhj8c5sc2fesp8kkz6cvjhu?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-04-20%2019-35-11.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-04-20%252019-35-11.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001123Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=740f07cd32443c6bcb91aefc4627eb641610f0a967968fa400c84b73aa880b81)

Note como os mapas da controlnet garantiram a pose correta. O modelo deduziu aqueles artefatos de fundo do mapa de borda como iluminação de alguma janela, mas na foto original vemos que é tipo o tijolo de concreto da parede kkkk mas é isso, sem saber, ele chuta. E se rodar várias vezes, sempre vai dar um resultado bem diferente. Olha outro: 

![Niji 2](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/xbxu131ivlqu4endtdf6j5ayxzxt?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-04-20%2019-37-04.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-04-20%252019-37-04.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001130Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=cdef824eedb5bc9d5ec1fafff5a18e840e51d0e11f1a5b47445839ebcee14299)

Nada a ver kkkk Mas podemos trocar o modelo SDXL-Niji pelo Anitoon. Vamos ver um dos resultados:

![Anitoon](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/w7fsjrui29pbp8e98ka4ubuvtl6f?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-04-20%2019-38-03.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-04-20%252019-38-03.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001132Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=ae266656228c27ba8b073bc5264a55d204df68dd9f169c82f25573d59015311a)

Trocando pro modelo waiNSFIllustrious:

![waiNSFIllustrious](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2un0xtv7g210xrqc74nbceiwg7t4?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-04-20%2019-39-05.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-04-20%252019-39-05.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001134Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=63243acd770766f533aa15c67276c1b430dae2920b36be933170c6db1b7ebf3e)

Esse ficou ainda mais nada a ver. Alguma coisa nos mapas está fazendo o modelo assumir que eu tenho cabelo cacheado, sei lá porque. Mas é isso: tem que ajustar os parâmetros. O resultado do workflow que mostrei no começo do artigo deu um resultado melhor, usando os mesmos modelos. 

De todos os Nodes, um dos mais importante é o "motor" do processo, o **KSampler**:

![KSampler](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/n6875915bhqq39vxw0kfripyyj3d?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-04-20%2019-40-58.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-04-20%252019-40-58.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001136Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=2bdf328c32adb3bdc3e55d06403d346c2f279e3a56ccad1e858eabc989a5d450)


Esse é o cara que comanda o show. Damos pra ele o modelo, o prompt, saídas de control-net e ele quem vai iterativamente (steps) fazer o "desnoise" do Latente. Note que sempre existe um fator aleatório ("seed"), quantidade de passos (25 a 50 é a média), "cfg" (classifier-free guidance) ou "guidance_scale", onde valores maiores puxam a imagem mais seu prompt positivo. Denoise é quando de noise o scheduler aplica (1.0 é noise completo, abaixo de 1.0 pode produzir resultados mais "artísticos", tem que testar).

Sampler Name é um saco porque precisaria entender a matemática por trás, mas são os algoritmos de steps, por exemplo `euler`, `ddim`, `plms` e cada um tem um trade-off entre velocidade e fidelidade. Na prática: teste um a um e veja os resultados. Scheduler tem `normal`, `klms`, `dpmsolver`. Mesma coisa: teste um a um. 

Como podem ver, tem BASTANTE parâmetros que dá pra brincar. Mas o fluxo principal é mais ou menos esse. Daí tem que ir aprendendo Node a Node o que cada um pode fazer e baixar bastante workflow pré-pronto pra ver como o pessoal tem solucionado diversos problema, quais os modelos e loras mais populares pra cada tipo de aplicação. Enfim, o Reddit é seu amigo. Espero que tenha dado pra dar um Norte, eu também ainda estou aprendendo.
