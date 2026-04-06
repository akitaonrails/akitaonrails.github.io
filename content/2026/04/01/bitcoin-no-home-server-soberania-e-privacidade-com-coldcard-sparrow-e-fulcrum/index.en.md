---
title: "Bitcoin on the Home Server: Sovereignty and Privacy with Coldcard, Sparrow and Fulcrum"
date: '2026-04-01T19:00:00-03:00'
draft: false
slug: bitcoin-on-the-home-server-sovereignty-with-coldcard-sparrow-fulcrum
translationKey: bitcoin-home-server-sovereignty
tags:
  - bitcoin
  - homeserver
  - self-hosting
  - privacy
  - security
  - lightning
---

This post is a direct follow-up to my recent articles about the [new home server with openSUSE MicroOS](/en/2026/03/31/migrating-my-home-server-with-claude-code/) and the [Minisforum MS-S1 Max](/en/2026/03/31/minisforum-ms-s1-max-amd-ai-max-395-review/). Those covered the foundation. Here I want to show one concrete use for it: putting together a decent Bitcoin stack at home, focused on privacy, operational sovereignty and safe transactions on my side.

First things first: this isn't an evangelism piece or a day-trading pitch. Quite the opposite. As I write this, on April 1, 2026, Bitcoin is around US$ 68k and close to R$ 391k, below the 2025 peaks. Plenty of people look at that and either panic or start fantasizing about leveraged trades. I think both reactions are wrong. There's a "super cycle" thesis floating around based on institutional demand, spot ETFs and the lagged halving effect. Maybe. Maybe not. What I do know is that short-term candles don't change the part I actually care about: infrastructure. If you need leverage to "speed up your gains," you're probably just speeding up your chances of getting liquidated.

For me, the useful question isn't "is it going up tomorrow?" The useful question is: "if I want to store and move Bitcoin without outsourcing everything to an exchange, a web wallet and a public API, how do I set that up properly at home?"

## The real problem: too much convenience costs too much privacy

Most people's default flow is simple: buy on an exchange, leave the balance sitting there, or install some random wallet on the phone and call it done. It works. It also concentrates risk and leaks metadata everywhere.

If you leave a balance on an exchange, you have custody risk. If you use a desktop wallet pointed at a public server, you have privacy risk. If you use a hardware wallet casually, bought second-hand on Mercado Livre, you have supply chain risk. Mix all that with hurry, and it gets worse.

That's why I ended up at a combination that, for someone technical who wants to run their own infra, feels pretty solid:

- Coldcard for cold storage
- Sparrow Wallet on Linux as the desktop wallet and transaction coordinator
- Fulcrum on the home server as a private Electrum server
- bitcoind on the same server as a real full node, validating the chain and broadcasting without depending on third parties

It's not the easiest path. But that's exactly the point. Real security rarely comes from the easiest path.

## The concepts that confuse beginners

Before getting into the stack, it's worth aligning on four terms that usually get tossed around like everyone already knows them:

| Concept | What it is | Why it matters |
|---|---|---|
| Airgap | A device that never touches the internet, not even over data USB | Reduces the signer's attack surface |
| PSBT | Partially Signed Bitcoin Transaction | Standard format for preparing, signing and finalizing transactions in stages |
| Watch-only wallet | A wallet that sees balances/addresses but doesn't hold a private key | Great for the desktop: it observes and assembles the transaction, but doesn't sign |
| Full node | A node that validates blocks and protocol rules locally | You don't have to "trust" anyone's API |
| Electrum server | An indexing layer that quickly answers wallet queries | Without one, desktop wallets end up dependent on public servers |

In plain language, the flow looks like this:

1. Sparrow, on the desktop, builds the transaction.
2. That transaction becomes a PSBT.
3. The PSBT goes to the Coldcard via microSD.
4. The Coldcard signs it offline.
5. The signed file goes back to Sparrow.
6. Sparrow broadcasts through your own server, not through someone else's public infrastructure.

That's what people mean by "airgapped workflow." It's not magic. It's just disciplined separation of roles.

## Coldcard: cold signer, offline, the right kind of annoying

