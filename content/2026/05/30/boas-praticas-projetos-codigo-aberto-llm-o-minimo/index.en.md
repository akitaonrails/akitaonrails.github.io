---
title: "Open Source Best Practices with LLMs - The Bare Minimum"
slug: "open-source-best-practices-llm-the-minimum"
date: '2026-05-30T13:00:00-03:00'
draft: false
translationKey: open-source-best-practices-llm-the-minimum
tags:
  - opensource
  - github-actions
  - ci-cd
  - docker
  - deploy
  - rust
  - AI
  - vibe-coding
---

Over the last few months I've pushed a pile of personal projects to GitHub. [Frank FBI](https://github.com/akitaonrails/frank_fbi), [Frank Mega](https://github.com/akitaonrails/FrankMega), [Frank Yomik](https://github.com/akitaonrails/FrankYomik), [Frank Sherlock](https://github.com/akitaonrails/FrankSherlock), [Frank Investigator](https://github.com/akitaonrails/frank_investigator), [ai-jail](https://github.com/akitaonrails/ai-jail), [ai-memory](https://github.com/akitaonrails/ai-memory), [ai-usagebar](https://github.com/akitaonrails/ai-usagebar), [ghpending](https://github.com/akitaonrails/ghpending), and so on. Some in Ruby on Rails, most in Rust, one or two in Flutter. Coded mostly with Claude Code and Codex, riding the wave of my [vibe coding marathon](/en/2026/05/14/wrapping-up-my-ai-marathon-success-or-failure/).

And here's the part nobody mentions when they say "I built a project with AI": generating the code is the easy part. The hard part, the thing that separates a repo that's just a pile of code from an actual open source project, is everything that comes **after** `git init`.

I have a strong opinion about this, so let me just plant the flag: no open source project is ready to be published without three things. In order of importance:

1. **Installation surface.** The new user has to be able to install and try the tool with the least friction possible. One command, ideally.
2. **Tests and automated CI.** So contributions are easier and there's common ground on what's minimally acceptable to land in the project.
3. **Documentation.** The short, easy-to-read version (the README) and a more detailed set in `docs/`, so new contributors understand the architectural decisions.

Without those three, the way I see it, the project isn't ready. It can have the most brilliant code on earth inside, doesn't matter. If a stranger can't install it, can't trust that whatever they touch won't break everything, and can't understand why things are the way they are, then you don't have an open source project. You have a public dead archive.

And there's a bonus that became an essential part of my workflow: **when all my projects follow the same pattern, I can just tell Claude Code or Codex "run the deploy" or "cut a release," and they can do it.** Because the structure is predictable. `bin/deploy` does the same thing in every project. The release comes out of a tag. The agent doesn't have to guess anything. Standardization is what makes the automation trustworthy. It looks like fussiness from an organized person, but it's the prerequisite for me to trust, eyes closed, whatever the agent is about to run.

Let me break down the three pillars and show the minimum setup I actually use.

## Pillar 1: The installation surface

This is the most important one and the most neglected. People spend weeks tuning the internal algorithm and then ship a README that says "clone the repo and run `cargo build --release`." So the guy who was curious enough to try it needs to have Rust installed, wait ten minutes for it to compile, and pray no system lib is missing. You just lost 90% of your potential users.

The ideal is to offer **several paths** and let the user pick the one that fits their environment. Look at the install header for ai-jail, my champion of options:

```sh
# Homebrew (macOS or Linux)
brew tap akitaonrails/tap && brew install ai-jail

# AUR (Arch Linux) - prebuilt binary
yay -S ai-jail-bin

# cargo (any platform with Rust)
cargo install ai-jail

# mise
mise use -g github:akitaonrails/ai-jail

# Direct binary download
curl -fsSL https://github.com/akitaonrails/ai-jail/releases/latest/download/ai-jail-linux-x86_64.tar.gz | tar xz
```

