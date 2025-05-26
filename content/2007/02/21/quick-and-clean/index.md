---
title: Quick and Clean
date: '2007-02-21T04:50:38-02:00'
slug: quick-and-clean
tags:
- career
draft: false
---



 ![](/files/ror_eXchange_logo.jpg)

Dia 9 de fevereiro aconteceu o evento [RoR eXchange 2007](http://www.skillsmatter.com/rorexchange), da [Skills Matter](http://www.skillsmatter.com/), co-organizadora da última [RailsConf](http://www.akitaonrails.com/2007/01/18/rails-1-2-admira%C3%A7%C3%A3o-rest-festival-http-e-celebra%C3%A7%C3%B5es-utf-8). Foi um evento de um dia que reuniu alguns bons palestrantes para discutir os últimos desenvolvimentos no mundo RoR.

Neste [link](http://skillsmatter.com/menu/479) vocês podem assistir a todas as palestras. Ainda não vi todas mas gostei muito da apresentação de Chad Fowler. Parte dela tem a ver com minha coluna de Janeiro na RubyOnBr – [A Dieta dos Controllers](http://www.rubyonbr.org/articles/2007/01/18/a-dieta-dos-controllers/) – onde tentei clarear uma dúvida constante: _“ok, sei que Rails é MVC, mas onde diabos coloco minha lógica de negócios?”_.

Outra parte tem a ver com o que já mostramos sobre o suporte [REST](http://www.akitaonrails.com/category/rails-1-2) no novo Rails 1.2. Mas o ponto alto da palestra é um aviso (muitos não vão gostar, mas vamos lá): Ruby e Rails são anunciados como “linguagem simples”, “framework fácil”, “mais fácil e rápido que Java”, “mais simples de aprender”, etc. Tudo isso dá uma extrema falsa impressão de que qualquer peão (sem ser pejorativo, mas já sendo), que nunca programou na vida, estará desenvolvendo um Yahoo.com amanhã. Novamente, cuidado, essa é a falácia da [causa e efeito](http://www.skepdic.com/refuge/ctlessons/lesson1.html): porque RoR é fácil, _qualquer um_ aprende fácil.

[![](/files/200px-Edgar_F_Codd.jpg)](http://en.wikipedia.org/wiki/Edgar_F._Codd)

Vamos consertar isso: _‘Ruby e Rails são tecnologias muito simples para todos que **JÁ SÃO** bons programadores hoje’_. Nos últimos tempos Chad teve a oportunidade de ver muitos códigos de terceiros, muitos deles códigos de novatos. O que ele viu deve horrorizar qualquer um: Rails não protege a aplicação de um mau programador.  
  
Como disse Chad, Java e C# são tecnologias que foram desenvolvidas para programadores idiotas. Calma! Não quer dizer que quem programa em Java é idiota mas sim que ela foi pensada em termos de dar uma série de _proteções_ para evitar erros banais. É isso que faz o compilador: _protege_ seu código contra erros triviais de tipos (mas _apenas_ contra erros triviais), por exemplo, o tipo de erro que um novato cometeria.  
  
Ruby não tem essas proteções. Linguagens como Ruby, Python, Haskell, O’Caml, foram feitas para bons programadores, aqueles que sabem exatamente o que estão fazendo. Rails é uma excelente ferramenta _apenas_, e _somente apenas_, àqueles que se deram ao trabalho de estudar como ela funciona internamente.

[![](/files/kay-alan.jpg)](http://en.wikipedia.org/wiki/Alan_Kay)

O exemplo de Chad é muito bom: em uma boa tecnologia de ORM como o Active Record do Rails ou mesmo um Hibernate em Java esconde boa parte do SQL que antes era feito manualmente. Agora imagine que você buscou uma lista de usuários do seu banco (find :all), colocou essa lista para iterar em um loop (.each) e está analisando as permissões de cada usuários para mostrar em uma tela. Você acabou de cair na armadilha conhecida como **1 + N** , ou seja, se sua lista de usuários tinha 200 usuários, você vai fazer pelo menos mais 200 queries no banco para buscar as permissões de cada um. Eu discuto isso no meu livro e mostro a diretiva :include dos finders, que é uma das possíveis soluções nesse caso.

Você só sabe onde, quando e como usar uma técnica como [:include](http://ruby.about.com/b/a/000070.htm) se souber exatamente o que o ActiveRecord fará no seu banco, como queries SQL se comportam, o que é um left outer join. Se não tiver nenhum desses conhecimentos, trará um impacto que poderia ser mortal à sua aplicação no médio prazo. Outro exemplo é uma homepage “ocupada” (cheia de pequenas queries e informações dinâmicas, uma página não-Web 2.0, digamos) que também terá um impacto enorme caso o programador não tenha noção das diversas técnicas de caching do Rails (outro assunto que também discuto no meu livro).

Em outras palavras: nem Ruby nem Rails protegerá uma aplicação de um programador folgado. Quando um bom programador (que já tem experiência em bancos de dados, em otimização do modelo request-response do HTTP, em configuração de servidores web como Apache, em ORM, em MVC, em Design Patterns, etc) se encontra com Ruby on Rails, temos um excelente casamento. Quando um programador que não investiu o devido tempo a estudar todos esses assuntos se encontra com Ruby on Rails, temos um desastre. E isso não é só com Rails. Coloque um programador que não tem o costume de se auto atualizar como deveria em qualquer plataforma de desenvolvimento e sempre teremos um desastre.

[![](/files/cernpeo4_5-04.jpg)](http://en.wikipedia.org/wiki/Niklaus_Wirth)

Significa que não há salvação para os novatos? Claro que não, todo programador sênior já foi um júnior. A diferença é que o primeiro investiu cada hora livre de seu tempo em estudo. E eu quero dizer estudo com perspectiva, não um estudo míope de ferramentas, mas sim um estudo amplo de tecnologias. Por que o HTTP é como é? Por que SQL é como é? Por que o que chamamos de MVC atual é como é? Quais as melhores formas de usar todas essas tecnologias em conjunto? Inclusive essa é a linha mestra que guia meu livro: um livro que apenas o leva passo a passo do estágio 1 ao 2, não ensina nada. _“Para buscar todas as linhas da tabela, digite find(:all)”_. Esse é o tipo de ensinamento que torna possíveis bons programadores em programadores folgados. Ele não diz o principal: “por que”, “quais as alternativas”, “o que acontece por baixo”, “quais minhas opções”.

Por muito tempo associamos programação a dois estilos: _quick’n dirty_ (rápido e sujo) ou _slow’n clean_ (lento e limpo), ou seja, se você programar rápido demais, sem pensar muito, apenas cuspindo código, terá algo sujo, difícil de dar manutenção e cheio de bugs. Para ter um sistema estável, com código razoavelmente simples de dar manutenção futura, é preciso planejar de antemão tudo que fará e ir muito devagar. A nova geração Agile de desenvolvimento postula que é possível sim, ser **quick’n clean** , ou seja rápido e limpo. Mas algo que está implícito é: para ser rápido e limpo é preciso ser esforçado, auto-didata e estar sempre experimentando técnicas e tecnologias.

Ninguém consegue ser quick’n clean em qualquer plataforma, linguagem ou tecnologia, mesmo tendo Q.I. de Einstein. Experiência não se herda nem se compra: se adquire, com esforço, treinamento contínuo e de qualidade. Para um jogador profissional de basquete, fazer cestas de três pontos é algo quase trivial. Para um principiante é a coisa mais difícil do mundo, a diferença é que o primeiro provavelmente treinou esse lance por várias horas, durantes vários dias, em vários anos a ponto disso se tornar trivial. É um conceito que vale para qualquer coisa, não apenas programação: quanto mais treinamos, mais as coisas difíceis se tornam simples e podemos partir para treinar algo mais difícil.

[![](/files/donald_knuth7.jpg)](http://en.wikipedia.org/wiki/Donald_Knuth)

Lembre-se: David Hansson, Marcel Molina, Sam Stepherson, Miguel De Icasa, Guido van Rossum, Rasmus Lerdorf, Larry Wall, Anders Hejlsberg, Alan Cox e mesmos outros célebres como Bjarne Stroustrup, Dennis Ritchie, Alan Kay, Niklaus Wirth, Donald Knuth e centenas de outros. Acha que está nos genes? Um bom programador nasce geneticamente bem dotado? A diferença entre um programador ruim e estes nomes é a quantidade de esforço investido em estudo, pesquisa e experimentação. Não existe fórmula mágica, curso à jato de 6 meses, voodoo, que substitua o puro e simples suor.

Enfim, Chad repete o que eu disse na minha coluna: lógica de negócios, SQL, operações no banco, devem estar nos models. Os controllers devem ser modelados na filosofia REST (que não é coisa nova) e simular operações CRUD (atenção aos models implícitos na forma de tabelas de relacionamento many-to-many). Leia meu livro, leia os artigos na categoria [Rails 1.2](http://www.akitaonrails.com/category/rails-1-2) neste blog, assine os feeds de sites como [Ruby Inside](http://www.rubyinside.com/) e outras dezenas de ótimos blogs como do [Dr. Nic](http://drnicwilliams.com/), [Ryan’s Scraps](http://ryandaigle.com/), etc. E principalmente: **estude** , mas estude muito, constantemente e sempre. Não existe ponto final em tecnologia, ninguém jamais poderá dizer _“agora já sei tudo que preciso”_, qualquer um que acha isso ainda não passa de um principiante.

