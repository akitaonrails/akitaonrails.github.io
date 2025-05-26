---
title: "[Off-Topic] Blogs are Obsolete. What's Next?"
date: '2013-05-04T14:46:00-03:00'
slug: off-topic-blogs-are-obsolete-what-s-next
tags:
- insights
- english
- blog
draft: false
---

Up until now I have almost 900 blog posts written over a period of 7 years. Some of those posts already "expired" as the piece of information got obsolete. Many of those are still very relevant and useful today.

People that have been following my blog for the past 7 years had the chance of reading most of those articles. But what about the new people? It's very hard to explore old good articles around a pool of almost 900.

Every blog still follows the very same structure: they are sorted by date in descending order, they show up one at a time in a long stream. Only new posts (or those manually chosen) show up at the top. As soon as I post a new article, the previous one become less relevant. If the blog is paginated, last month's posts will be buried and hidden in previous pages. Most people don't navigate to previous pages nor go through tags (which only help so far).

People looking for some specific pieces can search them through Google (or internal Search if I implement one). 

A blog is structured in a way that old posts must remain less relevant and more difficult to find. It's a good enough structure for a news feed. If you write columns, opinions, research, timeless material in general, it's a horrible structure.

We've seen a plethora of blog engines around but they are all exactly the same: a post has many comments, new posts go first in the feed, old posts go to hidden pages in a precarious pagination system.

Several other things have been tried already, none of them succeeded in solving this issue. Tags, featured articles, hierarchical categories, random visualizations of old posts in the main page. None solve the problem of **discoverability** of old still-relevant posts for new readers.

Maybe this is an unsolvable problem and I don't have a good idea to move forward with this structure. So I'm interested in seeing if anyone else tried to tackle this problem with a different perspective or if new approaches are emerging in this field. Please comment below if you've seen new ideas coming out.

<tt>Post.order("created_at DESC").page(params[:page])</tt> is history. What's next?

![Obsolete](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/345/obsolete.jpg)