Five paths. The Arch user runs `yay`. The macOS one runs `brew`. The Rust dev runs `cargo install`. Whoever uses [mise](https://github.com/jdx/mise) to manage versions pulls it through mise. And whoever just wants the binary downloads the tarball straight from the release. Everyone grabs what they're already used to, nobody's forced to install a whole toolchain just to kick the tires.

### The secret: compile once, repackage many

The gotcha that scares you at first is thinking each package format needs its own build. It doesn't. The trick is to **compile the binary once per architecture, then repackage that same binary into every format.**

In my Rust pipeline, the build job produces a tarball with the finished binary and its `sha256`. The packaging steps that follow (Docker, AUR, Homebrew) **download that already-compiled tarball** instead of recompiling. It cuts CI time, guarantees the byte that goes to AUR is exactly the one that goes to Docker, and kills off that whole class of "works in one format, breaks in the other" bug.

```yaml
# Docker job reusing the already-compiled binary
docker-amd64:
  needs: build-linux
  steps:
    - uses: actions/download-artifact@v4
      with:
        name: ai-memory-linux-x86_64
        path: artifacts
    - name: Desempacota o binário pré-compilado
      run: tar -xzf artifacts/ai-memory-linux-x86_64.tar.gz -C dist/docker/
    - uses: docker/build-push-action@v6
      with:
        target: runtime-prebuilt-amd64  # inject the binary, don't recompile
```

The AUR job does the same thing: download the tarball, compute the `sha256`, inject it into the `PKGBUILD`:

```sh
X86_SHA=$(awk '{print $1}' artifacts/ai-usagebar-linux-x86_64.tar.gz.sha256)
sed -i "s/^sha256sums_x86_64=.*/sha256sums_x86_64=('$X86_SHA')/" packaging/aur/PKGBUILD-bin
```

That's the core idea. The binary is the real artifact. RPM, DEB, AppImage, AUR, Homebrew tarball, Docker image, all of it is just **wrapping around the same binary**.

The two snippets above are excerpts. If you want to see the whole thing running, the full build-once-reuse flow (binary compiled once, reused across the Docker and AUR jobs) lives in [ai-memory's `release.yml`](https://github.com/akitaonrails/ai-memory/blob/main/.github/workflows/release.yml), and the `sha256` injection into the `PKGBUILD` is in [ai-usagebar's `release.yml`](https://github.com/akitaonrails/ai-usagebar/blob/main/.github/workflows/release.yml).

### The menu of formats

Every platform is its own world. Here's the minimum worth knowing:

**Linux** is the most fragmented. The options, from simplest to most work:

- **Tarball** (`.tar.gz`): the lowest common denominator. Works on any distro, just unpack it and drop it in `PATH`. Always offer this one.
- **AUR** (Arch): two packages, the `-bin` (prebuilt binary, installs in seconds) and the source one (compiles on the user's machine). I publish both with the `KSXGitHub/github-actions-deploy-aur` action. The `-bin` is what everybody uses.
- **AppImage**: a single executable file that carries all its dependencies inside. Good for desktop apps. Frank Sherlock, which is Tauri, builds the AppImage right in the build and I still GPG-sign it afterward (the signing step is in [its `release.yml`](https://github.com/akitaonrails/FrankSherlock/blob/master/.github/workflows/release.yml)). For a simple binary you can use `appimagetool`.
- **RPM and DEB**: for Fedora/openSUSE and Debian/Ubuntu. The tool that saves your life here is [nfpm](https://github.com/goreleaser/nfpm), which generates both from a single declarative `nfpm.yaml`, no need to learn the guts of `rpmbuild` or `dpkg-deb`. It takes the already-compiled binary and spits out both packages.

**macOS** has two targets: Apple Silicon (`aarch64-apple-darwin`) and Intel (`x86_64-apple-darwin`). You either compile them separately or build a universal binary with `lipo`. And here lives the platform's biggest headache: **signing and notarization**. Without it, macOS Gatekeeper refuses to open your app. The flow is to decode the P12 certificate, import it into a temporary keychain, sign with `codesign --options runtime --timestamp`, and notarize:

```sh
codesign --sign "$APPLE_SIGNING_IDENTITY" --options runtime --timestamp ./meu-binario
ditto -c -k meu-binario notarize.zip
xcrun notarytool submit notarize.zip \
  --apple-id "$APPLE_ID" --password "$APPLE_PASSWORD" \
  --team-id "$APPLE_TEAM_ID" --wait
```

This requires a paid Apple Developer account. It's annoying, but it's the price of not throwing an "app is damaged" error in your user's face. The whole signing-and-notarization job, with the temporary-keychain dance, is in [ai-jail's `release.yml`](https://github.com/akitaonrails/ai-jail/blob/master/.github/workflows/release.yml).

**Windows** is the easiest to build (`x86_64-pc-windows-msvc`) and the thorniest to sign. A Windows code signing certificate is expensive and bureaucratic, so I, honestly, don't sign. I accept that SmartScreen will throw a warning on first run and I make that clear in the README. For a personal open source project, that's good enough.

**Rust crates** (`cargo publish`): if it's a Rust library or CLI, publishing to [crates.io](https://crates.io) gives you `cargo install` for free. One line in the pipeline. Tip: make it idempotent, because re-running on an already-published tag errors out. I `grep` the output for "already exists" so it doesn't blow up the whole release over that.

**Homebrew**: the clean way is to keep your own tap (`akitaonrails/homebrew-tap`). The pipeline updates the formula with the new URL and the new `sha256` on every release. The user runs `brew tap` once and after that it's just `brew upgrade`.

**mise**: [mise](https://github.com/jdx/mise) can install straight from GitHub releases without you configuring anything on your end, as long as your tarballs follow a platform-name convention. You get this path basically for free just by naming your releases well.

Notice a detail: AUR, Homebrew, mise, and the direct download **all consume the same release tarball**. You publish the binaries once, and four different package managers know how to fend for themselves. That's why "compile once, repackage many" is the golden rule.

## Pillar 2: GitHub Actions, tag-based releases, and the changelog

The second thing that makes an open source project serious is CI. Forget the "build passing" badge on the README, the value is in the common ground it creates: when someone sends a pull request, CI runs the tests, the linter, and the security scanner, and you know right away whether that contribution breaks anything. Without it, every PR turns into a tiresome manual negotiation.

On my Rust projects CI runs `cargo fmt --check`, `cargo clippy -D warnings`, `cargo test`, and `cargo audit`. On the Rails projects it's `rubocop`, `brakeman` (security scanner), `bundler-audit`, and the Minitest suite. [FrankMD](https://github.com/akitaonrails/FrankMD) alone has over 1,800 tests between Ruby and JavaScript. Frank Sherlock clears 300 tests in Rust plus 300 on the frontend. That safety net is what lets me accept a stranger's PR without sweating.

### PR review with an LLM

The tests and CI are the bottom net. Above it there's a layer that became central to my workflow: using the LLM itself to review the pull requests. Opus and GPT are absurdly good at code review and quality refactoring. Better than me on consistency, because they don't get tired and they don't skim over 200 lines just because it's the fifth review of the day.

I have two prompts I use all the time. The first, for a specific PR that just landed:

> look at the open PR on github. don't trust the author's description. audit the code thoroughly to see if it actually makes sense. make sure there are no regressions and no drop in code quality. make sure test coverage is adequate. then tell me what you think we should do.

Notice the "don't trust the author's description." That's deliberate. A PR description tells you what the person thought they did, and it doesn't always match what they actually did. The LLM has to read the real code, not the summary.

The second prompt is for after a long coding session or a bunch of PRs merged at once:

> we touched a lot of code. audit the code those PRs changed, look for dead code, unnecessary duplication, magic hardcoded values that should be constants and/or better documented, missing test coverage, aim for [clean code](/en/2026/04/20/clean-code-for-ai-agents/) principles, then check whether the documentation was properly updated.

With the verdict in hand, I decide. For an incomplete PR, what I do depends on the size and my priority at that moment. If it's something small, I fix it myself right in the PR with an `amend`, reply explaining what I changed, and then merge and close. When I can merge but can't fix beforehand, I merge and immediately drop a follow-up fix commit. And when it's a big change, I ask the LLM to reply to the PR explaining why we're not merging, with the right direction on what needs to be done.

That's how I closed almost 40 PRs and 20 issues on ai-memory alone, in a couple of days. That volume doesn't happen by hand, and it also can't happen on autopilot.

And this is the point I keep hammering: none of this is blind. I'm piloting the LLM toward those goals the whole time. It does the audit, puts the suggestions on the table, and even writes the text of the reply, but the one who decides to merge, fix, or reject is me. The LLM is the tireless reviewer; I'm the one who signs off.

### The tag-based trigger

The release part is separate from CI. While CI runs on every push and PR, the release fires **only when you push a version tag**:

```yaml
on:
  push:
    tags:
      - 'v*.*.*'   # dispara em v1.2.3, v0.5.0, etc.
  workflow_dispatch: # permite disparar manualmente também
```

The flow for cutting a version becomes this:

```sh
git tag v0.5.0
git push origin v0.5.0
```

And that's it. GitHub Actions notices the tag, fires the release workflow, compiles for the targets, packages everything, signs whatever needs signing, creates the GitHub Release, and publishes to the package managers. I don't touch anything else. In fact that's literally what I tell Claude Code: "cut v0.5.0." It runs `cargo set-version`, updates the CHANGELOG, commits, creates the tag, pushes, and the rest is the pipeline.

The Rust build matrix compiles each target on its native platform:

```yaml
strategy:
  matrix:
    include:
      - os: ubuntu-22.04
        target: x86_64-unknown-linux-gnu
      - os: ubuntu-22.04-arm
        target: aarch64-unknown-linux-gnu
      - os: macos-latest
        target: aarch64-apple-darwin
      - os: windows-latest
        target: x86_64-pc-windows-msvc
```

A cross-compilation gotcha: if you compile ARM inside an x86 machine (via [cross](https://github.com/cross-rs/cross)), you **can't run the tests** for that binary right there, because the architecture doesn't match. The fix is to run tests only on the native target and cross-compile the rest without testing. ai-usagebar does exactly that, x86 native and ARM via `cross`, in the matrix of [its `release.yml`](https://github.com/akitaonrails/ai-usagebar/blob/main/.github/workflows/release.yml). And always use a compile cache: `Swatinem/rust-cache` easily cuts build time in half.

### Release notes and the changelog matter

This is where a lot of people slack off, and they shouldn't. When you cut a release, the person thinking about upgrading wants to know **what changed**. "v0.5.0" says nothing. A changelog says something.

I keep a `CHANGELOG.md` in the [Keep a Changelog](https://keepachangelog.com/) format, one section per version. And the pipeline automatically extracts the current version's section to paste into the GitHub Release body. A simple `awk` handles it:

```sh
awk -v ver="$VERSION" '
  BEGIN { hdr = "## [" ver "]" }
  index($0, hdr) == 1 { flag=1; next }
  flag && index($0, "## [") == 1 { exit }
  flag { print }
' CHANGELOG.md > changelog_section.md
```

That `awk` is the same one that runs on the ai-usagebar release (again in [its `release.yml`](https://github.com/akitaonrails/ai-usagebar/blob/main/.github/workflows/release.yml), which is my most polished one on this front). Then, after the changelog, I append the install instructions and the `sha256` checksums for each artifact. The result is a GitHub Release that explains itself: what changed, how to install it, and how to verify the integrity of the download. The user reads it and decides whether to upgrade. That's the kind of care that makes a stranger trust your project.

## Pillar 3: Real deployment, no fuss

The projects that run as a service (the Rails ones, mainly) have to go somewhere. And here I go against the hype. No Kubernetes. No Kamal. No three-stage deploy pipeline with manual approval.

I have a home server. A [Minisforum MS-S1 Max running openSUSE MicroOS](/en/2026/03/31/migrating-my-home-server-with-claude-code/) that I migrated recently, with a [Gitea](https://github.com/go-gitea/gitea) acting as a private Docker registry on port 3007. For a solo developer with a simple home server, that's more than enough. All that cluster-orchestration ceremony is solving a problem I don't have.

The whole deploy fits in a single `bin/deploy`. It does three things: builds the image, pushes it to the registry, and SSHes into the server to bring up the new version:

```sh
#!/usr/bin/env bash
set -euo pipefail

# Config comes from a .gitignored file, outside the repo
source "$(dirname "$0")/../config/deploy.env"

IMAGE="${REGISTRY_HOST}:${REGISTRY_PORT}/akitaonrails/frank_fbi:latest"

echo "==> Buildando a imagem..."
docker build -t "$IMAGE" .

echo "==> Empurrando pro registry..."
docker push "$IMAGE"

echo "==> Subindo no servidor..."
ssh "${DEPLOY_USER}@${DEPLOY_HOST}" \
  "cd ${REMOTE_DIR} && \
   docker compose pull && \
   docker compose down --remove-orphans && \
   docker compose up -d"
```

That's it. `build`, `push`, `ssh` with `pull`, `down`, `up`. Four commands on the remote server, chained in a single SSH. No agent running over there, no webhook, no control panel. The server has a `docker-compose.production.yml` pointing at the `:latest` image from the registry, and the `pull` brings the new version down.

Notice the sensitive data lives in a `config/deploy.env` that **doesn't go into Git**. The repo only carries the `config/deploy.env.example`, with the structure and fake values. This "versioned example, real one ignored" pattern repeats in every project of mine, and it's what lets the project be public without leaking the host, user, or path of my server.

The image itself comes from a multi-stage Dockerfile. The build stage installs the compilation tools, builds everything, and the final stage copies only the result into a lean image, running as a non-root user. The production compose swaps `build:` for `image:`, points the volumes at the server's persistent paths (`/var/opt/docker/...`), and uses `restart: always` to bring everything back up if the server reboots.

And again, the beauty of standardization: since **every** project of mine has this same `bin/deploy`, I can tell Claude Code "deploy Frank FBI" and it knows exactly what to run. I don't have to remember a single command. The tool is the executable documentation of the process.

## The lesson: nobody cares about your stack

Now the part I most wanted to write, and the one worth more than all the YAML snippets above.

Most people, when they go to present a project, focus everything on the technology. "Check out my brand-new vector database." "Check out my last-gen reactive framework." "I used such-and-such microservices architecture." And they fill the top of the README with that: the dependency list, the component diagram, the stack.

Nobody cares.

Seriously. The user who lands on your README doesn't want to know which database you used. They want to know **what problem this solves for them**. Implementation detail doesn't belong at the top of the README. It belongs in `docs/`, for whoever's going to contribute. In the README, what matters is the use case.

Look at the difference. "MCP server in Rust with FTS5 and optional LLM consolidation" says nothing to anybody. Now "long-term memory shared across Claude Code, Codex, and Cursor, with handoff between sessions" — that one the guy gets instantly, because it's the pain he has. Both describe ai-memory. One talks about technology, the other talks about the problem it solves.

The use case is the single most important thing about the whole project. Before writing a line of code, the right question is "what problem does this solve, and for whom?" If you can't answer that in one sentence, you're building a **solution looking for a problem**. And a solution looking for a problem is, in practice, a solution that solves nothing. Doesn't matter how elegant the code is on the inside.

The UX layer, the surface the user touches, is worth far more than the internal engineering. A project with mediocre technology that's trivial to install, that clearly states what problem it solves, and that has honest documentation, goes further than a brilliant project nobody can run. Every time.

So the minimum, the real minimum for an open source project, is this: easy install, CI that gives you confidence, documentation that starts from the problem. The pretty algorithm comes way down the priority list. The three pillars of this post exist to serve one thing, which is the experience of whoever shows up from outside. Get that right first. The rest is implementation detail.
