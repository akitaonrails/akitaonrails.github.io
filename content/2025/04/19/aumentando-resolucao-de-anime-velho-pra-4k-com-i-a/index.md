---
title: Aumentando Resolução de Anime velho pra 4K com I.A.
date: '2025-04-19T15:30:00-03:00'
slug: aumentando-resolucao-de-anime-velho-pra-4k-com-i-a
tags:
- ersgan
- docker
- video2k
draft: false
---

Mais de um ano atrás eu estava brincando com ErsGAN, redes adversariais generativas pra tarefa de fazer "upscaling" (aumentar resolução) de arquivos de animes velhos que eu tenho.

Pra quem coleciona, o problema é que muito anime dos anos 90 pra trás nunca saíram e nem nunca vão sair em Blu-Ray (1080p) nem UHD (4K). Só os mais famosos recebem tratamento de "remaster" (pegar as fitas master originais e recapturar em mais resolução). Então muito anime velho está preso na era de DVD (480p) ou VHS (480i).


Nem todo anime velho dá pra aumentar resolução, pode ficar "lavado" demais. Quem baixa torrent já deve ter visto upscalings mal feitos. Mas eu queria poder testar isso eu mesmo, na minha máquina local, com meus arquivos velhos. Eis um pequeno clip de exemplo:

