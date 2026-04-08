---
title: "Migrating my Home Server with Claude Code | openSUSE MicroOS"
date: '2026-03-31T16:00:00-03:00'
draft: false
slug: migrating-my-home-server-with-claude-code
translationKey: home-server-migration-claude-code
tags:
  - homeserver
  - docker
  - opensuse
  - microos
  - claude-code
  - vibe-coding
---

My old home server was a mess. An Intel NUC with Ubuntu Server that I'd been patching together for two years. Containers with hardcoded paths, volumes mounted in random places (`/home/akitaonrails/docker/`, `/home/akitaonrails/sonarr/`, `/mnt/terachad/`), docker-compose files scattered with no consistent layout. It worked, but if I lost the disk it would take days to rebuild everything from memory.

With the [new Minisforum MS-S1 Max](/en/2026/03/31/minisforum-ms-s1-max-amd-ai-max-395-review/) that I bought, I decided to do the migration properly. And I decided to use Claude Code from the start to speed up the process. It's a home server, only I use it, so the risk of making a mistake is low. But if this were a real production server, I would never do this without rigorous human review at every step.

What follows is the migration writeup and a guide for anyone who wants to replicate it. If I ever have to rebuild from scratch, this post is the documentation.

## Choosing the operating system

### Why not Ubuntu Server again

I used Ubuntu Server on the NUC for convenience. But `do-release-upgrade` is Russian roulette. Every time Ubuntu releases a new version, the upgrade is a real risk of breaking things. Packages change, configs get overwritten, dependencies clash. For a server that has to be running constantly, that's unacceptable.

### Why not Arch Linux

I use Arch on the desktop and I like it. But Arch is a rolling release with no stability guarantees at all. For a desktop where I can stop and fix problems, fine. For a headless server running 49 Docker containers that has to work after every reboot, no.

### Fedora CoreOS vs openSUSE MicroOS

