---
title: 'Off-Topic: Scientific Method vs Cargo Cult'
date: '2008-12-16T13:51:00-02:00'
slug: off-topic-m-todo-cient-fico-vs-cargo-cult
tags:
- off-topic
- principles
- science
- career
draft: false
translationKey: scientific-method-vs-cargo-cult
---

After several years I've noticed that a large number of programmers simply don't understand the Scientific Method. These days we discuss agility a great deal, how to write tests, why TDD matters. In "testing" there's something that should be **obvious** but apparently isn't. There's a step I consider very important: **experimentation**.

![](/files/20081216/42-17463681.jpg)

Just as many use "lack of time" as an excuse not to write tests, the same excuse is used to avoid testing hypotheses through experimentation (most don't even understand they should be experimenting with hypotheses). What I'm talking about here is creating proofs of concept — "pieces" of what you want to develop that will potentially be thrown away. The "throwing away" part is what makes programmers (and managers) bristle. _"But that's wasted time, work thrown away! Unacceptable!"_ This thinking leads people to believe that every line of code written necessarily needs to be in the application.

Again, it's the erroneous thinking that we need to get everything right the first time, the culture that trial-and-error is wrong. Well, I'm here saying that it's wrong to think we'll always get it right the first time. In most cases we'll get it wrong every first time.

## Cargo Cult

After World War II, religious Aboriginal tribes in the South Pacific built replicas of airplanes and military landing strips hoping to summon back the "god-planes" that had brought them so many wonderful supplies during the war. It's exactly what most programmers tend to do: as if in a ritual, they include various programming structures without understanding very well why they're doing it — they just know they "should." These are the programmers who try to force Design Patterns into unnecessary places, put comments in code that is already self-explanatory. More recently they're the types who practically bow before "Dependency Injection" without really understanding why. (source: [Wikipedia](http://en.wikipedia.org/wiki/Cargo_cult_programming))

Being fashionable isn't inherently bad, as many think. What's bad is simply applying things (new or old) without understanding the **reason**. What do schools teach today? The main function of education should be reasoning, but in an educational culture based on rote memorization, people simply accept everything they memorize and don't even know why they memorized it — just that some "authority" said it was true and therefore it "must" be applied.

![](/files/20081216/1217833732_d7fcaebe17.jpg)

Remember the discussions about why certifications are harmful? This is one of the reasons. For those who are already rational, of course it makes no difference. But for a large mass of people who don't reason, the end result is simply cargo culting.

Most people read tutorials, some books, attend some workshops, and already think they're ready to execute the task. In most cases they simply do the good old mental "copy and paste." They dump into the application all the code they learned. I've seen people write something like this:

* * *

```ruby
if ( a == b ) {  
 return true;  
} else {  
 return false;  
}  
```

Nothing wrong with that, but it's incredible how many people are surprised when you tell them this single line does the same thing:

* * *

```ruby
return (a == b);  
```

By itself, this small code is harmless. But notice the subtlety: the programmer doesn't know why they're doing it. They just know they have to do it. Want something worse? I've seen (in various languages) programmers who do the following:

* * *

```php
$dbname="meu_banco";
$chandle = mysql_connect("localhost", 'root', 'root') or die("Falhou");  
$query1 = "select * from tabela";  
$result = mysql_db_query($dbname, $query1) or die ("Falhou");  
while ($row = mysql_fetch_row($result)) {  
 $field = mysql_fetch_field($result, 1);  
 if ( $field == 'foo' ) {  
 echo "encontrei!";  
 break;  
 }  
}
```

This is the classic [What the F*ck!?](http://thedailywtf.com/)

Again, code that "runs." In some languages this would be code that "compiles," with no problem. However, anyone who doesn't understand the **serious problem** with this code needs to go back to first year of university.

![](/files/20081216/will_code_for_food.jpg)

## Blindness

_"Repeat a lie long enough and it soon becomes truth."_

There are many bad books, bad tutorials, bad teachers, and a whole crowd of bad elements spreading bad practices. But the greatest fault lies with those who let themselves be fooled. People who simply accept everything they're told, without the minimum of skepticism, are responsible for their own ignorance.

It's exactly why we still have horoscopes printed in newspapers instead of a science column: because there are far more readers interested in being fooled than in knowing boring things, like reality.

In technology it's the same:

- Windows must be better because it's the market leader (ignoring that Apple, even with its "measly 8%" generates as much revenue as Microsoft, or things like a third of Brazil already uses Firefox)

- Java must be better because it's the market leader, or PHP must be better because major websites use it (I don't even need to discuss this)

- Threads is the best way to write concurrent code (ignoring — out of laziness — the advantages of functional programming)

- The best way to manage data is with relational databases (ignoring — again out of laziness — the whole range of non-relational databases gaining ground)

- Static languages are better because you can compile them (ignoring — here, out of pure stupidity — the enormous productivity advantages of dynamic languages)

- Object-oriented programming is the pinnacle of programming techniques (ignoring that this is just one of dozens of paradigms that exist, like functional programming)

- Rails doesn't scale (seriously? anyone still repeating this proves they're an amateur)

