---
title: Conversando com Ola Bini (JRuby Core Team Member)
date: '2007-06-21T20:42:00-03:00'
slug: conversando-com-ola-bini-jruby-core-team-member
tags:
- interview
- jruby
draft: false
---

**English readers, click [here](/2007/6/21/chatting-with-ola-bini-jruby-core-team-member)**

Já faz alguns dias desde o histórico lançamento do JRuby 1.0, a primeira implementação estável de um interpretador Ruby alternativo. E que outra plataforma além de Java para suportar o poder de Ruby?

Conheçam **Ola Bini** , um jovem, dinâmico e importante colaborador desde incrível projeto. Ola é membro do **JRuby Core Team** e atualmente trabalha na ThoughtWorks para ajudar a assegurar o contínuo sucesso de JRuby.

Eu tive a oportunidade de conversar com ele por mais de uma hora. Então, outra grande entrevista para nosso site.

![](/files/511173503_15ef7dc203.jpg)


 **AkitaOnRails** : Oi. Olá, você está pronto?

**Ola Bini** : E aí. Sim, claro, vamos começar!

**AkitaOnRails** : Legal! Primeiro de tudo, muito obrigado por aceitar meu convite. Eu entendo que você está muito ocupado. E é exatamente por isso que será interessante falar com você, já que está envolvido em tantas coisas legais.

**Ola Bini** : hehe. Sim, espero que possamos falar sobre isso também.

