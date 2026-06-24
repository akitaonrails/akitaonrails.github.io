---
title: "Why LLMs Will Fail at Your Company"
slug: "why-llms-will-fail-at-your-company"
date: '2026-06-24T12:00:00-03:00'
draft: false
translationKey: why-llms-will-fail-at-your-company
tags:
  - ai
  - llm
  - agents
  - agile
  - scrum
  - productivity
  - programming
  - vibecoding
---

This post is more speculation than a finished thesis. I am thinking out loud. It may be incomplete. It may be wrong. If you disagree, even better: reply in the comments. I am not trying to sell a new methodology. I want to poke a wound that many people are pretending is not there.

In the last few months, we started seeing stories about large companies burning absurd amounts of tokens on AI tools without being able to point, clearly, to the matching product value. The most famous case was [Uber burning through its annual AI budget in a few months](https://www.forbes.com/sites/janakirammsv/2026/05/17/uber-burns-its-2026-ai-budget-in-four-months-on-claude-code/) with heavy use of tools like Claude Code, while executives admitted they still could not draw a straight line between token consumption and value delivered. It is not that nobody used the tool. They used it too much. That is exactly the problem.

By now, I think most people understand that a one-line prompt solves nothing. The fantasy of typing "build me an Uber clone" and coming back to a finished product died quickly. The market response was to run in another direction: **spec-driven development**.

Instead of asking for everything in one sentence, you write a specification. Scope, use cases, acceptance criteria, desired architecture, constraints, flows, maybe even a full PRD. Then you hand that to the agent and expect it to implement with less ambiguity.

Is that better than one-shot prompting? Of course. I still think it is wrong.

## The problem is not lack of specification

I have been hammering this idea for years, long before LLMs became fashionable. Two of my videos matter for this point: [Don't Outsource Your Decisions](/2019/10/09/akitando-63-nao-terceirize-suas-decisoes-a-licao-mais-importante-da-sua-vida/) and [Forget Agile Methodologies](/2019/06/18/akitando-51-esqueca-metodologias-ageis-rated-r/).

> The summary is simple: most professionals were trained not to decide.

Think about your own routine. Many people do nothing if there is no backlog ready. They cross their arms, blame management, blame colleagues, blame customers, and wait for someone else to say what should be done. When the task arrives, they execute. When it goes wrong, the requirement was bad. When the customer complains, the priority was wrong. When the product degrades, the process was to blame.

Almost nobody really decides, commits to the decision until the end, and suffers the consequences. Without suffering the consequence, you never learn how to decide.

You do not learn which choices lead to which results. You do not learn how to prioritize. You do not learn how to explain why something needs to exist. You do not learn how to write a specification because you understand the problem; you learn how to fill a template so nobody complains.

## Agile became structured bureaucracy

The original 2001 principles were crushed. What many companies call Agile today is bureaucracy in shorter cycles.

Everybody knows the classic drawing: backlog, sprint planning, sprint, daily, review, retrospective, next sprint. The [Scrum Guide](https://scrumguides.org/scrum-guide.html) describes the formal events. Diagrams like the [Scrum process on Wikimedia](https://commons.wikimedia.org/wiki/File:Scrum_process.svg) show the pretty circle. In practice, many teams turned it into theater.

An entire day is spent debating what goes into the backlog. The final backlog is rarely what actually needs to be done. It is the consensus of least resistance. Compromise after compromise. Small tasks, small risks, small wins, small failures. Everything designed to avoid too much conflict.

That is not merely mediocre. It is worse: it is the active choice for easy decisions, the kind that will not bring too much criticism your way.

Then the team spends days or weeks implementing that lukewarm backlog. QA comes in, finds problems, tries to fit corrections into the next round. A few more days, maybe two more weeks. A month later, maybe two, the original decision finally starts to show results in production.

But the result is so far away from the decision that almost nobody makes the connection. The team does not feel the real weight of what it decided. The error does not become learning. The process does not improve. The most important part of any continuous improvement system, **kaizen**, never happens.

> Something else happens instead: everybody learns to stay invisible.

You learn to please management, not the product. You learn to reduce friction, not solve the problem. You learn to survive the meeting, not deliver value. And when results get worse, upper management reacts in the usual way: more control, more rules, more gates, more committees, more checklists. The machine gets heavier. The team gets more cowardly.

## Then AI arrives

Now the LLM enters the room.

Until recently, the biggest bottleneck in software development was writing and adjusting code. Coding took days or weeks. That is why so much energy went into planning. If the team is going to spend two weeks implementing, spending a day arguing about what goes into the sprint feels reasonable.

But coding tools with LLMs change where the bottleneck sits. They can do a large part of the manual work: generate structure, write basic tests, refactor, adapt APIs, create screens, fill boilerplate, try fixes. It is not perfect, but it is fast enough to change the economics of the process.

It is the old chain and weakest-link problem. You strengthen one link, another one starts limiting the system. Before, the weak link was coding speed. Now, increasingly, it is the human ability to decide, explain, test, and review.

> The mistake companies make is putting LLMs inside the same broken process and expecting multiplicative gains.

You take people trained for years not to decide, give them a tool that requires clear decisions, and then act surprised when garbage comes out faster.

## The LLM reflects the user

A coding agent needs you to explain the goal, the context, the constraints, the priorities, what must not break, which paths are acceptable, and how success should be measured. It needs direction.

Now go interview your team. Ask each person:

- what is the real goal of what you are doing?
- how does this improve the product?
- which metric should move?
- what trade-off are you accepting?
- what must not break?
- which unhappy paths need to be tested?

Many people cannot answer. They know which ticket they picked up. They know they need to close a few tasks per week. They know there is a daily tomorrow. They do not know why the work matters.

Then you give that person an LLM.

The result is not magic. It is a mirror. Bad code ten times faster. Bugs ten times faster. Angry customers ten times faster. Giant pull requests ten times faster. The problem is not only AI. AI amplifies the lack of direction.

Spec-driven development tries to fix this with documentation. But if the specification is born from the same cowardly process, it only documents the cowardice. A PRD written by someone who does not understand the decision is still bad. Acceptance criteria written to avoid conflict still dodge the real problem. The agent will execute a bad decision better.

## The process has to change

My hypothesis is that the whole process has to be redesigned around the new constraint. Again: speculation. I do not have enough data to prove it. But looking at the kind of failure I see in companies, and the kind of success I see in intense individual use, my theory is this:

> **throw away the sprint ritual as the central unit of work.**

It makes no sense to keep days of planning, days of review, and weeks of coding as if the bottleneck were still the same. With LLMs, the cycle needs to be shorter. Much shorter. Ideally, inside the same day.

In my ideal setup, each programmer with an LLM should pair directly with a Product Manager for short blocks of work. The PM's job is to close the gap the programmer usually has: goal, priority, constraint, business context, expected result. That needs to enter the prompt and the conversation with the agent.

But because coding is no longer the main bottleneck, the PM does not need to wait two weeks to see a result. They can sit with the programmer for a morning, implement a small functional slice, adjust on the spot, decide on the spot, cut scope on the spot. Then the PM rotates to another programmer.

Then QA comes in. Not as a distant phase, but as pairing inside the same cycle. QA closes another common gap: testing only the happy path, forgetting error cases, not automating enough, not thinking about behavioral regression. QA's job becomes helping turn the implementation into something verifiable now, while the context is still hot.

Then the Tech Lead comes in. Also on the same day, not two weeks later. They look at what changed and close the third gap: unnecessary complexity, poor design, hidden regression, missing documentation, obvious vulnerability, performance getting worse, coupling that did not need to exist.

Build, check, adjust. In real time.

<figure>
  <a href="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/06/24/why-llms-fail/llm-pairing-rotation-en.svg">
    <img src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/06/24/why-llms-fail/llm-pairing-rotation-en.svg" alt="Diagram comparing the common sprint flow, where decisions are far from results, against a rotating LLM pairing flow with PM, programmer, QA and Tech Lead on the same day." />
  </a>
  <figcaption>The bottleneck changes: less time waiting for a sprint to end, more short cycles of decision, implementation, testing and review.</figcaption>
</figure>

## The new role of each person

This model demands more responsibility, not less.

The programmer stops being the person who only picks up tickets. They need to learn how to turn a goal into executable instruction. They need to discuss trade-offs. They need to understand why they are coding. They need to use the LLM as a tool for execution and investigation, not as an excuse to turn the brain off.

The PM stops being a backlog factory. They need to decide with the programmer, looking at the live product. This is not writing a card and disappearing. It is watching the thing come to life, adjusting it, cutting it, prioritizing it, and accepting the consequence.

QA stops being the person who receives the package at the end and returns defects. QA enters early to turn expected behavior into verification. If the LLM accelerates code, QA needs to accelerate learning about risk.

The Tech Lead stops being a late PR stamp. They enter while change is still cheap. They help keep things simple, remove complexity, protect architecture, documentation, security, and performance.

None of this works if everybody keeps using AI as expensive autocomplete inside the same bureaucratic Scrum.

## Why companies will not like this

Because this process exposes decisions.

In the current process, the decision dissolves. It was the backlog. It was the PM. It was refinement. It was the sprint. It was the team. It was a dependency. It was the customer changing their mind. Everybody can hide.

In a short LLM cycle, the decision appears quickly. You said this was the priority? Then implement it now. You said this was the acceptance criterion? Then test it now. You said this design was good? Then review it now. If it is wrong, the consequence shows up the same day.

That is uncomfortable. But that is how you learn.

Without nearby consequence, decision becomes theater. With nearby consequence, decision becomes training.

## How to implement this without burning money

The first step is accepting something professional programmers usually hate: you can throw code away.

> In fact, you should throw code away much more often.

Code is not a monument. Code is working material. Deleting code is as important as writing new code. That is why we use Git. The idea was always to work in branches, try paths, change our minds, compare alternatives, delete what did not work, and keep only what survived contact with reality.

But in the traditional process, code becomes too emotionally expensive. If it took two weeks to produce, nobody wants to admit it was waste. The manager feels that deleting it proves the previous decision was bad. The programmer defends the implementation because they suffered to make it. The team pushes the problem forward because deletion feels like defeat. It is not. Sometimes it is hygiene.

With LLMs, that cost changes. **Making mistakes becomes cheap**. Prototyping becomes cheap. Building a proof of concept becomes cheap. Trying two paths and throwing one away becomes cheap. Asking the agent to rewrite an entire approach in a temporary branch, compare it, document what was learned, and `git reset` without drama becomes cheap.

So do more of that. More prototypes. More proofs of concept. More internal A/B tests. More disposable branches. Less attachment to the first code that appeared. LLMs are good at this kind of work: exploring alternatives quickly, showing where the specification was vague, and producing material you can destroy without guilt.

But do not expect everyone to receive LLM tokens on Monday and know how to do this alone. That is the fastest way to burn the budget and then say AI does not work.

My suggestion is the opposite: assume one or two weeks with no planned delivery. Say clearly that the goal is not to ship a feature. It is to train the new process. Break the old ritual. Let the team practice in a safe environment. If it goes wrong, fine: reset the branch, delete the prototype, document what you learned, try again.

In that phase, the PM should not write a twenty-page spec. They should pair with the programmer and build small prompts, one step at a time, watching the result in real time. With each LLM response, the PM learns how much detail the code actually needs. The programmer learns to ask better questions. QA learns to turn behavior into tests early. The Tech Lead learns to cut complexity while it is still cheap.

This is how LLM adoption has some chance of working: as a process change, not as an expensive autocomplete license.

## The uncomfortable conclusion

> LLMs fail so often because they are inserted into processes made by people who were trained not to decide.

It is not just lack of a better prompt. It is not just lack of a larger spec. It is not just lack of token governance. Those things help, but they do not touch the center of the problem.

The center is that many people do not know how to explain a measurable goal, prioritize, accept a trade-off, or connect decision with result. An LLM needs exactly that to be useful.

If you put AI into the old process, you accelerate the old process. More mediocre backlog. More bad decisions. More bugs. More cost. More rework. More reports trying to prove productivity the customer never felt.

If you want LLMs to work, redesign the process around them. Smaller cycles. Real pairing. Decision close to execution. Testing close to decision. Review close to code. Result close to whoever decided.

This is the part programmers need to face: yes, you probably never learned how to decide properly. You never learned how to describe a goal objectively. You never learned how to measure consequence. The process trained you that way. Now AI is revealing the failure.

The good news is that you can train the opposite.

But it will not happen with another ceremony, another prompt spreadsheet, another AI usage policy, or another sprint full of tickets written so nobody gets criticized.

**It will happen when you stop outsourcing decisions.**
