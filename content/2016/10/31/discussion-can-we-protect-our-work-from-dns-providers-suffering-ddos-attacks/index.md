---
title: "[Discussion] Can we protect our work from DNS providers suffering DDoS attacks?"
date: '2016-10-31T15:00:00-02:00'
slug: discussion-can-we-protect-our-work-from-dns-providers-suffering-ddos-attacks
tags:
- security
- ddos
- devops
- whitehat
draft: false
---

A few days ago we witnessed a coordinated [DNS amplification attack](https://dyn.com/blog/dyn-statement-on-10212016-ddos-attack/) against Dyn DNS. There are many problems along the way, a lot of [blaming](https://threatpost.com/mirai-fueled-iot-botnet-behind-ddos-attacks-on-dns-providers/121475/), and lot of [possible solutions](http://dyn.com/blog/ddos-attacks-bcp38-internet-security-cloudflare-downtime-managed-dns-open-recursives/).

Bottomline is that attacks like this will probably [happen again, more often](https://github.com/emc-advanced-dev/unik/wiki/Worried-about-IoT-DDoS%3F-Think-Unikernels). The more poorly managed online devices (IoT) we add to the network, the more open recursive DNS servers around, and the more blackhat hackers learn how easy it is to run attacks like this, the worse it will become.

Now, how does one mitigate this kind of problem?

What I will suggest now is not the be-all and end-all sollution. As a disclaimer, I am neither a whitehat hacker nor fully experienced systems administrator. If you are, please by all means let me know in the comments section below if what I am saying is total busted or if it actually works the way I am describing.

I have a small company where up to a 100 people work everyday, either as software developers or performing administrative back-office work. We need access to a number of services such as GitHub, CodeClimate, Google Apps, Dropbox, and a number of internal services such as GitLab, Mattermost and so on.

When the DynDNS attack happened, we had some problems for a few hours. We didn't went total dark, though.

Some of the internal services we use were not affected because the authoritative DNS was not DynDNS. So our internal chat app, Mattermost, for example, remained responsive and online. The same for GitLab. So we didn't stop all our work duties. But some of our projects in GitHub and deployments over Heroku became compromised.

So this is the mitigation plan I am testing: installing my own DNS recursive/forwarder server. I want to forward all DNS queries to some public recursive DNS such as Google (8.8.8.8) or OpenDNS (208.69.38.170) and cache the results for more time than the TTL that returns from the query.

If you're not aware, every time you perform a DNS lookup, it returns the IP address for a given name (for example, 50.19.85.154, 50.19.85.156, and 50.19.85.132 for heroku.com) and a **Time To Live** (for example, 28 seconds when I ran `dig` against heroku.com).

It means that for that window of 28 seconds any other DNS lookup can rely on the IP addresses provided without having to run the queries against the DNS servers again (caching).

After the TTL expires, I should query again to see if the IP addresses did change. TTLs are usually small so the administrators of the services can freely move and decomission servers at least after a certain small window (TTL) and be sure that almost everybody will see new IP addresses when the TTL expires. On the other hand, the small the TTL, the more DNS traffic we all need to keep re-checking addresses all the time.

In practice I belive most services are stable enough to not be changing servers all the time. They do, eventually, for maintenance or even scalability purposes, but I believe it's "rare".

Actually, I believe that if I had my own DNS server, caching DNS results and overriding the TTLs from 60 seconds/15 minutes to a larger extent (let's say, 1 full day) before expiring and requiring a new query, we would have passed through that DDoS episode without noticing it.

In fact, I manually inserted GitHub web address in my local `/etc/hosts` file and I was able to browse through GitHub in the midst of the DDoS attacks.

For most people, that whole apocalyptic episode felt like "the internet fell", but in reality only the authoritative DynDNS servers went down and every other recursive DNS, obeying the TTLs also failed to get responses.

The cascading effect was that we were just unable to translate domain name queries such as spotify.com or heroku.com into their static IP addresses. But if we had those addresses in local caches, we wouldn't feel it because Spotify's, ZenDesk's, Heroku's servers were all online and fine.

It's different than when [AWS's Sydney data center suffered an outage](http://www.theregister.co.uk/2016/06/05/aws_oz_downed_by_weather/). That's way more rare and I've seen it happen just once every couple of years.

### Unbound

I was going to install BIND9 in an AWS EC2 t2.micro machine. But I've read that it's probably overkill if I am not interested in setting up an authoritative server. Whatsmore, I can't set a minimum TTL in BIND if I am not mistaken.

So the other simpler option is [Unbound](http://unbound.net/index.html). It's a simple `apt-get install unbound` away.

Configuration is super easy as well, I just added this:

---
server:
  interface: 0.0.0.0
  do-ip4: yes
  do-ip6: yes
  do-udp: yes
  do-tcp: yes
  do-daemonize: yes
  # access-control: 0.0.0.0/0 allow
  access-control: <your public IP>/8 allow
  access-control: <your public IP>/8 allow

  # Use all threads (roughly the same number of available cores)
  num-threads: 4

  # 2^{number_of_threads}
  msg-cache-slabs: 16
  rrset-cache-slabs: 16
  infra-cache-slabs: 16
  key-cache-slabs: 16

  # More cache memory (this is per thread, if I am not mistaken)
  rrset-cache-size: 150m
  msg-cache-size: 75m

  # More outgoing connections
  # Depends on number of threads
  outgoing-range: 206 # <(1024/threads)-50>
  num-queries-per-thread: 128 # <(1024/threads)/2>

  # Larger socket buffer
  so-rcvbuf: 4m
  so-sndbuf: 4m

  # Faster UDP with multithreading (only on Linux)
  so-reuseport: yes

  # cache for at least 1 day
  cache-min-ttl: 172800

  # cache for at most 1.5 day
  cache-max-ttl: 259200

  # security
  hide-identity: yes
  hide-version: yes
  harden-short-bufsize: yes
  harden-large-queries: yes
  harden-glue: yes
  harden-dnssec-stripped: yes
  harden-below-nxdomain: yes
  harden-referral-path: yes
  use-caps-for-id: yes

  use-syslog: yes

  python:
    remote-control:
            control-enable: no

  forward-zone:
    name: "."
    forward-addr: 8.8.8.8
    forward-addr: 8.8.4.4
---

Replace the `<your public IP>` for whatever IP you get when you Google for "what's my IP", it's better to whitelist every IP you want to enable access to query this server.

Unbound comes pre-configured for DNSSEC and it seems to work out of the box (or at least this is what [this test](https://dnssec.vs.uni-due.de/) says).

In my "enterprise" ISP account I have a static IP address and I can set my Airport Extreme and add my new DNS server IP address and all clients connecting there receives the new DNS automatically.

In my inexpensive backup ISP account (your usual DSL or Cable internet service), it doesn't have a static IP so I have to use the ISP's DHCP and NAT and enable "Bridge Mode" on the router. In that case I can't have a secondary DHCP turned on to set up the DNS automatically on the clients, so I have to add it manually in my notebook's network configuraton.

Anyway, one immediate advantage of setting up my own DNS server is that response times are much faster as I chose a data center very close to me, geographically. So instead of the usual 60ms from Google'S DNS I get less than 30ms in average now (not a dramatic improvement, but somewhat noticeable in web browsing).

The disadvantage is that a recursive DNS should obey the protocol and use the authoritative TTL, never overriding. But as I am using it only for whitelisted IPs within my own organization, I belive that with an occasional manual flush, I should be ok most of the time.

This is not a 100% guarantee that we will not suffer anything in case of another DDoS episode like we had, because not all domain names will be cached in this local DNS server. But the ones we use the most probably will be, particularly essential services such as access to GitHub or Heroku or ZenDesk.

With this new DNS "caching" system all my queries will return and be cached with a larger TTL, for example:

---
$ dig heroku.com

; <<>> DiG 9.8.3-P1 <<>> heroku.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 34732
;; flags: qr rd ra; QUERY: 1, ANSWER: 3, AUTHORITY: 0, ADDITIONAL: 0

;; QUESTION SECTION:
;heroku.com.      IN  A

;; ANSWER SECTION:
heroku.com.   172800  IN  A 50.19.85.156
heroku.com.   172800  IN  A 50.19.85.132
heroku.com.   172800  IN  A 50.19.85.154

;; Query time: 357 msec
;; SERVER: xx.xx.xx.xx#53(xx.xx.xx.xx)
;; WHEN: Mon Oct 31 15:07:37 2016
;; MSG SIZE  rcvd: 76
---

I'm obfuscating my DNS IP, of course. The important bit is that you can see that my DNS is returning a TTL of **172800 seconds** now. My local notebook cache should keep it that long now as well.

And now my organization should (possibly) be protected against another DNS DDoS attack like we had with Dyn DNS. Zerigo already went through that. SimpleDNS already went through that. Who knows which one will suffer next, maybe all of them again.

As I said before, I am not 100% sure this is a good mitigation. We will see if it works on the next Mirai attack. And a final **BIG DISCLAIMER**:

> EVERY DNS recursive server MUST obey the authoritative TTL!! TTLs exist for many important reasons, so if you manage a publicly available DNS server, you MUST NOT override the TTL with a minimum cache time like I did. Make sure you know what you're doing!

Are you an experienced whitehat hacker? Let me know if there's something easier/more secure. The goal is not to fix the internet, just to protect the productivity of my tiny organization.
