---
title: "Crystal and a Smart FFmpeg Wrapper Built in 3 Hours | easy-ffmpeg"
date: 2026-03-07T18:00:00-03:00
draft: false
slug: easy-ffmpeg-smart-wrapper-in-crystal
translationKey: easy-ffmpeg-crystal-wrapper
tags: ["crystal", "ffmpeg", "cli", "vibe-coding", "open-source"]
description: "I wanted to convert videos without memorizing FFmpeg flags. Out came a smart CLI in Crystal with presets, interactive mode and static compilation for Linux and macOS, in 3 hours of vibe coding."
---

Anyone who's ever needed to convert a video on the terminal knows the FFmpeg pain. It does everything. Absolutely everything. But to do anything at all, you need to remember flag combinations that look like incantations:

```bash
ffmpeg -i input.mkv -c:v libx264 -crf 23 -preset medium \
  -profile:v high -level 4.1 -c:a aac -b:a 128k \
  -movflags +faststart output.mp4
```

What does that do? Convert to H.264 with reasonable quality for the web, using AAC for audio and moving the moov atom to the start of the file to allow progressive streaming. If you already knew that, congratulations. If you didn't, welcome to the club of 99% of people who use FFmpeg by copying commands from Stack Overflow.

And that's the easy case. Want to make an animated GIF from a sequence of PNGs? You need a two-pass pipeline with palette generation:

```bash
ffmpeg -framerate 10 -i frame_%04d.png \
  -vf "split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" output.gif
```

Want to cut a clip, resize to 720p and force a 16:9 aspect ratio? Good luck assembling the filter chain.

I got tired of memorizing flags. I wanted a CLI where I'd say "convert this to MP4 optimized for the web" and it would figure it out. So I built [easy-ffmpeg](https://github.com/akitaonrails/easy-ffmpeg).

## What easy-ffmpeg does

It's a smart wrapper. You give it the input file and the output format, and it analyzes the video with ffprobe, finds out which video, audio and subtitle streams exist, checks codec compatibility against the destination container, and decides on its own what can be copied directly (no re-encoding, instant) and what needs to be transcoded.

The most basic use:

```bash
# Convert MKV to MP4 (copies compatible streams, no unnecessary re-encoding)
easy-ffmpeg input.mkv mp4

# Optimized for the web (H.264 + AAC, faststart)
easy-ffmpeg input.mkv mp4 --web

# Optimized for mobile (720p, AAC stereo, smaller file)
easy-ffmpeg input.mkv mp4 --mobile

# Maximum compression (H.265, CRF 28)
easy-ffmpeg input.mkv mp4 --compress

# High quality for streaming (H.265, CRF 18)
easy-ffmpeg input.mkv mp4 --streaming
```

## Examples of what you can do

**Cut a clip from the video:**

```bash
# From minute 1:30 to 3:00
easy-ffmpeg video.mp4 mp4 --start 1:30 --end 3:00

# The first 90 seconds
easy-ffmpeg video.mp4 mp4 --duration 90

# Accepts several time formats: 90, 1:30, 01:30.5, 1:02:30
```

**Resize:**

```bash
# To 720p
easy-ffmpeg video.mp4 mp4 --scale hd

# To 1080p
easy-ffmpeg video.mp4 mp4 --scale fullhd

# Presets: 2k (1440p), fullhd (1080p), hd (720p), retro (480p), icon (240p)
```

**Change aspect ratio:**

```bash
# Force 16:9 (adds black bars if needed)
easy-ffmpeg video.mp4 mp4 --aspect wide

# TikTok/Stories format (9:16 vertical)
easy-ffmpeg video.mp4 mp4 --aspect tiktok

# Square for Instagram
easy-ffmpeg video.mp4 mp4 --aspect square

# Crop instead of adding bars
easy-ffmpeg video.mp4 mp4 --aspect wide --crop
```

**Image sequence to video:**

