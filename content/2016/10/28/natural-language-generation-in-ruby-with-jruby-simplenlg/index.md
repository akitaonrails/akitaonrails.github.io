---
title: "Geração de Linguagem Natural em Ruby (com JRuby + SimpleNLG)"
date: '2016-10-28T17:53:00-02:00'
slug: geracao-de-linguagem-natural-em-ruby-com-jruby-simplenlg
translationKey: nlg-jruby-simplenlg
aliases:
- /2016/10/28/natural-language-generation-in-ruby-with-jruby-simplenlg/
tags:
- jruby
- traduzido
draft: false
---

Estou tocando um projeto que precisa gerar frases em inglês decentes. A primeira versão que fiz usava o jeito mais ingênuo possível: criar um template de string e ir fazendo substituições e concatenações simples.

Mas dá pra imaginar que isso vira uma bagunça rapidamente quando você precisa lidar com pluralização, flexão verbal, e o código começa a ficar parecido com isso:

```ruby
"There #{@users.size == 1 ? 'is' : 'are'} #{@users.size} user#{'s' unless @users.size == 1}."
```

Ou usar o suporte de I18n do Rails desse jeito:

```ruby
I18n.backend.store_translations :en, :user_msg => {
  :one => 'There is 1 user',
  :other => 'There are %{count} users'
}
I18n.translate :user_msg, :count => 2
# => 'There are 2 users'
```

Para frases transacionais simples (tipo flash messages), isso resolve de sobra.

Mas se você quer gerar um artigo inteiro em inglês a partir de estruturas de dados, a lógica fica convoluta muito rápido.

Dei uma olhada em alguns projetos Ruby que poderiam ajudar, por exemplo:

