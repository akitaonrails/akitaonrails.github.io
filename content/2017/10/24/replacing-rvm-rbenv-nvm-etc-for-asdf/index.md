---
title: Replacing RVM/Rbenv/Nvm/etc for ASDF
date: '2017-10-24T14:19:00-02:00'
slug: replacing-rvm-rbenv-nvm-etc-for-asdf
tags:
- rvm
- rbenv
- nvm
- ruby
- nodejs
- elixir
draft: false
---

Many people are using Docker as the means to have different Ruby versions or for any other language. I still think the added overhead both in resources usage and usability friction is simply not worth it. I highly recommend against it. Docker is great as the basis for automated infrastrucutres, but I prefer to have them in servers only.

I've been using [asdf](https://github.com/asdf-vm/asdf) as my main Ruby version manager for a long while now and I am confident that I can recommend it in place of the more well recognized RVM or Rbenv.

Moreover, it not only can manage Ruby versions, but it can manage almost all languages you might want. With just one command set. So you don't even need virtualenv for Python or NVM for Node.js. Just use ASDF.

Installing it couldn't be easier. Just follow the [README](https://github.com/asdf-vm/asdf/blob/master/README.md) from the project page.

Don't forget to install the base development tools for your environment. You can follow [ruby-build's wiki page](https://github.com/rbenv/ruby-build/wiki) for example:

```
## For OS X
# optional, but recommended:
brew install openssl libyaml libffi

# required for building Ruby <= 1.9.3-p0:
brew tap homebrew/dupes && brew install apple-gcc42

## For Ubuntu
sudo apt-get install gcc-6 autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev

## For Arch
sudo pacman -S --needed gcc5 base-devel libffi libyaml openssl zlib
```

Then you can install ASDF itself:

```
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.4.0
```

Then add the proper environment configuration for Path and auto-completion.

```
# For Ubuntu or other linux distros
echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bashrc
echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc

# OR for Mac OSX
echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bash_profile
echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bash_profile
```

Finally, you must install one of the dozens of [plugins](https://github.com/asdf-vm/asdf-plugins). In my case, I have these installed:

```
asdf plugin-add clojure https://github.com/vic/asdf-clojure.git
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf plugin-add golang https://github.com/kennyp/asdf-golang.git
asdf plugin-add python https://github.com/tuvistavie/asdf-python.git
asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git

# Imports Node.js release team's OpenPGP keys to main keyring
bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring

asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
```

You can update the plugins all at once with this simple command:

```
asdf plugin-update --all
```

You can see what versions are available for a particular language like this:

```
asdf list-all ruby
asdf list-all clojure
asdf list-all python
```

Then you can install any version you need like this:

```
asdf install ruby 2.4.2
asdf install nodejs 8.7.0
asdf install erlang 20.1
```

After you install a particular language version, I always set one as the system default like this:

```
asdf global ruby 2.4.2
asdf global elixir 1.5.2
```

And in a particular project directory, I can set it to use any other version, just for that project:

```
asdf local ruby 2.3.4
```

The command above will write a `.tool-versions` file to the directory you're at when you ran it. It will contain the language and version you chose, so whenever you go back to that directory ASDF will set the correct version for the language you need. The previous `asdf global <language>` command is actually writing a `.tool-versions` file to your home directory. The local config override the home directory version.

Another important thing to remember, whenever you install libraries which have executable scripts that need to be in the PATH, you must **reshim** them. For example:

```
npm install -g phantomjs # will install phantomjs
asdf reshim nodejs # will put the shim for the phantomjs executable in the PATH
phantomjs # will properly execute it
```

If you try to install Ruby versions prior to 2.4 you will find [compilation problems](https://github.com/asdf-vm/asdf-ruby/wiki/Ruby-Installation-Problems) as it depends on gcc5 and openssl-1.0. So you should use the following command (assuming you have already installed the obsolete openssl-1.0 and gcc5):

```
CC=gcc-5 PKG_CONFIG_PATH=/usr/lib/openssl-1.0/pkgconfig \
RUBY_EXTRA_CONFIGURE_OPTIONS="--with-openssl-dir=/usr/lib/openssl-1.0" \
asdf install ruby 2.3.4
```

Sometimes, if a dependency is missing and an install fails, you must manually remove it before attempting to reinstall, so you have to do:

```
asdf remove <language> <version>
```

Finally, if you're used to add something to your bash or zsh files to show the current language version in the command line, you're probably using something like `rvm-prompt`. In the case of ASDF you will need something a bit longer like this:

```
asdf current ruby | awk -F' ' '{print $1}'
```

This will get only the version (the `asdf current` command states which `.tool-versions` file it is using, so this is a longer result).

Other than that, you're all set. One version manager to rule them all. No more RVM, no more Virtualenv, no more NVM, etc. You can live happily ever after!
