---
title: Starting with Blender
date: '2017-06-21T17:32:00-03:00'
slug: starting-with-blender
translationKey: starting-with-blender
description: "My guide to getting started with Blender covers initial settings like Cycles, Filmic, and CUDA, then moves into photography, composition, and PBR materials. Learning takes study, practice, and shortcuts."
tags:
- tutorials
- learning
- audio-and-video
- off-topic
draft: false
---

Blender is a beast. A true marvel of what open source technology can achieve, and you should applaud everyone involved in making this thing work as well as it does. It rivals the most expensive commercial options out there, from Maya to the venerable Pixar's Renderman.

The Blender community is so passionate and committed that they frequently produce high quality, almost Hollywood grade [short movies](https://web.archive.org/web/20151127160645/http://archive.blender.org/features-gallery/movies/) inside Blender. The point is to stress test the tool and flush out bottlenecks and usability issues in a real world workflow.

This is primarily a post for "future me" to jump back into a single resource list. Being a 3D modeler is not my full time job, so I'll have large gaps between Blender sessions. And I know I'll regret it if I don't dump my brain into a post while it's still fresh :-)

### Beginner First Steps

First things first. If you're in this blog, you're probably a programmer. And let me tell you that the Graphics folks see "usability" very differently from what we, programmers, usually think of. The sheer amount of customization, options, shortcuts and combinations will rival even Vim and Emacs users out there.

Oh, by the way, you're going to need a real 3-button mouse. Touchpads are useless with Blender, and the Mac mouse is terrible. [Any cheap PC mouse will do.](http://www.dell.com/br/mouse)

Out of the box, the main button is the right one, not the left one we're used to. Change that in the [user preferences](https://web.archive.org/web/20181118204135/https://docs.blender.org/manual/en/dev/preferences/input.html) to select with Left, and things start to make sense. While you're there, enable Numpad emulation too.

By the way, it's well worth having a keyboard with a numpad, or even a separate numpad. You can use the number row on top of your normal keyboard, but Blender was built assuming both an inverted 3-button mouse and a numpad.

