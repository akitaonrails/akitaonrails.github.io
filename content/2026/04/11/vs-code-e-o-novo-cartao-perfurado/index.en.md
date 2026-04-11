---
title: "VS Code Is the New Punch Card"
date: '2026-04-11T12:00:00-03:00'
draft: false
slug: vs-code-is-the-new-punch-card
translationKey: vs-code-is-the-new-punch-card
tags:
  - ai
  - llm
  - opinion
  - programming
description: "In the era of coding agents, typing everything by hand in VS Code is becoming the modern equivalent of a punch card. Foundations did not become legacy."
---

Every time someone asks whether juniors are going to stop learning how to program because LLMs can write code for them, I have the same reaction: you're asking the wrong question.

You're confusing **code input** with **software engineering**.

Those are not the same thing. They never were.

There was a time when programming meant knowing how to convert numbers into binary in your head and jam instructions straight into memory addresses, bit by bit, by hand. There was a time when programming meant knowing how to organize a punched-card deck, knowing whether the deck order was right, knowing where one bad hole wrecked execution, and knowing how to debug visually without the modern fantasy of infinite backspace. There was a time when real programming meant knowing 6502, Z80, and Assembly because computers had so few resources that every byte actually mattered, not as a figure of speech.

![Altair 8800, symbol of the era when programming still meant physical panels and manual instruction entry](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/altair-8800-computer.jpg)

*Front panel and switches: before editors, before IDEs, before comfortable terminals.*

Then compilers got better. C showed up. Machines got fatter, consoles moved into the 32/64-bit era, PCs got more decent, and Assembly stopped being the center of everything. It became what it should be: a low-level tool, local optimization, critical routines, bootstrapping, drivers, that sort of thing. Nobody serious looked at that transition and said, "well, that's it, programming is over because the compiler writes machine instructions for you now."

The 21st century brought the Web and shoved an entire generation into HTML, CSS, and a pile of markup bureaucracy that adds very little intellectual value while demanding a ton of manual labor just to get it mostly right. I still think the industry dragged that model out way too long. For way too many years, programmers became glorified form operators, CRUD assemblers, `div` aligners, priests of front-end frameworks that all do the same thing with slightly different syntax.

Then the 2010s bubble made it worse.

I've already written about that in [RANT: Did AI Kill Programmers?](/en/2026/02/08/rant-ai-killed-programmers/) and also in [37 Days of Vibe Coding Immersion](/en/2026/03/05/37-days-of-vibe-coding-immersion-conclusions-on-business-models/). The startup bubble, cheap money, and the hiring frenzy produced a legion of very bad programmers, coming out of two-month bootcamps and sketchy online courses promising Google salaries with no foundation, no education, and no depth. The market spent a decade pretending that was normal. It wasn't. Same story as always: lots of volume, little value, and a whole lot of people confusing inflated employability with actual competence.

And when the layoffs started in 2022, that did not come out of nowhere. I spent years warning that the bubble would pop. It's all there in the playlist [EU AVISEI](https://www.youtube.com/watch?v=wpPv1dJWjDs&list=PLdsnXVqbHDUehzKjiRruy--gncHz9Injy&pp=sAgC). The message was always the same: once the cheap money dried up, the bar would go back up, and the only people with a real shot would be the ones who had made the effort to actually learn Computer Science. The next economic cycle was always going to be less about hiring volume and more about efficiency. That's exactly what happened.

## What really changed

LLMs went mainstream at the end of 2022. That's true. But mainstream is not the same thing as useful for serious work.

Throughout 2023 and 2024, I was already using AI to write code. Did it work? Sure, it worked. But it was still full of nonsense: too many hallucinations, too many agent loops, context getting lost too easily, tooling breaking too often, too much cost for too little reliability. It was useful for experienced programmers who knew how to keep the thing on a leash. It still wasn't a mature tool for day-to-day heavy lifting.

For me, the turn came at the end of 2025. That's when the combination of better models, prompt caching, decent tool calling, inference optimizations, context windows that were actually useful in practice, and above all real agent interfaces made the whole thing stop feeling like conference-demo theater and start feeling like an actual work tool.

That was the point where Claude Code, Codex, OpenCode, and the rest stopped being "autocomplete on steroids" and became a different category of interface.

