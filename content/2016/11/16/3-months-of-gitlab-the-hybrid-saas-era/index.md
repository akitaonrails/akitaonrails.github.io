---
title: 3 Months of GitLab. The Hybrid-SaaS Era
date: '2016-11-16T16:44:00-02:00'
slug: 3-months-of-gitlab-the-hybrid-saas-era
tags:
- gitlab
- saas
- business
draft: false
---

If you didn't already, maybe it's a good idea to read my previous post on [Moving to GitLab! Yes, it's worth it!](https://about.gitlab.com/2016/08/04/moving-to-gitlab-yes-its-worth-it/).

My impressions stem from very specific circumstances, so this is not to be read as a general recommendation for every situation. For example, I didn't review GitLab's hosted options, which may be more compatible with circumstances different than mine.

In my case, the move to GitLab was part of an internal company strategy to have more control over our own data. In that strategy we also moved from using Slack to Mattermost, and from using Pivotal Tracker to my own open source alternative called [Central](https://github.com/Codeminer42/cm42-central), among other things.

Before the migration, I had dozens of active projects over GitHub and lots of archived ones at Bitbucket. I'm the kind that hates to lose data, so I keep redundant backups and try to never erase anything.

I moved almost everything over to my own GitLab server and this is almost **200 repositories**, spread in 4 groups, with almost 80 active users. This accounts for more than 13,500 notes and over 5,200 Merge Requests already, and over 2,500 builds in the CI, and the internal Sidekiq controlling everything has over 51,000 jobs processed.

In the last 3 months since the migration, I am paying a Digital Ocean bill of around $140 every month for the exact infrastructure I described in the previous article, with a separated box for the GitLab Core, the CI Runner, the CI Docker Registry Mirror, the CI Cache server and disposable machines for parallel builds, controlled by the Runner.

Although the reduction in cost is welcome, the whole endeavor was not done because of it. I could easily pay double or triple just for the convenience, but the underlying strategy is more important in this case.

My company has over 60 developers, working from our own offices in 6 different cities in Brazil (no freelancers and no home-office), communicating daily over Mattermost, Code Reviewing through GitLab's Merge Requests, having immediate automated tests feedback from GitLab CI, and project management through our own Central application.

The only piece that is currently missing is a good static code analysis tool. We heavily rely on Code Climate, which I strongly believe is one of the best out there from our own experience.

I was about to start an endeavor to build a simplified OSS version to integrate into GitLab CI's, but [Bryan Helmkamp recently announced](http://blog.codeclimate.com/blog/2016/10/06/series-a-and-community-edition/) that they would release their own "Community Edition" version of Code Climate in the next few months.

This is exactly the missing piece in my stack, and it will make my strategy move faster for next year.

### Hybrid-SaaS Era

In the past 5 to 10 years there was a fast move towards 3rd party "micro-services" structure. And this is really great as it allowed many small companies or even independent developers to tap into technology that made them not only move faster, but with increasingly more quality in their delivery.

It's now super easy to have top-notch upload and storage service through tools like Cloudinary.

Also very easy to have top-notch relational database, with replication and scalability, such as Heroku Postgres or AWS RDS.

Project management as a service with Pivotal Tracker, Trello.

Communication as a service with Slack, Hangout, etc.

Knowledge Management as a service with GitHub, Bitbucket, etc.

So now many tech companies are a mashup of several different 3rd party services.

My small beef is that our entire knowledge, experience, portfolio is spread across a dozen or more opaque services, completely out of our control and depending on each company's (or their investors) whim.

Don't get me wrong, I am not against using those services, on the contrary. I use several of them and I will continue to use many of them for the foreseable future. Some endeavors would not even be possible without the efficiency of this sample of a technology-based free market.

But every now and then you reach a tipping point where it becomes important to have more control over your own data, your own identity. Not only for pure ownership but also to be able to use this data with better intent.

And I believe that at that point we should have an option that doesn't cost a couple of limbs to replicate.

Before an option such as GitLab, we were either limited to choose between walled-gardens such as GitHub or Bitbucket or you could invest a ton of resources trying to use small open sourced components to try to build your own. With GitLab we now have the option to make a smooth transition to its hosted option, so we don't incur in having to deal with infrastructure maintenance or we can choose to have full control. And the users will not suffer in the process.

Which is why I believe that the best SaaS to endure the next decade will start to go into **Hybrid-mode**: having a commercial, usually "cheaper", hosted option, and a DIY (do-it-yourself) OSS version.

GitLab is like that. Mattermost is like that. Now Code Climate is getting like that.

In that option, companies like GitLab have a win-win situation. Many more people and companies can contribute towards making a mature and robust platform that everybody enjoys using, and at the same time, each participant can extend it to their own particular plans. GitLab can have a sustainable business model serving the long tail of companies and developers that want a reasonably affordable hosted service while the top 20% can pursue more specific endeavors using the same technology.

That way we remove the discussion of confidentiality, the way companies treat our data, and we move forward into more productive actions such as building a tool that benefits both the external public and  each others internal plans.

Walled gardens are here to stay. Releasing integration - whilst opache - public APIs is not enough. It's very exciting to see those new options arising to fill this gap. The OSS environment along with a sustainable business model makes sense. And I hope to continue to see more and more competitors to closed services following the Hybrid model in the near future.

Why go the trouble to install, maintain and tweak open sourced alternatives to well-established hosted (albeit opaque) services? I believe more than a discussion over convenience, maintenance and cutting costs. We should start small, less risky, but as we grow we should be able to take control back. But we usually can’t get out of walled gardens without a significant - and sometimes impossible - investment in reinventing the wheel. We always had the small open sourced components that those services are built on, but to go from those small components to a full-featured system, it’s an unrealistic path.

With this possible trend of post-SaaS, or Hybrid-SaaS as I call it, we may have just gained the missing link to go from just convenience to full control without the inherent costs and risks chasm.
