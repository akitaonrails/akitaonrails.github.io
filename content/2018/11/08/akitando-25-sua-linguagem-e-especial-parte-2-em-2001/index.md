---
title: "[Akitando] #25 - Sua Linguagem É Especial? Parte 2 em 2001"
date: '2018-11-08T17:00:00-02:00'
slug: akitando-25-sua-linguagem-e-especial-parte-2-em-2001
tags:
- asp
- nosql
- xml
- xsl
- psn
- ajax
- dhtml
- akitando
draft: false
---

Disclaimer: esta série de posts são transcripts diretos dos scripts usados em cada video do canal [Akitando](https://www.youtube.com/channel/UCib793mnUOhWymCh2VJKplQ). O texto tem erros de português mas é porque estou apenas publicando exatamente como foi usado pra gravar o video, perdoem os errinhos.


<iframe width="560" height="315" src="https://www.youtube.com/embed/O4CWVQLbi48" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


### Descrição no YouTube

Recapitulando, na série "Sua Linguagem NÃO é especial" expliquei porque tudo que você acha que é diferente e moderno na sua linguagem já existia décadas atrás.

No episódio anterioe eu comecei  a explorar um pouco o outro lado: ninguém disse que você não pode gostar da sua linguagem e, mais importante, dominá-la até o fim.

Veja o que eu fazia quando estava no começo da minha carreira e compare com o que você faz hoje em dia.

Em particular, veja como exploração sem limites pode levar você a antecipar tendências, sem querer.

Quer ver como fazíamos "Ajax" e "NoSQL" já em 2001?  :-D

Links de referência:

* ASP XML Framework (https://github.com/akitaonrails/ASP-Classic-XML-NoSQL)
* Nested Set (https://en.wikipedia.org/wiki/Nested_set_model)

## Script

No episódio passado eu mostrei um mini-framework que eu fiz com ASP clássico tentando imitar o que, na época, era o moderno ASP.NET Web Forms. Estamos falando de 2001.

Mas alguns meses antes desse framework eu fiz um código que - olhando hoje - é ao mesmo tempo assustador - porque o código é grande e bem feio - mas também surpreendente.

Lembram quando eu falei no episódio de Blockchain rapidamente sobre o Hype do NoSQL em 2010? E se eu te disser que eu já usava noSQL em 2001?

(...)


Estamos em 2001, como eu expliquei no episódio anterior eu estava desenvolvendo e dando manutenção em diversos sites esportivos de propriedade da PSN como os sites do Corinthians e Cruzeiro aqui no Brasil.

Além disso havia todo um Gerenciador de Conteúdo usado pelos jornalistas pra postar artigos e todo workflow de aprovação e publicação. Tinha área pra subir fotos, ferramentas pra montar pesquisas online tipo polls e muito mais.

Mas tinha 2 problemas que eu queria resolver. Um deles é que antigamente, tanto em ASP ou PHP a gente fazia o HTML misturado com o código. Se você já abriu o código fonte de um Wordpress, bom, era pior que isso.

Olha um exemplo disso, (aponta pro lado) HTML, dados, styles (já tinha CSS mas ele não era tão poderoso como hoje e pouca gente sabia usar direito ainda) e código tudo misturado. Era uma zona.

Uma coisa que tava começando a se popularizar na época era XML. Mas nem todo mundo entendia isso direito ainda. Muito menos no mundo ASP. Assim como hoje em dia pra vocês é tudo JSON, pra mim naquela época o quente era tudo XML. 
Tecnologia funciona assim, você não sabe os limites, vai testando.

Então o primeiro problema que eu queria resolver era separar os dados do HTML. Eu não lembro se já existia o framework de Java Apache Coccoon, mas pra quem não sabe ele tinha exatamente esse conceito. Pra quem não sabe o que é XSL é o Extensible Style Language. Hoje XSL é uma família, por exemplo você talvez já tenha ouvido falar de XPATH? Faz parte. 

Na época só existia o XSLT que é um padrão de transformação pra modificar um XML em outro XML. Então eu pensei, ora, um exemplo de XML é HTML ou mais especificamente o XHTML que a gente usava na época. Um HTML mais restrito e que é um XML válido. Pensei, porque não separar os dados puros em um XML estruturado e usar transformações XSLT pra converter em HTML?

E foi o que eu fiz. Já que todo site de evento esportivo era basicamente o mesmo template mas com dados diferentes, eu reduzi os dados de cada evento em XML e usava essas transformações pra gerar o HTML final a partir de um template XSLT.

Vou falar que o código que eu fiz ficou tão complicado que só de bater o olho hoje rapidamente nem eu consigo entender tudo que eu fiz. (risos) Quem me conhece sabe que eu costumo dizer que coisas como testes unitários não é uma coisa que você faz pros outros, é pra você mesmo de amanhã. E eu digo essas coisas por experiência, se eu pudesse voltar 17 anos no passado eu daria um tapa na orelha em mim mesmo. 
Mas dá um desconto, em 2001, o assunto testes automatizados era meio novo até em Java. Só pra vocês terem uma idéia o site do JUnit só foi lançado 1 ano antes, em 2000. 

De qualquer maneira eu meio que consegui fazer isso e pelo menos alguns eventos como Campeonato Paulista, Copa Libertadores, Copa Merconorte, Copa Mercosul, eu acho que consegui implementar nesse framework.

Novamente, eu fiz componentes VBScript encapsulados em Windows Script Components ou WSC. Eu criei componentes com nomes meio bizarros como TXMLSynchro, 
TXMLFront, TXMLEvents, 
TXMLLanguage e TXMLTranslation.

Ou seja, como eram portais de conteúdo internacionais pra América Latina e Estados Unidos, eu também tinha uma mini-engine de internacionalização. E suportando 2 bancos de dados, SQL Server e Oracle.

E porque tudo começa com T? Porque eu era desenvolvedor de Delphi alguns anos antes. E em Delphi todos os componentes começavam com a letra T e eu acabei pegando esse hábito de começar tudo com T. Em Delphi existia essa convenção porque tudo que definia um Tipo começava com T.

O componente principal TXMLSynchro usava uma convenção de pastas e ele ia percorrendo as pastas em busca dos XML e os templates XSL pra ir gerando os HTML. Esse conceito soa familiar? Se você já usou Jekyll por exemplo, é parecido, só que em vez de ser Markdown, era XML. Então eu tinha um gerador de site em XML em 2001.

Na verdade, era um passo além. Os jornalistas podiam editar o conteúdo via um Admin que gravava o XML no banco de dados. Daí eu pegava esse XML e aí convertia pra HTML via o XSL, por isso era TXML Synchro o nome do componente.

Ao mesmo tempo esse pacote era um gerador de eventos, daí o outro componente TXML Event, daí cada nova Copa ou evento era mais ou menos simples de gerar tudo.

Agora vem o principal. Eu gostei desse conceito de gravar XML natabela. E fui um passo além. Tinha um outro problema em todos os eventos esportivos, todo campeonato era visualizado via uma chave. Sabe? Basicamente uma árvore de nós convergindo na semi-final, final até o campeão.

Mas todo evento tem chaves diferentes. O problema: como eu represento isso num sistema multi-eventos? 

A primeira coisa que você provavelmente teria vontade de fazer é criar uma tabela Evento, uma tabela Jogo e uma tabela Time ou algo assim e ir criando uma linha no banco pra cada nó da árvore. Isso é um design terrível. É o pattern que chamamos de Parent-Child. Terrível porque não tem como trazer todos os nós da árvore num único select.

Árvore é uma das coisas ruins de se mapear numa tabela SQL. O jeito correto é usar um Nested Set, vou deixar o link abaixo se você nunca ouviu falar em Nested Sets. Mas em 2001 eu também não conhecia isso, só conhecia o Parent-Child que é o que eu falei agora que é ruim, e pelo menos eu sabia disso. 

Aqui foi um insight. Gerenciar nós de uma árvore, em SQL não é trivial. Gerenciar nós num XML era fácil, é um DOM, como o DOM que você manipula hoje via Javascript num HTML, é uma árvore. CreateElement, Sibling, Child, etc. Mas não existe banco de dados XML, não em 2001. 

Mas, bancos SQL tem campo BLOB. E se eu simplesmente gravar o XML num campo blob? Daí com um único select eu puxo o XML inteiro que representa a árvore toda e posso passar num DOM Document pra parsear e criar os objetos todos. 

E se eu for além, e se eu usar XSL em cima do XML que veio do banco pra gerar o HTML final que o jornalista ia ver no gerenciador de conteúdo?

E se eu for além, e se eu usar esse troço novo que o Internet Explorer 4 tinha inventado uns 3 anos antes chamado Dynamic HTML que me permite modificar o HTML dinamicamente na página via Javascript? Cês tão vendo? Eu to falando de tecnologia de ponta aqui. 

E se eu somar isso a esse componente novo chamado MSXML que eu podia instalar tanto no servidor mas tinha componente pro browser. Isso permite, via Javascript ou VBScript, fazer uma requisição HTTP pra aplicação ASP me devolver o XML e, no client-side, eu poderia via javascript parsear com MSXML e ter o DOM na memória?

Agora se eu somar tudo isso. Eu posso fazer o jornalista clicar em qualquer nó da árvore, editar o nome do time, pontuação e tudo mais direto na representação do DOM do XML na memória do browser. Daí via Javascript gerar o XML que representa essa árvore e dar POST pro servidor, que daí ia gravar direto na tabela do banco.

O que eu tinha acabado de fazer?

Asynchronous Javascript and XML ou AJAX, nome que seria cunhado só em 2005, 4 anos depois. Eu não fui o primeiro a fazer isso, muito antes do Google fazer o Gmail que popularizou a técnica, a Microsoft já tinha o Outlook Web App em 2000 que era basicamente um Outlook versão Web que usava o componente XMLHTTP, que é o precursor do XMLHttpRequest. Ninguém usa esse objeto direto, hoje em dia vocês usam o que? Axios? Mas por baixo é o mesmo XMLHttpRequest. Esse componente nasceu pela primeira vez em 1997 ou 98 com o Internet Explorer 4, mas acho que só começou a ser usado de verdade com o IE 5 em 1999.

E isso de serializar e deserializar árvores de objetos XML num campo blob numa tabela é um tipo rudimentar de NoSQL. É o que hoje a gente faz com Postgres e o tipo de campo JSONB. É basicamente a mesma coisa: em vez de fazer um monte de tabela pra cada campeonato, eu reduzi tudo numa tabela só sem schema, schemaless.

O termo NoSQL foi cunhado primeiro em 1998 mas só se popularizou quando a Last.fm reintroduziu o termo em 2009, 8 anos depois do que eu fiz.

Imaginem minha surpresa quando em 2005 eu vi todo mundo ficando doido com o conceito de Ajax e em 2009 todo mundo ficando doido com o conceito de NoSQL. Eu juro que coçava a cabeça pensando, é legal, mas isso é velho não?

Lembrando que em 2001 não tinha ainda Hacker News, nem Reddit, nem Quora, nem Stackoveflow. Esses conceitos nasceram organicamente combinando as peças que eu aprendi fora da caixa e fazendo o que todo programador novo faz: over engineering.

Engraçado que eu tinha noção que a solução que eu fiz era bem overkill e over engineering mesmo pra época, mas assim como muitos de vocês, é aquelas coisas que você faz mais porque é divertido e menos porque é um bom custo-benefício. 

O objetivo dessa história é ilustrar como sem querer eu cheguei nas mesmas conclusões que outras pessoas chegaram de outra forma. Acho que muitas outras pessoas usavam da mesma maneira, mas não era tão famoso porque não tinha blogs, não tinha meetups, não tinha screencasts nem nada disso em 2001. Se você não prestar tanta atenção na propaganda, ou a forma como os outros dizem que você deve usar essa ou aquela ferramenta e encarar tudo como peça de lego eventualmente você mesmo vai chegar nas mesmas conclusões que os grandes nomes chegam.

O que eu falo mais é o seguinte: se você está seguindo o que os outros estão dizendo, você já está atrasado. Eu não sigo muito os outros, eu penso: pra que esse troço serve ou não serve. Em vez de seguir o que os outros dizem “ah, isso só dá pra fazer se for em Java” ou “ah, isso o melhor é se for em Javascript”. Eu penso. Quem disse? Deixa eu testar. 99.9% das vezes não funciona, mas essa é justamente a graça do negócio. Programação não é pra ser um negócio que todo código que vc digita precisa necessariamente ser útil pra alguma coisa. É como dizer que toda vez que você for chutar pro gol precisa fazer gol. Senão nem vale a pena tentar chutar. Se futebol fosse só isso, não teria graça, teria? E fazendo assim, um vez por década você tem um momento eureka!

E você, já teve seu momento eureka em algum momento? Compartilhe com a gente sua história nos comentários abaixo. Se curtiram o vídeo mandem um joinha, assinem o canal e cliquem no sininho! A gente se vê, até mais!



