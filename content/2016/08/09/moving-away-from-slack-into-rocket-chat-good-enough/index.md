---
title: Moving away from Slack into Rocket.chat. Good Enough.
date: '2016-08-09T16:21:00-03:00'
slug: moving-away-from-slack-into-rocket-chat-good-enough
tags:
- slack
- rocket.chat
- group chats
draft: false
---

In my quest to create my own private infrastructure I've already moved away from Pivotal Tracker (saving this for a future post), Bitbucket, Github, Travis and into GitLab and GitLab Runner. There are more services I will move away from in the future, so expect more posts like this.

In [my previous post](http://www.akitaonrails.com/2016/08/03/moving-to-gitlab-yes-it-s-worth-it) I forgot to mention minimal firewall and SSL configuration, but you can check it here.

One of the most difficult pieces to move away from is Slack. Don't get me wrong, it's a great tool and it gets the job done. The free-tier is really competent but I really want some of the payed features such as history of all conversations with search capabilities and uploads without limit.

![Codeminer Rocket](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/555/big_Franz.png)

## The Cost Conundrum

But then you have to commit to pay USD 8/month per user (USD 6.67 if you pay ahead of time). If you're a small team (around a dozen people) it's well worth it and you should definitely pay and get over with.

If you have more than 20 people then it starts to become a conundrum. On my GitLab cost calculations, some people argued that saving USD 15k yearly is not such a big deal, and they're not wrong.

If you're from outside of the US coastal cities, specially from countries in South America, Asia where currency can be more than 3 times devalued, than it quickly starts to become a big deal.

Apart from that, we are currently offloading a whole lot of out IPs and knowledge into the care of companies we don't really know and where we don't hold any real stakes.

If you're a medium to big company it really starts to make sense to want to have more control over your own property. Of course, it costs some work and maintenance, so it's not for everybody.

What I will argue is that if you have **150 people** or more, and you're still growing, it's not such a big burden to jump into your own infrastructure.

> You avoid paying around [**USD 12,000 a year**](https://codeminer42.slack.com/pricing) or more, and instead you will pay **USD 960 a year** in Digital Ocean boxes and MMS plus a few hours every month in basic maintenance. That's 12 times cheaper.

Again, you shouldn't do it just for the cost savings as the maintenance burden can easily not be worth it if you or your team are not devops savvy and you don't have anyone to keep monitoring it. For most companies, the conversation history is not so important and even the free-tier will be more than enough.

Cost is less relevant depending on your context, and there are many different uses for group chats. For example, if you're an [open source community](https://news.ycombinator.com/item?id=9754626), you would try [Gitter](https://gitter.im) instead.

There are also [many other alternatives](https://www.google.com/search?q=slack+alternatives) that you may want to try.

For the sake of this article, let's assume you're a small to medium company, in need of private rooms, many external users (for example, your clients), with at least 50 people. Then this can start to make sense. Any other scenario and we have to analyze it differently.

## Why I chose Rocket.chat

With the cost reasoning out of the way, then it's a matter of choosing which alternative to use.

I tried [MatterMost](https://www.mattermost.org/) first and I really wanted to like it. It has a very similar feature set to Slack and most importantly, it's written in Go. So it's both lightweight, very fast, and not so difficult to contribute. It uses MySQL or PostgreSQL which I like.

Unfortunatelly, it has an important **show-stopper** for my needs. You can create both public channels or private groups, but anyone can delete a private group. If you want permission control for that you must use their ["Enterprise" offering](https://about.mattermost.com/pricing/) and pay **USD 20/year per user**.

> It's still at least **3 times cheaper** than Slack, so it may be a good option for you.

I really want to have full-control, not just make it cheaper. I could pay Slack already if I didn't care, so I would not just pay an alternative and not have full-control (including the ability to tweak and improve the entire code base).

Then, it took me back to [Rocket.chat](https://rocket.chat/). It's feature set also rivals Slack, it's good looking enough. But, it's made in Meteor. Now, I don't have anything against Meteor and I really think a Slack-clone is exactly the kind of use case where you could use Meteor to its full potential.

Technically I really think it's a downside to be forced to use Mongodb (Meteor requires Mongo). For small installations I really prefer to have PostgreSQL. MongoDB is competent, but for medium to big installations, and I will show you why below.

I **strongly dislike** the [culture of writing software without _minimal care_](https://medium.com/friendship-dot-js/i-peeked-into-my-node-modules-directory-and-you-wont-believe-what-happened-next-b89f63d21558#.8jd3z3n6u) such as having a reasonably complete test suite. You browse through the many packages that comprise Rocket.chat and several of them have no tests whatsoever. Some packages do have jasmine tests, but the majority is lacking.

This is [one example](https://github.com/RocketChat/Rocket.Chat/blob/a5cb22bb0017f4c39654bf1e2895ae64acb0339b/packages/rocketchat-katex/tests/jasmine/client/unit/katex.spec.coffee) I picked randomly, out of the few test files I found:

--- javascript
describe 'rocketchat:katex Client', ->

  it 'should exist', ->
    expect(RocketChat.katex).toBeDefined()
---

This is sad, sorry to say that, but it is. Not surprisingly I've seen katex issues while using the interface. And if you think this was just a poor choice, I picked [another test file](https://github.com/RocketChat/Rocket.Chat/blob/a5cb22bb0017f4c39654bf1e2895ae64acb0339b/packages/rocketchat-markdown/tests/jasmine/client/unit/markdown.spec.coffee):

--- javascript
describe 'rocketchat:markdown Client', ->

  it 'should exist', ->
    expect(RocketChat.Markdown).toBeDefined()
---

Really?

So, the code itself is not so pretty, you have to keep this in mind. I'd much rather use Mattermost (which is much better structured and with enough tests), but it's not entirely free, so it's not an option to me. For my scenario, I'd rather have sloppy code (that minimally "works") that I can tweak than code I can't see, for this particular venture. Many inexperienced developers may argue about the necessity of having automated tests, but not having them also impacts this:

![Rocket.chat contribution graph](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/552/big_Contributors_to_RocketChat_Rocket_Chat.png)

If we see how the project is evolving over time, we can see that interest is diminishing. The lack of good automated tests also make it more difficult for new people to contribute without adding regressions, make contribution reviews more difficult and time consuming.

On the other hand the feature set is good enough as it is. There is only so much you can add to a Slack-clone. The upside is that if the code doesn't change too much, I can tweak it more without having many things breaking all the time. It's the complete opposite from the impressive contribution boost over at GitLab, for example.

Doing a few days of testing through the administration settings, user interface, having dozens of users doing real conversation, convinced me that even though the code quality is bad, the feature set is indeed there. I think I can live with that. Your mileage may vary though.

I am using [Franz](http://meetfranz.com) to open Slack, Rocket.chat, Hangouts, Messenger and any number of other communicators in one single app, which is great. And Rocket.chat does provide [mobile](https://itunes.apple.com/us/app/rocket.chat/id1028869439?mt=8) [apps](https://play.google.com/store/apps/details?id=com.konecty.rocket.chat&hl=en) based off PhoneGap. Again, it's good, not great.

Many people have heavy bots or integrations into their Slack configuration. The alternatives such as Rocket.chat do support incoming and outgoing webhooks and most of the integrations should be possible (with some tweaking and hacking such as this [Giphy example](https://github.com/FinndropStudios/GifRocket)), so make a list of all important integrations and do a Google research on that before continuing.

## Planning the Infrastructure

All that having being said, I'd recommend you try Rocket.chat's [demo server](https://demo.rocket.chat) first to see if it has the minimal features you need. And also that you install a dry-run in a small Digital Ocean box with the intention to blow it off later.

For a single-instance, stand-alone installation, temporary dry-run, I recommend you start by installing the [MongoDB One-Click Application](https://www.digitalocean.com/community/tutorials/how-to-use-the-mongodb-one-click-application) and follow [this instruction](https://www.digitalocean.com/community/tutorials/how-to-install-configure-and-deploy-rocket-chat-on-ubuntu-14-04) to install everything in one machine.

This is the worst possible production environment, which is why I am being so repetitive into saying that you should destroy this box after you do your testing.

As I've said before, I am assuming a scenario where you have 50 or more people, with real clients, important communication going on. You don't want to keep a simple installation like this for production usage.

For a **minimal production installation** you will need at the very least 4 boxes with 1 GB of RAM each. Now, why 4?

This is an important section for most of the beginner Javascript programmers out there playing with the so called "MEAN" stack (MongoDB, Express, Angularjs, Node.js). I've seen people deploy single-instance, stand-alone "MEAN" apps for production usage. And this is super bad.

> **MongoDB is NOT MEANT to function with just one single instance!**

More than that:

> **DO NOT start an even number of MongoDB nodes, or at least install an Arbiter**

So, the minimal setup for MongoDB is a [Three-member Replica Set](https://docs.mongodb.com/manual/core/replica-set-architecture-three-members/), no less!

The article ["MongoDB Gotchas & How To Avoid Them"](https://www.rainforestqa.com/blog/2012-11-05-mongodb-gotchas-and-how-to-avoid-them/) is a little bit old but you should be aware of several of the documented gotchas, including adding replica sets and avoid waiting too long to start sharding you data.

The most important part of making Rocket.chat reliable is to make your MongoDB minimally reliable, and this is a hidden cost you must consider.

#### Installing a Three-Member Replica Set

For the sake of this article I will assume that you created 3 (three) MongoDB One-Click Applications on Digital Ocean's at the very least 1 GB RAM boxes (2 GB RAM machines are a good choice if you're in doubt, but never the 512 Mb) and another bare Ubuntu 14.04 box to be the web server. Create all machines in the same sub-region, all of them with private networking and backup enabled.

Take note of the public IPs and private IPs, for the sake of this article let's say you have this:

---
Public IP     Private IP    Hostname

192.160.10.1  10.0.0.1      mongo1.yourdomain.com
192.160.10.2  10.0.0.2      mongo2.yourdomain.com
192.160.10.3  10.0.0.3      mongo3.yourdomain.com
192.160.10.4  10.0.0.4      yourdomain.com
---

In the commands and code snippets below, make sure to replace the fake IPs for your own private IPs.

As I said in [my GitLab post](http://www.akitaonrails.com/2016/08/03/moving-to-gitlab-yes-it-s-worth-it?), create a swap file, configure the locale, set it up for automatic security updates, and do upgrade the Ubuntu packages.

The next first thing: configure the firewall in all machines (assuming `ufw` package is already installed):

---
sudo ufw reset
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow https
sudo ufw allow ssh
sudo ufw allow in on eth1 to any port 27017
sudo ufw enable
---

We are allowing MongoDB's 27017 port only for machines in the same private networking (through eth1, the public IP go through eth0). We're also allowing port 22 for SSH and although I am not listing it here in this article you should also consider installing and configuring [fail2ban](https://www.digitalocean.com/community/tutorials/how-to-protect-ssh-with-fail2ban-on-ubuntu-14-04). Digital Ocean also has a [good post on UFW](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-14-04) for more details.

Next thing to do on the MongoDB machines is to [Disable Transparent Huge Pages (THP)](https://docs.mongodb.com/manual/tutorial/transparent-huge-pages/). For that create a file `/etc/init.d/disable-transparent-hugepages`, with this content:

--- bash
#!/bin/sh
### BEGIN INIT INFO
# Provides:          disable-transparent-hugepages
# Required-Start:    $local_fs
# Required-Stop:
# X-Start-Before:    mongod mongodb-mms-automation-agent
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Disable Linux transparent huge pages
# Description:       Disable Linux transparent huge pages, to improve
#                    database performance.
### END INIT INFO

case $1 in
  start)
    if [ -d /sys/kernel/mm/transparent_hugepage ]; then
      thp_path=/sys/kernel/mm/transparent_hugepage
    elif [ -d /sys/kernel/mm/redhat_transparent_hugepage ]; then
      thp_path=/sys/kernel/mm/redhat_transparent_hugepage
    else
      return 0
    fi

    echo 'never' > ${thp_path}/enabled
    echo 'never' > ${thp_path}/defrag

    unset thp_path
    ;;
esac
---

Now you can register it as a service:

---
sudo chmod 755 /etc/init.d/disable-transparent-hugepages
sudo update-rc.d disable-transparent-hugepages defaults
sudo /etc/init.d/disable-transparent-hugepages start
---

Stop MongoDB in all 3 machines:

---
sudo service mongod stop
---

Now comes a complicated procedure that you should not do wrong. It's only complicated because you have to do it in all 4 machines minding their correct private IP addresses. If you already have your own DNS server, you can skip this, otherwise follow through carefully.

You will have to edit both `/etc/hostname` and `/etc/hosts`. Each machine will have a particular name and they should be able to find the other machines by name. Let's start by editing the `/etc/hostname` on each machine. Use the table in the beginning of this section, for example, in the machine with public IP `192.160.10.1` you must edit it's hostname to be `mongo1.yourdomain.com`, and so on for all the machines.

Once you have it done, you have to replace the line `127.0.0.1 localhost` in the `/etc/hosts` in each of them for the following:

---
127.0.0.1 localhost mongo1.yourdomain.com
10.0.0.1 mongo1.yourdomain.com
10.0.0.2 mongo2.yourdomain.com
10.0.0.3 mongo3.yourdomain.com
10.0.0.4 yourdomain.com
---

This snippet assumes you're in the machine with private IP `10.0.0.1`, of course. Make sure you change `mongo1.yourdomain.com` in the first line for the hostname of the machine you're in. If this is too difficult for you, you definitely should not try to maintain your own infrastructure, so beware.

Finally, let's edit the `/etc/mongod.conf` with these changes:

---
storage:
  dbPath: /mongodb-data
...
net:
  port: 27017
  bindIp: 0.0.0.0
...
replication:
  replSetName: rs0
---

This should be exactly the same in all machines. And you must create this `/mongodb-data` directory like this:

---
sudo mkdir /mongodb-data
sudo chown -R mongodb:mongodb /mongodb-data
---

Now go ahead on machine `mongo1.yourdomain.com`, start up with `sudo service mongod start` and fire up the `mongo` command, and you should see something like this:

---
# mongo
MongoDB shell version: 3.2.8
connecting to: test
>
---

Let's now configure the replica set by issuing this command in the MongoDB command-line interface:

---
rs.initiate()
rs.add('mongo2.yourdomain.com')
rs.add('mongo3.yourdomain.com')
---

And you can now log in to the secondary machines and `sudo service mongod start` in all of them. They should all start joining the replica set and syncing.

You can check the status of the replication like this:

---
> rs.conf()

{
  "set" : "rs0",
  "date" : ISODate("2016-08-09T17:33:10.466Z"),
  "myState" : 1,
  "term" : NumberLong(-1),
  "heartbeatIntervalMillis" : NumberLong(2000),
  "members" : [
    {
      "_id" : 1,
      "name" : "mongo1.yourdomain.com:27017",
      "health" : 1,
      "state" : 1,
      "stateStr" : "PRIMARY",
      "uptime" : 11727,
      "optime" : Timestamp(1470763990, 3),
      "optimeDate" : ISODate("2016-08-09T17:33:10Z"),
      "electionTime" : Timestamp(1470752553, 1),
      "electionDate" : ISODate("2016-08-09T14:22:33Z"),
      "configVersion" : 6,
      "self" : true
    },
    {
      "_id" : 2,
      "name" : "mongo2.yourdomain.com:27017",
      "health" : 1,
      "state" : 2,
      "stateStr" : "SECONDARY",
      "uptime" : 11693,
      "optime" : Timestamp(1470763988, 4),
      "optimeDate" : ISODate("2016-08-09T17:33:08Z"),
      "lastHeartbeat" : ISODate("2016-08-09T17:33:10.026Z"),
      "lastHeartbeatRecv" : ISODate("2016-08-09T17:33:08.887Z"),
      "pingMs" : NumberLong(0),
      "syncingTo" : "mongo3.yourdomain.com:27017",
      "configVersion" : 6
    },
    {
      "_id" : 3,
      "name" : "mongo3.yourdomain.com:27017",
      "health" : 1,
      "state" : 2,
      "stateStr" : "SECONDARY",
      "uptime" : 11693,
      "optime" : Timestamp(1470763988, 4),
      "optimeDate" : ISODate("2016-08-09T17:33:08Z"),
      "lastHeartbeat" : ISODate("2016-08-09T17:33:09.994Z"),
      "lastHeartbeatRecv" : ISODate("2016-08-09T17:33:08.655Z"),
      "pingMs" : NumberLong(0),
      "syncingTo" : "mongo1.yourdomain.com:27017",
      "configVersion" : 6
    }
  ],
  "ok" : 1
}
---

Each box should be syncing data to another box, one of them will be marked "PRIMARY" and the others will be "SECONDARY". If one of them "dies" for some reason, one of the others will be elected as PRIMARY until you add a replacement box. Read more details on this procedure in [Digital Ocean's post about implementing replication sets](https://www.digitalocean.com/community/tutorials/how-to-implement-replication-sets-in-mongodb-on-an-ubuntu-vps).

#### Adding your MongoDB environment to MMS

Another thing beginners will not realise is that it's a good idea to monitor your services. At the very least you should install MongoDB Cloud Manager agents into your servers. Just set up an account at [MongoDB Atlas](https://www.mongodb.com/cloud).

It's beyond the point of this article to explain Atlas, but you should have no trouble installing the agents with the Group ID and API Key provided. Then install the monitoring agent and have the Manager figure out your existing deployment and replica set.

The basic subscription for monitoring will cost you an extra USD 39 a month, but believe me when I say it's worth to add all your MongoDB deployments under MMS.

![MMS](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/553/big_Deployment___Cloud_Manager__MongoDB_Cloud_Manager.png)

![Replica Set Graphs](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/554/big_Host___Cloud_Manager__MongoDB_Cloud_Manager.png)

#### Installing a multi-instance Node.js service

Another mistake beginners in the MEAN stack do is to start up a single Node.js instance. Yes, Node.js asynchronous I/O nature makes it "concurrent enough" in 1 single thread. But you do want to maximize the rented machine so you should spin up at least one Node.js instance for each CPU core. A 1 GB RAM machine has just 1 core, but you can spin up at least 2 instances.

First of all, we must set up the `yourdomain.com` (`192.160.10.4` or `10.0.0.4` in the example) to support Node.js, let's do it:

---
sudo apt-get install -y npm curl graphicsmagick nginx git bc
sudo npm install -g n
sudo npm install -g forever
sudo npm install -g forever-service
sudo n 0.10.40
---

If you haven't already, [create a more restricted sudo user](https://www.digitalocean.com/community/tutorials/how-to-create-a-sudo-user-on-ubuntu-quickstart):

---
adduser rocket # add a password when asked
usermod -aG sudo rocket
su - rocket # and always ssh in with `ssh rocket@yourdomain.com`
---

Within rocket's home directory let's install the Rocket.chat codebase:

---
cd /home/rocket
curl -L https://rocket.chat/releases/latest/download -o rocket.chat.tgz
tar zxvf rocket.chat.tgz
mv bundle Rocket.Chat
cd Rocket.Chat/programs/server
npm install
---

And now let's add a way for the machine to start the Rocket.chat whenever it reboots:

---
cd ~/Rocket.Chat
sudo forever-service install -s main.js -e "ROOT_URL=https://rocketchat42.com/ MONGO_URL=mongodb://mongo1.yourdomain.com:27017/rocketchat MONGO_OPLOG_URL=mongodb://mongo1.yourdomain.com:27017/local PORT=3001" rocketchat1
sudo forever-service install -s main.js -e "ROOT_URL=https://rocketchat42.com/ MONGO_URL=mongodb://mongo1.yourdomain.com:27017/rocketchat MONGO_OPLOG_URL=mongodb://mongo1.yourdomain.com:27017/local PORT=3002" rocketchat2

sudo start rocketchat1
sudo start rocketchat2
---

Let's also create SSL certificates (and for that you must have a properly registered domain, of course). Again, [Digital Ocean's documentation on Let's Encrypt](https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-14-04) is very good. In summary, all you have to do is:

---
sudo git clone https://github.com/letsencrypt/letsencrypt /opt/letsencrypt
---

Now edit the `/etc/nginx/sites-available/default` and add this inside the server block:

---
server {
  ...
  location ~ /.well-known {
          allow all;
  }
  ...
}
---

Now you can:

---
sudo service nginx reload

sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

cd /opt/letsencrypt
./letsencrypt-auto certonly -a webroot --webroot-path=/usr/share/nginx/html -d yourdomain.com -d www.yourdomain.com
---

Again, replace `yourdomain.com` with your own registered domain, of course. The `letsencrypt` command will prompt you to enter your e-mail address and accept terms of service.

[Let's Encrypt](https://letsencrypt.org/) is a fantastic free SSL provider. Their certificates are short lived and are meant to expire in 90 days, so you must set up auto-renewal. Start `sudo crontab -e` and add the following lines:

---
30 2 * * 1 /opt/letsencrypt/letsencrypt-auto renew >> /var/log/le-renew.log
35 2 * * 1 /etc/init.d/nginx reload
---

This should take care of SSL. Now you can edit your `/etc/nginx/sites-available/default` and replace it with this template:

---
# Upstreams
upstream backend {
    server 127.0.0.1:3001;
    server 127.0.0.1:3002;
}

server {
  listen 443 ssl;

  server_name yourdomain.com;

  ssl_certificate /etc/letsencrypt/live/yourdomain.com/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/yourdomain.com/privkey.pem;

  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
  ssl_prefer_server_ciphers on;
  ssl_dhparam /etc/ssl/certs/dhparam.pem;
  ssl_ciphers 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA';
  ssl_session_timeout 1d;
  ssl_session_cache shared:SSL:50m;
  ssl_stapling on;
  ssl_stapling_verify on;
  add_header Strict-Transport-Security max-age=15768000;

  location / {
    proxy_pass http://backend;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header Host $http_host;

    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forward-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forward-Proto http;
    proxy_set_header X-Nginx-Proxy true;

    proxy_redirect off;
  }

}

server {
  listen 80;
  server_name yourdomain.com www.yourdomain.com;
  return 301 https://$host$request_uri;
}
---

Just for the sake of completeness, again: replace `yourdomain.com` for your domain. Usually the `/etc/nginx/sites-enabled/default` is a symlink to `/etc/nginx/sites-available/default`, just check that as well. This configuration will load balance between the 2 node.js instances we configured and started before. And you can add as many as you want following the same `forever-install` procedure and adding the new instances to the `upstream` section in the nginx configuration above.

If everything is correct, you can restart nginx again: `sudo service nginx restart`.

And now you should have `https://yourdomain.com` already up and running. The first user that sign up will be the site administrator and from there you can customize Rocket.chat internally.

## Conclusion

As you can see, this is not a simple procedure to follow and I am assuming you have experience managing your own infrastructure. If you don't you definitely should NOT do this by yourself.

If you do it correctly, you should have a functional Slack-clone with minimal reliability (thanks in large part to Digital Ocean) and minimal cost (USD 80/month in the configuration I described that should be enough for more than a 100 users). Rocket.chat also offer more [documentation](https://rocket.chat/docs/installation/) for other environments including Docker configurations you might want to try. But the procedure above is sufficient for my needs.

I said it already but it's better to repeat it: don't fall for the trap of installing everything in a single box, with single instance MongoDB, and without proper monitoring. It's asking for trouble.

For now I am in the middle of the roll out. All developers in my company are already in the new deployment and soon half of the clients should also migrate (some will not be able to leave Slack just yet), but with Franz and the ability of full history and searchability this shoudn't be a concern even if a developer stays offline for some period of time.

I also don't advocate that everybody should be online and responding in real-time. It's unfeasible, unproductive, creates unnecessary tension. People should participate when they have free time, and they should be able to concentrate without worrying that they are missing something. That's why they should opt-out of being notified in the more busy channels and just enable notification on the private groups that matter.

Coincidentally Jason Fried just posted about concerns over group chats at [Signal v. Noise](https://m.signalvnoise.com/is-group-chat-making-you-sweat-744659addf7d#.3qxe09una), but the gist is that group chat should be purposeful not yet another tool to create tension. People should definitelly get offline when they need to fully concentrate in their work and have the opportunity to catch up with interesting conversations later. And really important communication should go through e-mail or other tradicional ways, a simple `@all` don't cut it for company-wide announcements for example.

I hope this exercise gives you more perspective on what you can have and also raise awareness on the need for companies to regain more control over their own data, particularly knowledge. Erase your communication channels and you're losing years-worth of knowledge that can be invaluable.
