---
title: Customizing Fedora 25 for Developers
date: '2017-01-06T17:11:00-02:00'
slug: customizing-fedora-25-for-developers
tags:
- linux
- fedora
draft: false
---

**Update 01/18/2017:** Right after trying out Fedora for a few days, I decided to [try Arch Linux](http://www.akitaonrails.com/2017/01/10/arch-linux-best-distro-ever) and I couldn't be happier. I recommend you try Arch too, it will probably surprise you. You may be also interested about [advanced Linux tuning for better responsiveness](http://www.akitaonrails.com/2017/01/17/optimizing-linux-for-slow-computers) on the desktop.

I've been a long time Ubuntu user. Whenever I need to setup a Linux box I go to straight to the latest LTS. Muscle memory, can't avoid it.

But to replace my macOS, Unity is damn ugly, honest. I tried to customize Cinnamon and I almost liked it, and don't even get me started on KDE or XFCE.

[GNOME 3.22](https://www.gnome.org/news/2016/09/gnome-3-22-released-the-future-is-now/), on the other hand, is very handsome. I don't need to tweak it or hack it to make it look good. The default set of global shortcuts are spot on if you're a long term macOS user. I like almost everything about it.

I've been curious about all the fuss surrounding the phase out of X.org into Wayland so I wanted to check it out.

The best distro I could find with those in mind is good old Fedora. RedHat (4) was the second Linux distro I tried after Slackware 1 back in the mid-90's. I come back and leave every couple of years. It's a good time to try it again.

The TL;DR is that I am quite delighted with [Fedora 25](https://getfedora.org/en/workstation/download/). It does almost everything I need very right out of the box.

![Fedora 25](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/578/big_Screenshot_from_2017-01-06_16-58-17.png)

I dusted off a 4 years old Lenovo ThinkCentre Edge 71z Tower desktop and Lenovo IdeaPad G400s notebook. They are, respectivelly, a 2nd generation Core i5 SandyBridge 2.5Ghz and Core i3 2.4Ghz, with 8GB of RAM in the Tower and 4GB of RAM in the notebook. For a developer's routine, they are quite good enough. A better CPU wouldn't do a whole lot.

I was very happy to see that this old tower has an old Intel graphics card with a DVI port. Fortunatelly I had an old DVI-to-HDMI cable around and I was able to hook it up to my ultrawide LG monitor 21:9 (2560x180) and it properly scaled everything (macOS Sierra had a regression that required a hack to make it work!)

What hurts a lot are the super slow mechanical hard drives (7200rpm and 5400rpm). I just ordered a RAM upgrade and 2 Crucial MX300 compatible SSD drives. When those arrive, I will have the snappiness I need.

That being said, when you have a fresh Fedora 25 install, what to do next?

### for Ubuntu users

Just remember this: instead of `apt-get` you get `dnf`. Fedora prior to version 22 used to have `yum`, but `dnf` supercedes it with basically the same command options.

You don't have the equivalent of `apt-get update` because it auto-updates. The rest is pretty much the same: `dnf install package` instead of `apt-get install package`, `dnf search package` instead of `apt-cache search package`, and so on. For a global upgrade, do `dnf upgrade` instead of `apt-get update && apt-get upgrade`.

For services, instead of doing `sudo service restart memcached` you can do `sudo systemctl restart memcached`.

That's pretty much it for the most part. Read this [wiki page](https://fedoraproject.org/wiki/Differences_to_Ubuntu) for more command differences.

### Crystal Language support

Let's say you want to learn this brand new language called "Crystal": Ruby-like familiar syntax and standard libraries but Go-like native binary generation, with fast concurrency primitives and all the benefits of an LLVM optimized binary.

You should follow [their wiki](https://crystal-lang.org/docs/installation/on_redhat_and_centos.html) [page](https://github.com/crystal-lang/crystal/wiki/All-required-libraries#fedora) but this is what you need:

---
sudo dnf -y install \
  gmp-devel \
  libbsd-devel \
  libedit-devel \
  libevent-devel \
  libxml2-devel \
  libyaml-devel \
  llvm-static \
  openssl-devel \
  readline-devel

sudo dnf -y install fedora-repos-rawhide
sudo dnf -y install gc gc-devel # get all dependencies from Fedora 25
sudo dnf -y install gc gc-devel --enablerepo=rawhide --best --allowerasing

sudo dnf -y install crystal
---

And that's it, a lot of dependencies but as it's pre-1.0 I believe they will improve this in the future.

### Ruby and Node.js support

Rubyists have a number of Rubies version control, but I personally like RVM. First, we need to install some [other requirements](http://www.socialquesting.com/blog/octopress-installation-fedora-25/) and go on with it:

---
sudo dnf -y install patch autoconf gcc-c++ patch libffi-devel automake libtool bison sqlite-devel ImageMagick-devel nodejs git gitg
curl -sSL https://rvm.io/mpapis.asc | gpg2 --import
curl -L https://get.rvm.io | bash -s stable --ruby

sudo npm -g install brunch phantomjs
---

There you go, you should have the lastest stable Ruby, Node, Npm and useful tools such as Brunch (required if you want to build Elixir-Phoenix web apps) and PhantomJS for automated acceptance tests in many languages

Notice that we're installing Git, the optional [GitG](https://git.gnome.org//browse/gitg) which is a fantastic companion to your Git routine.

![GitG](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/583/big_Screenshot_from_2017-01-06_16-59-05.png)

### Postgresql, Redis, Memcached support

What's a web app without proper databases and cache services? Let's install them:

---
sudo dnf -y install postgresql-server postgresql-contrib postgresql-devel memcached redis

sudo postgresql-setup --initdb
sudo sed -i.bak 's/ident/trust/' /var/lib/pgsql/data/pg_hba.conf # NEVER do this in production servers
sudo systemctl start postgresql

sudo su - postgres
createuser youruser -p
createdb youruser --owner=youruser
---

Change `youruser` for the username of your current user account, of course.

### Java support

This is easy, let's install the lastest [OpenJDK 8](http://www.2daygeek.com/install-java-openjdk-6-7-8-on-ubuntu-centos-debian-fedora-mint-rhel-opensuse-manjaro-archlinux/#) and web browser plugins.

---
sudo dnf -y install java-1.8.0-openjdk icedtea-web
---

### Go Support

Even easier:

---
sudo dnf -y install go
---

Do not forget to edit your profile, such as `$HOME/.profile` and add the proper environment variables:

---
export GOROOT=$HOME/go
export PATH=$PATH:$GOROOT/bin
---

### Elixir Support

There is an easy way, and a more complicated and time consuming one. Let's start with [the easy one](http://elixir-lang.org/install.html#unix-and-unix-like):

---
sudo dnf -y install erlang elixir
mix local.hex
mix local.rebar
mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez
---

The problem is that packages for distros such as Fedora can take time to come out. For example, Elixir 1.4 has been out for a couple of days, but no upgrades for Fedora yet.

Another problem if you're professionally developing Elixir projects is that you will need an Elixir version control, because you will end up getting client projects in different Elixir versions and you need to setup your environment accordingly. That's where [asdf](https://github.com/asdf-vm/asdf) comes in. You can follow [this gist](https://gist.github.com/rubencaro/6a28138a40e629b06470) but I will paste the important bits here:

---
sudo dnf -y install make automake gcc gcc-c++ kernel-devel git wget openssl-devel ncurses-devel wxBase3 wxGTK3-devel m4

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.2.1

# For Ubuntu or other linux distros
echo '. $HOME/.asdf/asdf.sh' >> ~/.bashrc
echo '. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc

# restart your terminal or source the file above:
source ~/.bashrc

asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git

asdf install erlang 19.0
asdf install elixir 1.4.0

asdf global erlang 19.0
asdf global elixir 1.4.0
---

Compiling Erlang from source will take a humongous ammount of time, specially if you're using old CPUs like me. But this is how you both have access to the latest and greatest Elixir while also having the ability to choose older versions for client projects.

By the way, you can install additional asdf plugins to version control other platforms such as Go, Rust, Node, Julia and many others. Check out [their project page](https://github.com/asdf-vm/asdf) for more details.

### Docker Support

You will probably want to have access to Docker as well, so [let's do this](https://docs.docker.com/engine/installation/linux/fedora/):

---
sudo dnf -y install docker docker-compose

# you can test if everything went ok with the infamous hello world
sudo docker run --rm hello-world
---

## Desktop Apps

Once you have everything in place, let's configure the non-terminal aspects for a better experience.

### Terminator (and Terminix)

![Terminator](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/579/Screenshot_from_2017-01-06_16-59-53.png)

Speaking of terminals, you will want to install [Terminator](https://gnometerminator.blogspot.com.br/p/introduction.html). I really don't like using screen or tmux in my local machine (I can't get around those key bindings). I am more used to iTerm2 on macOS and Terminator is pretty much the same thing with similar key bindings. You definitelly need to replace the default terminal for this one.

---
sudo dnf -y install terminator
---

You will also want to edit `~/.config/terminator/config` and add the following to make it better:

---
[global_config]
  title_transmit_bg_color = "#d30102"
  focus = system
[keybindings]
[layouts]
  [[default]]
    [[[child1]]]
      parent = window0
      type = Terminal
      profile = default
    [[[window0]]]
      parent = ""
      type = Window
[plugins]
[profiles]
  [[default]]
    use_system_font = false
    font = Hack 12
    scrollback_lines = 2000
    palette = "#073642:#dc322f:#859900:#b58900:#268bd2:#d33682:#2aa198:#eee8d5:#586e75:#cb4b16:#586e75:#657b83:#839496:#6c71c4:#93a1a1:#fdf6e3"
    foreground_color = "#eee8d5"
    background_color = "#002b36"
    cursor_color = "#eee8d5"
---

Another great options that was recommended to me is [Terminix](https://copr.fedorainfracloud.org/coprs/heikoada/terminix/). This is how you install it:

---
sudo dnf copr enable heikoada/terminix
sudo dnf -y install terminix
---

### Hack font

You will want to have a nicer font such as [Hack](https://github.com/chrissimpkins/Hack) around as well:

---
dnf -y install dnf-plugins-core
dnf copr enable heliocastro/hack-fonts
dnf -y install hack-fonts
---


### Gnome Tweak Tool

Now you will want to install **Gnome Tweak Tool** to be able to setup Hack as the default monospace font:

---
sudo dnf -y install gnome-tweak-tool
---

### Vim, Zsh, Yadr

![Vim gruvbox](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/582/big_Screenshot_from_2017-01-06_16-59-36.png)

I really like to use Vim so you can install it like this:

---
sudo dnf -y install vim-enhanced vim-X11
---

And I really like to use [YADR](https://github.com/Codeminer42/dotfiles) to customize all aspects of my ZSH and Vim:

---
sh -c "`curl -fsSL https://raw.githubusercontent.com/skwp/dotfiles/master/install.sh `"
---

I recommend you have Zsh, Vim, Ruby pre-installed before running the script above. Once you finish, I had to tweak the settings a bit:

---
sed 's/gtk2/gtk3' ~/.vim/settings/yadr-appearance.vim
---

You'd want to tweak that file as well, to add new fonts such as Hack, and right now I am more in the mood of "gruvbox" instead of "solarized" as Vim theme.

### GIMP Photoshop

![Gimp with Photoshop Theme](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/580/big_Screenshot_from_2017-01-06_17-07-14.png)

If you're a web developer you will have to edit a couple of images sometimes. And if you're like me, Gimp is a freaking usability nightmare. But [there are ways](http://www.omgubuntu.co.uk/2016/08/make-gimp-look-like-photoshop-easy) to make it a bit [more palatable](https://github.com/doctormo/GimpPs).

---
sudo dnf -y install gimp
sh -c "$(curl -fsSL https://raw.githubusercontent.com/doctormo/GimpPs/master/tools/install.sh)"
---

There you go, a Photoshop-like theme for Gimp to make it less ugly.

### Spotify

What would we, developers, be without music to concentrate?

---
dnf config-manager --add-repo=http://negativo17.org/repos/fedora-spotify.repo
dnf -y install spotify-client
---

### CoreBird

![CoreBird](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/581/big_Screenshot_from_2017-01-06_17-08-43.png)

I am so glad that someone built a very competent and elegant Twitter client for Linux. Install CoreBird:

---
dnf -y install corebird
---

It's probably even better than the official Mac version.

### Tweaking the title bar

I found [this hack](http://blog.samalik.com/make-your-gnome-title-bars-smaller/) to try to make the Gnome title bars a bit less fat, which is about the only complaint I have for the look-and-feel so far:

---
tee ~/.config/gtk-3.0/gtk.css <<-EOF
.header-bar.default-decoration {
 padding-top: 3px;
 padding-bottom: 3px;
 font-size: 0.8em;
}

.header-bar.default-decoration .button.titlebutton {
 padding: 0px;
}
EOF
---

### Conclusion

Most of everything you need is web based, so Gmail, Slack, all work just fine. Fire up Chromium, Firefox or install [Franz](http://meetfranz.com/) or [WMail](http://thomas101.github.io/wmail/) if you have to. Unfortunatelly everything that is web based consumes a lot of RAM, and this is really bad. I do miss good old, slim, native apps. Web-based apps are a huge hassle.

They "work", but I'd rather have a good native app. On the other hand, Dropbox and Skype have really terrible client apps. They are very poorly maintained, full of bugs, and terrible support. I'd rather not have them.

I was trying to get used to Thunderbird while on Ubuntu. Geary is still not good enough. But I was surprised when I tried Evolution again. It has the only thing I really want from any email client: a damn shortcut to move emails to folders: Ctrl-Shift-V (!!) How hard can that be??

Gnome 3 has a global Online Accounts repository in the Settings where you can register social networks such as Facebook and Google, but the Google support is [buggy](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=820913). It expires everytime, so don't use Evolution with it. Add the Imap/Smtp information manually instead. Email and Calendar data is properly synced that way.

You should have all your password in a LastPass account by now. Authy is a Chrome extension, so your multi-factor authentication should also just work.

My personal bank and investment companies, with their ugly Java applets, work just fine with Chromium and IcedTea, so I'm ok there too.

I just have to figure out the easiest backup strategy to have everything really secure. On the installation process, do not forget to choose the encrypted partition option - and if you do, definitelly backup your data regularly as I've heard of bugs during upgrades that made the encrypted partitions inaccessible. Be secure and also be careful.

As usual, from my macOS the only 2 things I will really miss is Apple Keynote (it's really amazing as no one was able to make a slick and fast presentation tool as good as Keynote) and iMovie for quick video editing (although [Kdenlive](https://kdenlive.org/) is a very good alternative).

You even have built-in [shortcuts](https://wiki.gnome.org/Gnome3CheatSheet) to screen capture a window or an area and [record a screencast](https://fedoramagazine.org/taking-screencast-fedora/)!

Compared to my Ubuntu configuration, this Fedora 25 is really a pleasure to use. A competent macOS replacement. I highly recommend it!

And as I said at the update in the beginning of the post. Do check out [Arch Linux](http://www.akitaonrails.com/2017/01/10/arch-linux-best-distro-ever) and how to [optimize your distro to be more responsiveness](http://www.akitaonrails.com/2017/01/17/optimizing-linux-for-slow-computers), particularly on old hardware.