* ["nameable"](https://github.com/chorn/nameable) que faz coisas úteis assim:

```ruby
Nameable::Latin.new('Chris').gender
#=> :male
Nameable::Latin.new('Janine').female?
#=> true
```

* ["calyx"](https://github.com/maetl/calyx) que dá pra usar para gerar frases simples desse jeito:

```ruby
class GreenBottle < Calyx::Grammar
  mapping :pluralize, /(.+)/ => '\\1s'
  start 'One green {bottle}.', 'Two green {bottle.pluralize}.'
  bottle 'bottle'
end

# => "One green bottle."
# => "Two green bottles."
```

Bonitinho, mas ainda inútil para as necessidades mais complexas que tenho em mente.

Então resolvi cavar mais fundo, no mundo obscuro do NLG, ou **Natural Language Generation** (Geração de Linguagem Natural). Cuidado para não confundir com NLP, que é Natural Language Processing, justamente o oposto do que eu quero. NLP recebe um texto em inglês e devolve uma estrutura de dados parseada.

Para **NLP** (parsing, tokenização, etc), recomendo demais o ["Stanford CoreNLP"](http://stanfordnlp.github.io/CoreNLP/). Parece ser um dos mais robustos e completos por aí (vai, é de Stanford). Também é um projeto Java, e um download enorme (mais de 300MB!). Esses projetos de linguística são pesados pra caramba porque precisam baixar dicionários inteiros e bases de léxico.

Mas focando no meu problema atual, **NLG**, existem [várias opções](https://aclweb.org/aclwiki/index.php?title=Downloadable_NLG_systems) disponíveis. Sendo bem honesto, não fiz uma pesquisa muito extensa, então se você conhece qual é o mais robusto, bem mantido e com uma interface fácil de usar, deixa nos comentários aí embaixo.

Minha escolha foi o [SimpleNLG](https://github.com/simplenlg/simplenlg). Pela página dele no GitHub dá pra ver que continua sendo bem mantido até hoje, é uma biblioteca Java simples e é uma das alternativas mais "simples". Já o [KPML](http://www.fb10.uni-bremen.de/anglistik/langpro/kpml/README.html) está no extremo oposto: parece ser um dos mais antigos (desde os anos 80!) e robustos. Mas falando sério, você precisa praticamente de um Ph.D. só pra começar.

Ler o código-fonte Java do SimpleNLG foi chato, mas tranquilo o suficiente. Reserva um dia inteiro de estudo para se acostumar com o código e você está pronto.

O problema principal é que ele é escrito em Java, e eu não pretendo escrever nada em Java (ou derivados) por enquanto. Por um instante cheguei a considerar a empreitada de reescrever o troço todo em algo mais portátil, tipo Rust, que eu poderia carregar de qualquer lugar via FFI.

Mas mesmo o SimpleNLG tendo "Simple" no nome, ele tem algumas dependências cabeludas para carregar a base de léxico. E a base em si é um dump de HSQLDB, que é um banco escrito em Java. E ainda haveria a questão de manter um fork.

Desisti rápido dessa ideia e contornei o problema embrulhando a biblioteca dentro de um endpoint [Rails-API](https://github.com/rails-api/rails-api) simples. Tive uns problemas porque eu tinha o Git LFS rastreando os arquivos jar no meu sistema e o Heroku não suporta isso, e acabei com um deploy corrompido (cuidado com essas pegadinhas, aliás!).

No fim consegui colocar no ar um projeto JRuby + Rails-API funcionando com SimpleNLG embutido no Heroku. Você pode subir sua própria cópia clonando meu [nlg_service](https://github.com/Codeminer42/nlg_service). Funciona bem com o JRuby 9.1.5.0 mais recente. Você precisa pagar pelo menos um plano Hobby no Heroku. Java leva um tempo ridículo para subir e mais tempo ainda para esquentar. O free tier do Heroku desliga seu dyno se ele ficar parado, e a próxima requisição web vai dar timeout ou levar uma eternidade para responder.

Uma vez no ar, ele sobe o Rails e carrega [este initializer](https://github.com/Codeminer42/nlg_service/blob/master/config/initializers/simple_nlg.rb):

```ruby
require 'java'
Java::JavaLang::System.set_property "file.encoding","UTF-8"

SIMPLE_NLG_DEFAULT_LEXICON_PATH = Rails.root.join("lib/SimpleNLG/resources/default-lexicon.xml").to_s.freeze
SIMPLE_NLG_PATH                 = Rails.root.join("lib/SimpleNLG").to_s.freeze

Dir["#{SIMPLE_NLG_PATH}/*.jar"].each { |jar| require jar }
```

E depois mapeio as classes [assim](https://github.com/Codeminer42/nlg_service/blob/master/app/models/simple_nlg.rb):

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

Por fim, tenho um endpoint simples mapeado para uma action de [controller](https://github.com/Codeminer42/nlg_service/blob/master/app/controllers/api/realisers_controller.rb):

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

O processo de gerar o texto final em inglês se chama **"realisation"** (realização). O SimpleNLG tem uma API Java bem completa, mas também expõe tudo num formato XML mais simples. O [XML Realiser Schema](https://github.com/simplenlg/simplenlg/blob/master/src/main/resources/xml/RealizerSchema.xsd) completo está disponível como XSD.

Se eu quiser escrever esta frase:

> "There are some finished and delivered stories that may not have been tested."

Este é o XML que preciso montar:

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

Ok, eu sei, isso é absurdo.

Por isso resolvi seguir adiante e usar uma das forças mais reconhecidas do Ruby: criar **DSLs**, ou Domain Specific Languages.

O resultado da minha tentativa inicial de simplificar esse processo é a gem [nlg_xml_realiser_builder](https://github.com/Codeminer42/nlg_xml_realiser_builder). Basta adicionar isso ao seu `Gemfile`:

```
gem 'nlg_xml_realiser_builder'
```

E o XML monstruoso ali em cima vira algo bem mais gerenciável, assim:

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

Entender as nuances de um `NPPhraseSpec` versus um `VPPhraseSpec`, ou a diferença entre um `WordElement` e um `StringElement`, está fora do escopo deste post. Mas a maior parte do XSD original foi mapeada [neste arquivo de constantes](https://github.com/Codeminer42/nlg_xml_realiser_builder/blob/master/lib/nlg_xml_realiser_builder/consts.rb).

Tenho [algumas specs de aceitação](https://github.com/Codeminer42/nlg_xml_realiser_builder/blob/master/spec/nlg_xml_realiser_builder_spec.rb) que geram XMLs como o de cima, postam no meu NLG Web Service que está no ar e pegam de volta as frases em inglês resultantes. Vou mudar esse processo no futuro, mas você já pode testar por conta própria.

As vantagens começam aqui. Vamos olhar o exemplo anterior mais de perto. De novo, ele renderiza esta frase:

> "There are some finished and delivered stories that may not have been tested."

Repare que está no plural porque estou falando de 'stories', mas e se eu quiser uma versão no singular?

Abaixo está a nova versão, onde eu envolvo o código num método e faço o atributo 'NUMBER' aceitar tanto 'PLURAL' quanto 'SINGULAR':

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

E posso rodar a versão singular assim:

```
puts example('SINGULAR')
```

Esta é a frase resultante:

> "There is a finished and delivered story that may not have been tested."

Olha como ele mudou o verbo de "are" para "is" e o determinante do substantivo de "some" para "a" sozinho! E claro, este é um exemplo bobo. Agora imagine um artigo inteiro customizável, cheio de parágrafos e frases que eu posso variar dependendo de várias variáveis que tenho.

Enquanto eu estudava e escrevia essa DSL, peguei uma compreensão razoável da estrutura do SimpleNLG, mas se você tem mais exemplos para estruturas de frase mais complexas, deixa nos comentários aí embaixo.

A maior parte das specs foi copiada dos testes do XML Realiser do projeto Java original para garantir que estou cobrindo a maioria dos casos.

Vai ser interessante ver se essa DSL facilita a vida de mais gente que queira experimentar com NLG. Como sempre, mandem seus Pull Requests, ideias e sugestões nos meus repositórios públicos do GitHub:

* [nlg_service](https://github.com/Codeminer42/nlg_service)
* [nlg_xml_realiser_builder](https://github.com/Codeminer42/nlg_xml_realiser_builder)

E se você se interessa pelo assunto de NLP e NLG, encontrei [esta lista](https://github.com/diasks2/ruby-nlp) de projetos open source relacionados em Ruby também.
