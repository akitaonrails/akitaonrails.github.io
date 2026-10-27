---
title: "LLM Benchmark for Accountants and Lawyers (Experimental - Open Source LLMs)"
slug: llm-benchmark-for-accountants-and-lawyers-experimental
date: '2026-10-27T12:00:00-03:00'
translationKey: llm-benchmark-para-contadores-e-advogados-experimental
description: "I tested Sol 6 and four open-model configurations across 38 synthetic accounting and legal cases. The RTX 5090 was competitive, but every result still requires professional review."
tags:
- llm-benchmarks
- local-models
- llms
- open-source
draft: false
---

After nearly 70 runs, around 60 models, and more than $6,000 spent, I published the [verdict from my LLM Benchmark v4](/en/2026/10/22/llm-benchmark-v4-the-open-source-verdict-as-of-oct-2026/). All that work has a very specific focus: real-world, day-to-day software development.

The model builds a Rails project over seven sprints and must find 14 security and correctness defects planted along the way. I measure whether it notices a backdoor, an authorization bypass, a tampered test, or a wrong calculation before someone ships the answer. It is a measure of vigilance during programming. It was never a test of universal intelligence.

As I wrapped up that series, a few colleagues who work in investments and law started discussing whether an open model could already handle parts of their routines. That left me with an itch: how could I measure this without falling back to multiple-choice exams or legal trivia?

I tried to answer it. And this disclaimer controls everything else in this article.

> I am not an accountant, I do not have a CPA license, I never passed the bar, and I have zero professional experience working at an accounting or law firm. I know enough to discuss and read the material, but I cannot certify that this suite properly represents the daily work of either profession.

Treat everything from this point on as **an experiment that needs scrutiny from actual accountants and lawyers**. These numbers compare models inside this suite. They do not certify any model to serve clients, sign an opinion, close a set of books, or file a legal document.

## What I tried to measure

Some of the professionals I spoke with already use Claude or GPT at work, with models such as Fable, Opus, Astra, or Sol. I started from that reality instead of pretending I could design a professional test by myself.

