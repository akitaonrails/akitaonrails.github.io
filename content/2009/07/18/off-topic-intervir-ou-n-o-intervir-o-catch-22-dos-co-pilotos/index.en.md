---
title: '[Off-Topic] Intervene or Not? The "Catch-22" of Co-Pilots'
date: '2009-07-18T10:57:00-03:00'
slug: off-topic-intervir-ou-n-o-intervir-o-catch-22-dos-co-pilotos
description: "Drawing on airplane accidents, the author adapts the PACE protocol for software teams: ask, alert, challenge, and intervene when a manager ignores serious risks."
tags:
- management
- software-engineering
- communication
- off-topic
translationKey: off-topic-intervir-ou-n-o-intervir-o-catch-22-dos-co-pilotos
draft: false
---

 **Update 07/20:** By coincidence, this month's Você S/A magazine ran the piece [How to Deal with Toxic Bosses](http://web.archive.org/web/20090715101405/http://vocesa.abril.com.br:80/edicoes/0133/aberto/materia/mt_482359.shtml), which has everything to do with this post.

![](http://s3.amazonaws.com/akitaonrails/assets/2009/7/18/40_Crash_Test_original.jpg)

Look at this list of fatal civil aviation accidents:

1. Jetstream into Hibbing, MN, (NTSB, 1994a);
2. DC-8 into Jeddah, Saudi Arabia (NTSB, 1993a);
3. C99 into Anniston, AL, (NTSB, 1993b);
4. Beechjet into Rome, GA, (NTSB, 1992a);
5. DC-8 loss of control at Toledo, OH, (NTSB, 1992b);
6. 707 fuel exhaustion into JFK, Washington DC, (NTSB, 1991);
7. L-1011 windshear accident, D/FW Airport, TX, (NTSB, 1986);
8. MS-748 electrical failure in Pinckneyville, IL (NTSB, 1985);
9. 737 out of Washington National, Washington DC, (NTSB, 1982);
10. DC-8 fuel exhaustion in Portland, OR, (NTSB, 1979);
11. 727 into Dulles New York City, NY, (NTSB, 1975);
12. DC-8 freighter into Cold Bay, AK, (NTSB, 1974);
13. Convair into New Haven, CT, (NTSB, 1972);
14. L-188 into a thunderstorm at Dawson, TX, (NTSB, 1969);
15. Lear Jet out of Palm Springs, CA, (NTSB, 1967);
16. F-27 into Las Vegas, NV, (CAB, 1965).

Each of these accidents is an example of subordinates knowing that the Captain was denying serious risks and displaying counterproductive and unreasonably perilous behaviour. These subordinate flight deck crews all knew that their respective Captains were either denying, discounting or oblivious to lethal dangers. Unfortunately, not one of them was able to do anything to change their Captain's performance, actions or strategies; most of them could not even get the Captain to acknowledge the problem.

Maybe that doesn't make sense at first, so let's take it step by step. In aviation the hierarchy is rigid: the Pilot/Captain is the ultimate authority, and the co-pilot and the rest of the crew must never disagree with him. That's the "Catch-22" of co-pilots, the dilemma:

- You're screwed if you ignore the Captain's mistakes!
- You're screwed if you do or say anything about them!

The corollary is an unwritten rule that everyone knows:

1. The Captain is always right.
2. IF the Captain is ever observed making a mistake, see Rule 1.

As in any organization, this type of hierarchy always leads to a code of ethics that's written nowhere but every co-pilot knows very well. In this case, like the Green Eagle Code of Ethics:

- Don't sleep while your Captain is sleeping
- Encourage your Captain to smoke
- It's hell to fly with a nervous Captain, especially if you're the one making him nervous!
- Don't interfere if your Captain absolutely insists on making a fool of himself.

Survival Rules:

- Don't fly with a Captain nicknamed "Lucky";
- Don't fly at night;
- Don't fly in bad weather;
- Don't mess with the red switches;
- Never, ever eat a crew meal in the dark;
- Keep your lousy attitude a secret;
- Speak very, very softly when you speak to your Captain;
- Don't make better landings than your Captain, until the last trip of the month.

I'm not joking. Analyses of the black boxes from aircraft accidents over the past decades have shown that Captains, under stress, tired, or irritated, sometimes end up ignoring dangerous situations. The co-pilots saw the risk and had no clue how to raise it, afraid of retaliation if they turned out to be wrong. For some reason, not even the worst case, literally falling to their death, could break the hierarchical barrier.

Because of this, researchers like [Dr. Robert O. Besco](http://web.archive.org/web/20090802092433/http://www.crm-devel.org/resources/paper/PACE.PDF) built procedural models for this Cockpit Resource Management (CRM), the management of the people inside the aircraft. One of them was P.A.C.E.:

- (P)robing
- (A)lerting
- (C)hallenging
- (E)mergency Warning

### PROBING

_"Captain, I need to understand why we are flying like this."_

This is the phase where the co-pilot, spotting a potential danger, needs to confirm that the pilot knows what he's doing. Sometimes it's a calculated maneuver, fully under control, and it doesn't hurt to check. The most direct translation would be:

_"Captain, Aren't you painting yourself into a corner and aiming to shoot yourself in the foot."_

### ALERTING

_"Captain, it appears to me that we are on a course of action that is drastically reducing our safety margins."_

If the Captain didn't give a satisfactory response during PROBING, it's time to alert him to the imminent dangers. More directly:

_"Captain, it is my function and responsibility to protect your blind spots. I see you are about to walk off a cliff."_

### CHALLENGING

_"Captain, you are placing the passengers and aircraft in irreversible and immediate danger. You must immediately choose a course of action that will reduce our unacceptably high risk levels."_

You've already tried to understand, you've already tried to warn, and now it's time to challenge him and confront him with reality. In this next-to-last step, the co-pilot still gives the captain a chance to come to his senses and do the right thing.

_"Captain, you are about to self destruct. You have the equivalent of a very angry and armed bogey in your six o'clock position. We are all about to get the civil aviation equivalent of a 20 millimetre enema."_

### EMERGENCY WARNING

_"Captain, if you don't immediately increase our safety margins, it is my duty and responsibility to immediately take over control of the airplane."_

We're now at the point where the captain ignores reality completely, or is incapacitated from making any decision. These are the last 30 seconds before the point of no return. In plain terms:

_"Captain, you, your airplane and every one on board are about to be dead meat. I choose not to join you. If you don't immediately cease and desist, I will take the airplane away from you."_

### PACE Survival Step: INTERVENTION AND TAKING CONTROL

Co-pilot: _"Captain, I must take over control of the airplane!!"_

If nothing happens in the next second, it's time to drop formalities and address them by first name or nickname.

Co-pilot: _"Jerry, take your hands off the controls, NOW!!"_ (Spoken loudly, slowly, and with firm authority!!)

A third crew member, if present, can use terminology such as:

Co-pilot 2: _"Captain, you must give control of the airplane to Barry immediately!"_

When the co-pilot is already flying the aircraft, the intervention steps of PACE must be used by the co-pilot to announce the intention to implement a strategy not initiated by the Captain. Although the co-pilot has control of the aircraft, the Captain still bears command responsibility for the basic flight plan and mission control. These same four progressive steps for an intervention strategy must be followed by the co-pilot in flight to formalize the change of command and return the aircraft to the previously planned safety margins.

## Conclusion

Replace "Captain" with "Manager" and "Co-Pilot" with "member of a project team" and you'll get where I'm going with this right away.

The archaic hierarchical systems we still use today start from the premise that these "Managers" are omnipotent, omnipresent, and hold absolute power. The board and HR live under the illusion that the manager knows each team member, knows how each one develops, how they behave, and what they want.

The team, on its side, lives under the illusion that the manager knows what needs to be done and what the priorities are. And the manager really does end up believing he can lead the team, deliver the results the board demands, and that everyone trusts him.

Or **worse**: the manager is the coercive type, using fear, intimidation, and raw pulling of rank to give and take orders. _"You work for me, shut up and do what I'm telling you!"_ Nobody usually says it in those words, but that's what happens, especially behind closed doors. Is your manager like this? Get ready: your plane is about to crash.

I'd say 99% of managers today are the captains who will fly the plane straight to the bottom of the Bermuda Triangle. The first people who need to prevent this are the Team itself.

Yes, you, comfortable and complacent member of a product or project team. You're the co-pilot in this story. When the project fails, don't pin it all on the manager: the fault is yours too. If this were a plane, you'd be equally dead, a goner. Do your part.

The four PACE steps work for any team to adopt. This is not about chaos or insubordination. You need to pay attention early to have time to apply all four steps:

- (P) When you notice something strange unfolding, ask for clarification
- (A) If the explanation isn't convincing, try to warn of the risks you already see
- (C) If no action is taken, demand that something be done
- (E) If nothing is done, it's time to warn that you'll take control!

The good news is that in projects and products, especially in our field of software, there's no risk of death, literally speaking. But think of every failed project as a piece of you that dies. A professional who only piles up failures in his career is, by definition, a failure.

One last thing: do you work in HR? Think of all of this as a training course for new hires, a protocol that gives the subordinate an "official" path to act and avoid the premature death of his own career. Today the only path that exists is authority flowing top-down. Most subordinates are afraid of retaliation from their managers. It's long past time to build a bottom-up safety valve that the manager knows exists.
