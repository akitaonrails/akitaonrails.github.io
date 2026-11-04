---
title: "Fingerprinting: You Can't Fool the 'Algorithm' the Way You Think"
date: '2026-11-04T19:00:00-03:00'
slug: fingerprinting-you-cant-fool-the-algorithm-the-way-you-think
translationKey: fingerprinting-voce-nao-consegue-enganar-o-algoritmo-como-pensa
description: "Favoriting random videos doesn't erase your profile. Fingerprinting, telemetry, and recommendations link devices, habits, and content; thinking you fooled the feed makes you more vulnerable to misinformation."
tags:
- security
- machine-learning
draft: false
---

In the [previous article about decompiling TikTok 47.7.1](/en/2026/11/04/tiktok-technically-does-not-comply-with-brazilian-law-lgpd-felca/), I showed the scale of the collection happening inside the app. It re-sends persistent identifiers, builds a device fingerprint, measures the pressure and path of your touches, reads motion sensors, and logs more than 6,000 types of events. It also splits users by region and gives Brazil fewer technical protections than the United States and Europe.

Many people read that as a privacy issue alone, as if the concern were TikTok finding a bank password. The problem begins much earlier. These companies need to recognize **who came back**, record **what that person did**, and predict **what will hold their attention next**.

That is where the folklore starts. Someone likes and favorites a pile of dog videos to "confuse the algorithm." They install a VPN and figure they became anonymous. They clear the cache, reinstall the app, create another account, or replace the phone and believe they got a blank slate. Some people never hit Like and conclude they never handed over a preference.

All of that can change a signal. None of it erases the entire set.

> Your intention stays inside your head. The system receives your behavior.

## There Isn't Just One "Algorithm"

When someone says "the TikTok algorithm," it sounds like a magic function choosing the next video. In practice, several layers work together:

1. **Identity:** decides whether this device, installation, and account have appeared before.
2. **Telemetry:** records what happened, including watch time, pauses, replays, searches, comments, shares, touches, and scrolling.
3. **Recommendation:** estimates which videos have the best chance of producing the next interaction.
4. **Experimentation:** puts different content in the feed to measure reactions and update the profile.

The fingerprint lives mainly in the first layer. It helps preserve continuity when a cookie, installation ID, or account changes. Behavioral history feeds the others.

