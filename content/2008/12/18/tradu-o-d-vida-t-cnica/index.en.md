---
title: 'Translation: Technical Debt'
date: '2008-12-18T01:55:00-02:00'
slug: tradu-o-d-vida-t-cnica
tags:
- off-topic
- principles
- career
- management
draft: false
translationKey: technical-debt
---

I came to know **Steve McConnell** many years ago, first through the books [After the Gold Rush](http://www.stevemcconnell.com/gr.htm) and [Software Project Survival Guide](http://www.stevemcconnell.com/sg.htm). Many people know him more from [Code Complete](http://www.stevemcconnell.com/cc1.htm). Last year he wrote an excellent article on the subject of **Technical Debt**. While discussing this topic recently, I decided to revisit this text and translate it. Again, after years of experience I'm still surprised that this is yet another concept that few people discuss — and everyone keeps making the same mistakes over and over.

First of all, the concept of "Technical Debt" is a metaphor indicating that every time you take a technical shortcut (the good old _"it doesn't matter if it comes out messy, what matters is shipping the product fast!"_), it doesn't come for free. Every time we do this, it's like taking out a loan at a bank — it's like taking on debt. And like all debt, this one also accrues interest and will one day be duly collected!

Extremists often say _"pay everything upfront, because credit cards are evil."_ That's not true either. Loans can be good and important. What merchant has never had a cash flow crunch where a small loan gave them some breathing room? The problem, as always, is excess — like the compulsive buyer who pays one credit card with another! Many companies behave exactly this way with software: they take on hundreds of debts and then after a few years are shocked by the accumulated amount owed.

And you: have you taken on technical debt recently? Are you prepared to start paying it off? Here is my translation of the [original article](http://blogs.construx.com/blogs/stevemcc/archive/2007/11/01/technical-debt-2.aspx) by Steve:

_Note: this is Akita's adaptation and translation of Steve McConnell's original article._


## Technical Debt

The term "technical debt" was coined by Ward Cunningham to describe the obligation that a software organization incurs when it chooses a design or construction approach that is expedient in the short term but which increases complexity and is more costly in the long term.

Ward didn't explain the metaphor very deeply. The few people who have discussed technical debt seem to use the metaphor mainly to communicate the concept to technical teams. I agree that it's a useful metaphor for communicating with technical teams, but I'm more interested in the metaphor's incredible and rich ability to explain a critical technical concept to non-technical project stakeholders.

## What Is Technical Debt? Two Basic Types

_The first type of technical debt is the kind incurred unintentionally._ For example, a design approach turns out to be error-prone or a junior programmer simply writes bad code. This technical debt is the non-strategic result of **poor work**. In some cases this type of debt can be incurred unknowingly — for example, your company might acquire another that has accumulated significant technical debt that wasn't identified until after the acquisition. Sometimes, ironically, this debt can be created when a team stumbles in its efforts to **rewrite** an indebted platform and unintentionally creates more debt. Let's call this general category **Type I** debt.

_The second type of technical debt is the kind incurred intentionally._ This typically happens when an organization makes a **conscious decision** to optimize for the present rather than the future. _"If we can't ship on time, there won't be a next release"_ is a common refrain — and usually a convincing one. This leads to decisions like _"We don't have time to reconcile these two databases, so we'll write some code to keep them in sync for now and reconcile after shipping."_ Or _"we have some code written by consultants who don't follow standards; we can clean it up later."_ Or _"we didn't have time to write all the unit tests for the code we wrote in the last 2 months of the project. We'll write them after the release."_ (We'll call this **Type II**.)

The rest of my comments focus on the type of technical debt incurred for strategic reasons (Type II).

## Short-Term vs Long-Term Debt

With real debt, a company will maintain both short-term and long-term debt. You use short-term debt to cover things like gaps between your receivables (customer payments) and expenses (payroll). You take on short-term debt when you have the money, you just don't have it _now_. Short-term debt is expected to be paid off frequently. The technical equivalent seems fairly straightforward. Short-term technical debt is debt that is taken on _tactically and reactively_ — typically as a last resort to ship a product. (We'll call this **Type II.A**.)

Long-term debt is debt that a company takes on _strategically and proactively_ — investment in new capital equipment, like a new factory, or a new corporate campus. Again, the technical equivalent seems straightforward: _"We don't think we'll need to support a second platform for at least 5 years, so this release can be built on the assumption that we'll be supporting only one platform."_ (We'll call this **Type II.B**.)

The implication is that short-term debt should be paid off quickly — perhaps as the first part of the next release cycle — while long-term debt can be carried for a few years or more.

## Incurring Technical Debt

When technical debt is incurred for strategic reasons, the underlying rationale is always that the cost of doing development work today is viewed as more expensive than it will be in the future. This can be true for any of several reasons.

_Time to Market._ When time to market is critical, incurring $1 extra in development can equate to $10 in lost profit. Even if the cost of development for the same work rises to $5 later — that is, costs more later — incurring the $1 debt now is a sound business decision.

_Preserving Startup Capital._ In a startup environment you have a fixed amount of seed money, and every dollar counts. If you can defer an expense by a year or two, you can pay for that expense out of a larger pool of money later rather than paying it from precious startup funds now.

_Deferring Development Expense._ When a system is retired, all of a system's technical debt is retired at once along with it. Once a system is taken out of production, there's no difference between a "clean and correct" solution and a "quick and dirty" one. Unlike financial debt, when a system is retired all its technical debt is retired with it. Consequently, near the end of a system's life it becomes much harder to justify the cost of investing in anything other than the most expedient and immediate fix.

## Ensure You're Incurring the Right Kind of Technical Debt

Some debts are taken on in large chunks: _"We don't have time to implement this properly right now; just hack it and we'll fix it after we ship."_ Conceptually it's like buying a car — it's a large debt that can be tracked and managed. (We'll call this **Type II.A.1**.)

Other debts accumulate by taking on hundreds or thousands of small shortcuts — generic variable names, sparse comments, creating one class where two should have been created, not following coding conventions, and so on. This type of debt is like credit card debt. It's easy to incur unintentionally, it accumulates faster than you expect, and it's difficult to track and manage once you've incurred it. (We'll call this **Type II.A.2**.)

Both types of debt are commonly incurred in response to the directive to _"Ship as fast as possible."_ However, the second type (Type II.A.2) doesn't pay off in the short term of an initial release cycle and **must be avoided**.

## Servicing the Debt

An important implication of technical debt is that it must be _serviced_. That is, once debt is incurred there will be **interest charges**.

If the debt grows large enough, the company will eventually spend more on servicing the debt than on investing in growing the value of its assets. A common example is **legacy code** bases where so much work goes into keeping the system in production (that is, "servicing the debt") that little time is left to add new capabilities to the system. With financial debt, analysts speak of "debt ratio," which equals total debt divided by total assets. High debt ratios are viewed as riskier, which seems true for technical debt as well.

## Attitudes Toward Technical Debt

Like financial debt, different organizations have different philosophies about its utility. Some want to avoid taking on any debt; others see debt as useful tools and just want to know how to use them wisely.

I've found that business teams generally seem to have a higher tolerance for technical debt than technical teams. Business executives tend to want to understand the tradeoffs involved, while some technical teams seem to believe the only correct amount of technical debt is zero.

The reason typically cited by technical teams for avoiding debt entirely is the challenge of **communicating the existence of technical debt** to the business team and the challenge of helping them remember the implications of previously incurred technical debt. Everyone agrees that it's a good idea to incur debt late in a release cycle, but business teams can sometimes resist paying down the debt in the next release cycle. The main problem seems to be that, unlike financial debt, technical debt is much less visible, and so people find it easier to ignore.

## How Do You Make an Organization's Debt Load More Visible?

One organization we worked with maintains a debt list within its defect-tracking system. Every time debt is incurred, the tasks required to pay it off are entered into the system along with an effort estimate and a schedule. The debt backlog is then tracked, and any debt unpaid for more than 90 days is treated as critical.

Another organization maintains its debt list as part of Scrum's Product Backlog, with similar effort estimates for what it will take to pay down each debt.

Either of these approaches can be used to increase the **visibility** of the debt load and the debt service work that must occur during future release cycles. Either one also provides a safeguard against accumulating "credit card debt" from a mountain of small shortcuts as mentioned earlier. You can simply tell the team: _"If the shortcut you're considering taking is too small to add to the debt service list/product backlog, it's too small to make a difference; don't take the shortcut. We only want shortcuts we can track and repair later."_

## Ability to Take on Debt Safely Varies

Different teams will have different credit ratings for taking on debt. The credit rating reflects a team's ability to pay down technical debt after it's been incurred.

A key factor in the ability to pay down technical debt is the level of debt a team incurs unintentionally — that is, how much is Type I? The less debt a team creates for itself through poor quality work, the more debt it can safely absorb for strategic reasons. This is true whether we're talking about taking on Type I vs. Type II debt or taking on Type II.A.1 vs. Type II.A.2 debt.

One organization tracks debt vs. team velocity. Once team velocity starts to decline as a result of servicing technical debt, it focuses on reducing its debt until velocity recovers. Another approach is to track rework, and use that as a measure of how much debt a team is accumulating.

## Retiring the Debt

"Getting out of Debt" can be motivational and good for team morale. A good approach when short-term debt has been incurred is to take the first development iteration after a release and devote it to paying down the short-term technical debt.

The ability to pay down debt depends at least in part on the type of software the team is working on. If a team incurs short-term debt in a web application, a new release can easily be installed after the team does the debt reduction work. If the team incurs short-term debt in aircraft firmware — the payoff, which requires replacing a box on the aircraft — that team will have a much higher bar for incurring any short-term debt. It's like minimum payment — if your minimum payment is 3% of your balance, no problem. If the minimum payment is $1,000 regardless of your balance, you'll need to think much harder before taking on any debt.

## Communicating About Technical Debt

The vocabulary of technical debt provides a way to communicate with non-technical teams in an area that has traditionally suffered from a lack of **transparency**. Shifting the dialog from technical vocabulary to financial vocabulary provides a much clearer and more understandable framework for these discussions. Although technical debt terminology isn't yet in wide use, I've found that it immediately resonates with every executive I've presented it to, as well as other non-technical stakeholders. It also makes sense to technical teams that are usually very aware of the debt load their organization is carrying.

Here are some suggestions for communicating about debt with non-technical stakeholders:

_Use the organization's maintenance budget as a rough proxy for its technical debt service._ However, you'll need to differentiate between maintenance that keeps the production system running vs. maintenance that extends the capabilities of the production system. Only the first category counts as technical debt service.

_Discuss debt in monetary rather than functionality terms._ For example, _"40% of our R&D budget goes to supporting prior releases"_ or _"we are currently spending $2.3 million per year servicing our technical debts."_

_"Ensure you're incurring the right kinds of debt."_ Not all debt is equal. Some debt is the result of good business decisions; other debt is the result of sloppy technical practices or poor communication about what debt the business intends to incur. The only types that are truly healthy are Types II.A.1 and II.B.

Treat the discussion of debt as an ongoing dialog rather than a one-time conversation. You may need several discussions before the nuances of the metaphor are truly absorbed.

## Technical Debt Taxonomy

Here is a summary of the types of technical debt:

_No Debt_

Feature Backlog, deferred features, cut features, etc. Not all incomplete work is debt. It's not debt because it doesn't require interest payments.

_Debt_

- I. Debt incurred unintentionally due to poor quality work
- II. Debt incurred intentionally
- II.A. Short-term debt, typically incurred reactively, for tactical reasons
- II.A.1. Individually identifiable shortcuts (like financing a car)
- II.A.2. Numerous small shortcuts (like credit card debt)
- II.B. Long-term debt, incurred proactively, for strategic reasons

## Summary

What do you think? Do you like the technical debt metaphor? Do you find it useful for communicating the implications of technical/business decisions to non-technical project stakeholders? What's your experience? I'd love to hear your thoughts.

## Resources

- [OOPSLA '92 Experience Report](http://c2.com/doc/oopsla92.html) by Ward Cunningham that first mentioned technical debt
- Short [Bliki article](http://www.martinfowler.com/bliki/TechnicalDebt.html) by Martin Fowler on technical debt
- Discussions on the c2 wiki on [Complexity as Debt](http://www.c2.com/cgi/wiki?ComplexityAsDebt) and [Technical Debt](http://www.c2.com/cgi/wiki?TechnicalDebt)
