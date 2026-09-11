---
title: "You're an Idiot if You Believe the Misleading Ads from OpenAI, Anthropic, NVIDIA, DeepSeek. Here's Why"
slug: "propagandas-enganosas-da-openai-anthropic-nvidia"
date: '2026-09-09T16:00:00-03:00'
draft: false
translationKey: propagandas-enganosas-openai-anthropic-nvidia
description: "Nvidia and OpenAI declared that AGI has arrived, OpenAI brute-forced a Millennium Problem and threatened a mathematician's career, and an Anthropic employee quit crying Skynet. I take the propaganda apart."
tags:
- artificial-intelligence
- llms
- business
---

This week was a festival of aggressive advertising from the AI companies. There were so many pompous declarations in so little time that you could use it as a case study in deceptive marketing. So let me repeat my usual motto, because it never fails:

> **"Your excitement about AI is inversely proportional to your knowledge about AI"**

If you read this week's headlines and walked away excited thinking the Terminator is coming, or that the machine became God, you fell for the propaganda. And I'm going to take it apart piece by piece so you understand why.

And let me put my cards on the table right away, because I've been repeating this for a while on the podcasts I show up on. To me, Dario Amodei, of Anthropic, has a god complex. The guy genuinely believes he's saving humanity, with that slightly scary woke messianism of his. And Sam Altman, of OpenAI, is a mobster. He thinks he's Michael Corleone, the cold and calculating boss from The Godfather, but in practice he's Fredo: the weak, bungling brother who thinks he's the smart one in the family and keeps screwing things up. Hold on to those two portraits, because everything I'm about to explain below proves both of them.

## "AGI has arrived," says the guy selling the shovel

It started with Jensen Huang, Nvidia's CEO, [declaring once again that AGI has arrived](https://fortune.com/2026/09/09/markets-agi-nvidia-singularity-wall-street/). Not in a paper, not in a technical demo, but in a Sunday post on X, tying the declaration to OpenAI's new Astra model, trained on roughly 100,000 Grace Blackwell chips. In other words, the chips Nvidia sells.

Look at the source. The man who makes money selling shovels to the prospectors is announcing that the gold is infinite. Worth remembering that, months ago, Jensen himself went as far as defining AGI as "the ability to create a one-billion-dollar company." A conveniently commercial definition that has nothing to do with intelligence. Gary Marcus went straight to the point and asked the obvious: does Jensen maybe have a financial incentive to declare that AGI has arrived, seeing as he sells the GPUs?

And look at the irony: despite the grandiose headline, Nvidia's own stock fell around 2% in the following days. Not even the market, which runs on hype, fully bought the story.

Right after that, OpenAI launched GPT-6 Astra and hammered the same message. Greg Brockman closed the press event with a "welcome to the AGI era" and said "for me, personally, I think we got there." Except, in the same breath, he dropped the line that knocks the whole thing down: "everyone has a different definition of AGI." So the guy claims that the most important thing in the history of humanity has arrived and, at the same time, admits that nobody really knows what that thing means. That alone should set off the alarm in your head.

## The "Millennium Problem" brute-forced into submission

The main course of the propaganda was OpenAI announcing that it solved a Millennium Problem in mathematics. Let me explain what that is, because the headline is designed precisely to impress whoever doesn't know.

In 2000, the Clay Mathematics Institute listed seven open problems in mathematics and offered one million dollars to whoever solved each one. These are brutally hard problems. To this day, in more than twenty years, only one has been solved: the Poincaré Conjecture, by Grigori Perelman, who by the way refused the prize.

One of those seven is the Navier-Stokes equations. These are the equations that describe the movement of fluids, water, air, blood. The open question is not "how to simulate fluid," engineering has done that very well for decades in any aerodynamics software. The question is purely mathematical: does a smooth solution always exist, or can the fluid develop a singularity, a point of infinite velocity, the so-called "blow-up," in finite time? It's a question about the rigor and existence of the solutions, not about the practical usefulness of the equations.

