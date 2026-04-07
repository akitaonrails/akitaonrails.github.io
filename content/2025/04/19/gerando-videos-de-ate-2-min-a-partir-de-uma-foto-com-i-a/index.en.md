---
title: Generating Up to 2-Minute Videos from a Photo with A.I.
date: '2025-04-19T20:00:00-03:00'
slug: generating-up-to-2-minute-videos-from-a-photo-with-ai
tags:
- framepack
- hunyuan
- flux
- docker
- figures
- 3d print
draft: false
translationKey: ai-photo-to-video-2min
description: Using FramePack with Tencent's HunyuanVideo in Docker on an RTX 4090 to animate photos of action figures and drawings into videos up to two minutes long.
---

By far the best channel for tutorials on open source A.I. tools is [Aitrepreneur](https://www.youtube.com/watch?v=GywyMij88rY). And in this link he introduces a new tool called [FramePack](https://github.com/lllyasviel/FramePack), which uses Tencent's famous [HunyuanVideo](https://github.com/Tencent/HunyuanVideo) model to take a single image, a photo, and generate excellent quality videos up to 2 minutes long. It's truly impressive! Watch the video, but right below is a 10-second clip generated from a photo I took of one of the action figures in my collection.

<div class="video-container">
    <video controls>
        <source src="https://akitaonrails-videos.s3.us-east-2.amazonaws.com/link-animado.mp4">
        Your browser does not support the video tag. [Direct Link](https://akitaonrails-videos.s3.us-east-2.amazonaws.com/link-animado.mp4)
    </video>
</div>



Since I was already on a roll packaging this kind of tool in Docker, I decided to make another little project with a Dockerfile to run on my Manjaro Linux with an RTX 4090. The good thing about Aitrepreneur is that he has a Patreon you can subscribe to in order to contribute (it's cheap) and he always uploads scripts to run on [RunPod](https://www.runpod.io/) in case you don't have a beefy machine or GPU, or .BAT scripts to run on your Windows.

My little project is [on this GitHub](https://github.com/akitaonrails/FramePack-Docker-CUDA) and using it is very simple:

```

git clone https://github.com/akitaonrails/FramePack-Docker-CUDA.git
cd FramePack-Docker-CUDA
mkdir outputs
mkdir hf_download

# Build the image
docker build -t framepack-torch26-cu124:latest .

# Run mapping the directories outside:
docker run -it --rm --gpus all -p 7860:7860 \
  -v ./outputs:/app/outputs \
  -v ./hf_download:/app/hf_download \
  framepack-torch26-cu124:latest
```

This will build the Docker image and run it. And the first time you can see it will download a TON of models, HunyuanVideo, Flux and more. Get ready for over 30GB. But it's only the first time because I map the download directory outside, so if you restart the container it will already have everything next time.

When it's done, just go to **http://localhost:7860** and you'll see this super simple interface:

![FramePack Web UI](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/x5nwxu25vlb9ox5kda5xiz6b4fwf)


The controls are very simple:

- Disable the "Use TeaCache" option which makes it faster but then you risk getting those A.I. defects like hands with extra fingers and stuff like that.
- Total Video length can go up to 2 minutes, but only do that if you really have patience because it takes A LOT of time! I think it's better to start by testing with short 5 to 10 second videos first.
- If your GPU has little VRAM you'll be forced to mess with "GPU Inference Preserved Memory (GB) (larger means slower)". In my case with 24GB of VRAM I left it as is, but look how it consumes resources while running:

![btop](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/5purckhhytuqd7bwp2wjqhyxq66p)

Yes! 100% of the GPU and almost 100% of the VRAM, pulling more than 350W from the wall! (screw the environment! lol) The CPU stays chill, because this process is made to really MASSACRE the GPU. If you don't have a good GPU, rent a machine on RunPod like I said before.

The 10-second video at the start of the post is a photo of one of my favorite action figures in my collection, Link from Breath of the Wild. And this is something that got me excited. This is the original photo that served as the basis for FramePack to make the video:

![Link Foto](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/g3dm9u1ij8r6gl0dk90qool0htyw)

Making videos of photos of people is dull and tedious, but now that I'm learning to model 3D to print on my Bambulab, imagine then being able to make it animated too?

To animate in Blender and render also takes a lot of processing and time. But with this I can quickly prototype an animation and see how it looks, to decide if it's worth making a better version in Blender afterwards. It opens up many possibilities for experimentation!

As impressive as this seems, it doesn't do **JUST ANYTHING**, I had several experiments that went wrong and the movement it makes is quite limited, after all it only has a single photo to use as a reference and you can't make movements that are too abrupt, there are limits. Even so it's very fun to play with. The fact that it can identify more than just human beings is a big "plus" in my opinion, because that's what got me more interested.

**OH YES!** Remember the [other blog post](https://www.akitaonrails.com/2025/04/19/aumentando-resolucao-de-anime-velho-pra-4k-com-i-a) I published today about doing **UPSCALE TO 4K**?? You can use it here too, take a video that FramePack generated that you really liked and upscale it to 4K to have even more definition! Then it's at quality you can even use in video editing.

2-minute videos must take hours to make. 30 seconds took almost 1 hour. The best thing is to stick with 5-second videos to play and experiment, just that already takes nearly half an hour. Here are some more examples taken from photos of items in my collection (the ones you used to see in the background of my videos). Have fun!

<div class="video-container">
    <video controls>
        <source src="https://akitaonrails-videos.s3.us-east-2.amazonaws.com/ultraseven-animado.mp4">
        Your browser does not support the video tag. [Direct Link](https://akitaonrails-videos.s3.us-east-2.amazonaws.com/ultraseven-animado.mp4)
    </video>
</div>

This is an Ultraseven over 30cm tall that I found and brought directly from a used goods shop in Tokyo last year, one of my favorites especially because I watched it a lot in the early 80s when I was a kid.

<div class="video-container">
    <video controls>
        <source src="https://akitaonrails-videos.s3.us-east-2.amazonaws.com/jiraya-animado.mp4">
        Your browser does not support the video tag. [Direct Link](https://akitaonrails-videos.s3.us-east-2.amazonaws.com/jiraya-animado.mp4)
    </video>
</div>

Speaking of nostalgia, this is another awesome item in my collection, a super detailed Jiraya made by Iron Studios. And animated it actually turned out pretty cool. What did you think?

But now my **FAVORITE**, those who follow me on [Instagram](https://www.instagram.com/p/DIAe3pNOFgffFZ5J32fWlc-8Kmy3Lhap5Vm58U0/?img_index=1) have seen that for the past few weeks I've been dedicating myself to improving my 3D techniques and also drawing and I made a concept of Mandalorian + Judge Dredd:

![Boba Dredd](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/01qz4daelmm671m5ytgua036373h).png?disposition=attachment&locale=en)

Check out my other drawings on my Instagram afterwards, but anyway, I needed to know if FramePack was capable of animating drawings too and YES, IT CAN!! LOOK HOW B4D4SS!!! This one really impressed me, it gives a new dimension to my stuff!

<div class="video-container">
    <video controls>
        <source src="https://akitaonrails-videos.s3.us-east-2.amazonaws.com/boba-dredd-animado_upscaled.mp4">
        Your browser does not support the video tag. [Direct Link](https://akitaonrails-videos.s3.us-east-2.amazonaws.com/boba-dredd-animado_upscaled.mp4)
    </video>
</div>

Yes, all of this is quite heavy, but the advantage is that I can experiment INFINITELY, because everything runs locally. On someone's commercial product in the "cloud", I'd have to pay some subscription and they'd limit me, it would be impossible to keep experimenting whenever I wanted. Now I can do everything I want, whenever I want, however I want, without anyone or anything bothering me.

By the way, if you can, watch that "Boba Dredd" clip in full screen on a big monitor. Did you notice how sharp it is? That's because I ran it through Video2K and upscaled to 4x the resolution that FramePack gave me. Combining these tools you can do REALLY interesting things, let me know later if you managed to use it and what cool stuff you made!