I use [Coldcard](https://coldcard.com/) as cold storage. The reason is simple: it was designed from day one as a Bitcoin-only device, with a heavy focus on airgapped operation through microSD. That alone eliminates an entire category of "conveniences" that many people find practical, but that I'd rather not have anywhere near my keys.

[![Coldcard Mk4 on the official Coinkite site](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/01/bitcoin-sovereignty/coldcard-mk4-official.png)](https://coldcard.com/mk4)

In practice, the Coldcard holds the most important part of the system: the private key. It doesn't need to know about a server, Electrum, public API, exchange, or any of that. Its job is one thing: sign transactions offline.

That decoupling is great for two reasons:

- The desktop can be convenient without becoming a single point of failure.
- The signer stays isolated even if your main machine has problems.

And here's a warning I really want to put in mental all-caps:

**Never buy a hardware wallet second-hand. Ever.**

This isn't an exaggeration. You have no way to actually know what happened to that device before it reached your hands. It could have a pre-generated seed, tampered firmware, swapped components, repackaged box, compromised supply chain, or simply some dumb trick waiting for you to let your guard down. Hardware wallet is one of those categories where saving R$ 300 buying used is insanity. Always buy from the manufacturer's official site or from a reseller officially authorized by the manufacturer. And even then, check seals, provenance and firmware.

## Can you do something similar with an old phone?

You can. But I'd treat it as a study or budget alternative, not as an obvious substitute for a Coldcard.

The most serious path for that today is [AirGap Vault](https://airgap.it/), which was specifically designed to use an old smartphone as an offline signer over QR codes, keeping the device off the network. The idea is good, and for many people it might be the right entry point.

But there are trade-offs:

- An old smartphone wasn't designed as a dedicated hardware wallet
- The device's prior history matters
- An aged battery, bad screen and abandoned Android are real problems
- The threat model is less clear than on a dedicated device

So my view is simple: can you use it? Yes. Would I recommend it as the main solution for storing meaningful wealth? No. For that I still prefer dedicated hardware bought from the right source.

## Sparrow Wallet: the best desktop piece in this puzzle

On Linux, I use [Sparrow Wallet](https://sparrowwallet.com/). For me, today, it's one of the best pieces of software in this ecosystem.

[![Sparrow Wallet running, showing a detailed history of the wallet and transactions](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/01/bitcoin-sovereignty/sparrow-transactions.png)](https://www.sparrowwallet.com/features/)

What I like about it:

- works very well on Linux desktop
- supports hardware wallets properly
- understands PSBT without drama
- makes it crystal clear what's happening in a transaction
- it's great as a watch-only wallet

In my flow, Sparrow does three things:

1. Holds the watch-only wallet.
2. Builds the transaction with outputs and fees.
3. Receives the signature back from the Coldcard and broadcasts it.

That separation is elegant. The desktop becomes the coordinator. The signer stays cold.

## Why Coldcard + Sparrow works so well

This combo is good because each piece does what it does best:

- the Coldcard protects the key
- Sparrow organizes the human use of the wallet
- the server handles the infrastructure

A lot of wallets try to do everything. I prefer this modular design. It's less "magic," more explicit, and easier to reason about without lying to yourself.

If I'm at the desktop, I want visibility. If I'm at the signer, I want isolation. If I'm at the server, I want validation and a local index. That division is clean.

## The Sparrow problem when you don't run your own infra

Now comes the important detail. Sparrow alone doesn't solve privacy.

If you install it, open it and just use public servers, the people on the other end learn quite a lot about your wallet: your address set, xpubs or derivations, balance, history, query behavior, broadcast. It's not custody, but it's still exposure.

That's the hole Fulcrum fills.

## Fulcrum: the home's private Electrum server

[Fulcrum](https://github.com/cculianu/Fulcrum) is an Electrum server. Instead of letting Sparrow ask things of a third-party public server, it asks my own server.

In practice, that means:

- local balance lookups
- local history
- local address discovery
- local broadcast

In other words: the desktop wallet stops "phoning home" to the world every time you open the program.

In my current setup, Sparrow points at a Fulcrum running on the home server on the LAN, with port `50001` on the internal network and `50002` with TLS.

## And why Fulcrum isn't enough on its own

Because Fulcrum doesn't replace a full node. It indexes on top of a full node.

The thing actually validating blocks, consensus rules, scripts, transactions and the chain is `bitcoind`. Fulcrum sits in front of it as an indexing layer, because plain Bitcoin Core wasn't built to serve a desktop wallet with that kind of fast querying.

So the correct architecture is:

```text
Coldcard (offline signer)
        ^
        | microSD / PSBT
        v
Sparrow Wallet (desktop watch-only + coordinator)
        |
        v
Fulcrum (private Electrum server)
        |
        v
bitcoind (full node)
```

## What I actually brought up on the home server

On my home server, the stack lives in a dedicated Docker Compose folder and is made of two containers:

- `bitcoin-bitcoind`
- `bitcoin-fulcrum`

The compose is simple. And that's good. Sensitive infra doesn't gain anything by getting clever in YAML.

The main design is this:

```yaml
services:
  bitcoin:
    image: lncm/bitcoind:v28.0
    container_name: bitcoin-bitcoind
    user: "${BITCOIN_UID}:${BITCOIN_GID}"
    restart: always
    security_opt:
      - label:disable
    volumes:
      - /srv/bitcoin/data:/data/.bitcoin
    ports:
      - "8333:8333"
    stop_grace_period: 5m
    healthcheck:
      test: ["CMD", "bitcoin-cli", "-datadir=/data/.bitcoin", "ping"]
      interval: 30s
      timeout: 10s
      retries: 5
      start_period: 60s

  fulcrum:
    image: cculianu/fulcrum:latest
    container_name: bitcoin-fulcrum
    restart: always
    security_opt:
      - label:disable
    volumes:
      - /srv/bitcoin/fulcrum:/data
      - /srv/bitcoin/data:/bitcoin:ro
    command: ["Fulcrum", "/data/fulcrum.conf"]
    ports:
      - "50001:50001"
      - "50002:50002"
    depends_on:
      bitcoin:
        condition: service_healthy
```

In my case, the restriction of `50001` to LAN happens at the host's network layer. The YAML above is the skeleton of the stack, not the entire firewall policy.

The most important parts of this:

- `restart: always` because this is a long-running service
- explicit volume so state isn't lost
- `user: "${BITCOIN_UID}:${BITCOIN_GID}"` because the persistent directory needs to match the storage's real ownership, so I'd rather pin UID/GID explicitly than trust the image's default
- the RPC isn't published on the host; it stays on the Compose internal network, which is all Fulcrum needs
- the healthcheck uses Bitcoin Core's own local `.cookie`, so there's no need to spread a fixed password through commands
- Fulcrum mounts the node's datadir as read-only just to authenticate via the `.cookie` without inventing parallel credentials
- in `fulcrum.conf`, that becomes a simple configuration: talk to `bitcoin:8332` and read the mounted `.cookie`, instead of repeating credentials in plaintext
- `security_opt: label:disable` because on this host with MicroOS, SELinux and sensitive bind mounts, I preferred the pragmatic route of disarming this specific friction rather than wasting time fighting labels on a volume that's already being handled in a controlled way
- `depends_on` with `service_healthy` so Fulcrum only comes up after bitcoind's RPC is responding
- `stop_grace_period: 5m` because bitcoind needs real time to flush state on a graceful shutdown

## The final version

Today, the design I want to keep is this: `bitcoind` with `txindex`, `dbcache=1024`, persistent volume, 5-minute graceful stop, `.cookie` authentication, and Fulcrum in front serving Sparrow over LAN or TLS.

The current stack looks like this:

| Component | State |
|---|---|
| Bitcoin Core | `28.0` |
| Fulcrum | `2.1.0` |
| Container stop timeout | `300` seconds |
| Node data dir | dedicated persistent volume mounted at `/data/.bitcoin` |
| Network | `8333` for P2P, RPC only on the Compose internal network, `50001/50002` for the private Electrum |

I'm not interested in turning this into a spectacle. The point is simpler: the final infrastructure has to be boring, predictable and stable.

## The tunings that actually matter

There's no magic here. There are a few parameters that make a real difference and a bunch of stuff that just decorates compose files.

`stop_grace_period: 5m` exists because bitcoind isn't a disposable stateless API container. It maintains chainstate, indexes and an in-memory cache. If you don't give the process time to finish properly, you create unnecessary work for the next start.

`user: "${BITCOIN_UID}:${BITCOIN_GID}"` is there for a much less glamorous and much more important reason: persistent storage with the wrong permissions is an excellent way to break a working service. So I'd rather align the container with the volume's actual ownership instead of leaving that implicit.

`dbcache=1024` is the spot I find most reasonable for a domestic node that's always on. Big enough not to suffer constant I/O, small enough that every restart isn't a labor.

`txindex=1` I keep because I want the complete node, not a minimalist install just to claim "it runs Bitcoin." If the goal here is operational autonomy, I'd rather have the full index.

`rpcworkqueue=512` and `rpcthreads=16` are the kind of tweak that makes sense when you know you'll have Fulcrum querying the node all day and you want some headroom.

On the Fulcrum side, the main parameters are:

- `db_mem = 8192`
- `db_max_open_files = -1`
- `bitcoind_clients = 8`
- `worker_threads = 0`
- `peering = false`

Again: nothing esoteric. Just enough cache, reasonable parallelism and absolutely no announcing this server as a public service.

In my current `bitcoin.conf`, the important core ended up like this:

```ini
server=1
txindex=1
prune=0
rpcbind=0.0.0.0
rpcallowip=172.0.0.0/8
rpcthreads=16
rpcworkqueue=512
dbcache=1024
maxmempool=512
```

All of this makes sense on a server with decent RAM and fast NVMe. But the detail that matters most is still the clean shutdown. Wallet infrastructure has no room for "we'll deal with it later" thinking.

## The actual size of all this

This is another point a lot of people underestimate.

If you look at older Bitcoin Core documentation, you'll find numbers like 350 GB of disk for a node with default config. That's outdated. More current data on the size of the blockchain points to something around **725.82 GB on March 11, 2026**, and that's just the raw chain, without the extra indexes that many technical folks will want to keep.

And here comes the catch: the stack I'm describing isn't "a bare Bitcoin Core just to claim you run a node." It's `bitcoind` with `txindex`, plus Fulcrum, plus headroom for rebuild, logs, snapshots and normal network growth.

So to put together something similar today, I'd think like this:

- below 1 TB: I wouldn't even start
- 1 TB: pragmatic minimum
- 2 TB: comfortable range
- above that: if you want long-term headroom, snapshots and less operational anxiety

And here's the most important observation of all in self-hosting: don't assume persistence, mount and backup are right just because the YAML looks clean. Verify.

Another thing I wouldn't forget on a btrfs host: put Fulcrum's database (`fulc2_db`) on a separate subvolume. The reason is mundane. That directory grows, changes constantly and has nothing to do with generic automated snapshots of `/var`. If you mix everything, you end up dragging a large rebuildable index along with system snapshots, burning space and making maintenance more annoying than it needed to be. The Fulcrum index isn't sensitive configuration. It's heavy, volatile, rebuildable data. I treat it exactly like that.

## Hardening: what I've already applied

This is where the difference between "ran on my laptop" and "I'd trust this to operate my wallet" shows up.

In the current state of the stack, the points I consider important ended up like this:

- Bitcoin Core's RPC no longer relies on unnecessary host exposure; Fulcrum talks to `bitcoind` over the Docker internal network, which is what actually matters
- `50001` is restricted to internal LAN use
- `50002` is available with TLS, which is the right move when you need to leave plaintext behind
- shutdown is graceful, with `stop_grace_period: 5m`, so `bitcoind` has time to flush state instead of dying any old way
- the storage mount isn't on a "we'll see later" basis; there's a mount check before Docker comes up, precisely to avoid silent drift

Each of those items exists for a very concrete reason.

Pulling the RPC off the host's surface reduces attack at zero cost. Fulcrum is already in the same Compose and can already talk to the service by its internal name. There's no real gain in leaving that port exposed where it doesn't need to be exposed.

Separating `50001` and `50002` also helps keep the house in order. Within a controlled LAN, plaintext is acceptable. Outside of that, the minimum reasonable thing is TLS. Mixing the two scenarios usually turns into a mess.

`stop_grace_period: 5m` looks like a container detail, but it isn't. Anyone who's ever had a database, an index or a blockchain node killed without grace knows how that turns into hours of work later. A stateful service needs a decent stop.

And the mount check is one of those annoying things that saves you from yourself. The YAML can look beautiful. If the storage didn't mount and the service came up writing where it shouldn't, you've just manufactured a really irritating problem.

There's also one detail I really like in this final version of the stack: Fulcrum authenticates to `bitcoind` through the `.cookie` file, not through a fixed plaintext password. That's interesting for two reasons:

- you don't need to leave a static credential showing up in compose, inspect, healthcheck or documentation
- the authentication is more aligned with the way Bitcoin Core already knows how to operate locally

In practical terms, that reduces accidental leakage of operational secrets. It's not a magic solution to everything, but it's much better than spreading `rpcuser` and `rpcpassword` across files, logs and commands.

The only kind of hardening I try to avoid here is the one that's overly performative in YAML and loose in operation. I'd rather have less "stage engineering" and more basic discipline:

- minimum network
- minimum secrets
- minimum privilege
- clean shutdown
- verified storage
- separate subvolume for large rebuildable data, like the Fulcrum index

And, again, document everything. Good infrastructure isn't the kind that just works today. It's the kind that keeps working when you come back to it six months later.

## Why this improves transactions on your side

When I build a transaction in Sparrow and sign it on the Coldcard, the chain of trust is much better defined:

- the private key never touches the internet
- the desktop wallet doesn't have to trust a public server
- the broadcast can come out of my own node
- the address history doesn't need to land on a third-party Electrum server

This doesn't make anything invulnerable. There's still a risk of malware on the desktop, badly stored seeds, human error, social engineering and physical disaster. But the design becomes much more coherent.

## What about Lightning? Especially in Brazil?

There I separate things.

Reserves and larger-value transactions I treat one way. Day-to-day spending I treat another.

For day-to-day spending, especially in Brazil, I think it's operationally dumb to carry a lot of balance in a hot wallet. Lightning wallets and spending apps have to be almost like a "pocket wallet": just enough for daily life.

That goes double if you use a hybrid or custodial solution like [RedotPay](https://www.redotpay.com/). I get why it's interesting for Brazilians: a Hong Kong company, international focus, a reasonably practical bridge between crypto and card spending. For travel, online shopping and life outside the Brazilian banking axis, it makes sense. But I'd never treat it as a place to store wealth. That's a spending tool, not a vault.

Same logic for [Bitrefill Brasil](https://www.bitrefill.com/br/pt/). I think the service is interesting precisely because it solves a real pain in Brazil: turning sats into concrete utility without selling your full position or depending on banking integration all the time. Gift cards, top-ups, small expenses. As a use tool, it makes a lot of sense.

For a Lightning wallet on the phone, I'd look at first:

- [Phoenix](https://phoenix.acinq.co/) for people who want something very good and simple
- [Breez](https://breez.technology/) for people who want a great payments experience
- [ZEUS](https://zeusln.com/) if you're more technical and you eventually plan to operate your own Lightning node

All of them, in my head, fit into the "pocket wallet" category. Small balance. Daily use. Don't turn a phone app into a retirement vault.

## Recent news that reinforces this reasoning

I'm not building this kind of stack because I think it's pretty. I'm building it because outsourcing too much goes wrong too often.

Two recent examples:

- the [Bybit hack in 2025](https://www.cnbc.com/2025/02/21/hackers-steal-1point5-billion-from-exchange-bybit-biggest-crypto-heist.html) showed, again, the basic risk of leaving meaningful custody at an exchange
- the [Coinbase customer data leak in 2025](https://techcrunch.com/2025/05/15/coinbase-says-customers-personal-information-stolen-in-data-breach/) showed the other side of the problem: even when custody isn't the immediate concern, your identity, balance and history become an attack surface

A stack like Coldcard + Sparrow + Fulcrum + full node doesn't eliminate every risk in the world. But it avoids two very real classes of problem:

- losing custody sovereignty
- handing over wallet and transaction privacy on a silver platter to third parties

## So is it worth it?

For most people, honestly, probably not in the first month. It's labor-intensive, has a learning curve, and demands discipline.

But for programmers, engineers and any technical person who wants to learn not to depend on someone else's service all the time, I think it's an excellent exercise.

You learn about:

- separation of concerns
- persistence and state
- graceful shutdown
- observability
- secret isolation
- the trade-off between convenience and security

And all of that is valuable beyond Bitcoin.

In the end, that's what interests me most about this stack. It isn't about preaching "hyperbitcoinization" or posing as a price prophet. It's about building a system at home that I can trust more because I'm the one who installed it, measured it, broke it, fixed it and documented it.

Is it work? Yes.

But that kind of work teaches exactly what modern software tries to make you forget: depending less on others is more work upfront, but it usually buys a lot more control in the long run.
