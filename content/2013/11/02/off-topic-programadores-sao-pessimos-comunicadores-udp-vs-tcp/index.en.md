---
title: "[Off-Topic] Programmers Are Terrible Communicators (UDP vs TCP)"
date: '2013-11-02T13:49:00-02:00'
slug: off-topic-programadores-sao-pessimos-comunicadores-udp-vs-tcp
translationKey: off-topic-programadores-sao-pessimos-comunicadores-udp-vs-tcp
description: "Using UDP and TCP as a metaphor, the text says programmers confuse informing with communicating. Real projects require confirming connection, context, order, understanding, and message delivery."
tags:
- communication
- career
- off-topic
draft: false
---

We programmers live in the Matrix: we think we know what we're doing and that the rest of the world is too dumb to understand us. After all, we all know how to get on Github, read code, and argue on Hacker News and Reddit, while the rest of the world only knows how to post on Instagram and Facebook. So, _obviously_, we're the better ones, and whoever doesn't understand us is the one who has to make the effort to change.

Having lived on every side for a long time, I have news for you: programmers are **terrible** communicators. There's a communication impedance that is turning into a serious disability. Inside programming communities the impression is that code is the only universal language.

But _"show me the code"_ isn't everything. Some time ago I [answered on Quora](https://www.quora.com/Software-Engineering/What-is-the-hardest-thing-you-do-as-a-software-engineer/answer/Fabio-Akita?share=1) that the hardest thing for every Software Engineer to understand is that 90% of a project's problems aren't solved with code.

Without wanting to generalize, just to illustrate: in the open source world it gives the impression that it's the opposite. But note that the vast majority make small, sporadic contributions, and even those who take part more actively still live a fragmented experience. The software is ready only when it's ready. And in the end, the vast majority of open source projects fail.

For every jQuery that makes it, dozens of other JavaScript libraries never get recognized, even with some technically better aspects. The big, best-coordinated ones, with brute force and contributors to spare, tend to fare better. But brute force only looks like efficiency. And the ones that grow show a very different organization, with release dates and feature roadmaps, converging toward what we know as real "projects."

In the real world, time is short, people are few, the direct risks are much greater, and we want more control over the results. I won't get into the merits of the best ways to do it, but deep down, in the real world, communication is the difference between failure and success.

## Informing Isn't Communicating!

The first thing to understand is simple: just because the information "exists," or you dropped it somewhere shared, that doesn't mean you communicated.

Communication has 4 ends: the communicator, the recipient, the message, and the medium of transmission. Programmers usually take on only 2, the communicator (themselves) and the message, and ignore the rest. Let's define this better:

<blockquote>
"Communication only happens when the recipient receives and understands the message. If that didn't happen, no communication existed."
</blockquote>

Let's go down a level and speak "geek": there's a client, a server, a protocol, and a medium of transmission. If you packaged the message according to the protocol, opened the connection to the server, and tried to send it, but the transmission never finished and came back with an error, we know communication didn't happen.

In the [TCP/IP](http://web.archive.org/web/20131105125105/http://packetlife.net:80/blog/2010/jun/7/understanding-tcp-sequence-acknowledgment-numbers/) world, first we send a SYN, which initiates communication. We get back a SYN-ACK, the server's acknowledgement that it received the SYN, and we send an ACK to signal the connection is established. With this handshake, we manage to sequence the sending and receiving of packets and guarantee that everything sent was received in full.

In this metaphor, I'd say most programmers understand UDP better. They fire off datagrams of information and don't worry whether the recipient got all the packets, they just keep sending. It really gives the impression that programmers think in UDP, just look:

* they don't want to wait for a handshake to make sure the connection was established
* they send small packets of fragmented information, little protocol overhead
* TCP worries about [congestion control](https://en.wikipedia.org/wiki/TCP_congestion-avoidance_algorithm) and does throttling, UDP keeps sending even if the router drops the packets
* if a packet is lost, UDP doesn't bother resending
* it figures broadcast and multicast look more efficient

It works fine for communicating to large groups, in broadcast, where it's enough for a percentage to get the message. I'd say UDP works reasonably well in the fragmented open source world. But in a world where establishing a connection and guaranteeing delivery of the message matters, we go with TCP.

TCP works because, even with a bad connection, even with a half-baked server, you control the data stream and make sure everything arrived, in the correct sequence, with 100% of what was sent received. In UDP, if the medium is bad, if the server gets corrupted information, it doesn't care and keeps sending.

Both protocols are useful. But if we need to be sure the information was received correctly and in full, we need TCP. In the open source world, using UDP to communicate, cut latency, and be more "efficient" is fine. Outside the open source world, and that goes far beyond software, we need to be more TCP. The advantages of TCP?

* making sure the connection was established before sending information
* guaranteeing the order of the information, rearranging packets if necessary
* moderating the transmission speed so as not to flood the other side
* guarantee of message delivery, not just transmission
* error checking, to make sure the information wasn't corrupted
* "acknowledgment," making sure the other side received and understood the information

See the difference? It looks like it takes longer, but it's the old story: delivering fast and then having to redeliver several times ends up slower than making sure the message got through the first time. It's like writing code without tests, it looks faster, but then come the consequences.

So, programmers, adjust your protocols. Be more TCP than UDP.