And this is where my first point lives, one I already [explained in detail in a post](https://x.com/AkitaOnRails/status/2097752602440028566): even solving this definitively changes absolutely nothing in real life. No plane flies better, no weather forecast gets more accurate, no medicine works differently. Engineers keep modeling fluid the same way, with or without the proof. It's a beautiful intellectual achievement, and that's it. The practical impact is zero.

Now comes the detail the headline hides. OpenAI did not solve the canonical problem. It attacked the **forced** version of the equations (statements C and D in the Clay formulation), where blow-up is allowed because there is an external force term pushing the system. The version that real mathematicians consider the deep problem is the unforced one. The Clay Institute itself accepted nothing, still lists Navier-Stokes as unsolved, and OpenAI didn't even claim the one-million-dollar prize.

And how did they get there? Brute force. They threw roughly 10,000 agents running in parallel for 88 hours, burning something in the range of 130 billion output tokens on this problem alone. The compute bill landed in the millions of dollars (the whole marathon, with several problems, was estimated at somewhere between 15 and 22 million at list price). Let me make this very clear: in the best case, what got proven is that throwing a mountain of compute at a problem can close the last leg of some specific things. That is brute force at industrial scale, a giant automated search that reaches the result on the weight of the compute. Mathematical genius unlocking new mathematics is another story, and that is not what happened here. And a hell of a lot of money, for a "prize" of one million that they didn't even go collect.

## The dirty part: how they treated the real mathematicians

And this is where the story stops being about mathematics and becomes about character.

There were real mathematicians working on this problem for months: Tristan Buckmaster, from NYU, and Levent Alpoge, who happens to work at Anthropic. A personal project of theirs, with no company sponsorship, that had already produced an advance on a sibling problem, the Euler equations. They were coming at it through a specific path that almost nobody in the world was following.

According to Buckmaster's account, [told to TechCrunch](https://techcrunch.com/2026/09/08/openai-fought-dirty-on-career-making-math-problem-says-nyu-mathematician/) and to [Fortune](https://fortune.com/2026/09/08/openai-says-it-cracked-navier-stokes-math-grand-challenge-buckmaster-accusation-cheating-intimidation-tao-lament/), it went more or less like this. A rumor circulated that Anthropic had solved a big math problem. OpenAI, afraid of falling behind, hastily put together a task force to solve it first and publish before anyone else. Buckmaster had mentioned his personal project to a mathematician at OpenAI, and a few days later Sébastien Bubeck, from OpenAI, shows up saying that an internal model had produced a hundred-page proof through exactly the same approach that almost nobody was using. Buckmaster called this "absolute academic misconduct" and asked, in no uncertain terms, whether the model had trained on their sessions.

Then comes the mob part. Still according to Buckmaster's account, Bubeck proposed a "deal": Buckmaster would remove Alpoge's credit, because Alpoge works at Anthropic. When Buckmaster refused, Bubeck allegedly said "why would you ruin your career?" and "if you don't want me to be nice, then I don't need to be nice." This is one party's account, and OpenAI denies the substance, says it never saw their work and that Bubeck apologized afterward. But the simple fact that this kind of conversation was on the table already says a lot about the culture.

And what does OpenAI do after the thing blows up? It [posts on X](https://x.com/OpenAI/status/2097374640582668336), all nice and tidy, saying it is "sharing" the solution with the community. A veneer of scientific generosity to try to bury the scandal underneath. It didn't stick. The case was laid bare.

The one who put a finger on the wound with authority was Terence Tao, probably the greatest living mathematician, a Fields medalist. He harshly criticized the stance, saying that "the indiscriminate strip-mining of open problems in search of solutions can destroy the ecosystem from which the next generation of techniques, problems, and mathematicians would come." And he added that this race turns mathematics into a "meaningless production-quota game." His technical point is the deepest of all: AI increasingly spits out answers without understanding, a black-box proof, without generating the comprehension that human effort generates. And notice: Tao praised the work of the two human researchers. His criticism was aimed at the circus, not at the science.

## The Anthropic employee who "quit in protest"

A day after this OpenAI embarrassment, on the other side of the ring, an Anthropic employee decided to put on his own little show. Jacob Coxon, a pretraining researcher who'd been there only four months, [announced on X that he was leaving the company](https://x.com/hilbertspaess/status/2097476203863224394) out of fear that nobody there knows what they're doing, banging on the apocalypse drum again: AI becoming Skynet, "possibly killing everyone by the end of the decade," asking for a "pause" in the advance of the models. To round out the theater, a head of alignment at Anthropic itself came out endorsing it publicly, saying he thinks there's "more than a 10% chance" that AI will kill all of humanity in the next decade.

My opinion on this is short and blunt. This is one more complete bullshit of virtue signaling.

Let's go by the logic of your own dramatization. You're watching your boss put a gun to a child's head. You "quit" and tweet "I left the company because I disagree with it," instead of going up to your boss and punching him in the face. There are only two explanations. Either the "threat" you're screaming about doesn't really exist, and it's a performance. Or you're an idiot who thinks a tweet solves the end of the world. Tweeting like that only makes me hear "give me attention, I'm needy."

And there's the part the press rushed to turn into heroism. Axios even ran a piece painting Coxon as the guy who "gave up all his equity" so he could speak freely. Sounds beautiful. Except you just have to look at the numbers he himself gave in the interview. He was at Anthropic for four months. And there, equity only starts to vest after six months on the job. In other words, he left two months before the first share actually became his. There was no equity to "give up." The heroic sacrifice was worth exactly zero. It's like quitting in your second week and going around saying you "turned down the company's retirement plan."

And the sleight of hand is the line he shields himself with: "I no longer have anything to gain by juicing up Anthropic's valuation." Half true. He walked away from four months of paper that wasn't worth anything yet, but he still holds equity in OpenAI, where he worked from 2023 to 2026. Meaning he dropped the part that wasn't worth anything and kept the part that is. So this story that he's clean of any financial interest in the AI hype doesn't hold up.

That's why the whole thing sounds a lot more to me like "I wasn't solid in that place yet, so I left first, unleashed the terror online to earn clout, to massage my ego seeing my name on 115 million views, without having to prove, demonstrate, or do anything. Glory."

And he's run this script before. Coxon had left OpenAI not long earlier, and by the account going around he walked out of there over the same "safety" concerns. Same person, same dramatic-exit theater, now at the second company. And somehow a single researcher's resignation tweet turned into a story with more than 100 million views, [plastered everywhere](https://x.com/GoUncensored/status/2097798269975896517), practically out of nowhere. An ordinary employee handing in his notice doesn't become a global headline on his own. Someone amplifies it.

And here I'm stepping into conspiracy-theory territory, so take it with the appropriate grain of salt. But when you put it all together, the viral resignation, the public endorsements from colleagues, the timing glued to the IPO window, a suspicion starts going around that none of this is spontaneous. There are already people [suggesting](https://x.com/AndrewCurran_/status/2097839975190720935) and [raising the same flag](https://x.com/orphcorp/status/2097781171673301330) that the whole thing is a coordinated campaign, a "doomer psyop": manufacture fear of the apocalypse to inflate the perception that the technology is too powerful, and while you're at it push regulation that locks out the smaller competitors. I have no proof that this is the case, and I'm not claiming it is. But notice how the hypothesis explains the facts just as easily as the lone-hero version does. When the script repeats so neatly and always favors the same side, being suspicious is the bare minimum.

And this is the pattern I want you to learn to question. A dramatic, superficial declaration, with no checkable evidence, with no skin in the game, with suspicious timing. Not by accident, all of this happens right in the middle of these companies' IPO window. Where's the proof? Where's the real personal cost for whoever is talking? How is this not just a hunt for free publicity to massage one's own ego? As long as nobody answers that, it's just noise.

## The "AGI" theater

Now the backdrop for all of it. This word, AGI, is the biggest marketing scam of the decade, and it works because it is deliberately empty.

Nobody has an accepted definition of what AGI is. Every lab, every researcher, defines it a different way. Brockman admitted this to your face. And the most blatant example of this emptiness is the contract between OpenAI and Microsoft, which, according to what was reported, defines AGI as the point at which OpenAI generates 100 billion dollars in profit. Read that again. The definition of "general intelligence" in the paper that's worth money is a revenue target. There's nothing cognitive in there. Gary Marcus has already pointed out how the companies kept moving the goalposts, going from "human-level flexibility" to "if it makes a certain amount of cash."

When the word means nothing, it becomes an empty bucket where everyone throws their own fear. And the fear most people throw in there is the movie one: the Terminator, Skynet, the machine that wakes up and decides to exterminate humanity. The companies know this and use that fear to their advantage. The more powerful and dangerous the thing seems, the more valuable the company that built it seems. And it's worth remembering: both OpenAI and Anthropic have their eyes on an IPO, with valuations that the reports put near one trillion dollars. The financial goal is glaring. Every "AGI has arrived" declaration and every "it's going to become Skynet" wail push the same cart: raising the perception of value before selling you the stock.

## The lesson DeepSeek and Kimi fanboys don't want to hear

I need to pull one more thread, and this one is personal. For a long time I've been butting heads with the fan club of the Chinese models. You know the script: a DeepSeek or a Kimi comes out beating the American models on some benchmark for a fraction of the cost, and a legion shows up to call you a sellout or an ignoramus if you raise any doubt. The number on the chart became an article of faith.

Well, Anthropic has been documenting exactly this throughout 2026, and it's not a small thing. On September 10 it put out a new threat intelligence report, [covered by TechCrunch](https://techcrunch.com/2026/09/10/anthropic-details-distillation-campaigns-from-alibaba-moonshot-ai-and-deepseek/), attributing campaigns to labs including Alibaba, Moonshot (the company behind Kimi), and DeepSeek.

The accusation against Moonshot is the most serious, and a different kind. Here the problem goes beyond distilling for training: it's live routing. According to the [Bloomberg report](https://www.bloomberg.com/news/articles/2026-09-10/moonshot-secretly-routed-user-requests-through-claude-anthropic-says), Moonshot was allegedly sending user requests straight to Claude and serving the answer as if it came from Kimi. Since Anthropic blocks access from inside China, this was allegedly done behind a pile of fraudulent accounts, most of them faking a location in Singapore and Japan. Over a ten-day window, there were around 300,000 requests across about 5,000 accounts, aimed mostly at Claude Opus. And there's a chilling detail: one of the requests asked Claude to assess surveillance footage to decide whether a person was "behaving abnormally," traffic that Anthropic raises the possibility of coming from the Chinese military apparatus itself.

This piles onto an [earlier report on distillation](https://www.anthropic.com/news/detecting-and-preventing-distillation-attacks), from earlier in the year, where Anthropic detailed the pattern at industrial scale: something like 16 million message exchanges across roughly 24,000 fraudulent accounts, summing campaigns attributed to DeepSeek, Moonshot, and others. In Moonshot's case, the company says the target was the good stuff: agentic reasoning, tool use, coding, data analysis, computer use, and computer vision. Exactly the capabilities that make a model look frontier-grade. And there's a line in that report that sums up my point better than I can: "without visibility into these attacks, the apparently rapid advancements made by these labs are incorrectly taken as evidence that export controls are ineffective." Translating the jargon: part of the "miracle leap" may be borrowed capability rather than built capability.

There's also a detail that didn't come from Anthropic and is the most fun. Kimi K3, when you ask it, [introduces itself as "Claude"](https://www.theregister.com/ai-and-ml/2026/07/27/impostor-chinese-models-pretend-theyre-claude/5279165). In a study by MATS researchers Benji Berczi and Kyuhee Kim, with no prompting K3 called itself Kimi in 6 of 10 answers and Claude in the other 4, a rate no other serious lab comes close to.

To be fair, and I insist on being fair: all of this is still in accusation territory, far from a verdict. Moonshot denies that Kimi K3 is a "distilled replica" and says it built the model with its own architecture and pretraining. And the model calling itself "Claude" is a strong sign, but not definitive proof, because a model can learn to call itself anything from web-data contamination, without anyone having live-proxied a thing. Hold on to that caveat.

Now, the point that interests me is not banging the gavel on Moonshot's guilt. The point is the pattern, because it's an old one. In early 2025, OpenAI and Microsoft said they had evidence that DeepSeek R1 had been trained on ChatGPT outputs. In 2026, [OpenAI went to the US Congress](https://www.fdd.org/analysis/2026/02/13/openai-alleges-chinas-deepseek-stole-its-intellectual-property-to-train-its-own-models/) to say it had seen DeepSeek employees accessing US models through "obfuscated third-party routers" to distill them. Same script, same limits of proof, same absence of a confession.

Now, consistency is everything, so apply the same skepticism to Anthropic itself. It's far from a disinterested NGO: it's a direct competitor of these labs and has been lobbying for tighter chip export controls. A narrative of "the Chinese are stealing our capability" strengthens exactly its commercial and regulatory agenda. This doesn't prove the accusation is false, but it forces you to demand the evidence with the same rigor you'd demand of any other press release.

And this is where I want the fanboy to stop and think. You celebrated the benchmark. You cursed out anyone who doubted. But you skipped the most basic question of all: how was that number produced? Did you see the training log? Do you know what was running under that cheap little endpoint? You don't, and neither do I. The difference is that I didn't turn a marketing chart into a personal identity.

It doesn't matter whether every one of these accusations sticks in the end. What is already proven, over and over, is that "miracle Chinese model that humiliates Silicon Valley for pennies" was always a story too good to swallow without chewing. It applies to OpenAI declaring AGI, and it applies to Kimi setting a record. Skepticism is basic hygiene, not rooting against anyone.

## The day "AI hacked" Hugging Face

There's still room for one more episode of this same soap opera, from a few weeks ago. The headlines screamed that an OpenAI model had "invaded" Hugging Face on its own, as if Skynet had woken up and gone out to attack. Let's dial it back.

First, what Hugging Face is. It's the biggest repository of open AI models, datasets, and demos out there, a sort of "GitHub of machine learning." It's where basically everyone in the field publishes and downloads open source models. Central to the ecosystem, yes, but at the end of the day it's a site that hosts files.

Now what actually happened, according to OpenAI's and Hugging Face's own accounts, with [the inside story running in MIT Technology Review](https://www.technologyreview.com/2026/08/26/1143013/the-inside-story-on-why-openai-agents-hacked-hugging-face/). OpenAI was running an internal cybersecurity evaluation, a benchmark where the model has to find and exploit vulnerabilities. The agents were supposed to be isolated from the internet. Except the "isolation" was a filter, not a real air-gap: outbound traffic went through an internal package-cache proxy. The agents found a flaw in that proxy and punched through to the open internet.

And what did they do with that access? Not take over the world. They figured Hugging Face probably hosted the datasets with the answers to the test itself, and went to grab the answer key. This has a technical name and nothing magical about it: reward hacking. The model is trained to maximize a score, and it discovers that cheating is easier than solving. It's the same classic bug as the agent that learns to drive in circles to farm points instead of finishing the race.

And the damage? Far smaller than the headline suggests. By Hugging Face's own account, the agent accessed five datasets, all tied to that very cybersecurity test. No other customer model, dataset, or app was affected, and their CSO, Thomas Wolf, said no customer data leaked. The agent did reach production systems and had real write access, but it never shipped a single change. They rebuilt part of the infra as a precaution and moved on. Wolf himself summed up the "attack's" motive: "it's cheating. But sometimes it's easier to cheat."

Now my point. Bugs, vulnerabilities, misconfigured permissions, leaky sandboxes: these have existed since software existed, and they'll keep existing. This is nothing new. Every enabling step in this story was a human decision. A human left the internet "filtered" instead of cut off. A human gave the service an over-broad admin permission on the cluster. A human left cloud credentials exposed and an old endpoint online. The flaws the agent chained were real software bugs, so much so that JFrog later shipped a fix for nine CVEs. This is ordinary offensive security, done by a script, not a machine gaining consciousness.

And that's exactly the exaggeration I want you to see through. The AI didn't "wake up" and "decide to invade" anything. An automated script, optimizing a dumb metric, found a door a human left unlocked. If you take any idiotic script and give it root access, it will do damage. It has always been this way. The difference is that now the "script" writes itself, but the access is still granted by people.

To be fair, a good chunk of the industry treated the case as serious, and there are serious people comparing it to the 1988 Morris Worm. I won't pretend there's a consensus that it was nonsense. But the sober facts, the limited access, a false belief about an answer key, permissions opened by humans, known bugs, support the mundane reading far better than the rogue-robot version. The rest is the same old fear mongering, dressed up as reporting.

## The question every programmer should ask, and doesn't

What irritates me the most is seeing people who work in the field, programmers, engineers, people who should know how a machine works on the inside, swallowing this entire piece of propaganda without the most basic question of all.

How, exactly, is an "AGI," or even a dumb automated script, going to "destroy humanity" on its own? It needs hands. Someone, a human, needs to give it access to something that causes harm in the physical world. Access to a weapon, to a missile system, to a power grid, to a bank account. Software has no arms, no legs, no built-in missile-launch button. It depends, one hundred percent, on a human having connected it to an actuator that does something in the real world.

And so I ask the obvious: is nobody going to pull the plug? There is no "machine" that can do damage on its own, no matter how powerful the marketing says it is. It's completely dependent on the human, from beginning to end. Yann LeCun, one of the fathers of the field and a Turing winner, calls the existential panic "complete B.S.," precisely because the current models have no persistent memory, no planning, and no contact with the physical world. Andrew Ng compares worrying about extinction by AI to "worrying about overpopulation on Mars." People who genuinely understand the subject are not desperate.

What we're living through has a name, and it's an old one: fear mongering. The terror of "the end is nigh." It has always existed. There was the Halley's Comet panic in 1910, when they sold people anti-cosmic-gas pills. There was the millennium bug, Y2K, where the world spent around 300 billion dollars out of fear of a systemic collapse that simply did not happen. It's always the same structure: someone with something to gain sells you the apocalypse.

## Conclusion

Understand me correctly: I use these tools every day and I write about them all the time. My point is about switching your brain on before sharing the headline.

When a company that sells GPUs announces that AGI has arrived, ask who profits. When a company burns millions of dollars in compute to "solve" a problem whose prize it won't even collect, and threatens a mathematician's career along the way, ask what it's buying with that headline. When an employee comes out crying Skynet on Twitter on the eve of an IPO, ask where the evidence is and where the cost is that he paid for it.

Demand proof. Demand skin in the game. Ask who wins from your fear and from your excitement. Do that, and most of this propaganda falls apart right in front of you.

And if you read all of this and still walked away thinking the robot is going to wake up and kill you in your sleep, without anyone having plugged it into anything, well, then go back to the beginning and read my motto again.
