---
title: "Disaster on My NAS! How I Almost Lost 90 TB of Data"
slug: "disaster-on-my-nas-how-i-almost-lost-90-tb-of-data"
date: '2026-10-06T12:00:00-03:00'
draft: false
translationKey: desastre-no-meu-nas-como-quase-perdi-90-tb-de-dados
description: "I swapped one drive in my Synology DS1821+ and woke up the next day with two critical drives in an array that only survives losing one. This is the post-mortem, still in progress: why SHR-1 wasn't enough, the warning DSM never sent, the R$ 185 thousand for a QNAP bought in a hurry in Brazil against about US$ 11.5 thousand in the US, the new RAID-6 setup on ZFS, and copying 90 TB at 400 MB/s."
tags:
- storage-and-backup
- homelab
- hardware
---

Yesterday, Monday, I was woken up at 8 a.m. by a loud, insistent beep. I knew it was the NAS before I opened my eyes. I ran to check, and nearly lost it: two drives marked as critical, in an array that can never have more than one.

![Synology panel showing Storage Pool 1 in critical state, with drives 1 and 8 marked Critical](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20261006120000_nas-synology-2-discos-criticos.png)

At that moment I knew I was a hiccup away from losing everything. This post is the post-mortem of what happened, and it's still in progress: as I write, the rescue copy is still running.

## I've been using a NAS for a long time

I'm not new to this. I made an [entire video mini-series on storage and filesystems](https://www.youtube.com/playlist?list=PLdsnXVqbHDUcM0LTAxqrVrTy6Q7jQprjt) (in Portuguese), and I recommend watching it before asking me "what's a good beginner NAS?". There is no such thing.

I've used external storage since the second half of the 2000s, when I was a Mac user and Drobo existed. The company is gone, but I had three of their DAS units before migrating to Synology, first on an entry-level model and then on the mid-tier DS1821+, which I've been using for more than five years. I've written about it here, [setting up NFS on Linux](/en/2025/04/17/configuring-my-synology-nas-with-nfs-on-linux/) and [accessing it over iSCSI](/en/2025/04/24/accessing-your-nas-using-iscsi-instead-of-smb/).

It's been very valuable to me, and you don't get to question why I need that much space. It doesn't matter: everyone decides what they keep on theirs.

When I was producing YouTube videos, I edited 4K footage straight from the NAS, thanks to the NVMe cache and 10 GbE networking. I got used to big storage at 10 gigabits and I can't go back.

The array was organized in SHR, Synology's hybrid RAID, which in practice behaves like RAID-5 (more on that later): it survives the loss of one drive without losing any data. I always thought that was enough.

## Hard drives die. Always

Make no mistake: hard drives go bad. Never, ever trust a lone drive forgotten in a closet. It will fail, and you will lose everything on it.

