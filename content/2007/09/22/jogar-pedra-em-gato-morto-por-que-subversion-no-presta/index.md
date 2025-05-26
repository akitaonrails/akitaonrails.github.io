---
title: 'Jogar Pedra em Gato Morto: por que Subversion não presta'
date: '2007-09-22T01:03:00-03:00'
slug: jogar-pedra-em-gato-morto-por-que-subversion-no-presta
tags:
- subversion
- git
draft: false
---

Adiantando o final do artigo para os impacientes: está procurando um sistema de versionamento (VCS)? Tente [**GIT**](http://git.or.cz/).

Hoje eu estava ouvindo um podcast muito interessante no FLOSS Weekly com [Junio Hamano](http://www.twit.tv/floss19), mantenedor do sistema de versionamento [GIT](http://en.wikipedia.org/wiki/Git_(software)), que é um sistema **DISTRIBUÍDO** de controle de código fonte.

Nunca ouvi falar.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/9/22/stress_one.png)


[Darcs](http://darcs.net/), [Mercurial](http://www.selenic.com/mercurial/ "hg"), [Bazaar-NG](http://bazaar-vcs.org/ "bzr"), [Perforce](http://www.perforce.com/) por alguma razão me dão uma sensação de serem mais famosos – Google usa Perforce – ou pelo menos aparecem mais nas notícias. Não sei.

Uso Subversion por razões históricas. Na época que comecei a usar, as outras opções mais famosas eram CVS ou ClearCase – eu sei, haviam outros, mas eu era ignorante, o que posso dizer. E ser mais estável que CVS, parecendo CVS e sem ser CVS, para mim fechou a venda. Enfim, não gosto de nenhum dos dois. Falar que CVS é ruim é um eufemismo hiperbólico (isso existe?). Ele nasceu torto, vai morrer torto, daí a primeira metade do título do artigo.

ClearCase, é uma ferramenta comercial e não é barata (mudou?). Se fosse barata até pensaria em começar a considerar mas também não gosto da _pose_ dos “especialistas da Rational”. Qual a vantagem de ser um especialista de commits? O dia que eu precisar de certificação pra fazer commits … o mundo acabou! [BitKeeper](http://www.bitkeeper.com/) também é comercial, na época em que Linus resolveu usar BitKeeper houve muita controvérsia mas depois todo mundo esqueceu. Um fator que pode não parecer muito, é o formato do repositório, leiam este [artigo](http://64.233.169.104/search?q=cache:b6n7lvK2lGEJ:keithp.com/blog/Repository_Formats_Matter.html+repository+formats+matter&hl=en&ct=clnk&cd=1&client=safari)

Darcs, Bazaar e Mercurial são excelentes projetos. Não me agrada muito no Darcs o fato dele ser feito em Haskell. Nada contra Haskell, eu mesmo acho que é uma excelente linguagem, mas como meu dia-a-dia não envolve Haskell – e o de muita gente – se eu precisar de suporte, alguma coisa extra, vai ser mais difícil conseguir.

Mercurial e, acho, que Bazaar são feitos em Python. Mesmo assim parece que suas performances são muito boas. Bazaar parece que segue a linha do antigo Arch – acho que um dos primeiros a sair da linha centralizada do CVS. Por alguma razão nunca me senti muito atraído por elas. Pelo menos todos nasceram distribuídos. Conclusão: se quiser outro controlador de versão, escolha um distribuído.

Falar bem de GIT não significa falar mal desses outros. Mas podemos falar muito mal de CVS, então falaremos: gerenciar branches é uma piada de mal gosto. Arquivos corrompidos nem se fala. Tags? Pff. Procurem no Google “cvs sucks” e acharão uma lista de motivos de porque CVS é ruim.

Subversion? Como disse, uso por motivos históricos. O slogan é _“um CVS bem feito”_. De fato, ele corrompe muito menos, branches são mais fáceis. No geral ele é melhor. Toneladas de ferramentas, livros, hostings, bibliotecas, etc. Gostando ou não se tornou o “padrão”. Quando implementei a versão beta num projeto, acho que em 2003, minha equipe quase cortou minha cabeça. Mas uso desde então em todos os meus projetos, com variados níveis de satisfação. Mas não vamos cuspir no prato: Subversion serviu seu papel muito bem, apesar de não ser perfeito. Mas acho que passou da hora de mudar.

Interessado no GIT, acabei achando este vídeo com o próprio Linus Torvalds, criador do GIT, dando uma palestra no Google:

<object width="425" height="350"><param name="movie" value="http://www.youtube.com/v/4XpnKHJAok8">
<param name="wmode" value="transparent">
<embed src="http://www.youtube.com/v/4XpnKHJAok8" type="application/x-shockwave-flash" wmode="transparent" width="425" height="350"></embed></object>

É o que eu digo: todo bom projeto, open source ou não, precisa de caras como Linus. Ele vai direto ao ponto: _“os criadores do Subversion são idiotas!”_ E repete isso diversas vezes em mais de uma hora de palestra. _“É o projeto mais sem sentido que eu já vi”_. Hilário! Fugindo um pouco do ponto acho que todo bom projeto precisa de pessoas carismáticas na liderança. Não importa o que eles falam, são eles que vendem o produto. O Linus começou o GIT, é LÓGICO que ele acha os outros ruins – e não fará nenhuma tentativa de ser _policamente correto_ ou conciliador, o que eu acho ótimo. E mudando de assunto de novo: é por isso que eu gosto tanto da série [House M.D.](http://en.wikipedia.org/wiki/House_(TV_series)). Recomendo.

Voltando ao assunto, **ele tem razão**! Oras, Subversion é uma versão _um pouco_ melhorada do CVS. Ele faz branches muito mais rápido: mas quem se importa? Fazer branches só é importante se o Merge depois for excepcionalmente melhor do que no CVS. E convenhamos: gerenciar merges em Subversion é outra piada de mal gosto (tenho um amigo que já bateu o carro de nervoso por causa disso hehe). Mesmo assim, eis a segunda metade do título do artigo.

Aham. Não quer dizer que não pode ser feito: claro que pode, mas não chega nem perto de receber o título de “trivial”. Ainda não usei GIT, mas é o que Linus argumenta: nenhuma outra alternativa que existe supera GIT. Eu argumentaria que talvez Darcs e Mercurial sejam bons competidores, mas o discurso de Linus foi muito persuasivo.

Os problemas mais comuns? Eu gosto de fazer commits o tempo todo. Mudei uma única função em um único arquivo? Commit. Mudei uma única linha de comentário? Commit. Isso funciona bem se eu trabalho sozinho. Coloque mais um desenvolvedor no jogo e a coisa começa a ficar complicada muito fácil: eu já não posso fazer mais isso com frequência porque eu posso interromper o trabalho do outro.

Ok, vamos fazer branches. Criar o branch é trivial. Switch. Posso fazer commits à vontade agora. Chegou a hora do merge. Vamos ver, qual foi mesmo a revisão em que o branch foi criado? Log. Finalmente, merge e … conflicts. Vamos gastar algum tempo fazendo conflict resolutions (nem sei porque algumas coisas aparecem como conflito). Agora faça isso por dois ou três dias seguidos fazendo merges mais de uma vez por dia. A coisa fica tediosa muito rápido. Esse é o problema que sistemas distribuídos prometem eliminar. Veremos se GIT ajuda.

Então encontrei um sub-projeto chamado [git-svn](http://git.or.cz/course/svn.html) ([estes](http://utsl.gen.nz/talks/git-svn/intro.html) [outros](http://tsunanet.blogspot.com/2007/07/learning-git-svn-in-5min.html) também são interessantes), cuja intenção é usar GIT em ambientes onde Subversion seja mandatório: seja numa empresa, seja em projetos como no Google Code ou outro hosting. Você mantém um repositório centralizado em Subversion mas faz todo seu trabalho em um repositório descentralizado do GIT e no final envia os changesets de volta.

Inicialmente (algumas horas atrás, na verdade) pensei nisso porque migrar 100% para GIT significaria sacrificar algumas ferramentas. Capistrano, por exemplo, depende de Subversion. Mas olhando um pouco melhor parece que [suportar GIT no Capistrano](http://scie.nti.st/2007/9/4/capistrano-2-0-with-git-shared-repository) é próximo de trivial também.

Ao que parece temos um vencedor. Ainda é um trabalho em andamento – já que a moda hoje em dia é estar sempre em Beta :-) No Windows, esqueçam: precisa de Cygwin e mesmo assim tem alguns problemas. Ferramentas gráficas? Acho que só em Linux e mesmo assim são poucas – e meio feinhas, vamos concordar. Mas, como Windows não me interessa e o próprio Subversion eu só uso via shell, então tanto faz. Como diria DHH: _“pra quê fazer parte do mainstream?”_

Estes artigos tem algumas comparações interessantes: [Cutting Edge Revision Control](http://bryan-murdock.blogspot.com/2007/03/cutting-edge-revision-control.html), [What’s Happening with Version Control Systems](http://jaredrobinson.com/blog/?p=62). Ainda preciso ler este [FAQ](http://git.or.cz/gitwiki/GitFaq?highlight=%28merge%29#head-f7dc61b87eab4db58fe90ce48cc1d47fd50e6bea) do GIT. Aliás, o [GitWiki](http://git.or.cz/gitwiki/FrontPage) tem muitos artigos e links muito interessantes.

Talvez o melhor artigo para todo aspirante a deserdor de Subversion, que queira entender a arquitetura geral do GIT e porque ele é melhor que os outros, seja este [An introduction to git-svn for Subversion/SVK users and deserters](http://utsl.gen.nz/talks/git-svn/intro.html). Assim que tiver mais tempo vou testar GIT nos casos mais comuns do dia-a-dia de trabalho.

E assistam ao vídeo do Linus é **MUITO HILÁRIO**!! Kudos a Linus pela apresentação, todo palestrante deveria ter o mesmo senso de humor. Aliás: ponto negativo a todo palestrante que lê seus próprios slides (eu incluso, porque acabo caindo nessa armadilha de vez em quanto). Não preciso do palestrante se for só pra ler os slides: eu mesmo posso baixar e ler. Abaixo os bullet points!!

