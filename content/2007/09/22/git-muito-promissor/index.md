---
title: 'GIT: Muito Promissor'
date: '2007-09-22T05:44:00-03:00'
slug: git-muito-promissor
tags:
- git
draft: false
---

No [artigo anterior](http://www.akitaonrails.com/2007/9/22/jogar-pedra-em-gato-morto-por-que-subversion-no-presta) falei um pouco sobre [**GIT**](http://git.or.cz/) e ele parece mesmo promissor. Meu objetivo é não fazer uma migração big-bang. Não me interessa neste momento ter todo o trabalho de retirar meu Subversion do ar, instalar um servidor GIT, etc. Meu objetivo é ter um repositório local que seja: rápido, estável, confiável, que faça o arroz-com-feijão com competência. Só o tempo dirá. Mas os primeiros testes foram muito satisfatórios!

Instalar o GIT varia. Em Windows: não faço idéia. Em Linux: Google – ao que parece existem tarballs, pacotes para Yum, pacotes para Apt-get. Deve ser bem simples, façam sua lição de casa. Para Mac: MacPorts. Foi um pouco estranho, porque o **git-svn** parece que usa Perl5, e meu SVK que já estava instalado também. Acabei desinstalando o SVK e suas dependências e instalando novamente – deve ser o sono, já é bem tarde. Resumindo, acredito que a receita (para começar em um MacPorts limpo), seja algo assim:

```bash
sudo port install git-core +doc +svn
```

<p>Considerando que todos conseguiram instalar, agora deve haver, junto com o bom e velho script svn, os scripts <strong>git</strong> e <strong>git-svn</strong>. O que eu quero fazer: usar o git para gerenciar um repositório local – de tal forma que eu possa trabalhar (fazer commits, branches, merges) no meu micro sem depender de uma conexão ao servidor e, ao final do dia, poder “empurrar” todos os changesets (não apenas a última modificação, mas todo o histórico do dia) de volta ao servidor Subversion. Este <a href="https://wiki.bnl.gov/dayabay/index.php?title=Synchronizing_Repositories#GIT_and_SVN">link</a> foi muito útil.</p>
<p>Eu fiz um micro teste (micro mesmo, ultra-simples) usando o subversion de um projeto no <span class="caps">SVN</span> do Google Code.</p>

```bash
mkdir [diretorio_local_do_projeto]
cd [diretorio_local_do_projeto]
git-svn init -username [seu_username] [url_do_seu_svn]/trunk
```

<br>
Isso inicia o repositório local do git e associa ao <span class="caps">SVN</span> remoto. A partir daqui existem várias opções, leiam <a href="http://utsl.gen.nz/talks/git-svn/intro.html#howto-fetch">neste artigo</a> para entender as alternativas. Dentre as principais está fazer uma cópia <strong>completa</strong> do repositório – o que significa <strong>todas</strong> as revisões -, ou fazer um download apenas do <span class="caps">HEAD</span> do seu trunk. Se o projeto for pequeno, tanto faz. Se o histórico for importante, será necessário replicar tudo, ou replicar a partir de uma determinada revisão.<br>
<br>
Um aviso: puxar muitas revisões (sei lá, 500, 1000, 10 mil?) pode demorar <strong><span class="caps">MUITAS</span></strong> horas. Mesmo meu projetinho, com menos de 100 revisões, sob uma conexão de 8Mbit levou alguns minutos. Felizmente é possível pegar a partir de uma revisão até o <span class="caps">HEAD</span>, assim:<br>
<br>

```bash
git-svn fetch
```

<br>
Onde “<span class="caps">XXX</span>” é o número da revisào a partir da qual você quer pegar. Se quiser apenas o <span class="caps">HEAD</span>, pegue apenas a última. Não sabe qual o número? Oras “svn log —limit XX” para puxar o log das últimas XX revisões do seu <span class="caps">SVN</span>.<br>
<br>
Uma recomendação do artigo é criar um novo branch – questões cosméticas? Aliás, gerenciar branches – que é algo que fazemos com muita cerimônia no <span class="caps">SVN</span> – deve ser rotina no <span class="caps">GIT</span>: faça quantas quiser, quando quiser. Faça um por arquivo se for maluco. Diz a propaganda que o <span class="caps">GIT</span> aguenta. Na prática existem muitos recursos do <span class="caps">SVN</span> que usamos raramente porque sabemos que pode trazer dores-de-cabeça. E se pensarmos melhor, oras, se precisamos planejar tanto para usar um recurso é porque ele é muito mal feito. Todo bom recurso deveria ser à prova de noobies. Veremos nos próximos dias se o <span class="caps">GIT</span> sobrevive à propaganda (espero que sim). Enfim, criar branches:<br>
<br>

```bash
git checkout -track -b [qualquer_nome] git-svn
```

<br>
“git-svn” é o nome do branch que o script “git-svn” criou automaticamente. Fora ele, por default, todo repositório tem pelo menos um branch, chamado “master”. Ao criar um branch, ele automaticamente se torna o novo default. Para ver todos os branches disponíveis use:<br>
<br>

```bash
git branch -a
  ```

<br>
Já podemos brincar. Posso alterar meu código localmente neste novo working copy. Toda vez que precisar fazer um commit, basta fazer:<br>
<br>

```bash
git commit -a -m “[seu comentário]”
```

<br>
Note que esses commits não estão indo ao servidor. Está tudo local. Para ver as revisões, o comando é parecido com o <span class="caps">SVN</span>:<br>
<br>

```bash
git log
```

<br>
Finalmente, depois de alterar meu working copy como quiser, digamos que estou pronto para publicar as modificações de volta ao <span class="caps">SVN</span>:<br>
<br>

```bash
git-svn dcommit
```

<br>
Isso deve fazer um replay do histórico deste o último fetch de volta ao servidor, teoricamente mantendo o histórico intacto, com o autor, os comentários dos commits e tudo mais.<br>
<br>
Agora, no meu antigo working copy do <span class="caps">SVN</span>, fiz algumas pequenas modificações e depois svn commit. No novo working copy do <span class="caps">GIT</span>, para fazer o equivalente ao antigo “svn up”, faço o seguinte:<br>
<br>

```bash
git-svn fetch
git-svn rebase
```

<br>
Isso trará todas as revisões. O interessante é que parece que ele faz um “rollback” local e dá um “replay” nas minhas próprias revisões sobre as que vieram do <span class="caps">SVN</span>. Ainda não entendi bem o algoritmo, mas isso parece mais eficiente do que um merge bidimensional apenas do último snapshot local (working copy) contra os deltas do <span class="caps">HEAD</span> do servidor. Um conceito que parece importante é que o <span class="caps">GIT</span> – ao contrário de todos os outros – não rastreia arquivos, ele <strong>rastreia conteúdo</strong>. Segundo Linus Torvalds, isso é muito mais importante. Por exemplo, você consegue rastrear de onde veio uma determina linha, ou trecho: de qual arquivo ele veio, depois quem fez o “copy and paste” e para que arquivo ele foi parar. Todo o histórico. Fazer um blame nunca foi tão fácil.<br>
<br>
Enfim. Ao final fiz um teste mais interessante: no working copy do <span class="caps">SVN</span>, eu movi um arquivo de lugar, um básico “mv”. Isso significa:<br>
<br>

```bash
svn delete [arquivo antigo]
svn add [arquivo novo]
svn commit <del>m ""
```

<br>
No working copy do <span class="caps">GIT</span>, antes de fazer o fetch, eu peguei o <strong>mesmo arquivo</strong>, que ainda está com o nome antigo, e alterei seu conteúdo. Se fosse no <span class="caps">SVN</span>, aconteceria o seguinte: o svn up traria a ordem de deleção. Como o arquivo foi modificado ele não seria deletado. O novo arquivo viria e você acabaria com o novo e com o antigo, agora fora do repositório (marcado como “?”). <br>
<br>
E no <span class="caps">GIT</span>? Bem, depois to fetch/rebase ele foi inteligente o suficiente para saber que o arquivo antigo foi renomeado! Ele trouxe a já aplicou a mudança que havia feito localmente no <span class="caps">GIT</span>!! E não me deixou com sujeira para rastrear, copiar do antigo, colar no novo e apagar o arquivo velho, como o <span class="caps">SVN</span> faria. Isso foi interessante. Só esse recurso já me convenceu. <br>
<br>
E isso porque ainda nem comecei a raspar na casca. Como agora tenho um histórico local, digamos que estou na praia, sem internet, trabalhando desconectado mas mesmo assim fazendo commits :-) (wishful thinking, eu sei) mas suponha que eu pense <em>“Putz, não era isso que eu queria comitar”</em> mas agora eu posso reverter commits até a revisão anterior que eu queira. Vejam neste <a href="http://www.kernel.org/pub/software/scm/git/docs/howto/revert-branch-rebase.html">tutorial</a> sobre como trabalhar com o recurso de reversão.<br>
<br>
O pessoal do <a href="http://wiki.samba.org/index.php/Using_Git_for_Samba_Development">Samba</a> e do <a href="http://live.gnome.org/GitForGnomeDevelopers">Gnome</a> tem tutoriais parecidos. No primeiro caso, parece que o Samba agora fica gerenciado em <span class="caps">GIT</span>, então dá para ter uma idéia de como é trabalhar num ambiente puramente <span class="caps">GIT</span>. No caso do Gnome eles ensinam como colaborar com <span class="caps">GIT</span> mas interfaceando com a infraestrutura <span class="caps">SVN</span> (gerar patches e tudo mais). E aí mais um truque: em vez de usar “init” como fiz, eles usam “clone” e ao final há um passo extra: mudar de volta ao branch “master”, fazer um “merge” com seu branch atual e só depois “dcommit”. Parece que eles preferem fazer merge no master antes de enviar os commits ao <span class="caps">SVN</span>. No fundo acho que é a mesma coisa do que falei aqui.<br>
<br>
E falando em merge, veja o que acontece se fizer o merge entre o branch “working”, que modifiquei nos passos acima, e o “master”:<br>
<br>

