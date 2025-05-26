---
title: Conversando com Joshua Peek
date: '2008-09-27T21:54:00-03:00'
slug: conversando-com-joshua-peek
tags:
- interview
draft: false
---

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/8/1/468x60.gif)](http://www.locaweb.com.br/railssummit)

Desta vez passei algum tempo com [**Joshua Peek**](http://joshpeek.com/). Foi [anunciado](http://weblog.rubyonrails.org/2008/8/16/josh-peek-officially-joins-the-rails-core) recentemente que ele é o novo membro da Equipe Rails Core.

Ele conseguiu a honra por causa do seu duro trabalho para o próximo Rails 2.2 resolvendo o problema de **thread-safety** no Rails. Por causa do seu projeto no Google Summer of Code, guiado por Michael Koziarski, eles foram capazes de tornar o Ruby on Rails verdadeiramente seguro para threads, o que pode ser muito importante para máquinas virtuais com suporte a threads nativas, como o JRuby.

A parte interessante: ele tem apenas 19 anos e 4 anos atrás sequer era programador. Ele começou no Ruby com o [Learn to Program](http://pine.fm/LearnToProgram/) e agora é membro do Rails Core. Vamos conhecê-lo melhor.


 **AkitaOnRails:** Ok, então vamos começar. Primeiramente, seria legal saber mais sobre você. Por exemplo como encontrou Ruby, porque se enganchou nele.

**Josh Peek:** Como muitas pessoas, eu originalmente encontrei Ruby através do Rails. Na época, eu estava apenas fazendo web design como html, css, js. Eu não tinha experiência de programação. Acho que cheguei a comprar um livro de php, mas nunca fui muito adiante. Então ouvi falar sobre esse tal de “Rails” e fui olhar. Eu rapidamente aprendi que precisava aprender como programar e aprender Ruby, então eu peguei os livros [Pickaxe](http://pragprog.com/titles/ruby/programming-ruby) e [Agile Web Development with Rails](http://pragprog.com/titles/rails3/agile-web-development-with-rails-third-edition) e fui dali.

**AkitaOnRails:** Isso é interessante, um dos meus objetivos de te entrevistar é porque eu vi que você é bem jovem e existem muitos jovens programadores que acham que aprender Ruby é difícil. E você ainda diz que nunca programou antes de Ruby, então como foi a curva de aprendizado para você?

**Josh Peek:** Sim, eu tenho agora **19 anos** e comecie a programar Ruby cerca de 3 anos atrás. Antes de ler o Pickaxe, encontrei este pequeno livro de programação com Ruby do [Chris Pine](http://pine.fm/LearnToProgram/). Me ajudou muito a entender como programar. A parte mais difícil sobre programação, para mim, foi entender os conceitos de orientação-a-objetos. Realmente é uma coisa que você precisa praticar para realmente entender.

**AkitaOnRails:** Oh, esqueci de perguntar, de onde você é? E você é estudante de ciências da computação?

**Josh Peek:** Atualmente estou morando em Chicago, Illinois onde eu frequento a faculdade. E sim, estou estudando Ciências da Computação.

**AkitaOnRails:** Quando você começou a programar com Rails, o que mais te incomodava, se é que tinha algo?

**Josh Peek:** Hmm, não consigo pensar em alguma coisa que me “incomodava”. Nunca foi um problema porque você poderia fazer [monkey patch](http://en.wikipedia.org/wiki/Monkey_patch) ou consertar e liberar para o resto da comunidade Rails.

**AkitaOnRails:** Então você começou a trabalhr com Rails como freelancer? Você fez alguma gem ou plugin open source também?

**Josh Peek:** Sim, comecei como freelancer. Tecnicamente ainda sou. Eu costumava publicar toneladas de plugins de Rails. Acho que exagerei um pouco no começo. Realmente não tenho mais nenhum deles por aí, mas seria legal dar uma olhada neles de novo para ver quanto minha visão de programação mudou desde então.

Agora mesmo, todos os meus plugins e códigos atuais estão no [github.com/josh](http://github.com/josh). Eu acabo publicando todo projeto pessoal em que estou trabalhando no Github mesmo que não esteja pronto ou eu ache que será útil.

**AkitaOnRails:** Ok, então ao prato principal, Thread-Safety! Você disse que não estava particularmente “incomodado” por nada no Rails, mas decidiu atacar esse desafio mesmo assim, como tudo isso começou?

 ![](http://s3.amazonaws.com/akitaonrails/assets/2008/9/26/TwextGoogleSOC2008.png)

**Josh Peek:** Eu realmente queria participar de um projeto no [Google Summer of Code](http://code.google.com/soc/2008/ruby/appinfo.html?csaid=AE462A3EF48107C3) por algum tempo. Entretanto quando fui me inscrever acabei fazendo tudo de última hora, e perguntei pelo Rails Core e algumas idéias apareceram, uma delas foi thread safety.

Eu não estava realmente muito interessado em fazer isso, eu queria mesmo trabalhar no [ActiveModel](http://github.com/rails/rails/tree/master/activemodel/README) como meu projeto. Entretanto o projeto de thread safe foi o único que foi aceito, então fiquei preso nele. Antes de começar o projeto, eu não tinha experiência alguma com threads.

Eu não sabia sequer o que era um mutex, mas eu aceitei isso como uma boa experiência de aprendizado.

**AkitaOnRails:** Talvez fosse interessante se você desse um resumo de como o Google Summer of Code funciona. Quero dizer, quais os objetivos, como participar, quão difícil é. Alguns brasileiros provavelmente não estão familiarizados com isso.

**Josh Peek:** Google Summer of Code é um programa controlado pelo Google que patrocina estudantes para trabalhar em projetos open source. Os estudantes criam propostas de projetos para a organização com quem querem trabalhar, no meu caso foi a Ruby Central, e eles aprovam ou não o projeto.

Você também trabalhar com um mentor da organização. Michael Koziarski (Rails Core) originalmente sugeriu que eu fizesse o projeto e então “demos um jeito” para trabalharmos juntos.

Ao fim do programa, você envia seu código e se você completou o projeto então recebe USD 5.000. E eu acho que USD 500 vai para a organização open source.

**AkitaOnRails:** E você completou o projeto?

**Josh Peek:** Sim.

**AkitaOnRails:** Legal, e quanto tempo durou o programa?

**Josh Peek:** Acho que cerca de 3 meses.

**AkitaOnRails:** Ok, de volta à parte mais técnica. Tem uma coisa que me perturba um pouquinho. Claro que é um grande trabalho tornar o Rails thread-safe e isso é uma coisa que muitas pessoas já queriam. Mas por outro lado, o Ruby MRI não tem threads nativas, o que essencialmente significa que eles nunca são executados de forma verdadeiramente concorrente, correto? Talvez outros projetos como JRuby podem se beneficiar? Existe algum benefício para o MRI?

**Josh Peek:** Correto. JRuby é a única solução de verdade se você quiser concorrência real de threads. Ruby 1.9 suporta threads “reais”, entretanto a maior parte do código interno em C não é thread-safe então existe uma interrupção ao redor desses métodos, mas estou esperançoso que talvez o Ruby 2.0 seja totalmente thread-safe.

**AkitaOnRails:** Você provavelmente rodou testes para ambos o MRI e JRuby? Notou melhorias de performance/responsividade por causa do novo código thread-safe? Ou ele acaba adicionando um peso extra em vez disso?

**Josh Peek:** Nossos testes mostraram melhorias pequenas no MRI, entretanto a aplicação que estávamos testando era muito simples. Não tínhamos uma aplicação real que pudéssemos usar para benchmark já que nada era thread-safe na época. JRuby demonstrou algumas boas melhorias, novamente, não era uma aplicação de uso real.

**AkitaOnRails:** Você mirou apenas para as partes thread-safe ou também encontrou e consertou outros tipos de gargalo no framework? Você provavelmente andou pelo código todo várias e várias vezes e já conhece de cabeça para baixo, certo?

**Josh Peek:** Eu fiz vários trabalhos em pré-carga de caches no momento do boot. O jeito fácil de sair disso seria simplesmente colocar um mutex ao redor desses caches e pronto, entretanto eu tinha tempo sobrando então re-escrevi uma tonelada de código de ActionView.

Pré-carga significa que estamos construindo o cache no boot de forma que ele não precise ser modificado (ou sincronizado) enquanto estiver servindo requisições e isso deve beneficiar aplicação que não usam threads também.

E é uma grande vantagem para o Passenger, se você estiver usando a funcionalidade de copy-on-write, já que caches construídos no boot do Rails serão compartilhados entre múltiplos processos.

**AkitaOnRails:** Muito legal, o pessoal da [Phusion](http://www.modrails.com/) vai gostar de ouvir isso. E eu sei que algumas pessoas ficarão perdidas ouvindo sobre [mutexes](http://en.wikipedia.org/wiki/Mutual_exclusion), poderia explicar um pouco disso para o público?

**Josh Peek:** O maior problema de múltiplos threads rodando ao mesmo tempo é a memória compartilhada. Se duas threads tentarem acessar e modificar o mesmo objeto, isso pode causar grandes problemas. Um “mutex” é um tipo de trava que “sincroniza” suas threads de forma que apenas uma thread possa acessar um pedaço da memória de cada vez.

Entretanto, isso tem um impacto de performance porque outras threads precisam parar enquanto uma está acessando a memória compartilhada.

**AkitaOnRails:** Eu acho que esse é um trabalho incrível, especialmente para o JRuby. Você chegou a conversar com o Charles, Nick ou alguém do JRuby Core? Eu lembro de ter entrevistado o Charles e ele me disse que embora eles estejam avançando muito na otimização do runtime JRuby, a performance de aplicações Rails não estava melhorando tanto, então o próximo passo seria tentar descobrir como modificar o próprio Rails para se comportar melhor. Você ouviu alguma coisa a respeito?

**Josh Peek:** Sim, nós trabalhamos com o Charles em otimizações específicas de JRuby. Ele foi uma grande ajuda e respondeu todas as minhas questões relacionadas a como o JRuby sincroniza threads e quais operações são atômicas.

[Nick Sieger](http://blog.nicksieger.com/) realmente se voluntariou (antes do GSoC) para lidar com o [pool de conexões](http://ryandaigle.com/articles/2008/9/7/what-s-new-in-edge-rails-connection-pools) do ActiveRecord. Realmente um grande obrigado ao Nick, eu realmente não tenho experiência em lidar com esse problema e ele fez um grande trabalho com isso.

**AkitaOnRails:** Ok, embora o Ruby VM não tenha threads concorrentes verdadeiras, ele tem que lidar com recursos concorrentes, nesse caso conexões de banco de dados, então um pool foi necessário. Foi um problema grande de implementar? Foi alguma coisa que você teve que fazer do zero ou havia trabalho anterior com pools de conexão para Ruby?

**Josh Peek:** Bem, eu acho melhor perguntar isso ao Nick. Mas aqui vai o que entendo sobre isso: a implementação anterior de conexões do ActiveRecord suportava threadas, entretanto era fácil maximizar o número permitido de conexões ao banco se o servidor fosse sobrecarregado.

O pool de conexões basicamente recicla conexões antigas e previne o ActiveRecord de estabelecer muitas. Você pode configurar o máximo de conexões no seu database.yml com a opção “pool”. Ach que o padrão são 3.

**AkitaOnRails:** E como o papel de mentor funciona? Quero dizer, o [Koziarski](http://www.koziarski.com/) te guiou em pontos específicos que ele queria que você olhasse?

 ![](http://s3.amazonaws.com/akitaonrails/assets/2008/9/26/506281043_419fd4e72d.jpg)

**Josh Peek:** O Koz realmente me ajudou a me manter na linha. Ele fez muita auditoria de código, e apontou locais específicos que eu deveria olhar por problemas na grande base de códigos do Rails.

**AkitaOnRails:** Olhando de fora provavelmente deve parecer ‘fácil’ dizer _‘ok, nós adicionamos suporte thread-safe no Rails’_, mas isso não é como uma gem ou plugin externo, você realmente precisa lidar com as entranhas do framework. Como você pode ter certeza que realmente tocou em todas as partes do código que precisavam de medidas de segurança para concorrência?

**Josh Peek:** Isso é realmente a parte difícil de tornar o código ‘thread safe’: não existe maneira de saber com certeza. Você pode escrever um monte de testes unitários e dizer _‘olhe, eu posso provar que está tudo certo’_. Entretanto, os maiores problemas não estão visíveis. De agora em diante, decidimos classificar qualquer novo problema com thread safe como bugs normais.

**AkitaOnRails:** Você acha que isso já está pronto para lançamento? Ou ainda pretende refinar mais?

**Josh Peek:** Acho que já está pronto para as pessoas que estavam esperando por um Rails thread-safe. As pessoas precisam começar a auditar e testar suas próprias aplicações para problemas thread-safe e se alguma coisa aparecer, nós vamos corrigir no Core. É realmente difícil testar as coisas a menos que pessoas reais comecem a testar contra aplicações reais.

**AkitaOnRails:** Pelo menos dizer _“Rails não é thread-safe”_ já não é mais um argumento bom o bastante para não se usar Rails. Isso deve calar os críticos. Esse Rails 2.2 será interessante, derrubando algumas críticas. A outra é _“Rails não suporta internacionalização”_, graças a [Sven](http://www.artweb-design.de/2008/9/6/the-future-of-i18n-in-ruby-on-rails-railsconf-europe-2008). O que você gosta mais na próxima versão do Rails?

**Josh Peek:** Meu próximo pequeno projeto no Rails é mudar para usar [Rack](http://rack.rubyforge.org/). O Rails 2.2 incluirá um processador Rack que o deixa usar qualquer servidor Rack, entretanto ainda não estamos mudando totalmente para Rack. No 2.2 o Rack será opcional.

O ./script/server ainda rodará o antigo processador CGI. Espero ver CGI deprecado na próxima versão para que possamos ter o Rack somente lá pelo 3.0.

**AkitaOnRails:** Quais os benefícios de ir para Rack? Pode não ser muito óbvio para muitas pessoas sobre porque mudar código que já está funcionando (a parte CGI).

**Josh Peek:** Deve haver alguns benefícios de performance, entretanto isso não seria suficiente para convencer. Agora mesmo temos toneladas de hacks de CGI no Rails. Isso deve limpar as coisas um pouco.

O que eu realmente gosto é a interface padronizada para Rails. Isso significa uma API mais universal para escrever plugins relacionados a ActionController que funcionarão com qualquer framework compatível com Rack. Eu espero que isso significa mais plugins Rails que funcionarão com Merb e vice-versa.

**AkitaOnRails:** Tendo terminado seu projeto GSoC lhe deu as chaves para o repositório oficial do Rails, correto? Como o Rails Core se organiza? Cada pessoa é responsável por alguma parte em particular, ou todos olham um pouco de tudo?

**Josh Peek:** Parece que cada um tem suas pequenas responsabilidades dependendo no que estavam trabalhando. Já que eu reescrevi uma tonelada do ActionView, devo assumir qualquer problema ou tickets relacionados com isso. Não acho que qualquer um tenha uma área pré-determinada. As pessoas mudam seus interesses o que está bem.

**AkitaOnRails:** Mas agora você pode dar ‘git push’ em qualquer coisa no Edge? E aliás, você mencionou que mexeu bastante no ActionView, mas o que exatamente mudou?

**Josh Peek:** Sim, eu já tinha acesso de commit um pouco antes do projeto GSoC (pouco antes de mudarmos para git). O ActionView foi refatorado para suportar o esquema de pré-carga que falei antes. Então templates ERB são pré-compilados e colocados em cache no boot em vez de em tempo de execução.

**AkitaOnRails:** Então, em 3 anos você foi do zero para o Rails Core, realmente o “problema de thread-safety” e ainda conseguindo tempo para estudar e trabalhar em projetos como freelance. Como se sente, olhando em retrospectiva? Alguma vez pensou que fosse contribuir tanto?

**Josh Peek:** 4 anos atrás, eu realmente nunca me vi programando. Eu definitivamente nunca pensei que acabaria no Core Team do Rails.

**AkitaOnRails:** Depois de tanto que aprendeu, quais as áreas em computação que te interessam mais? Desenvolvimento web, ou outra área como compiladores, sistemas operacionais, etc? O que pretende fazer agora?

**Josh Peek:** Eu ainda adoro desenvolvimento web. Eu recentemente tentei programação de iPhone, mas ainda não sei como me sinto sobre isso.

Eu gostaria de tentar coisas de mais baixo nível. Eu ainda não tive a chance de usar a API C do Ruby e ouvi dizer que é legal. Ultimamente tenho feito muito trabalho em um projeto javascript que será anunciado em breve e será open source.

**AkitaOnRails:** Oh, e falando nisso, você também é usuário de Mac? :-) E eu acho que é isso! Alguma consideração sobre o que falamos?

**Josh Peek:** Sim, tenho usado Macs por cerca de 6 anos já. Não sou um desses que mudou depois de descobrir Ruby :-)

E acho que é isso … eu fui puxado para falar no RubyConf este ano, pela coisa do GSoC. Então vocês provavelmente vão ouvir sobre “thread safety” por lá. Provavelmente é a última vez que vou falar sobre Rails e threads de novo.

Obrigado pelas questões.

