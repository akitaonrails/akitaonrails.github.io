---
title: "[Off-Topic] Agile Done Wrong"
date: '2013-11-01T10:48:00-02:00'
slug: off-topic-agile-feito-errado
translationKey: off-topic-agile-feito-errado
description: "The text argues that Agile cannot save teams without technical ability and commitment. Planning, pair programming, quality, and responsibility become a performance, and bad professionals need replacing."
tags:
- agile
- software-engineering
- management
- off-topic
draft: false
---

One of the most common things I've seen in countless companies is adopting some methodology in the hope that it will improve things. Invariably nothing changes and sometimes it gets worse. I've repeated this countless times and I'll repeat it again: Agile isn't a silver bullet, and no magic recipe fixes bad professionals. Bad professionals can't be fixed.

The distinction matters. A junior professional, who still has technical deficiencies and wants to grow, learns techniques, practices, and tools, and gains technical quality, productivity, and efficiency. A bad professional, who may even have some technical capacity, is more interested in little work, little effort, and little responsibility, and turns bad-character in conduct and attitude. That one doesn't change.

Agile is another [formula](http://www.akitaonrails.com/en/2013/10/30/off-topic-matematica-trolls-haters-e-discussoes-de-internet) whose image (result) is the [promise of hyper-productivity](http://www.akitaonrails.com/en/2009/12/10/off-topic-voce-nao-entende-nada-de-scrum) that can reach 500% of the current. Again, what is the Domain (the premises)?

The most basic premise for Agile is that the team has technical capacity and commitment. No methodology teaches or changes that. Either each individual on the team is a capable person or it simply won't work. Well-made, well-organized code, following the known good practices, with tests and discipline, is the minimum to start, the rice and beans.

If that doesn't exist, give up. No methodology, no voodoo, no exorcism, no feng shui will help. Dropping Scrum, XP practices, Kanban, or anything else into a bad team with weak leadership produces some of the following prostitutions of the good practices:

## Planning for Show

Good planning is only possible if the Product Owner commits to keeping a prioritized, well-defined backlog. And understand this: the definition of the User Stories should be ready **before** the Sprint Planning. A vague, poorly defined User Story helps nothing at all.

While the team works on the Sprint, the PO defines the upcoming User Stories, and can pull in one or more members of the team itself or of parallel teams to help. By the Sprint Planning everything should already be well defined, ideally pre-pointed and prioritized. The team just points the Sprint and, according to the current Velocity, sees what fits in the next one. A well-run meeting lasts 1 or 2 hours at most.

Symptoms: if it takes more than 2 hours, has too many people just to make quorum, poorly defined User Stories that spawn endless discussions and no action, you're doing it wrong.

## Pair Programming for Show

Pair Programming is a very good practice, and the team decides how to run it. Except you can end up with a member who almost never programs well alone and, when doing the "pair," turns into more of a listener than a participant. That's the famous "dead weight." Sits there tossing out opinions, or just sits in silence playing Candy Crush and browsing Facebook. No value at all.

Symptoms: this happens more easily on very large teams (above 6), since it becomes easier to "hide" doing pair-fake with different people. In fact, I never recommend more than 4 people on an agile team. Even for a single product, if there are 15 people, for example, better to split into 3 teams of 5. Better still if people rotate across those teams so that "cliques" don't form where one bad guy covers for another.

## Departmental Protectionism

Professional programmers today need to be multi-functional, versatile. Obviously each one is stronger at some type of capability than another. For example, what we'd call a "front-end" should be the master of HTML 5, CSS 3, JavaScript, but should also know the minimum of Rails, Node.js, Python, or whatever the back-end is, enough to organize the templates and integrate with controllers, models, helpers, etc. And the "back-ends" should also minimally know HTML, and even infrastructure.

Pointing User Stories (whether in Story Points, Working Hours, etc.) should always be the same no matter who pulls the User Story. There's none of: "these 3 stories are mine, these 2 are so-and-so's, these 4 are what's-his-name's." Stories are prioritized and each person pulls one story at a time as they finish the previous one.

Symptoms: stories pointed differently depending on who's going to pick them up, or "reserved" stories, or types of stories only one "type" of professional can pick up. There's none of "this story is infra, only an infra guy should get it, and the back guy shouldn't even be looking at it." Sprints are the responsibility of the entire team.

One of the advantages of pair programming and small teams is that each person learns new capabilities from the others. A back-end dev can pull a Story with something of front-end in it, without being the best at front-end, and nothing stops them from asking to pair with a good front-end on the team when they need it. A User Story may take 2 hours if done by a good back-end, but it may take 5 hours if done by a front-end.

The right thing is for the front-end guy to get close to those 2 hours, not to reserve the story. The right thing is for the team's velocity to climb gradually, and for that the individual velocity of each member also has to climb. And for that they have to keep learning new capabilities. That's how everyone evolves. Reserving stories is the best example of a punch-the-clock worker wanting to 'protect' their job and hide their mediocrity.

## Quality for Show

Every member of the team should care about both the technical quality of the code and the functional quality, that is, whether the feature actually behaves correctly with end users. Many times teams allocate people with the sole goal of being a "Q&A" (Quality Assurance), responsible for building test cases, automating integration tests, aligning with the PO and with business analysts, marketing, etc.

I'll say that personally I don't like this distinction, but I confess that in some cases it makes a lot of sense. Except it has to be done in a way that doesn't strip the team of the responsibility to deliver features that actually work. There can't be a feeling of "who cares if there are bugs, the Q&A will catch them later." But that's what often happens.

Symptom: look for User Stories that get delivered, then rejected, then redone, then rejected again, and stay that way for a long time. A User Story that goes 1 month without being accepted is a monstrous absurdity, an abomination. Even worse if there are team members who, when you look at the past backlog, are always involved in stories that always get rejected and always take days to be accepted. It's the typical case of the professional who keeps their job by solving problems they created themselves. Remove those rotten apples from the team as soon as possible, because they contaminate the whole barrel very fast.

## Excuses, Excuses, Excuses

"I couldn't do it because we were missing a test, but the guy who does tests was overloaded so I got stuck."

"I couldn't do it because there was an obstacle in the other team that they didn't resolve, so I got stuck."

"I couldn't do it because it was poorly specified, I sent an email to clear it up, no one answered, so I got stuck."

A good professional gives solutions, doesn't point fingers or keep looking for excuses to justify their own incompetence. Does that mean nobody can complain? Of course not. There are always hard problems to solve, and people can and should seek help when needed.

Symptoms: it's easy to spot the professional procrastinator. The guy is never at his desk, spends more time chatting at the coffee machine than working. Shows up late every day, leaves early every day. When he's at his desk, you glance over and the poor soul is on YouTube or on Hacker News.

And let it be very clear: none of these activities, on its own, is a problem. Even I take a break and hang out on Facebook. It's just that whoever behaves this way **constantly**, **routinely**, is clowning around. Worse: if by the end of the day his task were finished, with well-made code and no bugs, I wouldn't complain. Usually it isn't. The task comes in incomplete, the code poorly made, always needing to be redone, and the guy shows up with excuses like the ones above.

That's being bad-character, that's a criminal's attitude. He's deliberately stealing from the company: his salary is being paid and the value isn't being delivered. He's a thief.

A good professional, who works seriously, doesn't wait to be pressed to say "ah, I asked, no one answered, so I didn't do it." When they hit an obstacle, they chase the problem. Technical question, they ask the colleagues next to them (in person, email, chat, gtalk). Functional problem, they go straight to the PO. Departmental problem, they get up from the chair and walk over to the other team to clear it. If the task depends on a third party who wouldn't collaborate, they go straight to the boss to solve it.

The basic symptom of the bad professional is the opposite: he doesn't go after it. He's happy when he hits the obstacle, because a week from now, only at the next Review meeting, he'll say "daaaamn, I even tried, but so-and-so didn't collaborate, so I couldn't." Give me a break.

## Conclusion

If your team has just 1 of the problems described above, it's already a catastrophe. If it has more than one, it's a military-intervention problem, Iraq level. Anything past that, only a nuclear bomb solves it. And worse still, someone who exhibits **all** the bad behaviors described above is a criminal sociopath. Scolding is useless, trying to fix them is useless: there's no fixing it... but there's a solution: swap out the rotten apples as soon as possible.

And again, to be clear, obviously there are all kinds of bad professionals, and I'm not talking only about programmers. There are bad managers, bad analysts, bad coordinators, bad supervisors, bad directors, etc. This applies to everyone.

If you're a programmer and you see all this, chase after it. If the problem is in upper management, I'm sorry to say there's nothing to do. Now, if you're a manager, a supervisor, someone in a position of authority, and you're taking no action knowing all this: resign, you're doing it very wrong and being complicit with an environment whose culture is bad character.

Applying 'some' Agile practices, interpreted the wrong way, isn't being Agile, it's fooling yourself. It's like a nutritional diet. During the day you follow the diet to the letter, but when no one is looking you eat chocolate and sweets, and the next day you say "damn, I don't know why this diet isn't working, I'm following it right, I guess the diet's no good, let's try another one." #lamentable
