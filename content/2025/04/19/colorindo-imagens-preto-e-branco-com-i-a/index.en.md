---
title: Colorizing Black and White Images with A.I.
date: '2025-04-19T01:40:00-03:00'
slug: colorizing-black-and-white-images-with-ai
tags:
- ddcolor
- I.A.
- github
- docker
draft: false
translationKey: ai-colorize-black-white
description: Using DDColor inside Docker to colorize old black and white photos, plus a Reinhard global color transfer hack to bias the result toward a reference image.
---

My girlfriend gave me a challenge today: she had old black and white photos and wanted to know if I could colorize them. If you go searching the Web you bump into a few sites for this, like [Palette](https://palette.fm/). But it is paid, it is not cheap, and I do not think it can do something she wanted: use another colored image as a reference to pull the colors instead of letting the model guess.

I went poking around GitHub and there is an [Awesome Image Colorization](https://github.com/MarkMoHR/Awesome-Image-Colorization) page with a bunch of research papers. Very useful for researchers but totally useless for me, since I am not going to build one from scratch lol. There were links to projects like ChromaGAN, but that one has been discontinued for about 5 years. And several other projects I saw were also discontinued ages ago. I do not know why there is so little open source still actively maintained.


Luckily I bumped into a promising one: [DDColor](https://github.com/piddnad/DDColor).

Let's clone the repo. And to keep going, I prefer to do everything inside Docker. Downloading Python dependencies always messes up my system and leaves a bunch of garbage behind, so the best thing is to isolate it all. Another thing, you need to download the binaries of the pre-trained models. Just for that I will use a bit of Python because of the "modelscope" lib that handles it:

```bash
git clone https://github.com/piddnad/DDColor.git
cd DDColor

mkdir modelscope

# create a new venv inside the DDColor project
python -m venv venv

venv/bin/pip3 install modelscope

venv/bin/python3 -c "from modelscope.hub.snapshot_download import snapshot_download; snapshot_download('damo/cv_ddcolor_image-colorization', cache_dir='./modelscope')"
```

Good Python practice is to do everything inside a VENV, right? Anyway, this should download the model binary, which weighs almost 900MB. Not huge.

Now we need a Dockerfile:

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

Too lazy to open a pull request for this, if anyone wants to, send it over there.

Now we need to put a black and white image somewhere:

```
mkdir input
mkdir results
mv ~/Downloads/bw.jpg input/
```

Since my girlfriend's photos are family and private, obviously I am not going to share them, so I grabbed a random one from Google Images:

![B&W Photo](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/qgt3lynkp1f5uzkbysyvio2kmq04)

Now we drop it in "./input" and run Docker with this command:

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

Pay attention to the directory mapping. And note the "--gpus" option, which only works in my case because I have an RTX 4090 installed here. I have no idea if it is the same with AMD, but since the image is based on cuDNN/CUDA, I would say no. Ask ChatGPT.

If everything is right and it runs successfully, it will take just 1 second and produce this output in the terminal:

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

And here is the result that shows up in the `./results` directory:

![Re-colorized photo](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/o2r085pzzpsavbyr39btg1vq0hwp)

Yes, I was impressed. Even with the image being from the Web, with watermark and all, it did everything properly and worked!!

The only problem left is being able to use a reference image to try to pull the colors. That is a harder problem and I asked ChatGPT, which answered me this:

**No native support for a reference image:**

The DDColor model, both in the official version hosted on ModelScope and in the `piddnad/DDColor` GitHub repo, was designed only for **automatic colorization of black and white images**, with no option to accept a reference image as input. The official description itself makes it clear that the model takes **a single B&W image** and returns a colored image.

The model's `forward` method expects **only one tensor**, the B&W image converted into artificial RGB (actually the luminance expanded into 3 channels). In other words, **there is no place in the model to pass a second image as a color reference**.

This is also evident in the original `predict.py` from the Cog library, which only accepts the `image` parameter as input — with no support for `reference`, `ref_image` or anything of the kind.

### How to solve the problem: two possible approaches

Since DDColor does not natively support a reference image to guide the colors, we have two alternatives:

### 🔁 1. Use a model specialized in reference-based colorization

There are models developed specifically for this, such as:

- **Deep Exemplar-based Colorization** (Zhang et al., CVPR 2018)
    
- **ChromaGAN** (2019)
    
- **Exemplar-Transformer Colorization** (Yin et al., ACM MM 2021)
    
- **UniColor** (Huang et al., 2022)
    

These models accept **two images**:

- The B&W image (main input)
    
- A colored image as a **color reference**
    

These models map semantic similarities (e.g., "skin here should have the same skin color as over there") and do a transfer **based on the image content**, getting much more detailed and specific results. However, this would require:

- Downloading different weights
    
- Completely changing the architecture used
    
- Adapting the pipeline and inference
    

### 🎯 2. Use global color transfer after the DDColor output (our current approach)

The practical and lightweight solution we used was:
➡️ Run DDColor normally to generate the colored image automatically
➡️ Then **globally** adjust the colors of the result to look more like the reference image.

This adjustment is done with the **Reinhard et al. (2001)** algorithm:

1. We convert both the output image and the reference to the Lab color space.
    
2. We compute the **mean and standard deviation** of the `a` and `b` channels (the ones that represent color).
    
3. We adjust the result to have **the same statistical distribution** of color as the reference image.
    
4. This tends to leave the image with the same overall "mood" or tone (warmer, cooler, more vibrant).
    

This method is fast, lightweight, and works **without altering the DDColor model**.

## Continuing

I used the modification it suggested to the predict.py file:

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

With this modification I can run with a new parameter, note the "--ref" option that exists now and place your image in the right spot:

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

I passed in another colored reference photo but saw no difference in the result. Once again, I asked ChatGPT:
### Why didn't you notice a difference in the result?

The **global color transfer** only changes the "overall palette" — and not the colors of each object.

If the reference image has soft tones similar to what DDColor would already apply automatically, the final effect **will look identical**.

But if you use as reference a heavily saturated image (for example, an orange sky, or a deep blue environment), you will see DDColor's output **visually pulled** toward that style.

## Conclusion

I followed the suggestion and downloaded another totally unrelated image, colored, super saturated with vibrant colors to see if it made a difference. This is the reference image I passed to Docker:

![Reference Image](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/ryptql9u8mk04o3r7ah01fk1qz5q)

And here is the new result applying it to the previous image in post-processing (this step is no longer A.I., it really is just image post-processing).

![Post-processed photo](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/cxcwwnj2ncszvmv4whj4qesafgnm)

Compare it with the other re-colorized photo, I will put it down here again so you can compare:

![Repeating the first re-colorization](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/o2r085pzzpsavbyr39btg1vq0hwp)

Got it? Now you have to keep testing with different references to see how they influence the final result, but indeed, it manages to apply the Reinhard algorithm and do a global color transfer. As the name says, it is "global", not "per object", so it is hard to control only parts of the image — it acts on the whole image. But in theory I think you could do a manual colorization in Photoshop with saturated colors, near where you want to influence, to try to nudge it, but I have not tried that yet. Later, if anyone does, drop it in the comments.

But that is it. Now at least I can have fun grabbing old family photos and re-colorizing them.
