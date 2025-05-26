---
title: Chatting with Hal Fulton
date: '2008-01-09T21:27:00-02:00'
slug: chatting-with-hal-fulton
tags:
- interview
- english
draft: false
---

 ![](http://s3.amazonaws.com/akitaonrails/assets/2008/1/9/n767352779_362954_175.jpg)

[The Ruby Way](http://rubyhacker.com/) is the undisputed must-have book in any Rubyist bookshelf. Rather than being a ‘reference’ book it explains what it takes to really dive into the intricacies and marvels of the Ruby programming style.

Today I am very happy being able to engage in a conversation with one of my favorite authors, **Hal Fulton**. This was a great chat and I know people will be delighted as well. He is one of the Ruby veterans and certainly has a lot of experience to share. So, let’s start:

**AkitaOnRails:** First of all, it is a tradition at my blog to ask for the guest’s background. How long you’ve been at the programming career? How did you first get there? What inspires you about the computer world?

**Hal Fulton:** I started college as a physics major, but I found that I was taking computer courses for fun. I switched to computer science and the rest was history.

Unlike most younger people now, I never was really exposed to computers until I was sixteen, because personal computers were much less common then. I was hooked right away. I saw the computer as a “magic box” that could do anything I was smart enough to instruct it to do. Really I still feel that way about it.


 **AkitaOnRails:** This is almost a cliché already but I have to ask: you were one of the ‘first generation’ rubyist. How did you come to find Ruby and what was it that ‘clicked’ for you about the language?

**Hal:** I was on a contract at IBM in Austin in the fall of ‘99. In a conversation with a friend across the hall, I complained that I was never on the “ground floor” of any new technology — I was always a late adopter. And he said, _“Well, you should learn Ruby then.”_ And I said: \_"What’s that?"\_ So I got on the English mailing list and started to learn Ruby (version 1.4).

My experience before was with very static languages. I had started (like many people in the earlier days) with BASIC, FORTRAN, and Pascal. Then I learned C, C++, Java, and various other things along the way. But I was never exposed much to LISP, and I never knew Smalltalk. So the whole concept of a dynamic language was a little foreign to me. I had always known that I wanted more power, but I wasn’t sure exactly what I wanted. I tried to envision macros that would give me the kind of flexibility I wanted, but it seemed like the wrong solution.

Then I learned Ruby, and I felt that I had taken not just a single leap forward, but three leaps. It was clear to me that this was very similar to what I had been looking for subconsciously.

**AkitaOnRails:** The Pickaxe is another must-have book, but it serves the role of a complete ‘Reference’ book whereas your book is about inner underpinnings and foundations of the language – heck, you spend 40 pages just talking about String, if this isn’t detailed enough I don’t know what would be. What was your intent when you wrote the 1st edition, how it came to be?

**Hal:** I met Dave Thomas and Andy Hunt online on that mailing list. At that time, their excellent book _The Pragmatic Programmer_ had just come out, and they were working on the Ruby book. I was one of the reviewers of that book – helping to iron out little inaccuracies and problems.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/1/9/0672328844.jpg)

A little later, Sams Publishing went looking for someone to write a book. At that time, the English mailing list had very few native speakers of English, so I had a good chance of being picked. I submitted a proposal, and they liked it.

The Pickaxe wasn’t on the shelves yet, but I had intimate knowledge of its contents. So when I put together the proposal for the book, I tried to make sure it was **not** in direct competition; rather, I wanted it to be complementary. If you look on the “praise page” of the first edition, there is a quote from me, saying “This is the first Ruby book you should buy.” But privately I was already thinking: _“And I know what the second one should be, too.”_

**AkitaOnRails:** As detailed and complete as you try to be Ruby has several subtleties and nuances that are hard to capture. Was there anything that you didn’t cover at that time that you would’ve like to spend more time with?

**Hal:** There are certainly some subtleties with classes and modules, reflection, metaprogramming, and that kind of thing, that are not mentioned or not stressed. But in general a programmer shouldn’t be “too clever” when writing code anyhow.

The most glaring omission, I think, is that there is no coverage of writing C extensions. In the first edition, I simply ran out of time, energy, and space – I couldn’t cover that. In the second edition, I omitted it because I thought the C API was going to undergo radical   
changes as we approached Ruby 2.0 – more radical changes than the core classes, for example. I think this is turning out not to be true, however.

**AkitaOnRails:** You probably stumbled upon many Ruby students and enthusiasts that were learning Ruby through your book. By your experience, what do you think people get most amazed about the language, and what are the features that bite them initially?

**Hal:** I think the conciseness is one really attractive feature. Take a look at this single line of Ruby, which creates two accessors for a class:

* * *
rubyattr\_accessor :alpha, :beta—-

How would you do that in C++? Well, you would declare two attributes; then you would write a pair of “reader” functions and a pair of “writer” functions. What’s that, at least seven lines of code right there? But then what if you want to be able to assign different  
types to these? Now you have to get into overloading. It quickly becomes a nightmare. Meanwhile, in Ruby — it’s still just one line of code.

**AkitaOnRails:** What do you like the most about Ruby that sets it apart from other similar languages?

**Hal:** One of the best features about Ruby is dynamic typing. Variables don’t have types; only objects have types (or should I say, classes). Static typing was so ingrained in me that I **assumed** it was the right way. But when I gave it up, I felt as if I had removed weights that I didn’t know I was wearing.

Its **regularity** is also an appealing feature. For example, a class is Ruby is in a sense a “special” thing – but not nearly so special as in (for example) C++. A class is “just an object,” so you can do things to classes that you can do to other objects – such as pass them around, store them in arrays, test their values, and so on.

**AkitaOnRails:** And what would you improve if you were the guardian of it?

First of all, I’m glad I’m not the guardian of it. Matz does an excellent job, and he is much smarter than I am. I think there are some issues with reflection and dynamic programming that need to be cleaned up — exactly how, I’m not sure.

I look forward to a truly usable virtual machine, and I look forward to some form of method combination (pre, post, wrap). I admit, though, there are small syntax and core changes I would like to make – mostly pretty minor.

For example, I’ve always wanted an “in” operator that would be syntax sugar for calling the include? method – for example, _“x in y”_ would mean _“y.include?(x)”_ – this operator would be essentially the same as the set membership operator in mathematics (instead of the reverse) and would sometimes make code more readable and even make parentheses unnecessary sometimes. I’ve used the “in” operator in Pascal since I was 18; Python has it, even SQL to an extent. I wish Ruby had it, too.

Many times I’ve felt a need for a data structure that would be accessed like a hash, but would preserve the order specified in the code. For example, imagine a kind of “dynamic case statement” — we pass in possible matches and code to execute (as procs) for each of those matches. (It would have the advantage over a case statement that we can control the number of case limbs and their associated code at runtime.) Let’s implement it as a method called “choose” that we call in this way:

* * *
rubychoose regex1 =\> proc { handle\_case1 }, regex2 =\> proc { handle\_case2}—-

Now, what’s the problem here? The syntax fools us into thinking that regex1 somehow precedes regex2 – but when we iterate over a hash, the order is not guaranteed to be the same as in the code. (That is a property of hashes, of course, not a bug.) So we can’t control or predict the order in which these are applied. And I have found several other cases where I wanted such a thing – an associative array, a set of tuples, that had a convenient syntax for literals and had an order.

There are two usual responses to my desire for an “ordered hash.” Some people say that I’m crazy, that a hash isn’t ordered and that’s that. Some people say I could always make my own class that behaved that way – which is true, except that I wouldn’t have the convenience of representing it as a “first-class citizen” in Ruby syntax. After all, a hash “could” be represented as a second-class citizen as well – I could say

* * *
rubyHash[“a”,2,“b”,4,“c”,6]—-

instead of saying:

* * *
ruby{"a" =\> 2, “b” =\> 4, “c” =\> 6}—-

But I am glad for the expressiveness of the latter syntax.

**AkitaOnRails:** Your second edition covers Ruby 1.8. Are you researching into Ruby 1.9 (YARV) already? Being a Ruby veteran, what do you think of the directions Matz and Koichi have been choosing for the next version? Is it satisfying for you? For you, what are the good, the bad and the ugly about Ruby right now and the next version?

**Hal:** There have been minor points where I disagreed with Matz from time to time. But as I said, I am glad he is in charge. I like YARV from what I have seen so far. I am anxious for it to be 100% stable so that I can really get a feel for how it works.

**AkitaOnRails:** Your book is in the second edition, and it is a huge book, covering not only the language itself but a few 3rd party components as pdf\_writer. Are you working on a 3rd edition? Maybe we will have _“The YARV Way”_?

**Hal:** I am not working on a third edition, and I think it would be very hard to write one. The second one was harder than I expected – although much content was re-used, it still had to be re-examined line by line – and more than 50 errors still crept into those 800+ pages.

I once joked that if there was a 3rd edition, it might have to be two volumes. But really, that might not be such a bad idea – basic concepts and core classes in one volume, standard and third-party libraries in the second. But that’s idle speculation. There **is** a kind of add-on for the book being planned – but I won’t mention that until we know more details. Ask me in a few months.

As for YARV – I think Ruby will always be Ruby. We may change the inside, but the name will remain the same for the foreseeable future.

**AkitaOnRails:** Around 2002 Ruby was not widely adopted and only a handful of hobbyists and enthusiasts were using and helping to improve the language. Yourself, David Black, Nathaniel Talbott, and a lot of big guns from what I call ‘the first Ruby generation’. But in 2004 came this full fledged web framework called Rails that made Ruby publicly known and acknowledged, attracting many great minds but also a lot of trolls and amateurs. I hear that some in the first generation regret it because what was once a peaceful and insightful community became very noisy. What are your thoughts about this sudden celebrity status that Ruby gained and its side-effects?

**Hal:** Well, Ruby isn’t a private club. I wonder if the Japanese felt any offense when Europeans and others started to be interested in it? I think that we’ve certainly lost a little bit from the old days, but I don’t waste any time thinking about it. We’ve gained quite a bit also. And it’s interesting that the “friendliness” of the community has scaled better than many of us expected. Ruby is still Ruby, and Rubyists are still Rubyists. It’s just that there are more of us now – also more projects, more activity, more opportunities. That can only be a good thing.

**AkitaOnRails:** Do you work with systems development in pure Ruby or do you use Ruby on Rails for web development today? What’s your occupation or day job?

**Hal:** I’ve done a little work with Rails here and there, but I’m more of an old-fashioned generalist. I’m not a web guy. Many younger programmers, of course, seem unaware that there is any other kind of programming to be done. But if you were writing a compiler or interpreter, a custom web server, any kind of daemon or background networking app… would you reach for your Rails book? Of course not.

I’ve done system-level work in the past, but I can’t imagine Ruby ever being appropriate for the kinds of things I did back then. For those things, we used C (the universal assembly language). In my day job, I’m happily coding Ruby every single day – telecommuting for a Dallas  
company called [Personifi](http://www.personifi.com). I’d describe my work as internal applications and tools – a lot of text analysis and indexing, a little number-crunching and a lot of word-crunching.

**AkitaOnRails:** Here in Brazil we have a lot of people that were initially attracted by the Rails hype machine, now they are struggling to learn the Ruby language. Metaprogramming, Closures, Mixins, make them go nuts. Do you have recommendations for new comers?

**Hal:** What would be a good way to start experimenting with the language? Well, you can keep a copy of _The Ruby Way_ nearby. :-)

Really, I only have three recommendations. First of all, the mailing list or newsgroup is a powerful source of information, and there are still friendly and knowledgeable people there who will answer your questions. Second, there are millions of lines of Ruby source  
out there. Study it and learn from it. Third, and most important: Just play around! You don’t really learn a language by reading about it, but by using it.

**AkitaOnRails:** By the way, are you already writing a new edition? :-)

