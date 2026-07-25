---
title: "AI-Jail: Security Update, Docker Goes Opt-In"
slug: "ai-jail-security-update-docker-opt-in"
date: '2026-07-25T13:00:00-03:00'
draft: false
translationKey: ai-jail-update-seguranca-docker-opt-in
description: "Issue #88 proved that the Docker socket, mounted by default inside ai-jail, gave any agent root on the host. In v1.16.0 it became opt-in. The flaw, a hands-on demo, and best practices."
tags:
- ai-jail
- containers
- security
---

Someone opened an important issue on the [ai-jail](https://github.com/akitaonrails/ai-jail) repo this morning: [issue #88](https://github.com/akitaonrails/ai-jail/issues/88), reported by [@mdindoffer](https://github.com/mdindoffer), titled "Sandbox escape via a docker socket passthrough (effective host root)".

The report checked out, and the fix is already available in **v1.16.0**.

## Update to v1.16.0

If you use ai-jail, the update is the usual drill:

```bash
# Arch Linux (AUR)
yay -Syu ai-jail-bin

# Homebrew (macOS / Linux)
brew update && brew upgrade ai-jail

# crates.io
cargo install ai-jail --force

# mise
mise cache clear && mise upgrade github:akitaonrails/ai-jail
```

## What changed in v1.16.0

Up through v1.15.x, ai-jail mounted the Docker socket inside the jail automatically whenever `/var/run/docker.sock` existed on the host. Read-write. No warning, no flag, no asking for your opinion. I documented this in the README as "favors usability," and it was true: a coding agent often needs to run `docker compose` to bring up a test database, and the automatic passthrough saved some configuration.

Starting with v1.16.0, the behavior flipped:

- Socket passthrough is now **off by default**. It only goes in if you explicitly ask for it with the `--docker` flag or `no_docker = false` in `.ai-jail`.
- When you enable it and a host socket exists, ai-jail prints a launch warning spelling out that this amounts to giving host root to the process inside the jail.
- `ai-jail status` now shows Docker as `disabled (default)`, so nobody thinks it got turned on by accident.
- In `--lockdown` and browser profile modes the socket never goes in, same as before.

A behavior change, yes, and a deliberate one. If your workflow depends on Docker inside the jail (mine does, in a few projects), opting in is one line in the project's `.ai-jail`:

```toml
no_docker = false
```

The field name is ugly (`no_docker = false` to turn it on, I know), but old configs keep parsing the same way, and `--no-docker` / `no_docker = true` work as before. Only the default changed. The details are in the [v1.16.0 release notes](https://github.com/akitaonrails/ai-jail/blob/master/releases/v1.16.0.md).

## What issue #88 showed

mdindoffer's report is the kind every maintainer wants to get: precise summary, a repro in a few lines, a fix proposal. The gist:

ai-jail was mounting the **raw** Docker socket inside the sandbox, read-write. The Docker daemon runs as root on the host. So an agent inside the jail could run this:

```bash
docker run --rm -v /:/host alpine sh -c 'cat /host/etc/shadow'
```

And that's the ballgame. Read any file on the host, as root. It defeats the tmpfs `$HOME`, `--mask`, `--deny-path`, and Landlock in one move, because the action no longer happens inside the sandbox: it happens in the daemon, which lives outside and above any namespace bwrap created. The agent doesn't even need to escape the jail when the jail has a door straight into the engine room.

In retrospect, shipping this on by default was a design mistake. I knew the passthrough was "dangerous" in the abstract, and I wrote as much in the README. What I hadn't internalized: dangerous like this, with this default, is a vulnerability.

mdindoffer also proposed the definitive hardening path: instead of mounting the raw socket, put a filtered proxy in front of it (in the style of [wollomatic/socket-proxy](https://github.com/wollomatic/socket-proxy)) that only accepts bind mounts from paths the agent can already write to inside the jail. It's on the radar for a future release. To close the hole now, opt-in with an explicit warning fixes the default, which is where the problem lived.

## The vulnerability class: docker.sock is root

This is not the first time I've run into this story, and I'd bet it isn't yours either. "Whoever has access to the Docker socket has root on the host" is one of the classics of container security, documented by Docker itself on the [daemon attack surface](https://docs.docker.com/engine/security/) page: only trusted users should control the daemon, because Docker lets you share any host directory with a container, with no access restriction whatsoever.

The technical reason is simple. `dockerd` is a daemon that runs as root and obeys commands arriving through the API on the `/var/run/docker.sock` Unix socket. The `docker` CLI is just a client of that API. When you ask for `docker run -v /:/host`, the daemon is the one creating the container and mounting the host's entire filesystem inside it, with full privilege. And a process inside a container runs as uid 0 by default, which the kernel sees as real uid 0 (barring user namespace remapping, which almost nobody turns on). The math checks out: write access to the socket equals root on the host. The `docker` group is passwordless sudo by another name.

## The demo, on your machine

If you have Docker installed and your user in the `docker` group, reproduce it right now. No sudo, no exploiting any bug:

```bash
# confirm you're a regular user
$ id
uid=1000(akitaonrails) gid=1000(akitaonrails) groups=...,docker

# try reading /etc/shadow directly: denied, as expected
$ cat /etc/shadow
cat: /etc/shadow: Permission denied

# now ask the daemon to do it for you
$ docker run --rm -v /:/host alpine sh -c 'head -3 /host/etc/shadow'
root:$6$...:...
bin:!:...
daemon:!:...
```

And if you want the whole nine yards, a root shell on your own host:

```bash
$ docker run --rm -it -v /:/host alpine chroot /host /bin/bash
# id
uid=0(root) gid=0(root) groups=0(root)
```

No exploit, no 0-day. You used the official API, the documented way, and went from regular user to root in one command. That's exactly what an agent inside ai-jail could do until today, even with every layer (bwrap, Landlock, seccomp, rlimits) turned on.

## Why does this still exist?

If everyone has known about this for over a decade, why hasn't anyone "fixed" it? Short answer: this is architecture, and architecture doesn't get patched.

- The root daemon with an all-powerful API was the design that made Docker simple to operate. Granular per-request authorization exists in the form of [authorization plugins](https://docs.docker.com/engine/extend/plugins_authorization/), but it's opt-in, annoying to configure, and I can count on one hand the setups I've seen using it.
- [userns-remap](https://docs.docker.com/engine/security/userns-remap/) has been around since Docker 1.10 and maps container root to an unprivileged user on the host. It ships turned off, because it breaks compatibility with images and volumes that assume uid 0.
- [Rootless mode](https://docs.docker.com/engine/security/rootless/) runs the whole daemon as your user, with the socket at `$XDG_RUNTIME_DIR/docker.sock`. It works, but it has network and storage limitations, and the entire internet of tutorials assumes the root daemon at the classic path.
- [Podman](https://podman.io/) was born rootless and daemonless precisely because of this criticism. If you can switch, switch.

Bottom line: this is here to stay. Every tool that mounts `/var/run/docker.sock` into an environment "for convenience" opens the same hole, knowingly or not. CI mounting the socket for image builds, remote IDEs, code-server, AI agent sandboxes (hi, me), web dashboard plugins. The fix always lives on the side of whoever builds the environment.

## Best practices so this doesn't bite you

The list I apply and recommend:

1. **Treat the `docker` group as passwordless sudo.** Before adding any user or service to it, ask whether you'd give that thing unrestricted sudo. Same thing.
2. **Never mount `/var/run/docker.sock` into untrusted environments.** AI agents, CI jobs running code from a stranger's pull request, third-party containers. Run `grep -r docker.sock` over your docker-compose files, CI manifests, and tool configs. It shows up in more places than you remember.
3. **Need to expose it to something semi-trusted? Use a socket proxy.** [wollomatic/socket-proxy](https://github.com/wollomatic/socket-proxy) and [Tecnativa's docker-socket-proxy](https://github.com/Tecnativa/docker-socket-proxy) sit between the client and the daemon with an endpoint allowlist and blocking of arbitrary bind mounts. Read-only by default; you enable only what you need.
4. **Prefer rootless whenever possible.** Rootless Podman on Linux is the cleanest path; Docker's own rootless mode is the second option. The daemon stops being root and this entire class of problem loses its bite.
5. **In CI, build images without a privileged daemon.** [Kaniko](https://github.com/GoogleContainerTools/kaniko) and [Buildah](https://buildah.io/) build images rootless, with no socket mounted in the job at all.
6. **Can't go rootless? Turn on userns-remap.** It costs an afternoon of testing with your volumes and buys real isolation between container root and host root.
7. **In ai-jail, let the default work for you.** Docker off, and `--docker` only in projects where you trust the workload the way you'd trust a sudo. Rule of thumb: if you wouldn't blindly hand `sudo` to the agent in that directory, don't hand it `--docker` either.

## Conclusion

A well-built sandbox loses much of its value with a back door left open for convenience. bwrap, Landlock, seccomp, and rlimits in ai-jail keep doing their jobs, but none of them can see what happens when the process inside politely asks the host's root daemon to mount the whole filesystem into a container. A security layer you don't audit becomes decoration.

My public thanks to [@mdindoffer](https://github.com/mdindoffer): clean report, minimal repro, correct severity, and a solution proposal on top. That's how you report a vulnerability to an open source project.

If you want the full context of how I use sandboxes day to day, I wrote about it in [How Do I Protect Myself From My Agents Deleting My Stuff?](/en/2026/07/11/how-to-protect-yourself-from-agents-deleting-your-stuff/). The ai-jail story is in [AI Agents: Locking Down Your System](/en/2026/01/10/ai-agents-locking-down-your-system/) and in the [Rust rewrite](/en/2026/03/01/ai-jail-sandbox-for-ai-agents-from-shell-script-to-real-tool/).

Now go run the upgrade.
