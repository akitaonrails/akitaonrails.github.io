---
title: "I Self-Published My Own Book/e-book: Competent Enough"
slug: "i-self-published-my-own-book-ebook-competent-enough"
date: '2026-10-13T19:00:00-03:00'
draft: false
translationKey: auto-publiquei-meu-proprio-livro-ebook-competente-o-suficiente
description: "I published my book about AI, for free, in EPUB and PDF: the blog's 131 posts from 2026, almost half a million words, reorganized into 20 chapters, 6 appendices, a glossary and almost 300 references. This text is the technical backstage: the inventory with a hash per post, the contract every agent read before writing, the parallel drafts, the invisible per-paragraph marker that ties the book to the blog, the checker that fails a chapter with an error, what the fact-check caught wrong in my own posts, and the Quarto, Typst and Pandoc pipeline that generates everything. It's a preview: open an issue if you find a mistake."
tags:
- artificial-intelligence
- coding-agents
- open-source
---

I just published my own book about artificial intelligence. It's called *Competent Enough*, subtitled "A year putting artificial intelligence to the test, without fear and without propaganda", and it's free, in EPUB and PDF, to read on your phone, PC or Kindle. The official page is [here](https://ailair.akitaonrails.com/book/), and the [repository](https://github.com/akitaonrails/ai-book-2026) is public.

[![Competent Enough, the book, in 3D](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20261013190000_book-competent-enough-3d.png)](https://ailair.akitaonrails.com/book/)

The book consolidates almost everything I wrote about AI on this blog from February to October 2026: all the experiments, the Frank projects, the benchmarks, billions of tokens spent and hundreds of hours of work over eight months, reorganized into a format that's easier to read than a pile of dated posts. It came out in Portuguese and in English.

> **Important notice:** this is a *preview*. The book is still in progress and new versions will come out until I consider it done. If you find anything wrong, from a typo to a fact, [open an issue on GitHub](https://github.com/akitaonrails/ai-book-2026/issues). The trail I describe below exists precisely so that the fix reaches the right paragraph.

This text is about the technical backstage. How you turn 131 blog posts, written over months, with opinions that changed along the way, into a book with a beginning, middle, end, appendices, glossary and bibliography. And how you do that with agents without losing control of what the book says.

## What's inside

Five parts, each answering a question people keep asking me:

1. **What is this thing, anyway.** Is it intelligent? Is AGI coming?
2. **The marathon.** Does it actually work, or is it all demo?
3. **Numbers and propaganda.** Which AI is best? Can you believe the announcements?
4. **Who keeps the keys.** Is it dangerous to let it touch my things?
5. **And my job?** Will it replace me? What comes next?

That's 20 chapters and two interludes, plus a preface, a "how to read", a "before you start" saying what the book doesn't explain and where to learn it, an epilogue and an afterword. Then come six appendices (the machine inside without math, a timeline, a minimal kit for using agents safely, ai-memory, how to read a benchmark or an announcement, the year's projects), the sources, the image credits, a glossary of 146 terms and almost 300 references in ABNT style. The print edition has 467 pages at 6 by 9 inches; the screen edition, around 445. There are almost 50 figures, all with a provenance record.

The audience is different from the blog's. The book was written for people who are anxious or confused about AI: the professional afraid of being replaced, the parent who read that AGI is two years away, the manager being sold an "AI transformation". Most of them don't program. That changes the voice, and I'll come back to it.

## The problem: half a million words that disagree with each other

On October 12 I published [the year's synthesis](/en/2026/10/12/llms-agents-competent-enough/), which became chapter 20. On the 13th I started the book. I had 131 posts from 2026 on the blog, almost half a million words, from model benchmarks to a bitcoin wallet.

Reorganizing that by hand would take months. And there's a worse problem than volume: I changed my mind during the year. I redid the benchmark several times, corrected costs, switched tools, and a February post contradicts a September one with complete naturalness. A book that simply pasted the posts in order would be a book that contradicts itself.

So I did what the whole book describes: I handed the grunt work to coding agents and kept the part of deciding, building the process and checking. The process is the subject of this text.

## Step 1: a sealed inventory

The first thing was a script that reads the 131 posts and records, for each one, the SHA-256 hash of the Portuguese file and of the English file, plus the exact commit of the blog repository everything was read from. If a comma changes in a post, the hash changes with it. That file is machine-generated and never edited by hand.

Then an agent read each post and filled out a fixed form, with a schema defined in YAML: the thesis in one or two sentences, the claims a book would need to verify, which of them age fast, which lay reader's fear the text answers, what to cut. Each analysis carries the hash of the post it came from.

Of the 131 texts, 96 had AI as the central subject or with relevant weight. The others only came in when they taught something specific, and every AI post left out has its reason recorded in the structure file. A script fails the structure if any AI post is left without a destination.

### Lineage: who supersedes whom

To solve the contradiction problem, there's a lineage map. It says which post superseded which, what can still be salvaged from the older one, and which corrections coming from the reference projects (the benchmark repository, ai-memory's, ai-jail's, my home server notes) apply to each text.

The rule for chapters is to tell the most recent state and, when the change teaches something, tell the change. "In June I thought X; in July the numbers said Y" is a story. Printing the old number as if it were current is an error, and the checker treats it as an error.

## Step 2: the structure is data, and it generates the configuration

From the analyses came a proposed structure: five parts, each answering a reader's fear, twenty chapters, two interludes. I read it, changed it and approved it. Some pieces came in at my request, like the "before you start" and the appendix on the machine inside.

That structure lives in a single YAML file, and it's the source of truth. Each chapter has its id, title, opening scene, the question it answers, the arc, the list of source posts and the figure ideas. The Quarto configuration, which assembles the book, is generated from that file by script. Nobody edits the configuration by hand.

This matters because structural change is where a book breaks. Midway I moved the cut-off: the January posts went out, and the story settled between February and October. Ten posts vanished from the base.

Three chapters needed a new scene, a dozen units needed small repairs, and the damage that's hard to see was elsewhere: a sentence in an untouched chapter saying "the five reviewers from chapter 5", the timeline, the projects appendix, chart labels, every translation. That's why there's an impact script that, before any edit, lists every paragraph, figure, reference and translation that depends on a post.

## Step 3: a pilot chapter becomes a contract

Before scaling, a pilot chapter. I picked chapter 5, about the first ten percent of a project, and it served to calibrate the voice and discover the doubts an agent would have along the way. Each doubt resolved became a written rule.

Those rules went into a contract document every agent reads before writing, along with three things:

- the book's voice guide, which inherits the blog's rules (my WRITER.md, the humanizer and my finishing checklist) and only adds what changes when the text leaves a dated post and goes into a book a lay reader holds in their hands;
- a continuity file, saying which chapter explains each concept and what each character is called, so nobody explains "context window" five times;
- the entire structure, so each agent knows what the other chapters cover.

Besides the voice rules that already existed (a chapter opens on a scene with a date, a place and something at stake, never on a definition; it closes on a hook toward the next one, never on "in this chapter we saw"), some of the rules that came out of the pilot, to give you a taste:

- when the chapter brief and the post disagree on a detail, the post wins;
- the chapter that owns a concept explains it properly; if the term shows up earlier in reading order, it gets a half-sentence gloss and a pointer, never a second explanation;
- a fact verified online gets a citation even if the original post had no link;
- model and product names in the vendor's spelling, even when the blog abbreviated them.

> It's the project instructions file I describe in the chapter about how to talk to the machine, at the scale of a book. Anyone who has written an AGENTS.md for a codebase recognizes all of it.

## Step 4: parallel drafts, contradictions expected

With the contract ready, the chapters were drafted in parallel, one agent per chapter, in two waves: parts I and II first, then III through V, so the later chapters could build on the earlier ones. Each agent received its chapter's brief, the analyses, the full posts, the lineage and the reference-project files it needed.

Agents working at the same time contradict each other, and that happened. One chapter said FrankMD had around 130 commits in three days; another, that it had 212 in 19 days. Both numbers came from the posts and were right, they were just different windows. An integration ledger collected those conflicts, and the rule became making the window explicit in each chapter.

After the drafts comes the integration pass, with another set of agents, each owning a group of chapters and forbidden from touching the others. Their job: apply the conflict ledger, cut concepts explained twice, check that every callback matches what the other chapter actually says, make sure the last paragraph of a chapter leads into the first of the next, and redo the fact-check assuming the draft is wrong.

To read the seams, the build generates a "seams" file: the final paragraph of each unit next to the opening paragraph of the next. It's the fastest read there is for finding where the book stops feeling like one book.

## Step 5: an invisible marker per paragraph

This is the part I find most useful in the whole project. Every paragraph of the book, in the source file, carries a comment saying where it came from:

```markdown
<!-- src: 2026/09/28/llms-sao-boas-em-reproduzir-o-que-existe-e-coisas-novas -->
Every LLM was trained only on what is public...

<!-- src: original -->
New text, written for the book.

<!-- src: ref:ai-jail/README.md -->
Fact checked in the reference project.
```

The marker disappears when the book is built, through a Pandoc Lua filter, so the reader never sees it. It exists for maintenance. I edit posts after publishing all the time, and the book has to follow.

The `rake drift` command redoes the inventory, compares the hashes, and lists the chapters that depend on a post that changed, with the post's diff since the commit at which the book last read it. The marker leads straight to the paragraphs that came from that post, and only those need review. Once resolved, a script records the new hash and the commit.

A real example, from today. I removed from the [reverse engineering post](/en/2026/10/13/ai-reverse-engineering-is-adobe-dead/) a paragraph about a Linus Tech Tips video. `drift` flagged chapter 19 and one appendix; the diff showed that passage had never been used in the book; two commands later, both were stamped with the new hash. Without the marker, I'd have had to reread two chapters to discover I didn't need to change anything.

The bibliography plays the same role for external sources: each reference records which post cited it. And each image has its own provenance record.

## Step 6: what the fact-check caught

Every number, date and name was checked against three oracles: the posts, the reference projects and primary sources online, with the same adversarial checker prompt I use on the blog's articles. The full list is in the book's afterword, and a good part of the corrections are to my own blog:

- in the March review of the Strix Halo mini-PC, I had set aside 96 GB of memory for the GPU; in April I lowered it to 64, and later posts still said 96. The book uses 64 for everything after April;
- a counting bug in one of the benchmark's tools undercounted by 40 to 90 times the cost of runs made on it before August. The book cites none of those costs;
- in the June text about Claude Fable 5, I wrote it cost ten times more than Opus 4.8 per run. Redoing the math in July, with cache-read tokens included, Fable cost almost double. The post still says ten times; the book tells the wrong number and the correction;
- in a March text, I wrote that Anthropic had bought Bun at the end of 2024. The announcement is from December 2025;
- a chapter summary, written by an agent, said Claude Code's subscription lock fell in less than a day after the leak. The announcement came about 30 hours later, and the book says "the next day".

> The drafts came out fast. Confidence in the text came from the checking. And the source beats the summary, even when the summary comes from the machine.

## Step 7: a chapter with an error doesn't pass

On top of everything runs an automatic checker, the equivalent of continuous integration. They're Ruby scripts, standard library only, chained in a Rakefile, plus what they call externally: the chart checker is Python because it lives inside matplotlib, the page audit uses poppler, and epubcheck needs Java:

- a **chapter linter** fails em dashes, phrases banned by the voice guide, loose URLs in the middle of prose, unknown citation keys, paragraphs without a provenance marker, and warns about overlong paragraphs;
- a **doctor** checks that every cross-reference, citation, glossary term and figure exists, that provenance matches the inventory, that no post before the cut-off leaked in, that translations are up to date, and runs a callback heuristic: a sentence pointing at another chapter using names that chapter no longer contains;
- a **page audit** opens the finished PDF and looks for blocks split across pages, headings orphaned at the foot of a page, nearly empty pages, oversized images, lines overflowing the margin;
- a **chart checker** looks for labels that spilled out of their boxes;
- **epubcheck** validates the EPUB 3;
- a **style report** for copyediting: passages repeated across chapters (an inevitable consequence of posts that repeat the same thesis from different angles), recurring phrases, overused words, term variants, badly formed comparatives in Portuguese.

And the scripts have tests. A suite of more than 140 tests builds a fake book in a temporary directory, with five fake posts in a fake git repository, and checks that each tool catches the problem it should catch. When a bug is fixed, the test that would have caught it goes in, with a comment naming the regression it guards. It runs in CI before every build.

## The assembly pipeline

The toolchain is Quarto, which bundles Pandoc and Typst, version-pinned inside the repository. No LaTeX. A single `rake build` produces, from the same tree of Markdown files:

| Output | For what |
| --- | --- |
| EPUB 3 | Kindle, Kobo, Apple Books, any reader |
| Screen PDF | reading on a computer or tablet, with the cover |
| Print PDF | 6 by 9 inches, blank versos, chapters opening on the right |
| HTML | web edition |
| DOCX | for an editor who wants Word |

Portuguese and English are Quarto profiles, generated from the same structure file. Citations come from a YAML in CSL format shared by both editions, with an ABNT style adjusted for Portuguese. The glossary is a Lua filter: each term is marked in the source where it appears, and the filter links the mark to the entry, expands the acronym the first time and generates the page.

Typst solved something I thought would cost me weeks: a PDF that looks like a typeset book, Portuguese hyphenation, ligatures, without the pain of TeX. The page audit after the build catches what the engine let through, and a `rake fit` recompiles while tightening chapters that end on a nearly empty page.

### The figures

Every figure is code or has a record. Charts and box-and-arrow diagrams are matplotlib scripts, 43 of them, each with a note of the chapter the data came from, and with the labels in Portuguese and English inside the script itself: the same chart comes out in both languages. The path for D2 diagrams exists in the repository, and no figure in the book needed it.

The conceptual illustrations were generated by AI, with the model, the prompt and the date of each one recorded in its credit record, and the book discloses it. The rule I imposed on myself: no AI-generated image of a real person. Real people only appear in freely licensed photos, with the credit in the caption.

The cover is the retro-futurist robot with the weary face, kneeling at a 1950s World's Fair, studying its own hand while the crowd watches. The prompt to the model described the scene to hold three fears at once: the end of humanity, losing your job, the machine becoming conscious. The cover's record keeps the whole prompt. The face is Marvin's, my newsletter's character, and a sticker with my face sits beside the name.

## The tricks of turning posts into a book

Turning a blog into a book is a list of mechanical conversions, and each one has a catch:

- **A link becomes a citation.** Every external link became a bibliography entry, and the sentence has to stand without the link. A link to another post of mine became a cross-reference to the chapter that now covers it, or disappeared. Never a URL in the prose.
- **"Today", "yesterday", "last week", "update:"** became absolute dates. The book will be read in 2028 too.
- **Model versions, prices, benchmark scores** stayed as dated snapshots ("in September 2026, the best..."), and when a later post superseded the number, the book tells the change instead of printing the old number.
- **Code dumps, install steps, terminal screenshots** were cut. At most a 3-to-8-line excerpt when the code is the point; the step-by-step went to an appendix.
- **Post titles, which are made for search** ("Vibe Code: I built X in two days"), became short literary titles, with the subject in the subtitle.
- **Repetition across posts**, the same thesis from many angles, is said once, in the right place, and later chapters build on it.
- **Calls to action, "subscribe", "comment"**, cut.
- **The sharp edge aims at the propaganda, never at the reader.** The post "You're an idiot if you believe..." became a chapter about how the ads work. The reader who believed the ad is the person the book wants to help.
- **Every technical term is explained once**, at its first appearance in the book, and goes to the glossary.

And the most important of all: the book reads like a first-person story, with the year as its spine. Information arrives when the narrative needs it, instead of following encyclopedia order. That's the opposite of how a blog is written, and it was the rule that gave the agents the most trouble.

## The English edition

The English edition, *Competent Enough*, only started after I approved the Portuguese one. Each translated unit records the hash of the Portuguese file it came from, and wherever the book follows a post of mine that already had an English version on the blog, the translation uses my own English wording instead of translating again.

`drift` also works per language: if I change a paragraph in Portuguese, it flags the English unit that went stale, and only the marked paragraphs are retranslated. Charts with text are regenerated in English from the same scripts, and the English cover is composed by script on top of the same art.

## Releasing is pushing a tag

A release is a CHANGELOG entry and a `git push` of a `vX.Y.Z` tag. A GitHub Actions workflow runs the tests, builds both editions in every format, validates the EPUB, runs the audit and publishes the release with the files. It deletes every release except the two newest, and keeps the tags. That's how the official page always points at the current version.

The repository is public, and that brought its own catch: my home server notes are the source of some facts, and they're private. The provenance markers cite those files by alias, the alias map stays out of git, and a pre-push hook blocks any file or commit message containing a private repository name, host or IP.

## Copyediting: what the checking machine lets through

Lint, doctor, page audit and tests catch structural problems. They let through what a book written by many agents, each seeing a few chapters, always suffers from: the same sentence or anecdote reused in three chapters, drifting tone, inconsistent terminology, agreement slips. For that there's a copyedit procedure, which runs once per version, in three steps from the cheapest to the most expensive.

**Step 1, mechanical and nearly free:** the style report I mentioned above. Sequences of seven words or more that appear in more than one unit, meaning reused sentences and retold anecdotes; set phrases of four to six words used in many chapters, which are nice as callbacks and become tics when they repeat; a word used far more in one chapter than in the rest; term variants ("e-mail" and "email", "Open AI" and "OpenAI"); and an agreement heuristic for Portuguese. The report is a worklist, and nothing changes on its own.

**Step 2, the straight-through read:** one read-only agent per part of the book, each reading its units in order, start to finish, with a shared style sheet (names, spellings, terms, recurring phrases from step 1). Each produces a ranked report, editing nothing: typos and grammar first, then inconsistencies with the style sheet, repetition the reader would notice, passages a lay reader would stumble on, and pacing only in the worst cases. A script validates the reports, checks that every quoted passage really exists in the unit, numbers the items and summarizes.

Then comes the triage, done by me with an editor agent, and the pointed application of each approved item, under the same rules as the integration pass. A cheaper model does the proofreading; hard passages go to the strong model. Rough budget: two to three million tokens per language.

The most important rule of that step is "facts get checked, not asked". Any item that turns on a number, date, name or tool behavior is settled by the editor against the source of truth before it reaches me: first the post pointed to by the paragraph's provenance marker, recomputing totals; then the code or data behind the claim, in my repositories; then public records.

When two sources disagree, the task is to find out why. "653 commits in 8 projects" versus "692 in 4" were two cuts of the same work, one of them without the newsletter's private repository, and the text now states its scope instead of picking a number. When the blog post itself is wrong, the book prints the correct figure and the error goes to a blog errata list, for me to fix at the source.

Only what no source can settle reaches me: an unpublished fact, intent ("is this ironic?"), a preference about a cut or a title, and a contradiction between two statements of mine with no record to break the tie. Each question comes with what was checked and what was found.

**Step 3, my own read.** The last and the most valuable. The notes go into the same cycle of apply, check and propagate to the English edition.

The first round of that copyedit is what separates preview 2 from preview 3, released tonight. Among what it caught: commit counts now state their scope, a "more than a thousand" that summed to 984, the Frank Investigator voting example that didn't match the code (figure redrawn), the David Sacks and Pirate Wires quotes in chapter 14 verified against the originals and corrected, Sam Altman's photo swapped for one from 2025. And in the English edition, a reader pass of its own after the re-sync: Portuguese calques rewritten, glossary terms used consistently, American quotation punctuation throughout.

## What remains mine

The repository records the first commit and the draft of every chapter on the same day, October 13. Those are the first ten percent, the ones that impress and say almost nothing about the rest. The other ninety percent are reading, cutting and correcting, and that part is mine. No chapter goes in without me reading and approving it, and what I send back to be redone goes through the same process.

Any of the good models of October 2026 would have written similar drafts, because the model became a commodity. What made the process work was what surrounds it: the inventory, the written contract, the automatic checker, the sources as oracle, the per-paragraph trail. It's the same old software engineering I defend in every chapter, applied to text.

> The agents were competent enough to write the draft. Deciding what it said remained my job.

And, once again: making a book with AI isn't a "write me a book" prompt and done. I had to invent the whole process and steer the agent to create every piece of it: the scripts, the tests, the consolidation of the posts, the narrative strategy, the goals, what stays and what goes, the copyedit, the fact-checking, the automated release. You need to know exactly what you want, and then the AI helps a lot. Whoever doesn't know what a book publishing process involves won't make a real book, and showing that was one of the goals I had when creating this example.

## Download it, read it, and tell me where I was wrong

Both editions, in three formats each, straight from GitHub, no sign-up. This is version 1.0.0-preview.3, from today:

| Edition | EPUB (Kindle, Kobo, Apple Books) | Screen PDF | Print PDF (6 × 9 in) |
| --- | --- | --- | --- |
| Competent Enough (EN) | [EPUB](https://github.com/akitaonrails/ai-book-2026/releases/download/v1.0.0-preview.3/Competent-Enough.epub) | [PDF](https://github.com/akitaonrails/ai-book-2026/releases/download/v1.0.0-preview.3/Competent-Enough-ebook.pdf) | [PDF](https://github.com/akitaonrails/ai-book-2026/releases/download/v1.0.0-preview.3/Competent-Enough.pdf) |
| Competente o Suficiente (PT-BR) | [EPUB](https://github.com/akitaonrails/ai-book-2026/releases/download/v1.0.0-preview.3/Competente-o-Suficiente.epub) | [PDF](https://github.com/akitaonrails/ai-book-2026/releases/download/v1.0.0-preview.3/Competente-o-Suficiente-ebook.pdf) | [PDF](https://github.com/akitaonrails/ai-book-2026/releases/download/v1.0.0-preview.3/Competente-o-Suficiente.pdf) |

The latest version, always, lives on the [book page](https://ailair.akitaonrails.com/book/) and on the [GitHub releases](https://github.com/akitaonrails/ai-book-2026/releases).

It's a preview. There will be mistakes, and the process above exists so they get fixed in the right place. Found one, [open an issue](https://github.com/akitaonrails/ai-book-2026/issues).
