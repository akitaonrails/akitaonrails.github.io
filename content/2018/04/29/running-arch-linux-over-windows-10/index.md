---
title: Running Arch Linux over Windows 10!
date: '2018-04-29T22:06:00-03:00'
slug: running-arch-linux-over-windows-10
tags:
- archlinux
- wsl
- asdf
- microsoft
- windows
- vmware
draft: false
---

Ok, anyone that has been reading my blog for the past year or two knows how I [enjoy Arch Linux](http://www.akitaonrails.com/archlinux) (in particular Manjaro Gnome).

I am also still very much intrigued by the idea of Windows Subsystem for Linux (or WSL) which properly debuted in the [Windows 10 Anniversary Edition](http://www.akitaonrails.com/2016/07/26/the-year-of-linux-on-the-desktop-it-s-usable) back in mid-2016.

It's been almost 2 years and we're expecting some significant updates to WSL compatibility and performance for the next [Spring Creators Update](https://winaero.com/blog/command-line-wsl-improvements-windows-10-version-1803/) (or version 1803) scheduled to arrive on April 30, 2018. This brings it closer to make WSL actually usable for professional programmers. Just to give you an idea, right now you will have orders of magnitude better performance if you run your favorite Linux distro inside Virtualbox or VMWare Workstation.

Moreover, out of the box the "Bash for Windows" proper only officially supports Ubuntu, Fedora, and OpenSuse I guess. Most people will just install Ubuntu. And it works ok. For a toy and cool demonstration purposes, it works. But it really frustrates me that I can do so much but I can't actually use it as my daily driver. It's like being able to carry the fully built prototype of the next iPhone but no 4G support yet. So it's just a toy.

Bear with me here, if you want to just see how is the performance compared to my VMWare setup, go straight to the end of the article.

Anyway, in the case of distros. Serious Linux users would prefer better alternatives. Enter this GitHub repository:

[![screenfetch of arch](https://raw.githubusercontent.com/wiki/yuk7/WSL-DistroLauncher/img/Arch_Alpine_Ubuntu.png)](https://github.com/yuk7/ArchWSL)

You just download [this zip file](https://github.com/yuk7/ArchWSL/releases/latest), unzip it and run the included `Arch.exe`. And that's about it!

Now, you can go ahead and open the Windows version of "Bash" and we can bootstrap the rest of the installation setup from there.

We must get Pacman and some AUR manager. To start Pacman, we must do this:

```
pacman-key --init
pacman-key --populate
pacman -Syu
```

Hell yeah, Pacman running natively on Windows!! Who would've known??

![pacman on windows](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/674/big_IMG_20180429_174518.jpg)

This will bring everything up to date. Next up, we must create a non-root user:

```
useradd -m your_user
passwd your_user
EDITOR=nano visudo
```

Look for the line that says `root   ALL=(ALL) ALL` and add your user right on the next line like this:

```
your_user   ALL=(ALL) ALL
```

Finally, we should login as this user:

```
su your_user
```

Next up, let's install Yaourt so we can use it to install Pacaur (this is a personal preference, you can just use Yaourt. I think Yaourt prompts too much, that's why I prefer Pacaur).

Start by editing your `/etc/pacman.conf` file with your favorite editors like vim or nano.

Just add the following section to the very bottom of the file:

```
[archlinuxfr]
SigLevel = Never
Server = http://repo.archlinux.fr/$arch
```

Before we can proceed, we have one small problem. WSL still has no support for SYSV IPC. This is required for [fakeroot](https://unix.stackexchange.com/questions/9714/what-is-the-need-for-fakeroot-command-in-linux), which is required by `makepkg` (which cannot run as root).

To overcome this problem, this is what we'll have to do:

```
wget https://github.com/yuk7/arch-prebuilt/releases/download/17121600/fakeroot-tcp-1.22-1-x86_64.pkg.tar.xz
sudo pacman -U fakeroot-tcp-1.22-1-x86_64.pkg.tar.xz
```

And that's it for now! Until WSL add proper support for SYSV IPC, we can use this. Yaourt itself will probably prompt you to install `fakeroot-tcp` on top of it, just let it.

As I said, Yaourt is quite verbose in its many prompts for confirmations. Rule of thumb, whenever it prompts if you want to edit anything, just say "N"(o). Whenever it prompts you if you want to build or install something, just say "Y"(es). If you got annoyed with me, do this:

```
yaourt -S pacaur
```

From now on, I will assume you have Pacaur.

### Graphical User Interface Support

Now, let's install some of the basics for a development environment:

```
sudo pacman -S base base-devel gvim git
```

It will prompt you sometimes "default: all", just install everything. Hard disk space should not be a concern in 2018.

I prefer to have a full-on GNOME 3 environment, so I just do:

```
sudo pacman -S gnome
```

Again, let it install everything it wants. Everybody has a different taste when it comes to GUIs, some prefer KDE5, other prefer XFCE4. Some even go as far as using the tile-based GUI [i3](https://i3wm.org/).

That requires some serious adapting. It's for people that like to do stuff like using a tenkeyless keyboard with nothing written in the keycaps and using an alien layout like  DVORAK or [Colemak](https://colemak.com/) (yikes!). Taste is taste. And I dare you to become a touch typist using [Maltron](https://www.maltron.com/the-maltron-letter-layout-advantage.html), I double dare ya! :-D

But, I digress. Now, you can add this to your `/etc/.bashrc` file or the global `/etc/environment` file:

```
echo "export LIBGL_ALWAYS_INDIRECT=1" >> /etc/.bashrc
echo "export DISPLAY=:0" >> /etc/.bashrc
```

Export those to your current shell, or just close and reopen Bash.

We can have a full GUI environment by installing a local X Server. You have 2 options, Xming and VcXSrv. I am having trouble resizing windows in Xming, so I am recommending [VcXSrv](https://sourceforge.net/projects/vcxsrv/) instead. Just download and install it as you would with any Windows application and start it up. It will add a Desktop shortcut named "XLaunch", just fire it up.

And finally, we can install a **PROPER** usable terminal instead of that poor contraption derived from old cmd.exe that WSL provides you out of the box.

```
pacaur -S tilix-bin
tilix
```

If you've been a Mac user, you probably know iTerm2, which is possibly the best Terminal emulator I've ever used. There is nothing else that comes close. Nothing, except possibly [Tilix](https://gnunn1.github.io/tilix-web/) (previously known as Terminix).

Just for having "Ctrl-Alt-D" to split the terminal horizontally down and "Ctrl-Alt-R" to split it vertically to the right, and using "Alt-1", "Alt-2", and so on to switch between the terminals, it's great for me. It also comes pre-installed with very nice themes such as the now classic Solarized Dark or my current favorite Monokai Dark.

Don't curse me, I know. Some will prefer the default terminal app and just add TMUX. Again, taste (it's more useful if I were working on a remote server).

Add the Hack monotype font to make everything more pleasing to the eye:

```
sudo pacman -S ttf-hack
```

### Programming Languages

Let's see if the most important languages out there install correctly. As I always say, look no further than ASDF for that task.

```
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.4.3
echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bashrc
echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc
```

Restart your terminal and continue:

```
asdf plugin-add nodejs
addf plugin-add ruby
```

For Node.js you must add the proper GPG keys and only then you can install:

```
bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
asdf install nodejs 10.0.0
asdf global nodejs 10.0.0
```

Ruby benefits with jemalloc to allocate less system memory. I have no idea if it impacts WSL but let's do it anyway:

```
sudo pacman -S jemalloc
RUBY_EXTRA_CONFIGURE_OPTIONS="--with-jemalloc" asdf install ruby 2.5.1
asdf global ruby 2.5.1
gem install bundler
```

![ruby compiles](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/675/big_IMG_20180429_193432.jpg)

So far so good, if you need to install an old Ruby (< 2.4) for legacy projects, you must do:

```
pacaur -S openssl-1.0
PKG_CONFIG_PATH=/usr/lib/openssl-1.0/pkgconfig RUBY_EXTRA_CONFIGURE_OPTIONS="--with-openssl-dir=/usr/lib/openssl-1.0" asdf install ruby 2.3.3
```

Unfortunately it needs a version of OpenSSL that you should not be using due to security problems. We all moved on to 1.1. But Ruby 2.3.x reached its EOL (end of line). So it's at your own risk to keep using it.

Well, so far so good. Can we install Go as well? Let's see:

```
asdf plugin-add golang
asdf install golang 1.9.5
asdf global goland 1.9.5
```

We can keep going, but I think you got the idea. It just works!

### Background Jobs

Again, another current limitation of WSL (that we expect to see fixed on the Spring Creators Update) is the ability to start and keep running background jobs (daemons).

Just doing `sudo systemctl enable postgresql` and restarting won't automatically start Postgresql in the background as it should. This Arch.exe thing we're using won't even have systemd.

Fortunately, servers such as Postgresql or Redis do work normally, they can be started as user-level processes, and they do properly bind to their respective TCP ports. But, you will have to manually start them in every session. Close your Bash terminal and they are all killed off.

For example, Postgresql:

```
[your_user]# sudo pacman -S postgresql
[your_user]# sudo mkdir -p /run/postgresql
[your_user]# sudo chown -R postgres:postgres /run/postgresql

[your_user]# sudo -u postgres -i
[postgresql]# initdb --locale $LANG -E UTF8 -D '/var/lib/postgres/data'

[postgresql]# pg_ctl -D /var/lib/postgres/data start
waiting for server to start....2018-04-29 23:30:35.483 UTC [1064] LOG:  listening on IPv4 address "127.0.0.1", port 5432
2018-04-29 23:30:35.505 UTC [1064] LOG:  listening on Unix socket "/run/postgresql/.s.PGSQL.5432"
2018-04-29 23:30:35.583 UTC [1065] LOG:  database system was shut down at 2018-04-29 23:23:48 UTC
2018-04-29 23:30:35.660 UTC [1064] LOG:  database system is ready to accept connections

[postgresql]# createuser --interactive
Enter name of role to add: your_user
Shall the new role be a superuser? (y/n) y

[postgresql]# exit
[your_user]#
```

See what I did here? There is a small problem in the install under WSL where the `/run/postgresql` is not created with the correct permissions. Fixing that we can start the server. We can exit out of the `su` session and the postgresql server will keep running. But when we close the first Bash window/session, it will die.

And another very annoying thing? The `mkdir` and `chown` fixes above? I have to do it every single time I close the Bash for Windows app and start it again!! Super duper annoying if you ask me!

But, we can live with it for now. Hopefully, this will be fixed tomorrow (April 30) or in an upcoming upgrade. 

In a Rails development environment, we can take advantage of [Foreman](https://github.com/theforeman/foreman) to help us out. Just edit some `Procfile.dev` file:

```
web: bundle exec puma -C config/puma.rb -p 3000
db: su postgres -c 'pg_ctl start -D /var/lib/postgres/data'
redis: redis-server /usr/local/etc/redis.conf
mailcatcher: mailcatcher -f
```

Now we can do: `foreman start -f Procfile.dev` and all services will start properly at once.

### Real World Performance

My daily driver is Manjaro GNOME under VMWare Workstation Pro on my Surface Book 2. I give it 6 threads out of the 8 and a hefty 12GB of RAM out of the total 16GB (damn Microsoft, we need more RAM nowadays that the cool kids deploy stupid ass Apps with heavy JS/CSS coating that eats up all available RAM).

In the project I am currently working, my full RSpec suite is a bit on the slow side. For this comparison, I am skipping all my feature specs as I am in no mood to tweak chrome-driver to work in WSL (probably runs, but let's have it another day).

```
Finished in 12 minutes 8 seconds (files took 14.58 seconds to load)
1493 examples, 0 failures, 35 pending

531,34s user 127,56s system 88% cpu 12:24,99 total
```

In this comparable WSL environment, I have just installed, I am running the exact same RSpec suite, and this is what I get:

```
Finished in 13 minutes 43 seconds (files took 3 minutes 16.8 seconds to load)
1474 examples, 0 failures, 35 pending


455.80s user 399.14s system 83% cpu 17:04.96 total
```

For some reason, my WSL environment is skipping a few examples (seems more like an RSpec counter bug of some sort though), but I think this shouldn't pose too much of a difference in the grand scheme of things here. WSL is losing even if the counter is correct and it's running fewer examples.

When we start to really exercise the WSL a whole lot of issues start to show up. For example, PostgreSQL goes crazy and keeps stdout'ing "could not flush dirty data: Function not implemented", which is due to [this documented issue](https://github.com/Microsoft/WSL/issues/645) from the WSL! So what ends up happening is that sometimes the RSpec runner just pauses while PG tries to figure out what to do. 

You can clearly see that under VMWare files took less than 15 seconds to load. On WSL they took over 3 minutes just on file I/O! It's orders of magnitude slower. This is the bad part. When it's just CPU vs CPU, they are pretty comparable actually.

On paper, the total time is actually quite close. And CPU-wise I think WSL has an edge, which is why it's able to recover in the totals even though the I/O is clearly sluggish.

In practice what happens in a normal programming situation is that you fire up Vim, or any other text editor of your choice. Any programmer has to keep opening files and going back and forth between a lot of files. Now, I/O being super slow, every file you try to open pauses your action for a split second. And this adds up.

Within VMWare, Vim is super responsive, whenever I need to open a file, it's almost instantaneous. 

The benchmark may be hard to account for this situation. But in a normal scenario, you will end up annoyed. Moreover, running a GUI over X (VcXsrv in my case) slows things down a bit as well. From within VMWare, the normal Xorg can take advantage of being GPU accelerated. So the entire rasterization pipeline is faster.

You "can" use WSL as your daily driver. But if I can have a smoother experience from within VMWare, that's where I will be for now.

### Conclusion

I will actually hold my conclusions until tomorrow (April 30) or later this week, because if the Spring Creators Update actually fixes some performance issues. Then I can see myself using this instead of my VMWare Workstation install of Manjaro GNOME.

It may not come in this big update, but I have word that they are working on the outstanding I/O performance issues. So it's right around the corner.

Everything I need just works. Tilix, Vim, Git, Zsh, Ruby, Node.js. Everything installs as expected from Pacman and AUR. Pure Arch Linux glory! So sad the bad performance spoils it.

It's close, it's very close! For the first time in almost 15 years, I can almost see myself returning to 100% Windows (with no VMWare support) and still be able to be fully productive with real, professional, open source tools that "Just Works".

Keep an eye on this blog post for updates this week!
