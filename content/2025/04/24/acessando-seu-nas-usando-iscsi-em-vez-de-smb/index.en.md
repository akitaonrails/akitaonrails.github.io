---
title: Accessing Your NAS Using iSCSI Instead of SMB
date: '2025-04-24T01:00:00-03:00'
slug: accessing-your-nas-using-iscsi-instead-of-smb
tags:
- nfs
- smb
- iscsi
- synology
- nas
- docker
draft: false
translationKey: nas-iscsi-instead-of-smb
description: Why I moved my Docker data-root off NFS and onto an iSCSI virtual drive served from my Synology NAS, and how block-level storage crushes file-based protocols for high-churn workloads.
---



If you have a NAS or any kind of file server on your network, odds are your default move is to create a shared folder and mount it on your operating system, whether Windows, Mac, or Linux, using the old, tired SMB (Samba) protocol.

On Linux, this is a massive pain in the ass, because the SMB protocol (built for Windows) doesn't properly carry concepts like ownership (chown) or permissions (chmod). It doesn't understand things like execute permission (everything is executable). For simple stuff like a Downloads, Videos, or Photos directory, it kind of doesn't matter.

But let's say you want to edit source code in projects with Git. It's going to be a nightmare, because SMB overrides the permissions regardless of what's underneath, and every single time it's going to conflict with Git, which will think files were modified (changing permissions counts as a change it tracks), and it'll keep nagging you to commit that, and that will pollute your whole repository (never use Git projects on SMB over the network).