The best public data on this comes from Backblaze, which runs hundreds of thousands of drives and publishes failure rates every quarter. In the [Q2 2026 report](https://www.backblaze.com/blog/backblaze-drive-stats-for-q2-2026/), with 354,415 drives monitored, the annualized rate was 1.73%, and the lifetime rate for the whole fleet stands at 1.41% per year.

That sounds small. Translated to human scale:

- **One drive on its own, for 5 years:** the chance of it dying in that period is close to 7%. That's roughly the chance of rolling one specific number on a 14-sided die. Would you bet every family photo on that?
- **One drive on its own, for 10 years:** about 13%, one in eight.
- **Eight drives, like my NAS, for one year:** the chance of at least one failing is about 11%. In five years, more than 40%.

And those numbers are from a datacenter, with controlled temperature, clean power and drives spinning all the time. A drawer drive that sits idle for years and gets knocked around in a move doesn't have statistics that pretty.

Memory cards are worse, and there isn't even an equivalent statistic to consult. What exists is torture testing: the [Great MicroSD Card Survey](https://www.bahjeez.com/the-great-microsd-card-survey-one-year-later/) tested 216 cards over a year of continuous writing, and 52 of them, one in four, had already died.

Genuine cards started throwing errors, on average, after about 2,500 rewrite cycles; counterfeit cards, after 700. A memory card is transport media. Keeping the only copy of anything on a microSD is asking to lose it.

The practical conclusion is the same as in the mini-series: important data needs redundancy. A parity array exists precisely so that the death of one drive, which is a matter of time, doesn't take anything with it.

## What happened

With all that, I should have been at ease with my setup. I wasn't.

It started the day before yesterday, Sunday. For a while I'd been watching the volume approach the ceiling.

At first it was 8 drives of 10 TB. Over the years I swapped them, one by one, for 20 TB drives (DSM shows binary units; on the label they're 12 and 22 TB). It's a slow process: each swap takes days, because the array has to rebuild and redistribute the data.

I decided to swap one more, the seventh. Synology supports hot-swap, so it's simple: pull the old drive, slot in the new one, add it to the array and let DSM handle the rebuild.

![Synology Storage Pool 1 repairing, 0.01% complete, with 108 TB allocated out of 121.8 TB](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20261006120000_nas-synology-pool-reparando.png)

On Sunday night it looked like this: rebuild starting, all eight drives healthy, 108 TB allocated out of 121.8 TB.

On Monday, at 8 a.m., the beep. Drive 1, the new one, with 13 hours of use, marked critical:

![Synology drive 1 in critical state, with an I/O error and 13 hours powered on](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20261006120000_nas-synology-drive1-critico.png)

And drive 8, one of the old ones, with 22,095 hours powered on (two and a half years), also critical, with a read error at 08:05:

![Synology drive 8 in critical state, with a read error and the message that the number of failed drives exceeds the RAID's fault tolerance](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20261006120000_nas-synology-drive8-critico.png)

The pool's message left no room: "Unrecoverable errors have occurred because drive errors occurred after storage pool degradation. Please back up your data immediately."

### Why two drives is the end

In RAID-5, if two drives go down, redundancy is zero, and in theory the whole array goes with them. It's an unrecoverable situation.

Anyone who watched my playlist knows why. An array like this doesn't store "files," one per drive. A file is a collection of blocks, and the blocks are spread across all the drives, along with the parity. Losing a drive is losing a piece of every file. It doesn't matter that the other seven are healthy, because they only have parts.

Parity is there to recompute the missing piece when one drive disappears. With two missing, the math doesn't close.

And there's a cruel detail in the rebuild: to recreate the new drive, the array has to read every other drive end to end. That's more than 100 TB of continuous reading. If some old drive had a bad sector hiding in a corner nobody had read in a long time, that's when it shows up. That's what happened with drive 8.

## Where do you copy 90 TB to?

The only way out, at that point, was to thank the heavens that the volumes were still accessible, with the files showing up, and use the window to copy everything out immediately. I couldn't touch anything else.

The problem: copy about 90 TB to where? Nobody has an empty 100 TB NAS lying around at home.

Normally I'd buy this kind of hardware in the United States, on a tourist trip, and bring it back with me. It's much cheaper. Buying expensive electronics in Brazil isn't worth it: the country has charged import taxes worse than Trump's tariffs for decades, and the final price usually goes past double the American list price.

Except I had to choose. What is it worth to lose 90 TB of data I spent years collecting and that is nearly impossible to recover from anywhere else? It's one of those situations where the answer is "it's priceless," and so, whatever the price, I pay.

I found a storage reseller close to home, [Controle Net](https://www.controle.net). Good people, very quick to respond, and they sent me a proposal for equipment with same-day delivery.

Their first suggestion was a QNAP TS-832PX. I researched it before accepting. It has the same 8 bays and ships with 10 GbE, but the processor is a 1.7 GHz ARM Cortex-A57 (Annapurna Labs AL324) with 4 GB of RAM, half the 8 GB minimum that QuTS hero asks for. For RAID-6 on ZFS, with checksums and double parity on every block, that's weak hardware, as I explain further down. And it would be a downgrade from the DS1821+ I already had, which runs on a Ryzen V1500B.

I asked for another option, and after some back and forth I settled on a QNAP TS-873A, 8 bays, with the same Ryzen V1500B as my Synology, 8 GB of RAM, and 10 Toshiba MG11 24 TB enterprise-class drives.

This is why you have to do your own research and know, objectively, what you want to do with the equipment. The reseller didn't act in bad faith: they suggested an 8-bay NAS to someone who asked for an 8-bay NAS. The one who knew it would run ZFS in RAID-6 was me. If I had accepted the first proposal in a panic, I'd have paid a lot for a worse machine than the one I was replacing.

![Reseller proposal: QNAP TS-873A, 10 Toshiba MG11ACA24TE 24 TB drives, installation, training and 6 years of support, total R$ 185,320.00](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20261006120000_nas-proposta-qnap.png)

R$ 185,320.00. Eye-watering.

### What it would cost in the United States

I checked today's American list prices. About the exchange rate: the dollar is at R$ 4.97 right now, but that's the effect of Sunday's first-round election results, which knocked the rate down more than 4% on Monday. Through Friday it closed at R$ 5.22, and that's the fair rate to compare with, because that's the rate the reseller's stock was built at:

| Item | US price | Total |
|---|---:|---:|
| QNAP TS-873A-8G ([QNAP store](https://store.qnap.com/ts-873a-8g-us.html), Newegg) | US$ 1,199 | US$ 1,199 |
| 10 × Toshiba MG11ACA24TE 24 TB ([B&H](https://www.bhphotovideo.com/c/product/1889900-REG/toshiba_mg11aca24te_24tb_mg10_series_7200.html)) | US$ 999.99 each | US$ 9,999.90 |
| 10 GbE card QXG-10G2T-X710 ([B&H](https://www.bhphotovideo.com/c/product/1643883-REG/qnap_qxg_10g2t_x710_dual_port_10gbase_t_10gbe_network.html)) | US$ 351.99 | US$ 351.99 |
| **Total** | | **~US$ 11,550** |

At R$ 5.22, about R$ 60 thousand. I paid R$ 185 thousand, more than three times that.

The comparison isn't perfect: the Brazilian proposal includes installation, training and six years of technical support, and the equipment was on my desk by the end of the same day. But it gives the measure of the Brazil effect.

If the rule of thumb is "double the American price," normal would be about R$ 120 thousand. The extra R$ 65 thousand is, in my own rough estimate, the sum of services, local stock of enterprise drives and my urgency. Whoever buys on a Monday morning with the array dying is in no position to haggle.

### And drives are expensive everywhere

To make it worse, this is the worst possible moment to buy hard drives. The AI bubble is sucking up production.

| Indicator | Before | Now |
|---|---|---|
| WD Blue 4 TB (Camelcamelcamel history) | US$ 67 to 85 | US$ 99, [nearly 50% more in five months](https://winbuzzer.com/2026/02/18/wd-seagate-2026-hard-drive-shortage-ai-data-centers-xcxwbn/) (February 2026) |
| Production capacity | available at retail | WD: 2026 practically sold out, with contracts through 2027 and 2028; Seagate: nearline capacity fully allocated |
| WD gross margin | 41.0% a year earlier | [54.1% in the quarter ended July 2026](https://datacenterdisk.com/news/hard-drive-prices-up-50-percent-2026) |

I thought Seagate had left the consumer market. I checked, and that's not quite it: it hasn't left, but in February 87% of its hard drive sales were already nearline drives, for datacenters, and WD gets 89% of its revenue from cloud customers and only 5% from retail. WD's CEO said the company is "pretty much sold out for calendar year 2026."

Seagate has said it won't expand production capacity; growth comes only from higher-density drives. For someone buying drives at home, the practical effect is similar to them having left: you get what the hyperscalers didn't want, at whatever price the seller asks.

## QNAP instead of another Synology

After spending the morning and afternoon between negotiation, paperwork and payment, by the end of the day I had the QNAP powered on next to the Synology.

Choosing QNAP went beyond availability. Synology has been making questionable business decisions.

In 2025 it launched the Plus line [requiring its own-brand drives or drives it certified](https://www.tomshardware.com/pc-components/nas/synology-walks-back-controversial-compatibility-policy-for-2025-nas-units-third-party-hdd-and-ssd-support-returns-with-diskstation-manager-7-3-update).

The own-brand ones are Seagate, Toshiba and WD drives rebadged with custom firmware, and anyone using something else was left without pool creation, health monitoring, deduplication or firmware updates. After the outcry, it [walked that back in DSM 7.3](https://www.howtogeek.com/synology-is-walking-back-its-drive-requirements/) and allowed HDDs and SATA SSDs from other brands.

Except M.2 pools still require the compatibility list. The uncertainty is left hanging: what stops them from doing it again?

Setting up the QNAP is very easy. QuTS hero, their ZFS-based system, is as simple to use as Synology's DSM.

## Fixing my mistake: RAID-6 and ZFS

This time I knew I had to configure RAID-6, which survives two drives failing at the same time. The downside is less total capacity, because the equivalent of two drives becomes parity instead of one. The upside is that I shouldn't have to go through an emergency like this again.

One of QNAP's strengths is supporting ZFS out of the box, well integrated and easy to use.

For those who don't know it: ZFS was born at Sun Microsystems, for Solaris, in the mid-2000s, and today lives on as OpenZFS on Linux and FreeBSD. It merges into one system what used to be three layers, the RAID, the volume manager and the filesystem. It keeps a checksum of every block, so it notices when a drive silently returns corrupted data, and repairs it on its own from parity. And it never overwrites data in place: every write goes to a new block, which makes snapshots practically free.

Its reputation as a RAM hog comes from two things. The first is the ARC, its cache, which by design takes up almost all the machine's free memory. That scares anyone looking at the graph, but it's cache: it gives the memory back when another process asks. The second is deduplication, which keeps a huge table with the hash of every block and needs it in RAM or it becomes unusably slow. The old rule of "1 GB of RAM per TB of disk" comes from there, and only applies to people who turn deduplication on.

Even without it, ZFS is heavier than ext4 or a simple Btrfs. Computing checksums, compression and double parity for every block costs CPU, and with little memory the cache shrinks and everything gets slow. On weak hardware, like an entry-level NAS with an ARM processor and 2 GB of RAM, it suffers.

QNAP asks for at least 8 GB for QuTS hero. Mine came with 8 GB and a quad-core Ryzen, which works for my use, which is storing large files and serving them over the network. Deduplication stays off.

I bought 10 drives for an 8-bay NAS, so two are left in the drawer as spares, for the day one fails.

![QNAP storage pool creation wizard: 8 disks in RAID 6, 126 TB, 5% over-provisioning, 5% guaranteed snapshot space and an 85% alert threshold](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20261006120000_nas-qnap-criando-pool-raid6.png)

For my simple setup, three settings:

- **5% over-provisioning.** It's a slice of the pool the system reserves and never hands out for data. ZFS always writes to new space and gets slow when the pool fills up near the limit; this slack keeps performance stable. On SSD pools it also extends drive life, but these are hard drives, so the minimum is enough.
- **5% guaranteed snapshot space.** It's the reserve for snapshots, the "photos" of the state of your files that let you go back after an accident or ransomware. Guaranteeing the space means the snapshots keep existing even if I fill up the rest. My data changes little (it's mostly cold archive), so snapshots take almost nothing and 5% is plenty.
- **Alert at 85%.** The system warns me when the pool passes 85% usage, with room for me to act before hitting the ceiling. It was exactly the lack of room that had me swapping drives in a hurry on the Synology.

Adding the two reserves, about 13 TB are set aside and 112.9 TB are left for use.

A detail of my case: I'm copying the 90 TB with snapshots turned off, and I'll only enable the schedule after the copy finishes. A snapshot protects a file's previous state, and on an empty NAS receiving its first load there is no previous state worth protecting. The source of truth is still the Synology.

And there's a practical cost. I stopped and restarted the job several times, deleted folders that had gone in by mistake and copied again. With snapshots on, every deleted thing would keep taking up space inside some snapshot, and I'd be filling the pool with the migration's own garbage. When everything is on this side and checked, then yes: scheduled snapshots, to protect me from deleting what I shouldn't and from ransomware.

After that I created one giant "thick" partition. In ZFS you can create a "thin" folder, which only takes up what's inside it and can promise more space than exists, or a "thick" one, which reserves the full size at creation. Since it's a pool with one owner and one use, thick is more predictable: the space is mine and nothing competes for it.

Finally, I created the shares and installed the HBS 3 app.

## Copying 90 TB

HBS 3 (Hybrid Backup Sync) is QNAP's app for backup and synchronization. It connects to another NAS, to rsync, FTP, SMB or the cloud.

![HBS 3 sync job creation screen, with the destination options: local NAS, remote NAS, Rsync, FTP and CIFS/SMB](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20261006120000_nas-hbs3-criar-job.png)

I connected to the Synology's SMB share and told it to sync everything.

![HBS 3 syncing from the Synology TERACHAD to the QNAP TS-873A](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20261006120000_nas-hbs3-job-sync.png)

I had to stop and restart a few times, tweaking the job settings, because it was absurdly slow. And the file count wouldn't stop growing:

![HBS 3 job status showing 45 million files and 865 TB calculated, at an average of 350 MB/s](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20261006120000_nas-hbs3-snapshot-explosao.png)

865 TB on a 108 TB NAS, and that's when I understood what was going on.

I excluded two kinds of path from the job:

- **The `#snapshot` directories.** On Synology, when you check "make snapshot visible," each shared folder gets a `#snapshot` subfolder with a full view of the folder at each point in time. Inside the Synology that takes no space, because a snapshot only stores the difference. Seen from outside, over SMB, every snapshot looks like a full copy of everything, and HBS was trying to copy them all.
- **The restic backup directories.** restic stores everything in hundreds of thousands of pack files of a few megabytes each. Network copying is fast with large files and suffers with small ones, because each one costs an open, metadata and a close. And those backups I'll redo from scratch on the new NAS.

With that, throughput rose to an average of 400 MB/s.

![QNAP resource monitor showing 414.8 MB/s received on the 10 GbE interface](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20261006120000_nas-qnap-400mbs.png)

That's less than half of what a 10 GbE network delivers, but it's more than three times the gigabit most people have at home. Both sides really are at 10 gigabits:

![QNAP 10 GbE adapter connected at 10 Gbps](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20261006120000_nas-qnap-10gbe.png)

![Synology LAN 5 interface at 10000 Mbps, full duplex](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20261006120000_nas-synology-10gbe.png)

Why doesn't it reach 1,000 MB/s? My main hypothesis is drive 8. The source array is degraded, and every read that goes through the affected pieces has to be recomputed from parity, with a drive that on top of that returns errors and retries. It makes sense that the Synology can't go faster than this.

There's a second factor, which my own screenshots give away: the Synology has jumbo frames on (MTU 9000), and the QNAP image shows the default MTU of 1500. That screenshot is from earlier; I've already changed the QNAP to 9000 as well.

Why it matters: MTU is the maximum size of each packet that travels on the network. At the default 1500 bytes, filling a 10-gigabit link means processing more than 800 thousand packets per second, and each packet costs CPU on both sides, for the header, the checksum and the interrupt. With jumbo frames each packet carries six times more data, so it's one sixth of the packets for the same volume, and more processor is left for moving files. It only works if everything in the path matches: both cards and the switch. If one side stays at 1500, the connection negotiates down to the smaller value and the other side's jumbo frames do nothing.

At 400 MB/s, 90 TB takes about two and a half days, and I prefer two and a half guaranteed days.

## What Synology explained

In parallel, I opened a ticket with Synology support. After some back and forth, I sent the logs. They responded fast, the same day, and I'll give them that. The engineer's explanation, summarized:

- Drive 8 had been logging media errors **for over a month**. A media error is when the NAS tells the drive to read a sector and the drive answers that it couldn't, even after several retries. It's always an internal drive failure, and the drive should have been replaced.
- It was drive 8's poor health that took it down during the rebuild of drive 1.
- In practice I lost two drives, and the pool should have crashed completely. It didn't because of how SHR works.

SHR isn't a single RAID-5. To use drives of different sizes without wasting space, it slices the drives and builds several smaller RAIDs, one per size band, and joins everything into one volume. The engineer sent this example diagram:

![Synology support diagram showing how SHR splits drives of different sizes into partitions 1, 2 and 3](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20261006120000_nas-synology-shr-particoes.png)

In my case, the pool is made of two partitions. In the first, the rebuild of drive 1 was far enough along and the failure of drive 8 was mild enough that both kept working. In the second, both are missing. That's why the pool didn't crash entirely and I can still see the files.

His recommendation was the one I was already following: copy everything out before anything else, because there's no telling whether the situation gets worse or whether it's fixable. After the backup he can even try forcing drive 8 back into the pool so the rebuild continues, but there's no guarantee the drive will go back in, or that it will survive the process. In his words, copying and recreating the pool from scratch is probably the quickest way forward.

Classic RAID-5, by the way, requires all drives to be the same size, and to grow capacity I'd have to replace all of them at once. SHR is what let me swap one at a time over the years. Ironically, it's also what saved me from losing everything at once.

## The two mistakes

The way I understood it, there are two mistakes, one mine and one theirs, and that's where the whole disaster lives.

**Mine:** I underestimated RAID-6, which on Synology is called SHR-2. With two parity drives, drive 8 failing in the middle of the rebuild would have been just a scare. I traded safety for 20 TB of space and spent five years thinking I'd made a good deal.

**Theirs:** from the logs, the software knew drive 8 had been failing for at least a month, and I never got a single notification. I have email notifications configured. And they work: when the critical situation blew up, I got a flood of emails. This one, about drive 8's bad sectors, arrived at one in the afternoon on Monday, five hours after the disaster:

![Synology email warning that the number of bad sectors increased on drive 8, a Seagate ST22000NT001](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20261006120000_nas-synology-email-bad-sectors.png)

Before that, nothing. No warning about drive 8 until it failed catastrophically.

If I had received one, I would never have tried to swap drive 1 before replacing drive 8. The whole situation was avoidable, and it was the result of a human mistake plus some software bug.

That's the other reason I didn't buy another Synology. I have a principle: if the horse throws me, I put the horse down. I can't trust it again.

## Where I am now

So far I've copied about 20 TB of the original 90 TB, and HBS 3 keeps working. I still don't know whether I lost any data permanently. I hope not, but the most likely outcome is that I lost what was in the RAID slice the engineer described as crashed.

I have offsite backup on AWS Glacier of what matters most, but not of everything.

A lot of people ask why I don't use S3 or some other cloud storage for everything. I return the question: think for ten seconds. How long does it take to transfer 90 TB over your internet connection? Do the math:

- With a solid 1 gigabit of upload, never dropping for a second: more than 8 days.
- With 500 megabits: almost 17 days.
- With 100 megabits, which is good upload for many homes: 83 days.

And that's to upload. When disaster hits you need to download it all back, with the clock running. Not counting the rent: 90 TB on standard S3 costs about US$ 2 thousand a month at list price. Cloud is great for the critical subset, which is how I use it. For the whole archive, physics and the invoice won't allow it.

## Lessons

I was put in an impossible situation on a Monday morning, I acted right away as best I could, and I'll probably come out of this mostly unscathed. We'll see, HBS 3 is still syncing. What I take from it:

1. **Single parity isn't enough for big drives.** With 20 TB drives, a rebuild takes days and reads everything. That's the window in which the second drive tends to show up. RAID-6, SHR-2 or RAIDZ2.
2. **Don't rely only on the vendor's notifications.** Look at SMART and the drive logs before starting any swap. I didn't, because I trusted I'd be warned.
3. **Replace the sick drive first, then the small one.** A capacity upgrade on an array with a suspect drive is roulette.
4. **Leave slack.** I was swapping drives because the volume was at the ceiling. An 85% alert exists for that.
5. **Have somewhere to copy to.** My way out cost R$ 185 thousand because I had no plan B. A second NAS, even a modest one, with what matters, would have bought me time to shop calmly.
6. **RAID is not backup.** I know that, I teach that, and I still only had offsite for part of it.

I'll update this post when the copy finishes and I know the real size of the damage.
