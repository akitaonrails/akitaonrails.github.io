---
title: Matches, Rankings, The Social Network, League of Legends, and Ruby?
date: '2016-11-01T10:20:00-02:00'
slug: matches-rankings-the-social-network-league-of-legends-and-ruby
tags:
- ranking
- elo
- algorithm
draft: false
---

There is a segment in a series of talks that I have been presenting in Brazil for the last 3 years or so that I never blogged about. Yesterday I just [posted about the proper way to rank content by "popularity"](http://www.akitaonrails.com/2016/10/31/ruby-on-rails-implementation-of-a-proper-ranking-popularity-system) so I thought I should revisit the theme.

To begin, I believe by now most people already watched the movie "The Social Network". It's interesting that I heard many people saying how this movie influenced them to begin their own startups. So I was thinking, "what does this movie actually teach?"

![The Social Network Casting](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/567/pasted-image-765.jpg)

Well, from the movie we learn that David Fincher is an fantastic director, that Aaron Sorkin write very sharp dialogue that is very compelling, that Justin Timberlake does a better Sean Parker than the real deal, that Andrew Garfield does an ok Eduardo Saverin, and that Jesse Eisenberg will forever be Mark Zuckerberg.

And that's it, we can't learn anything else from the movie.

Or can we?

### Facemesh

One of my favorite scenes from the movie is when Zuckerberg/Eisenberg is pissed by the Erica Albright split up and he starts scrapping women photos from the Harvard websites and organizing them into a troll web site called "Facemesh" where he puts them to compete. People can vote on which photo they prefer and it sorts them out in a ranking of popularity.

When Eduardo Saverin/Andrew Garfield shows up, Zuckerberg asks him:

<iframe width="560" height="315" src="https://www.youtube.com/embed/BzZRr4KV59I" frameborder="0" allowfullscreen></iframe>

> "Wardo, I need you (...) I need the algorithm used to rank chess players"

And he goes ahead and write the following in the dorm room window:

![Through the Looking Glass](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/569/pasted-image-759.jpg)

Here most people would just think:

> "pff, another gibberish formula just to show off that they are little geniuses, but most certainly this formula doesn't even exist"

Except it does. And this is the one scene in the movie that stuck up in my head as I saw it before. To help you out, let's reverse the mirrored image:

![The Algorithm](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/568/pasted-image-761.jpg)

And this is the "algorithm".

As I said in my previous article, most developers would create a Facemesh-like website adding integer fields in the table of contestants with the count of upvotes, downvotes and they would do something silly such as:

--- ruby
score = upvotes - downvotes
---

Or even sillier:

--- ruby
score = upvotes / (upvotes + downvotes)
---

And it doesn't work that way, you will get very wrong rankings.

### The Demonstration

To show you how wrong, I created a simple demonstration project called [elo_demo](https://github.com/akitaonrails/elo_demo) which you can git clone and run yourself.

It will create 2,000 random matches against 10 players. This will be the sorted results if we use the wrong methods of subtracting losses from wins and order through that result:

---
   Name        Games  Wins  Losses Points (wins - losses)
 1 Kong          217   117    100     17
 2 Samus         211   110    101      9
 3 Wario         197   102     95      7
 4 Luigi         186    95     91      4
 5 Zelda         160    81     79      2
 6 Pikachu       209   105    104      1
 7 Yoshi         223   112    111      1
 8 Mario         203   101    102     -1
 9 Fox           208    95    113    -18
10 Bowser        186    82    104    -22
---

Now, let's make the 2nd place Samus win 10 times in a row against the 3rd place Wario, this is the new ranking:

---
   Name        Games  Wins  Losses Points
 1 Samus         221   120    101     19
 2 Kong          217   117    100     17
 3 Luigi         186    95     91      4
 4 Zelda         160    81     79      2
 5 Pikachu       209   105    104      1
 6 Yoshi         223   112    111      1
 7 Mario         203   101    102     -1
 8 Wario         207   102    105     -3
 9 Fox           208    95    113    -18
10 Bowser        186    82    104    -22
---

Sounds fair, Samus jumps to 1st place and Wario goes down to the 8th place.

Now, what if we make the weaker 10th place Bowser win 10 times against the current 2nd place Kong?

---
   Name        Games  Wins  Losses Points
 1 Samus         221   120    101     19
 2 Kong          227   117    110      7
 3 Luigi         186    95     91      4
 4 Zelda         160    81     79      2
 5 Pikachu       209   105    104      1
 6 Yoshi         223   112    111      1
 7 Mario         203   101    102     -1
 8 Wario         207   102    105     -3
 9 Bowser        196    92    104    -12
10 Fox           208    95    113    -18
---

This is where you see how **wrong** this method is. Even though he lost 10 times against the weakest player, Kong still reigns supreme at 2nd place. And poor Bowser, in spite of all his hard work and effort, levels up just 1 meager position from 10th to 9th.

This is very frustrating and if it feels unfair, it's because it is. This kind of calculation is **wrong**.

### From Chess to League of Legends

If you ever played League of Legends you are probably familiar with something called "ELO Boosts".

![Elo Boost](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/570/Screen_Shot_2016-11-01_at_10.19.42.png)

This is a way to level up your account for money. I'd strongly recommend against it if you intend to compete professionally as it's against the rules stipulated by Riot.

Anyway, I wonder if you ever wondered why it's called "ELO".

This is for Austro-Hungarian professor **Arpad Emmerich Elo**. He is best known for his system of rating chess players. Quoting from Wikipedia:

> The original chess rating system was developed in 1950 by Kenneth Harkness (...). By 1960, using the data developed through the Harkness Rating System, Elo developed his own formula which had a **sound statistical basis** and constituted an improvement on the Harkness System. The new rating system was approved and passed at a meeting of the United States Chess Federation in St. Louis in 1960.

> In 1970, FIDE, the World Chess Federation, agreed to adopt the Elo Rating System. From then on until the mid-1980s, Elo himself made the rating calculations. At the time, the computational task was relatively easy because fewer than 2000 players were rated by FIDE.

His system has been refined and evolved to make tournment leaderbords actually fair and competitive. One such evolution is in the form of Microsoft's [TrueSkill Ranking System](https://www.microsoft.com/en-us/research/project/trueskill-ranking-system/) used in all Xbox Live games.

That "algorithm" that Eduardo Saverin writes in the window of Harvard's dorm room? It's the **ELO Rating System**!!

I don't know if Zuckerberg actually implemented the ELO rating system equations. If he did, it was the **correct** choice. But the whole Eduardo writing the equations in the window probably didn't happen that way as it would be way easier to Google for it :-)

### ELO Rating System Demonstration

My pet demonstration project also calculates that exact ELO score. The calculations are done by the [elo](https://github.com/iain/elo) rubygem.

The idea is to calculate the probability that one player has to win over the other player. So if a strong player plays against a weak player, he is expected to win, and if this is the outcome, he will not score a lot and the losing player will not fall a lot either. But if the unexpected happens and the strong one loses than it's expected for him to fall down a lot and for the "weaker" player to jump up a lot.

That will make the tournments more competitive and make the new players more motivated to play against the strongest and also make the strongest play harder to hold their positions.

From the elo gem documentation, this is how you use it:

--- ruby
kong  = Elo::Player.new
bowser = Elo::Player.new(:rating => 1500)

game1 = kong.wins_from(bowser)
game2 = kong.loses_from(bowser)
game3 = kong.plays_draw(bowser)

game4 = kong.versus(bowser)
game4.winner = bowser

game5 = kong.versus(bowser)
game5.loser = bowser

game6 = kong.versus(bowser)
game6.draw

game7 = kong.versus(bowser)
game7.result = 1 # result is in perspective of kong, so kong wins

game8 = kong.versus(bowser, :result => 0) # bowser wins
---

And this is how you assess the results:

--- ruby
kong.rating       # => 1080
kong.pro?         # => false
kong.starter?     # => true
kong.games_played # => 8
kong.games        # => [ game1, game2, ... game8 ]
---

The gem has more tuning besides that original algorithm, such as the K-factor to reward new players. Those kinds of tunings are what makes matches more competitive today and how you evolve it to TrueSkill levels, but it's beside the point of this article.

Let's see the wrong ranking again:

---
   Name        Games  Wins  Losses Points (wins - losses)
 1 Kong          217   117    100     17
 2 Samus         211   110    101      9
 3 Wario         197   102     95      7
 4 Luigi         186    95     91      4
 5 Zelda         160    81     79      2
 6 Pikachu       209   105    104      1
 7 Yoshi         223   112    111      1
 8 Mario         203   101    102     -1
 9 Fox           208    95    113    -18
10 Bowser        186    82    104    -22
---

Now let's see how the **correct** ranking is by calculating the Elo score using the exact same 2,000 matches:

---
   Name        Games  Wins  Losses Points  Elo Rating
 1 Pikachu       209   105    104      1         851
 2 Zelda         160    81     79      2         847
 3 Samus         211   110    101      9         842
 4 Luigi         186    95     91      4         841
 5 Wario         197   102     95      7         824
 6 Mario         203   101    102     -1         820
 7 Yoshi         223   112    111      1         803
 8 Kong          217   117    100     17         802
 9 Bowser        186    82    104    -22         785
10 Fox           208    95    113    -18         754
---

See how different it is? In the wrong ranking, Kong is considered the strongest, but in the Elo ranking he is just 8th place. And reason is that even though he is the one that won most matches (217) he also lost a heck of a lot (117). Someone with less wins such as Zelda in 2nd place (160 wins) lost a heck of a lot less (81), which is why she is higher in the ranking.

Now, if we make her win 10 matches in a row against 3rd place Samus, this is the new ranking:

---
   Name        Games  Wins  Loses  Points  Elo Rating
 1 Zelda         170    91     79     12         904
 2 Pikachu       209   105    104      1         851
 3 Luigi         186    95     91      4         841
 4 Wario         197   102     95      7         824
 5 Mario         203   101    102     -1         820
 6 Yoshi         223   112    111      1         803
 7 Kong          217   117    100     17         802
 8 Bowser        186    82    104    -22         785
 9 Samus         221   110    111     -1         775
10 Fox           208    95    113    -18         754
---

Again, Zelda jumps up from 2nd to 1st place and Samus fall down from 3rd to 9th. So far so good. But what about the scenario where we make strong 2nd place Pikachu against a much weaker 10th place Fox McCloud?

---
   Name        Games  Wins  Loses  Points  Elo Rating
 1 Zelda         170    91     79     12         904
 2 Luigi         186    95     91      4         841
 3 Fox           218   105    113     -8         829
 4 Wario         197   102     95      7         824
 5 Mario         203   101    102     -1         820
 6 Yoshi         223   112    111      1         803
 7 Kong          217   117    100     17         802
 8 Bowser        186    82    104    -22         785
 9 Samus         221   110    111     -1         775
10 Pikachu       219   105    114     -9         766
---

Now, this is fairness: Pikachu should have won, but losing 10 times in a row against someone considered much weaker makes him fall down from 2nd place all the way to the last place. And noobie Fox, having won 10 times against a much stronger opponent deserves jumping up all the way to 3rd place.

This is the kind of dynamic that can make matches and games competitive, which is exactly why every online leaderboard and professional tournment use those kinds of algorithms.

And it all began in chess, using math that is known since the late 40's!!

> This is the point of this post and my previous one: **the math is not new**.

Developers waste a great amount of time in stupid pissing contests over which language or tool is "shinier", but they ignore the proper math and deliver wrong results. But the math has been around for decades, in some cases, more than a full century already!

We should strive to earn the title of Computer *Scientists*. There is a lot of **science** lacking from computing nowadays. Pissing contests do not make a programmer any good.
