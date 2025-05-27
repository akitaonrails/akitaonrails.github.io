---
title: The Year of Linux on the Desktop, by Microsoft ??
date: '2016-04-12T18:33:00-03:00'
slug: the-year-of-linux-on-the-desktop-by-microsoft
tags:
- off-topic
- microsoft
- ubuntu
draft: false
---

So, it's finally here. I wrote about the announcement at the Build event a few days ago [here](http://www.akitaonrails.com/2016/03/31/war-is-over-or-is-it-a-new-dawn-for-microsoft). Now Microsoft is teasing us a bit more by [releasing the first Insider Build Preview](http://thehackernews.com/2016/04/how-to-run-ubuntu-on-windows-10.html). It is labeled "Build 14316.rs1_release.160402-2217" to be exact, be sure to have this one.

To get it, you must have the following requirements:

* Have an activated Windows 10 64-bits
* Sign up for the [Windows Insider](https://insider.windows.com/) Program. If it's your first time it can take up to 24 hours to activate
* In your Windows Update Settings, Advanced Options, you must choose to "Get Started" in the Inside option and also choose the "Fast" Ring option. Now, when you Check for Updates, the Preview 14316 should show up. If not, wait until your account is refreshed by Microsoft.

[![windows update settings](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/538/big_windows_update_settings.jpg)](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/538/windows_update_settings.jpg)

You must have, at the very least, 10GB of available space in your main partition, so keep that in mind. Another caveat, if you're like me and you're testing under Virtualbox, also bear in mind that to resize a virtual drive you must delete your snapshots, and the merging process can take a ridiculously  long time.

Once it's installed, you must go to the Developer options in the "Update & Security" Control Panel and change your profile to "Developer Mode". This "Bash on Windows" feature will show up under the Windows Features list. It's intended for **developers only** not to be used in production servers.

Once you have the Preview installed you must be able to fire up the old cmd.exe console (or any other better console such as [ConEmu](https://conemu.github.io/)) and type in "bash", it will prompt you to now install the userland Canonical packaged for Ubuntu. Takes another while. The whole process take a lot of time, by the way, so make sure you reserve half a day at least. Don't do it at work :-)

One problem I stumbled upon right away is that networking was not working properly. Someone [narrowed it down](https://github.com/Microsoft/BashOnWindows/issues/35) to DNS not being added to <tt>/etc/resolv.conf</tt> so you must add it manually. Just add the Google DNS (8.8.8.8 and 8.8.4.4) to the resolv.conf file and you're up.

Finally, you should be inside bash, as a root user. So, if you're a Windows user, you must know right now that it's insecure and an anti-practice to run as root, so don't do it.

The very first thing you **must** do is manually create an unprivileged Linux user and add it to the sudo group as Andrew Malton [blogged](http://blog.greenarrow.me/elixir-with-ubuntu-for-windows/) first:

```
useradd new_username -m -s /bin/bash 
passwd new_username
usermod -aG sudo new_username
```

Then you can log into this user shell with <tt>su - [your user]</tt> everytime!

From here, we can assume it's a plain Ubuntu 14.04 and you should be able to follow [my very old post](http://www.akitaonrails.com/2015/01/28/ruby-e-rails-no-ubuntu-14-04-lts-trusty-tahr) on how to setup a developer Ubuntu environment, or any other tutorial you can find over Google. These basic development packages that I always install first all run:

```
sudo apt-get install curl build-essential openssl libcurl4-openssl-dev libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev libgmp-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion redis-server libhiredis-dev memcached libmemcached-dev imagemagick libmagickwand-dev exuberant-ctags ncurses-term ack-grep git git-svn gitk ssh libssh-dev

sudo dpkg-divert --local --divert /usr/bin/ack --rename --add /usr/bin/ack-grep
```

This should give you all compilation toolchain essentials as well as some well known command line tools such as ack (way better than grep). It also adds Redis and Memcached. They all run.

As good practice you should add the following to your <tt>/etc/bash.bashrc</tt> configuration file:

```
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
```

And after that you should also configure locale to UTF-8:

```
sudo locale-gen en_US.UTF-8
sudo dpkg-reconfigure locales
```

Just to warm up a little bit, we can start with one of the things that were impossible in Windows: get a stable Ruby installation. For that, RVM is said to not work (as ZSH is also not working for /dev/pts and symlink problems in this preview, see more below). But RBENV is working! You must [install it](https://github.com/rbenv/rbenv) first and they the [ruby-build](https://github.com/rbenv/ruby-build#readme) plugin:

[![installing ruby through rbenv](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/536/big_installing_ruby.png)](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/536/installing_ruby.png)

Interestingly, it takes a lot of time to complete and during the process CPU usage goes to the roof. Installing Go is even longer! Something is still unstable underneath as it shouldn't take the CPU to 100% for so long.

![CPU through the roof](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/537/big_resources.jpg)

If I check how much memory I have in the system it's more clear:

```
root@localhost:/mnt/c/Users/fabio# free -h
             total       used       free     shared    buffers     cached
Mem:          1.0G       342M       664M         0B         0B         0B
-/+ buffers/cache:       342M       664M
Swap:           0B         0B         0B
```

I am not sure if this is somehow just a "hard-coded" value for memory as many people are reporting the same "664M" free regardless of what we are running. But something is incomplete here. Swap is also zero and you can't add any as far as I can tell. Swapon, fallocate, none of those work yet.

```
root@localhost:/mnt/c/Users/fabio# swapon -s
swapon: /proc/swaps: open failed: No such file or directory

root@localhost:/mnt/c/Users/fabio# fallocate -l 4G swapfile
fallocate: swapfile: fallocate failed: Invalid argument
```

I actually tried to [create a swap file](https://www.digitalocean.com/community/tutorials/how-to-add-swap-on-ubuntu-14-04) using <tt>dd</tt> instead of <tt>fallocate</tt> and add it to the <tt>/etc/fstab</tt> but it didn't work:

```
root@localhost:/mnt/c/Users/fabio# free -m
             total       used       free     shared    buffers     cached
Mem:          1006        342        664          0          0          0
-/+ buffers/cache:        342        664
Swap:            0          0          0

root@localhost:/mnt/c/Users/fabio# cat /etc/fstab
LABEL=cloudimg-rootfs   /        ext4   defaults        0 0
/swapfile       none    swap    sw      0 0
```

So it sounds like memory is "hard-coded". Follow [this issue #92](https://github.com/Microsoft/BashOnWindows/issues/92) if you want to know how it develops out.

But worse than that, shared memory has very low limits and strange behavior. Postgresql will install but won't start up at all:

```
root@localhost:/mnt/c/Users/fabio# pg_createcluster 9.3 main --start
Creating new cluster 9.3/main ...
  config /etc/postgresql/9.3/main
  data   /var/lib/postgresql/9.3/main
  locale en_US.UTF-8
FATAL:  could not create shared memory segment: Invalid argument
DETAIL:  Failed system call was shmget(key=1, size=48, 03600).
HINT:  This error usually means that PostgreSQL's request for a shared memory segment exceeded your kernel's SHMMAX parameter, or possibly that it is less than your kernel's SHMMIN parameter.
        The PostgreSQL documentation contains more information about shared memory configuration.
child process exited with exit code 1
initdb: removing contents of data directory "/var/lib/postgresql/9.3/main"
Error: initdb failed
```

And if we try to expand the SHMMAX limit this is what we get:

```
root@localhost:/mnt/c/Users/fabio# sysctl -w kernel.shmmax=134217728
sysctl: cannot stat /proc/sys/kernel/shmmax: No such file or directory

root@localhost:/mnt/c/Users/fabio# echo 134217728 >/proc/sys/kernel/shmmax
bash: /proc/sys/kernel/shmmax: Operation not permitted
```

So, no Postgresql for the time being. Some people were able to complete the Go Lang installation (I gave up after a very very long time waiting for apt-get to finish) complained that Go also crashed on shared memory requirements. Follow the [Issue #32](https://github.com/Microsoft/BashOnWindows/issues/32) and [Issue #146](https://github.com/Microsoft/BashOnWindows/issues/146) to see if anyone can make it work.

I also tried to install Node.js. No lucky with package installs:

```
curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
...
E: dpkg was interrupted, you must manually run 'sudo dpkg --configure -a' to correct the problem.
Error executing command, exiting
```

NVM installs, sort of, with many errors in git:

```
...
error: unable to create file test/slow/nvm run/Running "nvm run 0.x" should work (No such file or directory)
error: unable to create file test/slow/nvm run/Running "nvm run" should pick up .nvmrc version (No such file or directory)
error: unable to create file test/slow/nvm use/Running "nvm use iojs" uses latest io.js version (No such file or directory)
error: unable to create file test/slow/nvm use/Running "nvm use node" uses latest stable node version (No such file or directory)
error: unable to create file test/slow/nvm use/Running "nvm use v1.0.0" uses iojs-v1.0.0 iojs version (No such file or directory)
error: unable to create file test/slow/nvm use/Running "nvm use" calls "nvm_die_on_prefix" (No such file or directory)
```

And this is what happens if I try to install the most recent version:

```
akitaonrails@localhost:~/.nvm$ nvm install 5.10.1
Downloading https://nodejs.org/dist/v5.10.1/node-v5.10.1-linux-x64.tar.xz...
######################################################################## 100.0%
tar: bin/npm: Cannot create symlink to ‘../lib/node_modules/npm/bin/npm-cli.js’: Invalid argument
tar: Exiting with failure status due to previous errors
Binary download failed, trying source.
######################################################################## 100.0%
Checksums empty
tar: bin/npm: Cannot create symlink to ‘../lib/node_modules/npm/bin/npm-cli.js’: Invalid argument
tar: Exiting with failure status due to previous errors
Binary download failed, trying source.
Detected that you have 1 CPU thread(s)
Number of CPU thread(s) less or equal to 2 will have only one job a time for 'make'
Installing node v1.0 and greater from source is not currently supported
```

[Issue #9](https://github.com/Microsoft/BashOnWindows/issues/9) points to non-implemented symlink support.

Another very annoying thing is the lack of Pseudo-Terminals (/dev/pts), this is possibly one of the reasons ZSH won't work. Follow [Issue #80](https://github.com/Microsoft/BashOnWindows/issues/80).

You should also be able to copy over your SSH private keys to ".ssh" and start git cloning from Github or git push-ing to Heroku in no time.

```
akitaonrails@localhost:~$ ssh-keygen  -t rsa
Generating public/private rsa key pair.
Created directory '/home/akitaonrails/.ssh'.kitaonrails/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/akitaonrails/.ssh/id_rsa.
Your public key has been saved in /home/akitaonrails/.ssh/id_rsa.pub.
The key fingerprint is:
f8:16:b1:be:85:31:0c:71:f8:c2:d3:72:ab:48:42:9a akitaonrails@localhost
The key's randomart image is:
+--[ RSA 2048]----+
|      ...        |
|      .o         |
|     ..o.        |
|  .   =++o       |
| +    .=S.       |
|E . .  o.=       |
|   o . .= .      |
|    . .. o       |
|        .        |
+-----------------+
```

At least, Elixir does seem to work:

```
akitaonrails@localhost:~$ iex
Erlang/OTP 18 [erts-7.3] [source-d2a6d81] [64-bit] [async-threads:10] [hipe] [kernel-poll:false]

Interactive Elixir (1.2.3) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> defmodule HelloWorld do; def say(name) do; IO.puts("Hello #{name}"); end; end
iex:1: warning: redefining module HelloWorld
{:module, HelloWorld,
 <<70, 79, 82, 49, 0, 0, 5, 240, 66, 69, 65, 77, 69, 120, 68, 99, 0, 0, 0, 147, 131, 104, 2, 100, 0, 14, 101, 108, 105, 120, 105, 114, 95, 100, 111, 99, 115, 95, 118, 49, 108, 0, 0, 0, 4, 104, 2, ...>>,
 {:say, 1}}
iex(2)> HelloWorld.say("Fabio")
Hello Fabio
:ok
```

Not so fast ...

```
akitaonrails@localhost:~$ mix new ex_test
** (ErlangError) erlang error: :terminated
    (stdlib) :io.put_chars(#PID<0.25.0>, :unicode, [[[[[[[] | "\e[32m"], "* creating "] | "\e[0m"], ".gitignore"] | "\e[0m"], 10])
    (mix) lib/mix/generator.ex:26: Mix.Generator.create_file/3
    (mix) lib/mix/tasks/new.ex:76: Mix.Tasks.New.do_generate/4
    (elixir) lib/file.ex:1138: File.cd!/2
    (mix) lib/mix/cli.ex:58: Mix.CLI.run_task/2
```

You will find more information on the pseudo-project Microsoft opened over Github to keep track of [Issues](https://github.com/Microsoft/BashOnWindows/issues?q=is%3Aissue+is%3Aclosed) from testers like me. You can follow the list of opened and closed issues there. You will see many things that work, but also many other things that won't work until a new release is available to fix everything I mentioned here.

### Conclusion

So, is "Bash on Windows" a good development environment for Linux users to have over Windows?

As far as Preview 14316, not yet. The keyword here is "yet". It's shaping up nicely, if they can actually fix all the issues opened so far, it will be very usable very fast.

We need proper memory controls, a well implemented pseudo-terminal support, proper shared memory controls, proper symlinks, proper upstart from Ubuntu so the installed services suchs as Redis or Memcached (which I installed and run) can be properly restarted when I boot the environment (they don't come up if I boot the machine, for example).

[Some people](http://www.neowin.net/news/bash-plus-windows-10-equals-linux-gui-apps-on-the-windows-desktop) went as far as being able to trick X11 and run GUI apps such as Firefox and even XFCE over this environment already, so it's really promising. This idea does work.

Once those issues are ironed out, yes, I believe we are closer than ever to finally use Windows as a viable and full featured development environment. Let's see if by the Windows 10 Anniversary Release in June we will have a stable Ubuntu installation.

One thing that I think they did very wrong was to tie the Linux Subsystem to the Windows 10 installation. It should've been a separated installer, so the team can release build updates without having to bundle it all together with the entire Windows OS.

If you were intending to move to Windows for your Linux-based developments, not yet. Hold your horses a bit longer.
