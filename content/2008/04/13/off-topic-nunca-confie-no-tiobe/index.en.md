---
title: 'Off Topic: Never Trust TIOBE'
date: '2008-04-13T14:40:00-03:00'
slug: off-topic-nunca-confie-no-tiobe
tags:
- off-topic
- principles
- fallacies
- tiobe
draft: false
---

I have used TIOBE numbers in my presentations. I've used those numbers in articles on this blog. I had a vague notion of how they formed those numbers, but never stopped to think about them. Does anyone here know how the TIOBE "Language Popularity" index is actually formed?

Today I read [two](http://blog.timbunce.org/2008/04/12/tiobe-or-not-tiobe-lies-damned-lies-and-statistics/) [articles](http://contentment.org/2008/04/perl-is-not-going-away.html) discussing exactly this. Both are right, and if you stop and think about it for 30 seconds, it was obvious I should never have used those numbers in the first place. Especially me — having spoken more than once about the dangers of statistics misused! Let's understand why.


So, how is the TIOBE index formed?

It's an unadjusted percentage of the number of hits on 5 search engines for the terms +"[language] programming". Let's look at some examples with absolute numbers from Google alone:

- Java – 3.4 million hits
- C – 2.2 million hits
- C++ – 1.7 million hits
- PHP – 1.5 million hits
- Perl – 0.9 million hits
- Python – 584 thousand hits
- C# – 558 thousand hits
- Ruby – 363 thousand hits
- Smalltalk – 28.4 thousand hits
- Groovy – 15.7 thousand hits

Now let's see on Yahoo!:

- C – 12.3 million hits
- Java – 9.6 million hits
- C++ – 4.9 million hits
- PHP – 4.9 million hits
- Perl – 2.8 million hits
- Python – 2.2 million hits
- C# – 1.9 million hits
- Ruby – 1.6 million hits
- Smalltalk – 103 thousand hits
- Groovy – 31.3 thousand hits

But there are exception lists for grouping or ungrouping. For example, C# is also searched as "CSharp", "C-Sharp", "C# 3.0", etc. The results of all are summed as "C#". In the example above I simply searched for "C# programming."

After that they take the total results — for example, C# on Google was 558 thousand — and divide by the total results of the top 50 languages, or in my example, the top 9. So I'd get for C#: 558 thousand / 11,249,100 = 4.9%. The same is done for Yahoo and the other search engines. The final percentages are summed and divided by 5 (total search engines). Here are my smaller results using none of the exceptions and not using all 5 search engines, just the top 2:

- Java – 27%
- C – 25%
- C++ – 13.6%
- PHP – 12.7%
- Perl – 7.47%
- Python – 5.3%
- C# – 4.87%
- Ruby – 3.6%
- Smalltalk – 0.3%
- Groovy – 0.1%

Well, we just saw the easy way to manufacture indices. This methodology is absolutely broken and you don't need to be a statistics expert to say so. It doesn't compare to any methodology considered 'serious' like an IBOPE poll (which is still controversial anyway).

## The Problems

Just the ones I, as a statistics layman, could identify:

- Results from third parties — search engines — are assumed to be trustworthy, presuming they do a good job.

- Duplicates are ignored. The same article that for some reason went viral and was re-published on hundreds of blogs out there (many of us bloggers are notorious for being mere echoes of primary sources). So an article that should count as just 1 suddenly becomes 100. Look at Google App Engine just launched. That must inflate Python's index, for example.

- All 5 search engines are considered equally relevant since a simple average is taken across all of them. There's no weighting index. Yahoo!, it seems, does a terrible job at search. Searching for "C programming" on Google brought 2.2 million hits, while on Yahoo it brought 12.3 million! I doubt it's because Yahoo's database is 10 times larger — it's more likely that it's 10 times worse at filtering out 'noise'. I wouldn't be surprised if it considered "Objective C programming" as a hit for "C programming", you understand? It's like the basic `select * from table where text like "C programming"`.

- Another reason you can't trust search engine hit counts? "Ruby programming" brought a mere 363 thousand hits on Google. But what about "Ruby Rails"? That brings **8.1 million** hits on Google (!) I browsed to page 63 and they were all genuinely relevant Ruby and Rails links (nothing to do with gemstones or train tracks, for example — very little noise). With the same string Yahoo brought 3.9 million, well above the previous 1.6 million. We see how hard it is to arrive at a reliable number for each platform.

The complaint from both authors of the posts I linked to is: Even with the results we saw, why did Python become last year's language? Why did Ruby become the language of the year before that? It's clear — by this method — that Java, C, C++, Perl, and PHP are an order of magnitude above.

My assessment: the TIOBE Index assumes a lot of things and lets a lot of errors slip through. In a measurement situation like this, the margin of error is larger than the number being measured. It's practically impossible to draw any conclusions from it.

An equally ridiculous methodology? Let's 'assume' that if a person who receives a political candidate's flyer doesn't throw it on the street, they like the candidate. We could therefore elect a president by counting the flyers thrown on the street and assuming whoever has the fewest flyers on the ground is the one people liked most, and therefore the winner.

I've said before in another article: [We Are Mathematically Illiterate](/2008/3/1/off-topic-somos-matematicamente-ignorantes). Unfortunately, unlike first-year algebra, statistics is still a very poorly understood field. I studied statistics at the Institute of Mathematics and **Statistics** at USP and I still know very little about it. People are constantly forced to simply "swallow" the numbers TV shows them without knowing how to determine, at minimum, whether the criteria are adequate.

My recommendation: when in doubt, ignore the indices. I'm no Dijkstra but I'd say _"Statistics Considered Harmful."_ Until people understand what statistics are, showing them indices is just an act of trying to lie with more substance. In his [article](http://blog.timbunce.org/2008/04/12/tiobe-or-not-tiobe-lies-damned-lies-and-statistics/), Tim quotes Mark Twain:

> "There are three kinds of lies: lies, damned lies, and statistics."

For my part, I don't intend to ever mention TIOBE again in any article or presentation as an argument that Ruby is growing. In practice I believe there are no reliable indices today to evaluate that.