Instead, I'm on Linux, my NAS is Linux. The right call is to use a Linux protocol. That protocol is NFS and I showed how I set it up in [last week's post](https://www.akitaonrails.com/2025/04/17/configurando-meu-nas-synology-com-nfs-no-linux).

Anyway, I'm using NFS and I have way fewer headaches around file permissions. But then I hit another problem: if you saw my recent posts, you saw I've been experimenting A LOT with Docker. Spinning up new images like there's no tomorrow. My local 2 TB NVMe filled up fast and started complaining about lack of space. So I thought, _"Ah, I'll just move the Docker storage directory, /var/lib/docker, to a directory mounted via NFS on my NAS"_

Doing that is very easy:

```
sudo mkdir -p /mnt/nfs/docker
sudo chown root:docker /mnt/nfs/docker
sudo chmod 771       /mnt/nfs/docker
```

That creates a new directory inside my NAS and applies the correct permissions.

```
sudo systemctl stop docker
sudo mv /var/lib/docker /mnt/nfs/docker
# sudo rm -Rf /var/lib/docker (this will free everything up for me)
sudo ln -s /mnt/nfs/docker /var/lib/docker
```

That will free up all the occupied space. I don't need to worry about the images because I can rebuild everything from my Dockerfiles. And I don't need to worry about volumes because I had nothing important that wasn't mounted externally, in real directories. Rule: never store important things in Docker volumes. It's bad practice!

```
# edit /etc/docker/daemon.json
{
  "data-root": "/mnt/nfs/docker"
}

sudo systemctl start docker
```

Done, this changes the configuration from `/var/lib/docker` to the new `/mnt/nfs/docker` and after restarting the service, it'll start writing everything there. So the post is over, right?

This is as far as most people go. But if you work with this setup for 2 minutes, you'll feel something is VERY wrong.

I tried building a new image. And it was taking ABSURDLY long. It turns out NFS is indeed faster than SMB, but both were built for file servers, not for operating systems. That makes a huge difference.

These protocols are **FILE-BASED**, every operation is based on files. And that's extremely inefficient.

If you watched my videos on file systems, you should already know they are **BLOCK-LEVEL**. At the filesystem level, you work with fixed-size blocks of bytes, organized in some variation of B-TREE structures (depending on the filesystem). Operations happen at the block level. Files are abstractions over collections of blocks.

When you run a `chmod -R`, which is a recursive permission change, inside a Dockerfile build, for example, even an empty tree will cause recursion on every entry inside, be it hidden files, ACLs, etc. And it needs to look up every single permission of everything in there. That costs network time (because NFS/SMB are network protocols).

That causes latency. Every permission on every file is an individual remote call, an RPC call. Even on the fastest network, like my 10Gbps one, even if each RPC is under 0.1 ms, it quickly becomes a bottleneck. And that's exactly what started happening.

I used `sudo nfsiostat 1 10` to check. It was showing this:

```
write: ops/s=2417  kB/s≈295 MiB/s  avg exe=106 ms  avg queue=102 ms
```

An average of 106 ms per RPC. That's an eternity. Average wait time in the queue of 102 ms. Even if I make just 100 RPC calls, it will cost more than 10 seconds in latency alone. And in an OS build, installing packages with thousands of files, that will literally cost an eternity. Running Docker build on NFS/SMB is simply not viable.

### iSCSI

Obviously I'm not the first to run into this problem and make the mistake of using a file-based protocol for services with high-volume file churn like the Docker cache.

The right move is to create an iSCSI virtual drive on my NAS. If you've never heard of it, SCSI is an advanced protocol for drives. Cheap PCs in the 90s and 2000s used IDE/ATA, which is a simpler and cheaper protocol. But the first Macs and UNIX workstations from the 80s and 90s always used SCSI, which was vastly superior.

It was **asynchronous**, with queue control. You could send dozens of commands at once and the protocol was smart enough to reorder those commands for better efficiency (for example, skipping a file read if a delete command came before it). IDE was blocking, one command at a time. A single SCSI BUS could handle up to 16 devices. Parallel ATA was 2 per cable. Ridiculous. SCSI had advanced error recovery and reporting systems. It had "enterprise" features for hot-swap, power management, timeout behaviors, recovery, clustering, etc. And on top of all that it was agnostic to the transport medium, it could be fiber optic, SAS, or even iSCSI, which is SCSI over Ethernet, which is what we're going to use.

IDE/ATA had none of that. It was the protocol for poor-person PC disks. Real workstations, SUN, IRIX, Silicon Graphics, Macs, used SCSI.

More importantly, iSCSI is a block protocol, not a file protocol. Anyway, this varies by NAS manager, but in the case of Synology DSM, which is what I use, it has an application called SAN Manager, which lets you create an iSCSI drive:

![iSCSI create](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/fraxoryhuszmp4cmr0ldc8h7hiip)

Just follow the wizard, give it a name, choose the size, enable CHAP if you need extra security (I don't, I'm on a controlled local network). That creates the iSCSI drive (think of it like a remote USB drive) and a LUN (Logical Unit Number). A LUN is simply one of many potential "virtual disks" that a target can present. A LUN is like a numbered slot in a target's storage array. A target is a disk server. On a SAN you can have several virtual disks and the way to organize that is with LUNs. In our case there's no real need to go deep on LUN details.

It takes a while, but when it finishes you just go back to my Manjaro Linux and run:

```
yay -S open-iscsi
sudo systemctl enable --now iscsi 
```

That brings up the service to start automatically on every boot. Now to discover my drive on the network:
```
```

```
❯ sudo iscsiadm -m discovery -t sendtargets -p 192.168.0.xx
192.168.0.xx:3260,1 iqn.2000-01.com.synology:TERACHAD.docker.7af6e...
[2804:1b3:....:fe18:3f7d]:3260,1 iqn.2000-01.com.synology:TERACHAD.docker.7af6e...
[fe80::9209:....:3f7d]:3260,1 iqn.2000-01.com.synology:TERACHAD.docker.7af6e...
```

Every virtual drive has an **IQN** which is like a "URL" for the drive. Now we log in:

```
❯ sudo iscsiadm -m node --login
Login to [iface: default, target: iqn.2000-01.com.synology:TERACHAD.docker.7af6e9116c1, portal: 192.168.0.21,3260] successful.
```

Since I didn't enable CHAP it doesn't ask for a password or anything (in a company it should be enabled, obviously). And done. When you do this I hear on GNOME the same little sound as when you plug a pen drive into the PC and it automatically shows up as a disk. If you run `lsblk`, it'll show up as a normal `/dev/sdX` drive. In the GNOME Disks app (or in Windows Disk Management) it really does show up as if it were any other hard drive or SSD. It doesn't behave like a shared folder, it behaves like a real drive. You even have to format it, just like a new pen drive.

![Disks](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/nvgrl3bov311vl4h251dcj1wvchz)

The formatting itself takes quite a while, because in the process it has to check and map block by block. Since it's over the network, it's slower than on a real drive, obviously. But it's a one-time thing. Even on my 10Gbps network it'll format at around 120 MB/s, and on a 2TB drive that comes out to around 2 hours for a fast format. I forgot you could format with "lazy":

```
mkfs.ext4 -v -E lazy_itable_init=1,lazy_journal_init=1 /dev/sdX
```

Leaving that for next time, now I wait 2 hours. To make sure it mounts automatically at boot, you need to check its `node.startup`:

```
❯ sudo iscsiadm -m node -o show | grep -E 'Target:|node.startup'

node.startup = manual
node.startup = manual
node.startup = manual
```

It's set to "manual", to switch it to "automatic" you do:

```
❯ sudo iscsiadm -m node \
  -T iqn.2000-01.com.synology:TERACHAD.docker.7af6... \
  -o update -n node.startup -v automatic
```

With the iSCSI daemon running and after logging in, besides `/dev/sda`, if you run `ls /dev/disk/by-path` you'll find something like this:

```
ip-192.168.0.xx:3260-iscsi-iqn.2000-01.com.synology:TERACHAD.docker.7af6exxxxx-lun-1 -> ../../sdX
```

Since I'm using the AUTOFS service and it "steals" my `/mnt` directory, I'm going to mount the iSCSI drive via fstab at `/media/docker` by adding this line at the end of `/etc/fstab`:

```
...
/dev/disk/by-path/ip-192.168.0.xx:3260-iscsi-iqn.2000-01.com.synology:TERACHAD.docker.7af6e9xxxx-lun-1  /media/docker  ext4      _netdev,nofail,x-systemd.automount,x-systemd.requires=iscsid.service,noatime,nodiratime,commit=60  0 2
```

Then just reload and mount:

```
sudo systemctl daemon-reload
sudo mount -a
```

And that's it. From now on I have a "virtual drive" on my remote NAS. Now, let's switch Docker over to start using it. I can reconfigure my Docker to cache images and volumes and everything else directly on that drive. Just edit the `/etc/docker/daemon.json` file with the mount point:

```
{
  "data-root": "/media/docker/docker"
}
```

Don't forget to create the directory on the new drive with the right permissions (and it does accept permissions, because it's a drive formatted with ext4 like any other):

