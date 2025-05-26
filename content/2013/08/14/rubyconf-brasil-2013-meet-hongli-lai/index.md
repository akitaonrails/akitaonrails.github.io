---
title: 'Rubyconf Brasil 2013: Meet Hongli Lai'
date: '2013-08-14T17:41:00-03:00'
slug: rubyconf-brasil-2013-meet-hongli-lai
tags:
- rubyconfbr2013
- english
draft: false
---

![Hongli Lai](http://www.rubyconf.com.br/assets/speakers/hongli_lai-2cfc23d129a2a1f001d84df45863071a.jpg)

If you didn't register yet, don't miss this opportunity. Go to [the official website](http://www.rubyconf.com.br) to register as soon as possible. The conference will commence on August 29th.

This is the 6th consecutive year that Locaweb and myself are organizing yet another great Rubyconf in Brazil. Several great established companies and tech startup are supporting the conference sending great developers. 

Meet [Phusion](http://www.phusion.nl/) the group of computer scientists from the Netherlands that first made Ruby on Rails deployment really easy. Most people won't remember but prior to 2007 it was pretty painful to deploy a Rails application. Zed Shaw brought us Mongrel. But it was not until Phusion released Passenger that we started to speed up to the point where Ruby web deployment became the gold standard.

Hongli Lai is coming here for the second time, he was in the very first Rails Summit Latin America 2008 together with his partner Ninh Bui. Since then they have been evolving the Passenger technology, making it work with Apache, NGINX and in several different customizations and scenarios.

Don't miss his closing keynote about Passenger precisely at 4:45PM of the first day of the event. Let's get to know more about him:

"Your talk is about the upcoming Phusion Passenger 4, can you explain what some of the requirements are to understand what you're going to talk about?"

**Hongli:** To understand the talk, you should have a basic understanding on how to deploy a Rails application. For example, past experience with using Phusion Passenger, Unicorn, Puma or Thin will be very helpful. You don't have to understand it very deeply, because the talk is designed to be easy to follow even for beginners. A part of the talk, especially the optimization and tweaking part, will be more advanced, but I will structure them in such a way so that beginners can follow it as well.
 
"Many developers would love to become as experienced and fluent in Ruby as you are. What have been some of the pitfalls you had to overcome in order to become a great developer? Any good tips for a Ruby beginner?"

**Hongli:** I believe the best way to become good is to get a lot of practice. I do not believe in talent, but I do believe in hard work. I think I am at the place I am now because I've been developing software for more than a decade. For the first few years, my code sucked and I didn't really understand what I was doing. It was only after years of experience that I began to produce good code.

In the beginning, I was self-taught. Self-teaching can get you very far, but there are certain mathematical and formal foundations that are best learned at a university. In that regard, my computer science education has helped me a lot, although I could never have reached my current level without a lot practical experience as well.

Finally, it is a good idea to be curious about other people's work. You will learn a lot by studying others' design and code, both with regard to what to do and what not to do. It is also a good idea to be open minded, and not to jump to conclusions too quickly. What at first glance appears to be a bad piece of code written by someone else may have legitimate reasons for being like that. It is important to understand those reasons.
 
"There are so many new technologies, best practices and so on being released all the time. In your personal opinion, and maybe related to your current field of work, what are some of the trends in technology that you think we should be paying attention for the near future?"

**Hongli:** I do not believe you should pay too much attention to trends. Trends come and go, and a lot of the current trends are just modifications of past trends. Furthermore, not all trends may be useful to you in their raw form. Instead of following a trend, you should understand the core reasons behind the trend, and adopt those instead.

That being said, there are several trends which I believe are good trends to follow and which I believe are timeless:

* Automated testing. You should definitely have automated tests, which have saved me time and time again in the past. Having a good test suite gives you confidence and reduces developer anxiety (fear of breaking something), which allows you to develop faster. There are several styles in area the automated testing, e.g. TDD and BDD. I belong to none of them, but I take ideas from all of them and apply them where I think makes sense.

* Continuous integration. Instead of having long development cycles, and integrating developer branches after a long time, or releasing software to staging after a long time, you should do it short intervals. This will give you more confidence, reduces developer anxiety and will allow you to release to production with less hassle. Continuous integration implies automated testing. A CI tool such as [Travis](https://travis-ci.org/) or [Apachai Hopachai](https://github.com/phusion/apachai-hopachai) is indispensable.

* Operational automation. If a task takes too many steps, or if it's too mentally draining (which makes it easy to introduce human errors), consider automating the task as much as possible so that you only have to enter one command to get it done. There are two trends which are strongly related to this core idea:

* The devops movement. Compared to traditional sysops, which performs a lot of tasks by hand, the devops moment seeks to automate as much as possible. You describe your cluster configuration in code, and a tool such as Chef, Puppet or Ansible builds the cluster for you. It changes the game so much if you can run a single command to rebuild your entire server cluster, instead of manually installing and configuring software every time.

* Virtualization of the development environment. This is like devops for development environments instead of for production environments. Instead of letting your developers build their development environment manually (installing a compiler, installing git, installing MySQL, editing your software's config files, etc), you describe the environment in code and let a tool such as Vagrant (in combination Chef, Puppet or Ansible) build it for you. All developers will have a consistent development environment, and they can set up a new one quickly whenever they switch machines. When done properly, no human error will be possible.