To me, Claude Code is already the new terminal. The editor has moved into the background.

I talked about that in [Migrating my Home Server with Claude Code](/en/2026/03/31/migrating-my-home-server-with-claude-code/), too. I simply have no patience left to burn attention on Linux shell busywork when the problem is mundane: installing a server, bringing up and organizing Docker services, hardening a firewall, reviewing security rules, tuning kernel parameters, auditing `dmesg`, digging through systemd logs, that kind of thing. I let Claude do the heavy lifting, and I review direction and risk. Ironically, my Linux machines have never felt more stable, faster, or more robust.

Today, if you spend your day building software, going back to the raw combo of text editor plus terminal and doing everything manually starts to feel like regression. Not because typing became impossible. Of course not. I've been typing code for decades. The problem is something else: it became a waste of attention.

If I can describe an intent, ask an agent to inspect the codebase, edit twenty files, run tests, compile, fix the fallout, and bring me back a proposed change in minutes, why exactly am I supposed to feel nostalgic about hand-typing boilerplate inside VS Code?

I don't.

And this is where a distinction a lot of people still don't get matters. You should not use a coding agent like some dumb editor extension, the kind of thing where you say "generate this file here" and then spend the next half hour micromanaging every line in a tiny corner pane. That's using a Ferrari to go buy bread around the block. The big gain does not come from treating Claude Code, Codex, or similar tools like glorified autocomplete inside VS Code. The gain comes when you drop the editor-operator mindset and start treating the agent like an actual pair programmer.

Instead of acting like a professional typist, you move up a level. You act more like a tech lead, product owner, QA, manager of the flow. You define intent, explain context, demand criteria, ask for a plan, ask it to run tests, ask for refactors, ask for alternative approaches, ask it to review its own change. You leave the manual code labor to the agent and use your own brain to judge direction, priority, risk, and quality.

But there is a balance there, and I've already covered it in other Agile Vibe Coding posts. You do not hand over the wheel and let the LLM `git push` everything blind. And you also don't swing to the opposite extreme and turn into a comma cop, nitpicking every tiny detail until the agent becomes one more layer of bureaucracy and kills the speed advantage. Both extremes are bad. In one, you outsource responsibility. In the other, you strangle productivity.

The right point on that pendulum is somewhere else: use XP and actual engineering discipline to sustain the speed. Continuous refactoring. Tests. CI. Review. Fast feedback. Small code. Incremental change. That's exactly what I documented in posts like [From Zero to Post-Production in 1 Week - How to Use AI on Real Projects](/en/2026/02/20/zero-to-post-production-in-1-week-using-ai-on-real-projects-behind-the-m-akita-chronicles/) and [Software Is Never 'Done'](/en/2026/03/01/software-is-never-done-4-projects-life-after-deploy-one-shot-prompt-myth/). The 10x multiplier does not come from model magic. It comes from the model plus a sane process.

![Modern coding-agent interface, representing the shift from the traditional editor to an intent-driven, execution-assisted workflow](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/cursor-homepage-crop.png)

*The interface changed. The need for judgment did not.*

## VS Code is the new punch card

That's what the title means.

VS Code did not "become bad." That's not the point. Punch cards weren't "bad" in their own historical context either. They were a massive step up from toggling bits by hand or rewiring a board. The point is that they were the mechanism of their era for feeding instructions into the machine.

![Punched-card deck, from an era when the profession demanded more discipline in preparing input than comfort in the interface](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/punched-card-program-deck.jpg)

*VS Code is not the enemy. It's just becoming the input mechanism of the previous era.*

Today, text editors are becoming that again: an input mechanism that still works, will still be around for a long time, but is no longer the center of the activity.

If you've never looked at those older eras of computing, I already went through it in [Akitando #86 - The Turing and Von Neumann Computer](/2020/10/23/akitando-86-o-computador-de-turing-e-von-neumann-por-que-calculadoras-nao-sao-computadores/):

{{< youtube id="G4MvFT8TGII" >}}