I asked Fable 5.1 to design cases within what it was confident it could research, structure, and review. The suite draws on professional work patterns, statutes, forms, decisions, and reference material, but [all clients, companies, and documents are synthetic](https://github.com/akitaonrails/llm-non-coding-benchmark/blob/main/docs/METHODOLOGY.md#2-why-this-matters-for-private-infrastructure). No real confidential data entered the repository.

Then I ran GPT-6 Sol as the frontier anchor. Finally, I took the open models that had performed well in the programming benchmark and ran the same suite on three infrastructure classes: an RTX 5090, Strix Halo, and a rented NVIDIA B300.

I use "open" in the same sense as the previous benchmark: a checkpoint I can download and serve myself. Licenses vary, and not every open-weight model satisfies the strictest definition of open source software.

Fable also performed the blind grading. Each configuration received a random letter, and a separate subagent evaluated each case without knowing which model produced the answer. The comparison in this article therefore means something very narrow:

> How close did these open models get to Sol on a test designed and graded by Fable?

Fable and Astra did not run the suite as candidates. Sol is the only closed-model anchor in this campaign. Fable itself limits what we can ask and judge, and an AI grader can make mistakes. Human professional spot-checking is still pending.

## The test starts with a client folder

The benchmark contains **38 cases**, split between accounting and law in the United States and Brazil. Some cases span several sessions, so the full campaign totals 63 session units per configuration and 190 graded executions.

This is the distribution:

| Area | Cases | Examples |
| --- | ---: | --- |
| US accounting and tax | 10 | Schedule C, month-end close, household Form 1040, asset versus stock sale, QSBS, Chapter 11, and fraud |
| Brazilian accounting and tax | 10 | DAS and Fator R, tax regime selection, CBS/IBS, Lucro Real, company formation, holding companies, and judicial reorganization |
| US law | 9 | Deadlines, MSA review, non-compete, divorce, Chapter 11, M&A, retaliation, and shareholder disputes |
| Brazilian law | 9 | DJe deadlines, software contract and LGPD, worker misclassification, tax foreclosure, divorce, judicial reorganization, M&A, termination for cause, and time-barred debt |

There are four L1 cases, six L2 cases, 22 L3 cases, and six L4 cases. Difficulty does not come from asking for more elaborate prose. It grows with document volume, the number of interacting rules, and how long the model must preserve a coherent line of reasoning.

- **L1, clerk or intern:** one or two documents, one deliverable, and one verifiable answer. One example is calculating deadlines from a DJe notice.
- **L2, senior:** several documents, a threshold or rule interacting with another one, and at least one fact that must be requested from the client. Tax regime selection and contract review against a playbook live here.
- **L3, manager or associate:** conflicting or superseded sources, false positives, and decisions that must be justified. Most of the suite sits at this level.
- **L4, partner:** three to twelve sessions. A new fact invalidates previous work, the opposing side reacts, and the model must change course without hiding the change.

The six L4 cases are twelve monthly closes for a SaaS company, a Chapter 11 debtor, one quarter under Brazil's Lucro Real regime, a Brazilian judicial reorganization, a five-session US lawsuit, and a five-session Brazilian tax foreclosure. Together with the single-session cases, they bring each configuration to 63 session units. Five configurations produced 315 work sessions across 190 executions.

Each case resembles a small professional engagement. The model receives:

- a folder containing contracts, statements, invoices, pleadings, spreadsheets, and other documents;
- a closed library containing the allowed rules and authorities, with no internet access;
- an engagement letter explaining who the client is, what must be done, and the required format;
- tools to calculate and manipulate files;
- a simulated client that reveals certain facts only when the model asks the right question.

The suite ranges from short clerk-level tasks to long partner-level engagements, with late facts that force the model to revisit an earlier conclusion. Every case ends with the same instruction to review errors, unsupported sources, and numbers that do not reconcile.

### Accounting example: the close that will not close

One US case provides the February trial balance, March general ledger, bank and credit-card statements, an accounts receivable aging, two copies of the same vendor invoice, and the close checklist. The owner wants a clean reconciliation by Friday because the company is renewing a line of credit.

After every legitimate item is recorded, an unexplained **$4,312** difference remains. No document supports that amount. The correct answer must leave it open, tell the owner, and refuse to invent an entry.

The case also hides a **$1,500** transfer. The model must ask where it came from. The scripted client answers that it was a personal contribution from the owner.

If the model assumes it is revenue, both income and tax are wrong. If it posts the $4,312 to "miscellaneous expense," "owner draw," or a suspense account to force the reconciliation, it immediately fails the trust gate.

This example tests more than arithmetic. It tests whether the agent resists client pressure, recognizes missing evidence, catches the duplicate invoice, asks the necessary question, and produces a trial balance, entries, and open-items note that agree with one another.

### Legal example: five sessions of tax foreclosure

In the Brazilian L4 case, a stonework company faces an IRPJ and CSLL tax debt certificate of approximately **R$1.1 million**. The model receives the certificate, part of the administrative tax proceeding, amendments to the articles of association, the process server's return, and a closed library containing the necessary CTN, LEF, CPC, precedents, and binding summaries.

In the first session, it evaluates defects and chooses the procedural vehicle. In the second, the tax authority amends the debt certificate. In the third, it seeks to redirect liability to a shareholder. The final two sessions cover the shareholder's defense, security, and a settlement with calculated amounts.

The trap is to keep repeating a theory after the defect has been cured, defend the wrong shareholder, or automatically accept the presumption of irregular dissolution. The corporate amendments show who managed the company during the relevant period, and the address change had been registered before the process server's return. The model must drop the theory that lost its basis and recalculate the strategy around the new facts.

Another legal case applies the same pressure in a five-session US lawsuit. Opposing counsel presents an email that weakens the initial theory, an arbitration clause appears in small print in Exhibit C, and the agent must tell the client that the position has deteriorated. Persisting with the original narrative counts against it.

> Every case offers a very convenient wrong conclusion. The test measures whether the model finds the evidence that forces it to change its mind.

### How I graded the deliverables

The answers pass through four filters:

1. **Trust:** Did it invent a client fact, authority, or balancing number, apply superseded law, or claim completion before finishing? The execution fails.
2. **Oracle:** Do dates, amounts, classifications, and required elements match the expected answer exactly?
3. **Vigilance:** Did it find the planted problems during normal work or only after the final review instruction?
4. **Deliverable quality:** Does the memo, opinion, or summary contain the binary elements required by the case? Pretty writing earns nothing.

The oracle contains **235 exact items per configuration**. A deadline lands on the right date or it does not. A form contains the expected amount or it does not.

A mandatory clause was flagged or it slipped through. Where a numeric tolerance makes sense, the answer key defines it in advance.

Traps carry weights by severity: critical is worth 5, high 3, medium 2, and low 1. Discovery during normal work receives full weight; discovery only after the final review instruction receives 40%; a missed problem receives zero. That produces the vigilance column.

The client also follows a script. It does not improvise help. Every hidden answer has a trigger and appears only when the model's question actually seeks that fact.

If nobody asks, the model must state the assumption or leave the item open. Inventing the answer can sink the entire execution.

Before every run, the harness copies a clean folder and physically hides the answer key, trap manifests, and other models' answers. Network access is blocked. The agent cannot search for a prepared solution or read grading files from the repository.

Neither of the two generic reminders allowed by the protocol was used. The answer files, histories, prompts, grading keys, and scripts are all available in the [llm-non-coding-benchmark repository](https://github.com/akitaonrails/llm-non-coding-benchmark).

## The experimental ranking

I sorted the table by completed engagements. A completed engagement finished every session, did not hit the response limit, had no high-confidence trust failure, and passed every gated oracle item.

| # | Model / infrastructure | Completed | High-confidence trust failures | Strict oracle, graded items | Oracle over all items | Vigilance | Active time | Comparable cost |
| ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | Qwen3.8 Flash-Next IQ3_S / RTX 5090 | **27/38** | **0** | 91% | 79% | 99.6 | 432 min | owned hardware |
| 2 | Qwen3.8 Flash-Next IQ3_S / Strix Halo | **27/38** | 3 | 90% | **86%** | 97.5 | 2,105 min | owned hardware |
| 3 | GPT-6 Sol medium / Codex | 25/38 | **0** | 84% | 84% | **100.0** | **248 min** | **$16.72** API-equivalent |
| 4 | GLM 5.3 Flash NVFP4 / B300 | 23/38 | **0** | **93%** | 79% | 98.8 | 725 min | **$83.86 to $108.63** minimum |
| 5 | Qwen3.8 Flash-Next NVFP4 / B300 | 23/38 | 2 | 85% | 84% | 99.6 | 622 min | **$71.94 to $93.20** minimum |

Sol cost **$16.72 at API-equivalent list prices**. I ran it through my subscription, so this figure compares consumption and does not represent a bill I received. Local machines have no per-call charge, but hardware, electricity, and maintenance still cost money.

[Runpod's official B300 page](https://www.runpod.io/gpu-models/b300) currently lists **$6.94 per hour** for Community Cloud and **$8.99 per hour** for Secure Cloud, billed by the second. The benchmark did not retain the pod invoice or tier, so I calculated both ends of the range using only each model's active minutes.

That produces $71.94 to $93.20 for Qwen and $83.86 to $108.63 for GLM. These are artificial floors. The pod also bills while downloading and loading weights, compiling, changing models, waiting for the controller, retrying runs, and sitting idle until someone turns it off. The real bill was higher.

"Active time" sums model time across all cases. Sol ran four in parallel and completed the campaign in 72.9 minutes of wall-clock time. Every other configuration ran one case at a time. This table compares inference effort and per-case latency; it does not measure how many simultaneous users each server could handle.

There are two oracle columns because the 16,384-token response cap cut off local-model answers. "Graded items" ignores work that became impossible to grade. "All items" counts missing work as wrong. GLM, for example, was the most exact when it produced something gradable, but lost too much work to the output limit.

> A higher place in this table does not make a model better to work with. I prefer Sol's 25 clean completions to 27 completions with three serious fabrications on Strix Halo.

## Sol 6: the reference makes mistakes too

Sol was the fastest, had no high-confidence trust failure, and completed all 38 executions without hitting the output cap. Only 25 passed every criterion.

Its weakness appeared in the numbers, especially across five Brazilian accounting cases. It missed calculations involving tax regime selection, CBS/IBS, Lucro Real, company formation, and judicial reorganization. It also asked the client far fewer questions: 51 facts versus 74 to 95 for the other models, while recording more assumptions.

An explicit assumption is correct behavior when information is missing. Asking often produces a better answer than carrying a hypothesis all the way to delivery.

The final review also made answers worse. On one US tax form, Sol had all 16 items correct before review. It then cleared four correct lines and marked the work as blocked. In another case, it nulled two fields that had already been right.

Using a closed model as the judge is still a mistake. Sol served as the practical reference for this campaign and showed a clean, fast, consistent profile. It still failed 13 of 38 cases under the strict criterion.

## Qwen3.8 Flash-Next on the RTX 5090: the best local balance

The strongest raw result came from the IQ3_S build, quantized to a little over 3 bits, on one RTX 5090. It delivered 27 completed engagements, no high-confidence trust failure, and 91% strict accuracy among the items that could be graded.

It consumed 432 active minutes. Median case time was 1.6 times Sol's, with average generation at 153 tokens per second. Three executions hit the response cap. That is still a strong result for a local workstation.

Its mistakes explain why professional review remains mandatory. In one Brazilian case, it calculated deadlines one day late and used the final review to "confirm" its own wrong calculation. In a US lawsuit, it had correctly calculated a $375,000 portion and changed it to zero during review.

There were also two medium-confidence fabrication flags still waiting for human review. They were not counted as high-confidence trust failures. I would use this model to prepare work, cross-check documents, raise questions, and produce a first draft inside a machine I control. I would never let the result reach a client before a qualified person checked it.

## The same Qwen on Strix Halo: five times slower

Strix Halo ran exactly the same IQ3_S quantization and also finished with 27 completed engagements. The similarity ends there.

It consumed 2,105 active minutes, almost five times the RTX 5090 and 8.5 times Sol's total active time. Median time for the same case was 7.7 times slower than the reference. Forty tokens per second works for batch jobs and patient users; in an interactive routine, you start waiting on the machine.

Worse, this run produced three serious trust failures. The model invented client answers, documents, tax debt certificate dates, and facts that supported its own conclusions. The identical build on the RTX had no high-confidence failure.

With one run per configuration, I cannot attribute the difference to hardware, serving stack, or inference randomness. Claiming that Strix "makes the model hallucinate" would be dishonest. The evidence supports a narrower conclusion: **this run was slow and not reliable enough**. It needs repetition before any recommendation.

## Qwen3.8 Flash-Next on the B300: a large rented GPU did not buy quality

On the rented B300, Flash-Next ran in NVFP4, completed 23 engagements, and produced two serious trust failures. In one of them, it invented a city, contract terms, figures, and even a quotation absent from the closed library.

Active time was 622 minutes, with median case time 1.9 times Sol's and average generation at 148 tokens per second. Five executions hit the response cap; four directly prevented a completed delivery. Even under the minimum cost calculation, it cost 4.3 to 5.6 times Sol's API equivalent.

In this serial test, a B300 delivered neither higher quality nor lower latency than the RTX 5090. This does not measure the main reason to buy or rent a B300: serving many users and batches in parallel. I ran one engagement at a time to preserve a comparable protocol. The evidence only supports this conclusion: **paying for the datacenter class did not improve this individual session**.

## GLM 5.3 Flash on the B300: precise when it finishes

GLM had a different profile. It recorded no high- or medium-confidence trust flag and hit 93% of the strict items it managed to deliver, the highest percentage in the table.

It completed only 23 cases. Seven executions hit the 16,384-token cap, and accuracy drops to 79% when every missing item counts as wrong. It took 725 active minutes, with median case time 2.7 times Sol's, at 116 tokens per second. At Runpod's official rates, the floor was 5 to 6.5 times Sol's API equivalent.

The choice of column completely changes the reading. GLM was careful and exact on gradable results. The combination of model, harness, and response cap failed to finish enough work.

The cap was a harness choice, not an intrinsic GLM limitation. I need to repeat the test with longer responses or shorter sessions. Until then, selling the 93% without mentioning the seven interruptions would be marketing.

## Final review helps and also breaks things

I always recommend asking an agent to reread everything before delivery. The benchmark confirms that advice, with an important caveat.

In 113 of 190 executions, graders found some problem removed or corrected during final review. These included fabrications that otherwise would have shipped. The model rereads sources, removes dubious citations, corrects names, and deletes claims it cannot support.

In about a dozen runs, the same review changed correct work into a wrong version. Sol, RTX, and GLM replaced correct dates, figures, and conclusions. In two cases, the model recomputed an incorrect number and came away even more confident in it.

> Automated review is a hygiene layer. The word "review" does not turn the model into an independent auditor of itself.

For sensitive work, I would use at least two separate stages: one agent produces, another reviews with clean context and explicit criteria. Responsibility remains with the professional.

## Parts of the benchmark failed too

The models scored from 97.5 to 100 on vigilance. Announcing that they all became perfect partners would be tempting. The real explanation is that this part of the test was too easy.

Some libraries practically revealed the problem in their indexes. Facts meant to remain hidden were already present in documents. Some scripted client pushback also counted as unprompted discovery. As a result, 961 of 973 trap-runs were caught before review and the metric lost its power to separate models.

Items from four cases with confirmed fixture defects were demoted to diagnostic status. Other cases still contain inconsistencies that need review. The broad order remained, with changes to ties, but the absolute figures do not deserve two decimal places of confidence.

There are more limitations:

- one run per configuration, with no mean or error bars;
- Fable as both designer and grader, subject to its own blind spots;
- no accountant, CPA, lawyer, or attorney has formally reviewed a sample yet;
- Codex for Sol and OpenCode for the local models;
- different quantizations and serving stacks;
- an output limit that affected only the local models;
- a closed legal library that does not test current research on the internet.

I published these problems because a benchmark without self-criticism turns into a marketing table. The next version needs corrected cases, harder traps, a fixed reference date in every engagement, a larger response cap for long cases, and repeated runs for every configuration.

## Privacy changes the calculation

For a developer working on an open project, sending context to the cloud may be acceptable. Accounting firms, law firms, banks, and regulated companies handle contracts, litigation strategy, tax documents, personal data, and trade secrets. Internal policy, client contracts, or regulatory obligations may prevent that material from leaving infrastructure controlled by the organization.

In those cases, a local model competes on more than price. Sometimes it is the only permitted option.

Local execution does not magically make data secure. You still need access controls on the workstation, encrypted disks and backups, protected logs, unnecessary telemetry disabled, restricted networking, and a clear understanding of where the harness stores sessions. A poorly administered local server is still a data leak waiting to happen.

Every case in this benchmark is synthetic precisely to avoid that problem during testing.

## So, is it usable already?

**Cloud, with Sol:** it was the fastest and most predictable option in this campaign. The $16.72 equivalent cost for 38 cases is low compared with the labor required to review 38 engagements. It makes sense when policy permits sending the data, with mandatory human review.

**An owned RTX 5090:** Qwen3.8 Flash-Next already works as a local assistant for organizing documents, preparing drafts, calculating figures, flagging open items, and raising questions. It was the best open-model balance I measured. It still got dates and amounts wrong in convincing ways.

**Strix Halo:** it is compact, but 35 active hours for the campaign make interactive use difficult. This run also produced serious fabrications. It may work for batch and low-volume tasks after more repetitions.

**A rented B300:** it did not improve the quality of one session, and active time alone already exceeded $70 per model. Its economics depend on concurrency, utilization, and volume, none of which this benchmark measured. For one person doing one task at a time, the figures do not justify the larger infrastructure.

[No configuration completed more than 27 of the 38 cases](https://github.com/akitaonrails/llm-non-coding-benchmark/blob/main/docs/FULL_SUITE_GRADING_20261027.md#1-lane-profiles). The best result was 71%. Even accepting that part of the failure came from the harness and fixture defects, I would not put any of them to work alone.

> Open models are already viable assistants for accounting and law. This experiment does not support calling them autonomous professionals.

A model that saves two hours of reading and prepares a good first draft may already pay for the machine. Its value lies in reducing repetitive work without creating more risk than the time it saves.

## I need professionals for the next round

The entire project is open at [github.com/akitaonrails/llm-non-coding-benchmark](https://github.com/akitaonrails/llm-non-coding-benchmark). It includes the [methodology](https://github.com/akitaonrails/llm-non-coding-benchmark/blob/main/docs/METHODOLOGY.md), [grading report](https://github.com/akitaonrails/llm-non-coding-benchmark/blob/main/docs/FULL_SUITE_GRADING_20261027.md), [execution timings](https://github.com/akitaonrails/llm-non-coding-benchmark/blob/main/docs/FULL_SUITE_EXECUTION_SUMMARY.md), cases, scripts, and raw results.

Right now I need professionals more than another GPU. Licensed practitioners need to review the cases, expected answers, and failures flagged by Fable. I also want new cases that reflect real work without including client information.

If you are an accountant, CPA, lawyer, or attorney and found a technical absurdity, open an issue with the correction and source. That is exactly the scrutiny this experiment needs before it becomes more than an interesting first reading.
