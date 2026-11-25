---
title: "Why I Don't Like Jensen Huang"
date: '2026-11-25T10:00:00-03:00'
slug: why-i-dont-like-jensen-huang
translationKey: por-que-eu-nao-gosto-do-jensen-huang
description: "From Jensen Huang's ouster and unanimous reinstatement at Nvidia to circular investments, Southeast Asia export loopholes, and the myth of a 'pro-open source' Nvidia with CUDA locked down."
tags:
- artificial-intelligence
- hardware
- open-source
- linux
draft: false
---

Plenty of people in tech treat **Jensen Huang**, Nvidia's CEO, like a leather-jacketed rockstar who single-handedly built the future of computing. I take a very different view, and the events of November 2026 laid bare everything that rubs me the wrong way about how he runs the most valuable company in the AI race.

Start with the corporate circus of the past two weeks. On November 12, Jensen Huang [stepped down as Nvidia's CEO](https://nvidianews.nvidia.com/news/nvidia-announces-ceo-transition) following an internal board probe into personal conduct, triggered by reports of extramarital relationships, including with an Nvidia executive (**Kimberly Powell**) and with **Alice Huang** (no relation), a former executive and controlling shareholder of Singapore data-center operator **Megaspeed International**, whom U.S. intelligence agencies suspected of acting as an asset for Chinese intelligence.

![Jensen Huang and Alice Huang photographed at Computex (Reuters)](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/25/jensen-huang/jensen-alice-huang.jpg)

Eleven days later, on Monday (November 23), after a steep drop in Nvidia's stock (falling from $173.73 the day before his exit down to a trough of $125.53 on November 20, down 42% from its $217.94 peak on October 27) and a marathon board meeting in which, according to *The Wall Street Journal*, Huang expressed remorse and disclosed **additional extramarital affairs** beyond those initially reported, the exact same board [voted unanimously to reinstate him as CEO](https://nvidianews.nvidia.com/news/nvidia-board-reinstates-jensen-huang-as-president-ceo-and-board-director). On reinstatement day, the stock surged 31.5% in a single session to close at $165.05.

![Nvidia (NVDA) daily closing price chart from October 26 to November 24, 2026 showing the sell-off during Jensen Huang's absence and the rebound on reinstatement](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/25/jensen-huang/nvda-nov2026-stock-en.png)

## Politics, Alaska, Howard Lutnick, and the Southeast Asia loophole

Huang's rapid return came with a very visible political backdrop. In its [official reinstatement press release](https://nvidianews.nvidia.com/news/nvidia-board-reinstates-jensen-huang-as-president-ceo-and-board-director), Nvidia's board stated that its reversal factored in assurances from senior U.S. government officials that his return posed no national security risk, and President **Donald Trump** openly acknowledged using his influence behind the scenes to back Huang's reinstatement, arguing that losing Huang would hurt U.S. competitiveness against China in AI.

![Jensen Huang and President Donald Trump at an official event (Reuters)](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/25/jensen-huang/jensen-trump.jpg)

Trump's personal warmth toward Huang had already raised eyebrows back in May 2026. When Trump assembled a delegation of top U.S. Big Tech CEOs (including Tim Cook and Elon Musk) for a state visit to China, Jensen Huang was noticeably missing from the initial roster. According to *CNN* and *Business Insider*, after media coverage highlighted his absence, Trump personally called Huang and invited him at the last minute; Huang flew his private jet to board Air Force One during its refueling stop in **Anchorage, Alaska**, a Hollywood-style stunt that immediately spawned waves of *Mission: Impossible* memes online, even amid reports that U.S. intelligence officials had already briefed the White House on concerns surrounding Alice Huang.

Meanwhile, a fierce cabinet battle broke out over chip export enforcement. According to reporting by [*The Guardian*](https://www.theguardian.com/us-news/2026/nov/18/howard-lutnick-nvidia-cantor-fitzgerald), *Axios*, and *Forbes*, Commerce Secretary **Howard Lutnick** repeatedly resisted or slow-walked requests from Treasury, State, and Defense to place Megaspeed on the trade blacklist (*Entity List*), prompting Treasury Secretary Scott Bessent to publicly criticize Commerce's delays.

This touches on something I despise regardless of which party is in power: governments and giant corporations cozying up in ways that reek of conflict of interest. In November 2026, U.S. House Democrats (including Jamie Raskin and Gregory Meeks) [opened a formal congressional probe](https://democrats-foreignaffairs.house.gov/2026/11/ranking-members-meeks-raskin-and-kamlager-dove-probe-whether-lutnicks-family-finances-shaped-his-response-to-the-nvidia-spy-scandal/) and sent a letter directly to **Brandon Lutnick**, Howard Lutnick's son and current Chairman of the Wall Street firm **Cantor Fitzgerald** (which Howard ran before transferring his stake into trusts for his adult children upon joining the cabinet), asking whether Commerce's resistance to blacklisting Megaspeed had any connection to Cantor's Nvidia holdings (reportedly over 3.5 million shares worth more than $1.3 billion before being trimmed by roughly 49% between late 2025 and early 2026). Cantor Fitzgerald flatly denied the allegations, stating that the reported shares were client-hedging equity swaps rather than a proprietary bet and that the firm played zero role in export-control decisions.

In the same political orbit, **Donald Trump Jr.** joined the venture firm **1789 Capital** as a partner after the 2024 election; in late 2025, 1789 Capital co-invested alongside **Nvidia** itself in a $2 billion funding round for **Reflection AI** (at an $8 billion valuation), alongside broader bets on AI data centers. Even without jumping to conspiracy theories and acknowledging that nothing here is a proven crime, I hate seeing regulators, national-security blacklists, and politically connected investment funds tangled up with the biggest vendor in the industry.

Sitting behind that fight was a glaring loophole left over from Biden-era export controls. Because Chinese firms were barred from importing top-tier Nvidia GPUs directly into China, giants like **Tencent**, **Alibaba**, and **ByteDance** simply rented compute remotely from Nvidia-powered data centers in Southeast Asia, particularly in **Singapore** and **Malaysia** (including Megaspeed and its Malaysian subsidiary **Speedmatrix**).

Faced with those warnings, in a *Bloomberg* interview covered by [*Fortune*](https://fortune.com/article/nvidia-ceo-jensen-huang-ai-chip-diversion-china-blackwell-diffusion-rule/), Jensen Huang brushed them off and insisted there was **"no evidence of any AI chip diversion,"** joking that two-ton Grace Blackwell racks are *"not going to be putting that in your pocket or your backpack anytime soon"* and claiming customers and partner countries police themselves carefully. In reality, the black market was operating in plain sight. Back in August 2025, months before mainstream financial outlets broke the Megaspeed scandal, independent hardware outlet **Gamers Nexus** spent three weeks reporting on the ground in **Hong Kong, Shenzhen, and Taipei** and released a [feature-length documentary](https://gamersnexus.net/gpus-deep-dive-news/nvidia-ai-gpu-black-market-investigating-smuggling-corruption-governments) with on-camera interviews of actual smugglers, brokers, repair shops, and end buyers. They mapped how U.S.-restricted GPUs flow from American resellers through Southeast Asian middlemen into mainland China, and documented Chinese repair networks salvaging and rebuilding high-end cards to bypass controls (the documentary was even briefly pulled off YouTube by a Bloomberg DMCA strike over a short fair-use clip before being restored):

{{< youtube id="1H3xQaf7BFI" >}}

Only this month, under pressure from the scandal, did the Commerce Department's **BIS** (Bureau of Industry and Security) finally add Megaspeed and Speedmatrix to the *Entity List* and roll out an [Interim Final Rule (**15 C.F.R. § 744.24**)](https://www.ashurstperkinscoie.com/en/insights/bis-issues-interim-final-rule-restricting-remote-access-to-advanced-us-ai-chips/) closing the remote-access loophole:

* Any data center outside the United States offering compute above a threshold roughly equal to 750 H100s (or 330 Blackwell B200s) to companies headquartered in China or Macau now requires a U.S. export license and strict *Know Your Customer* (KYC) vetting.
* BIS explicitly designated **Singapore, Malaysia, Indonesia, Thailand, and Brazil** as countries presenting an "unacceptable risk of diversion," mandating case-by-case export licenses for advanced AI accelerators (outside specific exemptions for U.S.-headquartered operators with monthly reporting).

## What disgusts me most: circular investments

Personal scandals and Washington lobbying are nothing new on Wall Street. What genuinely turns my stomach about Jensen Huang's playbook is the financial engineering behind Nvidia's **circular investments**.

> **Disclosure:** I am an Nvidia shareholder. Every trick that keeps the stock climbing directly benefits my portfolio. If you disagree with me here, I hope you are right, because that only makes me wealthier. Still, I call things as I see them: I cannot turn into a fanboy, even when I own the stock.

If you don't read balance sheets for fun, here is a simple contrived example of why this looks so much like an accounting trick. Suppose I run "GPU Corp" and need to show Wall Street that my quarterly revenue keeps doubling every year:

1. I take **$1 billion** from my cash pile and "invest" in equity in an AI startup or a *neocloud* (a specialized GPU cloud renter) called "CloudX," while also guaranteeing its data-center leases and promising to buy back unsold capacity if demand dips.
2. Armed with my stamp of approval, my $1 billion, and my capacity backstops, CloudX goes to credit markets and raises another **$3 billion in high-interest debt**.
3. The very next day, CloudX turns around and spends that **$4 billion** buying GPUs from me.
4. On my quarterly income statement, that $4 billion lands on the top line as **shiny Data Center revenue** (at massive gross margins), while my $1 billion investment sits quietly on the balance sheet as a "strategic equity asset," leaving reported revenue untouched.

![Diagram of Nvidia's circular investment loop: equity and lease backstops feeding leveraged debt and Data Center revenue](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/25/jensen-huang/diagram-circular-investments.jpg)

Under the letter of GAAP accounting, structured across separate legal entities, this passes as legal. Economically, you are financing and backstopping your own customers' debt to inflate your top-line revenue and defend a multi-trillion-dollar stock multiple.

In the real world, Nvidia built a web estimated at **over $100 billion** in equity stakes and financial commitments across customers including **OpenAI**, **xAI**, **CoreWeave**, and **Nebius**, including roughly **$36 billion** in direct neocloud capacity commitments (which Nvidia only recently started trimming down to around $32 billion with stricter guardrails during CFO Colette Kress's interim stewardship).

## Putting the AI bubble in perspective with real numbers

To appreciate the scale of this distortion, look at Nvidia's official numbers across the past three fiscal quarters (**FY2027**, running February 2026 through January 2027), including its [Q3 FY2027 earnings release](https://nvidianews.nvidia.com/news/nvidia-announces-financial-results-for-third-quarter-fiscal-2027):

| Fiscal Quarter | Ended | Total Revenue | YoY Growth |
|---|---|---:|---:|
| **Q1 FY2027** | Apr 26, 2026 | **$81.6 billion** | +85% |
| **Q2 FY2027** | Jul 26, 2026 | **$96.2 billion** | +106% |
| **Q3 FY2027** | Oct 25, 2026 | **$115.8 billion** | +103% |

In Q3 FY2027 alone, the **Data Center** segment generated **$107.6 billion** (roughly 93% of total revenue). Annualized, Nvidia is running at a clip above **$460 billion a year**.

Now stack that against the broader 2026 AI infrastructure bubble in the summary table below:

| Layer / Player (2026) | Estimated Annual Scale | Role in the Bubble |
|---|---:|---|
| **Global AI infra capex** | **~$1 trillion** | Consolidated estimate (Goldman Sachs / JPMorgan) |
| **Top 5 U.S. Hyperscalers** | **$800B to $830B** | Amazon (~$220B), Alphabet (~$200B), Microsoft (~$175B), Meta ($130B to $145B) + Oracle |
| **Nvidia (Q3 annualized)** | **~$460 billion** | Dominant picks-and-shovels supplier (93% Data Center) |
| **Circular / neocloud margin** | **~$30B to $50B** | Demand leveraged off $100B+ in Nvidia equity & backstops |
| **Southeast Asia gray zone** | **~$10B to $20B** | Remote access/diversion (Megaspeed network alone ~$7.5B to $12B) |

![Infographic comparing 2026 global $1 trillion AI capex, the top 5 U.S. hyperscalers, and Nvidia's annualized revenue footprint](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/25/jensen-huang/diagram-ai-bubble-scale.jpg)

How much of Nvidia's revenue sits inside those two gray zones (Southeast Asia diversion + circular financing)?

* **Southeast Asia and remote access**: in prior fiscal years (such as FY2025), **Singapore** alone accounted for roughly **18%** of Nvidia's billed revenue (Nvidia has consistently noted that this reflects billing destination rather than final deployment, and later stopped breaking Singapore out as a separate line item in its Form 10-Q). Investigations into the Megaspeed/Speedmatrix network alone estimated **$7.5 billion to $12 billion** in advanced hardware moving through those regional hubs.
* **Circular investments and neoclouds**: combining equity-seeded purchases, lease guarantees, and capacity backstops across CoreWeave, Nebius, xAI, and OpenAI, analysts point to tens of billions of dollars in demand leveraged off Nvidia's own balance sheet.

> Even if you stripped out $10 billion to $20 billion a year in Southeast Asia diversion and another $30 billion to $50 billion a year in circularly financed demand, Nvidia would still be a monstrous $350 billion to $400 billion hardware juggernaut fed by hyperscaler capex.

The danger lives on the **margin**. When you juice the top 15% to 20% of demand with circular financing and export loopholes, you sustain the illusion of endless 100% year-over-year growth, convince lenders to pour billions into cash-burning neoclouds, and inflate valuations across the entire $1 trillion bubble. When end-user AI software revenue lags behind capex, those leveraged intermediaries are the first ones to snap.

## The myth of a "pro-open source" Nvidia

Beyond the financial engineering, what drives me up the wall about hardcore Jensen Huang fanboys is watching them celebrate him as a "champion of open source" just because he praises open-weight AI models on stage and releases Nemotron weights.

Follow the money and his sudden love for open-source AI makes instant sense. If the entire world only bought closed APIs from two or three labs (like Google running on its own **TPUs**, or Amazon on **Trainium**), Nvidia would lose leverage. If every bank, university, government, and startup downloads open-weight models (Llama, DeepSeek, Qwen) to run on-prem or on neoclouds, **every single one of them has to buy Nvidia GPUs**. Open-source models commoditize the layer above Nvidia while fortifying Nvidia's monopoly on the silicon underneath.

That same lens explains how I view the **September 3, 2026** deal in which Nvidia agreed to [acquire Hugging Face for $12.93 billion](https://blogs.nvidia.com/blog/nvidia-to-acquire-hugging-face/) (targeted to close in the first half of 2027, pending regulatory approval). Fanboys celebrated the buyout as ultimate proof of Nvidia's devotion to open source. To me, it signals the exact opposite: the corporate capture of open AI's public square. Just a year earlier, in 2025, Hugging Face had turned down a $500 million Nvidia investment offer specifically to protect its independence and hardware neutrality (supporting AMD, Intel, and AWS alongside Nvidia through tools like *Optimum*).

On announcement day, Nvidia read from the standard corporate playbook and promised to keep Hugging Face "open and hardware-neutral." Every dominant vendor promises neutrality while regulators are still reviewing the paperwork. In reality, owning the "GitHub of AI" (used by more than 18 million developers) hands Nvidia the primary distribution bottleneck for open models and datasets: privileged visibility into every emerging architecture, leverage to steer default deployment paths toward **CUDA** and **TensorRT-LLM**, and countless subtle ways to turn rival silicon into a second-class citizen over time. That exact risk of vertical lock-in is why both the **U.S. Department of Justice (DOJ)** and European competition regulators opened antitrust scrutiny into the buyout (on top of Nvidia's earlier strategic acquisitions of **Run:ai** and **SchedMD**).

![Jensen Huang and Clément Delangue on CNBC announcing Nvidia's $12.93 billion acquisition of Hugging Face](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/25/jensen-huang/nvidia-hugging-face-cnbc.jpg)

Look at Nvidia's actual history in real open source and the record is infamous. In June 2012, during a [Q&A at Aalto University in Finland](https://www.youtube.com/watch?v=iYWzMvlj2RQ), **Linus Torvalds** was asked about Nvidia's refusal to properly support **Nvidia Optimus** hybrid laptop graphics on Linux (even while Nvidia happily sold Tegra chips into Android, which runs on the Linux kernel). Torvalds called Nvidia *"the single worst company we've ever dealt with"* and flipped off the camera: *"So, Nvidia, fuck you."*

![Linus Torvalds at Aalto University in June 2012 delivering his famous "Nvidia, fuck you" response](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/25/jensen-huang/linus-torvalds-nvidia.jpg)

For more than a decade, the volunteer developers behind the open-source **Nouveau** driver had to reverse-engineer Nvidia GPUs in the dark without hardware documentation. Worse, starting with Maxwell and Turing, Nvidia locked GPU clock-switching (*reclocking*) behind cryptographically signed firmware, leaving modern cards stuck at sluggish boot clocks on Nouveau for years.

What about Nvidia's GitHub presence and its May 2022 release of [`NVIDIA/open-gpu-kernel-modules`](https://github.com/NVIDIA/open-gpu-kernel-modules) under a dual GPL/MIT license?

Look at what they actually opened. On modern GPUs, Nvidia moved almost all low-level hardware management onto an internal RISC-V microprocessor on the card called the **GSP** (*GPU System Processor*), which runs a **100% closed, proprietary binary firmware blob**. The open GitHub module is essentially a thin Linux kernel shim forwarding calls to that closed firmware. That genuinely helped Linux distributions (Ubuntu, Fedora, Arch) ship drivers without breaking on every kernel release, and deserves modest credit.

Where is Nvidia's actual moat? The entire userspace graphics stack (OpenGL, Vulkan) and the core technologies that actually lock the market in remain **100% closed and proprietary**:

* **CUDA**: Nvidia's proprietary parallel-computing platform and compiler that lets developers run general-purpose code across thousands of GPU cores. Nearly two decades of scientific libraries and AI frameworks (like PyTorch) targeted CUDA first, creating the strongest vendor lock-in in modern computing.
* **cuDNN and TensorRT**: the deeply tuned low-level libraries that push neural-network primitives (matrix multiplies, attention kernels, convolutions, and quantization) to peak silicon efficiency during training and production inference. Without equivalent software optimization, rival hardware with similar paper specs often delivers a fraction of real-world throughput.
* **DLSS** (*Deep Learning Super Sampling*): in gaming, Nvidia's proprietary AI upscaling and frame-generation stack running exclusively on GeForce Tensor Cores, giving gamers a strong incentive to stay locked inside Nvidia's ecosystem.

### Artificial segmentation, crypto cards, the RTX 5090 shortage, and the HBM memory squeeze

That same habit of locking down hardware to protect margins shows up across Nvidia's entire recent product history:

* **Artificial throttling on the RTX 3090 and 4090**: Nvidia deliberately crippled consumer cards by running FP16/BF16 Tensor Core matrix multiplies with FP32 accumulation at half speed, while also blocking direct PCIe Peer-to-Peer (P2P) transfers across multiple GPUs. The open-source community (via pre-boot kernel modules like `gpu-unlock` / `gpu-unlock-ada` and P2P driver forks) discovered that rewriting hidden internal speed-select registers before the driver loads **doubles raw Tensor Core throughput** (pushing an RTX 4090 to around 330 TFLOPS) and speeds up real-world local LLM **prompt processing (prefill) by 15% to 35%** in `llama.cpp` and `vLLM`, while unlocking P2P adds **10% to 30% throughput** in multi-GPU setups. It was pure software segmentation designed to push AI users onto $10,000 workstation cards.
* **The crypto card debacle**: in May 2022, the [SEC fined Nvidia $5.5 million](https://www.sec.gov/newsroom/press-releases/2022-79) for failing to disclose how much of its 2018 "Gaming" revenue surge came from volatile crypto miners rather than gamers. During the 2021 boom, Nvidia followed up with **LHR** (*Lite Hash Rate*) limiters on consumer RTX 30-series cards while selling stripped-down **CMP** mining cards with zero display outputs, which turned into instant e-waste the moment crypto cooled off.
* **The RTX 5090 shortage**: launched at an official **$1,999 MSRP**, the 32 GB GDDR7 RTX 5090 (built on the huge GB202 die) became a ghost on retail shelves, trading on street and secondary markets for **$5,000 to over $6,200** (150% to 200%+ above MSRP). With TSMC wafer allocations and GB202 dies routed heavily toward high-margin Blackwell Data Center accelerators and RTX Pro workstation cards, and AI startups buying remaining 5090s by the pallet as cheap local inference nodes, regular consumers were left empty-handed.
* **The memory squeeze (SK Hynix, Samsung, and Micron)**: producing HBM (HBM3E/HBM4) for Nvidia's AI accelerators consumes roughly **three times as much wafer capacity** as conventional DRAM. As Nvidia and hyperscalers locked up multi-year HBM supply agreements with **SK Hynix, Samsung, and Micron** (which together control over 90% of global DRAM), conventional DDR4/DDR5 and GDDR7 supply was squeezed and prices surged. While Nvidia itself is not a defendant in the U.S. federal antitrust class action against the memory trio (where Judge Noël Wise denied their motion to dismiss, remarking that their synchronized cuts looked like *"hawks flying in formation,"* echoing the early-2000s DRAM price-fixing cartel), Nvidia's HBM lock-ups sit squarely at the center of that supply crunch.

## The ghost of 1990s Microsoft

Anyone old enough to remember the tech industry in the late 1990s recognizes this playbook immediately. Back then, **Microsoft** controlled over 90% of desktop PCs with Windows and used its closed Win32 API moat, restrictive OEM contracts, and the infamous *"Embrace, Extend, and Extinguish"* strategy to crush rivals like Netscape and Sun's Java.

In May 1998, the U.S. Department of Justice and 20 states sued Microsoft in *United States v. Microsoft Corp.*. In November 1999, federal judge **Thomas Penfield Jackson** issued his Findings of Fact concluding that Microsoft had abused its monopoly power; two months later, on **January 13, 2000**, right in the eye of the antitrust storm, **Bill Gates stepped down as CEO** (handing the job to Steve Ballmer while staying on as Chairman and Chief Software Architect), months before Jackson ordered the company broken in two (a breakup later vacated on appeal in 2001, even as the monopoly-abuse ruling stood).

The operational parallel with Nvidia today is hard to miss: **CUDA and NVLink are the new Win32 of the AI era**. Nvidia embraces open-source models on the surface and buys the community's town square (Hugging Face) while keeping the compiler, runtime, and interconnect layers locked down, tying up neoclouds with multi-billion-dollar backstops, and cornering silicon and HBM supply.

There is one glaring irony separating 2000 from 2026. In the 1990s, the U.S. government dragged Microsoft into court to break up its monopoly and helped hasten the end of Gates's run as CEO. In 2026, when Jensen Huang stepped down amid a corporate scandal, chip-war geopolitics against China turned Nvidia into a strategic asset deemed too important to weaken, and senior officials in Washington helped roll out the red carpet for his return eleven days later.

Looking at the hardcore fanboys who cheer Nvidia today as "open-source friendly," I have zero doubt: back in the 1990s, they would have been the exact same crowd cheering Microsoft's monopoly, mocking Linux as a toy, and applauding *Embrace, Extend, and Extinguish*, just as today they line up behind pro-Trump politics to excuse any cozy entanglement between government and mega-corporations whenever it favors their side.

For a company whose CEO loves taking the stage in a leather jacket preaching the gospel of open ecosystems, Nvidia is open wherever it sells more cards and locked down like a vault wherever it protects its own monopoly. I respect the brutal engineering competence that built CUDA; I just refuse to buy the saintly PR narrative fanboys keep pasting onto Jensen Huang.