```bash
# Auto-detects the numbering pattern (frame_0001.png, frame_0002.png...)
easy-ffmpeg /folder/with/frames/ mp4

# Animated GIF with optimized palette
easy-ffmpeg /folder/with/frames/ gif

# Image sequence at 720p, 30fps
easy-ffmpeg /folder/with/frames/ mp4 --fps 30 --scale hd
```

**See what it'll do without running it:**

```bash
easy-ffmpeg video.mkv mp4 --web --dry-run
# Shows the exact ffmpeg command that would be executed
```

**Combine everything:**

```bash
# Cut, resize and compress to send over WhatsApp
easy-ffmpeg video.mkv mp4 --start 0:30 --end 2:00 --scale hd --compress
```

And if you run `easy-ffmpeg` with no arguments in an interactive terminal, it opens a TUI mode with file selection through fuzzy search, preset choice through a menu, and time input with validation — all without having to remember any flags.

## Why Crystal

I hadn't touched Crystal in years. The last time was for fun, before version 1.0. And I wanted to revisit it.

Crystal occupies an interesting niche. Go and Crystal compete for the same space: compiled languages for applications, generating static binaries, with garbage collection and no runtime dependency. But the approach is very different.

Go is famously, deliberately simple. No generics for years (they only landed in 1.18), no exceptions (error returns), no expressiveness. The argument is that this makes it easier to read and maintain in big teams. In practice, it produces verbose, repetitive code, with `if err != nil` on every line.

Crystal has static typing with inference, compile-time macros, blocks as closures (just like Ruby), exceptions, generics from day one, and a syntax any Rubyist will recognize:

```crystal
# Crystal: read a JSON and extract data
streams = json["streams"].as_a.map do |s|
  StreamInfo.new(
    codec: s["codec_name"]?.try(&.as_s) || "unknown",
    width:  s["width"]?.try(&.as_i) || 0,
    height: s["height"]?.try(&.as_i) || 0,
  )
end

# Go equivalent: would be 3x more lines with type assertions and error checks
```

Crystal's stdlib has an HTTP server, JSON parsing, YAML, regex, fibers (green threads with a cooperative scheduler), channels (just like Go), and even IO::FileDescriptor with raw mode for the terminal — which I used for the interactive mode. Concurrency works with `spawn` (the equivalent of Go's `go`) and `Channel` (identical to Go's chan). The difference is that everything comes with Ruby's ergonomics.

For a CLI that needs to compile into a static binary with no dependencies, run on Linux and macOS, and be distributed as a direct download — Crystal is perfect. The compiler generates native binaries, and with Docker Alpine you can do static linking with musl for Linux. The final easy-ffmpeg binary is around 6MB.

I think Rust is better for systems code (kernels, drivers, databases, things where ownership and lifetime matter). But for a video conversion CLI? Rust would be overkill. Crystal gives you the same end result (fast static binary) with a third of the code and without fighting the borrow checker.

## The numbers

The whole project was built in one afternoon. 10 commits between 18:32 and 21:33 on March 7, 2026. Three hours.

```
Language     Files       Lines     Code
Crystal      13          2,823     2,342
Shell        1           109       91
Markdown     1           266       210
YAML         2           46        34
─────────────────────────────────────────
Total        20          3,326     2,419
```

2,342 lines of Crystal do: a CLI with 5 presets, media analysis through ffprobe, smart conversion planning with a codec compatibility matrix, a progress bar with ETA, an interactive mode with fuzzy search, support for image sequences and GIFs, and trimming/scaling/aspect ratio with validation.

The tool already has CI/CD on GitHub Actions, compiling static binaries for Linux (x86_64 and arm64) and macOS (arm64), with installation through a one-line curl:

```bash
curl -fsSL https://raw.githubusercontent.com/akitaonrails/easy-ffmpeg/master/install.sh | sh
```

Three hours of one afternoon, from the first line of code to a release on GitHub with binaries for three platforms. FFmpeg keeps doing the heavy lifting — I just put a decent interface in front of it.

The [repository is here](https://github.com/akitaonrails/easy-ffmpeg). MIT license.