The two modern options for a container server are Fedora CoreOS and openSUSE MicroOS. Both are immutable systems: the root filesystem is read-only, updates are atomic (they either apply in full or don't apply at all), and rollback is instant.

The difference: Fedora CoreOS uses Ignition (declarative configuration before the first boot) and is designed to be provisioned automatically. MicroOS uses `transactional-update` and allows normal interactive use. For a home server where I want SSH and the ability to poke around manually, MicroOS fits better.

### What makes MicroOS different

The immutable system concept changes how you operate the server:

Every package install or `/etc` edit goes through `transactional-update`, which creates a new btrfs snapshot, applies the change in that snapshot, and on the next reboot the system boots into the updated snapshot. If the change breaks something, you do `transactional-update rollback` and you're back on the previous snapshot in seconds.

Updates are automatic and daily. The `transactional-update.timer` downloads patches, creates a snapshot, and `rebootmgr` reboots in a configured window (in my case, between 4am and 5:30am). If the update breaks the boot, GRUB automatically falls back to the previous snapshot.

SELinux is enforcing by default. That caused 90% of the problems during the migration, but it's the right setting for security.

## Initial setup

### Hardware

- AMD Ryzen AI Max+ 395, 128GB LPDDR5X
- 96GB allocated as VRAM via BIOS (UMA Frame Buffer Size)
- 2TB NVMe (system + Docker)
- Wired 2.5Gbps network
- Synology DS1821+ NAS at 192.168.0.21 (NFS)

### First steps

MicroOS install is standard. Then:

```bash
# Create user with a UID that matches the NAS (so NFS works without permission issues)
useradd -u 1026 -m akitaonrails
passwd akitaonrails

# Configure sudo (inside transactional-update shell)
sudo transactional-update shell
# inside: add akitaonrails to sudoers
exit
sudo reboot
```

### Synology NFS

The Synology NAS exports `/volume1/TERACHAD` over NFS. The mount point on MicroOS is `/var/mnt/terachad` (not `/mnt/`, which lives on the immutable root).

In `/etc/fstab` (applied through transactional-update):

```
192.168.0.21:/volume1/TERACHAD /var/mnt/terachad nfs4 nfsvers=4.1,rsize=262144,wsize=262144,hard,_netdev 0 0
```

Details that matter: `nfsvers=4.1` because 4.2 didn't work with the Synology. `rsize=262144,wsize=262144` (256KB buffers) was the biggest NFS performance improvement. `hard` instead of `nofail` so the mount keeps retrying indefinitely if the NAS disconnects temporarily.

### GPU / ROCm

This step was a pain. The Radeon 8060S in the AI Max+ 395 is gfx1151, which ROCm doesn't officially support. Three steps were needed, and all three are mandatory:

1. BIOS: set UMA Frame Buffer Size to 96GB
2. Kernel: add `amdttm.pages_limit=25165824 amdttm.page_pool_size=25165824` to `/etc/kernel/cmdline`
3. Docker: use `HSA_OVERRIDE_GFX_VERSION=11.5.1` in every ROCm container

Without step 2, ROCm only sees 15.5GB even with the BIOS allocation in place. The numbers are 96GB / 4KB (page size) = 25,165,824 pages.

```bash
sudo transactional-update shell
echo "amdttm.pages_limit=25165824 amdttm.page_pool_size=25165824" >> /etc/kernel/cmdline
exit
sudo sdbootutil update-all-entries  # OUTSIDE the transactional shell
sudo reboot
```

Verification:
```bash
cat /sys/class/drm/card1/device/mem_info_vram_total
# 103079215104 (96 * 1024^3)
```

## Docker on MicroOS

```bash
sudo transactional-update --non-interactive pkg install docker
sudo reboot

sudo systemctl enable --now docker
sudo usermod -aG docker akitaonrails
# logout and login for the group to take effect

# Install standalone docker-compose (the openSUSE package doesn't include it)
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64" \
  -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
mkdir -p ~/.docker/cli-plugins
ln -s /usr/local/bin/docker-compose ~/.docker/cli-plugins/docker-compose
```

### daemon.json

```json
{
  "log-level": "warn",
  "log-driver": "local",
  "log-opts": {"max-size": "10m", "max-file": "5"},
  "selinux-enabled": true,
  "live-restore": true,
  "userland-proxy": false,
  "exec-opts": ["native.cgroupdriver=systemd"]
}
```

`live-restore: true` keeps containers alive across a Docker daemon restart. `userland-proxy: false` uses iptables directly instead of proxy processes (less overhead). `selinux-enabled: true` is mandatory on MicroOS.

## SELinux and Docker: the biggest source of problems

This deserves an entire section because it was responsible for 90% of the bugs during the migration.

On MicroOS with SELinux enforcing, every container that writes to a host bind-mounted directory needs special handling. There are two approaches: the `:Z` suffix on volumes and the `security_opt: label:disable` option.

### NEVER use `:Z`. Use `security_opt: label:disable`.

`:Z` tells Docker to relabel the host directory with the container's SELinux context. Sounds like the right thing. In practice:

- SQLite databases break. The relabeling changes the file's context and SQLite may refuse to open the WAL journal.
- NFS mounts silently ignore `:Z`. NFS doesn't support SELinux xattrs. The kernel ignores the flag without error, but the container still doesn't have permission.
- `:ro,Z` mounts try to relabel even when read-only, which fails on NFS and can corrupt the context on local paths.

The right solution for every container on this system:

```yaml
services:
  myservice:
    security_opt:
      - label:disable     # disables SELinux enforcement for this container
    volumes:
      - ./data:/data      # NO :Z
      - ./config.yml:/etc/config.yml:ro  # NO :Z even on :ro
```

`label:disable` disables SELinux label enforcement for that container only, not for the entire system. Combined with Docker's network and process isolation, it's safe for a home server.

## Migrating the stacks

All Docker stacks were reorganized into `/var/opt/docker/<stack>/docker-compose.yml`. On the old server, they were scattered across `/home/akitaonrails/docker/`, `/home/akitaonrails/<service>/`, with no pattern.

### Substitutions applied across every compose file

| Before | After |
|---|---|
| `/mnt/terachad/` | `/var/mnt/terachad/` |
| `192.168.0.145` | `192.168.0.90` |
| `/home/akitaonrails/<service>/` | `/var/opt/docker/<stack>/<service>/` |
| `OLLAMA_BASE_URL=http://192.168.0.14:11434` | `OLLAMA_BASE_URL=http://192.168.0.90:11434` |

### Media stack (Plex, Radarr, Sonarr, etc.)

The media stack is the most complex. Plex needs its own LAN IP (macvlan) for direct streaming to work. The setup:

```bash
docker network create -d macvlan \
  --subnet=192.168.0.0/24 \
  --gateway=192.168.0.1 \
  -o parent=enp97s0 \
  plex_macvlan
```

In compose, Plex needs to be on two networks: the macvlan (for the IP 192.168.0.6) and the default bridge (so other containers like Seerr can talk to it):

```yaml
plex:
  networks:
    plex_macvlan:
      ipv4_address: 192.168.0.6
      mac_address: "02:42:c0:a8:00:06"
    default: {}    # mandatory — without this, Seerr can't see Plex
```

A detail that almost broke me: Plex stores absolute paths in its database. If the container's internal volume changed from `/media` to `/data`, Plex no longer finds anything. You have to use exactly the same mount target as the old compose.

### Ollama with ROCm

New stack, didn't exist on the previous server:

```yaml
ollama:
  image: ollama/ollama:rocm
  container_name: ollama
  devices:
    - /dev/kfd:/dev/kfd
    - /dev/dri:/dev/dri
  security_opt:
    - seccomp:unconfined
    - label:disable
  group_add:
    - "485"   # render group GID
    - "488"   # video group GID
  environment:
    - HSA_OVERRIDE_GFX_VERSION=11.5.1
    - PYTORCH_ROCM_ARCH=gfx1151
    - OLLAMA_KEEP_ALIVE=30m
    - OLLAMA_NUM_PARALLEL=4
    - OLLAMA_FLASH_ATTENTION=1
    - OLLAMA_KV_CACHE_TYPE=q8_0
  volumes:
    - /var/lib/ollama:/root/.ollama
  ports:
    - "11434:11434"
```

`OLLAMA_FLASH_ATTENTION=1` activates flash attention. `OLLAMA_KV_CACHE_TYPE=q8_0` uses 8-bit KV cache, cutting the bandwidth needed per token in half. Free performance optimizations.

### Monitoring (Grafana + Prometheus)

Grafana uses a named volume (`grafana_data`) which is NOT included in normal filesystem backups. That's the reason I lost all my dashboards on the first attempt. The fix is an explicit backup of the named volume:

```bash
# On the old server:
docker run --rm -v grafana_data:/data:ro -v /tmp:/backup alpine \
  tar czf /backup/grafana_data.tar.gz -C /data .

# Transfer and restore on the new one:
docker run --rm -v grafana_data:/data -v /tmp:/backup alpine \
  sh -c "cd /data && tar xzf /backup/grafana_data.tar.gz"
```

Same thing for Portainer (`portainer_data`). Any volume defined in the `volumes:` block of a compose without a host path needs this treatment.

### Cloudflare Tunnel

I use [Cloudflare Tunnel](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/) to access all the services from outside the house without opening ports on the router. The migration was the easiest part: copy the tunnel's JSON credentials file and the `config.yml`, update the IPs from `.145` to `.90`, and bring the container up. The tunnel keeps the same ID, no need to recreate DNS.

The hostnames live in `config.yml`: portainer, grafana, plex, seerr, qbittorrent, syncthing, radarr, sonarr, bazarr, prowlarr, vault, gitea, kavita, and others. Everything accessible via `https://<service>.example.com` from anywhere.

### Gitea (image registry)

[Gitea](https://github.com/go-gitea/gitea) acts as a private Docker registry on port 3007. The Frank FBI, Frank Mega, Frank Yomik and Mila projects have Docker images that are built and pushed to Gitea. For it to work, Docker's `daemon.json` needs:

```json
{
  "insecure-registries": ["192.168.0.90:3007"]
}
```

Gitea SSH gave me a problem during the migration: the old app.ini had `SSH_LISTEN_PORT=22`, but the container's entrypoint also starts sshd on port 22. Conflict. Fix: `GITEA__server__SSH_LISTEN_PORT=2222` as an environment variable in compose.

### All 49 containers running

The migrated server runs 49 containers across 15 stacks. The media stack alone has 10 containers ([Plex](https://www.plex.tv/), [Radarr](https://github.com/Radarr/Radarr), [Sonarr](https://github.com/Sonarr/Sonarr), [Bazarr](https://github.com/morpheus65535/bazarr), [Prowlarr](https://github.com/Prowlarr/Prowlarr), [qBittorrent](https://github.com/qbittorrent/qBittorrent), [SABnzbd](https://github.com/sabnzbd/sabnzbd), [Jackett](https://github.com/Jackett/Jackett), [FlareSolverr](https://github.com/FlareSolverr/FlareSolverr), [Seerr](https://github.com/seerr/seerr)). The personal projects ([Frank FBI](https://github.com/akitaonrails/frank_fbi), [Frank Mega](/en/2026/02/21/vibe-code-fiz-um-clone-do-mega-em-rails-em-1-dia-pro-meu-home-server/), [Frank Yomik](https://github.com/akitaonrails/FrankYomik), Mila) add another 11. Monitoring with [Grafana](https://github.com/grafana/grafana), [Prometheus](https://github.com/prometheus/prometheus), node-exporter and [cAdvisor](https://github.com/google/cadvisor). Utilities like [Portainer](https://github.com/portainer/portainer), [Vaultwarden](https://github.com/dani-garcia/vaultwarden), [Syncthing](https://github.com/syncthing/syncthing), [Organizr](https://github.com/causefx/Organizr), [Watchtower](https://github.com/containrrr/watchtower). [Gitea](https://github.com/go-gitea/gitea) as private Docker registry. [Immich](https://github.com/immich-app/immich) as self-hosted Google Photos. [Kaizoku](https://github.com/oae/kaizoku) for manga with [Kavita](https://github.com/Kareadita/Kavita) as the reader. [Ollama](https://github.com/ollama/ollama) with ROCm. And [Bitcoin Core](https://github.com/bitcoin/bitcoin)/[Fulcrum](https://github.com/cculianu/Fulcrum) indexing the blockchain off the NAS.

## Backups: two layers

### Layer 1: local btrfs snapshots (snapper)

`/var` lives on a 3.7TB btrfs partition. snapper creates automatic snapshots: 7 daily + 1 weekly. They're crash-consistent, not application-consistent (postgres can be slightly inconsistent if there's heavy writing during the snapshot).

To recover an accidentally deleted file:
```bash
sudo snapper -c var list
sudo cp /var/.snapshots/5/snapshot/opt/docker/media/radarr/appdata/config/radarr.db \
        /var/opt/docker/media/radarr/appdata/config/radarr.db
```

For a full stack rollback:
```bash
sudo docker compose -p media down
sudo snapper -c var undochange 7..0 /var/opt/docker/media
sudo docker compose -p media up -d
```

### Layer 2: restic to the NAS (off-machine)

[restic](https://github.com/restic/restic) runs every night at 3am, doing incremental backups to `/var/mnt/terachad/homelab-backups/`. Retention: 7 daily + 4 weekly. Content-based deduplication, so Plex config (19GB) and Gitea repos (12GB) only transfer deltas.

Before restic runs, a `pg_dump` exports the postgres databases (Immich, Kaizoku). The dumps go to `/tmp/homelab-db-dumps/` and are included in the backup.

What's NOT included in the backup (re-downloadable): Bitcoin blockchain (785GB on the NAS), Docker images (re-pullable), Ollama models (re-downloadable), HuggingFace/EasyOCR caches, Plex transcoding scratch.

Large re-downloadable directories were converted to btrfs subvolumes so snapper ignores them: `/var/lib/ollama` and `/var/opt/docker/bitcoin/fulcrum/fulc2_db`.

## Performance tuning

### btrfs with zstd compression

Added `compress=zstd:1` to the fstab for the `/var` partition. zstd level 1 has near-zero CPU overhead on NVMe and compresses Docker metadata, JSON configs and logs nicely. Incompressible data (SQLite, postgres) is automatically skipped by btrfs.

### zram swap

With ~30GB of RAM available for the system (96GB go to VRAM), in-memory compressed swap helps. zram creates a ~15GB swap device (ram/2) with zstd compression, much faster than disk swap.

```ini
# /etc/systemd/zram-generator.conf
[zram0]
zram-size = ram / 2
compression-algorithm = zstd
swap-priority = 100
```

### btrfs nodatacow on database directories

Copy-on-write + random database writes = write amplification. I disabled CoW on the directories that hold SQLite and postgres:

```bash
sudo chattr +C /var/opt/docker/gitea/data/gitea.db
sudo chattr +C /var/opt/docker/immich/db/
sudo chattr +C /var/opt/docker/media/radarr/appdata/config/
```

### CPU in performance mode

On a headless server, there's no point saving energy:

```bash
echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference
```

Persisted via systemd service `cpu-epp.service`.

### Docker shutdown fix

A problem I discovered: Docker ships with `KillMode=process`, which means at system shutdown, systemd kills only dockerd and leaves all the `containerd-shim` processes (one per container, ~49 in my case) orphaned. systemd-shutdown then has to hunt them down one by one after the journal has already stopped, causing a silent multi-minute hang.

Fix:
```ini
# /etc/systemd/system/docker.service.d/shutdown.conf
[Service]
KillMode=control-group
TimeoutStopSec=30
```

## The problems we ran into

This is the table of actual problems we hit during the migration. If you're planning something similar, read it before starting:

| Problem | Cause | Fix |
|---|---|---|
| ROCm only sees 15.5GB of VRAM | Kernel TTM caps pages even with BIOS at 96GB | Add `amdttm.pages_limit=25165824` to kernel cmdline |
| Every container: permission denied on volumes | SELinux `container_t` can't write to unlabeled paths | `security_opt: label:disable` on every service |
| NFS with `:Z` silently fails | NFS doesn't support SELinux xattrs | Never use `:Z` on NFS paths |
| SQLite breaks with `:Z` | Relabeling changes the context, WAL mode fails | Drop `:Z`, use `label:disable` |
| Radarr/Sonarr showed the setup screen | Backup at `appdata/config/` but compose mounted `appdata/` | Fix to: `appdata/config:/config` |
| Grafana lost dashboards | Named volume not included in filesystem backup | Explicit named volume backup |
| Plex can't find media | Internal path changed from `/media` to `/data` | Restore the original path in compose |
| Seerr can't connect to Plex | macvlan isolated from the bridge network | Add `default: {}` to Plex networks |
| Fulcrum crash: "option -b missing" | Env vars not supported by the image | Use CLI flags in `command:` |
| bitcoind rejects RPC | Binds on `::1` by default | Add `-rpcbind=0.0.0.0 -rpcallowip=172.0.0.0/8` |
| sdbootutil warning in transactional shell | Has to run outside the transaction | Run `sdbootutil update-all-entries` in the normal shell |
| Watchtower permission denied on docker.sock | SELinux blocks socket access | `label:disable` |
| Gitea SSH crash | Conflict: entrypoint sshd on port 22 + app on port 22 | `GITEA__server__SSH_LISTEN_PORT=2222` |
| docker-compose not installed with Docker | The openSUSE package only installs the daemon | Install standalone binary manually |

## What to tell Claude Code before you start

If I were redoing the migration from scratch, I'd give Claude Code these instructions on the very first message. In order of importance:

Tell it that SELinux is enforcing and that it should NEVER use `:Z` on any Docker volume, but rather `security_opt: label:disable` on every service. Tell it that `/var/mnt/terachad/` is an NFS mount and that `:Z` should never appear on NFS paths. Tell it to always look at the original compose before rewriting and only change IPs, paths and container names, without inventing new volume layouts. Warn that named volumes need explicit backup (Grafana, Portainer). Explain that Plex runs on macvlan and needs `default: {}` in the networks. Inform that the GPU is gfx1151, not officially supported, and that it needs UMA 96GB in the BIOS + kernel TTM params + `HSA_OVERRIDE_GFX_VERSION=11.5.1`. And tell it that Bitcoin/Fulcrum don't process environment variables, everything goes as an argument in `command:`.

Those instructions would have prevented 80% of the problems we hit.

## Final server layout

```
/var/opt/docker/
├── bitcoin/          (bitcoind + fulcrum)
├── cloudflared/      (Cloudflare tunnel)
├── frank_fbi/        (email fraud analysis)
├── frank_mega/       (Mega clone)
├── frank_yomik/      (manga translation)
├── gitea/            (Docker registry)
├── immich/           (self-hosted Google Photos)
├── kaizoku/          (manga downloader + reader)
├── media/            (Plex + *arr stack)
├── mila/             (Discord bot)
├── monitor/          (Grafana + Prometheus)
├── ollama/           (local LLM with ROCm)
├── rip/              (HandBrake)
└── utils/            (Portainer, Vaultwarden, Syncthing, etc.)

/var/mnt/terachad/    (Synology NFS)
├── Bitcoin/data/     (blockchain, 785GB)
├── Downloads/        (torrents + nzbget)
├── Videos/           (Radarr movies + Sonarr series)
└── Ollama/models/    (model overflow if local disk fills up)
```

## A warning about using AI to administer servers

I used Claude Code to speed up the migration. It created compose files, wrote backup scripts, configured the firewall, diagnosed SELinux problems. It worked well for my case: home server, only I use it, and I was reviewing every step.

But there are traps. Claude doesn't know that `:Z` breaks SQLite unless you tell it. It doesn't know that Fulcrum doesn't accept env vars unless it's already seen the Dockerfile. It will invent "better" volume layouts that break Plex because Plex stores absolute paths in its database.

If it were real production: don't do this without review. Every compose file Claude generates, read it in full before applying. Every destructive command (rollback, delete, recreate), confirm manually. And have tested backups before you start. Claude is great for generating the first version and diagnosing errors, but the architecture decisions and the safety validations are yours.

The previous home server posts that may give additional context:
- [My "Personal Netflix" with Docker Compose](/2024/04/03/meu-netflix-pessoal-com-docker-compose/)
- [Accessing my Home Server with a real domain](/en/2025/09/09/acessando-meu-home-server-com-dominio-de-verdade/)
- [Protecting your Home Server with Cloudflare Zero Trust](/en/2025/09/10/protegendo-seu-home-server-com-cloudflare-zero-trust/)
- [Installing Grafana on my Home Server](/en/2025/09/10/instalando-grafana-no-meu-home-server/)
- [Self-hosted Vaultwarden](/en/2025/09/10/omarchy-2-0-bitwarden-self-hosted-vaultwarden/)
