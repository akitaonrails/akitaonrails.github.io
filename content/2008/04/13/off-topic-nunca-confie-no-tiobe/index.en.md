---
title: 'Off Topic: Never Trust TIOBE'
date: '2008-04-13T14:40:00-03:00'
slug: off-topic-nunca-confie-no-tiobe
translationKey: off-topic-nunca-confie-no-tiobe
description: "Examining TIOBE’s formula, the author shows how search-engine hits, duplicates, and noise distort the measurement. The index therefore cannot support reliable conclusions about language growth."
tags:
- programming-languages
- science
- off-topic
draft: false
---

I have used TIOBE numbers in presentations and in articles on this very blog. I had a vague notion of how they put that index together, but never stopped to think hard about it. Does anyone here know how the TIOBE "Language Popularity" index is actually formed?

Today I read [two](https://blog.timbunce.org/2008/04/12/tiobe-or-not-tiobe-lies-damned-lies-and-statistics/) [articles](http://web.archive.org/web/20080527051237/http://contentment.org/2008/04/perl-is-not-going-away.html) discussing exactly that. Both are right, and if you stop to think for 30 seconds, it was obvious I should never have used those numbers. Me, of all people, who has spoken more than once about the dangers of misused statistics! Let's understand why.

So, how is the TIOBE index formed?

It's a percentage, with no adjustment whatsoever, of the number of hits on 5 search engines for the terms +"[language] programming". Let's look at examples with absolute numbers from Google alone:

- Java: 3.4 million hits
- C: 2.2 million hits
- C++: 1.7 million hits
- PHP: 1.5 million hits
- Perl: 0.9 million hits
- Python: 584 thousand hits
- C#: 558 thousand hits
- Ruby: 363 thousand hits
- Smalltalk: 28.4 thousand hits
- Groovy: 15.7 thousand hits

Now let's see Yahoo!:

- C: 12.3 million hits
- Java: 9.6 million hits
- C++: 4.9 million hits
- PHP: 4.9 million hits
- Perl: 2.8 million hits
- Python: 2.2 million hits
- C#: 1.9 million hits
- Ruby: 1.6 million hits
- Smalltalk: 103 thousand hits
- Groovy: 31.3 thousand hits

There are also exception lists for grouping or splitting terms. C#, for example, is also searched as "CSharp", "C-Sharp", "C# 3.0", and the results of all of them are summed as "C#". In the example above I simply searched for "C# programming".

After that, they take each language's total results and divide by the total of the top 50. In my example, with the 10 in the list, C# comes out at 558 thousand / 11,249,100 = 4.9%. The same is done for Yahoo and the other search engines. The final percentages are summed and divided by 5. Here's what you get in my smaller example, using none of the exceptions and only the 2 major search engines:

- Java: 27%
- C: 25%
- C++: 13.6%
- PHP: 12.7%
- Perl: 7.47%
- Python: 5.3%
- C#: 4.87%
- Ruby: 3.6%
- Smalltalk: 0.3%
- Groovy: 0.1%

There you go: we just saw the easy way to manufacture indices. This methodology is absolutely broken, and you don't need to be a statistics expert to say so. It can't even be compared to a methodology considered "serious", like an IBOPE poll, which is controversial anyway.

## The Problems

Some of the problems that I, a statistics layman, can point out:

- Blind trust in third parties: the search engines are presumed to do a good job.

- Duplicates count. The same article that gains notoriety gets re-published on hundreds of blogs (many of us bloggers are notorious for being mere echoes of primary sources). What should count as 1 suddenly becomes 100. Google App Engine, just launched, must be inflating Python's index, for example.

- All 5 search engines weigh the same, because the index is just the simple average across all of them. There is no adjustment factor. And Yahoo!, in my experience, does a terrible job at search: "C programming" returned 2.2 million hits on Google and 12.3 million on Yahoo!. I doubt Yahoo's database is 10 times larger; most likely it's 10 times worse at filtering out noise. I wouldn't be surprised if it counted "Objective C programming" as a hit for "C programming", something at the level of the basic `select * from table where text like "C programming"`.

- The hit count depends on the exact search string. "Ruby programming" brought a mere 363 thousand hits on Google. But "Ruby Rails" brings **8.1 million** hits (!). I browsed all the way to page 63 and every link was genuinely about Ruby and Rails (no gemstones, no train tracks, so very little noise). With the same string, Yahoo returned 3.9 million, well above the previous 1.6 million. It becomes clear how hard it is to arrive at a reliable number for each platform.

The complaint from both authors of the posts I linked is this: even with the results we saw, why did Python become last year's language of the year? Why did Ruby become the language of the year before that? By this method it's clear that Java, C, C++, Perl, and PHP are an order of magnitude above.

My assessment: the TIOBE Index assumes too much and lets too many errors slip through. In a measurement situation like this, the margin of error is larger than the number being measured. Drawing any conclusion from it is practically impossible.

Want an equally ridiculous methodology? Let's "assume" that a person who receives a political candidate's flyer and doesn't throw it on the street likes the candidate. We could elect a president by counting the flyers thrown on the street: whoever has the fewest flyers on the ground is the most liked and, therefore, the winner.

I've talked about this in another article: [We Are Mathematically Illiterate](/en/2008/3/1/off-topic-somos-matematicamente-ignorantes). Unfortunately, unlike first-year algebra, statistics is still a very poorly understood field. I studied statistics at the Institute of Mathematics and **Statistics** at USP and I still know very little about it. People are constantly forced to "swallow" the numbers TV shows them, without knowing how to judge, at minimum, whether the criteria are adequate.

My recommendation: when in doubt, ignore the indices. I'm no Dijkstra, but I'd say _"Statistics Considered Harmful"_. As long as people don't understand what statistics are, showing them indices is just trying to lie with more substance. In the article I linked above, Tim quotes Mark Twain:

> "There are three kinds of lies: lies, damned lies, and statistics."

For my part, I don't intend to mention TIOBE ever again in any article or presentation as an argument that Ruby is growing. In practice, I believe there is no reliable index today to evaluate that.
