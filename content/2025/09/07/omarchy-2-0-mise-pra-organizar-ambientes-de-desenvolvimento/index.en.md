---
title: Omarchy 2.0 - Mise for Organizing Development Environments
date: "2025-09-07T16:40:00-03:00"
slug: omarchy-2-0-mise-for-organizing-dev-environments
tags:
  - arch
  - omarchy
  - mise
  - docker
draft: false
translationKey: omarchy-mise-dev-environments
description: How to use Mise on Omarchy (or any Linux distro) to pin language versions per project and stop breaking your apps on every system update.
---

Continuing my posts about [Omarchy](https://www.akitaonrails.com/en/tags/omarchy/), here's another introductory post, this time about [Mise-en-place](https://mise.jdx.dev/getting-started.html), which already comes pre-installed. On Omarchy, if you press "Super+Alt+Space" the main menu will open. Pick "Install" and then "Development" and you'll see several languages/frameworks you can install, like Ruby on Rails or Go.

But you don't need to use these menus. Let me explain.

On a regular Arch Linux or Ubuntu, an amateur would install ruby or python doing something like this:

```
# arch
yay -S ruby python3
# ubuntu
apt install ruby python3
```

**This is the WRONG way.**

These commands will install the latest version of each language, and every time you update the system with `yay -Syu` or `apt upgrade`, they'll pull in even newer versions.

The thing is, if you develop real projects, **you don't want the versions to change**.

The version deployed on the cloud server and the version on your local machine **MUST BE THE SAME**.

If you're using Ruby v3.0.7 and Node.js 22.19.0, you can't be held hostage to the fact that when you update your system, out of nowhere Ruby 3.4.5 and Node 24.7.0 show up. Everything will start breaking and you'll be super confused without knowing why. This is the most basic mistake a junior developer makes.

To avoid this, every project you're working on MUST BE LOCKED TO FIXED VERSIONS.

The easiest way to do this in 2025 is using **MISE**. As I said, it already comes installed and activated on Omarchy, but if you're using another distro just install Mise manually:

```
yay -S mise

# .bashrc
eval $(mise activate bash)
```

Adapt this for ZSH, Fish or whatever shell you're using, read the [documentation](https://mise.jdx.dev/installing-mise.html)

Now navigate to your project directory, for example:

```
cd ~/Projects/AkitaOnRails.com
```

And lock the versions:

```
mise use ruby@3.2.3
mise use node@14.21.3
```

This will create a `.tool-versions` file that you should add to your repository's git:

```
❯ cat .tool-versions
ruby 3.2.3
nodejs 14.21.3

❯ git add .tool-versions
```

And done, every time you `cd` into the directory, Mise will activate exactly the right version for that project. Look:

```
AkitaOnRails.com [ master][$!?⇡][ v24.7.0][💎 v3.2.3]
❯ ruby -v
ruby 3.2.3 (2024-01-18 revision 52bb2ac0a6) [x86_64-linux]

AkitaOnRails.com [ master][$!?⇡][ v24.7.0][💎 v3.2.3]
❯ which ruby
/home/akitaonrails/.local/share/mise/installs/ruby/3.2.3/bin/ruby
```

Notice that, if you're using the [Starship](https://akitaonrails.com/en/2025/09/07/omarchy-2-0-zsh-configs/) prompt I explained in the previous post, with a preset like Pure Prompt, it shows the version of each language in the prompt so it's easy to see if you're on the wrong version.

In this case, if you read carefully, you've probably already noticed that **YES, I'M ON THE WRONG VERSION** of Node.js. Look how the prompt says I'm using Node 24.7.0 but the `.tool-versions` file asks for 14.21.3.

The reason it's "missing" is because this machine was recently installed, but the project is old.

So let's check:

```
AkitaOnRails.com [ master][$!?⇡][ v24.7.0][💎 v3.2.3]
❯ mise list
Tool    Version            Source                                              Requested
go      1.25.0             ~/.config/mise/config.toml                          latest
node    14.21.3 (missing)  /mnt/data/Projects/AkitaOnRails.com/.tool-versions  14.21.3
node    22.18.0
python  3.13.7
ruby    3.2.3              /mnt/data/Projects/AkitaOnRails.com/.tool-versions  3.2.3
ruby    3.4.5
```

See how in the `mise list` output it says 14.21.3 is "missing". So let's install it:

```
AkitaOnRails.com [ master][$!?⇡][ v24.7.0][💎 v3.2.3]
❯ mise use node@14.21.3
mise /mnt/data/Projects/AkitaOnRails.com/.tool-versions tools: node@14.21.3

AkitaOnRails.com [ master][$!?⇡][ v14.21.3][💎 v3.2.3]
❯
```

With the `mise use` command we can ask it to install and use a particular version. If it's not already installed, it will install it. Notice how after that the Starship prompt changed to reflect that we're now using 14.21.3. That's the right way.

If you're not necessarily in a project directory with locked versions, you can still run commands using a specific version, like this:

```
mise exec ruby@3.2.1 -- ruby ...
```

Say you want to generate a Rails project on a specific Ruby version:

```
mise exec ruby@3.2.3 -- rails new todo-exercise
```

The same goes for generators in Node, like Next.js or any other framework.

I haven't checked whether LazyVim on Omarchy comes configured this way, but in case it doesn't, for NeoVim to support Mise you need to add this:

```lua
-- Prepend mise shims to PATH
vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH
```

Just put this in `~/.config/nvim/lua/config/mise.lua` and it should load the correct path. To integrate with other editors, check [this documentation](https://mise.jdx.dev/ide-integration.html). There are TONS of advanced options and it's worth reading about them in the [Dev-Tools section](https://mise.jdx.dev/dev-tools/), but the basics are what I listed here.

## And databases??

The same goes for databases. Every project should be locked to a specific version identical to what's running on the production server and should never depend on operating system packages. You can use mise for this but the most recommended option is to use Docker. Every project **MUST** have a `docker-compose.yml` to spin up only the databases. You don't need to spin up containers for languages, for that it's better to use Mise.

If you don't understand Docker, I made videos teaching it:

{{< youtube id="85k8se4Zo70" >}}

</br>

{{< youtube id="-yGHG3pnHLg" >}}

Adding up Mise + Docker Compose + LazyVim, that's everything you need to be a productive web developer, while also using your machine's resources efficiently. Every developer NEEDS to learn this combo of options. Omarchy already brings it all pre-installed, which is why it's been my recommendation for every beginner.

Don't worry: Arch Linux (with archinstall) is as easy to install as an Ubuntu or Linux Mint, and Omarchy's Hyprland is much prettier and smoother than MacOS. The best of both worlds. Learn it today!