[![Input User Preferences](https://web.archive.org/web/20181119110123/https://docs.blender.org/manual/en/dev/_images/preferences_input_tab.png)](https://web.archive.org/web/20181118204135/https://docs.blender.org/manual/en/dev/preferences/input.html)

If you have never studied Blender before, you will not figure things out just by randomly exploring the UI. The UI is useless until someone teaches you the ins and outs. There are hundreds of terms you just have no idea what they mean, such as Meshes, Edges, Seams, Nodes, Viewport, Subsurface, Modifiers, etc.

The main thing you MUST do before proceeding is watching this entire 9 part series from Blender Guru, called [Blender Beginner Tutorial Series](https://www.youtube.com/watch?v=VT5oZndzj68&list=PLjEaoINr3zgHs8uzT3yqe4iHGfkCmMJ0P). Optionally you can slowly do the [Intermediate Blender Tutorials](https://www.youtube.com/watch?v=Mwzz-Y6t-v8&list=PLjEaoINr3zgEgoyYWE0Yit-cVoZ60WGtt) later.

The Beginner Series will teach you enough that you'll finally start feeling confident with the UI and tools. And don't forget to print and hang this handy ["cheat sheet"](https://web.archive.org/web/20170708042817/https://www.blenderguru.com/articles/free-blender-keyboard-shortcut-pdf). You won't believe how much easier your life becomes once you get used to the most important keyboard shortcuts.

### Better Defaults

For historical reasons, some things are not how they should be. Knowledge in the 3D rendering field is evolving very fast.

The very first thing to do: [change](https://web.archive.org/web/20160308012834/http://wiki.blender.org/index.php/Doc:2.6/Tutorials/Rendering/Cycles) the default render engine from Blender Render to the Cycles Raytracing Engine.

Then, color grading. The default sRGB EOTF is basically wrong. You must download Sobotka's [filmic-blender](https://sobotka.github.io/filmic-blender/) configuration. If you're on Arch Linux you can basically do:

```
pacaur -S filmic-blender-git
```

I created a script at `~/bin/filmic-blender` with this:

```
env OCIO=/usr/share/blender/2.78/datafiles/filmic-blender/config.ocio blender
```

And I always start Blender from the terminal like this:

```
optirun ~/bin/filmic-blender
```

This does 2 things: first, it pre-configures OpenColorIO to use the Filmic replacement. Second, it enables the external GPU of my notebook to be available to Blender. Read my post on ["Enabling Optimus NVIDIA GPU on the Dell XPS 15 with Linux, even on Battery"](http://www.akitaonrails.com/en/2017/03/14/enabling-optimus-nvidia-gpu-on-the-dell-xps-15-with-linux-even-on-battery) for more details. On Windows or Mac this is not necessary, but you'll still need to load the filmic configuration.

Then, on the Scene tab you must reconfigure "Color Management" to be like this:

![Color Management](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/636/Screenshot_from_2017-06-21_16-31-05.png)

Then you need to configure Cycles. If you're on Linux and Optimus is correctly installed as I explained before, you should have the CUDA option enabled in the User Preferences:

[![System preferences](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/637/Screenshot_from_2017-06-21_16-43-29.png)](https://web.archive.org/web/20181118204134/https://docs.blender.org/manual/en/dev/preferences/system.html)

In the Render tab, you should have something like this:

![Render configuration](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/638/Screenshot_from_2017-06-21_16-45-32.png)

In the Dimensions section, you'll notice it has the Full HD (1920x1080 px) size but only 50% (so it will only render half the size). Increase it to 100%. If you want a 4K shot, increase the dimensions to 3840x2160 px. 4K makes it 4 times slower to render than 1080p, obviously.

In the Performance section you'll see 2 input fields for "Tile size". Blender will slice your full image into tiles, and each tile renders in parallel on an available CPU or GPU core. My notebook has 8 CPU cores, so 64 is a good size, because it will render 8 tiles of 64 pixels each in parallel.

The fewer cores you have, the larger you should make the tile sizes. For my NVIDIA GPU, I only have 2 available cores (and not a lot of video memory either!), so it's worth bumping both fields to 512. On the GPU it only renders 2 tiles at once, and larger tiles optimize the render.

As you probably guessed, Blender Guru has a very useful ["18 ways to speed up Cycles Rendering"](https://www.youtube.com/watch?v=8gSyEpt4-60&t=204s) tutorial.

These should cover the basic defaults.

### You must think as a Photographer!

You will want to watch A LOT of online tutorials, because it's really not obvious how to best use the tools. Another channel I really like is [BornCG](https://www.youtube.com/watch?v=lY6KPrc4uMw&list=PLda3VoSoc_TR7X7wfblBGiRz-bvhKpGkS) and [CG Masters](https://www.youtube.com/channel/UCCxay0KiyLlawfgoZ2mVnNQ). Pick a few of their videos to get a more in-depth view on specific tools, modeling techniques and so on.

And really, you must practice as much as possible while studying a lot along the way. One important area is Photography. This is what you see when you select the Camera tab:

![Camera settings](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/639/Screenshot_from_2017-06-21_16-55-09.png)

There's a lot of customization you can do here. For example: Focal length: 35.00, which is what photographers know as a 35mm lens, a good default choice. You can also use a really wide angle such as 200mm or 300mm, and indoor shots, in small rooms, could use a 24mm or even 18mm lens. This article ["Understanding Color Lenses"](http://www.cambridgeincolour.com/tutorials/camera-lenses.htm) should give you the basics.

Then, you must understand "Depth of Field". This can be done at this configuration before rendering, or you can simulate it after rendering (if you chose to separate the render in layers), in the [Compositor](https://web.archive.org/web/20160308021547/http://wiki.blender.org/index.php/Doc:2.6/Tutorials/Composite_Nodes/Setups/Depth_Of_Field).

Speaking of which, another way to control Depth of Field is reconfiguring "f-stop", which is the measurement of exposure, or aperture. The default is "128.0", which is "f/128". As a reference, your iPhone 7s camera has an f/2.2 aperture. Again, let's study more about this starting with the article ["What's the Best F-Stop?"](https://www.bhphotovideo.com/explora/photography/tips-and-solutions/what%E2%80%99s-best-f-stop)

Taking a photo (or rendering a still, in our case) is a whole lot more than just point-and-click. You also have to worry about proper composition techniques such as the [Rule of Thirds](http://www.photographymad.com/pages/view/rule-of-thirds), the [golden ratio](http://www.makeuseof.com/tag/golden-ratio-photography/), and so on. You can change that in the "Composition Guides" combo box as shown above.

![Golden Ratio Composition](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/641/3911f4657078a19b4f3677a304e7451d.jpg)

You really should dive deep into the field of Photography to improve the final result of the renders. I'm an amateur and it's really exciting to be able to apply real world techniques to 3D rendering.

### Material Design and Physically-Based Render (PBR)

The golden standard in 3D modeling and rendering is certainly [Disney/Pixar RenderMan](https://renderman.pixar.com/view/renderman). Every award winning Pixar movie was made with it.

But Blender learns fast. Every Pixar paper eventually becomes part of Blender itself. Material design, for example, has always been quite cumbersome in the tool. I did some of the tutorials myself, and creating materials with the proper real world characteristics, like proper Fresnel and the right dielectric versus metallic distinction, was a challenge.

If you subscribed to Blender Guru's channel you should really watch the tutorials ["How to Make Photorealistic PBR Materials - Part 1"](https://www.youtube.com/watch?v=V3wghbZ-Vh4&t=2668s) and ["Part 2"](https://www.youtube.com/watch?v=m1PkSViBi-M). And you will end up with this complicated Nodes configuration for PBR materials:

![PBR Materials - Node Editor](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/640/Screenshot_from_2017-06-21_17-25-46.png)

And Blender Guru just posted a new video introducing a feature for the upcoming Blender 2.79 (currently at 2.78): the implementation of the ["Physically-Based Shader at Disney"](https://disney-animation.s3.amazonaws.com/library/s2012_pbs_disney_brdf_notes_v2.pdf) paper as a proper and optimized new Blender Shader named "Principled Shader". It's quite literally the [Ultimate Shader](https://www.youtube.com/watch?v=4H5W6C_Mbck), because it makes creating and customizing realistic materials **very** easy, and compatible with Renderman and Substance.

### Conclusion

I am still a beginner at Blender, there is a very long road to walk here. But it's a very exciting environment and I am learning tons of new and useful stuff all the time. Anyone should try it!

Over time I hope I find the time to integrate the Blender workflow with other tools such as Unreal Engine or Unity3D to create interactive stuff as well.

This is by no means a complete tutorial or reference. The idea was to highlight a few things that are not immediately obvious when you start with Blender and that can give you a broader sense of what Blender can do.

If you want to go really in-depth in the customization, watch this CG Master setup video:

{{< youtube id="-_BZasG_UDA" >}}
