---
title: "[Off-Topic] Blogs are Obsolete. What's Next?"
date: '2013-05-04T14:46:00-03:00'
slug: off-topic-blogs-are-obsolete-what-s-next
description: "After nearly 900 posts, the author argues that chronological blogs bury useful older work. Tags, categories and featured posts still fail at discoverability, leaving the blog structure in need of a new model."
tags:
- blog
- arquitetura-de-software
- off-topic
draft: false
---

Up until now I have almost 900 blog posts written over a period of 7 years. Some of them already "expired", the information they carried got obsolete. Many others are still very relevant and useful today.

People who followed my blog over those 7 years had the chance to read most of these articles. But what about the newcomers? It's very hard to explore the good old articles buried in a pool of almost 900.

Every blog still follows the same structure. Posts are sorted by date in descending order and show up one at a time in a long stream. Only new posts, or the ones I manually pick, sit at the top. As soon as I publish a new article, the previous one becomes less relevant.

If the blog is paginated, last month's posts get buried in previous pages. Most people never navigate to those pages, and they rarely dig through tags, which only help so far. People looking for something specific can search through Google, or an internal search if I ever build one.

A blog is structured so that old posts must stay less relevant and harder to find. That works well enough for a news feed. For columns, opinions, research, timeless material in general, it's a horrible structure.

We've seen a plethora of blog engines over the years and they are all the same. A post has many comments, new posts go first in the feed, old posts go to hidden pages under a precarious pagination system.

Several things have been tried already and none of them solved this. Tags, featured articles, hierarchical categories, random showcases of old posts on the front page. None of them crack the **discoverability** of old, still-relevant posts for new readers.

Maybe this is an unsolvable problem, and I don't have a good idea to move past this structure. So I want to know if anyone else has tackled it from a different angle, or if new approaches are emerging. Please comment below if you've seen fresh ideas coming out.

<tt>Post.order("created_at DESC").page(params[:page])</tt> is history. What's next?

![Obsolete](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/345/obsolete.jpg)