**Hal:** I’m not, and I can’t see ahead that far. But wait six or seven months, and I do hope to have a little surprise for you…

![](http://s3.amazonaws.com/akitaonrails/assets/2008/1/9/p4250004_1.jpg)

**AkitaOnRails:** In the light of the current Zed episode, he said a lot of thing specifically against the Pickaxe. One of the things is his claim that the Pickaxe didn’t mention clearly all the meta-programming stuff. Then I was talking to ‘arton’ – a Ruby book author from Japan – and he reminded me: americans and japanese seem to do Ruby differently. He said that they don’t usually do all that meta-programming in the level that Rails does, for example. As you said, they don’t try to be “too clever”.

Now, I don’t want to be apologetic because I don’t think Dave needs it, but this explains a lot given that the Pickaxe mostly only had japanese sources to rely on back in 2001. I personally learned most of my Ruby reading the Rails source code at first (and books like yours later). What do you think about this? (meaning, about the Zed episode in general, and about the different american/japanese programming styles?)

**Hal:** As for Zed, I won’t take any sides in that discussion. Zed can say whatever he wants, and usually does. I’m sure there is some truth on both sides of any controversy.

As for metaprogramming – well, I think those capabilities are in Ruby for a reason. They are meant to be used. But any tool has both appropriate and inappropriate uses. It’s impossible to generalize and say “this is always bad,” but certainly metaprogramming can be misused.

As for Rails itself, I have no doubt there is both good and bad code in it. I suspect the developers working on it would admit as much. And it is possible that they have used “too much magic” here and there, though I couldn’t say specifically where. But could Rails exist without metaprogramming features? Not in its current sense — not in any meaningful sense, I would argue.

**AkitaOnRails:** I interviewed Avi Bryant, from Seaside fame, and one of his mottos is that ‘a language is not finished until it can extend itself’ or ‘turtles all the way down’ as he says. Meaning, that Ruby still relies a lot on C extensions to this day. Of course, the initial motivations for Ruby are different than Smalltalk. On the other hand people like Evan Phoenix is pursuing this very goal: make Ruby be extensible using pure Ruby. What do you think about this new direction?

**Hal:** I like the idea of “Ruby in Ruby” in general, though Matz does not. And I am impressed with what I have seen of Rubinius so far – I think it is an important project and will grow more important.

If it’s possible to move toward an elimination of C extensions without sacrificing speed, I suppose that’s a good thing. I am not sure if it is possible. We might at least create a “Ruby in Ruby” that does not rely directly on MRI (Matz’s Ruby Interpreter). But I don’t expect to see the “original Ruby” replaced any time soon.

**AkitaOnRails:** This was a very insightful conversation, thank you!

