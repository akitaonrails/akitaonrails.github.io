---
title: "Manga Plus (Shueisha) on the Desktop: Frank Manga+"
slug: "manga-plus-shueisha-on-the-desktop-frank-manga-plus"
date: '2026-05-30T09:00:00-03:00'
draft: false
translationKey: manga-plus-shueisha-desktop-frank-manga-plus
tags:
  - rust
  - tauri
  - manga
  - desktop
  - opensource
  - shueisha
---

![Frank Manga+ logo: the name stylized in red and white over a black background.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/05/30/manga-plus/logo.png)

I'm a subscriber to the **MANGA Plus by Shueisha** app on Android's Google Play Store. For those who don't know, this is Shueisha's official channel (the Japanese publisher behind Shonen Jump) for reading their manga legally, with chapters releasing weekly nearly the same day they're published in Japan. Two dollars a month gets you the entire catalog with an official English translation.

I own a Samsung ZFold 7, one of the few phones that's actually good for reading manga and Kindle (I talked about this and about [Frank Yomik](/en/2026/05/14/wrapping-up-my-ai-marathon-success-or-failure/) in the AI marathon final ranking). The Fold opened gives you a bigger screen than a normal phone, which helps a lot. But there are days when my eyes are already tired of tiny screens, and what I really wanted was to read on a 32-inch OLED monitor that sits right in front of me, perfect for long sessions.

The problem is that **MANGA Plus has no official website for reading**. The subscription is locked to Android. There's an iOS version too, but no web. A tablet helps, but nothing beats the comfort of a big, static screen when you want to read a whole One Piece arc in one go.

For context, I caught up on a lot recently: I finally finished Chainsaw Man, Dan Da Dan, Jujutsu Kaisen, Kagurabachi, Akane-banashi, Sakamoto Days and, of course, One Piece. There's a lot more I want to follow, and the comfort of the big monitor became a real problem worth solving.

## Decompiling the app

