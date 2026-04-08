---
title: "[Off-Topic] Agile Done Wrong"
date: '2013-11-01T10:48:00-02:00'
slug: off-topic-agile-feito-errado
tags:
- off-topic
- career
- management
- agile
draft: false
---

One of the most common things I've seen in countless companies is trying to adopt some methodology in the hope that it will improve things. Invariably nothing changes and it even gets worse. I've repeated this countless times and I'll repeat it again: Agile isn't a silver bullet, it's not a magic recipe that will fix bad professionals. Bad professionals can't be fixed. To be clear: a junior professional, who still has technical deficiencies and wants to grow, will be able to learn techniques, practices, tools, and improve in technical quality, productivity, and efficiency. A bad professional, who may even have some technical capacity but is more interested in little work, little effort, little responsibility, and is even bad-character in their conduct and attitude, is not going to change.

Agile is another [formula](http://www.akitaonrails.com/en/2013/10/30/off-topic-matematica-trolls-haters-e-discussoes-de-internet) whose image (result) is the [promise of hyper-productivity](http://www.akitaonrails.com/en/2009/12/10/off-topic-voce-nao-entende-nada-de-scrum) that can reach 500% of the current. Again, what is the Domain (the premises)?

The most basic premise for Agile is that the team has technical capacity and commitment. No methodology will teach or change that — either each individual on the team is a capable person or it simply won't work. Making well-made, well-organized code, following the known good practices, with tests, with discipline, etc., is the minimum necessary to start — it's the rice and beans. If that doesn't already exist, give up, no methodology, no voodoo, no exorcism, no feng shui, will help. What will happen when you put Scrum or XP practices or Kanban or anything else into a bad team, with weak leadership, are some of the following prostitutions of the good practices:

## Planning for Show

A good planning is only possible if the Product Owner dedicates themselves to having a prioritized and well-defined backlog. And understand, the definition of User Stories should be ready **before** the Sprint Planning. A vague, poorly defined User Story won't help at all. While the team is working on the Sprint, the PO should define the User Stories — they can join one or more members of the team itself or of parallel teams to help with this. During the Sprint Planning, everything should already be well defined, preferably pre-pointed, prioritized, and the team will merely point the Sprint and, according to the current Velocity, see what fits in the next Sprint. It's a meeting that, if well done, will last 1 or 2 hours at most.

Symptoms: if it takes more than 2 hours, has too many people just to make quorum, poorly defined User Stories that generate endless discussions and no action, you're doing it wrong.

## Pair Programming for Show

Pair Programming is a very good practice — the team decides how to practice it. But you can find a team member who almost never programs well alone and, when doing the "pair," is more of a listener than a participant — the famous "dead weight." Just sits there giving hints or even just sits in silence (playing Candy Crush or browsing Facebook). That is, it has no value at all.

Symptoms: This is easier to happen in very large teams (above 6), as it becomes easier to "hide" doing pair-fake with different people. In fact, I never recommend more than 4 people on an agile team. Even being a single product, if there are 15 people, for example, it's better to divide into 3 teams of 5 people. Even better if the people rotate on those teams so that "cliques" don't form where one bad guy protects another bad guy.

## Departmental Protectionism

Professional programmers today need to be multi-functional, versatile. Obviously each has one type of capability better than another. For example, what we'd call a "front-end" should be the master of HTML 5, CSS 3, JavaScript, but should also know the minimum of Rails, Node.js, Python or whatever the back-end is in order to be able to organize the templates, integrate with controllers, models, helpers, etc. And the "back-ends" should also minimally know HTML, and even infrastructure.

Pointing of User Stories (whether in Story Points, Working Hours, etc.) should always be the same no matter who pulls the User Story. There's none of: "these 3 stories are mine, these 2 are so-and-so's, these 4 are what's-his-name's." Stories are prioritized and each one pulls a story at a time as they finish the previous one.

Symptoms: stories that are pointed differently depending on who's going to pick them up, or "reserved" stories, or types of stories only one "type" of professional can pick up. There's none of "this story is infra, only an infra guy should be able to pick it up, and the back guy shouldn't be looking at it." Sprints are the responsibility of the entire team.

One of the advantages of pair programming and small teams is for each one to learn new capabilities from the others. A back-end dev may pull a Story that has something of front-end, but they're not the best at front-end — but when they need to, nothing stops them from asking to pair with a good front-end on the team to help. A User Story may take 2 hours if done by a good back-end, but it may take 5 hours if done by a front-end.

The correct thing is for the front-end guy to get close to the 2 hours and not for the story to be reserved. The correct thing is for the team's velocity to gradually increase, and for that the individual velocity of each member should gradually increase. And for that they should constantly learn new capabilities. That's how everyone evolves. Reserving stories is the best example of a punch-the-clock worker wanting to 'protect' their job and hide their mediocrity.

## Quality for Show

All members of the team should be concerned with both the technical quality of the code and the functional quality (whether the functionality actually behaves correctly with end users). Many times there are teams that allocate people with the sole goal of being a "Q&A" (Quality Assurance), who take responsibility for building test cases, automating integration tests, aligning with the PO and with business analysts, marketing, etc.

I'll say that personally I don't like this distinction, but I confess that in some cases it really does make a lot of sense. Except this should be done in such a way that the responsibility for delivering functionality that actually works is not taken away from the team — there can't be the feeling of "who cares if there are bugs, the Q&A will catch them later." But that's what often happens.

Symptom: look for User Stories that are delivered, then rejected, then redone, then rejected, and stay that way for a long time. A User Story that goes 1 month without being accepted is a monstrous absurdity, an abomination. Even worse if there are team members where, when you look at the past backlog, you'll see they're always involved in stories that are always rejected and always take days to be accepted. It's the typical case of the professional who keeps their job by solving problems they themselves created. Remove those rotten apples from the team as soon as possible — they contaminate the whole pot very quickly.

## Excuses, Excuses, Excuses

"I couldn't do it because we were missing a test, but the guy who does tests was overloaded so I got stuck."

"I couldn't do it because there was an obstacle in the other team that they didn't resolve, so I got stuck."

"I couldn't do it because it was poorly specified, I sent an email to clear it up, no one answered, so I got stuck."

A good professional gives solutions, not points fingers or keeps looking for excuses to justify their own incompetence. Does that mean nobody can complain? Of course not, there are always hard-to-solve problems, and people can and should always seek help when needed.

Symptoms: But it's easy to identify the professional procrastinator. The guy is never at his desk, spends more time chatting at the coffee machine than working. Arrives late every day, leaves early every day. When he's at his desk, you look over and the unfortunate guy is on YouTube! or on Hacker News. And let it be very clear: none of these activities, in isolation, is a problem. Even I take a break and hang out on Facebook. It's just that whoever has this behavior **constantly**, **routinely**, is joking around. And worse: if at the end of the day his task is finished, with well-made code, no bugs, etc., I wouldn't complain, but normally it's not: the task is incomplete, poorly made code that always has to be redone. And the guy comes with excuses similar to the ones I showed above.

That's being bad-character, that's a criminal's attitude. He's deliberately stealing from the company — his salary is being paid and the value isn't being delivered. He's a thief.

A good professional, who works seriously, doesn't wait to be pressed to say "ah, I asked, no one answered, so I didn't do it." A good professional, when they encounter an obstacle, chases the problem. If it's a technical doubt, they ask the colleagues next to them (in person, email, chat, gtalk, etc.). If the problem is functional, they run straight to the PO. If the problem is departmental, they themselves get up from their chair and go to the other team to clear the doubt. If the task depends on a third party who didn't want to collaborate, they go directly to their boss to solve the problem. Anyway: the basic symptom of the bad professional is that they don't go after it — they're happy when they encounter the obstacle because in a week, only at the next Review meeting, they'll say "daaaamn, I even tried to do it, but so-and-so didn't collaborate, so I couldn't." You've got to be kidding.

## Conclusion

If your team has only 1 of the problems described above, it's already a catastrophe. If it has more than one, it's a military intervention problem, Iraq level. More than that, only a nuclear bomb to solve it. And worse, someone who exhibits **all** the bad behaviors described above is a criminal sociopath. It's no use scolding, it's no use trying to fix them: there's no fixing ... but there's a solution: change the rotten apples as soon as possible.

And again, to be clear, it's obvious that there are all kinds of bad professionals — I'm not just talking about programmers. There are bad managers, bad analysts, bad coordinators, bad supervisors, bad directors, etc. This applies to everyone.

If you're a programmer and you see all this, chase after it, but if the problem is in upper management, I'm sorry to say there's nothing to do. Now, if you're a manager, a supervisor, someone in an authority position, and you're not taking any action knowing all this: resign, you're doing very wrong and being complicit with an environment whose culture is bad character.

Applying 'some' Agile practices, interpreted the wrong way, isn't being Agile, it's fooling yourself. It's like a nutritional diet. During the day you follow the diet strictly, but when no one is looking you eat chocolate and sweets, and the next day you say "damn, I don't know why this diet isn't working, I'm following it correctly, I think the diet doesn't work, let's try another one." #lamentable
