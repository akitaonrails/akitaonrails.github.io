---
title: Configuring My Synology NAS with NFS on Linux
date: '2025-04-17T20:40:00-03:00'
slug: configuring-my-synology-nas-with-nfs-on-linux
tags:
- synology
- nas
- raid
- btrfs
- autofs
draft: false
translationKey: synology-nas-nfs-linux
description: How I switched from SMB to NFS to mount my Synology DS1821+ shares on Linux with proper ownership and permissions, plus the UID/GID gotcha along the way.
---

3 posts on the same day, but I took the day off to fix my Linux problems, so here is one more note for my future self.

Everyone who follows me, particularly on [Instagram](https://www.instagram.com/akitaonrails/), knows about my NAS saga. In particular my new Synology DS1821+ with more than **100TB** (4x 12TB HDs and 4x 20TB HDs, and I already have 4 more 20TB HDs to upgrade in the future when I need to). I use it for a lot of stuff, particularly my [Personal Netflix](https://www.akitaonrails.com/2024/04/03/meu-netflix-pessoal-com-docker-compose) that I explained in that other post on how I set it up with Docker.

![Synology DSM](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/4egervwxarfvls2uw3kg5k13i3hd)

In the highlights and posts about it on Insta I already discussed details of this NAS, but to summarize:

* I prefer Synology because deep down it is a Linux box with the BTRFS filesystem (which I like), which is almost as flexible but easier to use than ZFS. And yes, I know unraid, TrueNAS and others exist. But I think Synology DSM is very competent (there is an open source version if you want), and it does everything I need.
* I prefer Plex over Emby or Jellyfin. I have tested them, but Plex's support for TV and mobile apps is much better in my opinion, the player is more stable, and I also think its organization features are more robust.
* Why not just use Cloud? First because it is slow. My fiber is only 1Gbps and upload is half of that. Second because my internal network is ultra fast (10Gbps) and much better. Third because nothing in the "Cloud" has any guarantee, they can block you, they can get hacked, they can delete things by accident. Fourth, everything that is mine, I like it being **really** mine, within my reach, under my total control, with nobody to mess with my property. It costs more, it is a choice. I literally have more and better movies and series than Netflix with content you will not easily find in any streaming service anymore, for example.

In fact, I trust "cloud" so little that I use it but I keep a copy of everything on my local NAS using the Cloud Sync app from the Synology store:

![Cloud Sync](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/deednjd3ii774b5b7jdxu1azox3x)

**"Yeah, but what if your NAS dies in some unrecoverable way and you lose EVERYTHING?!"**

No backup is complete unless it follows the **3-2-1 Mantra**, remember??

* **3 copies, 2 media types, 1 off-site**

I have some things recorded on Millennial Discs (mdiscs, which are like Blu-Rays but made of inorganic material that never degrades). And I make copies of the most important things from my NAS to Amazon Glacier using the "Glacier Backup" app that is also in the Synology store.

Glacier is like S3 but much cheaper because it does not have easy access or fast transfer. It is built for backups, where you write once and almost never access again. **ENCRYPTED**, of course.

![Glacier Backup](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/y83uw9rtu8p5hgsq0ugyanb5cibj)

Notice how little I trust cloud, like dropbox, that I make a copy on my NAS and send it to another cloud. There are things with multiple copies indeed. I do not trust anyone's service, some human will always commit a catastrophic mistake one day, it is just a matter of time.

Oh yes, and I do download a lot of things from torrent and I consider myself a Power User and I know what is malware/virus and what is not, and I know how they work. But I am also human, so all my Windows machines have at least Windows Defender active, Malwarebytes which I also like, and even so I still run yet another antivirus on the NAS as well, which is also in the Synology store. I do not trust anything without redundancy of everything, under my total control.

![antivirus](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/bekpbla77t4o4uxcysqks18racwc)

More importantly, and the reason I choose BTRFS both on the NAS and on my PC: **snapshots**. It takes snapshots of everything periodically. So, if at some point I run a botched `rm -Rf`, I lose nothing, I just go back to the previous snapshot and everything will be there, intact. Snapshots are smart, they take almost no space, because in BTRFS the same binary content of identical files points to the same physical location. It does not work like `rsync` that actually duplicates everything and doubles the space used.

![Synology Snapshots](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/zhbq7dv8ai8jupqwj3zqvmetq5yk)

On your Linux PC/notebook, with BTRFS, install the Timeshift program to do the same thing. The best part: if one day you update your system and it does not boot or something breaks after an update, it is easy: just reboot and choose the previous snapshot in GRUB and that is it, it will go back exactly as it was before the update. On Arch/Manjaro it is smart and already takes snapshots automatically every time before `pacman` runs:

![Timeshift](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/n20yo00ztofrjsu6p6678wmfphdd)

Anyway, another use is for personal code projects on my Linux. On the mini-PC I use on the TV as a media center, I run Windows 11. Because I use it connected to another eGPU with an RTX 4060 and I use Steam for games. Yes, many Steam games run on Linux, there is Bazzite, etc. But there are things that only run on Windows and I preferred convenience. I only use it for games and media, so screw it, it works plug and play.

My other home server mini-PC is where my Docker stuff for media center, torrent, plex server and everything else runs. It is a headless Ubuntu LTS. Plus my handhelds like the Rog Ally X that runs Windows. All of them have access to my Synology NAS, where I expose shared folders with SMB and that is it. Plug and play.

I used to do the same on my Manjaro Linux: mount the folders with SMB. But this has a problem if I want to code something and want to use Git: in SMB there are no chmod attributes (like the +x flag for executable scripts) and every time I do git push, it messes up all the permissions of everything. It is a huge pain. Anyone who has used Git on Windows knows this.

I cannot keep scripts executable in this shared directory. So it makes my life hard on Linux. So I decided to fix this once and for all and do the right thing: stop using SMB and start using NFS, which is the native Linux way to access shared folders on the network from another Linux server (if the server were Windows, then it would have to be SMB, but nobody in their right mind sets up a NAS with Windows Server).

In SMB, the service ignores filesystem ownership and permissions. I create users and assign them to the service, not to the files. Just log in with that user and it will have access to the files. So there is no way to do `chown` and change ownership, nor `chmod` to change permissions individually on the files, it is all normalized.

In NFS, the service exposes exactly the ownership and permissions on the filesystem directly, without an ACL middleman to check permissions on the side. So I have the same level of access to those attributes that I have on the local files of my Linux, which is what I want.

But Synology does an annoying thing for some reason. On any Linux, the first user and first group created are usually UID: 1000 and GID: 1000. Try it, go to your terminal and run `id [your user]`:

```
❯ id akitaonrails
uid=1000(akitaonrails) gid=1000(akitaonrails) groups=1000(akitaonrails),998(wheel),996(audio),994(input),...
```

So it does not matter whether you do `chown akitaonrails:akitaonrails foo.txt` or `chown 1000:1000 foo.txt`. In practice, the identifier number is what matters, not the name.

With NFS, if on the Synology side there is a user with the same UID and GID number, I automatically have permission. But when you create users on Synology, for whatever reason, it starts creating them with IDs above **1020 instead of 1000**. So I have an "akitaonrails" user on Synology with UID 1026 instead of 1000.

Even being able to mount the shared folder with NFS, if I try to use Git, for example, it detects that my local UID is 1000 and the files have ownership of UID 1026:

```
git st fatal: detected dubious ownership in repository at '/mnt/gigachad/Projects/dotfiles' To add an exception for this directory, call: 

	git config --global --add safe.directory /mnt/gigachad/Projects/dotfiles
```

I cannot keep using mixed UIDs, it becomes a mess as bad as SMB. There are mapping tricks and other hacks, but there are only two "cleaner" solutions:

* change my Linux UID/GID to also be 1026
* create a new user on Synology, change its ID to 1000 and chown all files to this new user.

I chose the second option. The first thing is to enable SSH access on the NAS (the ideal is to leave such things off, for security, but I am on a private local network so the risk is minimal):

![SSH Synology](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/jpanifwk7guaxaekpoph0hty61ve)

At a minimum I always change the default SSH port, out of habit, but it does not really matter. You need to know how to use SSH, I will not teach it here, there is ChatGPT for that.

Now, create a new standard user:

![Novo Usuário](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/l6surkfy60whkaqri8m2rzqrq7d2)

Let's also make sure the NFS service is on, since I am going to start using it (by default it comes off, with only SMB on because the majority of clients are Windows PCs):

![Enable NFS](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/tpyix3dfkc0h2i4x4iaad99djffj)

Now SSH into the NAS and edit the UID and GID, first by editing `/etc/passwd` and finding a line like:

```
akitaonrails-nfs:x:10xx:10xx:...
```

And changing it to:

```
akitaonrails-nfs:x:1000:1000:...
```

Now editing `/etc/group` and the same thing, changing the newly created `akitaonrails-nfs` group to `1000` as well. Done, now I have a user with UID 1000 and GID 1000 created. The name is not the same as on my PC but that does not matter, only the numbers.

In the Synology DSM GUI, do not forget to add permissions for each shared folder, for NFS:

![NFS permissions](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/x5q0fmb5u6qxd7ahe7f7nquoy73k)

Still over SSH, you have to change the ownership and fix the permissions of **ALL FILES** and in my case, with terabytes, it took QUITE a while, just leave it running there:

```
sudo chown -R 1000:1000 /volume1/GIGACHAD
sudo chmod -R 0755 /volume1/GIGACHAD
```

If I want to disconnect from SSH and leave it running there (since it is going to take a long time), just run it detached from the SSH session with `nohup`:

```
nohup chown -R 1000:1000 /volume1/GIGACHAD > /tmp/chown.log 2>&1 &
```



One thing to be careful about is not doing something like `chmod -R -x` on everything. First: directories need to have the execute bit and if you remove it, you will no longer be able to navigate directories, so you have to separate fixing directories from files. Second: it is good to apply this fix on directories to make sure no files were left with the executable bit (which can create security problems, imagine random files inside Node modules directories). Third: directories like "#snapshot" are for filesystem control and are read-only, trying to mess with them will only eat A LOT of time, so it is better to filter them out and not touch them.

Or make a script with this and run it with nohup so you can leave SSH while waiting for it to run (in my case, with terabytes, it takes hours):

```
nohup /tmp/fix-terachad-perms.sh > /dev/null 2>&1 &
```

There are still some hidden little problems. Still on the Synology SSH you have to change the `/etc/exports` that NFS uses because it still maps by default to user UID 1026 and 100, you have to change both to 1000:

```
# old
sudo cat /etc/exports
Password:

/volume1/GIGACHAD       192.168.0.0/24(rw,async,no_wdelay,no_root_squash,insecure_locks,sec=sys,anonuid=1025,anongid=100)
/volume1/TERACHAD       192.168.0.0/24(rw,async,no_wdelay,crossmnt,no_root_squash,insecure_locks,sec=sys,anonuid=1025,anongid=100
```

The problem with messing with system files like this is that you do not know if touching the NFS permissions GUI, or if updates come, will revert it to how it was before. If anyone knows of a more permanent solution, let me know.

And done, with all this, just unconfigure the CIFS/SMB configuration I had and replace it with NFS. I prefer to use [AutoFS](https://wiki.archlinux.org/title/Autofs) to do this. I had an `auto.cifs` before, which I can now delete. And create a new `/etc/autofs/auto.nfs` like this:

```
gigachad  -fstype=nfs4,rw,nosuid,noatime 192.168.0.xx:/volume1/GIGACHAD
terachad  -fstype=nfs4,rw,nosuid,noatime 192.168.0.xx:/volume1/TERACHAD
```

And replace the `auto.cifs` line in `/etc/autofs/auto.master` with this:

```
/mnt  /etc/autofs/auto.nfs --timeout=60 --ghost --browse
```

Now restart the service:

```
sudo systemctl daemon-reexec
sudo systemctl restart autofs
```

And done, everything mounted with NFS and now I have full support for native Linux ownership and permissions, without the overhead and incompatibilities of crappy SMB. It was a bit scary doing chown and chmod en masse, but it is a NAS with BTRFS. It has RAID to handle data corruption, it has snapshots if I need to revert something. That is the advantage of having safety systems: you can do things knowing that if something goes wrong, there is a way to revert. That peace of mind is priceless.