I decided to dig in. I sat down with Claude Code and we downloaded the official MANGA Plus xapk. We decompiled it to Java source with [jadx](https://github.com/skylot/jadx) and navigated around until we understood how the app authenticates with Shueisha's API.

The conclusion is straightforward: the user's "subscription," from the app's point of view, is a 32-character hexadecimal **deviceSecret** stored in a plain XML file inside Android's shared preferences. The app generates this secret once when you log in, and from then on every API call (`jumpg-api.tokyo-cdn.com`) is signed with it. No elaborate DRM, no rotating token, none of that. A single static secret per device.

The catch is that **extracting that secret from the app is a hassle**, because by default you don't have access to `/data/data/jp.co.shueisha.mangaplus/shared_prefs/config.xml` on a non-rooted Android. Three paths exist:

1. **Rooted phone**: run `adb shell su -c "cat /data/data/jp.co.shueisha.mangaplus/shared_prefs/config.xml"` and look for `<string name="secret">...</string>`.
2. **Rooted emulator**: install Android Studio, create an AVD with Google Play x86_64, apply [rootAVD](https://gitlab.com/newbit/rootAVD) for Magisk root, log into the Google account that holds your subscription, install MANGA Plus from the Play Store, then run the same `adb shell` above.
3. **Network capture with mitmproxy** (more advanced): run the rooted emulator, inject the mitmproxy CA via Conscrypt APEX, and intercept the secret on the app's first authenticated call.

All three paths are documented in detail in the repo's [docs/install.md](https://github.com/akitaonrails/frank_mangaplus/blob/main/docs/install.md) and [docs/debugging.md](https://github.com/akitaonrails/frank_mangaplus/blob/main/docs/debugging.md). I won't repeat them step by step here because it's more about tooling than technique, and anyone willing to put in the work will want to read the original. The important thing is that it **works**, and you only have to do it **once**: once extracted, the secret keeps the desktop app working for as long as your subscription lasts.

Yes, it's annoying. But it's the price for having a single configuration point that unlocks the rest.

## The desktop app

With the secret in hand, the rest was easy. I built **Frank Manga+**, a native app in **Rust + Tauri**, with a SvelteKit WebView on the frontend and a Rust client using `reqwest` on the backend talking directly to Shueisha's API. To load chapter images without leaking URLs or fighting CORS, I created a custom `mpimg://` scheme intercepted by Tauri, which downloads, decrypts (the API serves pages with a simple XOR), and hands the result back to the WebView.

The app opens on a library view with search:

![Frank Manga+ open on the Library/Search tab showing a grid of manga covers: One Piece, Sakamoto Days, Kagurabachi, Jujutsu Kaisen, Akane-banashi, Chainsaw Man, Dan Da Dan, among others.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/05/30/manga-plus/library.png)

Clicking a title takes you to a detail page with the full chapter list and a "Continue" button that picks up from the last chapter you read:

![Kagurabachi detail page in Frank Manga+: large cover on the left, synopsis, and a virtualized list of numbered chapters on the right with a Continue button at the top.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/05/30/manga-plus/title-detail.png)

And the reader itself has snap-per-page, keyboard navigation, click on the bottom to advance, and prefetch of the next chapter while you read the current one. For huge series like One Piece (1100+ chapters), the list is virtualized, so it opens instantly:

![Frank Manga+ reader showing page 12 of 19 of a Kagurabachi chapter: dramatic black-and-white scene of Chihiro wielding his sword, with a page indicator at the top and a progress bar at the bottom.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/05/30/manga-plus/reader.png)

Reading state (last chapter, current page) lives in the WebView's `localStorage`. Image cache at `~/.cache/mangaplus-reader/`. The extracted `deviceSecret` lives in `~/.config/mangaplus-reader/secret` (Linux/macOS) or `%APPDATA%\mangaplus-reader\secret` (Windows). You can override it with the `MANGAPLUS_SECRET` environment variable if you prefer.

## Install

There's a build ready for all the main platforms:

- **Linux**: AppImage, `.deb`, `.rpm`, or via AUR (`yay -S mangaplus-reader-bin`).
- **macOS**: separate `.dmg` for Apple Silicon (aarch64) and Intel (x64).
- **Windows**: `.exe` installer. It's not signed, so Windows SmartScreen will complain, click "More info → Run anyway".

All artifacts come out on the [GitHub Releases](https://github.com/akitaonrails/frank_mangaplus/releases).

## Status and contributions

This is **beta**. It works fine for my use (I read several series a week with no headaches), but it's missing features: reverse pagination for traditional Japanese manga, genre filters in search, real offline mode (today it only caches what you've already read), and a smoother secret-extraction path for less technical users.

If you subscribe to MANGA Plus and want to test it, send an issue or PR. The code is Rust + Svelte, MIT, contributions welcome: [github.com/akitaonrails/frank_mangaplus](https://github.com/akitaonrails/frank_mangaplus).

Now I finally read One Piece on the big monitor, without having to hold a phone or twist my neck. The work paid off.

## Bonus: Frank Yomik now on the desktop too via extension

Anyone who read the [AI marathon recap](/en/2026/05/14/wrapping-up-my-ai-marathon-success-or-failure/) remembers [Frank Yomik](https://github.com/akitaonrails/FrankYomik), my self-hosted project that takes a manga or webtoon page, detects the bubbles with RT-DETR-v2, runs OCR, sends it to a local Ollama (`qwen3:14b`) for translation, and returns the page with the translated text in place. Originally it had only a Flutter client for Android and Linux, which opened Kindle Japan and Naver Webtoon inside a WebView.

The thing is, running a Flutter app inside a WebView on the desktop just to read Kindle is using a sledgehammer to crack a nut. On the desktop you already have Chromium open. What was missing was a browser extension.

Over the past few weeks I added exactly that. A Manifest V3 extension for Chromium/Brave/Edge, talking to the same self-hosted Yomik server. It runs on [read.amazon.co.jp](https://read.amazon.co.jp), [read.kindle.co.jp](https://read.kindle.co.jp), [comic.naver.com](https://comic.naver.com), and Naver's mobile version. The page stays visually identical to the original, with no injected buttons or HUD in the reader's face. All configuration lives in the popup:

![Frank Yomik popup open over a Kindle Japan page showing Initial D in Japanese: fields for API base URL, auth token, checkboxes for Kindle reader and Naver Webtoon, manga pipeline dropdown set to Furigana, target language English, and a webtoon prefetch block.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/05/30/manga-plus/yomik-extension-popup.png)

The content script grabs the current page image and sends it to the server. The bearer token sits in the service worker, so it never leaks to the page's JS. When the translation comes back, the image gets swapped in place of the original. There's a local cache to avoid re-translating pages you've already seen, a "force reprocess" button for when you need to file a bug report, and autosave for the config. Details in the [extension README](https://github.com/akitaonrails/FrankYomik/tree/main/extension), and the Load Unpacked zip ships with the repo's Releases.

In practice, the 32" monitor is now my reading desk. Frank Manga+ opens Shueisha's official catalog in English (One Piece, Chainsaw Man, and whatever else Shonen Jump publishes). When I feel like reading something Japanese that doesn't have an official translation, I open Kindle Japan in another tab and Yomik renders furigana or an LLM translation on top of the page. For Korean Naver webtoons, same story, same extension.

The nice part is that the two projects solve different problems and complement each other. Frank Manga+ exists because Shueisha has no website. Yomik exists because the rest of the manga I read doesn't have a decent official translation in any reasonable timeframe. For a manga addict like me, it's the setup I'd been wanting for years.
