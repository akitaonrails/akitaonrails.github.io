---
title: Interviewed by FiveRuns
date: '2008-04-04T13:31:00-03:00'
slug: interviewed-by-fiveruns
tags:
- biography
- interview
- english
draft: false
---

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/4/4/Picture_1.png)](http://blog.fiveruns.com/2008/4/4/rails-application-monitoring-takefive-five-questions-with-fabio-akita)

Monday, Apr 1st, I was invited to participate in a series of interviews being published at FiveRun’s blog, called [TakeFive](http://blog.fiveruns.com/2008/4/4/rails-application-monitoring-takefive-five-questions-with-fabio-akita). It was just published.

Thanks a lot for FiveRuns for choosing me, I am flattered as I don’t yet consider myself in the same luminary league as [Chad Fowler](http://blog.fiveruns.com/2008/1/12/takefive-five-questions-with-chad-fowler), [Peter Cooper](http://blog.fiveruns.com/2008/1/25/rails-application-monitoring-takefive-five-questions-with-peter-cooper), [Pat Eyler](http://blog.fiveruns.com/2008/2/22/rails-application-monitoring-takefive-five-questions-with-pat-eyler), [Satish Talim](http://blog.fiveruns.com/2008/3/28/rails-application-monitoring-takefive-five-questions-with-satish-talim) and all the others in the series. I hope to get up there, though :-)

This series revolves around 5 questions out of 15 that I could choose. Being prolific – as you well know – I actually answered all 15 of them. So I will publish here the remaining 10 that didn’t make into the interview. Hope you like’em.


 **FireRuns:** What was your first _“ah-ha”_ moment with Ruby and/or Rails and when did you know that the framework was a good fit for you (or your organization)?

**AkitaOnRails:** Back in 2005 I was a Java/SAP consultant creating web applications that integrates smoothly with SAP’s underlying processes and technologies. As an eager RSS reader since than, I suddenly started seeing a lot of buzz around Rails. I already knew about the Ruby language but never did anything with it, so I decided to take a closer look. Coming from a Java background, seeing Rails in action blew me away immediately. So decided to learn it, and once I got ahold of the basics I wanted to dig deeper and read the entire Rails source-code. The outcome of this journey was my book ‘Repensando a Web com Rails’, which is a comprehensive documentation of Rails written exclusively for the brazilian audience. As I was doing SAP stuff I also documented Pier Harding’s Rails connector for SAP.

**FireRuns:** In his RubyConf 2007 Keynote presentation Matz stated that _“The suits people are surrounding us”_ – is this increasingly the case with the community, and what does this mean for the future of Ruby?

**AkitaOnRails:** Everytime I do a presentation about Ruby or Rails I emphasize that the best thing about them is not only the tecnology, but the community. The reason for Rails catching up so fast is that the community embraced it very deeply and rapidly started to fill in the several gaps. This lead to many amazing products such as RSpec. The Ruby oriented tools now surpasses those from other platforms in many ways now.

I firmly believe that adoption begins from the inside. The suits guys will not decide by themselves. The developers working inside will make the switch first and start convincing their coleagues and bosses. It is a time consuming process, but done correcly, can change the way we develop for corporations.

**FireRuns:** Do you have any secret techniques, tools, or other Jedi strategies that you can share with our readers?

**AkitaOnRails:** Unfortunately I am not in the same league as Rick Olson and other Ruby Jedi Masters. My job has been mainly trying to help our local community through information. I am a very prolific writer and I try to help the word-of-mouth process here, though we are still way behind the US in Rails adoption.

What I always recommend is to learn your tool. The first mistake many novice programmers do when they switch to Ruby is try to write in the same way they wrote C# or Java. That’s also one reason some novice programmers get frustrated because the resulting code becomes very ugly and different from those they see in the various screencasts and blogs. Buy [Beginning Ruby](http://www.amazon.com/Beginning-Ruby-Novice-Professional/dp/1590597664), from Peter Cooper; [The Ruby Way](http://www.amazon.com/Ruby-Way-Second-Addison-Wesley-Professional/dp/0672328844), the classic from Hal Fulton and watch as many [Peepcode](http://www.peepcode.com), [Railscasts](http://www.railscasts.com) screencasts as possible. Learning is part of the process that makes adopting Ruby so enjoyable.

**FireRuns:** Where do you go for Rails-related news and insight – any particular website, blogs, forums, etc. that are of particular value?

**AkitaOnRails:** Of course. Actually I subscribe to a lot of RSS feeds, dozens. So the only website I go is Google Reader. Some of my favorites are Peter Cooper’s [Ruby Inside](http://www.rubyinside.com), probably the best source of Rails related news. [DZone](http://www.dzone.com), to me, is becoming more and more relevant. Some of my favorite blogs incluse [Err the Blog](http://errtheblog.com), Josh Susser’s [has_many :through](http://blog.hasmanythrough.com), Charles Nutter’s [Headius](http://headius.blogspot.com), etc. There are so many great blogs that it’s, again, difficult to list them all. [Jamis Buck](http://weblog.jamisbuck.org), [Obie Fernandez](http://blog.obiefernandez.com), [Geoffrey Grosenbach](http://geoffreygrosenbach.com), [Ezra Zygmuntowicz](http://brainspl.at/) and so on. I usually read the digest version of the Ruby on Rails Core and Ruby on Rails Talk Google Groups as well, which are very informative.

**FireRuns:** Let’s talk about Rubinius – what do you see as the major advantage here, even though we’re obviously in the early stages? A test suite at last? A VM that folk can easily hack?

**AkitaOnRails:** As I always say in my blog, Rubinius is the technology that will become the most important one for the future of the Ruby community. Sorry Matz, but Rubinius is ‘Ruby done Right’. But don’t get me wrong, I don’t say this in a way to diminish the MRI. On the contrary, I love the MRI for what it is, but Rubinius are making all the bold decisions that will make it or break it.

I like Avi Bryant’s motto of _‘Turtles all the way’_, and Rubinius represents what I would love to have: Ruby written in Ruby. Just that would be excellent. But Evan is not stopping there, he is making several breakthrough stuff in this project. For instance, I believe the Git buzz in the Rails community really started when Rubinius adopted it. The way of giving the keys to the castle to every single person that contributes is another different paradigm shift as well.

The marriage of Rubinius and Engine Yard is delivering in spades. Rubinius was also probably important to make RSpec even more well known. Now we finally have a full suite technically describing and testing the MRI that both JRuby and IronRuby are making good use of. So it should make Ruby implementations that much more compatible and well behaving.

Evan is a very clever engineer. The way he approached a new Ruby implementation using Smalltalk’s concepts is spot on. So we get the best of both world: the elegant architecture of a Smalltalk VM with the elegance of the Ruby language. It’s a win-win situation. As soon as web framework such as Rails and Merb run without modification on Rubinius, that’s when adoption rates will explode, without a doubt.

**FireRuns:** Is Rails still waiting for its killer app, or are we already there with Basecamp, Highrise, Twitter, Hulu, Revolution Health, etc.?

**AkitaOnRails:** You probably listed all the high profile Rails apps out there. Twitter is definitely a killer-app but I am not sure if it is ‘the’ killer-app. For coders, in my opinion, Github has the potential of growing to become a killer app as well. But up until this point I will be honest and say that no, we still don’t have that kind of killer app that would make people come in flocks to Rails.

**FireRuns:** There was a great article recently on the Rails community in Austin and the Austin on Rails user group specifically. Are you part of a local user group? Tell us about your local community, what you love about it, how it is grown, and what challenges the group sees ahead of itself, in both the near and long term.

**AkitaOnRails:** Yes, I subscribe to many groups though I don’t participate actively on all of them. Our local group is Rails-br at Google Groups where brazilian Railers discuss about several Rails related subjects everyday. There are a lot of noobs and we try to answer their questions and also we help each other.

It’s growing very slowly, unfortunaly. Different than the US or Europe is that Brazil is an under-developed country. As such, people here give less value to quality of life and enjoyment of their work. They want to be hired, that’s all. And right now people learn Java and C# because they need to. So Ruby adoption is very slow over here. We still wasn’t able to get enough traction to start a positive spiral. There is only my book in portuguese about Rails, the community is small, the media is also small and not paying attention, therefore companies don’t want to try Rails because of shortage of programmers, and programmers don’t want to learn Rails because there are not that many jobs. I hope we can reverse this situation soon.

**FireRuns:** Obie Fernandez’s new startup Hashrocket, which has been blogged about extensively, is all about being ultra-productive in 3 days. Obie has written about ultra- productivity here, but we have to ask – what are your own tips around, to paraphrase Obie and 37Signals, getting real — on steroids?

**AkitaOnRails:** I’ve been working with [Surgeworks](http://www.surgeworks.com), which is a consulting firm, since June last year. So, I have less than a year of full time Rails experience. Before that I wasn’t doing full time Rails works. But we learned a lot and we still do a lot of mistakes, it’s part of the learning process. If someone tells you that they don’t make mistakes, they are lying.

Getting Real is about being pragmatic. It’s easier if you’re a startup, or yourself a product oriented team. But if you’re a more traditional company, the ‘Getting Real’ approach may feel too radical. It’s funny to say this, but it’s the truth. For them, low prices are higher priority than better quality. They expect Rails to deliver both very high quality and very low prices. There is a lot of convincing and explaining to be able to fully delivery Rails apps that the clients are going to really like.

To me, being a pragmatist is remembering Fred Brooks: ‘there is no silver bullet’. Rails is amazing but is no Silver Bullet either. It is a more elegant tool. But not every tool is able to fit in every job. Some projects are just not suitable for Rails, that’s a fact, but it doesn’t mean Rails is less good, on the contrary: it is great on the kinds of problems it was built to solve.

Programmers have to learn more than simply code. They have to get acquainted with processes and how companies operate. Being an offshore outsourced developer makes it even harder to use Agile methods, for example, so we have to stretch very hard to compensate for that. Communication is key. If the client is not willing to communicate, the project will fail, be it in Rails or not.

**FireRuns:** The Rails community at large, like many open-source communities, is in our mind very much defined by its charitable work, from the recent acts_as conference Merb/Runinius sessions, to Chad and Marcel’s yearly RailsConf testing tutorials. Is charity in many ways the glue that binds the community together? Any charitable events or initiatives that you’d like to see happen over the next year?

**AkitaOnRails:** What binds the community together is the common excitement around a subject: in this case Rails. As when you fall in love, passion vanishes very fast if you don’t maintain it. Events are a good way of doing that. You have two for one: you gain exposure for yourself, your project and your company and at the same time you contribute back with knowledge and guidance, helping promote the community all around the country. Whenever Ezra talks, it accumulates more positive points for Engine Yard and makes this brand that more easier to remember by all attendants. Marketing is very important.

In the US there are plenty of events already and still room for more. I would really like to see more action here in Brazil. But without sponsor and more support it is very difficult to make something on the scale of a RailsConf, which is sad. We will keep trying, though.

**FireRuns:** Charles Nutter recently said that _“Not liking JRuby because it is written in Java is like not liking Ruby because it is written in C.”_ That objection put aside, what is the single greatest challenge for JRuby going forward? Peter Cooper has suggested that Ruby’s only real downside is its lethargic start-up time compared to MRI, do you agree?

**AkitaOnRails:** I agree with Peter about JRuby being slow to start up, but that’s something that Charles can’t do much about because the JVM behaves like that for everything, not only JRuby. The important part about JRuby is it being fully compatible with the MRI, making it easy to develop using the MRI and then deploying into a Java application server over JRuby.

Being a former Java programmer I don’t dislike. On the contrary, I think it is a great platform, with several amazing libraries and tools that the Ruby community still don’t have. Dismiss Java is a mistake, the same way it is a mistake to dismiss C: everything is written in C.

JRuby is the second most important Ruby project, Rubinius being the first. On the other hand, JRuby is more mature and available right now so you can run your Rails app inside your corporation’s Java servers. It’s very important for a niche that needs access to legacy software – lots of old Java code. It is also important for making the point that Java doesn’t need to be the sole language to run on top of the JVM and helped making Sun more flexible towards new advancements.

