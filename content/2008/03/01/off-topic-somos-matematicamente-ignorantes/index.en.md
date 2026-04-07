---
title: 'Off Topic: We Are Mathematically Illiterate'
date: '2008-03-01T14:18:00-03:00'
slug: off-topic-somos-matematicamente-ignorantes
tags:
- off-topic
- principles
- science
- fallacies
draft: false
translationKey: mathematically-illiterate
---

Unless you've already studied Statistics and Probability, or are a math enthusiast, you're probably a true naïve in mathematical terms — to put it politely.

Especially if, even infrequently, you try to explain purely random events as "mysterious coincidences" that "must" have some mystical or supernatural explanation.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/3/1/skeptic.jpg)

Even among us programmers, many have ignored the discipline during what is normally taught in the first year of Computer Science. One practical result of this kind of ignorance: [Birthday Attacks](http://en.wikipedia.org/wiki/Birthday_attack), a type of cryptographic attack named because it exploits the mathematics behind the [Birthday Paradox](http://en.wikipedia.org/wiki/Birthday_paradox) — which is explained in the article I translate below.

That is, given a function f (example: authentication), the goal of the attack is to find two inputs x1 and x2 (example: passwords) such that f(x1) = f(x2). Such a pair x1 and x2 is called a [collision](http://en.wikipedia.org/wiki/Hash_collision). We always solve this problem the wrong way.

An interesting read is [The Psychology of the Psychic](http://en.wikipedia.org/wiki/The_Psychology_of_the_Psychic), by David Marks and Dr. Richard Kammann, a skeptical analysis of paranormal claims. A non-obvious definition is what Marks called "Koestler's Fallacy" where people assume that two strange hits in random events cannot happen by chance alone (_cough_ Evolution _cough_).

This article by **Bruce Martin**, from the excellent [Skeptical Inquirer](http://csicop.org/si/9809/coincidence.html) magazine, demonstrates how two "coincident" events in a universe of random alternatives is more common than we think. That is, it demonstrates how our **intuition** or **common sense** around this type of analysis is totally flawed and how we are completely ignorant when attributing probabilities to events. _"This project has a 90% chance of succeeding."_ _"This soccer team has a 60% chance of winning the championship."_ _"I have a 45% chance of passing the entrance exam."_ All of this is nothing more than a guess — an arbitrary number with no real grounding in the events it tries to predict.

When you try to predict something and get it wrong you say, _"how strange, I'm usually right"_ and everyone ignores and forgets this. If you happen to "get" a prediction right you say _"aha, I knew I was right, I'm always right!"_ and everyone is surprised, and everyone remembers only this fact. Our minds work this way: we don't store everything, we store only what is convenient to us. And this influences our (bad) future decisions.

Truth #1: nobody can "predict" the future with precision. Truth #2: random events happen more frequently than we imagine. Truth #3: among many completely random events we will always find patterns — and we will memorize these patterns and try, futilely, to give them "meaning." But these "coincidences" are just that: entirely calculable random events.

**Note:** I highly recommend reading the excellent [Skeptical Inquirer](http://csicop.org/si/9809/) magazine. Likewise I recommend staying informed about the [CSICOP](http://csicop.org/) or _"Committee for Skeptical Inquiry"_ — an organization that encourages critical investigation of pseudoscientific and paranormal claims from a responsible and scientific standpoint, and disseminates factual information and results of such inquiry to the scientific community and the public. Every day, somewhere in the world, someone is actively thinking about how to deceive us. Every day we automatically deceive ourselves without realizing it. Every day this kind of lie leads us to wrong and harmful decisions. That's why we need to constantly police ourselves to be "Skeptical Inquirers." Not knowing the answer to some question today doesn't mean we won't uncover it tomorrow. Hasty conclusions are the greatest enemy of progress because we become stagnant investing in lies. I hope this article serves as an alarm that we deceive ourselves more often than we'd like.

Think you can "predict" the results of a sports championship? Think you can predict stock market results? Think you can predict the results of successive spins of a roulette wheel? Think again. I've had this article saved for a long time and wanted to translate it, but only now have I decided to put it here. This text is long and may be tiring for most people, but I recommend reading it to the end. Here is the translation:

## Coincidences: Remarkable or Random?

_The most unlikely coincidences usually result from the play of random events. The very nature of randomness guarantees that combining random data will result in some pattern._

Bruce Martin

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/3/1/cover.jpg)](http://csicop.org/si/9809/)

_"Don't you believe in telepathy?"_ My friend, a sober professional, asked with disdain. _"Do you?"_ I replied. _"Of course. Many times I've been out at night and suddenly became worried about my kids. Calling home I would discover that one was sick, hurt, or having nightmares. How do you explain that?"_

This type of episode has happened to all of us, and it's common to hear the words _"It can't be just a coincidence."_ Today the explanation many people arrive at involves mental telepathy or psychic connections. But should we so quickly jump into the arms of the mystical world? Could such events result from coincidences after all?

There are two features of coincidences not well known to the public. First, we tend to ignore the powerful reinforcement of coincidences, both waking and in dreams, in our memories. Non-coincident events don't register in our memories with the same intensity. Second, we fail to understand the extent to which highly improbable events occur daily to everybody. It's not possible to estimate all the probabilities of the many paired events that occur in our daily lives. We normally tend to give coincidences lower probabilities than they deserve.

However, it is possible to calculate the probability of events that seem unlikely with precision. These examples give clues to how our expectations fail to agree with reality.

### Coincident Birth Dates

In a random selection of 23 people there is a 50% chance (1 in 2) that at least 2 people share the same birthday. Who hasn't been surprised to learn this for the first time? The calculation is straightforward. First find the probability that everyone in the group has a different date (X) and then subtract that fraction from 1 to get the probability of at least one shared birthday in the group (P), P = 1 – X. Probabilities range from 0 to 1, or can be expressed from 0 to 100%. From no coincidence, the second person has a choice of 364 days, the third person 363 days, and the nth person 366 – n days. So the probability of all different birthdays becomes:

* * *

```bash

For two people: X2 = (365*364)/365

For three people: X3 = (365* 364*363)/365

For n people: Xn = (365*364* … 366-n)/365  
 Xn = 365! / [365^n * (365-n)!]  
```

With its factorials the last equality isn't especially useful unless you have the ability to handle very large numbers. It's instructive to use a spreadsheet and a computer language loop to calculate Xn, from the first equality, for successive values of n. When n = 23, you find that Xn = 0.493 and P = 0.507. The graph of the probability of at least 1 shared birthday, P, versus the number of people, n, appears as the right side of a circle curve in Figure 1. The curve shows that the probability of at least 2 people sharing a birthday rises slowly, initially passing less than 12% probability with 10 people, rising to 50% at the open circle corresponding to the 23rd person, then stabilizing and reaching 90% probability in a group of 41 people. This means that, on average, out of 10 random groups of 41 people, in 9 of them at least 2 people share a birthday. No mysterious force is needed to explain the coincidence.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/3/1/fig1.gif)

> **Figure 1:** Probability of Coincident Birthdays: the right-side curve of a circle represents the probability that in a random group of people, at least 2 share the same birthday. As indicated by the open circle above the horizontal probability line of 0.50, a 50% chance on average is reached with only 23 people. The left-side curve represents the probability that in a random group of people at least 2 share birthdays within 1 day of each other. The 50% chance for this 3-day coincidence occurs with only 14 people.

Note that the probability of birthday coincidence for 23 + 23 = 46 people is not 100%, as some might assume, but 95% as shown by the right-side curve in Figure 1. Extending the curve above the figure 1 limit reveals that 57 people produce 99% probability of coincident birthdays.

The same principle can be used to calculate the probabilities of at least 2 people in a random group having the same birthday within 1 day of each other (the same and two adjacent days, e.g., the first person's birthday is the 20th, the second's being between the 19th and 21st). This condition is less restrictive than before, and the 50% probability is reached with only 14 people. The left-side curve in Figure 1 shows a plot for the within-1-day-birthday probabilities.

Going a bit more deeply into some aspects of the probability of identical birthdays gives additional clues. Note that we have said several times "at least 2 people" sharing the same birthday. As the group grows the chances of multiple coincidences increase.

- The descending curve at the left in Figure 2 represents the probability of no coincidence (NC) of birthdays, identical to the values of Xn calculated above.

- The first curve with a maximum shows the probability of only one pair (1P) with the same birthday. The maximum occurs with 28 people and a probability of 39%.

- As the group grows the probabilities of other coincidences also increase. The second curve with a maximum represents the probability of exactly 2 pairs of people (2P) having identical birthdays. Its maximum happens with 39 people and probability of 28%.

- The last, the ascending curve in Figure 2, shows the total probability of all remaining coincidences (> 2P), consisting of 3 pairs, etc. For all numbers of people, the probabilities for all 4 curves total 1.00 (100%).

![](http://s3.amazonaws.com/akitaonrails/assets/2008/3/1/fig2.gif)?

> **Figure 2:** Probabilities of Multiple Coincident Birthdays: the descending curve at left represents the probability of no coincidence (NC). The first curve with a maximum shows the probabilities of 1 single pair (1P) with identical birthdays. The second curve with a maximum represents the probability of exactly 2 pairs (2P) where each pair may have birthdays different from each other. The ascending curve at right shows the probability of all coincidences (> 2P), 3 pairs, triplets, etc. For any number of people the probabilities of the 4 curves total 1.00.

Figure 2 shows that for 33 people the probabilities are 36% for 1 pair, 11% for 2 pairs, and 3% for the total of all coincidences, where the totals sum to 50%. We've broken down the 50% probability of at least one coincidence discussed above for 33 people into component contributions. For 33 people the probability of no coincidence is also 50%, as shown by the descending (NC) curve of Figure 2.

There is almost a triple intersection with 38 people where the chance of 1 identical pair, 2 identical pairs, and the total of all coincidences is 28-29. For 38 or more people the total of all coincidences becomes greater than the possibilities of exactly 1 or 2 pairs and passes 50% with 45 people. In a random group of more than 45 people there's a better than average chance there are more than 2 birthday coincidences.

What this series of calculations concludes is this: if birthday coincidences are much more common than we might imagine, isn't it likely that many of those other impressive coincidences in our lives are also the result of probability? We should not multiply hypotheses: the principle of Occam's Razor dictates that the simplest explanation should be preferred.

### Presidential Coincidences

Consider the birth and death dates of American presidents to see how this reasoning works in real cases. There have been 41 presidential births, and Figure 1 indicates 90% probability that at least 2 presidents should have been born on the same day. And there is indeed that coincidence: James K. Polk and Warren G. Harding were both born on November 2. The result appears in Table 1.

| **Table 1** |
| **Presidential Coincidences** |
| **Birthdays, 41 cases (90%)** |
| Nov 2 | James K. Polk |
| &nbsp; | Warren G. Harding |
| **Deaths, 36 cases (83%)** |
| Mar 8 | Millard Fillmore |
| &nbsp; | William Howard Taft |
| Jul 4 | John Adams |
| &nbsp; | Thomas Jefferson |
| &nbsp; | James Monroe |

With 41 cases there is 66% chance of a second coincidence, but none has happened yet [the result can be obtained by adding the probabilities for 41 people for 2P (28%) and >2P (38%) in the curves of Figure 2.] Perhaps the next president's birthday will coincide with one of the 41 previous ones.

Of the 36 dead presidents, Figure 1 indicates with 83% probability that at least 2 should have died on the same date. The result also appears in Table 1. Both Millard Fillmore and William Howard Taft died on March 8.

With 36 cases, there is 51% chance of a second coincidence...

In what seems a startling coincidence, 3 presidents died on July 4, as listed in Table 1. Both John Adams and Thomas Jefferson died in the same year, 1826, on the 50th anniversary of the signing of the Declaration of Independence. Adams's final words, that his long-time rival and correspondent Jefferson "still lives," were wrong, as Jefferson had died earlier that same day. James Monroe died on the same date 5 years later.

Presidential scholars suggest that earlier presidents made an effort to wait until July 4. James Madison rejected stimulants that might have prolonged his life, and he died 6 days before, on June 28 (in 1836). It seems evident that for the deaths of many presidents July 4 was not a random date. Only one president, Calvin Coolidge, was born on July 4.

An important point is that no birth date was specified in advance. Table 2 lists the number of people needed for 50% probability. The first repeats what we already know: a group of 23 people is sufficient for at least 2 to share the same unspecified birthday.

| **Table 2** |
| **Population for 50% probability** |
| At least 2 with the same unspecified date | 23 |
| At least 1 has a specified date | 253 |
| At least 2 have the same specified date | 613 |

If we specify a particular date, like today, 253 people are needed for an average chance of at least 1 person with that birthday.

For at least 2 people to have the same specified birthday, the 50% probability is not reached until 613 people. This enormous difference of 23 vs 613 for 50% probability of at least 2 people with a birthday in common is due to whether or not a particular date is specified.

That some unlikely event will happen is expected; that one particular one will happen is quite unusual. When we look at our personal coincidences, we see that they were rarely predicted in advance.

(**Akita's note:** what we mean is this: coincidences happen. Saying "unlikely" is not "impossible." 0.000001% is still not Zero. The difference is that it is very — extremely — rarely possible to predict in advance a particular event, even so not impossible. That is, hitting 1 prediction in thousands is not impossible. Hitting all of them is highly unlikely. That's the nature of coincidences: they happen, however unlikely, it's a fact, and there's no supernatural agent involved — it's just a random event that is mathematically describable. Predicting that a certain event will happen "and" being right is also absolutely random and there's no mystical or intuitive power involved. It's purely like rolling dice and, by chance, hitting a number. No: you are _not_ a psychic. :-)

### Abraham Lincoln and John Kennedy

You can always combine random data and find some regularity. A very well known example is the comparison of coincidences in the lives of Abraham Lincoln and John Kennedy, two presidents with 7 letters in their last names, elected 100 years apart, 1860 and 1960. Both were assassinated on a Friday in the presence of their wives, Lincoln in Ford's Theatre and Kennedy in a Ford automobile. Both assassins have 3 names: John Wilkes Booth and Lee Harvey Oswald, with 15 letters in each full name. Oswald shot Kennedy from a warehouse and ran to a theater, and Booth shot Lincoln in a theater and ran to a kind of warehouse. Both successor vice-presidents were Southern Democrats and former senators named Johnson (Andrew and Lyndon), with 13 letters in their names, born 100 years apart, 1808 and 1908.

But if we compare other relevant attributes we fail to find coincidences. Lincoln and Kennedy were born and died on different dates (day and month) and in different states, and none of the dates are separated by 100 years. Their ages were different, as were their wives' names. Of course, if any of these had matched they would have been on the list of "mysterious" coincidences. For any person with a reasonably eventful life it's possible to find coincidences between them. Two people meeting at a party typically find startling coincidences between them, but what they are — birthdays, hometowns, etc. — is not predicted in advance.

(**Akita's note:** coincidences are **much** more common than we think. We're not as different from each other as people believe.)

### Bridge Hands

In a card game called Bridge there are 635,013,559,600 possible 13-card hands. That many hands could be dealt if all the people in the world played bridge for a day. For an individual it would take many millions of years of continuous play to have all those hands. Even so, any hand dealt to a player is equally probable — or rather, equally improbable — since its probability is 1/635,013,559,600 or a little better than 1 in 1 trillion. Any hand is as improbable as 13 spades. Bridge hands are an example of the daily occurrence of very improbable events — but of course the hands are not specified in advance.

Consider a group of only 10 or more students in a college classroom with students from various states. During a school term there are numerous such classes. Yet the odds against predicting exactly the composition of any such class 10 years in advance (with all students and teachers already born by then) are truly astronomical. This is another example of daily occurrences of highly improbable events.

### Runs of Heads and Tails

What sequence of Heads (H) and Tails (T) could you expect from random coin flips? Neither all heads nor all tails, nor even heads and tails alternating in a sequence like HTHTHTHT, since this series is obviously regular and not random. In a random sequence we expect flips of both heads and tails. We can simulate progressions of coin flips from a random sequence of numbers.

Until now, as is known, the decimal digits of the irrational number π, which multiplied by the diameter of a circle gives the circumference, are random. This doesn't mean that every time π is calculated a different result is obtained, but instead that the value of each individual digit is not predictable from the previous digits. An example of this type of pattern leading to predictability is the sequence of decimal digits of the fraction 1/7 = 0.142857142857142857..., where there is an obvious repetition (142857) every 6 digits.

The decimal digits of π have been calculated to hundreds of millions of digits by high-performance computers, but we list only the first 100 digits in 4 lines of 25 digits:

3.141592653589793238462643  
38327950288419716939937510  
582097494459230781*64062862  
08*9986280348253421170679

There are 51 even digits and 49 odd digits. There is almost a median distribution when the first 100 decimal digits are divided another way: 49 digits from 0 to 4 and 51 digits from 5 to 9.

Since the decimal digits of π are random, we can simulate the random sequence of heads and tails by assigning even digits to heads and odd to tails. The sequence of heads and tails in 100 flips with 25 per line becomes (T = tails and H = heads):

THTTTHHTTTHTTTTHTHHHHHHT  
THTHTTTHHHHHTTTTHTTTTTTT  
THTHHHTTHTHHT*THTHTHTH*HHHHH  
HHHHTTHHHHHTHHHTTHHTTTHHTT

Combining the random sequence we find some regularity, like the alternating sequence in 8 flips from 62 to 69 (in bold). The probability of an alternating sequence in 8 flips is 1 in 2^7 = 128 flips. There are some long runs of all heads and all tails. There are 2 runs of 5 heads and 1 run of 6 heads, 1 run of 8 tails, and a surprising run of 10 tails. The decimal digits of π between 69 and 78 are all even. A run of 10 even digits should happen only 1 time in 2^10 = 1,024 digits. Yet this type of run happened within the first 80 digits.

So what do we have here? Proof that the decimal digits of π are not random? No, what we have instead is a demonstration of how it's always possible to combine random data and find regularities **not specified in advance**. Since 10 even digits occur in the first 100 digits of π, we could (erroneously) think we have something special, and that this type of sequence happens frequently. In fact, a run of 10 even digits does not happen again in the first thousand digits of π. In the first thousand digits a single run of 10 odd digits occurs between digits 411 and 420.

The crucial point is that the very nature of randomness guarantees that combinations of random data will result in some pattern. But what that pattern is cannot be specified in advance. If someone finds a pattern by combining random data, they can use it as a hypothesis to investigate more data but **should never** reach a general conclusion from it. In our example we discovered (but did not predict) 10 odd digits in 100 digits but not again in the next 900 digits. To confirm some tendency, the target data needs to be specified in advance of data inspection. If an unexpected pattern appears during inspection after data has been obtained, the pattern may be used as a hypothesis to obtain and inspect a completely new data set.

The sequence of heads and tails can be applied in other ways. Consider a football quarterback who completes 50% of his passes or a basketball player who scores 50% of his free throws. Assign heads (H) to a completed pass or free throw and tails (T) to a miss, and one can expect long runs of successes and failures as shown in the previous HT sequence. Most hot or cold streaks in sports are simply the consequence of randomness. The "hot hand" is yet another illusion of significance that appears in data sets that are random.

We can use random sequences of the decimal digits of π to find probable sequences for a baseball batter. For example, assign digits 0, 2, and 4 to hits and the other 7 digits to outs. Then, from the first 100 decimal digits there are 30 hits and 70 outs. If we divide the sequence of 100 digits into successive groups of 4, a number representing hits per game, we get results for 25 games. Our batter then goes hitless for 4 games (3 in succession), gets 1 hit in the 13th game, 2 hits in 7 games, 3 hits in one game, and has no game with 4 hits. Surprisingly, the batter gets at least 1 hit in the last 13 games, considered sufficient to constitute a "real" streak. But this streak appears from a random sequence of decimal digits of π. The slump and hot streak of a batter appear to be just the result of a random flip.

Clearly, unspecified unlikely coincidences happen daily in our lives, and these coincidences are much more the result of randomness. If the data set is large enough, coincidences will appear, as demonstrated in the first 100 decimal digits of π. The chances of getting 5 heads in a row is only 3%, but for 100 flips the chances approach 96%. Although applied in a different context, Ramsey theory (Scientific American, July 1990) states that _"every large set of numbers, points, or objects necessarily contains a highly regular pattern."_ No mysterious forces are needed to explain coincidences.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/3/1/fig3.gif)

> Figure 3: Stock Market Simulation: the daily stock market presented as price for 109 trading days generated from the randomness of the decimal digits of π. The "head and shoulders top" representation is shown to be consistent with random market plays. Of course the number of days is flexible; one decimal digit represents any fraction or number of days. [See notes](#note) for a description of how stock price was generated.

### Random Stock Market Prices

Given the current fascination with the stock market, we can generate even more interesting results from the random decimal digits of π. Let's plot on the X axis the number of decimal digits and on the Y axis a price value that is generated from the decimal digits described in Figure 3 and the [note](#note) such that there is an arbitrary and equal balance between upward and downward price directions.

For the first 108 decimal digits of π the entire plot is in positive territory. Starting from zero the plot begins rising until it reaches a plateau at digits 48 to 71 before beginning to fall, almost returning to zero at digit 99, and crossing into negative territory after digit 108. For a stock market technician this chart represents a "head and shoulders top" in a stock price chart or market price over time. It's all there in Figure 3, a head and shoulders top. Yet this chart was generated from the first 109 random decimal digits of π!

The maximum value of 65 on the Y axis is reached 3 times in the plateau region and is more than 7 times greater than the maximum single movement of 9. Therefore, we can conclude that a 'head and shoulders top' in stock and commodity prices may represent nothing more than random plays in the markets. (After a long period there is an upward trend in stock markets on average.)

A recent sweepstakes received by mail offered a grand prize of $5 million. The instructions stated that the odds of winning the prize were 1 in 200 million. Within that enormous population 1 person will win the prize. With such incredible and unfavorable odds each person must decide for themselves if the time and money spent sending in the card is worthwhile. The real big winner appears to be the postal service, which earns more than 10 times the grand prize.

So next time you hear _"This couldn't be just a coincidence,"_ you'll be more than justified in replying, _"And why not?"_

### CSICOP Presidential Coincidence Contest

Back in 1992, the Skeptical Inquirer held a contest called the Spooky Presidential Coincidences Contest, in response to Ann Landers' article "for the zillionth time" describing a list of eerie parallels between John F. Kennedy and Abraham Lincoln. The task was for readers to compile their own lists of coincidences between pairs of presidents. There were 2 contest winners, Arturo Magidin from Mexico City, and Chris Fishel, a student from the University of Virginia. Magidin compiled 16 incredible coincidences between Kennedy and former Mexican president Alvaro Obregón, while Fishel compiled lists of coincidences from no fewer than 21 different pairs of American presidents.

Some examples from Magidin's list: Both "Kennedy" and "Obregón" have 7 letters each; each was assassinated; the assassins of both have 3 names and died almost immediately after killing the presidents; Kennedy and Obregón both married in years ending in 3; each had a child who died shortly after birth; and both came from large families and died in their 40s.

Fishel compiled dozens of coincidences, here are some: Thomas Jefferson and Andrew Jackson. Both served 2 full terms; both their wives died before they became president; each has 6 letters in their first names; both were in debt at the time of their deaths; each had a state capital named after them; and the predecessors of both refused to appear at their inaugurations. [For more information and the complete lists, see SI Spring 1992, 16(3); and Winter 1993, 17(2).]

### Acknowledgments

I am indebted to Professor Russell N. Grimes of the University of Virginia for discussions of expressions leading to Figure 2 and Table 2.

### Note

The stock price was generated in a positive direction when the preceding digit is odd (except for 5) and in a negative direction when the preceding digit is even, with the magnitude of the direction given by the digit's value. Thus odd preceding digits 1 + 3 + 7 + 9 = 20 generate a positive sense and even preceding digits 0 + 2 + 4 + 6 + 8 = 20 a negative direction. The sum of the two senses is the same. For the digit 5, the direction is up or down depending on whether the preceding digit is odd or even, respectively. In the first 108 decimal digits there are eight 5's, each half generating positive and negative directions. Therefore, we have a perfectly arbitrary and equal balance between positive and negative directions.

### References

- Epstein, Richard A. 1967. [The Theory of Gambling and Statistical Logic](http://csicop.org/q/book/012240761X). New York: Academic Press.

- Falk, Ruma. 1981. On Coincidences. Skeptical Inquirer 6 (2): Winter: 18-31.

- Graham, Ronald L., and Joel H. Spencer. 1990. Ramsey Theory. Scientific American 263 (1): 112-117 (July).

- Paulos, John Allen. 1988. [Innumeracy](http://csicop.org/q/book/0679726012). New York: Random House.

- Weaver, Warren. 1963. [Lady Luck](http://csicop.org/q/book/0486243427). Garden City, NY: Anchor Books.

### About the Author

**Bruce Martin** is Professor Emeritus of Chemistry at the University of Virginia, Charlottesville, Virginia.

* * *

**Akita's closing notes:** just to be clear. "Hits" in random events, finding "patterns," also known as "coincidences," simply happen. Especially in a large universe of random — or mutually exclusive — events.

The problem is when we decide to identify these patterns (easy) and try to give "meaning" to these randomly coincident sequences. Worse: when we decide to attribute "cause and effect" to these events.

Suppose someone took a certain substance "H" they saw in some folk remedy or similar. And a few days later they were free of their ailment. Of course they'll say: _"thanks to substance H, I got better!"_ and everyone will believe it. Even more so if several people report the same thing. But none of them actually investigated the case. They drew conclusions after the fact. That's the wrong way.

The correct way: if we formulated the hypothesis that such substance "H" works, we would need to experimentally obtain more data sets with results that exceed what could easily be obtained through randomness alone, as we've seen above. In the birthday case, you only need 23 people to find 2 people with the same birthday out of a universe of 365 different days in a year!!

People will only remember that, coincidentally, a thousand people "were cured" by substance "H." But they ignore the other ten thousand with the same ailment, treated with the same substance, who showed no improvement at all. We prefer to ignore the ten thousand and only look at the "magnificent" thousand positives. As we can see, numbers out of context are absolutely useless.