<div class="video-container">
    <video controls>
        <source src="https://akitaonrails-videos.s3.us-east-2.amazonaws.com/kenshin_old_clip1.mp4">
        Your browser does not support the video tag. [Direct Link](https://akitaonrails-videos.s3.us-east-2.amazonaws.com/kenshin_old_clip1.mp4)
    </video>
</div>


É um pedaço do 1o episódio do lendário Rurouni Kenshin de 1996. Sim, hoje temos um remake, que estão refazendo do zero. Mas pra quem tem nostalgia pelo original, não tem substituição. A qualidade de DVD não está horrenda, dá pra assistir de boa ainda hoje assim mesmo. Mas fico curioso pra ver como fica em 4K.

Não fiz nenhuma pesquisa longa, mas um ano atrás eu tinha esbarrado no [**Real ERSGAN**](https://github.com/xinntao/Real-ESRGAN). Esse projeto está descontinuado faz uns 4 anos, então não sei o que é o mais moderno hoje. Mas os modelos pré-treinados deles ainda são úteis.

Ainda tem projetos que usam esse modelo, o que eu conheço é o [**Video2K**](https://github.com/k4yt3x/video2x) Em Windows parece que tem até uma interface gráfica bonitinha, mas a vantagem pra Linux é que ele roda em Docker. Um exemplo seria assim:

```
docker run --rm --gpus all \
  -v "$PWD/videos_in":/input \
  -v "$PWD/videos_out":/output \
  ghcr.io/k4yt3x/video2x:6.4.0 \
  -i /input/old_anime.mp4 -o /output/old_anime_4K.mkv \
  -p realesrgan -s 4 --realesrgan-model realesr-animevideov3
```

Se tiver com sua NVIDIA configurada com o Container Toolkit, Cuda e tudo mais (pergunte ao ChatGPT), o Docker consegue mapear o dispositivo direto pra dentro do container. Isso facilita muito não deixar meu Linux sujo cheio de dependências e configuraçõe soltas por aí. Não faço mais nada desse tipo fora de containers.

Mas eu esbarrei com um problema. Se você estiver usando GPU AMD, só assim já deve funcionar, porque essa imagem Docker na verdade usa Vulkan e não CUDA. No meu caso eu tenho uma GPU integrada AMD primária e uma NVIDIA RTX 4090 secundária. Eu tentei passar direto:

```
❯ docker run --gpus all --privileged \
  --device=/dev/nvidia0 \
  --device=/dev/nvidiactl \
  --device=/dev/nvidia-uvm \
  --device=/dev/nvidia-modeset \
  --runtime=nvidia \
  -e VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/nvidia_icd.json \
  -e VK_LAYER_PATH=/usr/share/vulkan/explicit_layer.d \
  -v "$HOME/Downloads/Video2K/videos_in":/input \
  -v "$HOME/Downloads/Video2K/videos_out":/output \
  --rm -it \
  ghcr.io/k4yt3x/video2x:6.4.0 \
  -i "/input/(B-A)Rurouni_Kenshin_-_01_(A5D3CB57).mkv" \
  -o "/output/(B-A)Rurouni_Kenshin_-_01_(A5D3CB57)_upscaled.mkv" \
  -p realesrgan -s 4 --realesrgan-model realesr-animevideov3
```

Mas não vai de jeito nenhum. Se eu só disser "--gpus all" ele vai pegar a iGPU por padrão. Fazer o upscaling de um video acaba consumindo 100% da minha CPU, todas as 32 threads, mas minha GPU NVIDIA fica parada olhando sem fazer nada. Se eu tentar passar "/dev/dri/card0" ou "/dev/nvidia0", ele dá erro e não consegue começar.

Então a partir daqui a solução é só pra quem tem NVIDIA:

### Dockerfile CUDA

Desta vez resolvi não ser preguiçoso e organizar tudo no projetinho no Github. Clone direto de lá [Batch Anime Upscaler Video2K Docker CUDA](https://github.com/akitaonrails/Batch-Anime-Upscaler-Video2K-Docker-CUDA) Só fazer assim:

```
git clone git@github.com:akitaonrails/Batch-Anime-Upscaler-Video2K-Docker-CUDA.git
cd Batch-Anime-Upscaler-Video2K-Docker-CUDA
mkdir input # coloque seus videos velhos aqui
mkdir output

docker build --build-arg HOST_UID=$(id -u) --build-arg HOST_GID=$(id -g) -t anime-upscaler:latest .
```

Se nada der errado, isso vai construir uma imagem de Docker com tudo que você precisa, daí é colocar seus videos no subdiretório que falei, ou outro que quiser e configurar no comando pra rodar:

```
 docker run --gpus all --rm \
  -v "./input":/input \
  -v "./output":/output \
  -e HOST_UID=$(id -u) -e HOST_GID=$(id -g) \
  anime-upscaler:latest
```

E é só isso. Demora bastante. Com meu Ryzen 7950X3D mais RTX 4090, ele processa a uma taxa de uns 13 frames por segundo. Então menos da metade da velocidade de playback. Se um video tiver 20 min, vai levar mais de 40 minutos pra processar cada um. É bom reservar um bom tempo, e por isso também é bom só pra videos que você realmente queira assistir.

O script original do Video2K suporta vários parâmetros, que eu deixei expostos como variáveis de ambiente no Dockerfile:

```
MODEL="${MODEL:-realesr-animevideov3}"
SCALE="${SCALE:-4}"
TILE="${TILE:-0}"
DENOISE="${DENOISE:-1.0}"
NUM_PROC="${NUM_PROC:-1}"
```

Daí dá pra mudar mexendo assim:

```
docker run --gpus all --rm \
  -e DENOISE=0.5 \
  -v ... \
  anime-upscaler:latest
```

Como podem ver, por padrão usamos o modelo pré-treinado "realesr-animevideov3" que é menos detalhado que o modelo de 6 bilhões de parâmetro mas é bem mais estável entre frames, que é mais importante pra um video. A maioria dos outros modelos que ele suporta, como "RealESRGAN_x4plus" ou "ESRGAN_x4" servem pra fotos e imagens mas não pra video. Video exige coerência temporal, que é bem difícil. 

No máximo vale testar o modelo "realesr-general-x4v3" que dizem ser um pouco mais leve, caso sua máquina esteja capengando muito pra rodar o padrão. Mas aí vai ter que modificar o Dockerfile pra fazer download desse modelo e re-buildar:

```
# === OPTIONAL: Preload additional Real-ESRGAN models ===
# Uncomment any models you want available in the container at build time

# Anime 6-block model (better for anime stills, line art)
# RUN wget -q https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.5.0/RealESRGAN_x4plus_anime_6B.pth \
#     -O /opt/Real-ESRGAN/weights/RealESRGAN_x4plus_anime_6B.pth

# Original RealESRGAN 4x general-purpose model
# RUN wget -q https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.5.0/RealESRGAN_x4plus.pth \
#     -O /opt/Real-ESRGAN/weights/RealESRGAN_x4plus.pth

# RealESRGAN 2x model (lighter upscale)
# RUN wget -q https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.5.0/RealESRGAN_x2plus.pth \
#     -O /opt/Real-ESRGAN/weights/RealESRGAN_x2plus.pth

# ESRNet (non-GAN model, ultra-smooth)
# RUN wget -q https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.5.0/RealESRNet_x4plus.pth \
#     -O /opt/Real-ESRGAN/weights/RealESRNet_x4plus.pth

# General-purpose lightweight video-friendly model (with denoise control)
# RUN wget -q https://github.com/xinntao/Real-ESRGAN/releases/download/v0.3.0/realesr-general-x4v3.pth \
#     -O /opt/Real-ESRGAN/weights/realesr-general-x4v3.pth

# Anime video model (default in your setup)
# RUN wget -q https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.5.0/realesr-animevideov3.pth \
#     -O /opt/Real-ESRGAN/weights/realesr-animevideov3.pth

# Original ESRGAN (2018) model
# RUN wget -q https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.5.0/ESRGAN_x4.pth \
#     -O /opt/Real-ESRGAN/weights/ESRGAN_x4.pth
```

Eu não testei todos, mas pra quem quiser, acho que esses são os links. Mude no Dockerfile, faça o build, mude a variável MODEL e teste nos seus videos.

O que vale mexer são coisas como DENOISE, que está pra "1.0" que é máximo, mas isso pode deixar a imagem "esticada" demais. Vale testar valores menores, como "0.5". Varia de caso a caso, só testando.

Outro fator é a escala, SCALE, que o default é "4x", que transforma 1080p em 4K ou 720p em 1440p. Mas às vezes não precisa subir tanto, e nem adianta porque a imagem original já tem muito pouco detalhe mesmo. Talvez só 2x seja suficiente. O script suporta 2x, 3x, 4x mas tem teto na resoluçãod e 4K, então não adianta tentar transformar video que já é 4K em 8K por exemplo.

Minha RTX 4090 e meu Ryzen 9 são bem potentes. Processando só um video eu não vejo ele suando nem um pouco:

![btop](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2dz1abq9b1wteho3r1onowmij14v?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-04-19%2015-27-50.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-04-19%252015-27-50.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001014Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=bc29da3e2ec48f1d5fdac7aac430e21cf20b5775550ba6f6fcf2b0c0a223ec54)

Claramente daria pra rodar mais videos em paralelo. Tem que tomar cuidado quando é desbalanceado. Se a CPU subir pra perto de 100% pra separar os frames, não adianta estar sobrando na GPU. Os dois tendo sobra, dá pra fazer o script subir mais de 1 processo na GPU e mandar frames em paralelo com a opção "-e NUM_PROC=2". Olha como agora ele já usa mais da GPU e a CPU ainda tá sobrando. Talvez 3 seja o máximo, mas tem que testar, não é constante o tempo todo.

![btop x2](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/qur7lw4ox5s3nymh025u6q446831?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-04-19%2015-30-35.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-04-19%252015-30-35.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001015Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=859a8108ea72784420692f3bf119c750d02781ff915618140d84359a907592ae)

Isso pode diminuir o tempo total dramaticamente. Você pode escolher entre aumentar os processo na GPU pelo script ou ter dois diretórios separados de video e subir dois containers paralelos desse programa pra rodar ao mesmo tempo, o que funcionar melhor pra você.

## Resultado Final

Vamos ver como ficou aquele primeiro clip com upscale 4x e denoise 1.0:

<div class="video-container">
    <video controls>
        <source src="https://akitaonrails-videos.s3.us-east-2.amazonaws.com/kenshin_clip1_upscaled_jp.mp4">
        Your browser does not support the video tag. [Direct Link](https://akitaonrails-videos.s3.us-east-2.amazonaws.com/kenshin_clip1_upscaled_jp.mp4)
    </video>
</div>

Dá uma diferença ENORME, mas se ficou "BOM" vai ser BEM subjetivo. Eu particularmente não achava o original ruim de assistir. Talvez se mexer no DENOISE pra um pouco menos ou SCALE pra 2x em vez de 4x já fique bom, não sei.

Pra comparar, eis outro clip na versão original antiga:

<div class="video-container">
    <video controls>
        <source src="https://akitaonrails-videos.s3.us-east-2.amazonaws.com/kenshin_old_clip2.mp4">
        Your browser does not support the video tag. [Direct Link](https://akitaonrails-videos.s3.us-east-2.amazonaws.com/kenshin_old_clip2.mp4)
    </video>
</div>

E de novo, como fica depois do upscale 4x:

<div class="video-container">
    <video controls>
        <source src="https://akitaonrails-videos.s3.us-east-2.amazonaws.com/kenshin_clip2_upscaled_jp.mp4">
        Your browser does not support the video tag. [Direct Link](https://akitaonrails-videos.s3.us-east-2.amazonaws.com/kenshin_clip2_upscaled_jp.mp4)
    </video>
</div>

Pelo menos está funcionando como deveria, a partir daqui é fazer algum tuning. Se alguém tiver mais dicas ou conhecer modelos ou projetos mais novos de upscaling open source, mande nos comentários abaixo!

Antes que alguém pergunte, porque não usar DLSS 3 da NVIDIA, que eles usam pra aumentar resolução de games? Resposta: porque eles não expõe essa funcionalidade como uma API que dá pra acessar, é só pros drivers proprietários deles em profile de jogo. Eles ligam e tunam caso a caso. Não tem API geral na lib CUDA.

## Update pós-publicação

Resolvi testar o modelo RealERSGAN_x4plus_anime_6B, que é bem mais pesado que o realesr-animevideov3 que subi no repositório. 

Mude o Dockerfile e adicione isto depois do wget do outro modelo:

```
RUN wget -q https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.2.4/RealESRGAN_x4plus_anime_6B.pth \
     -O /opt/Real-ESRGAN/weights/RealESRGAN_x4plus_anime_6B.pth
```

Esse modelo não tem como rodar em paralelo nem na minha RTX 4090, que fica constantemente em 100%. Se antes ia a uns 13 frames por segundo, com esse vai só a 3 frames por segundo. É 4x mais pesado e somente pra GPUs realmente parrudas. Se não tiver algo assim, fique na "realesr-animevideov3" mesmo ou no mais leve ainda (menos qualidade) "realesr-general-x4v3". Esses modelos dependem muito da potência da GPU e principalmente, quantidade de VRAM.

Pra rodar adicione "-e MODEL=RealESRGAN_x4plus_anime_6B" no comando "docker run".

Veja como ficou o mesmo clip de antes usando este modelo:

<div class="video-container">
    <video controls>
        <source src="https://akitaonrails-videos.s3.us-east-2.amazonaws.com/kenshin_upscaled_clip1_x4plus.mp4">
        Your browser does not support the video tag. [Direct Link](https://akitaonrails-videos.s3.us-east-2.amazonaws.com/kenshin_upscaled_clip1_x4plus.mp4)
    </video>
</div>

Pra ter gasto 4x mais recursos da minha máquina pra processar, o resultado final eu não achei que ficou tão diferente, e em algumas partes eu acho que ficou mais defeitos até. Então é isso, o resultado vai variar, tem que testar. Depende muito da qualidade do anime original, mas não é porque existe um modelo maior e teoricamente "melhor" que todo resultado vai ficar melhor.
