---
title: A Controvérsia Test::Unit vs RSpec/Cucumber
date: '2011-04-17T15:26:00-03:00'
slug: a-controversia-test-unit-vs-rspec-cucumber
tags:
- fud
- rspec
- ruby
draft: false
---

Alguns dias atrás, o bom e velho [@dhh](http://www.twitter.com/dhh) começou uma controvérsia na comunidade. Eu diria até que foi uma discussão saudável. Leia a cobertura do acontecido na [RubyInside](http://www.rubyinside.com/dhh-offended-by-rspec-debate-4610.html) mas em resumo ele fez a seguinte sequência de tweets:

> “Pergunta: que framework de teste vocês usam na 37signals? Resposta: Test::Unit com uso ocasional do mocha. (Isso é tudo que você precisa para bons testes.)”

> “Eu respeito os caras por trás disso e sou totalmente a favor de experimentação, mas a proliferação de rSpec e Cucumber me deixa triste.”

> “RSpec me ofende esteticamente com nenhum benefício discernível pela sua complexidade adicionada sobre Test::Unit.”

> “Cucumber não faz sentido a menos que você tenha clientes lendo os testes. Por que você construiria um parser específico de testes para inglês?”

> “A coisa importante, é claro, é que consigamos fazer as pessoas testarem, então ferramentas não deveriam importar muito. Mas a complexidade extra ainda me chateia.”

Sendo sincero, eu também compartilho da mesma opinião do @dhh. E não, não é [cargo cult](http://akitaonrails.com/2008/12/16/off-topic-m-todo-cient-fico-vs-cargo-cult), antes que algum engraçadinho faça o comentário: lembro de 1 ou 2 anos atrás onde eu e o Carlos Brando estávamos conversando justamente como voltar pra Test::Unit era até um alívio. Também lembro de discutir o assunto do Cucumber com o Daniel V. Lopes, que pelo menos na época preferia Steak justamente porque nenhum cliente iria ler os testes escritos em inglês e portanto isso era redundante.

Só para adiantar a conclusão: se alguém estava levando a discussão para o nível de qual sintaxe é “melhor”, ou qual é mais “elegante”, ou qual é mais “suscinta”, você está indo na direção errada e vai tirar conclusões sem nenhum fundamento também. Então vamos com calma que, pra variar, a leitura será longa.

## Introdução

É importante que as pessoas primeiro coloquem a imagem dos códigos na cabeça antes de continuarmos a discussão. Este é um exemplo pequeno de um teste unitário escrito com RSpec:

* * *

```ruby

describe Cart, “.sub_total” do  
 before(:each) do  
 @cart = Factory(:cart_with_two_5_dollar_items)  
 end

it “should calculate subtotal correctly” do @cart.sub_total.should == 10.00 end
end  
```

Este é um pequeno trecho de um teste do arquivo <tt>cart_spec.rb</tt> do projeto [ror_ecommerce](https://github.com/drhenner/ror_ecommerce). O que uma DSL como RSpec fornece é uma descrição suscinta em “quase-inglês” que poderíamos ler assim:

* * *

```ruby

describe Cart, “.sub_total” do # descrevendo o sub total de um Cart  
 before(:each) do # antes de cada teste execute:  
 @cart = Factory(:cart_with_two_5_dollar_items) # faça @cart ser o resultado da Fábrica com 2 ítens de $5  
 end

it “should calculate subtotal correctly” do # o cart deve calcular o subtotal corretamente @cart.sub_total.should == 10.00 # sub total do @cart deve ser igual a 10.00 end
end  
```

Agora vejamos um trecho de cucumber:

* * *

Feature: adding a comment

As a Ruby developer I would like to comment on a gem So that I can help the community track which gems work with Ruby 1.9 Scenario: adding a comment Given an initialised database And a gem called “rubynuts” When I visit the page for “rubynuts” Then I see the comment form When I add a comment And I press “submit comment” Then I see my comment on the page
* * *

Este trecho foi retirado do projeto [isitruby19](http://isitruby19.com/). Acho que não preciso traduzir, com certeza todos vocês consegue ler o que está escrito, certo??

Mas este arquivo de Cucumber, sozinho, não faz tudo. Ele precisa necessariamente de outro código que faz par com ele por baixo dos panos, este sim, escrito em Ruby:

* * *

```ruby

1. general_steps.rb  
Given an initialised database$ do  
 Platform.load_defaults  
end

1. code_steps.rb  
Given a gem called “(.*)”$ do | name |  
 code = Code.find_by_name name  
 code.destroy unless code.nil?
 code = a_saved Code, :name => name  
end

When I visit the page for “(.*)”$ do | name |
 visit “/#{name}”  
end

1. comment_steps.rb  
Then I see the comment form$ do  
 response.should have_tag(‘div#new-comment-form’)  
end

When I add a comment$ do  
 fill_in “Name”, :with => ‘Henry the Tester’  
 fill_in “Email”, :with => ‘<henry@testing.com>’  
 choose :comment_works_for_me_true  
 fill_in “Version”, :with => ‘1.0’  
 select ‘Mac OSX’, :from => ‘Platform’  
 fill_in :comment_body, :with => ‘Here is my test comment’ # have to request via ID rather than label because of the span around the optional, making it hard to find  
end

1. webrat_steps.rb  
When I press “(.*)”$ do |button|  
 click_button(button)  
end

1. comment_steps.rb  
Then I see my comment on the page$ do  
 response.should include_text(‘Here is my test comment’)  
end  
```

Note que sobre cada trecho eu tirei em que arquivo ele estava. Sem explicar muito, se vocês lerem a especificação em inglês e depois ler com calma o código Ruby abaixo, verá que cada frase tem um equivalente em Ruby. Esse código equivalente é chamado de “Step Definition” no Cucumber, e pode estar em qualquer arquivo no <tt>load path</tt>.

O objetivo do Cucumber é que essas “User Stories” sejam escrita em inglês em conjunto com o cliente final. E a partir daí elas se tornam “especificações executáveis” em vez de um mero papel que não tem como validar automaticamente. Mas depois precisamos reescrever tudo em Ruby. Por isso muitos dizem que, se você não pretende usar isso com um cliente de verdade, parece um trabalho duplicado.

Finalmente vejamos um teste no antigo Test::Unit (em particular com suporte do Rails):

* * *

```ruby

class Cart < ActiveModel::TestCase  
 def setup  
 @cart = Factory(:cart_with_two_5_dollar_items)  
 end

test “should calculate subtotal correctly” do assert_equal 10.00, @cart.sub_total end
```

Este eu fiz de propósito. Se você comparar somente no escopo deste micro-teste, tanto a versão em Test::Unit quanto em RSpec não tem praticamente diferença nenhuma. Mas claro que não é só isso e existem dezenas de outras funcionalidades que o RSpec tem sobre o Test::Unit.

Para iniciar em cada uma das ferramentas leia:

- [Livro RSpec Book](http://pragprog.com/titles/achbd/the-rspec-book "que cobre Cucumber")
- [Documentação Test::Unit para Rails](http://guides.rubyonrails.org/testing.html)

## Refletindo sobre a História

A comunidade Ruby, Agile e outras ao redor se concentraram bastante nos assuntos Test Driven Development e Behavior Driven Development. Mas não se esqueçam que testar software é um assunto [muito mais amplo](http://en.wikipedia.org/wiki/Software_testing) do que isso. Muitos outros vieram antes de nós explorando, pesquisando, documentando e refinando esse conhecimento. Resumidamente a história passou já por esses estágios:

- Até 1956 – orientado a debugging
- 1957-1978 – orientado a demonstração
- 1979-1982 – orientado a destrução
- 1983-1987 – orientado a avaliação
- 1988-2000 – orientado a prevenção

O que conhecemos hoje como níveis de testes, que vai de unitário, integrado e de sistema, além de definições, terminologias, classificações, estão todas descritas no Software Engineering Body of Knowledge (SWEBOK) e você pode ler o capítulo específico sobre [Software Testing](http://www.computer.org/portal/web/swebok/html/contentsch5#ch5) na versão gratuita do livro disponível online.

Os exemplos de código que dei acima assumem muita coisa. Assumem que você entende todos os conceitos e terminologias de testes, que entende porque eles são assim. Assumem que você entende qual a diferença entre “Use Cases”, “User Stories” e “Narrative”. Assume que você entende como e porque TDD existe e também como se evoluiu para BDD. Se você não entende, leia os links acima nesta seção e também este artigo [A Story about User Stories and Test-Driven Development](http://www.rbcs-us.com/images/documents/User-Stories-and-Test-Driven-Development.pdf).

O Test::Unit que conhecemos hoje do Ruby é herança da idéia original de TDD do Kent Beck. Foi escrito por **Nathaniel Talbott** originalmente com o nome de [Lapidary](http://lapidary.sourceforge.net/) e demonstrado na primeira e lendária RubyConf de 2001. Ele se inspirou na documentação original de Kent Beck, [Simple Smalltalk Testing With Patterns](http://www.xprogramming.com/testfram.htm) que é o pai de todos os frameworks de TDD atuais. O objetivo do Lapidary era o mesmo de todo framework TDD:

> Testes Unitários está crescendo em todo lugar, principalmente pelo fato de ser uma prática essencial do XP. Embora XP seja grande, testes unitários existem há um longo tempo e sempre foi uma boa idéia. Uma das chaves para bons testes unitários, não é somente escrever testes, mas ter testes. Qual a diferença? Bem, se você apenas escreve um teste e joga fora, você não tem garantias que alguma coisa não vai mudar mais tarde e quebrar seu código. Se, por outro lado, você tem testes (obviamente você precisa escrevê-los primeiro), e os executa tão frequentemente quanto possível, você lentamente constrói uma parede de coisas que não podem quebrar sem você imediatamente saber disso. É quanto testes unitários atingem seu pico de utilidade.

Então, em maio de 2002, o Lapidary foi substituído por [Test::Unit](http://test-unit.rubyforge.org/), o pacote oficial de testes unitários que vem pré-instalado junto de todo Ruby – e por isso é particularmente útil em comparação com outros pacotes de programação que não tem um pacote padrão de testes.

Depois de Alistair Cockburn, depois de Kent Beck, depois de TDD e XP, quem já estava dentro do assunto anos atrás começou a pensar em evolução. Um deles foi Dave Astels que escreveu este artigo [A New Look at Test Driven Development](http://techblog.daveastels.com/2005/07/05/a-new-look-at-test-driven-development/). Ele explica os problemas do TDD e como se transita para um novo paradigma chamado BDD. Na mesma época Dan North estava evoluindo o conceito de User Stories do Alistair para o formato canônico que conhecemos hoje, por exemplo, com o famoso artigo [What’s in a Story](http://dannorth.net/whats-in-a-story/), criando as fundações para o Behavior Driven Development, ao mesmo tempo implementando [JBehave](http://dannorth.net/introducing-bdd/) para ser usado em vez de JUnit.

O foco passaria a ser centrado em “comportamento” e o Astels explica:

> Uma grande diferença é o vocabulário. Em vez de fazer subclasses de <tt>TestCase</tt>, você faz subclasses de <tt>Context</tt>. Em vez de escrever métodos que começam com <tt>test</tt> você começa com <tt>should</tt>, ou preferencialmente você não precisa se preocupar com o padrão de nomenclatura de forma a poder escolher o nome mais apropriado. Em vez de fazer verificação com <tt>assertions</tt> (ex. <tt>assertEquals(expected, actual)</tt>) você especifica pós-condições com algo como <tt>shouldBeEqual(actual, expected)</tt>.

O livro do David Chelimsky, o recém-lançado [The RSpec Book](http://pragprog.com/titles/achbd/the-rspec-book) continua a história:

> RSpec foi criado por Steven Baker em 2005. Steven ouvira falar sobre BDD a partir do Aslak Hellesøy, que trabalhara em um projeto com Dan North quando a idéia surgiu da primeira vez. Steven já estava interessado na idéia quando Dave Astels sugeriu que com linguagens como Smalltalk e Ruby, nós poderíamos mais facilmente explorar novos frameworks de TDD que poderiam encorajar o foco em comportamento. E RSpec nasceu.
>
> Embora os detalhes sintáticos tenham evoluído desde a versão original do RSpec do Steven, a premissa básica permanece. Nós usamos RSpec para escrever exemplos executáveis de comportamento esperado de um pequeno pedaço de código em um contexto controlado.

Por isso eu insisto tanto em pesquisar novamente definições e história. RSpec, não é nada radicalmente diferente de um Test::Unit. Mas seu foco é tentar **encorajar** os desenvolvedores a pensar na forma de **comportamento** (“Behavior”) e o primeiro pequeno passo é renomear algumas palavras-chaves na forma que definimos testes unitários para tentar guiar nessa direção. Ou seja, se estiver consciente disso, obviamente você pode escrever no estilo BDD usando a mesma sintaxe do Test::Unit atual (por isso os dois testes que escrevi acima, com Test::Unit e depois com RSpec, não parecem tão diferente, olhando superficialmente).

Vou pegar algumas coisas emprestadas do livro do Chelimsky, a começar pela definição de “Behavior Driven Development”

> Behavior Driven Development tem como objetivo implementar uma aplicação através da descrição de seu comportamento a partir da perspectiva de seus stakeholders.

Quando praticamos somente TDD, sem atenção às outras práticas de XP que certamente cobrem User Stories, repriorização de Backlog, acabamos nos focando apenas na parte técnica. No final temos um excelente sistema, maravilhosamente coberto com testes unitários, testes de integração, porém o objetivo do projeto – o objetivo dos stakeholders que pagam por esse projeto – não foi atingido. Isso é uma coisa difícil de explicar para programadores cabeça-dura: em bom francês, o cliente está c@gando e andando se seu software tem 400% de cobertura de testes unitários se o objetivo dele era lançar 4 meses atrás na metade do custo e ainda está faltando funcionalidade que ele precisava.

A idéia do BDD, do ponto de vista de implementação é tentar direcionar os programadores em direção à implementação do que realmente interessa ao stakeholder – e não ao seu ego de hacker.

Seguindo esse raciocínio, uma coisa importante num processo Ágil é a definição de [Done](http://agilesoftwaredevelopment.com/2006/05/definition-of-done) (Pronto). Sem isso não existe parâmetro para saber se um software está pronto ou não. Para o programador é quando ele “acha” que o código está bom, para o stakeholder é quando ele “acha” que funciona como ele “acha” que queria. Rastrear User Stories ou Use Cases ou o que for, manualmente, é muito trabalhoso.

Novamente retornando ao livro do Chelimsky:

> Em 2003, Chris Stevenson, que estava trabalho com Aslak na ThoughtWorks na época, criou uma pequena ferramenta em Java chamada [TestDox](http://agiledox.sourceforge.net/). O que ele fazia era simples: lia código fonte em Java com testes em JUnit e produzia documentação textual a partir dele. O seguinte código Java:
>
> * * *
> java
>
> public class AccountDepositTest extends TestCase {
> public void testAddsTheDepositedAmountToTheBalance() { … }  
> }  
> -
>
> produziria o seguinte texto:
>
> * * *
>
> Account Deposit
> – adds the deposited amount to the balance  
> -
>
> Era uma ferramenta bem simplista, mas teve um efeito profundo nas equipes apresentadas a ele. Eles começaram a publicar relatórios de TestDox para todos verem, encorajando os programadores a escrever sentenças reais em seus testes, ou os relatórios de TestDox pareceriam grego.
>
> Tendo sentenças reais em seus testes, os programadores começaram a pensar sobre comportamento e o que o código deveria fazer, e a bola de neve do BDD começou a rolar.

E especificamente sobre o Cucumber:

> Mesmo antes de começar a explorar estrutura e sintaxe para RSpec, Dan North estava explorando um modelo completamente diferente para uma ferramenta BDD.
>
> Ele queria documentar e dirigir o comportamento em uma linguagem simplificada que poderia facilmente ser entendida pelos clientes, desenvolvedores, testadores, analistas de negócio e assim por diante. O resultado inicial dessa exploração foi a biblioteca JBehave, que ainda está em uso ativo e em desenvolvimento.
>
> Dan portou o JBehave para Ruby como RBehave, e o mesclou dentro do RSpec como o Story Runner. Ele suportava somente cenários escritos em Ruby no começo, mas depois adicionamos suporte a textos em inglês puro, abrindo todo um novo mundo de expressividade e acesso. Mas à medida que novas possibilidades eram reveladas, também apareciam limitações.
>
> Na primavera de 2008, Aslak Hellesøy se colocou para reescrever o Story Runner do Rspec com uma gramática real definida com a biblioteca Treetop do Nathan Sobo. Aslak o chamou de Cucumber, em sugestão da sua noiva, Patricia Carrier, imaginando que seria um título temporário até ser mesclado de volta no RSpec. Mas eles nem imaginavam que Cucumber desenvolveria uma vida própria.

[![](http://s3.amazonaws.com/akitaonrails/assets/2011/4/17/Screen%20shot%202011-04-17%20at%203.23.56%20PM_original.png?1303064641)](http://pragprog.com/titles/achbd/the-rspec-book)

Cucumber, Rspec, implementando os conceitos de BDD, se tornam não somente a especificação das User Stories, mas praticamente a própria implementação da definição de “Done”. Se a feature do Cucumber passa, quase poderíamos considerá-la “Done” mesmo.

## Retornando à Controvérsia

Essa história parece longa, mas no meu artigo eu apenas coloquei um micro-resumo. Se você não conhecia esses episódios, significa que ainda tem muito a aprender sobre esta prática muito específica de Engenharia de Software chamada “Software Testing”. Ela vai muito mais longe do que meros “asserts” ou “shoulds”. Ela trata de um mundo muito mais amplo chamado “Qualidade”, mas esse assunto fica para outro artigo.

Em resumo, a controvérsia Test::Unit vs RSpec/Cucumber é – pra variar – uma questão de discussão sobre [estética](http://en.wikipedia.org/wiki/Aesthetics). E como os sábios já diziam:

> A Beleza está nos olhos de quem vê.

Portanto, para muitos, a estrutura sintática da DSL do RSpec e Cucumber são praticamente a sétima maravilha. E eu não discuto que a sintaxe é muito elegante, até surpreendente para quem nunca viu e começa a enxergar os potenciais de explorar o tema de [Domain Specific Languges](http://my.safaribooksonline.com/book/software-engineering-and-development/ide/9780132107549).

Elas são a solidificação das idéias e conceitos de Dave Astels, Dan North e muitos outros que pesquisaram, exploraram e continuam tentando encontrar novas formas de aumentar a qualidade do software e a satisfação final do cliente – que é o que realmente interessa em qualquer projeto de software.

Porém, as ferramentas são auxílios para a implementação de um conceito. Se você não entende o conceito, não importa que ferramenta use: seu projeto vai fracassar miseravelmente, como sempre fracassou.

O valor é mais óbvio para quem já passou muito tempo antes fazendo testes unitário em ferramentas como o JUnit ou mesmo o Test::Unit do Ruby, porque a mudança de nomenclatura, a saída da execução do teste na forma de relatório legível por seres humanos, vai forçá-lo a repensar a maneira como escreve seus testes – mudando de uma forma mais de sistema para uma forma centrada em comportamento.

Quem nunca fez testes antes, dificilmente vai entender porque estamos discutindo – porque ele não viu como era feito antes e não entende a diferença.

Mas se você já entendeu o que significa _Behavior-Driven_, então você também é capaz de expressar comportamento da mesma forma usando Test::Unit ou qualquer outra ferramenta mais tradicional de testes. Portanto, usar Test::Unit não dificulta em nada o processo e você será capaz de escrever tranquilamente, implementando conceitos da mesma forma que quem usa RSpec.

Existe uma diferença técnica que faz toda a diferença: Ruby já vem por padrão com Test::Unit e Ruby on Rails suporta por padrão Test::Unit. Pode não parecer muita coisa, mas pense assim: você cria uma nova biblioteca, que usa Ruby puro e sequer tem dependências com outras gems. Agora você decide testar com RSpec. Só por causa disso, todo mundo que quiser colaborar vai ter que baixar e instalar todas as dependências do RSpec – que nada tem a ver com o objetivo da sua biblioteca.

Parece pouco, mas é aquela “pequena coisinha” que inconscientemente pode deixar alguns potenciais colaboradores de nariz virado sem saber porque. E isso porque todo bom programador sabe que deve procurar sempre nunca reinventar a roda, mas por outro lado também desenvolver e depender da menor quantidade de dependências externas quanto possível.

Minha conclusão, é: se você ainda é novato no assunto e está em dúvida, comece com Test::Unit. Você já tem ele na sua máquina, os generators de Rails todos geram templates de Test::Unit por padrão, e basta ler o código-fonte do próprio Rails para encontrar centenas de ótimos exemplos de como usar Test::Unit. Sentiu que está confortável com Test::Unit? Agora compre o livro do Chelismky, baixe RSpec, Cucumber, e comece a entender o ciclo diferente que é BDD.

Depois de mais algum tempo, se sentiu confortável com RSpec e a forma BDD de fazer as coisas? Pois bem, eis o desafio: retorne ao Test::Unit e tente desenvolver exatamente da mesma forma como em RSpec. Você vai ver que é praticamente a mesma coisa.

Em paralelo a isso, independente de Test::Unit ou RSpec, não se esqueça que hoje temos um enorme ecossistema próprio somente para testes:

- [Test::Unit](http://test-unit.rubyforge.org/) – o pacote canônico de testes do Ruby
- [Rspec](http://rspec.info/) – a nova geração de testes unitários com conceitos de BDD
- [Cucumber](http://cukes.info/) – a famosa ferramenta de BDD
- [Pickle](https://github.com/ianwhite/pickle) – Cucumber precisa de “steps” para executar as “features” (user stories), este projeto já lhe fornece dezenas de steps reusáveis para facilitar o desenvolvimento
- [Capybara](https://github.com/jnicklas/capybara) – abstração e simulação do usuário num navegador para testes de aceitação. Se integra com Cucumber, Rspec, Test::Unit, Ruby on Rails, Rack. Tem drivers para Selenium, HtmlUnit ([Akephalos](https://github.com/bernerdschaefer/akephalos) – o melhor -, [Celerity](https://github.com/sobrinho/capybara-celerity), [Culerity](https://github.com/sobrinho/capybara-culerity)), [env.js](http://github.com/smparkes/env-js), e [WebKit](https://github.com/thoughtbot/capybara-webkit).
- [Factory Girl](https://github.com/thoughtbot/factory_girl) – para criar dados de teste no banco de dados de forma mais fácil do que usando fixtures
- [Evergreen](https://github.com/jnicklas/evergreen) – é uma ferramenta para testar seu Javascript – coisa que poucos fazem – mas com este pacote ele fornece os meios de testar Javascript com a mesma facilidade que você testa Ruby, mas num ambiente isolado, headless (sem navegador nativo), simulando um HTML DOM (como env.js, por exemplo, ou outros integrados com Capybara)
- [Metric-Fu](https://github.com/jscruggs/metric_fu) – além de apenas testar cegamente, ferramentas de métricas podem ajudá-lo a encontrar pontos menos testados do que deveriam, complexidade desnecessária no código e assim por diante.
- [Hudson](http://wiki.hudson-ci.org/display/HUDSON/Configuring+a+Rails+build) – e de nada adianta ter testes se você não os executa constantemente. Fazer isso na sua máquina de desenvolvimento, manualmente o tempo todo, é tedioso. Para isso existem servidores de [Integração Contínua](http://www.extremeprogramming.org/rules/integrateoften.html) como o Hudson/Jenkins, que se integra bem com projetos de Ruby on Rails.

Como podem ver, o assunto “Testes” é bastante extenso, complexo e com uma longa história que deve ser entendida para que saibamos o que já foi feito e continuarmos a evolução daqui. TDD e BDD não são dogmas, não são procedimentos obrigatórios. Você vai encontrar exemplos que deram muito certo e muito errado, ou seja, temos somente [dados empíricos](http://en.wikipedia.org/wiki/Empirical_research) que nos levam a crer que esta é uma das melhores formas de se desenvolver software. Porém isto não é uma Teoria geral. Ela deve ser entendida, interpretada, modificada, medida e novas conclusões podem aparecer.

Rspec vs Test::Unit? Isso não é nem uma fração da história toda. Antes de achar que pode discutir a respeito, primeiro desça ao básico: você sabe a **definição** do que é um [teste unitário](http://en.wikipedia.org/wiki/Unit_testing)? (Dica: leia o documento [ANSI/IEEE Std 1008-1987 – IEEE Standard for Software Unit Testing](http://s3.amazonaws.com/akitaonrails/files/std1008-1987.pdf)).