**AkitaOnRails** : Agora, em segundo lugar, parabéns por ambas as conquistas tanto do lançamento do JRuby 1.0 e da sua mudança para Londres se tornando um [Thoughtworker](http://ola-bini.blogspot.com/2007/03/thoughtworks.html).

**Ola Bini** : Obrigado! Estou muito contente com ambas as coisas.

**AkitaOnRails** : Sempre começo minhas entrevistas com uma pequena introdução à origem do programador, ou como você entrou no mundo de tecnologia. Jovens programadores aqui têm muitas questões e dúvidas e acho que isso os ajuda a colocar as coisas em perspectiva. Poderia nos dizer como você começou? O que o fez escolher programação?

**Ola Bini** : Bem … Eu acho que meu pai foi uma influência. Eu comecei a programar Basic em um Apple IIc quando tinha 7 ou 8 anos de idade. Eu me divertia desde o começo, então meu pai me ajudou muito, ele me deu meu próprio computador e tudo mais. Então Basic foi o que fiz primeiro, mas C foi a primeira linguagem real de programação que aprendi e usei ativamente.

**AkitaOnRails** : Programação de jogos?

**Ola Bini** : Sim, jogos e programação de demos nos primeiros anos. Peguei C, a maior parte de C++, Assembler e Pascal antes de ter 16 anos. Na realidade eu larguei o colégio, já que recebi uma oferta para trabalhar como programador em Stockholm. Foi como comecei a fazer isso profissionalmente.

**AkitaOnRails** : Só por diversão?

**Ola Bini** : Sim, a programação de jogos e demos era só diversão.

**AkitaOnRails** : Puxa, então você começou a trabalhar com programação bem cedo na sua vida.

**Ola Bini** : Sim. Eu consegui um emprego de tempo integral programando Java aos 18 anos.

**AkitaOnRails** : Então você pulou bem rápido de C, para C++, Pascal e Java.

**Ola Bini** : Sim. Java foi fácil depois de C e C++. Pascal eu nunca gostei, mas precisei aprender já que a maioria dos tutoriais de programação de gráficos usava ele.

**AkitaOnRails** : Então seu primeiro emprego foi na área de gráficos?

![](/files/img1098574794.jpg)

**Ola Bini** : Na realidade não. Foi programação para Web com Java, JSP, PHP, ASP e outras tecnologias assim, para um departamento da [Karolinska Institutet](http://ki.se/), fazendo sistemas web para aprendizado à distância.

**AkitaOnRails** : Sim, aliás, você mencionou Stockholm. Você é de lá? Suécia?

**Ola Bini** : Não, sou de local pequeno chamado Kode, que é cerca de 60km ao norte de Gothenburg. E sim, sou da Suécia. Mudei pra Stockhold aos 18 aos.

**AkitaOnRails** : Uau, acho que seus pais ficaram bem chocados com você largando a escola para trabalhar tão cedo. Você chegou a se formar?

**Ola Bini** : Bem, não tão chocados na realidade. Eu realmente não aprendi muito durante o período escolar, então não foi uma grande surpresa para meus pais. E não, não me formei.

**AkitaOnRails** : E eu imagino que isso foi na Era da Bolha da Internet de 2000? Já que você mencionou ferramentas web.

**Ola Bini** : Na realidade foi 2001, diretamente depois da bolha, então tive sorte em arrumar um emprego.

**AkitaOnRails** : Entendo. Você tem um grande conhecimento de Java, como começou a trabalhar com Java? E como chegou a se interessar em Ruby?

**Ola Bini** : Sim, eu nunca fui muito fã de Java como uma linguagem, e eu sempre me interessei em outras linguagens. Então aprendi [Lisp](http://en.wikipedia.org/wiki/Lisp_programming_language) bem cedo e me apaixonei por ele. Alguns anos atrás, 3 ou 4 eu acho, descobri Ruby e tentei convencer meu empregador que deveríamos trocar vários scripts Perl e Bash de nosso ambiente por Ruby. Isso não funcionou muito bem, mas eu continuei falando sobre Ruby e usando em meu tempo livre, e um ano e meio atrás finalmente goleamos, fizemos um piloto em Rails e foi claramente um sucesso.

**AkitaOnRails** : Teve algum evento em particular que o levou a Ruby, ou você encontrou por acidente?

**Ola Bini** : Acho que foi por acidente, especialmente porque não me lembro de um ponto exato.

**AkitaOnRails** : Lisp tem uma [herança](http://www.levenez.com/lang/history.html) completamente diferente de linguagens estruturadas como C. Eu acho que você gostou do aspecto [funcional](http://en.wikipedia.org/wiki/Functional_programming) dela?

**Ola Bini** : Sim. E da maleabilidade. Sou muito fã de macros no [Common Lisp](http://en.wikipedia.org/wiki/Common_Lisp), e também gosto da estrutura muito direta de um programa Lisp. O fato que não existe divisão real entre dados e código. O aspecto funcional é prazeroso, mas não a principal razão de gostar dele.

![](/files/510521311_e2ca389c3e.jpg)

**AkitaOnRails** : Voltando ao JRuby. Eu li do seu [blog](http://ola-bini.blogspot.com/2005/12/homegrown-dao-to-hibernate-to-rails.html) que está trabalhando com JRuby desde o começo de 2005? Como se tornou um membro do JRuby Core Team? Você já conhecia [Charles](http://headius.blogspot.com/) ou [Thomas](http://www.bloglines.com/blog/ThomasEEnebo) anteriormente?

**Ola Bini** : Fim de 2005. E não, eu não os conhecia antes. Eu comecei contribuindo pequenas coisas primeiro, e então em [Março](http://ola-bini.blogspot.com/2007/03/jruby-regular-expressions.html) e [Abril](http://ola-bini.blogspot.com/2007/04/on-activerecord-jdbc-performance.html) passados eu fiz algumas coisas grandes. Eu continuei ajudando e logo depois de [Charles e Tom serem contratados pela Sun](http://www.tbray.org/ongoing/When/200x/2006/09/07/JRuby-guys) eles decidiram que eu seria uma boa adição ao Core Team.

**AkitaOnRails** : Você ainda estava trabalhando em JRuby no seu tempo livre ou isso se tornou uma empreitada de tempo integral?

**Ola Bini** : Eu nunca pude trabalhar tempo integral em JRuby; algumas vezes eu podia trabalhar nisso em intervalos no meu trabalho, mas a maior parte foi no tempo livre. Até agora, claro.

**AkitaOnRails** : Existe muita dúvida e medo na mente de programadores Java inexperientes aqui. Eles sentem “medo” de terem perdido tempo aprendendo Java. Eles “acham” que Ruby é uma linguagem menor, e assim por diante. Eu acho que o problema é que a maior parte deles acham que só precisam aprender uma única linguagem. Essa é uma questão dupla: primeiro, você mencionou que não gostava muito de Java. Poderia elaborar sobre isso? E segundo, o que você gosta sobre Ruby?

![](/files/504012154_839b1be79a.jpg)

**Ola Bini** : Eu gostaria de começar dizendo isso: é muito difícil se tornar um bom programador sabendo apenas uma única linguagem. Saber diversas linguagens de programação de diferentes estilos é [imperativo](http://media.pragprog.com/titles/mjwti/generalist.pdf) para usar uma linguagem bem. Saber Lisp me torna um programador Java melhor. Meu antigo colega de trabalho Lars me disse que aprender Ruby o tornou um programador Java melhor. Então, aprender outra linguagem é de fato algo que você pode fazer, e deve fazer, para se tornar um programador melhor em Java, por exemplo.

**AkitaOnRails** : Eu não esperaria resposta melhor.

**Ola Bini** : Então, Java: eu acho que a linguagem é muito verbosa, o sistema de tipos é inconsistente e meio irritante às vezes, e não existe maneira de comprimir o código. Quando se refatora, acaba-se com mais linhas de código para a mesma funcionalidade. Além disso, existe muita sujeira em um programa típico.

Eu não acho que [generics](http://weblogs.java.net/blog/arnold/archive/2005/06/generics_consid_1.html) melhorou a situação. E acho que Ruby tem quase o mesmo poder que estou acostumado com Common Lisp. Em alguns casos você pode fazer coisas incríveis com as capacidades de [meta-programação](http://ola-bini.blogspot.com/2006/09/ruby-metaprogramming-techniques.html). Ruby é como argila, que pode ser moldado no que quiser, e Java é mármore. Além disso, gosto do fato que Ruby tem suficiente herança de Perl para ser pragmático e fácil de usar; é rápido de se começar e você se torna produtivo em pouco tempo.

**AkitaOnRails** : Ruby é uma linguagem excelente, sem dúvida. Ruby 1.9 está crescendo para se tornar melhor. Você está atualizado com esse desenvolvimento? Eu pessoalmente tenho algumas coisas que gostaria de ter em uma nova versão, como suporte completo de UTF-16, um melhor e unificado aparato de Datetime, pelo menos uma dependência menor no C, um generational garbage collector, uma maneira melhor para as IDEs poderem fazer introspecção e debug no código talvez como Smalltalk faz. Agora que você tocou na maior parte da linguagem, o que acha que mudaria se tivesse a oportunidade? Ou você está satisfeito com o estágio atual?

**Ola Bini** : Não, eu não estou satisfeito, o que é uma das razões de eu trabalhar no JRuby. Existem algumas funcionalidades da linguagem Ruby que eu acho que a torna difícil em alguns casos. As operações de file system não são abstraídas o suficiente, muito centrado no Unix.

O sistema de threading é perigoso já que ele dá às funcionalidades um sistema “real” de threading que o GC nunca poderia dar. (Coisas como [critical=](http://jira.codehaus.org/browse/JRUBY-1157) e [ObjectSpace](http://www.rubycentral.com/book/ospace.html) eu gostaria de ver sumindo).

Então, um GC melhor, melhores maneiras de tuning, um sistema melhor de threading, sem global locking. Mas neste instante, as funcionalidades vão se provar. Se [Rubinius](http://blog.fallingsnow.net/rubinius/) fizer as escolhas certas para essas coisas, ela vai trazer mais usuários do que MRI/KRI no longo prazo. Eu concordo sobre um suporte melhor a UTF, claro. Qualquer um que não é de países com língua inglesa sabe disso.

 ![](/files/279242203_f1b6d306d9_m.jpg)

**AkitaOnRails** : Eu estava tentando contactar Evan Phoenix. Charles mencionou Rubinius também. Como você acha que ambos os projetos podem colaborar? Que brechas o Rubinius fecha para o JRuby, por exemplo?

**Ola Bini** : Estamos tentando cooperar. Especialmente com testes e implementar mais da biblioteca principal em Ruby. Evan está se mudando para Los Angeles esta semana, então é por isso que você não vai conseguir achá-lo.

**AkitaOnRails** : Sim, foi o que ouvi. E falando nisso, eu ficaria pessoalmente com medo de trabalhar em algo tão grande quanto JRuby. O que me amedronta mais são as partes [codificadas em C](http://www.rubyinside.com/how-to-create-a-ruby-extension-in-c-in-under-5-minutes-100.html). Existem diversas funcionalidades principais do Ruby totalmente em C. Quão difícil foi isso para você? Pode nos dizer sobre algum problema em particular que o deixou coçando a cabeça?

**Ola Bini** : Bem, sim, partes do MRI podem ser bem “interessantes”. Eles fazem coisas como modificar o [argc e argv](http://faq.cprogramming.com/cgi-bin/smartfaq.cgi?id=1043284392&answer=1046139290) para métodos varargs. O problema com código C é que ele usa ponteiros pesadamente, por todos os lados. Algumas vezes eles encapsulam objetos não-Ruby em um ponteiro [VALUE](http://www.oreillynet.com/ruby/blog/2006/01/the_ruby_value_1.html)  
o que é pura gambiarra. Mas isso normalmente não é difícil de entender, já que eu fiz muito código C na minha época.

**AkitaOnRails** : A implementação do JRuby se provou de muito sucesso mas não sem seus problemas. [Unicode](http://headius.blogspot.com/2006/06/unicode-in-ruby-unicode-in-jruby.html), [SSL](http://ola-bini.blogspot.com/search/label/openssl), [Regex](http://jira.codehaus.org/browse/JRUBY-1046), [YAML](http://jira.codehaus.org/browse/JRUBY-561). Por exemplo, você descreveu diferenças na implementação de expressões regulares do Java e da versão do Ruby MRI no seu blog. Quais foram as partes mais difíceis no processo de portar, do seu ponto de vista? Onde estava a carga pesada?

 ![](/files/511173733_e5680a0442.jpg)

**Ola Bini** : Existem basicamente duas coisas que foram o “pior” em fazer as coisas funcionar. A primeira eram os casos periféricos. Comportamentos estranhos que não estão especificados, mas que apenas se comportam assim por causa da implementação.

Já tentou usar _super_ de dentro de um bloco, onde o método ao redor pega um \* args e você modifica o args? Threading se provou problemático também. E a outra área principal é, como você disse, extensões. É basicamente impossível rodar qualquer coisa significativa sem portar muitas extensões. Apenas alguns dos que precisamos, por exemplo: strscan, yaml, zlib, enumerable e regexps são problemáticos. Temos três diferentes engines agora, a do Java, o [JRegex](http://jregex.sourceforge.net/) (que é o que usamos), e outro chamado REJ, que é a engine regexp do MRI portado para Java. (REJ não é usado.)

**AkitaOnRails** : Antes do JRuby realmente começar a ganhar tração (principalmente por causa do Rails, eu acho) ele estava bem parado. Estava tentando cobrir Ruby 1.8.2 se me lembro corretamente. Então muita coisa não estava coberta naquela época?

**Ola Bini** : Sim, é verdade. A maior parte do progresso que fizemos, foi feito de Janeiro de 2006 para cá. O suporte estava lá. Grandes partes do parser estavam funcionando bem, mas quase nenhuma extensão, e muitas partes da linguagem ainda estavam no nível do 1.6.

**AkitaOnRails** : Eu lembro de ler no seu blog sobre uma maneira de rodar [Mongrel Cluster](http://ola-bini.blogspot.com/search/label/mongrel) inteiramente dentro de uma única JVM. Isso foi só uma prova de conceito ou você vê aplicações Rails sendo instaladas desse jeito? Qual seria a vantagem de usar Mongrel no espaço da JVM? Ou o principal para Rails é o plugin Goldspike e as ferramentas [JRuby-Extras](http://rubyforge.org/projects/jruby-extras/) ?

**Ola Bini** : Eu fiz isso inicialmente como prova de conceito, mas acho que é uma solução viável. Eu achei que seria interessante fazer alguma coisa para as pessoas vindas do mundo Ruby. Pessoas acostumadas a usar Mongrel. Eu queria lhes dar uma solução melhor do que iniciar 10 JVMs. E isso está no núcleo, o JRuby server é uma ferramenta generalizada que pode ser usada em outras circunstâncias também.

**AkitaOnRails** : Mas o Goldspike não requer Mongrel para rodar. Então nós temos 2 maneiras de rodar Rails no espaço Java.

**Ola Bini** : Absolutamente. E eu acho que o caminho do Goldspike é a superior. Mas Ruby é totalmente sobre [escolhas](http://headius.blogspot.com/2006/06/mongrel-in-jruby.html) e flexibilidade.

**AkitaOnRails** : Acho que vamos voltar nesse assunto quando falarmos do [Mingle](http://studios.thoughtworks.com/2007/5/7/mingle-to-run-on-jruby). O que me traz à [ThoughtWorks](http://studios.thoughtworks.com/). Nos conte essa história. Como você os conheceu? Como entrou a bordo?

**Ola Bini** : Bem, o nome era familiar por um bom tempo. Eles ganharam uma boa reputação, como você sabe. Abril do ano passado uma amiga minha foi contratada. Nos falamos um pouco e parecia ser um bom lugar. Decidimos que eu deveria tentar. Ela fez uma recomendação e eu fui fazer uma entrevista em Agosto. Tudo foi bem, exceto que eles não tinham tido muito lucro até aquele ponto, então não poderiam me contratar. Voltamos a fazer contato novamente em Fevereiro, começamos a falar sobre Ruby e ThoughtWorks Studios. Eu fui, fiz uma rápida entrevista com a Cyndi, e o resto foi basicamente logística.

**AkitaOnRails** : [Cyndi Mitchell](http://studios.thoughtworks.com/2007/3/6/how-to-mingle) ?

**Ola Bini** : Sim. Ela é um dos meus chefes. (A estrutura aqui não é bem clara … :-)

**AkitaOnRails** : Ela fez uma [apresentação](http://conferences.oreillynet.com/cs/rails2007/view/e_sess/14493) na RailsConf se me lembro corretamente.

**Ola Bini** : Sim, ela fez. Foi ela também que colocou meu nome e número na telona. :-) Eu fui lá com ela, Roy e [Martin Fowler](http://www.martinfowler.com/bliki/), e alguns outros ThoughtWorkers.

![](/files/cyndy.png)

Lá é uma estrutura plana, sim, o que significa que não tenho chefes explícitos, mas chefes que gerenciam áreas diferentes do meu tempo, assim por dizer. Então Chad Wathington cuida do meu trabalho na [RubyWorks](http://studios.thoughtworks.com/rubyworks), Cyndi lida com toda logística de contratação para a Studios, e Alexei Vorontsov é Gerente de Projetos para a [RubyWorks](http://rubyworks.rubyforge.org/). Todos eles meus chefes, por assim dizer.

**AkitaOnRails** : Legal. Eu também li que você está trabalhando no Mingle. Esse é outro marco importante por ser provavelmente a primeira aplicação comercial em JRuby com suporte de uma grande empresa. Por favor, elabore sobre o que é Mingle e quais suas responsabilidades nesse projeto.

**Ola Bini** : Absolutamente. Então, Mingle é um sistema de gerenciamento ágil de projetos. Ele objetiva ser mais flexível e mais próximo dos métodos ágeis que as pessoas ágeis adoram praticar mais. Minha responsabilidade é até que bastante simples: é minha tarefa garantir que o JRuby funcione, consertar problemas e ajudar quando fazem aplicações bi-implementadas, para que rode tanto no JRuby quanto no MRI.

**AkitaOnRails** : Tem alguma coisa a ver com o [CruiseControl](http://cruisecontrol.sourceforge.net/overview.html)?

**Ola Bini** : Não, não nesse ponto. Até onde sei, vai haver integração em algum momento, mas não estou envolvido nisso.

**AkitaOnRails** : Ok. Você também está envolvido em várias conferências Java e Ruby por aí. Eu sempre me perguntei como caras como você encontram tempo para 1) realmente apresentar coisas legais nessas conferências; 2) encontram tempo suficiente para trazer grandes projetos open source como JRuby; 3) ainda tem um trabalho tempo integral e são produtivos. Você precisa ter um dia de 48 horas (e eu provavelmente estou atrapalhando seu fluxo de trabalho hoje :-) Como você faz para se organizar?

**Ola Bini** : Na realidade, tentamos dividir as conferências entre os desenvolvedores principais, por exemplo, eu irei na [TSSJS](http://javasymposium.techtarget.com/europe/europe_info.html) enquanto Charles e Tom estão de férias. Apresentar coisas boas nos ajuda a dividir material entre nós. Além disso, Charles e Tom, e agora eu, realmente estamos trabalhando nisso como nossos empregos, onde evangelizar é uma parte importante.

Organização é dureza. Eu normalmente mantenho listas no [tadalist](http://www.tadalist.com/). Isso funciona bem o suficiente para mim. Essa é toda organização que eu estou usando. Mas eu tendo a ser bem caótico, o que funciona bem pra mim.

**AkitaOnRails** : haha, mas você precisa estar no computador por mais horas do que um programador médio para fazer tudo isso.

**Ola Bini** : hehe. Bem, sim. Não estou muito longe dos computadores desde manhã cedo, isso é verdade. Especialmente não agora com o livro que estou escrevendo, o que come muito do meu tempo para outras coisas. =/

**AkitaOnRails** : E falando em ser workaholic e evangelização. Você está escrevendo um novo livro sobre JRuby. Está agendado para ser lançado em alguns meses. Nos fale mais sobre ele.

**Ola Bini** : Bem, é um [livro](http://ola-bini.blogspot.com/2007/06/book-update.html) sobre JRuby on Rails. O objetivo é ser bem prático, dando exemplos reais de como atingir as coisas. Existe muita informação de JRuby no meio, claro, mas não é um livro gerérico sobre JRuby.

 ![](/files/pat.jpg)

A [APress](http://www.apress.com/category.html?nID=155) vai publicar, e de acordo com a agenda atual, será lançado em Outubro. [Pat Eyler](http://on-ruby.blogspot.com/) será meu revisor técnico. E é isso. :-) Deve ficar com umas 250 páginas, contendo 4 projetos JRuby on Rails desenvolvidos do zero.

**AkitaOnRails** : Haha, e eu imagino que está sendo difícil escrever sobre um alvo móvel, não é? JRuby ainda está evoluindo assim como os plugins como Goldspike, que você precisa para a instalação em Java.

**Ola Bini** : Claro. Em alguns casos eu tive que revisar partes substanciais, e em outros casos eu tive que escrever muitas coisas para o JRuby, apenas para conseguir terminar a tempo de lançar o livro. Então, de algumas maneiras, o processo de escrever o livro melhorou meu trabalho com JRuby também, me dando dicas de coisas que eu preciso consertar e assim por diante.

**AkitaOnRails** : Sim, você vê o lançamento de um JRuby 1.1 logo?

**Ola Bini** : Com sorte um JRuby 1.1 será lançado dentro de uns 2 meses. É possível que leve mais tempo, por causa do verão ser época de descanso para alguns de nós. Mas JRuby tem uma tendência de se mover rápido e ter muitos lançamentos, então eu contaria com uns 2 meses.

**AkitaOnRails** : Rails trouxe muito interesse em desenvolvimento com Macs. [Textmate](http://www.pragmaticprogrammer.com/titles/textmate/) é a principal razão. Eu vi algumas das apresentações do Charles e acho que ele estava usando Emacs. Qual é sua ferramenta principal para desenvolver tanto JRuby quanto aplicações Rails?

**Ola Bini** : Na realidade, Charles e Tom normalmente usam [vi](http://wiki.rubyonrails.org/rails/pages/HowtoUseVimWithRails) para apresentações e [Netbeans](http://wiki.netbeans.org/wiki/view/RubyOnRails) quando desenvolvem. Eu sou mais às antigas. Eu trabalho em um Mac, mas sou muito _Lispânico_ para usar qualquer coisa diferente do [Emacs](http://dima-exe.ru/rails-on-emacs). Então Emacs, com meus cerca de 10 mil linhas de código E-lisp, é minha ferramenta principal de trabalho.

**AkitaOnRails** : Ei, você não lançaria seu pacote Emacs como um projeto open source tambem? :-)

**Ola Bini** : hehe. Não, eu acho que não. Está cheio de sujeira e muitas coisas que estão altamente especializadas para mim. Esse é realmente o objetivo do Emacs: você cria seu próprio pequeno mundo.

**AkitaOnRails** : Eu acho que a falta de ferramentas e IDEs fortes ainda são um obstáculo para a adoção em massa de pessoas vindas de Java ou .NET. Você se sente da mesma maneira ou vê uma adoção crescente mesmo assim?

**Ola Bini** : Acho que você está certo, mas eu não vejo isso como uma objeção racional para a mudança. Mas estão vindo muitos bons suportes para Ruby agora, se quiser. Eclipse, Netbeans, [IntelliJ](http://www.jetbrains.com/idea/training/demos/rails.html), jBuilder. Existem muitas opções e parece que eles ficam melhores a cada dia.

**AkitaOnRails** : Mas você não vai largar o Emacs tão cedo ;-)

**Ola Bini** : hehe. Não. Isso não vai acontecer.

**AkitaOnRails** : E finalmente, o que você vê no seu futuro com JRuby? Algum outro projeto pessoal que gostaria de investir mais tempo? Ou você está 100% tempo integral em JRuby por enquanto?

**Ola Bini** : Bem, acredito que JRuby e projetos relacionados a JRuby vão me tomar muito tempo. Se eu conseguir algum tempo livre, provavelmente tentaria me concentrar na minha música; mas se você queria saber de coisas relacionadas a [projetos](http://ola-bini.blogspot.com/2006/09/limits-of-power-what-lisp-can-do-but.html) de informática, existem algumas coisas que eu gostaria de fazer: Jio, uma implementação Java de Io; CLaJ, uma nova implementação de Common Lisp para Java, baseado no [Lisp In Small Pieces](http://en.wikipedia.org/wiki/Lisp_in_Small_Pieces), com o objetivo explícito de ser tanto performático, de fácil manutenção e compatível. E finalmente, eu adoraria poder fazer mais coisas sobre inteligência artificial.

**AkitaOnRails** : Você diz que não gosta muito de Java, mas 2 dos 3 itens são relacionados a Java :-)

**Ola Bini** : Você tem que separar entre Java, a linguagem e Java, a plataforma. A plataforma é excelente, e eu quero que todas as linguagens tenham uma base como essa. E sim, os projetos são baseados em Java, o que significa que eu me sacrificarei para o bem dos outros … :-)

**AkitaOnRails** : Bem dito. E como Steve Jobs diria _“e Tem Mais Uma Coisa™”_: eu tento trazer muitos conselhos de pessoas experientes como você para programadores em começo de carreira. Eles têm muitas questões. O que você recomendaria para essa nova geração de programadores? (Embora eu ache que você mesmo é bem jovem.)

![](/files/515994249_5a5bc1b92d.jpg)

**Ola Bini** : Isso não deve ser uma grande surpresa depois dessa entrevista: meu conselho seria aprender mais de uma linguagem. Bem simples. Alguma coisa funcional, ou com um modelo de concorrência desesperadamente diferente. Lisp, Smalltalk, Erlang e Ruby são todas boas escolhas para programadores Java/C/C++ aprender. E sim, eu acho que sou. Tenho 25 anos agora.

**AkitaOnRails** : Como Dave Thomas disse em Pragmatic Programmer: aprenda pelo menos uma [nova linguagem todo ano](http://www.pragmaticprogrammer.com/loty/).

**Ola Bini** : Absolutamente. Esse é um bom conselho. Não consigo melhorar isso. :-)

**AkitaOnRails** : Falando nisso, só de curiosidade, vocês falam inglês na Suécia?

**Ola Bini** : Não, não muito. Eu falo inglês quando a outra pessoa não entende sueco, ou se alguém em nossa empresa não entende sueco (de cortesia).

**AkitaOnRails** : Foi o que imaginei, seu inglês é muito bom.

**Ola Bini** : Obrigado. Nós estudamos inglês desde a quarta série na Suécia, então a maioria tem uma habilidade passável pelo menos.

**AkitaOnRails** : Tem outra coisa que eu [evangelizo](/articles/2007/04/14/off-topic-seja-arrogante) aqui no Brasil: a aprender inglês o melhor possível. Gostando ou não, é a linguagem do mundo de tecnologia.

**Ola Bini** : Sim, sem dúvida. Inglês é muito importante. E depois disso, eu acho que é o chinês, baseado em simples números.

**AkitaOnRails** : Absolutamente, como vai seu mandarim? :-)

**Ola Bini** : hehe. Meu mandarim e cantonês é totalmente inexistente. Mas eu acho que isso vai chegar… :-)

**AkitaOnRails** : Eu acho que a ThoughtWorks tem um escritório na China também, não tem?

**Ola Bini** : Sim, temos duas. É possível que eu mude para lá por 6 meses no ano que vem. Mas eu não tenho nenhuma facilidade com linguagens humanas. Inglês é a única língua que eu sei além do sueco.

**AkitaOnRails** : Não diga, me conte mais sobre isso. Isso é um furo de reportagem!

**Ola Bini** : Hehe, é possível, mas não certo. Estamos procurando onde a equipe RubyWorks deve ficar, e a China é provavelmente o melhor local para mim. Eu vou mudar para São Francisco mais tarde, mas preciso trabalhar para a ThoughtWorks por um ano para conseguir um visto L1 primeiro.

**AkitaOnRails** : China? Melhor para você? Por quê?

**Ola Bini** : Já que muitos da equipe da RubyWorks estarão lá ou em Bangalore.

**AkitaOnRails** : Ruby, com JRuby, está chegando perto de seu local de nascimento (Japão). Curioso. Bem, eu acho que já atrapalhei demais suas horas de trabalho. Outra grande entrevista finalizada ;-) Algum comentário final para a audiência brasileira?

**Ola Bini** : hehe. Obrigado. Não. Acho que já disse tudo agora :-) Eu espero poder ir ao Brasil um dia, então não seja muito duro comigo quando eu chegar!

**AkitaOnRails** : Legal. Foi bom falar com você. Eu espero que possamos trocar mais idéias outro dia. Muito obrigado!

**Ola Bini** : Obrigado! Me mantenha informado sobre o que acontece. Até mais.