```
sudo mkdir -p /media/docker/docker
sudo chown root:docker /media/docker/docker
sudo chmod 771 /media/docker/docker
``` 


Finally, just restart the Docker service, wipe out `/usr/lib/docker` to free up space on my main NVMe, and done. It should be WAY faster than NFS, though not as fast as a local disk, of course. Even at 10Gbps, the network introduces latency, there's no way around it. But the heaviest part is really the build process, which has a lot of writes. For loading an already-built image, it should be blazing fast. But at least by using a block protocol instead of a file protocol, latency should drop by at least an order of 10x or more.

![docker build](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/xh40fu275xx9q6os00m6j5gyr9w9)

And is it really faster? **YES**. In this screenshot of the docker build running, on NFS the times on the right were HUNDREDS OF SECONDS for many commands. Now they're back below 1 second like they should be. For all intents and purposes, I'm not feeling any difference from what a USB 3.2 Gen 2 external HD would give me.

The MASSIVE difference that a BLOCK-LEVEL virtual drive makes, compared to a FILE-LEVEL NFS/SMB protocol, is brutal, the protocol is gigantic overhead. Incidentally, this is more or less how it works when you go to AWS and hire EBS storage (Elastic BLOCK Store), that's why it's called "BLOCK", because it's a BLOCK protocol like iSCSI and not NFS. I hope you learned how much of a difference it makes to understand how protocols and filesystems work. If you haven't watched my videos, there's [this playlist](https://www.youtube.com/watch?v=lxjBgxmDZAI&list=PLdsnXVqbHDUcM0LTAxqrVrTy6Q7jQprjt&pp=gAQB) that explains BLOCKS in detail.


But yes, iSCSI has downsides: being a drive, it cannot, or should not, be shared (think of two PCs sharing the same pen drive, it would be a huge sh\*tshow). Block devices were built to be used by a single device. Precisely for sharing, that's why protocols like SMB or NFS exist: to manage concurrent access to the same file over the network. 

Another downside: the virtual drive is one big BLOB of bits. Without "mounting" it, there's no way to see the files. On the NAS server, it doesn't show the files. It's like a VirtualBox .vhd file. You need to "turn it on" and "mount" it on the "PC". That's why I'm still going to use NFS for the usual stuff, like Videos or Downloads. And the virtual drive is exclusively for the Docker cache, in this case. That works well. No other PC accesses it. If I had a second Linux machine that needed a Docker cache, I'd have to create a second LUN just for it. Remember, it's a drive. Virtual or not, it behaves like a real drive to your system.