![](/files/20081216/thestupiditburns.jpg)

Everyone has hundreds of preconceived ideas like these. Things they heard from someone or read somewhere (typically from a source of dubious reputation) and now simply repeat stupidly with absolutely no argument to sustain their beliefs. Or rather, these people think the source they got it from (the dubious source) is sufficient basis for continuing to repeat it.

In programming or in any other social field: if you have **any** belief you can't argue for (and sustain the argument), research it better. If your belief doesn't hold up against counter-arguments, **throw it away** — it serves you no purpose. Everyone thinks they're "open-minded." I disagree — most people are quite closed. If you doubt this, rethink everything you believe and argue against yourself. If you do it right you'll notice that most things you believe simply have no foundation.

## Scientific Method

A careful person needs to practice the basics of the scientific method daily. Our day-to-day life is a sequence of decision-making moments, some small, some enormous. Decisions should never be based on preconceived ideas. That's where mistakes happen.

This doesn't mean intuition shouldn't be used. But intuition is a rapid conclusion based on experience. If your daily experiences have been methodically rational for a long time, your intuition tends to be more solid. But if your daily experiences are based on superstitions, sympathies, pseudo-science, cargo culting, and preconceived ideas — sorry to say: your intuition is terrible.

Read [this Wikipedia definition](http://en.wikipedia.org/wiki/Scientific_method). It's extensive, complete, and requires a good deal of reflection. But what interests me most is summarized [here](http://www.sciencebuddies.org/mentoring/project_scientific_method.shtml).

Like any good process, this one is also **iterative** — meaning it foresees going back through steps to refine knowledge.

![](/files/20081216/dogma-jesus.jpg)

The steps are quite simple and can be executed quickly or more slowly and in detail. What matters is: when faced with a question, execute these steps at least mentally. It's the absolute minimum to make an educated decision.

- **Ask the Question** — this phase is important! Ask the wrong question and you'll find the wrong answer. It's been a long time since people have wasted time exploring answers that have no relevance because the question wasn't right. Think of the question as a User Story in an Agile Backlog: check whether it's a priority, check whether it's necessary. Don't waste time trying to answer irrelevant questions.

- **Do Research** — before anything else, research the subject. Don't spend days on it — sometimes a few minutes on Google can be enough. What's important in this step, for me, is the "stop, think, continue" part. Most people are too hasty. This is the stage to pause for a second and gain more knowledge before continuing.

- **Construct a Hypothesis** — normally when you ask a question, you should already have one or more possible answers. What's important in the first step, when you formulated the question, is not to hold on to preconceived ideas. Consider that what most people think is "truth" is in reality nothing more than [hypotheses](http://en.wikipedia.org/wiki/Hypothesis). A hypothesis is nothing more, nothing less than the mere suggestion of an explanation.

[![](/files/20081216/overview_scientific_method2.gif)](http://www.sciencebuddies.org/mentoring/project_scientific_method.shtml)

- **Test with an Experiment** — this is the most important step. Experiments need to be repeatable and have very well-defined criteria. If two people perform the same experiment, for the hypothesis to be non-false, the results must be the same. Note that I said non-false, not true. Truth is something very strong. I normally don't consider myself close to any truth. Sometimes I merely accept that my hypothesis hasn't yet been falsified. This is the crucial part: in programming, create proofs of concept — pieces of code you write only to test your hypothesis but that can simply be thrown away afterwards. Don't even do this in your project's main code: create a separate environment for it. Don't mix things up.

- **Draw Conclusions** — based on everything you did above, you'll prove or disprove your hypothesis. Accept that you can certainly prove your own hypothesis was false. In that case return to step two, reformulate a new hypothesis, and try again! This is being open-minded: when you prove yourself wrong and immediately set out to find a new answer.

- **Communicate Your Results** — the type of application I'm talking about here is quite informal, just the minimum so that you at least have "some" (probably not complete) grounding in what you're doing. But if it's something more complex, where you truly invested more time and were more detailed, it may be a topic that interests others. Share your results with your colleagues at minimum. If you invested that much time, the answer is probably important — and in that case it's also important that other people have the chance to try to disprove your result. It's not so important that people reach the same conclusions (quantity of people means nothing). It's far more important if someone manages to disprove your conclusion. In that case, discard the hypothesis. Start again.

## People

Most people can be described as follows:

- **Have preconceived ideas** — heard from other people (who, they believe, have credibility). Just because a person has some credential, is a celebrity, speaks well, dresses well, or for whatever reason you think they "must" be listened to, doesn't mean they know the whole truth. On the contrary, that other person may have many preconceived ideas. Yes, listen to what they have to say, but store everything in a mental box labeled "to be verified" and move forward.

- **Don't like being disproven** — nobody likes admitting they're wrong. First it kills the ego, second it destroys self-esteem. So an ignorant person will hold onto their particular lie until the last consequences. These are people with weak foundations. Build your foundation on several half-truths, and when one falls, everything falls. This is the greatest risk.

- **Don't like wasting time** — and here "wasting time" is absolutely relative. Most people practice false economy. Testing and experimenting, or better said, "not doing anything immediately," is considered a waste of time. But I would call it "saving future time." Being a little more careful now so I don't have to rush tomorrow. It's a balance: it makes no sense to spend 15 days preparing for a project that only has 20 days. But do the minimum. Stop for a second, think, if in doubt experiment, then proceed.

![](/files/20081216/funny-dog-pictures-praying-dogma.jpg)

- **Don't like new things** — there's another very wrong concept of "cost." Many think that because they invested time studying a particular subject, that invested time/money "cannot be lost" and therefore they need to persist with the same subject. This is what I've written about before as [The Sunk Cost Fallacy](http://www.akitaonrails.com/2007/08/19/a-falcia-do-custo-perdido). If you already have a loss, the biggest stupidity is persisting with the same loss. It's far more intelligent to write off that cost as lost and simply change direction and move forward.

- **Only do what they're told to do** — if nobody orders testing, they don't test. If nobody orders a proof of concept, they don't create one. If nobody tells them to worry about security, the code ships full of holes. If nobody tells them to automate tests, nobody automates. The quantity of Lemmings we have on projects is impressive. First because everything that should be an obligation isn't done; second because if the boss tells them to shoot their own foot, they shoot! Again, lack of reasoning.

- **Do the unnecessary** — even though it seems paradoxical, complementing the behavior above (not doing what's necessary), because of fixed preconceived ideas, people actually end up wasting time doing totally unnecessary things — because someone they consider "credible" said they should be done. It's a behavior I haven't fully understood yet, but I see it all the time, and it negates everything I said above: it's the case when someone decides to choose a completely idiotic technology for some inexplicable reason. They waste a good amount of time not doing what's actually a priority in the project. No proof of concept is made to test the hypothesis, and they start coding, "assuming" it will work. In the end, the project is late and full of code that will simply have to be thrown away because it's genuinely useless.

I think all of this is actually a consequence of people's lack of practice in reasoning. It's irrational behavior, overly complicated, full of basic mistakes — but for some reason nobody thinks they're wrong.

I remember a documentary by the great Richard Dawkins where he talks about a scientist who spent years studying a theory (I don't remember which). Then another young scientist proved him wrong. He looked at the young scientist and said something like "thank you very much." That's rational behavior. It's very difficult to prove something is true; it's simpler to prove it's **false**. If someone proves you wrong, thank them — it's effectively preventing you from wasting future time, which is enormously important!

And whenever you start a new project, don't assume you know what needs to be done, or even that you "need" to know what to do. Assume you don't know! Create hypotheses, discuss, experiment, gain real confidence, and only then do what needs to be done. There's nothing wrong with that. The problem is assuming you know what you're going to do, and then after wasting everyone's time, it finally becomes clear you were wrong the whole time!

Don't waste other people's time!

![](/files/20081216/2633591802_8498c58817_o.jpg)

References:

- [Scientific method](http://en.wikipedia.org/wiki/Scientific_method)
- [Steps of the Scientific Method](http://www.sciencebuddies.org/mentoring/project_scientific_method.shtml)
- [Deductive Reasoning](http://en.wikipedia.org/wiki/Deductive_reasoning)
- [Cargo Cult Programming](http://en.wikipedia.org/wiki/Cargo_cult_programming)
- [Cargo Cult Science](http://en.wikipedia.org/wiki/Cargo_cult_science)
- [Fallacy](http://en.wikipedia.org/wiki/Fallacy)
- [Due Diligence](http://en.wikipedia.org/wiki/Due_diligence)
- [Prejudice](http://en.wikipedia.org/wiki/Prejudice)
- [Hypothesis](http://en.wikipedia.org/wiki/Hypothesis)

I repeat many times that I don't know what the truth is. I answer "I don't know" every time someone asks me a question expecting an absolute answer. _"Will Rails survive?"_ Forget that type of question: predicting the future is hard. If someone gives you a prediction about the future, ignore it! They most likely have no idea what they're talking about.

Part of this type of question is the behavior I mentioned above — that people think they need to always get it right and don't like being proven wrong. In the worst case, the path you took to prove yourself wrong gave you more knowledge and experience. That's more important than finding a truth.

I've talked about Reason in some other posts like:

- [Be Arrogant](http://akitaonrails.com/2007/4/14/off-topic-seja-arrogante)
- [Enemies of Reason](http://akitaonrails.com/2007/8/23/off-topic-inimigos-da-razo)
- [100% pure Object-Oriented: The Fallacy](http://www.akitaonrails.com/2007/9/4/100-pure-object-oriented-the-fallacy)

## Conclusions

My objective in this post is to try to reinforce the importance of experimentation. I don't know the truth — anyone can post a comment here with dozens of counter-arguments. That person will be losing focus (and certainly their "arguments" will be nothing but citations of preconceived ideas). It's irrelevant to try to pick at details in the text and demonstrate errors. What's important here is that the professional needs to understand that age, years in the field, certifications/credentials are completely irrelevant when solving problems. In the end we are all amateurs and, as such, we need to go back to zero and review our hypotheses.

A practical example: when I spoke with [John Straw](http://akitaonrails.com/2008/11/21/rails-podcast-brasil-especial-qcon-john-straw-yellowpages-com-e-matt-aimonetti-merb) (YellowPages.com) in San Francisco, one thing they did that not every team does was extensive due diligence. They spent 22 months building the original YellowPages.com project in Java. They decided to stop for 4 months, create prototypes, proofs of concept, test hypotheses (Which framework to use — Rails, Django, or Seam? Which architecture — SOA, EJBs, etc.? How long does it take for the team to get comfortable with the new technology?) and only after they gained confidence in what they were doing did they begin implementing for real. Then it was only 4 more months to finish. Understand? The first 4 months weren't wasted time: they were "insurance," a way of preventing those 4 months from becoming 20.

As I said last year: "Be Arrogant, but deserve to be arrogant!" Be arrogant toward yourself to the point of questioning yourself and truly winning! You can fool others, but fooling yourself has little advantage. There is no better inquisitor for you than yourself. If you're wrong, excellent! One fewer wrong path — look for another and start again.

Repeating: it wasn't with preconceived ideas that we got to the Moon.

![](/files/20081216/redneck_moon_landing_2.jpg)
