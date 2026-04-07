---
title: Upscaling Old Anime to 4K with AI
date: '2025-04-19T15:30:00-03:00'
slug: upscaling-old-anime-to-4k-with-ai
tags:
- ersgan
- docker
- video2k
draft: false
translationKey: ai-anime-upscale-4k
description: Using Real-ESRGAN and Video2X inside a CUDA Docker container to upscale old anime files to 4K on an NVIDIA RTX 4090.
---

More than a year ago I was playing around with ErsGAN, generative adversarial networks for the task of "upscaling" (raising resolution) old anime files I have.

For collectors, the problem is that a lot of anime from the 90s and earlier never came out, and never will, on Blu-Ray (1080p) or UHD (4K). Only the most famous ones get the "remaster" treatment (taking the original master tapes and recapturing them at higher resolution). So a ton of old anime is stuck in the DVD era (480p) or VHS (480i).


Not every old anime can be upscaled, it can end up looking too "washed out". Anyone who downloads torrents has probably seen badly done upscales. But I wanted to be able to test it myself, on my local machine, with my old files. Here's a small example clip:

<div class="video-container">
    <video controls>
        <source src="https://akitaonrails-videos.s3.us-east-2.amazonaws.com/kenshin_old_clip1.mp4">
        Your browser does not support the video tag. [Direct Link](https://akitaonrails-videos.s3.us-east-2.amazonaws.com/kenshin_old_clip1.mp4)
    </video>
</div>


It's a piece of the 1st episode of the legendary Rurouni Kenshin from 1996. Yes, today we have a remake, which they're redoing from scratch. But for those of us who feel nostalgic about the original, there's no replacement. The DVD quality isn't horrendous, you can still watch it just fine today as is. But I'm curious to see how it looks in 4K.

I didn't do any long research, but a year ago I had stumbled onto [**Real ERSGAN**](https://github.com/xinntao/Real-ESRGAN). That project has been discontinued for about 4 years, so I don't know what the most modern option is today. But their pretrained models are still useful.

There are still projects that use this model, the one I know of is [**Video2K**](https://github.com/k4yt3x/video2x). On Windows it apparently even has a nice little graphical interface, but the advantage for Linux is that it runs in Docker. An example would be like this:

```
docker run --rm --gpus all \
  -v "$PWD/videos_in":/input \
  -v "$PWD/videos_out":/output \
  ghcr.io/k4yt3x/video2x:6.4.0 \
  -i /input/old_anime.mp4 -o /output/old_anime_4K.mkv \
  -p realesrgan -s 4 --realesrgan-model realesr-animevideov3
```

If you have your NVIDIA set up with the Container Toolkit, CUDA and all that (ask ChatGPT), Docker can map the device straight into the container. This makes it much easier to keep my Linux from getting dirty with dependencies and loose configs scattered around. I don't do anything of this kind outside of containers anymore.

But I ran into a problem. If you're using an AMD GPU, just doing this should already work, because this Docker image actually uses Vulkan and not CUDA. In my case I have a primary integrated AMD GPU and a secondary NVIDIA RTX 4090. I tried passing it directly:

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

But it just won't work. If I only say "--gpus all" it grabs the iGPU by default. Upscaling a video ends up consuming 100% of my CPU, all 32 threads, but my NVIDIA GPU just sits there watching, doing nothing. If I try to pass "/dev/dri/card0" or "/dev/nvidia0", it errors out and can't even start.

So from here on the solution is only for those who have NVIDIA:

### CUDA Dockerfile

This time I decided not to be lazy and organize everything into a little project on Github. Clone it directly from there [Batch Anime Upscaler Video2K Docker CUDA](https://github.com/akitaonrails/Batch-Anime-Upscaler-Video2K-Docker-CUDA). Just do this:

```
git clone git@github.com:akitaonrails/Batch-Anime-Upscaler-Video2K-Docker-CUDA.git
cd Batch-Anime-Upscaler-Video2K-Docker-CUDA
mkdir input # put your old videos here
mkdir output

docker build --build-arg HOST_UID=$(id -u) --build-arg HOST_GID=$(id -g) -t anime-upscaler:latest .
```

If nothing goes wrong, this will build a Docker image with everything you need, then it's just a matter of placing your videos in the subdirectory I mentioned, or any other you want, and configuring the run command:

```
 docker run --gpus all --rm \
  -v "./input":/input \
  -v "./output":/output \
  -e HOST_UID=$(id -u) -e HOST_GID=$(id -g) \
  anime-upscaler:latest
```

And that's it. It takes a while. With my Ryzen 7950X3D plus RTX 4090, it processes at a rate of around 13 frames per second. So less than half the playback speed. If a video is 20 minutes long, it'll take more than 40 minutes to process each one. It's a good idea to set aside plenty of time, and that's also why this is best reserved for videos you really want to watch.

The original Video2K script supports several parameters, which I left exposed as environment variables in the Dockerfile:

```
MODEL="${MODEL:-realesr-animevideov3}"
SCALE="${SCALE:-4}"
TILE="${TILE:-0}"
DENOISE="${DENOISE:-1.0}"
NUM_PROC="${NUM_PROC:-1}"
```

Then you can change them like this:

```
docker run --gpus all --rm \
  -e DENOISE=0.5 \
  -v ... \
  anime-upscaler:latest
```

As you can see, by default we use the pretrained model "realesr-animevideov3", which is less detailed than the 6 billion parameter model but is much more stable between frames, which matters more for video. Most of the other models it supports, like "RealESRGAN_x4plus" or "ESRGAN_x4", are meant for photos and images and not for video. Video demands temporal coherence, which is quite hard.

At most it's worth trying the "realesr-general-x4v3" model, which they say is a bit lighter, in case your machine is struggling too much to run the default. But then you'll have to modify the Dockerfile to download that model and rebuild:

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

I haven't tested all of them, but for anyone who wants to, I think those are the links. Change it in the Dockerfile, run the build, change the MODEL variable, and test on your videos.

What's worth tweaking are things like DENOISE, which is set to "1.0", the maximum, but that can leave the image too "stretched". It's worth trying smaller values, like "0.5". It varies case by case, only by testing.

Another factor is the scale, SCALE, where the default is "4x", which turns 1080p into 4K or 720p into 1440p. But sometimes you don't need to go that high, and there's no point because the original image already has very little detail anyway. Maybe 2x is enough. The script supports 2x, 3x, 4x but it caps at 4K resolution, so there's no point trying to turn a video that's already 4K into 8K, for example.

My RTX 4090 and my Ryzen 9 are quite powerful. Processing just one video, I don't see them breaking a sweat at all:

![btop](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2dz1abq9b1wteho3r1onowmij14v)

Clearly you could run more videos in parallel. You have to be careful when it's unbalanced. If the CPU climbs close to 100% just to separate the frames, having spare GPU capacity doesn't help. With both having headroom, you can make the script spin up more than 1 process on the GPU and send frames in parallel with the "-e NUM_PROC=2" option. Look at how it now uses more of the GPU and the CPU still has room to spare. Maybe 3 is the maximum, but you have to test, it's not constant the whole time.

![btop x2](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/qur7lw4ox5s3nymh025u6q446831)

This can dramatically reduce the total time. You can choose between increasing the GPU processes via the script or having two separate video directories and spinning up two parallel containers of this program to run at the same time, whichever works best for you.

## Final Result

Let's see how that first clip turned out with 4x upscale and 1.0 denoise:

<div class="video-container">
    <video controls>
        <source src="https://akitaonrails-videos.s3.us-east-2.amazonaws.com/kenshin_clip1_upscaled_jp.mp4">
        Your browser does not support the video tag. [Direct Link](https://akitaonrails-videos.s3.us-east-2.amazonaws.com/kenshin_clip1_upscaled_jp.mp4)
    </video>
</div>

The difference is HUGE, but whether it ended up "GOOD" is going to be VERY subjective. Personally I didn't find the original bad to watch. Maybe tweaking DENOISE down a bit, or SCALE to 2x instead of 4x, would already be good enough, I don't know.

For comparison, here's another clip in the original old version:

<div class="video-container">
    <video controls>
        <source src="https://akitaonrails-videos.s3.us-east-2.amazonaws.com/kenshin_old_clip2.mp4">
        Your browser does not support the video tag. [Direct Link](https://akitaonrails-videos.s3.us-east-2.amazonaws.com/kenshin_old_clip2.mp4)
    </video>
</div>

And again, how it looks after the 4x upscale:

<div class="video-container">
    <video controls>
        <source src="https://akitaonrails-videos.s3.us-east-2.amazonaws.com/kenshin_clip2_upscaled_jp.mp4">
        Your browser does not support the video tag. [Direct Link](https://akitaonrails-videos.s3.us-east-2.amazonaws.com/kenshin_clip2_upscaled_jp.mp4)
    </video>
</div>

At least it's working as it should, from here on it's a matter of doing some tuning. If anyone has more tips or knows of newer open source upscaling models or projects, send them in the comments below!

Before someone asks, why not use NVIDIA's DLSS 3, which they use to upscale game resolution? Answer: because they don't expose that functionality as an API you can access, it's only for their proprietary drivers in game profiles. They turn it on and tune it case by case. There's no general API in the CUDA lib.

## Post-publication Update

I decided to test the RealERSGAN_x4plus_anime_6B model, which is much heavier than the realesr-animevideov3 I uploaded to the repository.

Change the Dockerfile and add this after the wget for the other model:

```
RUN wget -q https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.2.4/RealESRGAN_x4plus_anime_6B.pth \
     -O /opt/Real-ESRGAN/weights/RealESRGAN_x4plus_anime_6B.pth
```

This model can't be run in parallel even on my RTX 4090, which stays constantly at 100%. If before it ran at around 13 frames per second, with this one it only runs at 3 frames per second. It's 4x heavier and only for really beefy GPUs. If you don't have something like that, stick with "realesr-animevideov3", or with the even lighter (lower quality) "realesr-general-x4v3". These models depend heavily on GPU power and especially on the amount of VRAM.

To run it, add "-e MODEL=RealESRGAN_x4plus_anime_6B" to the "docker run" command.

See how the same clip from before turned out using this model:

<div class="video-container">
    <video controls>
        <source src="https://akitaonrails-videos.s3.us-east-2.amazonaws.com/kenshin_upscaled_clip1_x4plus.mp4">
        Your browser does not support the video tag. [Direct Link](https://akitaonrails-videos.s3.us-east-2.amazonaws.com/kenshin_upscaled_clip1_x4plus.mp4)
    </video>
</div>

For having spent 4x more of my machine's resources to process it, I didn't find the final result that different, and in some parts I think it even has more defects. So that's it, the result will vary, you have to test. It depends a lot on the quality of the original anime, but just because a bigger and theoretically "better" model exists doesn't mean every result will turn out better.
