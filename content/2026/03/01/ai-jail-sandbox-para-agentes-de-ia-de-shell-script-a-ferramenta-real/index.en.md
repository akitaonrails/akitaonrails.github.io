---
title: "ai-jail: Sandbox for AI Agents — From Shell Script to Real Tool"
slug: "ai-jail-sandbox-for-ai-agents-from-shell-script-to-real-tool"
date: 2026-03-01T14:00:00-03:00
draft: false
tags:
- AI
- Linux
- Bubblewrap
- Sandbox
- Rust
- Security
translationKey: ai-jail-sandbox-tool
description: "ai-jail is a Rust tool that wraps bubblewrap (Linux) and sandbox-exec (macOS) to safely run AI coding agents like Claude Code, Codex, OpenCode and Crush in a sandbox."
---

This post is a direct follow-up to [AI Agents: Locking Down Your System](/en/2026/01/10/ai-agents-locking-down-your-system/), where I showed how to use bubblewrap to build a manual jail for your AI agents. If you haven't read it, read it before continuing.

--

In January I published a ~170-line shell script that built a sandbox with bubblewrap to run Claude Code, OpenCode, Crush and any other AI agent. It worked. It solved the problem. But it was a bash script dropped in `~/.local/bin/` that you had to copy, paste, and pray you wouldn't need to customize too much.

Two months of using that script every day showed me its limits. I wanted per-project configuration. I wanted macOS support for the devs on my team. I wanted to stop editing bash arrays every time I needed an extra directory. And I wanted something someone could install with `brew install` or `cargo install` in 10 seconds, without reading 170 lines of script.

