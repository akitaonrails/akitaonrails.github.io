---
title: Starting with Blender
date: '2017-06-21T17:32:00-03:00'
slug: starting-with-blender
tags:
- off-topic
- blender
draft: false
---

Blender is a beast. A true marvel of open source technology achievement, you should applaud everyone that have been involved in making this thing work as well as it does. It rivals the most expensive commercial options out there, from Maya to the venerable Pixar's Renderman.

The Blender community is so passionate and committed that they frequently produce high quality, almost hollywood grade, [short movies](http://archive.blender.org/features-gallery/movies/) within Blender in order to stress test the tool, fix bottlenecks and usability issues in a real world workflow.

This is primarily a post intended for "future me" to be able to jump back into a single resource list. As being a 3D modeler is not my full time job, I will have large hiatus between Blender sessions and I know I will regret if I don't dump by brain into a post while  still fresh :-)

### Beginner First Steps

First things first. If you're in this blog, you're probably a programmer. And let me tell you that the Graphics folks have things very different from what we, programmers, usually think of as "usability". The sheer ammount of customization, options, shortcuts and combinations will rival even Vim and Emacs users out there.

Oh, by the way, you're required to have a proper 3-button mouse. Touchpads are useless with Blender. The Mac mouse is terrible with Blender. [Any cheap PC mouse will do.](http://www.dell.com/br/mouse) And out of the box, the main button is the right-sided one, not our usual left-sided button! You should change that in the [user preferences](https://docs.blender.org/manual/en/dev/preferences/input.html) to select with Left. Now, things start to work. While on that, you should also enable the Numpad emulation. Oh yeah, you should get a keyboard with a numpad or even a separated numpad for extra smoothness. You can use the number row on top of your normal keyboard, but Blender was built with both an inverted 3-button mouse and 

[![Input User Preferences](https://docs.blender.org/manual/en/dev/_images/preferences_input_tab.png)](https://docs.blender.org/manual/en/dev/preferences/input.html)

If you have never studied Blender before, you will not figure things out just by randomly exploring the UI. The UI is useless until someone teaches you the ins and outs. There are hundreds of terms you just have no idea what they mean, such as Meshes, Edges, Seams, Nodes, Viewport, Subsurface, Modifiers, etc.

The main thing you MUST do before proceding is watching this entire 9 part series from Blender Guru, called [Blender Beginner Tutorial Series](https://www.youtube.com/watch?v=VT5oZndzj68&list=PLjEaoINr3zgHs8uzT3yqe4iHGfkCmMJ0P). Optionally you can slowly do the [Intermediate Blender Tutorials](https://www.youtube.com/watch?v=Mwzz-Y6t-v8&list=PLjEaoINr3zgEgoyYWE0Yit-cVoZ60WGtt) later.

The Beginner Series will teach you enough so you will finally start feeling confident with the UI and tools. And don't forget to print and hang this useful ["cheat sheet"](https://www.blenderguru.com/articles/free-blender-keyboard-shortcut-pdf), you won't believe how easier your life becomes once you get used to the most important keyboard shortcuts.

### Better Defaults

For historical reasons, somethings are not how they should be. Knowledge in the 3D rendering field is evolving very fast.

The very first thing to do: [change](https://wiki.blender.org/index.php/Doc:2.6/Tutorials/Rendering/Cycles) the default render engine from Blender Render to the Cycles Raytracing Engine.

Then, color grading. The default sRGB EOTF is basically wrong. You must download Sobotka's [filmic-blender](https://sobotka.github.io/filmic-blender/) configuration. If you're in Arch Linux you can basically do:

---
pacaur -S filmic-blender-git
---

I created a script at `~/bin/filmic-blender` with this:

---
env OCIO=/usr/share/blender/2.78/datafiles/filmic-blender/config.ocio blender
---

And I always start Blender from the terminal like this:

---
optirun ~/bin/filmic-blender
---

This does 2 things: first pre-configure the OpenColorIO to use the Filmic replacement. Second it enabled the external GPU of my notebook to be availble to Blender. Read my post on ["Enabling Optimus NVIDIA GPU on the Dell XPS 15 with Linux, even on Battery"](http://www.akitaonrails.com/2017/03/14/enabling-optimus-nvidia-gpu-on-the-dell-xps-15-with-linux-even-on-battery) for more details. On Windows or Mac, this is not necessary but you will still need to load the filmic configuration though.

Then, on the Scene tab you must reconfigure "Color Management" to be like this:

![Color Management](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/636/Screenshot_from_2017-06-21_16-31-05.png)

Then you need to configure Cycles. If you're on Linux and Optimus is correctly installed as I explained before, you should have the CUDA option enabled in the User Preferences:

[![System preferences](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/637/Screenshot_from_2017-06-21_16-43-29.png)](https://docs.blender.org/manual/en/dev/preferences/system.html)

In the Render tab, you should have something like this:

![Render configuration](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/638/Screenshot_from_2017-06-21_16-45-32.png)

In the Dimensions section, you will notice that it has the Full HD (1920x1080 px) size but only 50% (so it will only render half the size). Increase it to 100%. If you want a 4K shot, increase the dimensions to 3840x2160 px. 4K makes it 4 times slower to render than 1080p, obviously.

In the Performance section you will see 2 input fields for "Tile size". Blender will slice your full image into tiles. Each tile will render in parallel in a available CPU or GPU core. My notebook has 8 CPU cores. 64 is a good size because it will render 8 tiles of 64 pixels each in parallel. The less cores you have, the larger you should make the tile sizes. For my NVIDIA GPU, I only have 2 available cores (and not a lot of video memory as well!), you should increase both fields to 512. On the GPU it will only render 2 tiles at once, so increasing it will optimize the render.

As you probably guessed, Blender Guru has a very useful ["18 ways to speed up Cycles Rendering"](https://www.youtube.com/watch?v=8gSyEpt4-60&t=204s) tutorial.

These should cover the basic defaults.

### You must think as a Photographer!

You will want to watch A LOT of online tutorials, because it's really not obvious how to best use the tools. Another channel I really like is [BornCG](https://www.youtube.com/watch?v=lY6KPrc4uMw&list=PLda3VoSoc_TR7X7wfblBGiRz-bvhKpGkS) and [CG Masters](https://www.youtube.com/channel/UCCxay0KiyLlawfgoZ2mVnNQ). Pick a few of his videos to have a more in-depth view on specific tools, modeling techniques and so on.

And really, you must exercise as much as possible while also studying a lot along the way. One important area is Photography. This is what you see when you select the Camera tab:

[![Camera settings](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/639/Screenshot_from_2017-06-21_16-55-09.png)](https://docs.blender.org/manual/en/dev/render/blender_render/camera/object_data.html)

There is a lot of customization you can do here, but for example. Focal length: 35.00. This is what photographers know as a 35mm lens. It's a good default choice. But you can use really wide angle such as 200mm or 300mm. Indoor shots, in small rooms, could use a 24mm or even 18mm lens. This article ["Understanding Color Lenses"](http://www.cambridgeincolour.com/tutorials/camera-lenses.htm) should give you the basics.

Then, you must understand "Depth of Field". This can be done at this configuration before rendering, or you can simulate it after rendering (if you chose to separate the render in layers), in the [Compositor](https://wiki.blender.org/index.php/Doc:2.6/Tutorials/Composite_Nodes/Setups/Depth_Of_Field).

Speaking of which, another way to control Depth of Field is reconfiguring "f-stop", which is the measurement of exposure, or aperture. The default is "128.0" which is "f/128". As a reference, your iPhone 7s camera has a f/2.2 aperture. Again, let's study more about this starting with the article ["What's the Best F-Stop?"](https://www.bhphotovideo.com/explora/photography/tips-and-solutions/what%E2%80%99s-best-f-stop)

Taking a photo (or rendering a still, in our case) is a whole lot more than just point-and-click. You also have to worry about proper composition techniques such as the [Rule of Thirds](http://www.photographymad.com/pages/view/rule-of-thirds), the [golden ratio](http://www.makeuseof.com/tag/golden-ratio-photography/), and so on. You can change that in the "Composition Guides" combo box as shown above.

![Golden Ratio Composition](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/641/3911f4657078a19b4f3677a304e7451d.jpg)

You really should dive deep into the field of Photography to improve the final result of the renders. I am an amateur and it's really exciting to be able to apply real world techniques into 3D rendering.

### Material Design and Physically-Based Render (PBR)

The golden standard in 3D modeling and rendering is certainly [Disney/Pixar RenderMan](https://renderman.pixar.com/view/renderman). Every award winning Pixar movie was made with it.

But Blender learns fast. Every Pixar paper eventually becomes part of Blender itself. For example, material design is one aspect that has been quite cumbersome in Blender. I did some of the tutorials myself and to create the materials with the proper real world characteristics such as proper Fresnel, proper dialectric x metallic, etc was a challenge.

If you subscribed to Blender Guru's channel you should really watch the tutorials ["How to Make Photorealistic PBR Materials - Part 1"](https://www.youtube.com/watch?v=V3wghbZ-Vh4&t=2668s) and ["Part 2"](https://www.youtube.com/watch?v=m1PkSViBi-M). And you will end up with this complicated Nodes configuration for PBR materials:

![PBR Materials - Node Editor](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/640/Screenshot_from_2017-06-21_17-25-46.png)

And Blender Guru just posted a new video introducing a new feature for the upcoming Blender 2.79 (currently at 2.78), the implementation of ["Physically-Based Shader at Disney"](https://disney-animation.s3.amazonaws.com/library/s2012_pbs_disney_brdf_notes_v2.pdf) paper as a proper and optimized new Blender Shader named "Principled Shader". It's quite literally the [Ultimate Shader](https://www.youtube.com/watch?v=4H5W6C_Mbck) as it makes creating and customizing realistic materials **very** easy, and compatible with Renderman and Substance.

### Conclusion

I am still a beginner at Blender, there is a very long road to walk here. But it's a very exciting environment and I am learning tons of new and useful stuff all the time. Anyone should try it!

Over time I hope I find the time to integrate the Blender workflow with other tools such as Unreal Engine or Unity3D to create interactive stuff as well.

This is by no means a complete tutorial or reference. The idea was to highlight a few things that are not immediatelly obvious when you start with Blender and that can give you a broader sense of what Blender can do.

If you want to go really in-depth in the customization, watch this CG Master setup video:

<iframe width="560" height="315" src="https://www.youtube.com/embed/-_BZasG_UDA" frameborder="0" allowfullscreen></iframe>
