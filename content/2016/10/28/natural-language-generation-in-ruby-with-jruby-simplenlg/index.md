---
title: Natural Language Generation in Ruby (with JRuby + SimpleNLG)
date: '2016-10-28T17:53:00-02:00'
slug: natural-language-generation-in-ruby-with-jruby-simplenlg
tags:
- jruby
draft: false
---

I am building a project which needs to generate proper English sentences. The first version I built used the super naive way of just creating a string template and doing simple sub-string replacements or concatenations.

But you can imagine that it quickly becomes cumbersome when you have to deal with pluralization, inflection, and it starts to become something like this:

```ruby
"There #{@users.size == 1 ? 'is' : 'are'} #{@users.size} user#{'s' unless @users.size == 1}."
```

Or use Rails I18n support like this:

```ruby
I18n.backend.store_translations :en, :user_msg => {
  :one => 'There is 1 user',
  :other => 'There are %{count} users'
}
I18n.translate :user_msg, :count => 2
# => 'There are 2 users'
```

For simple transactional phrases (such as flash messages), this is more than enough.

But if you want to generate an entire article in plain English from data structures, then the logic becomes very convoluted very fast.

I looked around and found a few Ruby projects that could help, for example:

* ["nameable"](https://github.com/chorn/nameable) which can do useful stuff like this:

```ruby
Nameable::Latin.new('Chris').gender
#=> :male
Nameable::Latin.new('Janine').female?
#=> true
```

* ["calyx"](https://github.com/maetl/calyx) which can be used to generate simple phrases like this:

```ruby
class GreenBottle < Calyx::Grammar
  mapping :pluralize, /(.+)/ => '\\1s'
  start 'One green {bottle}.', 'Two green {bottle.pluralize}.'
  bottle 'bottle'
end

# => "One green bottle."
# => "Two green bottles."
```

Nice and dandy, but still useless for the more complex needs I have in mind.

So I decided to dig a bit deeper, into the dark world of NLG, or **Natural Language Generation** (not to be confused with NLP, which stands for Natural Language Processing, which is the opposite of what I want. NLP gets plain English text and returns a parsed data structure).

For **NLP** (parsing, tokenization, etc) I'd highly recommend ["Stanford CoreNLP"](http://stanfordnlp.github.io/CoreNLP/). It seems to be one of the most robust and comprehensive out there (come on, it's from Stanford). Again a Java project, and a big download (more than 300MB!). Those linguistics projects are super heavy because they have to download entire dictionaries and lexicon databases.

But focusing on my problem at hand, **NLG**, there are [several options](https://aclweb.org/aclwiki/index.php?title=Downloadable_NLG_systems) out there. In all honesty, I did not do a very extensive research so if you are aware of which is the most robust and also well maintained and with an easy to use interface, let me know in the comments section below.

My choice was [SimpleNLG](https://github.com/simplenlg/simplenlg). From it's GitHub page we can see that it seems to be quite well maintained to this day, it's a simple Java library and it is one of the "simpler" alternatives. [KPML](http://www.fb10.uni-bremen.de/anglistik/langpro/kpml/README.html) is on the opposite spectrum: it seems to be one of the oldest (since the 80's!) and most robust one. But seriously, it feels like you need a ph.D to even get started.

Reading the SimpleNLG Java source code was boring but easy enough. Give yourself one full day of study to get used to the code and you're in business.

The main problem is that it's written in Java and I am not intending to write anything in Java (or any derivative) for now. For a short while I considered the endeavour or rewriting the damn thing in something more portable such as Rust, which I could load anywhere through FFI.

But even though SimpleNLG has "Simple" in it's name it has a few hairy dependencies to load the lexicon database. And the database itself is an HSQLDB dump, which is a Java-written database. And then, there would be the issue of maintaining a fork.

I quickly gave up on that idea and instead I worked around this by wrapping the library under a simple [Rails-API](https://github.com/rails-api/rails-api) endpoint. I had a few issues because I had Git LFS tracking jar files in my system and Heroku doesn't support it and I ended up with a corrupted deployment (beware of those quircks, by the way!)

Finally, I was able to deploy a working JRuby + Rails-API project embedding SimpleNLG at Heroku. You can deploy your own copy by cloning my [nlg_service](https://github.com/Codeminer42/nlg_service). It works fine with the latest JRuby 9.1.5.0. You should pay for at least a Hobby tier over Heroku. Java takes a ridiculous amount of time to start up and more time to warm up. Heroku's free tier shuts down your dyno if it sits idle and a subsequent web request will definitelly time out or take an absurd amount of time to return.

Once deployed it starts up Rails, then loads [this initializer](https://github.com/Codeminer42/nlg_service/blob/master/config/initializers/simple_nlg.rb):

```ruby
require 'java'
Java::JavaLang::System.set_property "file.encoding","UTF-8"

SIMPLE_NLG_DEFAULT_LEXICON_PATH = Rails.root.join("lib/SimpleNLG/resources/default-lexicon.xml").to_s.freeze
SIMPLE_NLG_PATH                 = Rails.root.join("lib/SimpleNLG").to_s.freeze

Dir["#{SIMPLE_NLG_PATH}/*.jar"].each { |jar| require jar }
```

And then I map the classes [like this](https://github.com/Codeminer42/nlg_service/blob/master/app/models/simple_nlg.rb):

```ruby
module SimpleNLG
  %w(
    simplenlg.aggregation
    simplenlg.features
    simplenlg.format.english
    simplenlg.framework
    simplenlg.lexicon
    simplenlg.morphology.english
    simplenlg.orthography.english
    simplenlg.phrasespec
    simplenlg.realiser.english
    simplenlg.syntax.english
    simplenlg.xmlrealiser
    simplenlg.xmlrealiser.wrapper
  ).each { |package| include_package package }
end
```

Finally, I have a simple endpoint mapped to a [controller](https://github.com/Codeminer42/nlg_service/blob/master/app/controllers/api/realisers_controller.rb) action:

```ruby
class Api::RealisersController < ApplicationController
  def create
    reader = java::io::StringReader.new(params[:xml])
    begin
      records = SimpleNLG::XMLRealiser.getRecording(reader)
      output = records.getRecord.map do |record|
        SimpleNLG::XMLRealiser.realise(record&.getDocument)
      end
      @realisation = output.join("\n").strip
      render plain: @realisation
    ensure
      reader.close
    end
  end
end
```

The process of generating the final English text is called **"realisation"**. SimpleNLG has a comprehensive Java API but it also exposes it as a simpler XML format. The full [XML Realiser Schema](https://github.com/simplenlg/simplenlg/blob/master/src/main/resources/xml/RealizerSchema.xsd) is available as an XSD.

If I want to write this sentence:

> "There are some finished and delivered stories that may not have been tested."

This is the XML that I need to assemble:

```xml
<?xml version="1.0"?>
<NLGSpec xmlns="http://simplenlg.googlecode.com/svn/trunk/res/xml" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <Recording>
    <Record>
      <Document cat="PARAGRAPH">
        <child xsi:type="SPhraseSpec">
          <subj xsi:type="NPPhraseSpec">
            <head cat="ADVERB">
              <base>there</base>
            </head>
          </subj>
          <vp xsi:type="VPPhraseSpec" PERSON="THIRD">
            <head cat="VERB">
              <base>be</base>
            </head>
            <compl xsi:type="NPPhraseSpec" NUMBER="PLURAL">
              <head cat="NOUN">
                <base>story</base>
              </head>
              <spec xsi:type="WordElement" cat="DETERMINER">
                <base>a</base>
              </spec>
              <preMod xsi:type="CoordinatedPhraseElement" conj="and">
                <coord xsi:type="VPPhraseSpec" TENSE="PAST">
                  <head cat="VERB">
                    <base>finish</base>
                  </head>
                </coord>
                <coord xsi:type="VPPhraseSpec" TENSE="PAST">
                  <head cat="VERB">
                    <base>deliver</base>
                  </head>
                </coord>
              </preMod>
              <compl xsi:type="SPhraseSpec" MODAL="may" PASSIVE="true" TENSE="PAST">
                <vp xsi:type="VPPhraseSpec" TENSE="PAST" NEGATED="true">
                  <head cat="VERB">
                    <base>test</base>
                  </head>
                </vp>
              </compl>
            </compl>
          </vp>
        </child>
      </Document>
    </Record>
  </Recording>
</NLGSpec>
```

Ok, this is preposterous, I know.

Which is why I decided to go ahead and use one of Ruby's most recognized strengths: creating **DSLs** or **Domain Specific Languages**.

The result of my initial endeavor to simplify this process is the [nlg_xml_realiser_builder](https://github.com/Codeminer42/nlg_xml_realiser_builder) ruby gem. Simply add the following to your `Gemfile`:

```
gem 'nlg_xml_realiser_builder'
```

And the humongous XML above becomes something more manageable like this:

```ruby
dsl = NlgXmlRealiserBuilder::DSL.new
dsl.builder(true) do
  sp :child do
    subj :np, 'there', cat: 'ADVERB'
    verb 'be', PERSON: 'THIRD' do
      compl :np, ['a', 'story'], NUMBER: 'PLURAL'  do
        preMod :cp, conj: 'and' do
          coord :vp, 'finish', TENSE: 'PAST'
          coord :vp, 'deliver', TENSE: 'PAST'
        end
        compl :sp, MODAL: 'may', PASSIVE: true, TENSE: 'PAST' do
          verb 'test', TENSE: 'PAST', NEGATED: true
        end
      end
    end
  end
end.to_xml
```

Understanding the intricasies of an `NPPhraseSpec` vs a `VPPhraseSpec` or the difference between a `WordElement` or `StringElement` are beyond this blog post. But most of the original XSD has been mapped through [this constants file](https://github.com/Codeminer42/nlg_xml_realiser_builder/blob/master/lib/nlg_xml_realiser_builder/consts.rb).

I have a [few acceptance specs](https://github.com/Codeminer42/nlg_xml_realiser_builder/blob/master/spec/nlg_xml_realiser_builder_spec.rb) that are generating XMLs like the above, posting to my live online NLG Web Service and fetching the resulting English sentences. I will change this process in the future but you can test it our yourself.

The advantages start here. Now let's check out the previous example more closely. Again, it renders this phrase:

> "There are some finished and delivered stories that may not have been tested."

Now, it's in plural form because I am talking about 'stories', but what if I want a singular version?

Below is the new version where I just wrap it around a method and make the attribute 'NUMBER' accept both 'PLURAL' or 'SINGULAR':

```ruby
def example(plural = 'PLURAL')
  dsl = NlgXmlRealiserBuilder::DSL.new
  dsl.builder(true) do
    sp :child do
      subj :np, 'there', cat: 'ADVERB'
      verb 'be', PERSON: 'THIRD' do
        compl :np, ['a', 'story'], NUMBER: plural  do
          preMod :cp, conj: 'and' do
            coord :vp, 'finish', TENSE: 'PAST'
            coord :vp, 'deliver', TENSE: 'PAST'
          end
          compl :sp, MODAL: 'may', PASSIVE: true, TENSE: 'PAST' do
            verb 'test', TENSE: 'PAST', NEGATED: true
          end
        end
      end
    end
  end.to_xml
end
```

And I can run the singular version like this:

```
puts example('SINGULAR')
```

This is the resulting phrase:

> "There is a finished and delivered story that may not have been tested."

Check out how it changed the verb from "are" to "is" and the noun determiner from "some" to "a" on its own! And of course, this is a contrived example. Now imagine an entire customizable article, full of paragraphs and sentences that I can customize depending on several variable I have.

While I was studying and writing this DSL I got a good enough grasp of the SimpleNLG structure, but if you have more examples for more complex phrase structures, please let me know in the comments section down below.

Most of the specs were copied from the XML Realiser tests from the original Java project to make sure I am covering most cases.

It will be interesting to see if this DSL makes it easier for more people to experiment with NLG. As usual, send your Pull Requests, ideas and suggestions on my GitHub public repositories:

* [nlg_service](https://github.com/Codeminer42/nlg_service)
* [nlg_xml_realiser_builder](https://github.com/Codeminer42/nlg_xml_realiser_builder)

And if you're interested in the subject of NLP and NLG I found [this list](https://github.com/diasks2/ruby-nlp) of Ruby related open source projects as well.