```bash
git checkout master
git merge -squash working
```

```
Updating 780040f..00e988e<br>
Fast forward<br>
Squash commit  not updating
 init.rb | 4 
 lib/{fixes.rb => activerecord_fixes.rb} | 66 ++++++++++++++++++++—————
 2 files changed, 47 insertions(+), 23 deletions(-)
```

<br>
Notem como ele realmente entendeu que aconteceu um rename de arquivos. Também mostra quantas linhas mudaram em cada um. Ainda estou surpreso que a modificação que fiz no “fixes.rb” – do working copy do <span class="caps">GIT</span> – foi parar corretamente e automaticamente dentro do “activerecord_fixes.rb”, que foi o arquivo renomeado vindo do <span class="caps">SVN</span>. E pelo que li, se deletar um arquivo usando “rm” ele automaticamente entende que é para tirar do repositório, diferente do svn onde precisamos explicitamente usar “svn delete”, “svn mv”, etc. Para adicionar novos arquivos, é igual: “git add [arquivo]”.<br>
<br>
Aliás, o comando “git checkout” é semelhante ao “svn switch”. Não sei como ele faz, mas este comando foi instantâneo! Tecnicamente significa que agora meu working copy é o “master” e não tem as modificações que fiz no “working”. Pra isso ele teve que remontar minha estrutura local. No <span class="caps">SVN</span> não é nem de perto tão rápido: para começar que ele precisa se comunicar com o servidor, só no tempo que leva para conectar ao servidor para puxar o update, o <span class="caps">GIT</span> já acabou o trabalho. Aliás, switch é outra coisa que pode dar dor de cabeça. Nunca confiei muito nesse comando no <span class="caps">SVN</span>. Pra começar que você precisa ter feito commit de tudo antes do switch. No <span class="caps">GIT</span>, ele transfere as modificações que ainda não sofreram commit entre branches, durante o switch! Muito esperto. Ou seja, posso alterar arquivos, não fazer commit, ir tocando de branches e só comitar quando eu escolher o branch que eu queria!<br>
<br>
No fim, este ultra-micro-teste foi muito interessante, bem sucedido e me deixou muito satisfeito. Não deu nenhum problema inesperado, as mensagens do <span class="caps">GIT</span> foram muito solícitas e fáceis de entender e ele fez muito melhor do que eu esperava. Significa que vou usá-lo por mais algum tempo.</macro:code></macro:code></macro:code></macro:code></macro:code></macro:code></macro:code></macro:code></macro:code></macro:code></macro:code>
