---
title: 'Começando o Ano com um Ruby Drama: RubySpec vs MRI Core Team'
date: '2015-01-02T12:10:00-02:00'
slug: comecando-o-ano-com-um-ruby-drama-rubyspec-vs-mri-core-team
tags:
- rspec
- fud
draft: false
---

A comunidade internacional de Ruby vira e mexe surge com alguns "dramas". Toda comunidade tem seus "dramas", mas os Ruby Dramas particularmente chamam a atenção das demais comunidades então de vez em quando vale a pena explorar alguns deles para explicar porque eles acontecem e quais as ramificações.

No último dia de 2014, Brian Shirai soltou um post unilateral entitulado ["Matz's Ruby Developers Don't Use RubySpec and It's Hurting Ruby"](http://rubini.us/2014/12/31/matz-s-ruby-developers-don-t-use-rubyspec/), onde ele explica porque é ruim o Core Team do MRI não usar regularmente o projeto RubySpec, vale a pena dar uma lida.

Como contexto, vale explicar que [Brixen](https://twitter.com/brixen) é quem herdou o manto da implementação Rubinius e também do projeto RubySpec, que tenta ser uma suíte de testes que define o comportamento do que é a "linguagem Ruby" para que implementações alternativas como o próprio Rubinius ou JRuby ou outras possam se basear. Os projetos originaram com Evan Phoenix, atual membro do Ruby Central e organizador das RailsConf. Digamos que Evan é mais "politicamente correto", Brian é mais "agressivo".

O problema é que o Brian basicamente "joga a merda no ventilador e sai fora", que é o tipo de atitude mais infantil e menos efetivo possível. E vindo de um conhecido contribuidor open source como Brian, obviamente isso causou um shit-storm no Twitter e outras redes. Ele simplesmente "acusa" o Core Team do MRI de sabotar o RubySpec ao não usá-lo como ele gostaria. Um dos principais nomes que vieram para defender o Core Team foi [Charles Nutter](https://twitter.com/headius/with_replies), que é contribuidor tanto do JRuby quanto do próprio MRI, alguns dos comentários mais interessantes e que explicam o ponto de vista do Core Team, eu cito abaixo:

<blockquote>
@jamie_gaskins RubySpec was designed from the ground up. MRI's suite is decades old. What we need are people to help clean it up.
</blockquote>

<blockquote>
@josh_cheek And what of redoing over a decade of work in MRI's suite? It's there, it works, we use it to test JRuby. Don't buy the FUD.
</blockquote>

<blockquote>
@jamie_gaskins We use it as our primary compatibilty suite for JRuby. We also run RubySpec, but it's far less complete.
</blockquote>

<blockquote>
@josh_cheek I don't think anyone would disagree that MRI's suite needs improvement, but throwing it out is absurd.
</blockquote>

<blockquote>
@jamie_gaskins I also don't find MRI's tests hard to read. When I find ugly ones in the future, I will be fixing them. Help me :-)
</blockquote>

<blockquote>
Folks don't seem to realize JRuby runs MRI's test suite as our primary compatibility suite. It's not pretty, but it's OSS...help us fix it.
</blockquote>

<blockquote>
@jerrydantonio Please don't spread this kind of FUD. I know most of ruby-core personally and they've been very supportive of JRuby.
</blockquote>

<blockquote>
@jerrydantonio If they don't use RubySpec, it's because RubySpec did not meet their needs -- as stated in the article.
</blockquote>

<blockquote>
@jerrydantonio You are going based on what one person says without understanding the complexities involved.
</blockquote>

<blockquote>
@jamie_gaskins You can submit PRs to MRI's github/ruby/ruby mirror (which may turn into the main repo this year).
</blockquote>

<blockquote>
@jamie_gaskins If you start looking into it, copy me on your PRs. I'm a committer, and I can help get them in.
</blockquote>

<blockquote>
@jamie_gaskins Not at all, and ruby-core are all on board with switching to git now too. Like I said...that post is a massive dose of FUD.
</blockquote>

<blockquote>
Another reminder: I'm a member of the MRI core team and a committer. Got a problem? I'm listening. Let's collaborate, friends.
</blockquote>

<blockquote>
@samsaffron It doesn't matter if their suite serves their and our needs. It's aesthetics at that point. Aesthetics can be fixed.
</blockquote>

<blockquote>
@iainbeeston It just a political move. It's still alive and still OSS...if it's valuable to use it on MRI, we can still use it on MRI.
</blockquote>

<blockquote>
@zedshaw @mentalguy @raganwald The segfault was not reported. And yes, they fix bug reports. ruby-core is still almost all volunteer time.
</blockquote>

<blockquote>
@johnbender Don't take one article's assertions as truth. There's a lot of misinformation there.
</blockquote>

<blockquote>
@jc00ke @_zzak I'd like to know why RubySpec wins and MRI is at fault. Does Rubinius run MRI's suite, like JRuby?
</blockquote>

<blockquote>
@fugueish One person's story. I've been implementing Ruby longer and I have seen steady improvement. It's a community effort.
</blockquote>

<blockquote>
@josh_cheek And please don't spread FUD like this. There are real people working really hard on MRI. Help them instead.
</blockquote>

<blockquote>
@raganwald @codefolio @saturnflyer Indeed. But don't start saying things like "MRI devs don't write tests" because they usually do (now).
</blockquote>

<blockquote>
@chromatic_x The full run of MRI's suite on JRuby includes 5941 tests with 1091418 assertions (we exclude parts). They're indispensable.
</blockquote>

<blockquote>
@iainbeeston Either that, or it inspires ruby-core and us to improve MRI's suite. Positive things can come from a negative post. :-)
</blockquote>

<blockquote>
@chromatic_x In any case, MRI is the reference impl, so expecting them to drop their decades-old suite for someone else's is rather bold.
</blockquote>

<blockquote>
@headius Personally, I think that RubySpec is useful and valuable, but throwing MRI under the bus for not using a tool is pretty petty.
</blockquote>

<blockquote>
@r343l @sunnyrjuneja No, it doesn't. I don't agree with technical articles that don't take comments. Might as well be a press release.
</blockquote>

<blockquote>
Lesson for today: here's what you do when you find a bug in a project, rather than just blogging about it: https://bugs.ruby-lang.org/issues/10685 
</blockquote>

Shyouhei Urabe, um dos principais voluntários japoneses do Core Team disse [a coisa mais óbvia](https://twitter.com/shyouhei/status/550557396376879104) logo que o post do Brian saiu:

<blockquote>
Release of #ruby happens Dec. 25th EVERY YEAR.  If rubyspec found a SEGV, why didn't they report that and blame core devs instead?
</blockquote>

Logo em seguida Nate Berkopec fez um apanhado geral e [uma explicação/especulação das razões](https://gist.github.com/nateberkopec) pelas quais o artigo de Brian Shirai está errado no que ele quer atingir.

Em resumo, existe uma grande frustração no time do Rubinius em geral. Ao contrário do JRuby que tem um nicho de usuários e projetos em produção onde ele faz diferença, o Rubinius em si nunca alcançou nenhum uso significativo. Em [Outubro de 2013](http://rubini.us/2013/10/15/introducing-rubinius-x/), ele havia anunciado que o Rubinius começaria a experimentar mais e quebrar compatibilidade com o MRI o que, pra mim pelo menos, soa mais como um tiro no pé. Mas eles acharam que, por méritos técnicos, o Rubinius poderia ser o melhor substituto para o MRI. O controle do RubySpec leva nessa direção e por isso a frustração do Core Team nunca adotá-lo "oficialmente".

Hoje (2/1/2015), o próprio Evan Phoenix resolveu endereçar o assunto pessoalmente no Twitter com o Matz, e eis a transcrição:

<blockquote>
@evanphx 
1. I wonder if, all those years ago, I misunderstood Matz. Maybe "I like other ruby implementations" was really "I don't mind they exist"
</blockquote>

<blockquote>
@evanphx 
2. I thought it was "I want to help them" but Matz really didn't mean that. He just mean "good luck friends!"
</blockquote>

<blockquote>
@yukihiro_matz 
@evanphx Sorry for confusion & disappointment. I still don't know what kind of help you wanted. You do want to control your project as I do.
</blockquote>

<blockquote>
@evanphx 
@yukihiro_matz I should have asked: Could the CRuby team help track new features so other impls could know what they are missing.
</blockquote>

<blockquote>
@yukihiro_matz
@evanphx the MRI team maintains the forked version of RubySpec https://github.com/nurse/rubyspec  I think it can be a good start.
</blockquote>

Existe muito mérito nos esforços que as pessoas contribuíram aos projetos Rubinius e RubySpec ao longo dos anos, porém eles falharam ao tentar forçar sua visão do que deveria ser "o certo" em vez de colaborar com o projeto que já existia muito antes deles chegarem que é o Ruby MRI. É como se você fizesse um kernel alternativo ao Linux e começasse a dizer nas listas por aí que o Linus Torvalds deveria seguir essa alternativa porque é o "jeito mais certo". Sabe qual seria a resposta do Linus? "Fuck You!". É que o Matz é **bem** mais educado do que isso, mas seria a resposta mais adequada a esse tipo de atitude.

Qual seria a alternativa? Charles Nutter já demonstrou: ele é ao mesmo tempo líder da implementação alternativa JRuby e também contribui diretamente no Ruby MRI. Ele roda as suítes do MRI e do RubySpec, em paralelo, no projeto JRuby. Não há atrito entre JRuby e MRI. Mas há atrito entre Rubinius e MRI. O problema não é técnico, não é sequer político como muitos declararam, é um problema de caráter e atitude. O problema é que o estilo do Core do Rubinius sempre foi "somos os melhores, eventualmente todo mundo vai notar isso". Essa atitude é altamente destrutiva, frustrante e acaba com declarações suicidas como a do Brian Shirai. 

[Uma coisa que eu sempre digo](http://www.akitaonrails.com/2012/08/15/off-topic-o-mito-do-legado): fazer um projeto green field (do zero) é muito fácil, qualquer criança faz isso. Agora, pegar um projeto brown field (velho, cheio de débitos técnicos), é bem mais complicado, bem menos recompensador a curto prazo e por isso poucos (só os melhores) conseguem a disciplina para tentar transformar um brown field num green field. O Rubinius e RubySpec são green fields que tentaram enfiar goela abaixo do Core Team. Não é assim que se prova um ponto de vista. Releia os comentários do Nutter acima, é o que ele tenta explicar.

E é uma pena, pois tecnicamente Brian e o Core Team do Rubinius são muito bons e seria bom ver esse talento dentro do MRI. Porém, entre ter alguém tecnicamente bom mas de caráter duvidoso, é melhor não ter. Essa sempre é a melhor alternativa.

Em resumo: nada muda do lado do Ruby MRI, não é nenhuma crise ou algo assim. O MRI deve continuar como sempre: com Matz como seu único ditador benevolente e talvez, com alguma boa vontade, eles permitam o projeto RubySpec ser incorporado dentro do MRI sob a tutela do Core Team do Japão, como deve ser.
