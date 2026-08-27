---
title: 'Off-Topic: Scientific Method vs Cargo Cult'
date: '2008-12-16T13:51:00-02:00'
slug: off-topic-m-todo-cient-fico-vs-cargo-cult
translationKey: off-topic-m-todo-cient-fico-vs-cargo-cult
description: "Cargo culting is repeating structures without understanding why. The fix is testing hypotheses with throwaway prototypes. At YellowPages, four months of prep kept four months of coding from becoming twenty."
tags:
- science
- software-engineering
- off-topic
draft: false
---

After several years, I've noticed that a large number of programmers simply don't understand the Scientific Method. These days we talk a lot about agility and testing, and everyone repeats that TDD matters. Inside "testing" there is one step that should be **obvious** and almost nobody practices: **experimentation**.

![](https://akitaonrails.s3.amazonaws.com/files/20081216/42-17463681.jpg)

The "no time" excuse people use to skip writing tests also serves to skip testing hypotheses. Most don't even realize they should be experimenting. I'm talking about building proofs of concept, pieces of what you want to develop that will potentially be thrown away.

The "thrown away" part is what makes programmers and managers bristle. _"But that's wasted time, work down the drain! Unacceptable!"_ That thinking leads people to believe every line of code written must necessarily end up in the application.

It's the old mistake of assuming we have to get everything right on the first try, the culture that treats trial and error as wrongdoing. My point is the opposite: the mistake is assuming we'll always nail it on the first try. In most cases, we'll get it wrong every single first time.

## Cargo Cult

After World War II, native tribes on South Pacific islands built replicas of airplanes and military landing strips, hoping to summon back the "god planes" that had brought them so much wonderful cargo during the war. Most programmers do exactly that: as if in a ritual, they drop programming structures into the code without really understanding why, only because they "should." They're the ones who force Design Patterns where none are needed, who plaster comments over code that already explains itself and, more recently, who practically kneel before "Dependency Injection" without understanding the reason. (source: [Wikipedia](http://en.wikipedia.org/wiki/Cargo_cult_programming))

Following fashion gets an unfair bad rap; what ruins people is applying things, new or old, without understanding the **reason**. The main job of education should be teaching people to reason, but in a culture of rote memorization people accept everything they memorize without knowing why they memorized it: some "authority" said it was true and therefore it must be applied.

![](https://akitaonrails.s3.amazonaws.com/files/20081216/1217833732_d7fcaebe17.jpg)

Remember the discussions about why certifications are harmful? This is one of the reasons. For those who already reason, it makes no difference at all. For the large mass who don't, the end result is pure cargo culting.

Most people read tutorials, a few books, attend some workshops, and already consider themselves ready for the task. In practice they run the good old mental "copy and paste" and dump into the application every piece of code they ever learned. I've seen people write something like this:

```ruby
if ( a == b ) {  
 return true;  
} else {  
 return false;  
}  
```

Nothing wrong with that, but it's amazing how many people are surprised when I tell them this one line does the same thing:

```ruby
return (a == b);  
```

The first snippet, on its own, is harmless. The subtlety is that the programmer doesn't know why he wrote it; he only knows he "has to." Want a worse case? I've seen, in several languages, programmers do the following:

```php
$dbname="meu_banco";
$chandle = mysql_connect("localhost", 'root', 'root') or die("Falhou");  
$query1 = "select * from tabela";  
$result = mysql_db_query($dbname, $query1) or die ("Falhou");  
while ($row = mysql_fetch_row($result)) {  
 $field = mysql_fetch_field($result, 1);  
 if ( $field == 'foo' ) {  
 echo "encontrei!";  
 break;  
 }  
}
```

That's a textbook [What the F*ck!?](http://thedailywtf.com/)

Again, code that "runs." In some languages it compiles with no complaint at all. Anyone who can't spot the **deadly** problem in this code needs to go back to their freshman year.

![](https://akitaonrails.s3.amazonaws.com/files/20081216/will_code_for_food.jpg)

## Blindness

_"Repeat a lie long enough and soon it becomes the truth."_

There are plenty of bad books, bad tutorials, bad teachers, and a whole rabble of bad actors spreading bad practices. Even so, the greatest blame lies with those who let themselves be fooled. Whoever swallows everything they hear, without a shred of skepticism, is guilty of their own ignorance.

That's why newspapers still print horoscopes instead of a science column: there are far more readers interested in being fooled than in learning boring things, like reality.

In technology it's the same:

- Windows must be better because it's the market leader (ignoring that Apple, even with a "measly 8%" of the market, ranks among the most profitable companies in the industry, and that Firefox already has a huge share of users in Brazil)

- Java must be better because it's the market leader, or PHP must be better because big sites use it (no need to even discuss it)

- Threads are the best way to write concurrent code (ignoring, out of laziness, the advantages of functional programming)

- The best way to manage data is a relational database (ignoring, again out of laziness, the whole range of non-relational databases gaining ground)

- Static languages are better because you can compile them (ignoring, here out of pure stupidity, the enormous productivity advantages of dynamic languages)

- Object-oriented programming is the pinnacle of programming technique (ignoring that it's just one of dozens of paradigms, functional programming among them)

- Rails doesn't scale (seriously? anyone still repeating that proves they're an amateur)

![](https://akitaonrails.s3.amazonaws.com/files/20081216/thestupiditburns.jpg)

Everyone carries hundreds of preconceived ideas like these. Things heard from someone or read somewhere, usually from a source of dubious reputation, that the person now repeats with no argument to back the belief. Or rather: they think the dubious source they got it from is basis enough to keep repeating it.

In programming or in any other field: if you hold **any** belief you can't argue for and defend, research it better. If it doesn't survive counterarguments, **throw it out**, because it's useless to you. Everyone fancies themselves "open-minded"; I disagree, most people are quite closed. Doubt me? Rethink everything you believe and argue against yourself. Done properly, you'll notice most of what you believe has no foundation at all.

## Scientific Method

A careful person practices the basics of the scientific method every day. Our daily life is a sequence of decisions, some small, some huge, and decisions made on preconceived ideas are where mistakes live.

This doesn't rule out intuition. Intuition is a fast conclusion built on experience. If your daily experiences have been methodically rational for a long time, your intuition tends to be solid. If they were built on superstition, lucky charms, pseudoscience, cargo culting, and preconceived ideas, sorry to say: your intuition is garbage.

Read [this Wikipedia definition](http://en.wikipedia.org/wiki/Scientific_method). It's long, thorough, and asks for real reflection. What interests me most is summarized [here](http://web.archive.org/web/20081217012740/http://www.sciencebuddies.org:80/mentoring/project_scientific_method.shtml).

Like any good process, this one is also **iterative**: it expects you to loop back through steps to refine what you know.

![](https://akitaonrails.s3.amazonaws.com/files/20081216/dogma-jesus.jpg)

The steps are simple, and they can run fast or slow and detailed. What matters is this: faced with a question, run these steps at least mentally. It's the bare minimum for an educated decision.

- **Ask the question.** This phase matters: the wrong question leads to the wrong answer. People have been wasting time chasing irrelevant answers since forever because the question was wrong. Treat the question like a User Story in an agile backlog: check whether it's a priority, check whether it's needed. Don't spend time answering irrelevant questions.

- **Do research.** Before anything else, research the subject. Don't burn days on it; sometimes a few minutes on Google is enough. For me, the value of this step is the "stop, think, continue." Most people rush too much; this is the moment to pause for a second and gain more knowledge before moving on.

- **Build a hypothesis.** When you ask a question, you usually already have one or more possible answers. When you framed the question, don't cling to preconceived ideas. Consider that what most people call "truth" is, in reality, a set of [hypotheses](http://en.wikipedia.org/wiki/Hypothesis). A hypothesis is merely a suggested explanation.

[![](https://akitaonrails.s3.amazonaws.com/files/20081216/overview_scientific_method2.gif)](http://web.archive.org/web/20081217012740/http://www.sciencebuddies.org:80/mentoring/project_scientific_method.shtml)

- **Test with an experiment.** This is the most important step. Experiments must be repeatable and have very well-defined criteria: if two people run the same experiment, for the hypothesis to hold up the results have to match. Note that I said "hold up," not "be true." Truth is too strong a word; I rarely consider myself near any truth. Most of the time I just accept that my hypothesis hasn't been falsified yet. The crucial part, in programming: build proofs of concept, pieces of code written only to test the hypothesis, which can simply be thrown away afterward. Do it outside your project's codebase, in a separate environment. Don't mix the two.

- **Draw conclusions.** From everything you did above, you'll either confirm or demolish your hypothesis. Accept from the start that you may well prove your own hypothesis false. In that case, go back to step two, frame a new hypothesis, and try again. That's what open-minded means: proving yourself wrong and immediately setting out to find another answer.

- **Communicate your results.** The application I'm describing here is informal, the minimum for you to have some grounding, probably not all of it, in what you're doing. If the subject is more complex, with more time invested and more detail, it may interest more people. Share your results, at least with your colleagues. If you invested that much time, the answer is probably important, and then it's worth giving others the chance to try to demolish it. It hardly matters how many people reach the same conclusion; headcount means nothing. What matters far more is whether someone manages to demolish yours. In that case, throw the hypothesis out and start over.

## People

Most people can be described like this:

- **They hold preconceived ideas.** Heard from other people who, they believe, have credibility. Just because someone has a credential, is a celebrity, speaks well, or dresses well doesn't mean they know the whole truth. Quite the opposite: that person may be stuffed with preconceived ideas. Do listen to what they have to say, but file it all in a mental box labeled "to verify" and move on.

- **They hate being proven wrong.** Nobody likes admitting they're wrong: first it kills the ego, then it destroys self-esteem. So the ignorant person clings to their private lie to the bitter end. These are people with weak foundations. Build your foundation on half-truths and, when one falls, the whole thing falls. That's the biggest risk.

- **They hate wasting time.** And "wasting time" here is entirely relative. Most people practice lousy economics: testing and experimenting, in other words "not doing anything immediately," gets treated as wasted time. I call it "saving future time": a little more care now so I don't have to scramble tomorrow. It's a matter of balance. It makes no sense to prepare for 15 days on a 20-day project. But do the minimum: stop for a second, think, and if in doubt, experiment before you proceed.

![](https://akitaonrails.s3.amazonaws.com/files/20081216/funny-dog-pictures-praying-dogma.jpg)

- **They hate new things.** There's another wrong notion of "cost" at play. Many people think that because they invested time studying a subject, that investment can't be lost and they must stick with it. It's what I once wrote about in [The Sunk Cost Fallacy](http://www.akitaonrails.com/en/2007/08/19/a-falcia-do-custo-perdido). If the loss already exists, the dumbest move is to insist on it. Far smarter to write the cost off, change direction, and move on.

- **They only do what they're told.** If nobody orders tests, nobody tests. If nobody orders a proof of concept, nobody builds one. If nobody tells them to care about security, the code ships full of holes. If nobody tells them to automate tests, nobody automates. The number of Lemmings on projects is staggering. First, because everything that should be mandatory goes undone; second, because if the boss orders them to shoot their own foot, they shoot. Once again, a failure to reason.

- **They do the unnecessary.** Sounds like a paradox, but it complements the previous item. Because of fixed preconceived ideas, people waste time doing totally unnecessary things because someone they consider "credible" said it should be done. It's a behavior I still haven't figured out, I see it all the time, and it contradicts everything I said above: someone picks an idiotic technology for some inexplicable reason, burns ages away from the project's real priorities, builds no proof of concept at all, and starts coding on faith that it'll work. In the end, the project is late and full of code headed for the trash because it's good for nothing.

I think all of this comes down to people's lack of practice at reasoning. It's irrational behavior, needlessly complicated, full of basic mistakes, that nobody perceives as wrong.

I remember a documentary by the great Richard Dawkins in which he tells the story of a scientist who spent years studying a theory, I don't recall which. A young scientist proved him wrong. The older man looked at the kid and said something like "thank you very much." That's rational behavior. Proving something true is very hard; proving it **false** is far simpler. If someone proves you wrong, say thanks: that person just saved you from wasting time down the road, and that's worth gold.

And whenever you join a new project, don't assume you know what needs to be done, or even that you "need" to know. Assume you don't know. Build hypotheses, discuss, experiment, gain real confidence, and only then do what needs to be done. There's nothing wrong with that. The problem is assuming you know what you're going to do and, after wasting everyone's time, finally making it obvious you were wrong all along.

Don't waste other people's time!

![](https://akitaonrails.s3.amazonaws.com/files/20081216/2633591802_8498c58817_o.jpg)

References:

- [Scientific method](http://en.wikipedia.org/wiki/Scientific_method)
- [Steps of the Scientific Method](http://web.archive.org/web/20081217012740/http://www.sciencebuddies.org:80/mentoring/project_scientific_method.shtml)
- [Deductive Reasoning](http://en.wikipedia.org/wiki/Deductive_reasoning)
- [Cargo Cult Programming](http://en.wikipedia.org/wiki/Cargo_cult_programming)
- [Cargo Cult Science](http://en.wikipedia.org/wiki/Cargo_cult_science)
- [Fallacy](http://en.wikipedia.org/wiki/Fallacy)
- [Due Diligence](http://en.wikipedia.org/wiki/Due_diligence)
- [Prejudice](http://en.wikipedia.org/wiki/Prejudice)
- [Hypothesis](http://en.wikipedia.org/wiki/Hypothesis)

I repeat over and over that I don't know what the truth is. I answer "I don't know" every time someone asks me a question expecting an absolute answer. _"Will Rails take off?"_ Forget that kind of question: predicting the future is hard. If someone hands you a prediction about the future, ignore it. Odds are the person has no idea what they're talking about.

Behind that kind of question sits the behavior I described above: the person thinks they must always be right and hates being proven wrong. Worst case, the path you walked to prove yourself wrong gave you more knowledge and experience. That's worth more than finding a truth.

I've written about Reason in a few other posts:

- [Be Arrogant](http://www.akitaonrails.com/en/2007/04/14/off-topic-seja-arrogante)
- [Enemies of Reason](http://www.akitaonrails.com/en/2007/08/23/off-topic-inimigos-da-razo)
- [100% pure Object-Oriented: The Fallacy](http://www.akitaonrails.com/2007/09/04/100-pure-object-oriented-the-fallacy)

## Conclusions

My goal in this post is to reinforce the importance of experimentation. I don't know what the truth is; anyone can post a comment here with dozens of counterarguments. Whoever does will be missing the point, and their "arguments" will be citations of preconceived ideas. Picking at details in the text to point out errors is beside the point. What matters is the professional understanding that age, years on the road, certifications, and waving credentials solve nothing. In the end we're all amateurs and, as such, we need to go back to zero and review our hypotheses.

A practical example. When I spoke with [John Straw](http://www.akitaonrails.com/en/2008/11/21/rails-podcast-brasil-qcon-special-john-straw-yellowpages-com-and-matt-aimonetti-merb) (YellowPages.com) in San Francisco, he described something not every team does: extensive due diligence. They spent 22 months building the original YellowPages.com in Java. They decided to stop for 4 months to build prototypes, proofs of concept, and test hypotheses: which framework, Rails, Django, or Seam? Which architecture, SOA, EJBs? How long would the team take to get comfortable with the new technology? Only after they gained confidence in what they were doing did they start implementing for real. And it took just 4 more months to finish. See it? The first 4 months weren't wasted time: they were insurance, the thing that kept the following 4 months from turning into 20.

As I said last year: "Be arrogant, for real!" Be arrogant with yourself to the point of genuinely questioning yourself and winning. You can fool others; fooling yourself buys you nothing. There is no better inquisitor for you than yourself. Wrong? Excellent: one less wrong path. Find another and start over.

Repeating: it wasn't preconceived ideas that got us to the Moon.

![](https://akitaonrails.s3.amazonaws.com/files/20081216/redneck_moon_landing_2.jpg)
