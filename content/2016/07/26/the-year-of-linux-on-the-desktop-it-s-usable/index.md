---
title: The Year of Linux on the Desktop - It's Usable!
date: '2016-07-26T14:13:00-03:00'
slug: the-year-of-linux-on-the-desktop-it-s-usable
tags:
- microsoft
- off-topic
draft: false
---

07/23/16: coincidentally I posted this review a day before of the final release :-) So the final build is 14393 and [it's available](http://arstechnica.com/information-technology/2016/07/windows-10-anniversary-update-is-ready-to-go-and-free-for-just-a-few-more-days/) for free right now!

It's been 3 months since I posted [my initial impressions](http://www.akitaonrails.com/2016/04/12/the-year-of-linux-on-the-desktop-by-microsoft) on Windows 10 Anniversary Edition most important feature: Bash on Windows. My conclusion at the time was that it was not ready for prime time yet.

My conclusion as of right now, on July 26th is that it's finally usable enough for web developers, particularly for Ruby developers who always suffered through lack of Windows support.

![It's alive!](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/543/big_Screen_Shot_2016-07-26_at_13.28.48.png)

Installation process is the same. You must be signed up to the [Windows Insider](http://www.howtogeek.com/249966/how-to-install-and-use-the-linux-bash-shell-on-windows-10/) program, wait at least one day if this is your first time. Enable the **Fast ring** of updates, install the Preview edition from normal Windows Update and then turn on the "Windows Subsystem for Linux (Beta)" feature.

> Last time I was testing Windows 10 over Virtualbox over Ubuntu 14.04 on a Dell Inspiron notebook (8 cores i7 with 16GB of RAM). It was super slow, I don't recommend at all. Now I am back on my trustworthy Macbook Pro 2013 with 16GB of RAM and SSD running VMWare Fusion, and Windows 10 flies here. Super recommended.

Once you do all that, you can start the "Bash on Ubuntu on Windows" (a mouth full). The first good surprise is that it prompts you to register a new username instead of just falling back to Root. As I said in my previous post, it's good practice to create a new user and add it to the sudoers group, and this is what it does. So you can install packages using "sudo apt-get install".

You should follow my [previous post](http://www.akitaonrails.com/2016/04/12/the-year-of-linux-on-the-desktop-by-microsoft) for all the packages and configurations I normally do in a development Linux box.

RVM now works! I was able to install Ruby 2.3.1 through RVM without any problems whatsoever.

I was able to `git clone` a small Rails project and properly `bundle install`. All gems were downloaded, native extensions compiled without any flaws.

Somethings still don't work. For example, you won't be able to finish the Postgresql 9.3 installation. It will download and install but the cluster setup fails as you can follow through [this issue](https://github.com/Microsoft/BashOnWindows/issues/61) thread.

But you don't need to have **everything** installed under Ubuntu, you can just fallback to the native [Postgresql for Windows](https://www.postgresql.org/download/windows/) and edit your `config/database.yml` to point to server `127.0.0.1` and port `5432`. On the Ubuntu side you just need to install `libpq-dev` so the `pg` gem can compile its native extensions and that's it.

Smaller services such as Memcached or Redis install properly with `apt-get` but they won't auto-start through Upstart. But you can start them up manually and use something as [Foreman](https://github.com/ddollar/foreman) to control the processes. They both start and work good enough, so you can test caching in your Rails projects and also test Sidekiq workers.

I know that this is still a Preview, so there are bug fixes and possibly some new features that might be included in the final release in August. One nitpick I have is that every command I run with `sudo` takes a few seconds to start, so it's annoying, but it works in the end.

Node.js 6.3.1 successfully installs and runs. I was able to `npm i` and `node server.js` on Openshift's Node [example repository](https://github.com/openshift/nodejs-ex).

Crystal 0.18.7 successfully installs and it was able to properly compile my [Manga Downloader](https://github.com/akitaonrails/cr_manga_downloadr) project. It executed my built-in performance test in 15 minutes. Not lightning fast performance but it runs correctly until the end. (And so, yes, Crystal runs on Windows as well now!).

Go 1.6 works. I just did a `go get` to install Martini and just ran the simple "Hello World" server. Compiles, starts and executes very fast as expected.

Unfortunatelly, Elixir 1.3.1 crashes, I don't know why yet.

```
$ iex
Crash dump is being written to: erl_crash.dump...done
erl_child_setup closed
```

Actually, Erlang itself crashes by just trying to run `erl`. None of the Elixir tools work as a result. No iex, no mix. The funny thing is that it was working in the initial Preview. So either it's something in the new Preview or something in the newest Erlang releases. There are [open issues](https://github.com/Microsoft/BashOnWindows/issues?utf8=✓&q=is%3Aissue%20elixir) regarding this problem, so let's hope it gets fixed soon.

<a name="best-windows-dev-env"></a>

### "The Best Environment for Rails on Windows"

I have [this very old 2009 post](http://www.akitaonrails.com/2009/1/13/the-best-environment-for-rails-on-windows) to guide developers that are locked on Windows to implement Rails projects. The first advice is to avoid Ruby for Windows. I really commend the efforts of great developers such as Luis Lavena, who invested a lot of time to make it work well enough. But unfortunately the reality is that Ruby is made for Linux environments, it binds to native extensions in C that has lots of dependencies that are not easy to make available on Windows.

So the best option up until now was to install Vagrant (through Virtualbox or, even better, VMWare) as the runtime and use Windows-available editors such as Sublime Text 3 or Atom.

Now you can avoid the Vagrant/virtualization part and directly use "Bash on Ubuntu on Windows". It's so complete that I can even use ZSH and install complex dotfiles such as YADR. You can run Postgresql for Windows and connect to localhost:5432 in your Rails application or any web application that requires Postgresql for example.

You can install ConEmu as a better terminal emulator than the stupidly bad cmd.exe default console. Follow [this article](https://conemu.github.io/en/BashOnWindows.html) to get news on its support of Bash on Windows. Right now you have to edit the "Ctrl-V" hotkey to something else ("Ctrl-Shift-V"), arrow keys don't work well om Vim, and you can add a Default Task for Bash like this: `%windir%\system32\bash.exe ~ -cur_console:p`

![Developing Rails on Windows](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/544/big_Screen_Shot_2016-07-28_at_14.13.36.png)

### Conclusion

So, yes, at least from this version I tested (installed on July 25th) this is a **usable** "Bash on Ubuntu on Windows" and web developers from Ruby to Javascript to Crystal to Go can really start testing and trying to make Windows 10 Anniversary their primary platform for serious Linux-based development.

Add Sublime Text or Atom (or Visual Studio, if that's your thing) and you should be good to go. I expect the next releases to fix some of the bugs and performance issues, but compared to what we saw in April, it's a huge improvement.

Kudos to Microsoft for that!

And if you want to know more hardcore details on how the Windows Subsystem for Linux is actually implemented, I recommend this series of blog posts from MSDN itself:

* [Windows Subsystem for Linux Overview](https://blogs.msdn.microsoft.com/wsl/2016/04/22/windows-subsystem-for-linux-overview/)
* [Pico Process Overview](https://blogs.msdn.microsoft.com/wsl/2016/05/23/pico-process-overview/)
* [WSL System Calls](https://blogs.msdn.microsoft.com/wsl/2016/06/08/wsl-system-calls/)
* [WSL File System Support](https://blogs.msdn.microsoft.com/wsl/2016/06/15/wsl-file-system-support/)
