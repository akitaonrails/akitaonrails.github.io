---
title: Colorindo Imagens Preto e Branco com I.A.
date: '2025-04-19T01:40:00-03:00'
slug: colorindo-imagens-preto-e-branco-com-i-a
tags:
- ddcolor
- I.A.
- github
- docker
  - AI
draft: false
translationKey: ai-colorize-black-white
---

Minha namorada me deu um desafio hoje: ela tinha fotos preto e branco antigas e queria saber se eu conseguia colorizar elas. Se sair procurando na Web esbarra em alguns sites pra isso, como esse: [Palette](https://palette.fm/). Mas é pago, não é barato e acho que ele não consegue uma coisa que ela queria: usar uma outra imagem colorida como referência pra tirar as cores em vez de tentar colorizar por chute do modelo.

Saí fuçando GitHub e tem uma página [Awesome Image Colorization](https://github.com/MarkMoHR/Awesome-Image-Colorization) com vários papers de pesquisa. Muito útil pra quem for pesquisador mas totalmente inútil pra mim que não vou fazer um do zero kkkk. Tinha links pra alguns projetos como ChromaGAN, mas que está descontinuado faz uns 5 anos. E vários outros projetos que eu vi foram descontinuados lá atrás mesmo, não sei porque tem tão pouco open source ainda atualizado.


Mas felizmente esbarrei em um promissor: [DDColor](https://github.com/piddnad/DDColor). 

Bora clonar o repositório. E pra continuar, prefiro fazer tudo dentro de Docker. Ficar baixando dependência de python sempre zoa meu sistema e deixa um monte de lixo pra trás, então melhor coisa é isolar tudo. Outra coisa, precisa baixar os binários dos modelos pré-treinados. Só pra isso vou usar um pouco de Python por causa da lib "modelscope" que faz isso:

```bash
git clone https://github.com/piddnad/DDColor.git
cd DDColor

mkdir modelscope

# criar um novo venv dentro do projeto DDColor
python -m venv venv

venv/bin/pip3 install modelscope

venv/bin/python3 -c "from modelscope.hub.snapshot_download import snapshot_download; snapshot_download('damo/cv_ddcolor_image-colorization', cache_dir='./modelscope')"
```

Boa prática de Python acho que é fazer tudo dentro de uma VENV né? Enfim, isso deve baixar o binário do modelo, que pesa quase 900MB. Não é grande.

Agora precisamos de um Dockerfile:

```
# Use NVIDIA CUDA base image with cuDNN 8 and Python support
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04

# Install Python and system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip git libgl1 libglib2.0-0 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy DDColor source code into the image
COPY . /app

# Install PyTorch (CUDA 11.8 compatible) and matching torchvision/torchaudio
RUN pip3 install torch==2.2.0 torchvision==0.17.0 torchaudio==2.2.0 \
    --index-url https://download.pytorch.org/whl/cu118

# Install Python dependencies, skipping dlib (not needed for inference)
RUN sed '/dlib/d' requirements.txt > temp-req.txt && pip3 install -r temp-req.txt && rm temp-req.txt

# Optional: install modelscope if you want to run snapshot_download manually inside the container
RUN pip3 install modelscope
```

Preguiça de abrir um pull request pra isso, se alguém quiser, mande lá.

Agora precisamos colocar uma imagem preto e branco em algum lugar:

```
mkdir input
mkdir results
mv ~/Downloads/bw.jpg input/
```

Como as fotos da minha namorada são familiares e particulares, obviamente não vou compartilhar, então peguei uma aleatória qualquer no Google Images:

![Foto B&W](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/qgt3lynkp1f5uzkbysyvio2kmq04)

Agora colocamos em "./input" e rodamos o Docker com este comando:

```
docker run --rm --gpus all \
  -v "$PWD/input":/workspace/input_images:ro \
  -v "$PWD/results":/workspace/results:rw \
  -v "$PWD/modelscope":/app/modelscope:ro \
  ddcolor:latest \
  python3 infer.py \
    --model_path /app/modelscope/damo/cv_ddcolor_image-colorization/pytorch_model.pt \
    --input /workspace/input_images \
    --output /workspace/results
```

Preste atenção no mapeamento de diretórios. E note a opção "--gpus" que só funciona no meu caso porque eu tenho uma RTX 4090 instalada aqui. Não tenho a mínima idéia se é a mesma coisa com AMD, mas como a imagem é baseada em cnDNN/CUDA, acho que não. Pergunte ao ChatGPT.

Se estiver tudo certo e rodar com sucesso, vai levar só 1 segundo e ter este output no terminal:

```
==========
== CUDA ==
==========

CUDA Version 11.8.0

Container image Copyright (c) 2016-2023, NVIDIA CORPORATION & AFFILIATES. All rights reserved.

This container image and its contents are governed by the NVIDIA Deep Learning Container License.
By pulling and using the container, you accept the terms and conditions of this license:
https://developer.nvidia.com/ngc/nvidia-deep-learning-container-license

A copy of this license is made available in this container at /NGC-DL-CONTAINER-LICENSE for your convenience.

Output path: /workspace/results
100%|██████████| 1/1 [00:00<00:00,  4.09it/s]
```

E eis o resultado que aparece no diretório `./results":

![Foto re-colorizada](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/o2r085pzzpsavbyr39btg1vq0hwp)

Sim, eu fiquei impressionado. Mesmo a imagem sendo da Web, com marca d'agua e tudo, ele fez tudo direitinho e funcionou!!

Único problema é que ainda falta o problema de conseguir usar uma imagem de referência pra tentar pegar as cores. Esse é um problema mais difícil e eu perguntei ao ChatGPT que me respondeu isto:

**Sem suporte nativo para imagem de referência:**  

O modelo DDColor, tanto na versão oficial hospedada no ModelScope quanto no repositório GitHub `piddnad/DDColor`, foi projetado apenas para colorização **automática de imagens em preto e branco**, sem aceitar uma imagem de referência como entrada. A própria descrição oficial deixa claro que o modelo recebe **uma única imagem P&B** e retorna uma imagem colorida.

O método `forward` do modelo espera **apenas um tensor**, referente à imagem P&B convertida em RGB artificial (na verdade, a luminância expandida para 3 canais). Ou seja, **não há lugar no modelo para passar uma segunda imagem como referência de cores**.

Isso também fica evidente no `predict.py` original da biblioteca Cog, que aceita apenas o parâmetro `image` como entrada — sem suporte a `reference`, `ref_image` ou algo do tipo.

### Como resolver o problema: duas abordagens possíveis

Como o DDColor não suporta nativamente uma imagem de referência para guiar as cores, temos duas alternativas:

### 🔁 1. Usar um modelo especializado em colorização com referência

Existem modelos desenvolvidos especificamente para isso, como:

- **Deep Exemplar-based Colorization** (Zhang et al., CVPR 2018)
    
- **ChromaGAN** (2019)
    
- **Exemplar-Transformer Colorization** (Yin et al., ACM MM 2021)
    
- **UniColor** (Huang et al., 2022)
    

Esses modelos aceitam **duas imagens**:

- A imagem em P&B (entrada principal)
    
- Uma imagem colorida como **referência de cores**
    

Esses modelos mapeiam similaridades semânticas (ex: “pele aqui deve ter a mesma cor de pele dali”) e fazem uma transferência **baseada no conteúdo da imagem**, obtendo resultados muito mais detalhados e específicos. No entanto, isso exigiria:

- Baixar pesos diferentes
    
- Alterar completamente a arquitetura usada
    
- Adaptar o pipeline e a inferência
    

### 🎯 2. Usar transferência global de cor após a saída do DDColor (nossa abordagem atual)

A solução prática e leve que usamos foi:  
➡️ Rodar o DDColor normalmente para gerar a imagem colorida automaticamente  
➡️ Depois, ajustar **globalmente** as cores do resultado para ficarem mais parecidas com as da imagem de referência.

Esse ajuste é feito com o algoritmo de **Reinhard et al. (2001)**:

1. Convertemos tanto a imagem de saída quanto a referência para o espaço de cor Lab.
    
2. Calculamos a **média e o desvio padrão** dos canais `a` e `b` (os que representam cor).
    
3. Ajustamos o resultado para ter **a mesma distribuição estatística** de cor que a imagem de referência.
    
4. Isso tende a deixar a imagem com o mesmo “clima” ou tom geral (mais quente, mais frio, mais vibrante).
    

Esse método é rápido, leve, e funciona **sem alterar o modelo DDColor**.

## Continuando

Eu usei a modificação que ele sugeriu ao arquivo predict.py:

```python
import os
import cv2
import numpy as np
import torch
import torch.nn.functional as F
from cog import BasePredictor, Input, Path
from basicsr.archs.ddcolor_arch import DDColor

def color_transfer(reference_bgr: np.ndarray, target_bgr: np.ndarray) -> np.ndarray:
    """Transfer color palette of reference image to target image using Lab mean/std."""
    # Convert BGR images to Lab color space (float32 for precision)
    ref_lab = cv2.cvtColor(reference_bgr, cv2.COLOR_BGR2LAB).astype("float32")
    tgt_lab = cv2.cvtColor(target_bgr, cv2.COLOR_BGR2LAB).astype("float32")
    # Split channels
    L_ref, a_ref, b_ref = cv2.split(ref_lab)
    L_tgt, a_tgt, b_tgt = cv2.split(tgt_lab)
    # Compute mean and std for reference and target (a and b channels)
    a_ref_mean, a_ref_std = a_ref.mean(), a_ref.std()
    b_ref_mean, b_ref_std = b_ref.mean(), b_ref.std()
    a_tgt_mean, a_tgt_std = a_tgt.mean(), a_tgt.std()
    b_tgt_mean, b_tgt_std = b_tgt.mean(), b_tgt.std()
    # Subtract target means, scale by reference/target std, add reference means
    # (Avoid division by zero in case of zero std)
    if a_tgt_std > 1e-6:
        a_tgt = ((a_tgt - a_tgt_mean) * (a_ref_std / a_tgt_std)) + a_ref_mean
    else:
        a_tgt = a_tgt - a_tgt_mean + a_ref_mean
    if b_tgt_std > 1e-6:
        b_tgt = ((b_tgt - b_tgt_mean) * (b_ref_std / b_tgt_std)) + b_ref_mean
    else:
        b_tgt = b_tgt - b_tgt_mean + b_ref_mean
    # Clip values to valid Lab range [0,255] after transfer
    a_tgt = np.clip(a_tgt, 0, 255)
    b_tgt = np.clip(b_tgt, 0, 255)
    # Merge channels back (use original L from target to preserve brightness)
    merged_lab = cv2.merge([L_tgt, a_tgt, b_tgt]).astype("uint8")
    # Convert back to BGR color space
    result_bgr = cv2.cvtColor(merged_lab, cv2.COLOR_LAB2BGR)
    return result_bgr

class ImageColorizationPipeline:
    """Helper pipeline to load DDColor model and process images."""
    def __init__(self, model_path: str, input_size: int = 256, model_size: str = "large"):
        self.device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
        # Choose encoder backbone based on model size
        encoder_name = "convnext-t" if model_size == "tiny" else "convnext-l"
        # Initialize DDColor model
        self.model = DDColor(
            encoder_name=encoder_name,
            decoder_name="MultiScaleColorDecoder",
            input_size=[input_size, input_size],
            num_output_channels=2,    # model predicts ab channels
            last_norm="Spectral",
            do_normalize=False,
            num_queries=100,
            num_scales=3,
            dec_layers=9,
        ).to(self.device)
        # Load weights
        state = torch.load(model_path, map_location="cpu")
        # Some checkpoints store weights under 'params' key
        self.model.load_state_dict(state.get("params", state), strict=False)
        self.model.eval()
        self.input_size = input_size  # store for processing

    @torch.no_grad()
    def process(self, img_bgr: np.ndarray) -> np.ndarray:
        """Colorize a BGR image (numpy array) using the loaded DDColor model."""
        # Preserve original resolution L channel
        orig_h, orig_w = img_bgr.shape[:2]
        # Convert to Lab and extract L channel at original size
        img_lab = cv2.cvtColor(img_bgr, cv2.COLOR_BGR2LAB).astype("float32")
        orig_L = img_lab[:, :, 0:1]  # shape (H, W, 1)
        # Prepare grayscale input at model resolution
        # Resize input to model expected size
        inp = cv2.resize(img_bgr, (self.input_size, self.input_size))
        inp_lab = cv2.cvtColor(inp, cv2.COLOR_BGR2LAB).astype("float32")
        L = inp_lab[:, :, 0:1]
        # Create grayscale Lab image by zeroing AB channels
        gray_lab = np.concatenate([L, np.zeros_like(L), np.zeros_like(L)], axis=2)
        # Convert back to RGB (now it's a gray RGB image of size input_size)
        gray_rgb = cv2.cvtColor(gray_lab.astype("uint8"), cv2.COLOR_LAB2RGB)
        # Prepare tensor and run model
        tensor = torch.from_numpy(gray_rgb.transpose(2, 0, 1)).float().unsqueeze(0).to(self.device)
        out_ab = self.model(tensor)  # output is (1,2,H_out,W_out) in Lab AB
        out_ab = out_ab.cpu().float()
        # Resize output AB to original image size
        out_ab_resized = F.interpolate(out_ab, size=(orig_h, orig_w), mode="bilinear", align_corners=False)
        out_ab_resized = out_ab_resized[0].numpy().transpose(1, 2, 0)  # (H, W, 2)
        # Combine original L and predicted AB, then convert to BGR
        out_lab = np.concatenate([orig_L, out_ab_resized], axis=2).astype("uint8")
        out_bgr = cv2.cvtColor(out_lab, cv2.COLOR_LAB2BGR)
        return out_bgr

class Predictor(BasePredictor):
    def setup(self):
        """Load models into memory for efficient multiple predictions."""
        # Determine paths for large and tiny model weights
        large_model_path = "checkpoints/ddcolor_modelscope.pth"
        tiny_model_path  = "checkpoints/ddcolor_paper_tiny.pth"
        # (Ensure the above files exist. If not, download from ModelScope or HuggingFace as described.)
        # Initialize pipelines for large and tiny models
        self.colorizer_large = ImageColorizationPipeline(model_path=large_model_path, input_size=512, model_size="large")
        self.colorizer_tiny  = ImageColorizationPipeline(model_path=tiny_model_path,  input_size=512, model_size="tiny")

    def predict(
        self,
        image: Path = Input(description="Grayscale input image."),
        reference: Path = Input(description="Optional reference image to guide colors", default=None),
        model_size: str = Input(description="Model size to use (large = highest quality, tiny = faster).",
                                choices=["large", "tiny"], default="large"),
    ) -> Path:
        """Run a single prediction. Colorizes the image, optionally using a reference image for color bias."""
        # Read input image
        img = cv2.imread(str(image))
        if img is None:
            raise ValueError("Failed to load input image")
        # Select model pipeline
        pipeline = self.colorizer_tiny if model_size == "tiny" else self.colorizer_large
        # Colorize the image using DDColor
        output_bgr = pipeline.process(img)
        # If a reference image is provided, transfer its color style to the output
        if reference is not None:
            ref_img = cv2.imread(str(reference))
            if ref_img is None:
                raise ValueError("Failed to load reference image")
            # Only apply transfer if reference is a color image
            if ref_img.shape[2] == 3:
                output_bgr = color_transfer(ref_img, output_bgr)
        # Save result
        out_path = "/tmp/out.png"
        cv2.imwrite(out_path, output_bgr)
        return Path(out_path)
```

Com essa modificação posso rodar com esse novo parâmetro, note a opção "--ref" que tem agora e coloque sua imagem no lugar certo:

```
❯ docker run --rm --gpus all \
  -v "$PWD/input":/workspace/input_images:ro \
  -v "$PWD/results":/workspace/results:rw \
  -v "$PWD/ref_images":/workspace/ref_images:ro \
  -v "$PWD/modelscope":/app/modelscope:ro \
  -v "$PWD/infer.py":/app/infer.py:ro \
  ddcolor:latest \
  python3 /app/infer.py \
    --model_path /app/modelscope/damo/cv_ddcolor_image-colorization/pytorch_model.pt \
    --input /workspace/input_images \
    --ref /workspace/ref_images/images.jpg \
    --output /workspace/results
```

Passei outra foto colorida de referência mas não dferença no resultado. Novamente, perguntei ao ChatGPT:
### Por que você não percebeu diferença no resultado?

A **transferência global de cor** só altera a “paleta geral” — e não as cores de cada objeto.  

Se a imagem de referência tem tons suaves ou parecidos com os que o DDColor já aplicaria automaticamente, o efeito final **vai parecer idêntico**.

Mas se você usar como referência uma imagem bem saturada (por exemplo, um céu alaranjado, ou um ambiente azul escuro), você verá a saída do DDColor ser **puxada visualmente** para aquele estilo.

## Conclusão

Segui a sugestão e baixei outra imagem nada a ver, colorida, super saturada com cores vibrantes pra ver se fazia diferença. Esta é a imagem de referência que passei pro Docker:

![Imagem de Referência](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/ryptql9u8mk04o3r7ah01fk1qz5q)

E eis o novo resultado aplicando ela à imagem anterior em pós-processamento (esse passo não é mais I.A. é pós-processamento de imagem mesmo).

![Foto pós-processada](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/cxcwwnj2ncszvmv4whj4qesafgnm)

Comparem com a outra foto re-colorizada, vou colocar aqui embaixo de novo pra dar pra comparar:

![Repetindo a primeira re-colorização](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/o2r085pzzpsavbyr39btg1vq0hwp)

Entenderam? Agora precisa ficar testando com referências diferentes pra ver a influência no resultado final, mas de fato, ele consegue aplicar o algoritmo de Reinhard e fazer uma transferência global de cor. Como o nome diz, é "global", não "por objeto", então é difícil conseguir controlar só partes da imagem e sim a imagem toda. Mas em teoria eu acho que você conseguiria fazer uma colorização manual no Photoshop com cores saturadas, perto de onde quer influenciar, pra tentar ajustar, mas eu não tentei isso ainda, depois se alguém fizer, mande nos comentários.

Mas é isso. Agora pelo menos eu consigo me divertir pegando fotos antigas de família e re-colorizar.
