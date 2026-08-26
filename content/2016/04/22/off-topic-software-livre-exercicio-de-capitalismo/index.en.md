---
title: "[Off-Topic] Free Software: An Exercise in CAPITALISM"
date: '2016-04-22T15:30:00-03:00'
slug: off-topic-free-software-an-exercise-in-capitalism
translationKey: off-topic-software-livre-exercicio-de-capitalismo
aliases:
- /2016/04/22/off-topic-software-livre-exercicio-de-capitalismo/
description: "Free software is private property distributed under a license, with voluntary exchange and competition free of any regulator. That's why projects die, forks get born, and nobody can decree success."
tags:
- open-source
- economics
- philosophy
- off-topic
draft: false
---

A sentence from [my previous article](/en/2016/04/20/off-topic-se-voce-precisa-de-validacao-provavelmente-esta-errado) raised some eyebrows:

> "The foundation of that is the open source world: the biggest capitalist experiment in software and a living example of what a Laissez-faire Free Market looks like. The best place to maintain and improve technology commodities."

The confusion comes from the word "free". Because of the freedom principles of Free Software, a lot of people associate open source with one big "socialist" experiment. My thesis is the opposite: free software is the most capitalist thing in software. No government regulates it, no agency protects bad projects, every exchange is voluntary, and competition decides who survives. No sector of the real economy works like that; the closest historical period was late 19th century America, before the Federal Reserve and the federal income tax.

