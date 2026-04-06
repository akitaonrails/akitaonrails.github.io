---
title: "Porting 10K Lines of Python to Crystal with Claude: easy-subtitle"
date: '2026-03-07T22:00:00-03:00'
draft: false
slug: porting-10k-lines-of-python-to-crystal-with-claude-easy-subtitle
translationKey: easy-subtitle-python-to-crystal
tags:
  - crystal
  - python
  - claude
  - vibe-coding
  - subtitle
---

In the [previous article](/en/2026/03/07/easy-ffmpeg-smart-wrapper-in-crystal/) I showed why I picked Crystal for command-line CLIs. In this one I want to show a more ambitious case. It isn't a tool from scratch anymore — it's a feature-parity port of a 10,000-line Python open source project.

## The problem: subtitles

Anyone who maintains a movie and TV collection knows the pain. You download the MKV, but the embedded subtitle is out of sync. Or worse: there's no subtitle at all in the language you want. So you go to OpenSubtitles, download a subtitle, and it's 3 seconds ahead because it was made for a different release. The manual flow is:

1. Extract subtitle tracks from the MKV with `mkvextract`
2. Go to OpenSubtitles, look for a subtitle for the movie
3. Download, test, see it's out of sync
4. Run some sync tool (ffsubsync, alass)
5. Rename the file, move it to the right place
6. Repeat for every language, for every movie

For someone with 10 movies, it's tolerable. For someone with hundreds, it's insanity. It's exactly the kind of thing that should be automated.

## Subservient: the Python solution

Looking at what already existed, I found [Subservient](https://github.com/N3xigen/Subservient). It's a Python project that automates exactly this flow: it extracts subtitles from MKVs, downloads them from OpenSubtitles via REST API, syncs them with ffsubsync, and cleans ads out of SRT files.

The project is complete. It has movie mode and series mode, smart sync (tests every candidate in parallel and picks the best one) and first-match (stops at the first one that works). It uses the OpenSubtitles hash for exact matching and cleans watermarks and ads with more than 30 regex patterns.

But it has the typical Python distribution problems:

- **7 pip dependencies**: colorama, requests, langdetect, ffsubsync, platformdirs, pycountry, tqdm
- **ffsubsync as the sync engine**: which in turn depends on numpy, auditok, and a bunch more Python packages
- **Interactive menu UI**: good for manual use, terrible for scriptability
- **Config in INI format**: not the end of the world, but YAML is more ergonomic
- **10,220 lines across 6 Python files**: 2,700-line files with hundreds-of-lines functions each

The point isn't that Python is bad for this. Subservient works. But installing and maintaining it in production is another story. If you want to run it on a headless server, you need Python 3.8+, pip, virtualenv (or you're going to pollute the system), and pray no dependency breaks with the next OS update.

## The experiment: porting it to Crystal with Claude

Here's where it gets interesting. I wanted to test a hypothesis: can Claude take a large open source project, understand the architecture, and do a complete port to another language?

I'm not talking about translating it file by file. I'm talking about understanding what the project does, redesigning the architecture where it makes sense, and generating idiomatic code in Crystal.

What I did:

1. Asked Claude to clone and analyze the Subservient repo
2. Explained the design decisions: use [alass](https://github.com/kaegi/alass) (a Rust binary, no Python dependencies) instead of ffsubsync, CLI subcommands instead of interactive menus, YAML instead of INI
3. Asked for a feature-parity port, with tests

alass is an important detail. ffsubsync works fine, but it's a Python package that pulls in numpy and does audio analysis. alass does the same thing (subtitle synchronization through timing analysis), but it's a standalone Rust binary. Swapping one for the other eliminates the biggest Python dependency in the stack.

## The result: easy-subtitle

Five commits. Less than 40 minutes from the first to the last.

| Commit | Time | What it did |
|--------|------|-----------|
| Initial implementation | 21:47 | Complete port: 42 src files, 16 test files, CI, install script |
| Track shard.lock | 21:56 | Dependency lock for reproducible builds |
| Prefer ~/.local/bin | 22:03 | Install script fix |
| Add doctor command | 22:20 | New `doctor` command to validate the setup + bump v0.2.0 |
| Homebrew formula | 22:24 | Support for `brew install` and auto-update workflow |

The first commit already delivers a working project: 8 CLI commands, OpenSubtitles client with rate limiting, 76 passing tests, GitHub Actions with CI and release for Linux and macOS.

### Numbers

| Metric | Subservient (Python) | easy-subtitle (Crystal) |
|---------|---------------------|------------------------|
| Source code | 10,220 lines (6 files) | 2,516 lines (42 files) |
| Tests | 0 | 800 lines (76 specs) |
| Runtime dependencies | 7 pip packages + ffsubsync | 0 (just webmock for tests) |
| Binary | n/a (needs Python + deps) | ~6MB static |
| Config | INI | YAML |
| Sync engine | ffsubsync (Python) | alass (Rust) |
| UI | Interactive menu | CLI subcommands |
| Concurrency | ThreadPoolExecutor | Crystal fibers + channels |

The LOC difference is loud: 10,220 vs 2,516. But that's not all Crystal's doing. The original Python has monolithic files of thousands of lines, with a lot of duplication and UI logic mixed with business logic. The port separates the responsibilities into small, focused modules.

### Architecture of the port

```
easy-subtitle/
  src/easy_subtitle/
    cli/           # Router + 9 commands (init, extract, download, sync, run, clean, scan, hash, doctor)
    core/          # Language map, SRT parser/writer/cleaner, video scanner
    acquisition/   # OpenSubtitles API client, auth, search, download, movie hash
    extraction/    # MKV track parsing, extraction, remuxing
    synchronization/  # alass runner, offset computation, smart/first-match strategies
    models/        # VideoFile, SubtitleCandidate, CoverageEntry
```

Every module has a clear responsibility. The biggest file is 144 lines (config). In the original Python, `acquisition.py` alone has 2,726 lines.

### What each command does

```bash
# Generate the default config
easy-subtitle init

# Extract subtitles from inside MKVs
easy-subtitle extract /path/to/movies

# Download subtitles from OpenSubtitles
easy-subtitle download -l en,pt /path/to/movies

# Sync downloaded subtitles with the video
easy-subtitle sync /path/to/movies

# Full pipeline: extract → download → sync
easy-subtitle run /path/to/movies

# Clean ads/watermarks from SRTs
easy-subtitle clean /path/to/subtitles

# See subtitle coverage by language
easy-subtitle scan --json /path/to/movies

# Compute the OpenSubtitles hash (debug)
easy-subtitle hash /path/to/movie.mkv

# Validate the setup: config, credentials, dependencies
easy-subtitle doctor
```

`doctor` is a command I added later. It checks whether the config exists, whether the API key is configured, tests login against the API, and checks whether `mkvmerge`, `mkvextract` and `alass` are on the PATH. It shows OS-specific install instructions when something is missing.

### Smart sync with fibers

Smart sync is the part I most enjoyed seeing in the port. In the original Python, it uses `ThreadPoolExecutor` to run multiple candidates in parallel. In Crystal, the same logic is more natural with fibers and channels:

```crystal
def execute(candidates : Array(Path), video : VideoFile) : SyncResult?
  channel = Channel(SyncResult).new(candidates.size)

  candidates.each do |candidate|
    spawn do
      result = sync_one(candidate, video)
      channel.send(result)
    end
  end

  results = Array(SyncResult).new(candidates.size)
  candidates.size.times do
    results << channel.receive
  end

  accepted = results.select(&.accepted?)
  accepted.min_by(&.offset)
end
```

Each subtitle candidate gets synced in a separate fiber (via `spawn`). The results come back through the `Channel`. At the end, it picks the accepted one with the smallest offset. No ThreadPoolExecutor, no futures, no callbacks.

### API rate limiting

OpenSubtitles requires throttling of 500ms between requests. The Crystal client implements that with a Mutex:

```crystal
RATE_LIMIT_MS = 500

private def throttle! : Nil
  @mutex.synchronize do
    elapsed = Time.utc - @last_request_at
    remaining = RATE_LIMIT_MS - elapsed.total_milliseconds
    sleep(remaining.milliseconds) if remaining > 0
    @last_request_at = Time.utc
  end
end
```

Simple, thread-safe, no external library.

### Installation

The static binary comes out of GitHub Actions and can be installed three ways:

```bash
# Homebrew (macOS / Linux)
brew install akitaonrails/tap/easy-subtitle

# Install script
curl -fsSL https://raw.githubusercontent.com/akitaonrails/easy-subtitle/master/install.sh | bash

# Or grab the binary directly from Releases
```

One binary. No Python, no pip, nothing.

## On porting things "just because"

I've always argued that porting software from one language to another just for the language fetish is a waste of time. How many projects have been rewritten in Rust "just because"? How much effort spent on rewrites that delivered no new value?

But I have to admit this experiment made me reconsider.

When the cost of porting drops from weeks/months to less than 40 minutes, the equation changes. Porting Subservient to Crystal with Claude wasn't an exercise in linguistic vanity. I wanted a static binary I could drop on a server and forget. No managing a Python runtime, no pip install breaking on the next system update.

And the result isn't a mechanical port. It's 2,516 lines across 42 files, against 10,220 in 6 monolithic ones. The port came with 76 tests the original didn't have, CI with automatic release for Linux and macOS, a Homebrew formula and an install script with checksum verification.

The point isn't that Python is bad. It's that the bar for "is it worth porting?" got ridiculously low. Feature-parity port with tests in less than an hour. Hard to argue against that.

The [repository is here](https://github.com/akitaonrails/easy-subtitle). GPL-3.0, like the original.