And if you want a refresher on why 6502, Z80, and old machines forced a different kind of discipline, go back to the [Hardcore Guide to Computing Fundamentals](/2020/06/04/akitando-80-o-guia-hardcore-de-introducao-a-computacao/) and [Learning About Computers with Super Mario (Hardcore++)](/2020/06/18/akitando-81-aprendendo-sobre-computadores-com-super-mario-do-jeito-hardcore/). That wasn't old-man nostalgia. It was there to show that in every era the interface changes, but the machine still demands precision.

![Thumbnail from Akitando #80, part of the series built to teach computing fundamentals through the 6502 and the microcomputer era](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/akitando-80-6502.jpg)

*This is what a good part of Akitando existed for: teaching what still holds when the fashionable tool changes.*

And it's worth remembering something a lot of people forget: the 146 videos on [Akitando](https://www.youtube.com/@Akitando), more than 96 hours of material, were built precisely to teach this kind of foundation to Computer Science students, juniors, and people trying to stop being framework button-pushers. I recorded all of that because I could already see the industry pushing too many people toward manual busywork and not enough understanding. Ironically, now that agents are here, that archive is more relevant than ever.

The interface changed again.

First you needed to know how to type the instruction.
Then you needed to know how to organize the deck.
Then you needed to know how to convince the compiler.
Then you needed to know how to stitch together frameworks, HTML, CSS, YAML, CI, containers, cloud, ORMs, queues, observability, and fifty other layers of junk.

Now you need to know how to **orchestrate an agent**.

And again, that does not eliminate foundations. It only changes where the manual labor ends and the intellectual work begins.

## "So we don't need Computer Science anymore?"

Quite the opposite.

Now you need it more.

Someone with no foundation looks at an agent issuing a `SELECT * FROM table`, sees the thing working locally against 300 fake rows, and assumes everything is fine. In production the query pulls a million rows, blows memory, degrades latency, backs up a queue, congests connections, and the person has no clue why "it works on my machine" but melts in production.

That's the real problem.

The agent does not know your system's context the way an experienced engineer does. It doesn't know which tables are going to grow tenfold next quarter. It doesn't know which endpoint needs to answer in 80 ms and which one can take 2 seconds. It doesn't know which flow needs a transaction, which one needs idempotency, which one needs a pessimistic lock, which one needs async compensation, which one needs auditing, which one can never leak sensitive data.

It may get the syntax right.

But syntax was never the hardest part.

I already said that in [RANT: Did Akita Bend Over for AI??](/en/2026/02/24/rant-akita-caved-to-ai/): what AI is really good at is removing the mundane work. And thank God for that. I did not get into computing to become an IDE operator. I have no romantic attachment to formatting HTML, fighting CSS, assembling the same old CRUD, gluing one more framework onto an old stack, or writing the same pile of infrastructure code for the hundredth time when any decent machine should be able to produce that by now.

So what is left after that mundane layer disappears?

Exactly the part that separates amateurs from real programmers:

- domain modeling
- architecture
- trade-offs
- performance
- scalability
- security
- observability
- maintainability
- readability
- operational cost
- product decisions

All of that still exists. All of that is still hard. All of that still depends on judgment.

## The mistake people make when they think programming was typing

Some people genuinely think that if the machine writes the code, then the need to understand software is gone.

That is the same stupidity as thinking the compiler killed the need to understand computers.

It didn't.

It only killed the need to write everything in Assembly.

And thank God for that too.

Same thing here: coding agents do not kill the need to understand software. They kill the need for you to be a syntax typist.

And good riddance.

There is a nice irony here too: for years the industry sold the fantasy that programming meant "learning a framework." Then it sold the fantasy that programming meant "learning React." Then it sold the fantasy that programming meant "learning the stack of the month." Now it's going to sell the fantasy that programming means "learning prompt engineering."

It doesn't.

Prompts are an interface.
Frameworks are an interface.
IDEs are an interface.
Punch cards were an interface.

Programming is still the act of instructing a machine to compute something useful under real constraints.

People who understand that survive every tool shift.
People who don't become operators of whatever the trendy tool is, and when the trend changes, they go down with it.

## What I think is going to happen to juniors

So let's answer the original question properly.

Juniors are not going to stop learning.

But they are going to have to learn **something else**.

If the junior of 2015 could spend years hiding ignorance behind low-value manual tasks, tweaking views, adjusting CSS, assembling dumb endpoints, copying Stack Overflow snippets, and making it all look like "productivity," that hiding place is going away.

The junior of the agent era is either going to level up faster or get exposed faster. There isn't much middle ground.

If they use agents and actually study fundamentals, they'll be able to test hypotheses faster, read more code, compare more solutions, iterate more, make mistakes earlier and fix them earlier. They'll learn more in less time.

But if they use agents without foundations, all they'll do is outsource their own ignorance. They'll become reviewers who cannot review. They'll accept patches they do not understand. They'll approve decisions they do not know how to measure. They'll confuse "passed locally" with "ready for production."

That kind of professional is dangerous.

Far more dangerous than the old junior who was at least limited by their own speed.

## The post-bubble world

The good news is that this comes right after the collapse of the dumbest phase of the hiring bubble.

It's past time for the market to stop rewarding labor-intensive stupidity as if it were competence. It's past time to stop treating stack bureaucracy as technical depth. It's past time to stop confusing commit volume with engineering value.

If the new era wipes out a good chunk of that theater, great.

In a post-bubble, post-miracle-bootcamp, post-CSS-as-a-career, post-CRUD-as-a-profession world, foundations go back to being what they should always have been: the main asset.

People who understand operating systems, databases, networking, data structures, compilers, computer architecture, profiling, debugging, concurrency, consistency, security, and cost will use agents as an exoskeleton.

People who understand none of that will use agents as a crutch.

An exoskeleton amplifies strength.
A crutch only tries to hide weakness.

## "But this isn't sustainable"

There is always someone with the same excuse: "well, I don't think this is sustainable, the data centers can't keep up, the prices are too heavily subsidized, there's no way this can keep going like this."

And to be fair, that person is not entirely wrong.

It just doesn't change a thing about what I have to do tomorrow morning.

This kind of concern might be great for bar talk or an X thread, but it doesn't help me decide anything useful. Me, you, none of us are going to sit down with Anthropic or OpenAI leadership and redesign data-center capex, renegotiate power contracts, decide subsidy margins, or plan the next GPU generation. There is no concrete action for us that comes out of this besides repeating that "someday this will be a problem."

It's the same mindset as the person in the 1990s saying, "let's not use the internet too much, it's too slow, the limits are too low, the price per kilobyte is absurd, better wait until someone fixes it." Or the person in the early 2000s looking at mobile data and saying, "2G is too slow, too limited, better not depend on it." Why exactly would you want to be that person?

Thank God OpenAI, Anthropic, and the rest are fighting like hell and heavily subsidizing this race. I'm taking full advantage of it. I've already burned through my entire Claude Max 20x, already hit the extra-usage ceiling, already burned through my Codex plan, and upgraded to Pro so I can keep using it this weekend. People paying a monthly subscription and barely touching it are, in practice, subsidizing me to use as much as I can. I have no intention of slowing down. Why would you?

If prices change tomorrow, if infrastructure gets tighter, if the game changes, then I reassess tomorrow. That's how technology has always worked. While the window is open, the rational move is not to slow yourself down in advance. The rational move is to learn as much as possible, extract as much as possible, and build an advantage while everybody else is busy explaining why they still haven't started.

## The decision is still human

At the end of the day, nothing that matters actually changed.

Someone still has to look at the result and decide:

- can this go to production?
- can this handle load?
- is this readable?
- is this secure?
- is this maintainable?
- does this fit the rest of the system?
- does this solve the right problem?

If the answer is no, someone still has to know **why** it's no.

More importantly, someone still has to know **how to fix it**.

That's why, in the age of agents, foundational knowledge did not become less important. It became more expensive to be wrong without it.

VS Code is the new punch card.

Not because it became useless.

But because we're finally entering an era where the act of typing code by hand stops being the center of the profession.

And honestly? About time.

> **AI reflects who you are.**
>
> If you're good, it accelerates good code.
>
> If you're bad, it accelerates technical debt at industrial speed.
>
> AI is not going to take a bad programmer and turn them into a good one. It never did, it doesn't, and it won't.

That's why foundations matter more now than they did before.

The agent can write. You're still the one who has to know whether what it wrote is any good.