Result: [ai-jail](https://github.com/akitaonrails/ai-jail). A Rust tool, ~880KB, 4 dependencies, 124 tests, that does exactly what that script did and more. I'll explain what changed and why you should be using it.

## The Problem (again, for those who skipped the previous post)

AI coding agents need access to your filesystem. They need to run compilers, linters, grep, ls, make, cargo, npm. The minimum to be useful. The problem is that along with that access comes the ability to read `~/.aws/credentials`, exfiltrate your SSH keys, or run an `rm -rf` outside the project directory.

It isn't paranoia. Supply-chain attacks are real. Every other week some NPM, PyPI or RubyGems lib gets compromised. If the agent runs `npm install` and a malicious post-install script tries to exfiltrate your data, the only thing between the attacker and your credentials is whatever barrier you set up beforehand.

The answer is a sandbox. Specifically, one that lets the agent work in the project directory with the tools it needs, but makes the entire rest of the system invisible.

## From Script to Tool

The shell script from the previous post already solved this with bubblewrap. ai-jail solves the same problem, but addresses the limitations that two months of daily use revealed:

| Shell script | ai-jail |
|-------------|---------|
| Configuration by editing bash arrays | Per-project `.ai-jail` TOML file |
| Linux only | Linux + macOS |
| Hardcoded GPU/Docker/Display | Auto-detection with flags to turn things off |
| No dry-run | `--dry-run --verbose` shows everything |
| No lockdown | `--lockdown` for paranoid mode |
| Copy/paste to install | `brew install`, `cargo install`, `mise` |
| No bootstrap | `--bootstrap` generates permission configs for Claude/Codex/OpenCode |

The core logic is the same: bubblewrap creates isolated PID, UTS and IPC namespaces, mounts `$HOME` as an ephemeral tmpfs, and only mounts the project directory with write access. The difference is that all of that is now configurable without editing code.

## Installation

Four ways:

```bash
# Homebrew (macOS and Linux)
brew tap akitaonrails/tap && brew install ai-jail

# Cargo
cargo install ai-jail

# Mise
mise use -g ubi:akitaonrails/ai-jail

# Direct binary from GitHub Releases
curl -fsSL https://github.com/akitaonrails/ai-jail/releases/latest/download/ai-jail-linux-x86_64.tar.gz | tar xz
sudo mv ai-jail /usr/local/bin/
```

On Linux, bubblewrap needs to be installed separately: `pacman -S bubblewrap` (Arch), `apt install bubblewrap` (Debian/Ubuntu), `dnf install bubblewrap` (Fedora). On macOS no extra dependency is needed.

## Basic Usage

```bash
cd ~/Projects/my-app

# Run Claude Code inside the sandbox
ai-jail claude

# Run Codex
ai-jail codex

# Run OpenCode
ai-jail opencode

# Plain bash for debugging
ai-jail bash

# Any command
ai-jail -- python script.py
```

On the first run, it creates an `.ai-jail` file in the project directory:

```toml
# ai-jail sandbox configuration
# Edit freely. Regenerate with: ai-jail --clean --init

command = ["claude"]
rw_maps = []
ro_maps = []
```

This file is committable to the repo. When another dev on your team clones the project and runs `ai-jail`, the same configuration applies.

If you want to add extra directories, you can do it from the CLI or directly in the TOML:

```bash
# Extra directory with write access
ai-jail --rw-map ~/Projects/shared-lib claude

# Extra read-only directory
ai-jail --map /opt/datasets claude
```

Want to see what the sandbox is going to do without running anything?

```bash
ai-jail --dry-run --verbose claude
```

It shows every mount point, every isolation flag, the full bubblewrap command. No surprises.

## Why Bubblewrap on Linux

I evaluated the alternatives before deciding. The [full analysis document](https://github.com/akitaonrails/ai-jail/blob/master/docs/sandbox-alternatives.md) is in the repository, but the short version is:

Bubblewrap (bwrap) is the sandbox Flatpak uses to isolate every desktop app. ~50KB binary, ~4000 lines of C, maintained by the GNOME team. It runs without root using `CLONE_NEWUSER` to create namespaces without elevated privileges. It's packaged in every relevant Linux distro and tested at scale by millions of Flatpak installations.

I considered and rejected the alternatives. Firejail requires setuid root, and trusting setuid to protect against agents already running on your system is contradictory. nsjail and minijail are designed for production environments (Google uses them internally), too complex for a dev workstation. systemd-nspawn requires root and is meant for system containers, not for isolating a single process.

Landlock is a different case. It doesn't replace bubblewrap — it has nothing to do with namespaces or mount isolation. But it complements. Landlock is a Linux Security Module that controls access at the VFS level, independent of mount namespaces. That closes vectors bwrap alone doesn't cover: escape paths through `/proc`, symlink tricks inside permitted mounts, and it serves as a safety net against bugs in the namespace machinery itself. As of v0.4.0, ai-jail applies Landlock automatically on kernels 5.13+ as defense-in-depth. It uses ABI V3 (Linux 6.2+) with graceful degradation to V1 on older kernels, and turns into a silent no-op if the kernel doesn't support it. If it causes problems with some specific tool, `--no-landlock` turns it off.

Bubblewrap hits the exact sweet spot: real isolation without root, on every distro, and simple enough to wrap in an 880KB binary.

## What the Sandbox Does on Linux

When you run `ai-jail claude`, this is what happens:

The agent runs in isolated PID, UTS and IPC namespaces, with hostname `ai-sandbox`, and dies automatically if the parent dies (`--die-with-parent`).

The filesystem is mounted in a specific sequence (bubblewrap is order-dependent). `/usr`, `/etc`, `/opt`, `/sys` come in read-only for system tools. `/dev` and `/proc` are mounted for device and process access. `/tmp` and `/run` come in as fresh tmpfs. GPUs auto-detected (`/dev/nvidia*`, `/dev/dri`). Docker socket, X11/Wayland, `/dev/shm`, all auto-detected and mounted if they exist.

The most important part is how the home directory is handled. `$HOME` is mounted as an empty tmpfs. Then, selectively, dotfiles get layered on top. `.gnupg`, `.aws`, `.ssh`, `.mozilla`, `.sparrow` are never mounted (sensitive data). `.claude`, `.crush`, `.codex`, `.aider`, `.config`, `.cargo`, `.cache`, `.docker` come in as read-write because the agents need to write here. Everything else comes in read-only. Inside `~/.config`, browser subdirectories are hidden behind tmpfs: `BraveSoftware`, `Bitwarden`. Same in `~/.cache`: `BraveSoftware`, `chromium`, `spotify`, `nvidia`. The agent can't even see those directories exist.

The current project directory is the only place with write permission (besides the tool dotdirs). The agent modifies the code, but doesn't touch anything else.

## macOS: sandbox-exec

On macOS, the backend is `sandbox-exec` with SBPL (Sandbox Profile Language) profiles. It's a legacy Apple API, officially deprecated but with no public replacement. It works today, but Apple may remove it in the future.

ai-jail generates an SBPL profile at runtime that mirrors the same logic as Linux:

- Default deny on everything
- Allows process operations (exec, fork, signal)
- Allows network (except in lockdown)
- Allows global reads, denies sensitive paths (`.gnupg`, `.aws`, `.ssh`, `~/Library/Keychains`, `~/Library/Mail`)
- Allows writes only in the project directory, tool dotfiles, and `/tmp`

The limitations are real. GPU (Metal) and Display (Cocoa) are system-level on macOS, sandbox-exec can't restrict them. The `--no-gpu` and `--no-display` flags simply have no effect on macOS. Cross-platform parity is approximate, not exact.

Even with those limitations, it's better than running the agent completely open. sandbox-exec protects against access to sensitive filesystem areas and, in lockdown, removes write and network permissions.

## Windows: Not Supported (And Probably Never Will Be)

It's not for lack of interest, it's lack of primitives. Windows has no userspace equivalent to Linux namespaces. No mount API like bubblewrap. AppContainers exist but use a completely different security model, require admin privileges, and mapping bwrap functionality to AppContainers would effectively mean writing another project from scratch.

The Windows answer is WSL 2:

```bash
# Inside WSL 2 (real Linux kernel)
sudo apt install bubblewrap
cargo install ai-jail
# or: mise use -g ubi:akitaonrails/ai-jail

cd /mnt/c/Users/you/Projects/my-app
ai-jail claude
```

WSL 2 runs an actual Linux kernel. Bubblewrap works normally. Windows files are accessible at `/mnt/c/`. I/O performance is slower across the 9p mount, but it works. For large projects, cloning inside `~/Projects/` on the Linux side improves performance considerably.

## Lockdown Mode

For workloads you really don't trust, there's `--lockdown`:

```bash
ai-jail --lockdown bash
```

Lockdown does everything normal mode does, but goes further. The project gets mounted read-only (not read-write). GPU, Docker, Display and mise are disabled. `--rw-map` and `--map` flags are ignored. `$HOME` becomes pure tmpfs, no host dotfiles. On Linux, the network is cut with `--unshare-net` and the environment is wiped with `--clearenv`. On macOS, environment variables are wiped and write and network rules are removed from the SBPL.

It's the most restrictive sandbox you can build short of using a VM. Useful for auditing third-party code or running agents on projects you don't know.

## Bootstrap: Automatic Permission Configuration

`ai-jail --bootstrap` generates permission configurations for the tools you use:

```bash
ai-jail --bootstrap
```

For **Claude Code**, it generates `~/.claude/settings.json` with allow/deny/ask lists. Allows git status, diff, log, ls, grep, cargo, npm, python, docker compose. Blocks rm -rf, sudo, chmod 777, git push --force. Asks before git push, rm, docker run.

For **Codex**, it generates `~/.codex/config.toml` with `approval_policy = "on-request"`.

For **OpenCode**, it generates `~/.config/opencode/opencode.json` with bash, edit, write permissions.

Before overwriting any file, it makes an automatic backup (`settings.json.bak`). And it rejects operations if the target is a symlink, to avoid path traversal.

It's exactly the content I put in manually in the [previous post](/en/2026/01/10/ai-agents-locking-down-your-system/), but automated and tested.

## But Claude Code Already Has Its Own Sandbox

It does. Since October 2025, Claude Code has offered a runtime sandbox via the `/sandbox` command. And guess what it uses underneath? Bubblewrap on Linux and sandbox-exec on macOS. The same stack.

But the differences matter.

ai-jail is tool-agnostic. It works with Claude, Codex, OpenCode, Crush, and any command. Claude's sandbox only protects Claude. If tomorrow you switch agents, ai-jail keeps working the same.

The thing that bothers me most is the escape hatch. When a command fails because of a sandbox restriction, Claude can retry with `dangerouslyDisableSandbox`, falling back to the normal permission flow. You can disable that (`"allowUnsandboxedCommands": false`), but it's opt-out, not opt-in. In ai-jail, there is no escape hatch. The process runs inside bwrap or sandbox-exec, period. There's no way for the agent to decide on its own to leave the sandbox.

Another practical difference: `.ai-jail` lives in the project directory and can be committed to the repo. Any dev who clones the project inherits the same sandbox policy. Claude's sandbox depends on a global `settings.json`.

When run inside Docker, Claude's sandbox falls back to an `enableWeakerNestedSandbox` mode that, in the words of its own documentation, *"considerably weakens security"*. ai-jail wasn't designed to run inside Docker (it runs directly on the dev's workstation), so this problem doesn't exist.

About the network: Claude's sandbox routes traffic through a proxy and allows/blocks by domain. ai-jail in normal mode inherits the host network; in lockdown, it cuts the entire network with `--unshare-net`. Claude's approach is more granular; ai-jail's is simpler and harder to circumvent.

The two aren't mutually exclusive. You can run Claude's sandbox inside ai-jail. ai-jail handles filesystem isolation; Claude's sandbox adds per-domain network filtering. Security layers stack.

## Why Not Use --dangerously-skip-permissions Without a Jail

I'll be blunt: if you run Claude Code with `--dangerously-skip-permissions` without any sandbox, you're trusting blindly that the LLM will never execute anything destructive. And you're trusting that none of your project's dependencies has been compromised in a supply-chain attack.

Every `--dangerously` flag has that name for a reason. Claude Code is explicit: that mode exists for CI/CD and automation in environments that are already isolated (containers, throwaway VMs). Not for your personal workstation with `~/.aws/credentials`, `~/.gnupg/`, SSH keys, and your browser's password vault.

With ai-jail, the agent has total autonomy inside the sandbox. It does whatever it wants in the project directory, uses the tools it needs, and can't access anything outside what was explicitly permitted.

## ai-jail + Git: The Safety Net You Already Have

There's something I haven't mentioned yet that changes the risk calculus: if your project is in a Git repo, with a remote on GitHub/GitLab, and the agent doesn't have permission to `git push`, the damage it can cause is limited to the local directory.

Think about it. The worst-case scenario inside ai-jail is the agent corrupting every file in the project. Annoying? Sure. Catastrophic? No. You run `git checkout .` and you're back to the last commit. If it corrupts `.git` somehow (unlikely, but possible), you delete the directory and clone again. The remote was never touched.

That's why ai-jail's `--bootstrap` puts `git push` on the "ask" list (ask before running), not the "allow" list. And `git push --force` goes straight to "deny". The agent can commit locally all it wants, can create branches, can rebase. None of that affects the remote. When it comes time to push, you review what it did and decide whether it goes live.

That combination, sandbox for the filesystem + Git for the code + manual push, already gives you a very reasonable security level for daily use. ai-jail protects your personal data and the system. Git protects your code. And the decision to publish stays yours.

If you want to go further, the next two sections cover additional layers.

## ai-jail vs Dev Containers

Since I wrote ai-jail, the most frequent question is: *"why not use Dev Containers?"*. The short answer is that one doesn't replace the other. They solve different problems.

Dev Containers (the [containers.dev](https://containers.dev) spec) define a complete development environment in a `devcontainer.json`. You specify base image, tools, VS Code extensions, environment variables, and the editor mounts everything for you in a Docker container. Docker also recently launched Docker Sandboxes, which go further and run each agent in a microVM with Firecracker, with hardware isolation.

ai-jail does none of that. It doesn't define an environment. It doesn't install tools. It doesn't run a Docker image. It takes the environment that already exists on your machine and restricts what the process can access.

In practice, the difference is:

| | Dev Container | ai-jail |
|---|---|---|
| What it does | Defines and provisions a complete isolated environment | Restricts process access to the existing filesystem |
| Setup | `devcontainer.json` + Docker | `.ai-jail` TOML + bubblewrap |
| Startup | Seconds (image pull, container build) | Milliseconds (fork + exec of bwrap) |
| Tools | Whatever you put in the image | Whatever's already installed on your machine |
| GPU | Requires NVIDIA Container Toolkit configuration | Auto-detects `/dev/nvidia*` and `/dev/dri` |
| Daemon | Requires Docker daemon running | Nothing besides bwrap |
| Reproducibility | High (fixed image) | Depends on what's installed on the host |
| Network isolation | Docker Sandboxes: per-domain firewall | Lockdown: cuts everything with `--unshare-net` |

Dev Container makes more sense when you need the whole team to have exactly the same environment, or when the project has dependencies nobody wants to install on the host, or for running non-interactive agents in CI/CD. Docker Sandboxes with microVM are the strongest isolation that exists outside a dedicated VM.

ai-jail makes more sense when you already have the environment configured and want instant startup with no Docker daemon. Or when you use tools that are annoying to run inside a container (CUDA, Wayland, mise). Or simply when you want the same protection for any agent, not just the ones with devcontainer integration.

And you can combine them. I know people who run ai-jail inside a Dev Container to get environment reproducibility + filesystem restriction. Security layers stack.

## Immutable Operating Systems: The Last Layer

If you want to take security seriously, the third layer is the operating system itself.

Immutable systems like [Fedora Silverblue](https://fedoraproject.org/atomic-desktops/silverblue/), [NixOS](https://nixos.org/), and [openSUSE Aeon](https://aeondesktop.github.io/) have a read-only root filesystem. The base system can't be modified by any process, even with root. Updates are atomic: they either apply completely or not at all. And if something goes wrong, you roll back to the previous image in one reboot.

In practice, that means even if an AI agent escaped the sandbox (exploiting a kernel vulnerability, for example), it couldn't modify the system persistently. On the next reboot, the system returns to the declared state. On NixOS, the entire system is defined by a configuration file (`configuration.nix`). On Silverblue, the base is an OSTree image that gets atomic updates via `rpm-ostree`.

For developers, the catch is: your dev tools run in containers (Toolbox/Distrobox on Silverblue, `nix-shell` on NixOS). The base system stays untouched. Desktop apps come via Flatpak, which already runs in a sandbox. The result is that the host's attack surface is minimal.

Fedora Silverblue is probably the most accessible entry point. It's already Fedora underneath, with GNOME, works with hardware Fedora supports, and Toolbox gives you a containerized Fedora Server where you install whatever you want without touching the host. NixOS is more powerful (full reproducibility, declarative rollback), but the learning curve is real.

The full combination looks like this: the immutable OS handles the system (read-only filesystem, atomic updates, one-reboot rollback). ai-jail handles the session (isolated namespace, ephemeral home, sensitive data invisible). And Git handles the code (remote untouched as long as the agent doesn't have push).

None of those layers is perfect on its own. But the attack that punches through all three at the same time — escaping the namespace, persisting on a read-only filesystem, and corrupting a Git remote — is a scenario I'd be comfortable calling unlikely.

The best part is that none of them requires changing how you work. ai-jail is one command before your agent. Git you already use. And an immutable OS is an installation, not a workflow change.

## Technical Details (For Those Who Care)

Written in Rust with 124 tests and 4 dependencies: `lexopt` (CLI parsing without clap), `serde` + `toml` (config), `nix` (Unix syscalls). No async runtime, no color framework (raw ANSI), ~880KB binary with LTO and strip.

Signal handling is done correctly: SIGINT, SIGTERM, and SIGHUP are forwarded to the child process. The handler only calls `libc::kill`, which is async-signal-safe. Process reaping uses `waitpid` in a loop with retry on EINTR.

Temporary files (like the custom `/etc/hosts` the sandbox mounts) use RAII: a `SandboxGuard` that implements `Drop` in Rust. If the parent process dies for any reason, cleanup happens.

Configuration compatibility is guaranteed by development policy: never remove fields, never rename, new fields always with `#[serde(default)]`, unknown fields are silently ignored. Regression tests for old `.ai-jail` formats guarantee that updating the binary never breaks existing configs. There are 32 tests just for config.

## Roadmap

What's left:

- More tool backends in bootstrap: Aider, Cursor, Windsurf. As more agents standardize permission configuration files.
- Profile sharing for monorepos, so you don't have to configure each service separately.

## Installation and First Use (Quick Recap)

```bash
# 1. Install
brew tap akitaonrails/tap && brew install ai-jail
# or: cargo install ai-jail

# 2. On Linux, install bubblewrap
sudo pacman -S bubblewrap  # Arch
# sudo apt install bubblewrap  # Debian/Ubuntu

# 3. Enter the project and run
cd ~/Projects/my-app
ai-jail claude

# 4. (Optional) Generate permission configs
ai-jail --bootstrap

# 5. (Optional) See what the sandbox does
ai-jail --dry-run --verbose claude
```

The `.ai-jail` file it creates can be committed to your repo. From then on, any dev who clones the project runs `ai-jail claude` and gets the same sandbox.

## Conclusion

January's shell script solved the problem. ai-jail solves the problem properly. Per-project config, macOS support, lockdown mode, permission bootstrap, dry-run for auditing, and an 880KB binary that installs in 10 seconds.

If you use AI agents to code, run them in a sandbox. The LLM's good intentions are no guarantee of anything, and supply-chain attacks don't pick their victims. Process isolation is the barrier that works.

The project is GPL-3.0 and is on GitHub: [github.com/akitaonrails/ai-jail](https://github.com/akitaonrails/ai-jail)

Issues and PRs are welcome.