Matt Asay wrote on CNET, in ["Open source: It's about capitalism, not freebies"](http://www.cnet.com/news/open-source-its-about-capitalism-not-freebies/):

> "The secret is to use open source as a means to an end, not the end itself. Open source is a means to cheap distribution, a way to get software into the hands of would-be buyers at little to no cost. It's a way to make the software experience social and less risky, because users can try before they buy and because they can tailor (or pay someone else to tailor) software to their needs for a lower cost than proprietary software affords."

And he was even more blunt in ["Sorry, socialists: Open source is a capitalist's game"](http://web.archive.org/web/20211023100641/https://www.cnet.com/news/sorry-socialists-open-source-is-a-capitalists-game/):

> "[Sarah] Grey writes that 'there are alternatives to capitalism'. She's right. Unfortunately, open source isn't one of them. Open source is the essence of Free Market Capitalism."

### Definitions, so nobody fights a strawman

First, the terms I'm using. Capitalism is private ownership of the means of production, with voluntary exchanges between the owners of that property. A Free Market is those exchanges carried out with no coercion and no regulator: supply, demand, and prices stay in the hands of the participants.

Socialism, in the classical sense, is state or collective ownership of the means of production. Public healthcare and free education in a market economy are welfare policies, not socialism. The target of this text is the model where the State owns production.

With these definitions, defending classical socialism and defending individual liberty are opposite positions: the first requires subordinating everyone's property and choices to a central authority.

### Free software is private property under a license

Open source code has an owner, always. Copyright belongs to the authors, and using, copying, or modifying that code is only possible because the owner granted a license. Without a license, nobody has any right over someone else's code, as Jeff Atwood pointed out in ["Pick a License, Any License"](http://blog.codinghorror.com/pick-a-license-any-license/):

> "Because I did not explicitly indicate a license, I declared an implicit copyright without explaining how others could use my code. Since the code is unlicensed, I could theoretically assert copyright at any time and demand that people stop using my code. Experienced developers won't touch unlicensed code because they have no legal right to use it."

There's a practical test for this property: the owner can pull the code out of circulation whenever they want. In March 2016, Azer Koçulu unpublished his packages from npm, including the tiny left-pad, after a name dispute with the Kik app. Thousands of builds broke that same day, as [Ars Technica reported](http://arstechnica.com/information-technology/2016/03/rage-quit-coder-unpublished-17-lines-of-javascript-and-broke-the-internet/). The source code stayed on GitHub; what he removed was the distribution from the registry.

Agreeing with Koçulu or not is irrelevant. The package was his property, and the decision to remove it was his. The interesting part came after: nobody got arrested, no regulator stepped in. npm restored the broken package and changed its [unpublish policy](http://blog.npmjs.org/post/141905368000/changes-to-npms-unpublish-policy). The market absorbed the shock and grew antibodies, without taking away anyone's right to walk out.

The Ruby community lived through a smaller version of this in 2009, when _why deleted his projects and vanished, [as I wrote here](/en/2012/09/07/_why-ruby-dramas-and-dynamiting-courtlandt/).

When the disagreement is internal, the exit mechanism is the fork: whoever disagrees clones the project and competes with the original. That's what happened with io.js, born as a fork of Node.js in 2014 and merged back in 2015 under the newly created Node.js Foundation, once negotiation made sense. History has plenty of thriving forks: WebKit from KHTML, LibreOffice from OpenOffice.org, MariaDB from MySQL, X.Org from XFree86. And there are derivatives that outgrew their origins, like Ubuntu from Debian.

A fork is voting with your feet. It's expensive, because it means maintaining an entire project, and that's exactly why it only thrives when the motivation is real.

### Competition implies the right to fail

In a market with no regulator, nobody keeps a bad project artificially alive. For every PostgreSQL out there, dozens of databases tried and died. For every relevant Linux distro, hundreds became footnotes. That's a sign of health: selection is working.

The justice of this process is blind. Code doesn't carry its author's biography, and the market hands out no medals for good intentions. A project survives if it convinces users and contributors of its technical merit, and dies if it doesn't.

Opening the code, by the way, saves no one. Nokia finished open-sourcing Symbian in 2010, when the platform was already losing ground to the iPhone and Android. The gesture changed nothing: too little, too late.

I compared this process to natural selection in an [old screencast](http://www.akitaonrails.com/2010/07/01/screencast-entenda-software-da-maneira-correta) (in Portuguese). The software that adapts best to the demands of its environment is the one that reproduces the most, as users and contributors. The graveyard of dead projects proves selection exists and works.

And the landscape shifts all the time. Apache HTTP ceded ground to NGINX. Firefox lost a huge slice to Chrome. Perl ceded to Python and to newer languages like Go. MySQL lost prestige among developers to PostgreSQL, faced the NoSQL wave, and still gained a competing fork, MariaDB, after the Oracle acquisition. None of these projects had squatters' rights to the throne.

### The programmer pays to participate

The free software market has a curious inversion of values. At a company, the programmer gets paid money to write proprietary code. In a well-known free project, it's the programmer who "pays", with their time and skill, to get code accepted. In return they get reputation, learning, portfolio, and yes, a bit of vanity. It's a voluntary exchange that benefits both sides, like any other.

"Price" here isn't measured only in money. Value is anything with supply and demand, and competition sets the price. The currency of this market is technical competence demonstrated in public.

That has a hard consequence: convincing others is part of the game. If your idea has value and still nobody adopts it, the most likely explanation is the idea or how you presented it, not the audience's stupidity. Blaming the audience is the fastest way to devalue your own cause.

### The paradox of "socialist" free software

Picture the opposite model: the software world under classical socialism, with production controlled by a central authority.

Without individual ownership of projects, competition ends. A bad project that serves the controllers' agenda stays alive, even when a technically superior alternative exists. Choice leaves the hands of the users and moves to the hands of the controllers. There would be no left-pad accidents, and the price of that would be a huge catalog of derelict software nobody wants to use.

Without the individual benefit of exchange, volunteering ends. No competent programmer would donate their best hours without reputation, learning, or freedom in return. And if contribution becomes a mandatory quota decreed in the name of the "social good", everyone will do the bare minimum to fill the quota. Soviet production worked exactly like that in pretty much every sector, with the results we all know.

Without competition, innovation ends. Innovation is born from an individual's will to solve their own problem their own way. Eric Raymond opened ["The Cathedral and the Bazaar"](http://www.catb.org/~esr/writings/cathedral-bazaar/cathedral-bazaar/) with that idea:

> "Every good work of software starts by scratching a developer's personal itch."

Innovation is also transgressive, because it makes entire professions obsolete. Travel agencies nearly vanished once buying tickets online became trivial. Video rental stores died with streaming. Uber squeezed cab drivers, Airbnb squeezed hotels. Whoever stayed stuck in the old model suffered, and the world moved on.

Software was the same. The GNU Hurd folks didn't celebrate when Linux exploded. Nokia found no humor in Android. MySQL doesn't root for PostgreSQL. Whoever resists the market's dynamics gets left behind. Harsh, and absolutely fair.

### The dystopia of the protected monopoly

Proprietary software can be good or bad; the problem shows up when it becomes a protected monopoly. 1990s Microsoft was a de facto monopoly. We can argue forever about whether the Department of Justice ruling was fair, but the decisive blow to the monopoly came from the market: free software, with GNU and Linux, and then the commercial internet, which took the platform monopoly away from Windows.

Imagine an alternate future where Microsoft convinces the US government that Windows is essential to national security and deserves permanent protection. Everything would have stopped. To this day we'd be using a 100 MHz Pentium running some Windows 98 derivative, on dial-up, because "nobody needs more than that".

That's the logic of handing the market's decisions to a central authority: don't invent email, it will hurt the mail carriers; don't build websites, it will hurt the printing plants; don't create free software, it will hurt the government's programmers. Every dictator uses the same speech, "for the good of the people", and every speech of "for the good of the people, whatever the means" ends in the same place.

### Tyranny and the end of free software

The worst possible case for a free project starts like this. A developer builds a piece of software to solve a problem and opens the code. For twenty years, hundreds of people use it and contribute.

Then a cause comes along, any cause, and someone appoints themselves its representative. Through social pressure and propaganda, the maintainers become pariahs. The trade press amplifies it, because controversy attracts readers. The code stops being the subject: what counts now is each contributor's personal opinions, appearance, and past.

From that point on, participating in the project becomes a risk. Contributing pays no value anymore; all it pays is exposure. One by one, the people who actually wrote code walk away, and the project withers. It's a perverse way of seizing a property and destroying its value without formally confiscating anything.

Ayn Rand dramatized exactly this mechanism in Howard Roark's trial in "The Fountainhead", and [I wrote about it in 2011](/en/2011/02/04/off-topic-the-fountainhead-defesa-de-howard-roark):

> "I came here to say that I do not recognize anyone's right to one minute of my life. Nor to any part of my energy. Nor to any achievement of mine. No matter who makes the claim!"

That's the warning. A political layer on top of a free project destroys the market that sustained it.

### Conclusion

None of this condemns anyone who contributes out of social motivation. Whoever trades their code for the feeling of helping is making a voluntary exchange like any other, and outside software that has a name: donation and volunteer work. The trouble starts when someone decides that other people's property must serve the cause they picked.

Solving the world's problems is much harder than arguing about them. Bill Gates delivered that message in 2000, pushing back on the hype that PCs would end poverty:

> "Fine, go to those Bangalore Infosys centers, but just go and try those guys three miles outside, and look at the people who are living without a toilet, without running water... The world is not flat and PCs are not, in the hierarchy of human needs, in the first five rungs."

Programmers, from any social class, have internet and resources to spare, enough to spend the day on social media debating how to save the world. The people actually working on those problems are outside that circuit, [doing instead of talking](https://en.wikipedia.org/wiki/Computer_technology_for_developing_areas).

I'll close with a real story someone told me, names removed:

> A: Man, nobody gives my [minority] a chance.
>
> B: Why don't you help me fix these issues in this open source project? Then you can give talks about it.
>
> (A vanishes. B waits, gets tired, and calls C, who fixes the issues and gets the speaking slot.)
>
> A: See, B? You're one of the oppressors who won't give people like me a shot, and you'd rather hand the opportunity to C.

And a personal note to wrap up. People label me an "Ayn Rand follower", and they're wrong: Rand merely put in writing, before me, what I already thought and practiced. Same goes for Bastiat, Friedman, Hayek, or Menger. They're references, and references are not owners. Judging an idea by its author instead of judging the argument on its merits is the definition of [ad hominem](https://en.wikipedia.org/wiki/Ad_hominem), and I don't respond well to fallacies.
