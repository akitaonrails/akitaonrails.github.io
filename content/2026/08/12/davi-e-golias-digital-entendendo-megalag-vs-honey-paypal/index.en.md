---
title: "Digital David and Goliath: Understanding MegaLag vs Honey/PayPal"
slug: digital-david-and-goliath-understanding-megalag-vs-honey-paypal
date: '2026-08-12T11:00:00-03:00'
draft: false
translationKey: davi-e-golias-digital-entendendo-megalag-vs-honey-paypal
description: "Honey spent years skimming creators' commissions with a defeat device written in plain JSON. I walk through the ssd.json line by line, the PayPal-era rewrite, and the class action PayPal failed to kill."
tags:
- security
- tech-market
---

Anyone who makes content for a living knows: affiliate commission pays real bills. You test a product, record the review, drop the link in the description. Someone watches, clicks, buys days later, and a slice of the sale lands in your account. That's how a good chunk of independent YouTube funded itself over the last decade.

Now imagine finding out that one of your sponsors was planted at your viewers' checkout, swapping your tag for theirs and pocketing those commissions. Millions of times. For years.

That's what MegaLag showed in December 2024, exposing the practices of Honey, the coupon extension PayPal bought for $4 billion that promised to *"find every coupon code on the internet"* for you. I've followed his channel since that video and became an instant fan: this is technical journalism with live demos, code, and packet captures, not just loud accusations.

A year and a half later, the story has only gotten thicker: PayPal tried to dismiss it all as fake news, MegaLag came back with irrefutable technical evidence, Rakuten and other affiliate networks publicly cut Honey off, and the whole thing became a class action that just survived a motion to dismiss.

{{< youtube id="vc4yL3YTwWk" >}}

The video timeline, since these are the primary sources for this article:

1. [Exposing the Honey Influencer Scam](https://www.youtube.com/watch?v=vc4yL3YTwWk), December 21, 2024
2. [Exposing Honey's Evil Business Model (PART 2)](https://www.youtube.com/watch?v=wwB3FmbcC88), December 22, 2025
3. [The Honey Scam is Worse Than I Thought](https://www.youtube.com/watch?v=qCGT_CKGgFE), December 30, 2025
4. [Honey Gets Terminated as Lawsuits Proceed](https://www.youtube.com/watch?v=EXDemfGNGz0), August 11, 2026 (yesterday)

I'm telling this story in three acts: the last-click trick against creators, the extortion model against stores, and the defeat device that fooled the networks' auditors. The technical core, the part that matters to us developers, is in the third act. But without the first two it makes no sense.

## What Honey was supposed to be

The consumer pitch was irresistible: a free extension that, right at checkout, tries every known coupon code and applies the best one to your cart. *"It's literally free money."* And no, they swore, they didn't sell your data.

For content creators, Honey was a generous sponsor. MegaLag mapped roughly 5,000 sponsored videos across more than 1,000 channels, adding up to nearly 8 billion views. MrBeast was the first big name, and former Honey president Joanne Bradford bragged: *"every kid in America knows what Honey is."*

Creators got easy money for recommending a tool that seemed useful. The irony, which the first video exposes in exquisite detail: those same creators were installing on their audiences, the audiences most likely to click their affiliate links, the tool that was stealing those very commissions.

For stores and marketplaces, Honey sold itself as a conversion tool: less cart abandonment, higher average order value. And there was an extra, shadier pitch, right in the partner FAQ and on Honey's own podcast: the store controlled which coupons went live. So the consumer story was *"we find every code,"* while the merchant story was *"you keep consumers from finding your good codes."* Both stories were official.

## Affiliate marketing in 30 seconds

To understand the crime, you need to understand the victim. Affiliate marketing works like this: a creator posts a link with a tracking tag (like `?tag=shortcircuit` on a Newegg link). You click, the store drops a cookie good for about 30 days, and if you buy anything in that window, the commission goes to whoever generated that click.

MegaLag has a good analogy for this: it's like the department-store salesman who helps you, hands you a referral card with his name on it, and the cashier knows whose sale it was. The affiliate cookie is the digital version of that card.

The industry standard is **last-click attribution**: the last click takes everything. Not the fairest system in the world, but the simplest to implement. And here's where the trouble lives: whoever shows up in the final second before payment always wins. And who shows up in the final second? A browser extension that wakes up exactly on the checkout screen. It's as if a second salesman, one who never helped you at all, snatched the card from your hand in the checkout line and handed over his own instead.

## What Honey actually did

The first video documents the scenarios, all variations on the same trick:

- **The coupon popup**: you click "apply discounts," Honey opens a tiny hidden tab that simulates an affiliate click with PayPal's tag, then closes itself. Your creator's cookie gets overwritten. Commission stolen, even when Honey finds no coupon at all.
- **Honey Gold**: when there's no coupon, up pops an offer for cashback points. Click it, same thing: last click, PayPal's commission.
- **The empty popup**: no coupon, no cashback, Honey still pops up so you'll click "got it." Clicked to dismiss? Too late, the click counted.
- **The PayPal button**: at a checkout that already offers PayPal, Honey shows a "check out with PayPal" button. Any excuse works to grab that last click.

MegaLag's NordVPN experiment makes it concrete: a 40% commission program. Two purchases made through his own affiliate link. Without Honey: $35 in commission. With Honey Gold activated: $0. His cut, as the "consumer," of the loot stolen from himself? 89 points, or **89 cents**. Honey kept 97.5% of what was rightfully his.

> **Remember this:** even when you click the creator's affiliate link, the commission goes to PayPal if Honey shows up at checkout. In the NordVPN test, out of $35 in commission, the "benefit" left for the user was 89 cents.

And this was no hypothesis, it was happening at industrial scale. The first video's central example uses Linus Tech Tips' affiliate tag on Newegg: Linus Media Group promoted Honey for years, across something like 160 sponsored segments, and ended the partnership in 2022 after noticing Honey overwrote their affiliate link *even when it found no discount at all*. Notice the demographic trap: whoever installs a coupon extension is exactly the viewer who hunts prices and clicks affiliate links. Honey paid the sponsorship once and went on taxing the creator's future commissions forever.

{{< youtube id="wwB3FmbcC88" >}}

So far, the victim was the creator. The second video shows the other side of the counter: the stores.

## The business model against the stores

The extension's `supported domains` file listed over 180,000 stores, against "30,000 participating" in the marketing. The spreadsheet analysis (a developer crawled the whole thing and published it) showed 146,000 stores with no relationship at all, included presumably without consent.

There's more: a coupon typed manually at checkout was sent to Honey's servers *before* asking for consent. And private codes leaked into the public database: military discounts, employee codes, a $75-off code with no minimum order that meant unlimited free merchandise.

The damage was measurable. One store owner reported a $100,000 loss after the exclusive code from the podcast he sponsored leaked into Honey's database, and he only noticed months later, long after the podcast's affiliate commission had evaporated. Chip, the CEO of Made In Cookware, summed up the effect: *"if Honey is going to take 10% of your revenue all the time, at the end of the day you're forced to raise prices."*

And when a store owner asked to be removed, the official answer was *"we typically do not remove codes unless we have a working relationship,"* which MegaLag accurately calls economic extortion: **stores don't pay to get in, they pay to get out**.

## Stand down: the rule Honey pretended to follow

Against all of this, PayPal's defense was always the same: *"Honey follows industry rules and practices, including last-click attribution."* A clever rhetorical exit, because you can argue about whether last-click is fair. What comes next is different in nature: proof that Honey knew it was in the wrong and built a system to avoid getting caught.

Some context first. Affiliate networks (Rakuten Advertising, CJ, Impact, Awin) have known since 2002 that browser extensions are natural parasites in this ecosystem. So they created a contractual rule called **stand down**: if the user already arrived at the store through another affiliate's link, the extension must deactivate itself and not interfere. Period. It's written into the contracts. Rakuten's policy, for instance, says the publisher must *"stand down and not display any forms of sliders or pop-ups"* when another affiliate has already referred the user, and *"must not force clicks or cookie stuff."*

And Honey complied. Technically. When tested.

Which brings us to the heart of the third video, what MegaLag calls Cookie Gate, and his analogy is exact: Volkswagen's Dieselgate. VW programmed its cars to lower emissions only during lab tests. Honey programmed its extension to respect stand down only when it detected the user was probably an auditor.

> **Remember this:** stand down has been a contractual obligation since 2002, not a courtesy. If the user arrived at the store through another affiliate's link, the extension must back off. Honey backed off only when the user smelled like an auditor.

## The evidence: ssd.json, line by line

After PayPal bought Honey, the extension was rewritten and the rules started arriving in plain text from a server. That let MegaLag expose the entire mechanism, and let Ben Edelman, the security researcher who worked the eBay affiliate-fraud case in the 2000s, verify all of it independently ([his full analysis here](https://www.benedelman.org/honey-detecting-testers/)).

First architectural point: **the stand-down rules live in the cloud, not in the extension**. The extension fetches two JSON files from Honey's servers and checks for updates every hour: `standdown-rules.json` (the normal rules) and `ssd.json` (the *selective stand-down* rules). Meaning: PayPal could change the behavior of ~14 million users within an hour, with no extension update, no Chrome Web Store review, no one watching.

Second: the normal rules were already a joke. The stand-down timer, how long Honey respects the original affiliate's cookie, was 3,600 seconds. One hour. Clicked your favorite YouTuber's link in the morning, bought in the afternoon, Honey could act again. And a 2023 Wayback Machine capture shows it was once **360 seconds. Six minutes**. As MegaLag says, it takes him more than six minutes just to type in his credit card. No affiliate network defines any such expiry. Honey made one up.

Third, the main course. This is the `ssd.json` captured on October 22, 2025 (comments are mine):

```json
{"ssd": {
  "base": {
    "gca": 1,      // check for affiliate console cookies
    "bl": 1,       // check the server-side blacklist
    "uP": 65000,   // minimum points to IGNORE stand down
    "adb": 26298469858850
  },
  // domains where "industry insider" cookies get checked:
  "affiliates": ["https://www.cj.com", "https://www.linkshare",
                 "https://www.rakuten.com", "https://ui.awin.com",
                 "https://www.swagbucks.com"],
  "LS": { "uP": 5001 },  // Rakuten exception (formerly LinkShare)
  "PAYPAL": { "uL": 1, "uP": 5000001, "adb": 26298469858850 }
  },
  "ex": {  // per-store exceptions (Honey internal IDs)
    "7555272277853494990": { "uP": 5001 },                         // TJ Maxx
    "7394089402903213168": { "uL": 1, "adb": 120000, "uP": 1001 }, // Booking.com
    "243862338372998182": { "uL": 0, "uP": 100000 },               // Kayo Sports
    // cookies to look for, in the SAME ORDER as the domains above:
    "GA": ["CONTID", "s_vi", "_ga", "networkGroup", "_gid"]
  }
}
```

How it works: when the extension detects you clicked an affiliate link, it consults these rules before deciding whether to honor stand down:

- **`uL`** (user logged in): you must be logged into a Honey account.
- **`uA`** (user account age): your account must be a minimum age, 30 days, in milliseconds, *"for whatever reason,"* as MegaLag notes. A brand-new account is the signature of someone testing the extension for an audit.
- **`uP`** (user points): you must have accumulated a minimum of cashback points. In the current config: 65,000 points. Since 1,000 points redeem for $10 in gift cards, that's $650 in lifetime earnings, which rules out virtually every real user and certainly every auditor on a test account.
- **`bl`** (blacklist): the server can flag your ID, cookie, or IP (anyone who ever complained about Honey, say) and treat you as "high risk."
- **`gca`**: the most incriminating of all, and it gets its own paragraph.

If you pass every filter, the system classifies you as a legitimate consumer and Honey **ignores stand down** and takes the commission. Fail any one, it classifies you as a possible auditor and Honey behaves impeccably. Edelman sums it up: *"Honey stands down, but only sometimes. And the sometimes is predictable."* Deterministic, actually: same conditions, same result, reproducible.

### The gca: checking your pockets for an inspector's badge

The `gca` is the digital equivalent of patting you down for a regulator's badge. The `affiliates` and `GA` lists are positionally paired: on the `cj.com` domain, look for the `CONTID` cookie; on `linkshare`, `s_vi`; on `ui.awin.com`, `networkGroup`. The code, recovered via `sourceMappingURL` from the iOS app that leaked practically unobfuscated:

```javascript
m = p.ex && p.ex.GA || []
g = i().map(p.ssd && p.ssd.affiliates, (function(e) {
    return f += 1, u.A.get({
        name: m[f], // cookie name from the GA array
        url: e      // domain to check
    }).then((function(e) {
        e && (o.gca = 0) // cookie found: gca = 0, enter compliance mode
    }))
```

If you carry a login cookie from the CJ, Rakuten, or Awin affiliate dashboards, that is, if you work in the industry, Honey honors stand down on everything, always, no matter the link. MegaLag discovered this by accident while testing his own extension (Cookie Guard): he logged into his CJ affiliate account in another tab, and suddenly Honey turned into an angel.

And notice the cynical design detail: domains and cookie names sit in two separate lists instead of name-value pairs. As Edelman points out, the effect is to make the relationship between them harder to spot for anyone skimming the file.

Edelman is categorical about what this means: there is no legitimate reason for a coupon extension to check whether you logged into an affiliate dashboard. The only function is hiding from the people who enforce the rules. And whoever hides knows they're doing something prohibited.

### The other tricks: the "test" email, the killswitch, and eBay

Two more gems in the code. The extension scans your email address for the word "test". Found it, compliance mode:

```javascript
if (r.email && r.email.match("test") && (o.bl = 0), !r.isLoggedIn || t) {
```

And there's a master killswitch on the server: the extension periodically fetches a URL, and depending on the response the entire SSD system turns on or off:

```javascript
return e.next = 7, fetch("".concat("https://s.joinhoney.com", "/ck/alive"));
```

```javascript
c = S().then((function(e) {
    e && "alive" === e.is && (o.bl = 0)
}))
```

One flip on the server and 14 million extensions go into compliance mode instantly. Handy, say, on the day a big audit gets announced.

And eBay? eBay gets VIP treatment, straight in the code: while normal stand down lasts one hour, eBay's lasts 86,400 seconds (24 hours), and the SSD logic is explicitly disabled for eBay domains:

```javascript
"regex": "^https?\\:\\/\\/rover\\.ebay((?![\\?\\&]pub=5575133559).)*$",
"provider": "LS",
"overrideBl": true,
"ttl": 86400
```

```javascript
a = "ssd" === r && !/ebay/.test(p);
```

Why? Because in 2008 eBay brought civil and criminal charges against its two biggest affiliates, Shawn Hogan and Brian Dunning, who collected over $20 million in 18 months running cookie-stuffing schemes, and both went to jail. Edelman himself helped catch them. Honey knew exactly who not to mess with. The rest of the market, apparently, was fair game.

### Telemetry: the evidence that documents itself

The part that made my jaw drop: from day one, the defeat device **logged every decision it made**. When the extension decides to honor stand down, it sends telemetry with `"method":"suspend"` and a `state` saying exactly which rule fired, `"uP:5001"`, `"gca"`, `"ssd"`, along with the original affiliate link, which frequently contains the stiffed affiliate's ID and sometimes their name.

Somewhere on PayPal's servers sits a detailed record of every commission this system helped steal. MegaLag closes the fourth video urging the networks to demand that data and claw the money back. Hard to argue with that.

### How MegaLag proved it on the public extension

One bit of engineering that deserves respect. After the first video, PayPal raised the base threshold to 65,000 points, effectively switching the mechanism off for nearly everyone and narrowing the sketchy behavior. Except whoever edited the `ssd.json` forgot the Rakuten exception: `"LS": {"uP": 5001}`.

MegaLag went on what he calls a *"painfully expensive shopping spree"* until he crossed 5,000 points, and reproduced the fraud on the public extension, untouched, without modifying a single line. (Edelman did it the easy way: he intercepted the server's response with Fiddler and lied about his own points balance. His code is in the article linked above.)

## The PayPal rewrite

The system's genealogy, reconstructed by MegaLag from ~300 archived extension builds going back to 2014:

- **October 2017**: the SSD first appears, in version 10.5.2, still under founders Ryan Hudson and George Ruan, but encrypted, scrambled, unreadable to anyone who stumbled on it. Researcher Wladimir Palant had already documented in 2020 that Honey concealed chunks of its own code.
- **March 2021**: under PayPal, version 13.1.0, **the entire system was rebuilt**. The rules were restructured into a new format and started living in plain text on PayPal's servers. That careless rewrite is what exposed everything.

Hold that thought and compare it with PayPal's official statement after the roof caved in:

> *"The code causing this behavior has been identified and no longer has an impact. The code was implemented prior to PayPal's acquisition and appears to affect less than 0.1% of Honey's traffic."*
>
> — PayPal to Hello Partner, January 2026

MegaLag calls that what it is: a lie. You don't rebuild a system from scratch, tune its rules year after year, and then claim you had no idea it existed.

The timeline gives it away: MegaLag asked PayPal for comment on December 18, 2025; they called the accusations *"not accurate"* and sent the lawyers after him. Rakuten cut Honey from its network on January 12, 2026. The defeat device was deactivated on January 13, one day later, almost a month after the warning. And "0.1% of traffic" is empty rhetoric: the rules live on the server, so the targeting was always remotely tunable. Under the 2023 rules, the target was practically everyone.

## The fallout

After Cookie Gate, things moved:

- **Rakuten Advertising** (January 12, 2026): terminated Honey from the entire network, more than 2,000 stores, including Walmart, Lego, Sephora, Newegg, Uniqlo, and Samsung. The sordid detail: internal emails that surfaced in the litigation show Rakuten knew about stand-down violations as early as July 2020 and kept Honey anyway, and PayPal even replied that Rakuten's stand-down policies were *"overreach."* In May 2026 Rakuten quietly let Honey back in, after publishing an [open-source stand-down SDK](https://github.com/rakutenrewards/PublisherStandown-SDK) that Honey implemented.
- **Impact** (January 16): removed Honey from its discovery marketplace and suspended the account, confirming a breach of *"universal stand-down requirements."*
- **Awin** (January 21): the biggest network affected, with over 16,000 merchants. Confirmed *"breaches of our publisher policies,"* suspended payments, and imposed a remediation plan that includes **giving the networks access to Honey's source code**.
- **Google**: in March 2025 the Chrome Web Store started requiring a *"direct and transparent user benefit"* for any extension injecting affiliate links. Honey's workaround was switching on 0.1% to 1% cashback at nearly every partner store. Technically a benefit, practically loose change.
- **The market responded**: Honey lost about 7 million users (from 20 million to 14), over 7,000 stores (from ~35,000 to ~28,000), and the coupon database shrank from ~90,000 to ~50,000 codes. Apple, which alone generated more monetizable traffic than the bottom 27,000 stores combined, walked.

{{< youtube id="EXDemfGNGz0" >}}

## The class action

Here's where David meets Goliath in court. Days after the first video, on December 29, 2024, Wendover Productions (Sam Denby's company) filed the first suit; Devin Stone of LegalEagle, an actual attorney, organized the effort, and some twenty firms filed similar complaints across several states, with GamersNexus as lead plaintiff in one of them. The cases were consolidated in the Northern District of California: *In re PayPal Honey Browser Extension Litigation*, case 5:24-cv-09470-BLF, Judge Beth Labson Freeman.

The claims in the current complaint: unjust enrichment, intentional interference with contractual relations and with prospective economic advantage, violations of the Computer Fraud and Abuse Act (the American anti-hacking law), California's computer data access and fraud statute, and the unfair competition laws of California and Washington.

The procedural timeline is a soap opera:

- **November 2025**: PayPal tried to force arbitration and lost. Weeks later, Judge Freeman dismissed the first complaint, with leave to amend, because the affiliate contracts were with the merchants, not PayPal, and the Monte Carlo simulation the plaintiffs used to estimate damages didn't persuade her. Ryan Hudson tweeted *"Case dismissed"* and did a little victory lap. Hello Partner, the industry trade publication that had Honey as premier sponsor of its flagship conference, rushed out a piece on *"what MegaLag got wrong."*
- **January 2026**: the second complaint arrived at 101 pages, ten named plaintiffs, the actual merchant contracts, test-purchase evidence and, crucially, the Cookie Gate findings baked in. Page 65 describes the defeat device in detail: *"PayPal devised several methods to ignore or circumvent stand down protocols,"* including detecting visits to affiliate network websites, which the complaint calls *"arguably the most glaring reveal of PayPal's bad intent."*
- **June 4, 2026**: second hearing. The judge warned PayPal's attorney, Richard Jacobson, the same lawyer who signed the cease-and-desist against MegaLag, that he had *"an uphill battle."* When the defense argued that affiliate IDs are *"just short strings of numbers and letters"* with no intrinsic value, the judge replied that you could say the same thing about a dollar bill. Jacobson: *"I don't know how to respond to that."*
- **June 22, 2026**: the motion to dismiss was **denied in full**. Every claim survived. The case now moves into discovery: internal documents, communications, depositions, possibly of the founders and PayPal's own engineers. Trial, if it happens, late 2027. MegaLag's guess, and mine too: PayPal will try to settle to bury those depositions.

Worth noting: a parallel UK consumer suit over the misleading *"best coupons"* advertising was dismissed in June 2026. And Capital One Shopping, sued over a similar scheme, settled in September 2025 denying liability.

## Conclusion

What gets me about this whole story is PayPal's behavior at every step. Accused with video and live demonstrations, they called it fake news. Confronted with the code, they sent a cease-and-desist and tried to get the video pulled from Patreon with a copyright claim. Formally alerted about the defeat device, they called it *"not accurate"* and waited for Rakuten to act before switching it off. Caught, they announced they'd *"recently discovered"* a system the company itself rebuilt in 2021.

At every rung, the choice was deny, threaten, minimize, until the evidence made the position untenable; then retreat half a step pretending surprise.

Honey, as a product, is a lost cause. Even if you don't care about the ethics of skimming creators' commissions, remember what Amazon warned back in 2020: this is an extension with permission to read and modify your data on any website, one that scans your cookies, logs your browsing history with geolocation, and applied knowingly expired coupons just to keep the numbers up. Uninstall it. No coupon is worth that.

And there's an inspiring side to this: one motivated developer from New Zealand, armed with a packet sniffer, a test account, and patience, did what billion-dollar networks with compliance teams couldn't do in eight years. His weapon was a plain-text JSON file and a few dozen lines of JavaScript that PayPal itself served to anyone who bothered to look. The line that closes the fourth video sums up the arrogance he brought down:

> *"When I'm wrong, I'm MegaLag. When I'm right, I'm just an industry commentator."*

Well, now he's a de facto technical witness in a federal case. David won this round. And it was beautiful to watch.
