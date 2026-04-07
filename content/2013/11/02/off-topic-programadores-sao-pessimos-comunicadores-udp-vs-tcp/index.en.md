---
title: "[Off-Topic] Programmers Are Terrible Communicators (UDP vs TCP)"
date: '2013-11-02T13:49:00-02:00'
slug: off-topic-programadores-sao-pessimos-comunicadores-udp-vs-tcp
tags:
- off-topic
- career
draft: false
---

We programmers live in the Matrix: we think we know what we're doing and that the rest of the world is too dumb to understand us. After all, we all know how to go to a Github, read code, discuss on Hacker News and Reddit, and the rest of the world only knows how to post on Instagram and Facebook. So, _obviously_, we're better, and whoever doesn't understand us is the one who must make the effort to change.

Having lived on every side for a long time I have news for you: programmers are **terrible** communicators. There's a communication impedance that is seriously becoming an inability. The impression we have in programming communities is that code is the only universal language. But _"show me the code"_ isn't everything. Some time ago I [answered on Quora](https://www.quora.com/Software-Engineering/What-is-the-hardest-thing-you-do-as-a-software-engineer/answer/Fabio-Akita?share=1) that the hardest thing for every Software Engineer to understand is that 90% of a project's problems aren't solved with code.

Without wanting to generalize, but just to illustrate: in the open source world (for those who participate) it gives the impression that it's the opposite, but note that the vast majority make small contributions, sporadically, and even those who participate more actively are still having a fragmented experience. In fact, the software will be ready only when it's ready. And with that, the vast majority of open source projects actually fail.

For every JQuery that succeeds, dozens of other JavaScript libraries aren't even recognized — even having some technically better aspects. The big and best-coordinated ones, and that have brute force (more than enough contributors), tend to do better. But it's not efficient — it just looks that way. And the ones that are big show a very different organization, with release dates, feature roadmaps, and they begin to converge to what we know as real "projects."

In the real world, we don't have so much spare time, so many spare people, the direct risks are much greater, and we want more control over the results. I won't even get into the merits of the best ways, but fundamentally, in the real world, communication is the difference between failure and success.

## Informing Isn't Communicating!

The first thing you need to understand is the following: just because the information "exists" or you put it in a shared place, that's not communicating.

Communication has 4 ends: the communicator, the recipient, the message, and the medium of transmission. Programmers normally assume 2: the communicator (themselves) and the message — the rest is ignored. Let's define this better:

<blockquote>
"Communication only happens when the recipient receives and understands the message. If that didn't happen, no communication existed."
</blockquote>

Let's go down a level and speak in "geek": there's a client, a server, a protocol, and a medium of transmission. If you packaged the message according to the protocol, opened the connection with the server, tried to send the message, but it didn't finish and came back with an error, we know communication didn't exist.

In the [TCP/IP](http://packetlife.net/blog/2010/jun/7/understanding-tcp-sequence-acknowledgment-numbers/) world, first we send a SYN (which initiates communication), receive back a SYN-ACK (acknowledgement from the server saying it received the SYN), and send an ACK to indicate connection established. We perform this handshake and manage to sequence the sending and receiving of packets in such a way that we guarantee that what was sent was entirely received.

In this metaphor, I'd say most programmers understand UDP better — they send datagrams of information and don't worry whether the recipient received all the packets, they just keep sending. It really gives the impression that programmers think UDP, just look:

* they don't want to wait for a handshake to ensure that the connection was established
* they send small packets of fragmented information, little protocol overhead
* TCP worries about [congestion control](http://en.wikipedia.org/wiki/TCP_congestion-avoidance_algorithm) and does throttling, UDP keeps sending even if the router drops the packets
* if a packet is lost, UDP doesn't worry about resending
* it thinks it seems more efficient to do broadcast and multicast

It works well for communication to large groups, broadcast, where if a percentage receive the message that's enough. I'd say UDP works fine in the fragmented open source world, but in a world where establishing a connection and ensuring delivery of the message is important, we go with TCP.

TCP works because even with a bad connection, even with a half-baked server, you control the data stream and ensure that all the data was received, in the correct sequence, and 100% of what was sent was received. In UDP, if the medium is bad, if the server receives corrupted information, it doesn't care, it just keeps sending.

Both protocols are useful, but if we need to be sure that the information was received correctly and integrally, we need to use TCP. I'd say in the open source world there's no problem with you using UDP to communicate, lowering latency and being more "efficient." But in the non-open-source world (and that means not just software, but outside of software), we need to be more TCP. The advantages of TCP?

* ensuring the connection was established before sending information
* ensuring the order of the information, rearranging packets if necessary
* moderating the speed of transmission so as not to flood the other side
* guarantee of message delivery, not just transmission
* error checking, to ensure the information wasn't corrupted
* "acknowledgment," ensuring that the other side received and understood the information

See the difference? It seems to take longer, but it's that old story: delivering fast but having to keep delivering several times ends up being slower than ensuring it was understood the first time. It's like making code without tests — it seems faster, but then come the consequences.

So, programmers, adjust your protocols, be more TCP than UDP.
