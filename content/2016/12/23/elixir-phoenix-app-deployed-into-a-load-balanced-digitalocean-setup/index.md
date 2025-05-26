---
title: Elixir Phoenix App deployed into a Load Balanced DigitalOcean setup
date: '2016-12-23T15:07:00-02:00'
slug: elixir-phoenix-app-deployed-into-a-load-balanced-digitalocean-setup
tags:
- elixir
- phoenix
- deployment
- edeliver
- digitalocean
- websockets
draft: false
---

One of the main advantages of building a Websockets enabled web application using Phoenix is how "easy" it is for Erlang to connect itself into a cluster.

For starters, Erlang does not need multiple processes like Ruby (which is limited to one connection per process, or per thread if you're using a threaded-server like Puma). One single Erlang process will take over the entire machine, if you need to. Internally it will keep one real thread per machine-core. And each thread will have its own Scheduler to manage as many micro-processes as you need. You can read all about it in my post titled ["Yocto Services"](http://www.akitaonrails.com/2015/11/25/yocto-services-and-my-first-month-with-elixir).

Moreover, Erlang has built-in capabilities to form a cluster, where each Erlang instance acts as a peer-to-peer Node, without the need for a centralized coordinator. You can read all about it in my post about [Nodes](http://www.akitaonrails.com/2015/11/25/exmessenger-exercise-understanding-nodes-in-elixir). The power of Erlang is in how "easy" it is to form reliable distributed systems.

You can fire up many Phoenix instances and from one of the instances, it can broadcast messages to Users subscribed in Channels even if their sockets are connected to different instances. It's seamless and you don't need to do anything special in your code. Phoenix, Elixir and Erlang are doing all the heavy lifting for you behind the scenes.

### No Heroku for You :-(

Because you want to take advantage of this scalability and high availability feature for distributed systems (in the small example of a real-time chat system) you will need to have more control over your infrastructure. This requirement rules out the majority of Platform as a Service (PaaS) offerings out there, such as Heroku. Heroku's model revolves around single, volatile processes in isolated containers. Those jailed processes (dynos) are not aware of other processes or the internal networking, so you can't fire up Dynos and have them form a cluster because they won't be able to find each other.

If you already know how to configure Linux related stuff: Postgresql, HAproxy, etc, go ahead directly to the [Phoenix-specific section](#phoenix-setup).

### IaaS (DigitalOcean) to the rescue!

You want long lived processes in network reachable servers (either through private networking, VPN, or plain simple - insecure! - public networks).

In this example I want to walk you through a very simple deployment using DigitalOcean (you can choose any IaaS, such as AWS, Google Cloud, Azure or whatever you feel more comfortable with).

I have created 4 droplets (all using the smallest size of 512Mb of RAM):

* 1 Postgresql database (single point of failure: it's not the focus of this article to build a highly available, replicated database setup);
* 1 HAProxy server (single point of failure: again, it's not the focus to create a highly available load balancing scheme);
* 2 Phoenix servers - one in the NYC datacenter and another in the London datacenter, to demonstrate how easy it is for Erlang to form clusters even with geographically separated boxes.

### Basic Ubuntu 16.04 configuration

* Goals: configure locale, assure unattended updates are up, upgrade packages, install and configure Elixir and Node.
* You should also do: change SSH to another port and install [fail2ban](https://www.digitalocean.com/community/tutorials/how-to-protect-ssh-with-fail2ban-on-ubuntu-14-04, disallow login through password.

You will want to read my post about [configuring Ubuntu 16.04](http://www.akitaonrails.com/2016/09/21/ubuntu-16-04-lts-xenial-on-vagrant-on-vmware-fusion). To summarize, start by configuring proper UTF-8:

---
sudo locale-gen "en_US.UTF-8"
sudo dpkg-reconfigure locales
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
echo 'LC_ALL=en_US.UTF-8' | sudo tee -a /etc/environment
echo 'LANG=en_US.UTF-8' | sudo tee -a /etc/environment
---

Make sure you add a proper user into the sudo group and from now on do not use the root user. I will create a user named `pusher` and I will explain in another post why. You should create a username that suits your application.

---
adduser pusher
usermod -aG sudo pusher
---

Now log out and log in again through this user. `ssh pusher@server-ip-address`. If you're on a Mac copy the public key of your SSH certificate like this:

---
ssh-copy-id -i ~/.ssh/id_ed25519.pub pusher@server-ip-address
---

It creates the `.ssh/authorized_keys` if it doesn't exist, sets the correct permission bits and appends your public key. You can do it manually, of course.

DigitalOcean's droplets start without a swap file and I'd recomend adding one, specially if you want to start with the smaller boxes with less than 1GB of RAM:

---
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo cp /etc/fstab /etc/fstab.bak
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
sudo sysctl vm.swappiness=10
sudo sysctl vm.vfs_cache_pressure=50
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
echo 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.conf
---

Make sure you have unattended upgrades configured. You will want at least to have security updates automatically installed when available.

---
sudo apt install unattended-upgrades
---

Now, let's install Elixir and Node (Phoenix needs Node.js):

---
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install build-essential nodejs esl-erlang elixir erlang-eunit erlang-base-hipe
sudo npm install -g brunch
mix local.hex
mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez # this is optional, install if you want to manually test phoenix in your box
---

Now you have an Elixir capable machine ready. Create a image snapshot over DigitalOcean, move it regions you want to create your other droplets and use this image to create as many droplets as you need.

For this example, I created a second droplet in the London region, a third droplet for postgresql in the NYC1 region and a fourth droplet in the NYC3 region for HAProxy.

I will refer to their public IP addresses as **"nyc-ip-address"**, **"lon-ip-address"**, **"pg-ip-address"**, and **"ha-ip-address"**.

### Basic PostgreSQL configuration

* Goal: basic configuration of Postgresql to allow the Phoenix servers to connect.
* To do: create a secondary role just to connect to the application database and another superuser role to create the database and migrate the schema. Also lock down the machine and configure SSH tunnels or another secure way, at least a private networking, than allowing plain 5432 TCP port connections from the public Internet.

Now you can connect to `ssh pusher@pg-ip-address` and follow this:

---
sudo apt-get install postgresql postgresql-contrib
---

You should create a new role with the same name of the user you added above ("pusher" in our example):

---
$ sudo -u postgres createuser --interactive

Enter name of role to add: pusher
Shall the new role be a superuser? (y/n) y

$ sudo -u postgres createdb pusher
---

Postgresql expects to find a database with the same name as the role and the role should have the same name as the Linux user. Now you can use `psql` to set a password for this new role:

---
$ sudo -u postgres psql
\password pusher
---

Register a secure password, take note and let's move on.

Postgresql comes locked down to external connections. One way to connect from the outside is to configure your servers to create an [SSH tunnel](https://www.postgresql.org/docs/9.1/static/ssh-tunnels.html) to the database server and keep external TCP connections through port 5432 disavowed.

But for this example, we will just allow connections from the public Internet to the 5432 TCP port. **Warning:** this is VERY insecure!

Edit the `/etc/postgresql/9.5/main/postgresql.conf` and find the `listen_addresses` configuration line and allow it:

---
listen_addresses = '*'    # what IP address(es) to listen on;
---

This should bind the server to the TCP port. Now edit `/etc/postgresql/9.5/main/pg_hba.conf` and edit it at the end to looks like this:

---
# IPv4 local connections:
host    all             all             127.0.0.1/32            trust
host    all             all             your-local-machine-ip-address/24        trust
host    all             all             nyc-ip-address/24       trust
host    all             all             lon-ip-address/24       trust
# IPv6 local connections:
host    all             all             ::1/128                 trust
---

Save the configuration file and restart the server:

---
sudo service postgresql restart
---

See what I did there? I only allowed connections coming from the public IPs of the Phoenix servers. This does not make the the server secure, just a little bit less vulnerable. If you're behind a DHCP/NAT based network, just Google for "what's my IP" to see your public facing IP address - which is probably shared by many other users, remember you're allowing connections from an insecure IP to your database server! Once you make initial tests, create your new schema, then you should remove that `your-local-machine-ip-address/24` line from the configuration.

From your Phoenix application, you can edit you local `config/prod.secret.exs` file to look like this:

--- ruby
# Configure your database
config :your_app_name, ExPusherLite.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "pusher",
  password: "your-super-secure-pg-password",
  database: "your-app-database-name",
  hostname: "pg-ip-address",
  pool_size: 20
---

Replace the information for your server and database and now you can test it out like this:

---
MIX_ENV=prod iex -S mix phoenix.server
---

If you see a `:econnrefused` message from postgrex, then you're in trouble. Re-check your configuration, restart the server and try again. If everything connects, you can run `MIX_ENV=prod mix do ecto.create, ecto.migrate` to prepare your database.

Finally, you will want to lock down the rest of your server with UFW, at the very least. UFW should come pre-installed in Ubuntu 16, so you can just do:

---
ufw allow 5432
ufw allow ssh
ufw enable
---

That's it. And again, this does not make your server secure, it just makes it less insecure. There is a huge difference!

And by the way, if you're a Docket fan:

> DO NOT INSTALL A DATABASE INSIDE A DOCKER CONTAINER!

[You have been warned](http://patrobinson.github.io/2016/11/07/thou-shalt-not-run-a-database-inside-a-container/)!

### Basic HAProxy configuration

* Goals: Provide a simple solution to load balance between our 2 Phoenix servers.
* To do: There is something wrong with session checking or something like that as sometimes I have to refresh my browser so I am not sent back to the login from in my application. Phoenix uses cookie-based sessions so I don't think it is missing sessions.

Now let's `ssh pusher@ha-ip-address`. This one is easy, let's just install HAProxy:

---
sudo apt-get install haproxy
---

Edit `/etc/haproxy/haproxy.cfg`:

---
...
listen your-app-name
  bind 0.0.0.0:80
  mode http
  stats enable
  stats uri /haproxy?stats
  stats realm Strictly\ Private
  stats auth admin:some-secure-password-for-admin
  option forwardfor
  option http-server-close
  option httpclose
  balance roundrobin
  cookie SERVERID insert indirect nocache
  server us your_us_server_IP:8080 check cookie us1
  server uk your_uk_server_IP:8080 check cookie uk1
---

You can avoid the `stats` lines if you have other means of monitoring, otherwise set a secure password for the `admin` user. One very important part is the `option http-server-close` as explained in [this other blog post](http://blog.silverbucket.net/post/31927044856/3-ways-to-configure-haproxy-for-websockets), otherwise you may have trouble with Websockets.

For some reason I am having some trouble with my application after I login and it sets the session, sometimes I have to refresh to be sent to the correct page, not sure why yet and I believe it's something in the HAProxy configuration. If anyone knows what it is, let me know in the comments section below. For now, I am just relying to Sticky sessions (server affinity) by making HAProxy write back a cookie with the server.

Now you can restart the server and enable UFW as well:

---
sudo service haproxy restart
sudo ufw allow http
sudo ufw allow https
sudo ufw allow ssh
sudo ufw enable
---

You can easily add SSL support to your application by configure HAProxy (and not the Phoenix nodes). The [DigitalOcean documentation](https://www.digitalocean.com/community/tutorials/how-to-secure-haproxy-with-let-s-encrypt-on-ubuntu-14-04) is comprehensive, so just follow it. At the end, my `haproxy.cfg` looks like this:

---
global
   log /dev/log    local0
   log /dev/log    local1 notice
   chroot /var/lib/haproxy
   stats socket /run/haproxy/admin.sock mode 660 level admin
   stats timeout 30s
   user haproxy
   group haproxy
   daemon
   maxconn 2048
   tune.ssl.default-dh-param 2048

defaults
   log global
   mode http
   option httplog
   option dontlognull
   option redispatch
   option forwardfor
   option http-server-close
   timeout connect 5000
   timeout client  50000
   timeout server  50000

frontend www-http
   bind your_ha_proxy_IP:80
   reqadd X-Forwarded-Proto:\ http
   default_backend www-backend

frontend www-https
   bind your_ha_proxy_IP:443 ssl crt /etc/haproxy/certs/your_domain.pem
   reqadd X-Forwarded-Proto:\ https
   acl letsencrypt-acl path_beg /.well-known/acme-challenge/
   use_backend letsencrypt-backend if letsencrypt-acl
   default_backend www-backend

backend www-backend
   redirect scheme https if !{ ssl_fc }
   # setting session stickiness
   cookie SERVERID insert indirect nocache
   server us your_us_server_IP:8080 check cookie us1
   server uk your_uk_server_IP:8080 check cookie uk1

backend letsencrypt-backend
   server letsencrypt 127.0.0.1:54321
---

Finally, I will assume you have a DNS server/service somewhere where you can register the IP of this HAproxy server as an A record so you can access it by a full name such as "your-app-name.mydomain.com".

<a name="phoenix-setup"></a>

### Basic Phoenix Configuration

* Goal: configure the Phoenix app to be deployable. Configure the servers to have the necessary configuration files.
* To do: find out a way to cut down the super slow deployment times.

Finally, we have almost everything in place.

I will assume that you have a working Phoenix application already in place, otherwise create one from the many number of tutorials out there.

I have assembled this information from [posts](https://medium.com/@diamondgfx/deploying-phoenix-applications-with-exrm-97a3867ebd04#.7qyuplncx) such as [this very helpful one](http://engineering.pivotal.io/post/how-to-set-up-an-elixir-cluster-on-amazon-ec2/) from Pivotal about an AWS-based deployment. In summary you must do a number of changes to your configuration.

When you're developing your application, you will notice that whenever you run it, it delta-compiles what changed. The binary bits are in the `_build/dev` or `_build/test` in the form of `.beam` binaries (similar to what `.class` are for Java).

Different from Ruby or Python or PHP, you are not deploying source-code to production servers. It's more akin to Java, where you must have everything compiled into binary bits and packaged into what's called a **release**. It's like a ".war" or ".ear" if you're from Java.

To create this package people usually use "exrm", but it's being replaced by ["distillery"](https://github.com/bitwalker/distillery), so we will use it.

Then, if you're from Ruby you're familiar with Capistrano. Or if you're from Python, you know Capistrano's clone, Fabric. Elixir has a similar tool (much simpler at this point), called ["edeliver"](https://github.com/boldpoker/edeliver). It's your basic SSH automation tool.

You add them to `mix.exs` just like any other dependency:

--- ruby
...
def application do
  [mod: {ExPusherLite, []},
   applications: [..., :edeliver]]
end

defp deps do
  [...,
   {:edeliver, "~> 1.4.0"},
   {:distillery, "~> 1.0"}]
end
...
---

From the Pivotal blog post, the important thing to not forget is to edit this part in the `config/prod.exs` file:

--- ruby
http: [port: 8080],
url: [host: "your-app-name.yourdomain.com", port: 80],
...
config :phoenix, :serve_endpoints, true
---

You MUST hardcode the default PORT of the Phoenix web server and the allowed domain (remember the domain name you associated to your HAProxy server above? That one). And you MUST uncomment the `:serve_endpoints, true` line!

For edeliver to work you have to create a `.deliver/config` file like this:

---
USING_DISTILLERY=true

# change this to your app name:
APP="your-app-name"

# change this to your own servers IP and add as many as you want
US="nyc-ip-address"
UK="lon-ip-address"

# the user you created in your Ubuntu machines above
USER="pusher"

# which server do you want to build the first release?
BUILD_HOST=$US
BUILD_USER=$USER
BUILD_AT="/tmp/edeliver/$APP/builds"

# list the production servers declared above:
PRODUCTION_HOSTS="$US $UK"
PRODUCTION_USER=$USER
DELIVER_TO="/home/$USER"

# do not change here

LINK_VM_ARGS="/home/$USER/vm.args"

# For *Phoenix* projects, symlink prod.secret.exs to our tmp source
pre_erlang_get_and_update_deps() {
  local _prod_secret_path="/home/$USER/prod.secret.exs"
  if [ "$TARGET_MIX_ENV" = "prod" ]; then
    __sync_remote "
      ln -sfn '$_prod_secret_path' '$BUILD_AT/config/prod.secret.exs'

      cd '$BUILD_AT'

      mkdir -p priv/static

      mix deps.get

      npm install

      brunch build --production

      APP='$APP' MIX_ENV='$TARGET_MIX_ENV' $MIX_CMD phoenix.digest $SILENCE
    "
  fi
}
---

Remember the information we've been gathering since the beginning of this long recipe? These are the options you MUST change to your own. Just follow the comments in the file content above and add it to your git repository. By the way, your project is in a proper GIT repository, RIGHT??

If you like to use passphrase protected SSH private keys, then it's going to be a huge pain to deploy because for each command, edeliver will issue an SSH command that will keep asking for you passphrase, a dozen times through everything. You've been warned! If you still don't mind that, and you're in a Mac you will have an extra trouble because the Terminal will not be able to create a prompt for you to input your passphrase. You must create an `/usr/local/bin/ssh-askpass` [script](https://github.com/markcarver/mac-ssh-askpass):

---
#!/bin/bash
# Script: ssh-askpass
# Author: Mark Carver
# Created: 2011-09-14
# Licensed under GPL 3.0

# A ssh-askpass command for Mac OS X
# Based from author: Joseph Mocker, Sun Microsystems
# http://blogs.oracle.com/mock/entry/and_now_chicken_of_the

# To use this script:
#   Install this script running INSTALL as root
#
# If you plan on manually installing this script, please note that you will have
# to set the following variable for SSH to recognize where the script is located:
#   export SSH_ASKPASS="/path/to/ssh-askpass"

TITLE="${SSH_ASKPASS_TITLE:-SSH}";
TEXT="$(whoami)'s password:";
IFS=$(printf "\n");
CODE=("on GetCurrentApp()");
CODE=(${CODE[*]} "tell application \"System Events\" to get short name of first process whose frontmost is true");
CODE=(${CODE[*]} "end GetCurrentApp");
CODE=(${CODE[*]} "tell application GetCurrentApp()");
CODE=(${CODE[*]} "activate");
CODE=(${CODE[*]} "display dialog \"${@:-$TEXT}\" default answer \"\" with title \"${TITLE}\" with icon caution with hidden answer");
CODE=(${CODE[*]} "text returned of result");
CODE=(${CODE[*]} "end tell");
SCRIPT="/usr/bin/osascript"
for LINE in ${CODE[*]}; do
      SCRIPT="${SCRIPT} -e $(printf "%q" "${LINE}")";
done;
eval "${SCRIPT}";
---

Now do this:

---
sudo chmod +x /usr/local/bin/ssh-askpass
sudo ln -s /usr/local/bin/ssh-askpass /usr/X11R6/bin/ssh-askpass
---

Remember, Macs only. And now everytime you try to deploy you will receive a number of graphical prompt windows asking for the SSH private key passphrase. It's freaking annoying! And you must have [XQuartz](https://www.xquartz.org/) installed, by the way.

Now you must manually create 3 files in all Phoenix servers. Start with the `your-app-name/vm.args`:

---
-name us@nyc-ip-address
-setcookie @bCd&fG
-kernel inet_dist_listen_min 9100 inet_dist_listen_max 9155
-config /home/pusher/your-app-name.config
-smp auto
---

The `/home/pusher/your-app-name` is the directory where the release will be uncompressed after edeliver deploys the release tarball.

You must create this file in all Phoenix machines, by the way, changing the `-name` bit for the same name you declared in the `.deliver/config` file. The `-setcookie` should be any name, as long as it's the same in all servers.

See the `-config /home/pusher/your-app-name.config`? Create that file with the following:

---
[{kernel,
  [
    {sync_nodes_optional, ['uk@lon-ip-address']},
    {sync_nodes_timeout, 30000}
  ]}
].
---

This is an Erlang source-code. On the NYC machine you must declare the London name, and vice-versa. If you have several machines, all of them but the one you're in right now. Get it?

Finally, for the Phoenix app itself, you always have a `config/prod.secret.exs` that should never be `git add`ed to the repository, remember? This is where you put the Postgresql server information and random secret key to sign the session cookies:

---
use Mix.Config

config :your_app_name, YourAppName.Endpoint,
  secret_key_base: "..."

# Configure your database
config :your_app_name, YourAppName.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "pusher",
  password: "your-super-secure-pg-password",
  database: "your-app-database-name",
  hostname: "pg-ip-address",
  pool_size: 20

# if you have Guardian, for example:
config :guardian, Guardian,
  secret_key: "..."
---

How do you create a new random secret key? From your development machine just run: `mix phoenix.gen.secret` and copy the generated string into the file above.

So now you must have those 3 files in each Phoenix server, in the `/home/pusher` home folder:

---
~/your-app-name/vm.args
~/prod.secret.exs
~/your-app-name.config
---

As per [distillery](https://hexdocs.pm/distillery/runtime-configuration.html#vm-args) documentation, you have to set an environment variable to let it know about the `vm.args` file, and this is **SUPER** important otherwise it will generate a default one that doesn't set the proper name and cookie, so the nodes will not find each other after booting up.

Using `sudo`, edit the `/etc/environment` and add the line:

---
RELEASE_CONFIG_DIR=/home/pusher/your-app-name
VMARGS_PATH=/home/pusher/your-app-name/vm.args
---

You have to do it in all the phoenix servers.

In your local development directory you still have to run this:

---
mix release.init
---

It will generate a standard `rel/config.exs` file that you must add to your git repository with the following changes do the bottom:

--- ruby
...
environment :prod do
  plugin Releases.Plugin.LinkConfig
  ...
end

release :your_app_name do
  set version: current_version(:your_app_name)

  set applications: [
    your_app_name: :permanent
  ]
end
---

The plugin should enable the release to find the local `vm.args` file in the server (this is super important, otherwise the remote commands such as start, stop, ping, etc will not work and the nodes will not load the correct information to boot up and form a cluster).

Finally, all set, you can issue this command:

---
$ mix edeliver build release production --skip-mix-clean --verbose
---

If it finishes without errors you will have a message like the following in the end:

---
...
==> Release successfully built!
    You can run it in one of the following ways:
      Interactive: _build/prod/rel/your-app-name/bin/your-app-name console
      Foreground: _build/prod/rel/your-app-name/bin/your-app-name foreground
      Daemon: _build/prod/rel/your-app-name/bin/your-app-name start
--> Copying release 0.0.1 to local release store
--> Copying your-app-name.tar.gz to release store

RELEASE BUILD OF YOUR-APP-NAME WAS SUCCESSFUL!
---

Now, this will take an absurdly long time to deploy. That's because it will git clone the source code of your app, fetch all Elixir dependencies (every time!), it will have to compile everything, then it will run the super slow `npm install` (every time!), brunch your assets, create the so-called "release", tar and gzip it, download it and SCP it to the other machines you configured.

In the `.deliver/config` file you set a `BUILD_HOST` option. This is the machine where all this process takes place, so you will want to have at least this machine be beefier than the others. As I am using small 512Mb droplets, the process takes forever.

The last command will download the generated tarball. It has to do it to make sure you have the [NIFs](http://erlang.org/doc/tutorial/nif.html) compiled in the native environment where it run, because if you use a Mac, binaries from Macs won't run on Linux.

Now we must upload and decompress this tarball in each server with the following command:

---
mix edeliver deploy release to production
---

The slower your network, the longer this will take, as it's uploading a big tarfile across the public internet, so make sure you're in a fast connection. And when it finishes, we can restart the servers (if you already had instances running):

---
mix edeliver stop production
mix edeliver start production
---

If you do everything right, the edeliver process finishes without any error and it leaves a daemon running in your server, like this:

---
/home/pusher/your-app-name/erts-8.2/bin/beam -- -root /home/pusher/your-app-name -progname home/pusher/your-app-name/releases/0.0.1/your-app-name.sh -- -home /home/pusher -- -boot /home/pusher/your-app-name/releases/0.0.1/your-app-name -config /home/pusher/your-app-name/running-config/sys.config -boot_var ERTS_LIB_DIR /home/pusher/your-app-name/erts-8.2/../lib -pa /home/pusher/your-app-name/lib/your-app-name-0.0.1/consolidated -name us@nyc-ip-address -setcookie ex-push&r-l!te -kernel inet_dist_listen_min 9100 inet_dist_listen_max 9155 -config /home/pusher/your-app-name.config -mode embedded -user Elixir.IEx.CLI -extra --no-halt +iex -- console
---

It will still take a long time, but it should be easier. So this is a pro-tip for you, Linux users. Follow [this Gist](https://gist.github.com/mattweldon/2e8ecb953216438ad168) for more details, you must emulate what's run from the `.deliver/config` file's bottom half.

Also notice that I ran the migrations manually, but you can do it using `mix edeliver migrate`.

Read their documentation for more commands and configurations.

Also, do not forget to enable UFW:

---
sudo ufw allow ssh
sudo ufw allow 8080
sudo ufw allow 4369
sudo ufw allow proto tcp from any to any port 9100:9155
sudo ufw default allow outgoing
sudo ufw enable
---

### Debugging Production bugs

Right after I deployed, obviously it failed. And the problem is that the `/home/pusher/your-app-name/log/erlang.log` files (they are automatically rotated so you may find several files ending in a number), you won't see much.

What I recommend you to do is to change the `config/prod.exs` file ONLY in your development machine and change the log setting to `config :logger, level: :debug`, use the same `prod.secret.exs` you edited in the servers above and run it locally with `MIX_ENV=prod iex -S mix phoenix.server`.

For example, in development mode I had a code in the controller that was checking the existence of an optional query string parameter like this:

--- ruby
if params["some_parameter"] do
 ...
---

That was working fine in development but crashing in production, so I had to change it to:

--- ruby
if Map.has_key?(params, "some_parameter") do
 ...
---

Another thing was that Guardian was working normally in development, but in production I had to declare its application in the `mix.exs` like this:

--- ruby
def application do
  [mod: {ExPusherLite, []},
   applications: [..., :guardian, :edeliver]]
end
---

I was getting `:econnrefused` errors because I forgot to run `MIX_ENV=prod mix do ecto.create, ecto.migrate` as I instructed above. Once I figured those out, my application was up and running through the `http://your-app-name.yourdomain.com`, HAProxy was correctly forwarding to the 8080 port in the servers and everything runs fine, including the WebSocket connections.

### Conclusion

As I mentioned above, this kind of procedure makes me really miss an easy to deploy solution such as Heroku.

The only problem I am facing right now is that when I log in through Coherence's sign in page, I am not redirected to the correct URI I am trying ("/admin" in my case), sometimes reloading after sign in works, sometimes it doesn't. Sometimes I am inside a "/admin" page but when I click one of the links it sends me back to the sign in page even though I am already signed in. I am not sure if it's a but in Coherence, ExAdmin, Phoenix itself or an HAProxy misconfiguration. I will update this post if I find out.

Edeliver also takes an obscene amount of time to deploy. Even waiting for sprockets to process in a `git push heroku master` deploy feels way faster in comparison. And this is for a very bare-bone Phoenix app. Having to fetch everything (because Hex doesn't keep a local global cache, all dependencies are statically vendored in the project directory). Having to run the super slow npm doesn't help either.

I still need to research if there are faster options, but for now what I have "works".

And more importantly, now I have a scalable cluster for real-time bi-directional WebSockets, which is the main reason one might want to use Phoenix in the first place.

If you want to build a "normal" website, keep it simple and do it in Rails, Django, Express or whatever is your web framework of choice. If you want real-time communications the easy way, I might have a better solution. Keep an eye on my blog for news to come soon! ;-)
