---
title: Ruby on Rails implementation of a (proper) Ranking/Popularity system
date: '2016-10-31T16:51:00-02:00'
slug: ruby-on-rails-implementation-of-a-proper-ranking-popularity-system
tags:
- ruby
- ranking
- algorithm
draft: false
---

I was reading a blog post published recently titled ["Ruby on Rails implementation of a ranking system using PostgreSQL window functions"](http://naturaily.com/blog/post/ruby-on-rails-implementation-of-a-ranking-system-using-postgresql-window-functions) and to be fair the purpose of the post was to introduce [PostgreSQL's "ntile" window function](https://www.postgresql.org/docs/8.4/static/functions-window.html).

But in the process, the author made the same mistake I've seen time and time again.

Let's assume you have a project with resources that you want to list by "popularity". It can be a Reddit-like site where people like or dislike posts or comments. It can be an e-commerce where people like or dislike products.

It can be anything where people like or dislike something.

The biggest error people make is to consider a simple score like this:

--- ruby
popularity = positive_votes - negative_votes
```

There is an old article titled ["How Not To Sort By Average Rating"](http://www.evanmiller.org/how-not-to-sort-by-average-rating.html) and I quote:

> "_Why it is wrong:_ Suppose one item has 600 positive ratings and 400 negative ratings: 60% positive. Suppose item two has 5,500 positive ratings and 4,500 negative ratings: 55% positive. This algorithm puts item two (score = 1000, but only 55% positive) above item one (score = 200, and 60% positive). WRONG."

Then you may think, I know how to fix it:

--- ruby
Score = average_rating = positive_votes / total_votes
```

Again, this is wrong, and again I quote:

> "_Why it is wrong:_ Average rating works fine if you always have a ton of ratings, but suppose item 1 has 2 positive ratings and 0 negative ratings. Suppose item 2 has 100 positive ratings and 1 negative rating. This algorithm puts item two (tons of positive ratings) below item one (very few positive ratings). WRONG."

### Correct Solution: Lower Bound of Wilson Score Confidence Interval for a Bernoulli

And I quote again:

> "_Say what:_ We need to balance the proportion of positive ratings with the uncertainty of a small number of observations. Fortunately, the math for this was worked out in 1927 by Edwin B. Wilson. What we want to ask is: Given the ratings I have, there is a 95% chance that the "real" fraction of positive ratings is at least what? Wilson gives the answer. Considering only positive and negative ratings (i.e. not a 5-star scale), the lower bound on the proportion of positive ratings is given by:"

![Lower Bound Bernoulli equation](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/565/rating-equation.png)

I recommend you read the [original article](http://www.evanmiller.org/how-not-to-sort-by-average-rating.html) but let's cut to the chase. If we follow the original post I linked in the beginning, I have a simple blog post Rails app, but instead of a `visits_count` field I need to add a `positive:integer` and `negative:integer` fields and user interface to post votes.

And I will replace the `PostWithPopularityQuery` class with the following:

--- ruby
class PostWithPopularityQuery
  def self.call
    Post.find_by_sql ['SELECT id, title, body, positive, negative,
        ((positive + 1.9208) / (positive + negative) -
        1.96 * SQRT((positive * negative) / (positive + negative) + 0.9604) /
        (positive + negative)) / (1 + 3.8416 / (positive + negative))
        AS ci_lower_bound
      FROM posts 
      WHERE positive + negative > 0
      ORDER BY ci_lower_bound DESC']
  end
end
```

And this is what I expect to see in a simple scaffold `index.html.erb`:

![Post index page](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/564/Screen_Shot_2016-10-31_at_16.43.50.png)

I would even go as far as recommending the `ci_lower_bound` to be a float field in the table and to have an asynchronous ActiveJob to update it in some larger interval of time (every 5 minutes, for example) and then the `PostsController#index` action would perform a straight forward `SELECT` query ordering directly against a real indexed field `ci_lower_bound DESC` without performing the calculations on **every** query.

Now **THIS** is the correct way to implement a simple, naive popularity ranking system that actually works correctly.

And this is not the only way to do it. There are dozens of good discussions of algorithms online. Every service that depends on content popularity have been refining algorithms like this for years. Facebook used to have an algorithm called "EdgeRank" which relied on variables such as Affinity, Weight, Time Decay, and it seems to have evolved so much that it now calculates popularity against more than [100 thousand variables](http://marketingland.com/edgerank-is-dead-facebooks-news-feed-algorithm-now-has-close-to-100k-weight-factors-55908)!!

But regardless of the online service, I can assure you that **none** sorts by simple visits count or simple average votes count. That would downright wrong.