TikTok itself says it uses videos watched to the end or skipped, likes, shares, comments, followed accounts, sounds, hashtags, location, language, and device type. For most users, [watch time and other interactions receive more weight](https://support.tiktok.com/en/using-tiktok/exploring-videos/how-tiktok-recommends-content) than device settings.

The public description is simplified, of course. Our static analysis found the text of every search and events for `play_time`, percentage watched, pauses, replays, progress-bar scrubbing, entering and leaving screens, account switching, and thousands of other actions. The service delivering the feed inevitably knows what you requested and how long you stayed there.

## Fingerprinting: Recognition Without Relying on One Number

A fingerprint combines signals too small to identify someone in isolation. Phone model, resolution, CPU, GPU, sensor list, cameras, time zone, language, carrier, operating-system version, time since the last boot, and installation characteristics form a much more specific picture when they appear together.

Some signals are stable. Others vary. The system works with confidence levels and tolerates differences between observations.

On the same device and Android profile, the case is straightforward. The `ANDROID_ID` used by TikTok is stable for a combination of device, Android user, and application-signing key. Clearing data or reinstalling changes random IDs stored by the app, but it does not change this identifier. Model, sensors, screen, camera, network, and hardware state also remain similar.

Replacing the device changes the situation. New hardware produces a different fingerprint. Signing into the same account resolves the association deterministically. Creating another account leaves a probabilistic match: the same home network, region, language, schedule, social relationships, and a very similar consumption pattern can suggest that both identities belong to the same person without proving the relationship.

The industry calls this **cross-device tracking** or a **device graph**. Deterministic matches include the same login or email; probabilistic ones rely on a combination of signals. [Researchers had documented this distinction by 2017](https://doi.org/10.1515/popets-2017-0020). [TikTok's current US privacy policy](https://t.tiktok.com/legal/page/us/privacy-policy/en) says the company assigns device and user IDs and may use this information to identify activity across devices.

So "I replaced my phone" can mean three completely different things:

- you signed into the same account and supplied the connection;
- you created another account but left several bridges that allow a probable match;
- you created a genuinely isolated identity, without shared accounts, contacts, partners, networks, or habits, sharply reducing confidence in the match.

## A Simplified Example

The data below is fictional and only illustrates how a server compares observations. TikTok's internal format and any real scoring system remain unknown.

```yaml
conta: 84721
id_da_instalacao: "A9F2"
android_id: "7c81"
aparelho: "Pixel 10"
tela: "1080x2424@120"
sensores: "hash-31b7"
idioma_fuso: "pt-BR / America-Sao_Paulo"
rede_frequente: "200.10.x.x"
horario_de_uso: "22h-01h"
interesses_observados: [carros, tecnologia, politica]
gestos: "rolagem rapida, pressao media 0.42"
```

The code confirms collection of touch pressure, size, and trajectory as human-presence and antifraud signals. Static analysis does not show TikTok treating this as personal biometrics capable of recognizing your hand, so the field appears in the example as telemetry and stays out of the identity comparison below.

Now compare what happens:

| Signal | Before | Reinstalled on the Same Device | New Phone and New Account |
|---|---|---|---|
| Account | `84721` | may be the same | new |
| Installation ID | `A9F2` | changes | changes |
| `ANDROID_ID` | `7c81` | **stays** | changes |
| Hardware, screen, and sensors | Pixel 10 | **stay** | change |
| Language, time zone, and region | pt-BR / São Paulo | probably stay | probably stay |
| Home network | `200.10.x.x` | may stay | may stay |
| Schedule and usage pattern | 10 PM-1 AM | tends to reappear | may reappear |
| Interests and action sequence | cars, technology, politics | reappear with use | may reappear with use |

After a reinstall, too many strong signals remain to call that device a stranger. A new phone with a new account leaves a hypothesis. The more bridges you preserve, the more confidence that hypothesis gains. Sign into the old account and the doubt is gone.

The fingerprint can start without your name. At some point you sign into an account, use an email, sync contacts, open an identified link, or take some other action that connects the pseudonym to you. The earlier history can then be stitched to the known identity. A [2026 technical briefing from the Georgetown Law Institute for Technology Law & Policy](https://www.law.georgetown.edu/tech-institute/wp-content/uploads/sites/42/2026/02/Tech-Brief-Digital-Fingerprinting-February-11-26.pdf) calls this *identifier bridging*: a probabilistic fingerprint gains a bridge to a stable identifier.

## The Dog-Video Charade

Take the most common example. You want to avoid politics, fake news, and conspiracy theories. You search for dog videos, watch several through to the end, like fifty, and favorite twenty. The feed starts showing more animals. Did it work?

Partly. You taught the system that dog videos produce interaction. TikTok even provides explicit tools for doing this: "Not Interested," keyword filters, topic management, and [refreshing the For You feed](https://support.tiktok.com/en/getting-started/for-you/test-for-you).

But you did not erase politics from the profile. You added another interest. The server still has the earlier history, followed accounts, searches, watched videos, pauses, comments, shares, and signals from people whose behavior resembles yours.

There is also a huge difference between what you think you communicated and what the machine received:

- you opened an absurd video to understand what people were saying;
- watched it through because it made you angry;
- replayed a section to double-check it;
- opened the comments;
- replied that it was a lie;
- sent it to someone with "look at this garbage."

To you, those were six expressions of rejection. To a model looking at events, they were several minutes of attention and an unusual sequence of interactions. The content worked.

The same applies to your performance with animals. Events sent to the server contain no `estou_fingindo_gostar_de_cachorro` field; they contain searches, completed videos, likes, and favorites. A profile can carry several interests at once. The result may be someone who likes dogs **and** consumes politics whenever it appears, especially if the second subject triggers stronger reactions.

Independent audits confirm that the feed responds to more than one kind of signal. A [controlled-account experiment](https://arxiv.org/abs/2201.12271) found effects from following, liking, and watch time, with following as the strongest factor in that test. Another [study of interest *exploration* and *exploitation*](https://arxiv.org/abs/2403.12410) measured how duration, likes, and follows change personalization across a timeline.

> You can influence the feed. That is a long way from erasing the profile or becoming immune to manipulation.

## The Feed Keeps Testing You

A recommender cannot serve only what it already knows. It would become repetitive and never discover a new interest. So it alternates **exploitation**, content with a high chance of working, and **exploration**, bets used to learn.

That is why a political video, a miracle diet, or a conspiracy returns between the dogs. It may be popular in your region, recent, similar to something you watched, consumed by a group resembling you, or simply a test. TikTok itself acknowledges that popularity, diversity, and the behavior of similar users take part in selection.

You can spend a disciplined week ignoring everything. One tired evening, a subject that gets under your skin, or an especially effective video can produce the missing signals. Recommendations adjust again.

A 2025 audit observed [persistent content reinforcement and a gradual decline in diversity](https://arxiv.org/abs/2503.20231) across controlled timelines. The result describes a feedback mechanism without declaring that every user ends up trapped in the same kind of bubble: recommendations produce behavior, behavior feeds recommendations, and the next batch becomes more like whatever worked.

The term "echo chamber" makes it sound as though somebody locked the door from the outside. You often help build it. You choose to watch, comment, follow, and share; the system removes friction from repeating it. Before long, frequency becomes familiarity and familiarity starts looking like consensus.

## The Trap of Thinking You Won

This is the most dangerous part. Anyone who knows the feed is manipulated preserves some distrust. Anyone who believes they fooled the system drops their guard.

"I trained my algorithm to stop showing me fake news" becomes permission to treat whatever remains as trustworthy. The logic is circular: if it appeared after your cleanup, it must have passed through your filter. Except the filter optimizes the probability of interaction. It is no fact checker.

A study published in *PNAS* found a similar problem outside TikTok: [three out of four participants overestimated their ability to distinguish true news from false news](https://pubmed.ncbi.nlm.nih.gov/34074757/). On average, they placed themselves 22 percentiles above their actual performance. The most confident participants also visited more untrustworthy sites and showed greater willingness to like or share false content aligned with their politics.

A recent TikTok audit found another troubling signal: [engaging with misinformation about one subject led to recommendations for related misinformation and misinformation on other subjects](https://doi.org/10.1016/j.ijhcs.2026.103929). New accounts with no history also received more recommendations of this kind in some experiments. An empty profile does not necessarily begin in a clean, neutral environment.

Your subjective confidence is not evidence that the feed became safe. It merely reduces the chance that you will check.

## "There Is Nothing Important in There"

Another common defense is that the app has no bank password, secret document, or compromising photo. Someone evaluates each field in isolation and concludes they handed over garbage.

The value lies in the inferences and the decisions made from them. [TikTok's own policy](https://t.tiktok.com/legal/page/us/privacy-policy/en) says the company infers age, gender, and interests. Repeated behavior can suggest routine, purchasing power, religion, political position, emotional state, vulnerabilities, relationships, and major life events. Some inferences will be wrong, which also causes harm.

That power of inference was measurable well before TikTok. In 2013, a [study of more than 58,000 volunteers](https://www.pnas.org/content/pnas/110/15/5802.full.pdf) showed that Facebook Likes could predict sensitive attributes including sexual orientation, ethnicity, religion, political position, personality, age, and gender. Likes are trivial data until someone crosses thousands of them.

A platform can already affect you by choosing content and ads. Campaigns, sellers, and scammers can also exploit segmentation to reach people when they appear most receptive. It all starts from a profile you cannot see and can rarely correct.

The [FTC examined the practices of nine major platforms](https://www.ftc.gov/system/files/ftc_gov/pdf/Social-Media-6b-Report-9-11-2024.pdf), including ByteDance, and described mass collection, broad retention, and monetization through targeted advertising. The business model turns small observations into segmentation and prediction without ever finding a valuable password.

> Privacy protects more than secrets. It limits who gets to build a model of you and use it to decide what you will see next.

## The Other Tricks That Don't Do What You Think

A few more myths need cleaning up:

- **VPN:** changes the public IP and helps hide your origin from the carrier or local network. The app sees that a VPN exists and keeps receiving the account, fingerprint, and behavior.
- **Incognito mode:** keeps the browser from saving part of the local history. It changes nothing inside the native app and does not prevent remote fingerprinting.
- **Clearing cache or reinstalling:** removes disposable local state. Stable identifiers and hardware remain on the same device and profile.
- **Creating another account:** separates visible profiles. On the same device, the service can still observe that both accounts share the hardware.
- **Never hitting Like:** withholds one explicit signal. Watch time, completion, replay, search, pause, skip, and screen sequence keep talking.
- **Following varied sources:** helps and is worth doing, but even the Following feed is ranked. [TikTok says two people following the same creators can still receive a different order](https://support.tiktok.com/en/using-tiktok/exploring-videos/how-tiktok-recommends-content).

These measures can reduce exposure or change recommendations. The mistake is turning mitigation into a fantasy of invisibility.

## How to Use It Without Outsourcing Your Judgment

If you decide to remain on a social network, treat the feed as an interested selection. Every item was chosen because some model predicted a reaction. Truth, relevance, and balance are different criteria.

A few practices help:

1. Use the platform's real controls: "Not Interested," keyword filters, topic management, and feed refresh.
2. Stop rage-commenting. Block, report when appropriate, and move on. Outraged engagement remains engagement.
3. For news, open the original source outside the app. Find independent confirmation and check the date, author, and context.
4. Mix sources by your own decision. Do not expect automatic exploration to represent opposing views honestly.
5. Separate entertainment from information. A feed optimized for retention makes a lousy newsroom.
6. When privacy matters, isolate the identity. As I explained in the previous article, a separate Android profile or secondary device reduces the bridges; random spoofing usually creates more anomalies.

Take breaks too. Personalization depends on a continuous loop of recommendation and reaction. Leaving the flow gives you another chance to choose the next subject instead of accepting the model's next bet.

## Conclusion

The mechanism fits in one sentence: the platform tries to recognize you, measures your actions, and uses the result to choose the next stimulus. Fingerprinting, telemetry, and recommendation close that loop.

Favoriting dogs may put more dogs in the feed. A VPN may change your IP. Reinstalling may renew local IDs. Each measure changes one small part, and none grants immunity.

The best defense remains outside the app: distrust content that fits your beliefs too neatly, verify information through independent sources, and remember that algorithmic relevance measures the chance of a reaction. Truth requires different work.

The algorithm looks for the subject, format, and moment when you stop questioning. The conviction that you already won makes that job much easier.
