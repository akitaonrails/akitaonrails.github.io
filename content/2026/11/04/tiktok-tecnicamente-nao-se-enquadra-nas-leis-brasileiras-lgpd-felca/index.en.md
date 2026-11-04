---
title: "TikTok Technically Doesn't Comply with Brazilian Law (LGPD/Felca). Here's Why"
slug: "tiktok-technically-does-not-comply-with-brazilian-law-lgpd-felca"
date: '2026-11-04T16:00:00-03:00'
draft: false
translationKey: tiktok-tecnicamente-nao-se-enquadra-nas-leis-brasileiras-lgpd-felca
description: "I analyzed TikTok version 47.7.1 with REA: the app doesn't spy on the rest of your phone, but it builds a persistent, encrypted fingerprint of the device, re-sends your identifiers, measures how you touch and hold the phone, and logs everything you do inside it. I explain why DNS blocking or modifying the app doesn't solve it, why the only way out today is isolating TikTok on a secondary phone or a separate profile, how the app gives the US and Europe a treatment Brazil doesn't get, and where it clashes with Brazil's LGPD and the Lei Felca, with the ANPD having already fined ByteDance."
tags:
- security
- law-and-regulation
---

In July I [had Fable 5 analyze TikTok's code](/en/2026/07/08/fable-5-analyze-tiktok-clash-of-kings-govbr-fingerprint/), along with Clash of Kings and the gov.br app. It was a decompilation of version 46 of the Android app, done with jadx, a strings sweep over the native libraries and a lot of code reading, well before [REA](/en/2026/10/13/ai-reverse-engineering-is-adobe-dead/) existed. The conclusion back then: TikTok isn't disguised malware, but it does industrial-grade data collection, designed to be hard to audit.

Now that I have REA, I decided to go deeper. I took version 47.7.1, the latest, and this time I also opened the native code of the network stack in Ghidra. It's all in the [tiktok_analysis](https://github.com/akitaonrails/tiktok_analysis) repository, with the new reports 14 through 17 and line-by-line evidence.

This article is for two people at once: the regular user, who wants to know what the app does with them, and the software engineer, who wants to know whether it can be blocked. And at the end there's the part that matters to every Brazilian.

TikTok doesn't treat everyone the same. The app sorts users by region, and the United States, Europe and South Korea get their own treatment. The rest of the world falls into a single bucket, and Brazil is in it, [in the least protected group](#brazilians-are-the-least-protected-users). That's why, as it stands, TikTok clashes with Brazil's LGPD and with the Lei Felca.

> Everything here comes from **static analysis**: I read the app's code, I didn't capture traffic from a running phone. That proves what the app was built to do and where it was built to send things. It doesn't prove byte by byte what goes out in each request, because the most sensitive part is encrypted in native code.

### How it was done, and how to reproduce it

On version 46, the work was jadx turning the app into readable Java and the LLM reading the code. The native code, the `.so` libraries in C and C++, only got a strings sweep.

On 47, an agent ran everything by itself:

- **jadx** decompiled the app's 58 Java code parts, about 365,000 classes;
- **REA** opened the native libraries in Ghidra and decompiled specific functions, like the built-in DNS resolver inside `libsscronet.so`;
- **parallel subagents** swept the whole tree, one per topic (identifiers, fingerprint, servers), returning the file and line of each piece of evidence.

If you want to redo it, or apply the same method to another app, [report 11](https://github.com/akitaonrails/tiktok_analysis/blob/main/docs/11-diy-reproduce-guide.md#step-8--the-agent--rea-workflow-2026-update-what-reports-1417-used) has the step by step, with ready-made prompts for the main agent and the subagents and the exact sequence of REA tools.

## What TikTok collects, in plain language

First the good news, because it matters and a lot of people get it wrong. TikTok does **not** spy on the rest of your phone:

- it doesn't read your SMS, your call history, your notifications, or what you type in other apps;
- it has no accessibility service, which is how malicious apps read other apps' screens;
- it doesn't list all installed apps;
- it doesn't take the IMEI, phone number or MAC address.

The Android sandbox prevents it, and the app doesn't ask for the permissions that would get around that. [Report 10](https://github.com/akitaonrails/tiktok_analysis/blob/main/docs/10-os-and-clipboard-access.md) checked this across the whole tree, including the clipboard, which is only read when you paste something. The only new Android permission in version 47 is for detecting when someone is recording the screen *of TikTok itself*.

The bad news is what it collects **without asking for anything**, because Android requires no permission for it. [Report 14](https://github.com/akitaonrails/tiktok_analysis/blob/main/docs/14-v47-data-inventory-and-dns-blocking.md) has the full inventory. In short:

- **who your device is**: several persistent identifiers, including the `ANDROID_ID`, which survives clearing data and reinstalling the app. And every time you open or return to the app, at most once an hour, it re-sends the main identifiers, encrypted, to a dedicated endpoint;
- **what your device is**: model, CPU, GPU, memory, the list of sensors, the full spec of each camera (without asking for camera permission), the installed keyboards and the active accessibility services;
- **a Google-signed proof of your device**: the app asks the phone's security chip for a hardware attestation, which confirms the model, the bootloader state and the patch level. That can't be faked;
- **how you hold and touch the phone**: touch pressure and size on every screen, and samples from six motion sensors (details below);
- **where you are, without asking for location**: carrier, SIM country, time zone, language, your Wi-Fi's DNS servers, and whether you're using a VPN or proxy;
- **everything you do inside the app**: more than 6,000 [different event types](https://github.com/akitaonrails/tiktok_analysis/blob/main/docs/_evidence/v47/applog_event_names.txt), including how long you watch each video, what you search, what you like, whose profiles you visit.

### Things you'd never imagine are measured

The list above is already long, but the detail is more striking. The app's risk probe alone has about 90 fields, and the native security engine has its own list on top. Some of the variables the code reads, all without asking permission:

- **every touch on the screen**: the pressure, the size of the contact area, the type of "tool" (finger, stylus), the input device, and the full path of your finger, point by point, with the time of each point. That describes every scroll and every swipe, and it's recorded on every screen of the app. The keys you type are left out;
- **how the phone moves in your hand**: accelerometer, gyroscope, magnetometer, gravity, linear acceleration and rotation, plus the device orientation computed from them. The app uses this to know whether a human is holding the phone. But these are exactly the signals that would tell whether you're walking, sitting, lying down or inside a car;
- **the gyroscope "jitter" and the light sensor variation**, meaning how much your hand shakes and how much the light around you changes;
- **the battery**: level, whether it's charging, and a history of roughly the last 20 readings;
- **media volume, airplane mode and SIM state**;
- **whether the microphone and camera have permission**, even when you're not using them;
- **when the phone was last turned on** and how long it's been on, which lets sessions be joined even after reinstalling the app;
- **which keyboards and which accessibility services are installed**;
- **disk space, memory, screen refresh rate, GPU model**, creating a graphics context just to ask;
- **whether you're on a call** or have the microphone active in another app, whether developer mode is on, whether a USB cable is connected.

And inside the app, besides what you watch, it logs how long you stay on each video, when you pause, replay or drag the progress bar, and the text of every search.

> None of this data looks serious on its own. Together, it describes your device, your hand and your habits with a precision no sign-up form would ever ask for.

## What fingerprinting is, and why it's dangerous

Almost everything on the list above serves to build something called a **fingerprint**, the device's fingerprint.

The idea is simple. No single piece of data identifies you: millions of people have the same phone model, the same time zone, the same carrier. But the **combination** of dozens of these signals is so specific that it becomes practically unique. It's a serial number you never authorized and don't even know exists.

What makes it valuable, and dangerous, is **persistence**:

- a cookie you can delete;
- the advertising ID you can reset;
- the fingerprint survives clearing data and reinstalling the app. Only a factory reset changes the `ANDROID_ID`, and even then the model, the sensors and the attestation keep describing the same device.

The server can also re-issue the same device identifier when it recognizes the other signals. On the same device and the same profile, starting from scratch is very hard.

### Why this is nefarious

The problem isn't just ads. An identifier that doesn't die allows:

- **putting everything together**: what you watch, search and like becomes a profile tied to the *device*, which survives even if you delete the account;
- **crossing between apps**: TikTok has a specific endpoint to link your device's identifiers across ByteDance apps, like CapCut and Lemon8;
- **re-identifying you**: if you delete your account and create another on the same phone, the platform can tell it's the same device, because the `ANDROID_ID` is the same;
- **inferring what you didn't tell**: what you watch and for how long can reveal interests, emotional state, orientation, religion, politics. And you have no way to see or correct that profile.

And there's the aggravating factor that already showed up in the July analysis: the fingerprint is built and **encrypted in native code**, inside the `libmetasec_ov.so` library ([report 13](https://github.com/akitaonrails/tiktok_analysis/blob/main/docs/13-native-library-analysis.md) shows what can be read from it). Not even decompiling the whole app tells you exactly what goes into it. In version 47, this library's strings seem even more encrypted than in 46.

> You can't audit it, you can't delete it, and on the same device it's very hard to start over. That's the central point.

## Can it be blocked? The part for engineers

My first idea was the obvious one: block the telemetry servers in my DNS, NextDNS, or modify the app to strip the collection. I asked the agent to study both options in depth. Neither one solves it.

### Why DNS blocking doesn't work

DNS blocking (NextDNS, Pi-hole, AdGuard) works like this: the app asks "what's the IP of `log.tiktokv.com`?" and your DNS answers "none". But TikTok was built not to depend on your DNS:

- **it has its own DNS resolver**, on by default, and reaches it by **raw IP** (`34.102.215.99` outside the US). When the app uses that resolver, your DNS doesn't see the query, and the server decides when to use it;
- **the main API servers are pinned to IPs** owned by ByteDance itself, hardcoded;
- **the server can rewrite routes at any time**: on launch, the app downloads a rule list that can send any address elsewhere, or pin any name to an IP;
- **backup resolver IPs are saved on the phone**, so an IP learned once survives any blocking you do later;
- **the stats for each video you watch travel on the same server as the feed**. A built-in rule forces it. If you block it, the feed stops too.

You can reduce a lot. [Report 14](https://github.com/akitaonrails/tiktok_analysis/blob/main/docs/14-v47-data-inventory-and-dns-blocking.md#4-where-it-goes-and-the-blocklist) has a tiered blocklist and router firewall rules that close off the built-in resolver. That cuts third-party trackers, log and crash uploads, the hourly identifier re-report and much of the event stream. But it doesn't hide from TikTok what you watch, and the server can change the routes in the next update.

### Why modifying the app doesn't work either

The second idea was repackaging: decompile, turn the collectors into dead code, re-sign and install. [Report 15](https://github.com/akitaonrails/tiktok_analysis/blob/main/docs/15-repackaging-feasibility-and-patch-plan.md) studied this, and it hits three walls:

1. **the fingerprint is the request signer.** The same native library that builds the fingerprint signs every API call. Remove one and you lose the other, and the server rejects the unsigned request. The feed stops;
2. **your signature goes into the device signature.** The native code reads the certificate the app was signed with. Re-signing with your own key changes it, and the server knows you run a modified client. It can respond with a captcha, phone verification or a limited account, whenever it wants;
3. **the configuration comes from the server.** Routes, DNS rules and event lists are downloaded at runtime, so a static patch only changes the defaults.

You can strip the "luxury" telemetry at the source: the identifier re-report, AppsFlyer, Firebase Analytics, crash uploads. But not the fingerprint or your behavior, and you get on a treadmill of redoing the patch with every TikTok update.

### Faking doesn't work either

And faking the data makes it worse.

The app checks for root, Magisk, Xposed, Frida, emulators, fake location, an unlocked bootloader and developer mode. The Google-signed hardware attestation exposes any faked model. The touch and motion sensors exist precisely to detect synthetic values. [Report 8](https://github.com/akitaonrails/tiktok_analysis/blob/main/docs/08-mitigation-options.md) explains why every faking attempt backfires. Faking puts you in the "tampered device" bucket, and the fingerprint goes out anyway.

## The only way out today: isolate

If you can't hide your behavior from whoever serves you the feed, the goal changes: make that behavior tied to a **throwaway identity** that doesn't lead back to you. Isolate, without faking anything. There are two ways:

### A secondary phone

A cheap phone, or a tablet, just for TikTok:

- **no SIM**, or Wi-Fi only: the carrier and SIM-country fields go empty, which is normal on a tablet;
- **no login**, or with an email you don't use anywhere else. No signing in with Google, Facebook or a phone number;
- **no permissions**: deny location, contacts, photos, microphone and camera;
- **advertising ID deleted**, under Settings → Privacy → Ads;
- on the network, the blocklist and router rules from [report 14](https://github.com/akitaonrails/tiktok_analysis/blob/main/docs/14-v47-data-inventory-and-dns-blocking.md#5-the-fake-substitute-plan).

**Pros:** it's the most complete separation. Everything the fingerprint describes is *that* device, and nothing is faked, so nothing contradicts the attestation. CapCut and the other ByteDance apps stay away from your real life.

**Cons:** it costs a device, it's one more piece of equipment to charge and update, and it's less practical. And what you watch is still logged, just tied to an identity that isn't yours.

### A separate profile on the same phone

Android allows an isolated space: **Private Space** on Android 15 or newer, or a work profile with apps like Shelter or Island. TikTok goes in there, with the same no-login, no-permissions rules.

**Pros:** zero cost. Each profile has its own `ANDROID_ID`, the app can't see your contacts, photos and other apps, and nothing is faked.

**Cons:** the hardware is the same. The hardware fingerprint, the attestation and your phone's SIM stay the same, so anyone who wants to cross-reference can link the profile to the device. It isolates software identifiers well, but the device is still the same.

> There's no setting that makes TikTok stop knowing what you watch. What exists is making sure that "you" is a throwaway identity.

## Brazilians are the least protected users

Here it gets worse for us. [Report 16](https://github.com/akitaonrails/tiktok_analysis/blob/main/docs/16-regional-data-treatment.md) shows the app sorts every user into five compliance regions:

- **US**: United States;
- **EU**: Europe, specifically the European Economic Area;
- **KR**: South Korea, because of its data protection law;
- **ROW**: "rest of world". **Brazil lands here**;
- **UNKNOWN**: not yet determined.

What changes between them:

| | US | Europe (EEA) | Brazil |
| --- | --- | --- | --- |
| Dedicated data infrastructure | Yes (Project Texas, with Oracle; since January 2026, a US joint venture) | Yes (Project Clover, Norway and Ireland) | No, it goes to ByteDance's global infrastructure |
| Fingerprint engine mode | 503, the compliance mode | 503, the compliance mode | 603, the default mode |
| Specific regulatory treatment | Yes (required by the US government) | Yes (GDPR) | None. Zero occurrences of "LGPD" in the code |

What each mode collects exactly sits inside encrypted native code, so the difference can't be measured byte by byte. But the structure is clear: the path with a regulatory brake was written for the US and Europe, and Brazil falls into the default. Korea at least got its own bucket in the code; Brazil, with a GDPR-inspired law, didn't even get that.

And switching your Google store region to Europe doesn't help. The bucket comes from the TikTok account region, which the server sets, and forcing mismatches tends to become a fraud signal.

## LGPD and Lei Felca: why TikTok needs to comply

[Report 17](https://github.com/akitaonrails/tiktok_analysis/blob/main/docs/17-brazilian-law-compliance.md) maps these findings onto the law. A caveat applies: the ANPD (Brazil's data protection authority) and the courts decide whether there's been an infringement, also looking at the privacy policy, the consent screens and what happens on the server. The app analysis shows where it **clashes** with the law.

### LGPD

Brazil's [General Data Protection Law](https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/l13709.htm) has principles the app struggles to meet:

- **necessity** (art. 6): collect only what's needed for the purpose. Re-sending the main identifiers every hour, a probe of about 90 fields about root and hardware, touch and motion sensors, all of that goes far beyond what watching short videos requires;
- **transparency** (arts. 6 and 9): the data subject has the right to know what's collected. With the fingerprint encrypted in native code, the user has no way to know, and not even decompiling the app shows it;
- **data subject rights** (art. 18, IV and VI): deletion of unnecessary or excessive data, and of data processed with consent. An identifier that survives clearing and reinstalling, and that the server can re-issue on recognizing the device, empties that right in practice;
- **international transfer** (art. 33): with no dedicated infrastructure for Brazil, the data goes to ByteDance's global infrastructure;
- **children's data** (art. 14): the app has a Kids Mode that blanks identifiers and zeroes the advertising ID, but it only applies if the app knows the user is a child. The default path profiles everyone.

That last point isn't theory. The ANPD [opened a proceeding against TikTok](https://teletime.com.br/04/11/2024/anpd-tiktok-falha-no-tratamento-de-dados-de-criancas-e-adolescentes/) in November 2024 for processing children's and teenagers' data without age verification, and [ordered it to disable feed access without registration](https://canaltech.com.br/redes-sociais/tiktok-tera-que-desativar-acesso-ao-feed-sem-cadastro-no-brasil-determina-anpd/) in Brazil.

In August 2026 the bill came: the ANPD [fined ByteDance R$ 153.7 million](https://www.poder360.com.br/poder-tech/anpd-multa-dona-do-tiktok-em-r-1537-milhoes/) for processing children's and teenagers' data, saying the company "accepted the risk of carrying out massive processing of children's and teenagers' personal data". The feed without registration [still exists](https://teletime.com.br/25/08/2026/tiktok-muda-feed-multa-anpd/), but within a compliance plan, with no ads and limited collection.

### Lei Felca (ECA Digital)

[Law 15.211/2025](https://www.planalto.gov.br/ccivil_03/_ato2023-2026/2025/lei/l15211.htm), the Digital ECA (Brazil's child and adolescent statute for the internet), got the nickname Lei Felca because of influencer Felca's videos about the sexualization of children online, which pushed the bill forward in 2025. It's been in force since March 2026 and requires platforms, among other things, to provide:

- reliable age verification, not just self-declaration;
- accounts of under-16s linked to a guardian;
- a ban on targeted advertising using children's data;
- protection by design.

Most of this happens on the server, so the app analysis proves neither compliance nor infringement. What it shows: the tool to protect children's data exists in the code (Kids Mode), but it depends entirely on the app knowing who is a minor. And that's exactly where the ANPD already pointed out a failure.

### Comply or leave

Putting it all together:

- the app has regulatory treatment for the US and Europe, and nothing designed for Brazil (the only minimization that applies here is Kids Mode, which is the same everywhere);
- Brazilians' data has no dedicated infrastructure;
- the fingerprint is neither auditable nor deletable;
- the protection of minors depends on age verification the regulator has already found weak.

ByteDance knows how to do it differently: it did for Americans and Europeans, because there it was forced to. In the US, that obligation went so far that the American operation became a separate joint venture. Brazil has a data protection law in the same spirit as the GDPR and now a law specifically for children.

> TikTok needs to treat Brazilian users the way it treats Europeans: with dedicated infrastructure, real minimization and age verification that works. If it doesn't, it shouldn't be allowed to operate here.

Until that happens, protection is in your hands. If you're going to use it, use it on an isolated device or profile, without logging in and without permissions. And if there's a kid at home with TikTok on their phone, now you know what's being collected.
