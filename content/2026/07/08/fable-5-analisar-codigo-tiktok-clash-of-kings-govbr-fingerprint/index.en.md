---
title: "I Had Fable 5 Analyze the Code of TikTok, Clash of Kings and Gov.br - Understanding Fingerprinting"
slug: "fable-5-analyze-tiktok-clash-of-kings-govbr-fingerprint"
date: '2026-07-08T16:00:00-03:00'
draft: false
translationKey: fable-5-analyze-tiktok-clash-of-kings-govbr-fingerprint
description: "A static analysis with Fable 5 compares TikTok’s opaque fingerprint, Clash of Kings’ persistent UUID, and gov.br’s privacy precautions, with caveats about the method."
tags:
- security
- software-engineering
---

Let me open with the most important disclaimer in the whole post, because it changes how you should read everything below: **none of this is 100% factual.** I asked Claude Fable 5 to do a full analysis of the code of three Android apps, but I have no way to guarantee how deep it actually went without re-auditing file by file myself, and that's hundreds of thousands of files per app. So treat this as a panorama, not a forensic report.

And there are more layers of uncertainty. The APKs came from [APKPure](https://apkpure.com/), not the official Play Store, so there's a chance (small, but real) they were tampered with along the way. And even after decompiling, there's a pile of binary libraries and SDKs we didn't crack open, assuming they're common libs like Google Firebase or Google Play Services. This mini-project was, at bottom, my own curiosity: I wanted to know what's inside these apps we install without thinking.

## Decompiling Android is way too easy

Something a lot of people don't know: an Android app is **way too easy** to decompile. The APK is basically a zip. You unpack it, run a tool like [jadx](https://github.com/skylot/jadx) on the `.dex` files, and readable Java comes out the other end. If the app is Flutter, you can reconstruct the Dart with [Blutter](https://github.com/worawit/blutter). If it's a Cocos2d-x game, the Lua scripts are often sitting right there in plaintext, no decryption needed.

This does **not** let you recompile the app from the source (class and method names come scrambled by obfuscation, resources are missing, the signing keys are missing). But for **static analysis** it's more than enough: you can read the endpoints the app contacts, the permissions it asks for, the identifiers it assembles, the SDKs it bundles. That's exactly the kind of reading I asked Fable 5 to do.

One honest limit: the most sensitive part usually lives in **native code** (`.so`), compiled C/C++, which doesn't decompile into anything readable. In TikTok's case, that's precisely where the guts are, and I'll come back to it in a bit.

## "If it's free, you're the product"

You've heard that line a thousand times. It's true, but it almost always stays abstract. Let's make it concrete: how exactly do you become the product? The answer has a technical name, and it's why I picked this angle for the title: **fingerprinting**.

A fingerprint (device fingerprint) is a persistent identifier the platform assembles by combining dozens of signals from your device: phone model, OS version, screen resolution, CPU, RAM, carrier, timezone, language, battery, installed fonts, nearby Wi-Fi and Bluetooth networks, motion sensors, and so on. None of those data points identifies you on its own. But the **combination** of them is so specific it becomes practically unique, an implicit "serial number" for your device that you never explicitly authorized.

The clever part, and the reason it's so valuable, is the **persistence**. A cookie you can clear. The advertising ID you can reset. But a well-built fingerprint survives you clearing the app's data, survives a reinstall, sometimes survives a factory reset. It re-identifies you as the same person after any attempt to start from scratch. That's why companies want it so badly: with the fingerprint, they cross-reference your behavior across apps, across sessions, across reinstalls, and build a profile that follows you even when you think you wiped your tracks. That profile is the product from the line above. And the product is you.

The three apps I analyzed sit at three very different points on that spectrum, and that's where it gets interesting.

## The three apps

### TikTok: industrial-grade collection, armored against auditing

The [tiktok_analysis](https://github.com/akitaonrails/tiktok_analysis) was the densest one. Version 46.0.1, 37 dex files, 204 native libraries. The honest conclusion, and the one I think is fairest: **it's not disguised malware, but it is industrial-grade data collection engineered to be hard to audit.**

On the reassuring side: no secret servers. Every host the app contacts belongs to TikTok/ByteDance or to a *named* ad/analytics vendor (Adjust, AppsFlyer, Facebook, Google, ThreatMetrix, Amazon). We found no IMEI or MAC collection, no `QUERY_ALL_PACKAGES`, no reading of SMS or call logs. US and EU user data goes to dedicated enclaves (the famous Project Texas, with Oracle in Ashburn).

On the worrying side: it collects **a lot**. A persistent device fingerprint, precise location, Wi-Fi and Bluetooth scanning, contacts upload (if you enable "find friends"), motion sensors, and a check against a fixed list of **91 named apps** to see which ones you have installed (competitors, PayPal, Venmo, Spotify, sister ByteDance apps). Your advertising ID fans out to about 6 third parties.

And the central finding: the fingerprint and much of the telemetry are assembled in **native code** (`libmetasec_ov.so` and a stack of crypto libs), with each request's signature going out encrypted. Meaning, even decompiling the whole app, you can't tell exactly which bytes leave the device.

To attack that black box specifically, one of the analyses ran a `strings` sweep over the 204 native libraries (the repo's [report 13](https://github.com/akitaonrails/tiktok_analysis/blob/main/docs/13-native-library-analysis.md)), and there `libmetasec_ov.so` gives the game away in plaintext. You can read the fields it collects (`secdeviceid`, `device_id`, battery level and state, screen size), the function that signs the requests, the ByteDance telemetry endpoints baked into the binary, and even the scheduler that fires the upload on a timer. What the Java layer only let you infer, the native code confirms. It's a fingerprinting machine, plain and simple.

And the same sweep went looking for exactly what everyone's afraid of finding (keylogger, screen recorder, input injection) and found none of it. The scary keyword hits were false friends: `keylog` was the TLS debug log, `screenshot` was the video player and C2PA content authenticity, `getevent` was a media method name. There's anti-debug and frida/xposed detection, yes, but that's the app inspecting itself from the inside, standard security-library behavior, not snooping on the rest of the phone.

So the opacity is still the point, just sharper: we know what `libmetasec_ov` does and where it reports to, and what stays locked are the exact payload bytes, which only native disassembly or live capture would reveal. "Not proven to be spyware" and "collects far more than it needs, opaquely" are both true at once, now with plaintext confirmation that the fingerprinting engine is real.

### Clash of Kings: the game is honest, the monetization is predatory

The [clash_of_kings_analysis](https://github.com/akitaonrails/clash_of_kings_analysis) was a pleasant surprise on the privacy front. It's a strategy game by China's Elex, a Cocos2d-x engine with almost 12,000 Lua scripts in plaintext. And check it out: **no GPS, no camera, no microphone, no contacts, no SMS, no IMEI.** The two most sensitive reads it *can* do (installed-app list and Wi-Fi MAC) are both consent-gated. No malware, no hidden exfiltration.

The privacy concern is the same villain as TikTok in a simpler version: a **reset-resistant device UUID**, written in four different places (system settings, preferences, SD card, and cloud backup) precisely to survive a reinstall. Plus telemetry to China-region infra and to Tencent Bugly.

Where Clash of Kings really weighs on you is the **monetization**. It's the complete predatory free-to-play kit: loot boxes (the hero "luck draws"), countdown-timer offers to manufacture FOMO, VIP pay-to-win tiers, cumulative-spend ladders with leaderboards for who spends the most (the whale hunt), a monthly card, the whole package. The half-full side: drop-rate odds are disclosed in-game, and the Chinese anti-addiction and real-name system for minors is present. Decent privacy, wallet in danger.

### Gov.br: the example of how to do it right (with one caveat)

The [govbr_analysis](https://github.com/akitaonrails/govbr_analysis) is the counterpoint, and it actually left me relieved. It's the official digital-identity app of the Brazilian government, built in Flutter (I reconstructed the Dart with Blutter). By the standards of a mandatory government app, it's **well-built and privacy-respectful**: traffic is almost all to `*.gov.br`, SERPRO and Dataprev, TLS is certificate-pinned, credentials sit in Android's encrypted KeyStore, the ICP-Brasil signing uses FIPS-grade crypto, and the app hardens hard against rooted or tampered devices. And most importantly: **no commercial ad trackers.** No Segment, Adjust, AppsFlyer, or Meta.

The two honest caveats: it bundles **Google Firebase** (Analytics, Crashlytics, Messaging, Remote Config) with collection on by default and the ad-id permission declared, which is the lazy default of nearly every app today; and your **proof-of-life selfie gets uploaded to the government backend** for identity matching, which is inherent to the purpose and doesn't go to third parties. The one item only live traffic capture would settle is whether your CPF gets attached to the Crashlytics reports. But overall, if every app were built with this kind of care, this post wouldn't exist.

## What almost every app carries along

Cross-referencing the three (and this is where the pattern shows up), you can see what tends to come bundled in the app you download, even in a government app:

- **Google Firebase / Play Services**: present in all three. Analytics, Crashlytics (error reporting), Cloud Messaging (push), Remote Config. It's so ubiquitous it became invisible infrastructure. And it ships with collection on by default.
- **Ad attribution stack**: Adjust, AppsFlyer, Branch.io, Singular, Facebook SDK. The job is to link "you clicked this ad" to "you installed and used the app." TikTok had a redundant pileup: five of these at once, each collecting your ad-id independently.
- **Ad networks**: Google's AdMob/DoubleClick, and in the games' case the ad-mediation ecosystem.
- **Region-specific analytics/crash**: Tencent Bugly in Clash of Kings is the example, telemetry going to Chinese infra.
- **A specialized fingerprint/anti-fraud service**: the most striking case was [LexisNexis's ThreatMetrix](https://risk.lexisnexis.com/products/threatmetrix) in TikTok: a company whose business literally *is* building device fingerprints for fraud detection. Legit for anti-fraud use, but it's literally a fingerprint-as-a-service machine, embedded.

The takeaway is that "product" isn't assembled by a single company. It's five, six, seven partners, each grabbing a piece, and the fingerprint stitching it all back into one profile. Nobody's spying on you alone. It's a group effort.

## What you can do

You won't zero this out short of leaving the internet, but you can cut the exposed surface down a lot:

- **Don't consent to what isn't needed.** GPS is the big one. A video app doesn't need your precise location to work. Deny it, or grant only "while using the app." Same goes for contacts, microphone, and camera: only allow them when the feature you want to use right now requires it.
- **Reset your advertising ID now and then** (and on Android, you can choose to "delete advertising ID" outright). It doesn't kill the fingerprint, but it breaks part of the trail.
- **Be suspicious of "find friends."** That's the contacts-upload trigger. You hand over the entire social network of people who trusted you with their number.
- **Prefer the web version when you can.** A browser with a tracker blocker exposes less fingerprint than the native app, which has access to sensors and signals the browser doesn't give up.
- **Accept the trade-off consciously.** The point isn't to go paranoid and uninstall everything. It's to know the price. If you find TikTok fun enough to pay for it with your fingerprint, great, that's an informed decision. The problem is paying without knowing you're paying.

## The point of the post

None of this proves or disproves that a specific app is 100% safe. Static analysis shows what the app is **capable** of doing, what's built inside it; only live traffic capture, with a rooted device and a MITM proxy, would show what actually leaves over the network on each request. I didn't go that far. This is a glimpse, not a verdict.

And that's exactly the point. Today, with a good LLM and a free afternoon, any curious developer can crack open their own phone and see what's running inside it, without depending on some tech influencer's opinion or an alarmist headline. The three full analyses are on GitHub ([TikTok](https://github.com/akitaonrails/tiktok_analysis), [Clash of Kings](https://github.com/akitaonrails/clash_of_kings_analysis), [gov.br](https://github.com/akitaonrails/govbr_analysis)) with step-by-step instructions to reproduce. Grab an app you use every day and do the same. It's the closest thing to reading the label before you eat that we have in the software world.
