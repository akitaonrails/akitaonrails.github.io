---
title: Dicas de Git
date: '2009-07-05T14:56:08-03:00'
slug: dicas-de-git
tags:
- learning
- beginner
- git
draft: false
---

Se você ainda não aprendeu Git, um bom lugar para começar é meu [Micro Tutorial de Git](/2008/4/3/micro-tutorial-de-git). Para complementar, existem algumas dicas úteis para usar no dia-a-dia que vou explicar agora. Mesmo assim, Git é um mundo rico e complexo, existem infinitas possibilidades e você nunca vai se cansar de aprender coisas novas com ele. Recomendo também acompanhar o site [GitReady](http://www.gitready.com/) para continuar aprendendo truques novos.

Para começar, vamos criar um novo repositório para exemplo:

* * *

rails teste  
cd teste  
git init  
git add .  
git commit m “initial commit”  
--

Agora vamos falar sobre como desfazer modificações, manipular commits, e muito mais.


### Undo

Uma coisa que muitos perguntam e podem se confundir devido a comandos do git como ‘reset’ e ‘revert’. Por exemplo, digamos que você editou alguns arquivos e quer retornar apenas um deles ao estado original do último commit:

* * *

(master) $ git status

1. On branch master
2. Changed but not updated:
3. (use “git add <file>…” to update what will be committed)</file>
4. (use “git checkout — <file>…” to discard changes in working directory)<br>
#</file>
5. modified: README
6. modified: Rakefile  
#  
no changes added to commit (use “git add” and/or “git commit -a”)  
-

No exemplo, modificamos os arquivos ‘README’ e ‘Rakefile’. Agora digamos que você desistiu das mudanças no arquivo Rakefile e quer que ele volte ao estado original. Para isso apenas faça:

* * *

git checkout Rakefile  
-

Porém, digamos que você queira realmente desfazer todas as modificações que você fez, nesse caso você faz:

* * *

git reset -hard  
--

Isso retornará todos os arquivos modificados de volta ao estado original do último commit. Porém esse comando apenas afeta arquivos que já fazem parte do repositório. Se você criou diversos arquivos novos e que se livrar deles também, faça isto:

* * *

git clean d -f  
--

### Adicionando arquivos ao repositório

Uma coisa que muitos aprendem, decoram e fazem da forma errada é este comando:

* * *

git commit a -m “mensagem do commit”  
--

A opção “-a” essencialmente significa o equivalente a fazer o seguinte: ‘adicione todos os arquivos modificados ao próximo commit’. Normalmente é isso mesmo que queremos fazer, mas nem sempre. Por exemplo, isso não adiciona arquivos que já não estavam no repositório, para esses você precisa adicionar manualmente antes de fazer o commit, por exemplo:

* * *

git add novo\_arquivo.txt  
-

Digamos que você tem esta situação:

* * *

./script/generate scaffold Post title:string  
-

Isso nos dá o seguinte:

* * *

(master) $ git status

1. On branch master
2. Changed but not updated:
3. (use “git add <file>…” to update what will be committed)</file>
4. (use “git checkout — <file>…” to discard changes in working directory)<br>
#</file>
5. modified: config/routes.rb  
#
6. Untracked files:
7. (use “git add <file>…” to include in what will be committed)<br>
#</file>
8. app/controllers/posts\_controller.rb
9. app/helpers/posts\_helper.rb
10. app/models/
11. app/views/
12. db/
13. public/stylesheets/
14. test/fixtures/
15. test/functional/
16. test/unit/  
no changes added to commit (use “git add” and/or “git commit -a”)  
-

Preste sempre atenção – as pessoas se acostumam a “não ler” as coisas. Vejam que temos dois grupos de modificações:

- Changed but not updated – significa arquivos que já estavam no repositório e foram modificados
- Untracked files – significa arquivos novos, que ainda não foram adicionados ao repositório

Agora, façamos algumas operações:

* * *

git add app/models/  
git add config/routes.rb  
-

Vejam o resultado:

* * *

(master) $ git status

1. On branch master
2. Changes to be committed:
3. (use “git reset HEAD <file>…” to unstage)<br>
#</file>
4. new file: app/models/post.rb
5. modified: config/routes.rb  
#
6. Untracked files:
7. (use “git add <file>…” to include in what will be committed)<br>
#</file>
8. app/controllers/posts\_controller.rb
9. app/helpers/posts\_helper.rb
10. app/views/
11. db/
12. public/stylesheets/
13. test/fixtures/
14. test/functional/
15. test/unit/  
-

Agora eu tenho um novo grupo de arquivos:

- Changes to be committed – estes são arquivos modificados, que eu manualmente indiquei que serão inclusos no próximo commit, ou seja, eles estão numa região chamada “index”. Somente arquivos marcados no “index” entram no commit. Por exemplo:

* * *

$ git commit m “teste”  
[master bd69909] teste  
 2 files changed, 4 insertions(+), 0 deletions()  
 create mode 100644 app/models/post.rb  
-

Notem que eu não precisei usar a opção “-a”. Na verdade, eu recomendaria não usar essa opção a menos que você saiba exatamente o que ela faz. Nesse último commit, apenas os dois arquivos que estavam no index entraram.

Como exemplo, digamos que esse último commit foi um engano, justamente porque “esquecemos” de adicionar os outros arquivos que estavam como “Untracked files”. Podemos desfazer um commit, sem perder as modificações que ela carrega fazendo isto:

* * *

git reset -soft HEAD~1  
--

Note a opção “—soft”, ela está indicando para desfazer o commit anterior (HEAD~1) mas sem perder seu conteúdo. Veja:

* * *

(master) $ git status

1. On branch master
2. Changes to be committed:
3. (use “git reset HEAD <file>…” to unstage)<br>
#</file>
4. new file: app/models/post.rb
5. modified: config/routes.rb  
…  
-

Agora, como adicionar os “Untracked files”? Uma forma que eu acabo fazendo é simplesmente copiando os paths indicados para um editor de texto, adicionar ‘git add’ e simplesmente colar os comandos no terminal. Outra forma é adicionar arquivo a arquivo de forma interativa, assim:

* * *

$ git add -i  
 staged unstaged path  
 1: +2/-0 nothing app/models/post.rb  
 2: +2/-0 nothing config/routes.rb

- Commands **\***  
 1: [s]tatus 2: [u]pdate 3:®evert 4: [a]dd untracked  
 5: [p]atch 6: [d]iff 7: [q]uit 8: [h]elp  
-

Ele nos dá um menu de comandos. Você pode usar a opção “4” para adicionar os novos arquivos. Ele nos levará à seguinte tela:

* * *

What now\> 4  
 1: app/controllers/posts\_controller.rb  
 2: app/helpers/posts\_helper.rb  
 3: app/views/layouts/posts.html.erb  
 4: app/views/posts/edit.html.erb  
 5: app/views/posts/index.html.erb  
 6: app/views/posts/new.html.erb  
 7: app/views/posts/show.html.erb  
 8: db/migrate/20090705175333\_create\_posts.rb  
 9: public/stylesheets/scaffold.css  
 10: test/fixtures/posts.yml  
 11: test/functional/posts\_controller\_test.rb  
 12: test/unit/helpers/posts\_helper\_test.rb  
 13: test/unit/post\_test.rb  
Add untracked\>\>  
-

Agora você pode digitar o número do arquivo que quer adicionar e pressionar ‘enter’. Por exemplo, para adicionar o arquivo ‘test/unit/post\_test.rb’ apenas digite ‘13[enter]’. Para adicionar vários de uma só vez, você pode usar um ‘range’ ou seja, se digitar “1-13” ele adicionará do arquivo 1 ao 13. Arquivos adicionados ficam marcados com “\*” do lado.

Isso terminado, digite apenas ‘enter’ para retornar ao menu anterior e digite ‘q’ para sair do modo interativo. Agora, com os arquivos novos adicionados, temos isto:

* * *

$ git status

1. On branch master
2. Changes to be committed:
3. (use “git reset HEAD <file>…” to unstage)<br>
#</file>
4. new file: app/controllers/posts\_controller.rb
5. new file: app/helpers/posts\_helper.rb
6. new file: app/models/post.rb
7. new file: app/views/layouts/posts.html.erb
8. new file: app/views/posts/edit.html.erb
9. new file: app/views/posts/index.html.erb
10. new file: app/views/posts/new.html.erb
11. new file: app/views/posts/show.html.erb
12. modified: config/routes.rb
13. new file: db/migrate/20090705175333\_create\_posts.rb
14. new file: public/stylesheets/scaffold.css
15. new file: test/fixtures/posts.yml
16. new file: test/functional/posts\_controller\_test.rb
17. new file: test/unit/helpers/posts\_helper\_test.rb
18. new file: test/unit/post\_test.rb  
-

Pronto, agora todos os arquivos que queremos estão no “index”, marcados como “Changes to be committed”. A descrição é bastante explicativa: arquivos marcados como “new file” são os arquivos novos que adicionamos, e os “modified” são aqueles que já estavam no repositório e colocamos no index. Basta fazer o commit agora:

* * *

git commit m “adicionando scaffold de Post”  
--

### Revertendo commits

No [Micro Tutorial de Git](/2008/4/3/micro-tutorial-de-git) expliquei sobre repositórios locais e remotos. Neste exemplo estamos apenas no repositório local. Se tivéssemos um remoto usaríamos ‘git remote’ para adicioná-lo e usaríamos os comandos ‘git push’ para enviar os commits locais para o repositório e ‘git pull’ para trazer os commits do repositório remoto para o local.

A regra básica é a seguinte:

> Commits que você já enviou ao repositório remoto, ou commits que recebeu de lá, nunca devem ser modificados.

Ou seja, não use comandos como ‘git reset —hard HEAD~1’ para apagar um commit, ou faça ‘rebase’ em cima de um branch que já exista no lado remoto. Se precisarmos reverter o que foi feito em um commit podemos primeiro fazer:

* * *

$ git log  
commit 89b53e7d0bfc4fdb4b5c389f5481dab5ddb2b83d  
Author: AkitaOnRails \<fabioakita@gmail.com\>  
Date: Sun Jul 5 15:06:44 2009 -0300

adicionando scaffold de Post

commit d394bee7ec01b2d90f00f20fc698364e9d943352  
Author: AkitaOnRails \<fabioakita@gmail.com\>  
Date: Sun Jul 5 14:41:39 2009 -0300

initial commit
* * *

Vamos reverter o commit mais recente. Para isso tomamos nota do seu identificados SHA1 e podemos executar este comando:

* * *

git revert -no-edit 89b53e7d0bfc4fdb4b5c389f5481dab5ddb2b83d  
--

Agora teremos o seguinte log:

* * *

$ git log  
commit 15bb972393f7794892dbf5d6a3097c533a68fbea  
Author: AkitaOnRails \<fabioakita@gmail.com\>  
Date: Sun Jul 5 15:13:03 2009 -0300

Revert “adicionando scaffold de Post” This reverts commit 89b53e7d0bfc4fdb4b5c389f5481dab5ddb2b83d.

commit 89b53e7d0bfc4fdb4b5c389f5481dab5ddb2b83d  
Author: AkitaOnRails \<fabioakita@gmail.com\>  
Date: Sun Jul 5 15:06:44 2009 -0300

adicionando scaffold de Post

commit d394bee7ec01b2d90f00f20fc698364e9d943352  
Author: AkitaOnRails \<fabioakita@gmail.com\>  
Date: Sun Jul 5 14:41:39 2009 -0300

initial commit
* * *

Entendeu? Isso criou um novo commit com a reversão do que fizemos antes. Por exemplo, se no commit original nós criamos um arquivo, neste novo commit esse arquivo será deletado, e assim por diante. Essa é a forma correta de reverter modificações que já estão no repositório local. Mas se você quiser reverter commits locais que ainda não enviou ao servidor, o ‘git reset —soft’ é uma das opções.

### Forçando modificações remotas

Dissemos que commits remotos não devem ser modificados. Porém, digamos que você está numa situação onde precisa reorganizar seus commits. Existem algumas razões excepcionais, você saberá quando cair nelas :-) Estou sem um bom exemplo. Mas digamos que você precisou destruir ou reescrever commits e precisa modificar isso no servidor.

Antes de mais nada, considere o cenário de um repositório remoto controlado, onde você conhece todas as pessoas da equipe envolvidas nela. Ou seja, não é um projeto open source no Github. Nesse caso faça as modificações locais que precisa e no final faça isto:

* * *

git push -force  
--

A opção “—force” irá reescrever os commits no repositório remoto para refletir o que você fez localmente. Agora o truque: avise todos os membros da sua equipe para baixar as modificações da seguinte forma:

* * *

git pull -rebase  
--

Isto irá reescrever o histórico local de cada um dos membros da equipe. Não é uma operação que você quer fazer o tempo todo, por isso faça somente quando realmente precisar, simule isso em repositórios de teste para se sentir confortável antes de fazer isso no repositório do seu projeto, garanta que seus backups estão em dia. Reescrever o histórico no Git não é problemático, fazer sem saber o que está fazendo, é.

### Undelete

Depois de tanto manipular commits, digamos que você tenha feito alguma besteira. Vamos simular uma “besteira”, digamos que você tenha apagado um commit que não queria, por exemplo:

* * *
$ git log

commit 15bb972393f7794892dbf5d6a3097c533a68fbea  
Author: AkitaOnRails \<fabioakita@gmail.com\>  
Date: Sun Jul 5 15:13:03 2009 -0300

Revert “adicionando scaffold de Post” This reverts commit 89b53e7d0bfc4fdb4b5c389f5481dab5ddb2b83d.

…  
-

Para apagar “por engano” este commit mais recente, digamos que você “acidentalmente” tenha feito:

* * *

git reset -hard HEAD~1  
--

Agora seu log ficará assim:

* * *

$ git log  
commit 89b53e7d0bfc4fdb4b5c389f5481dab5ddb2b83d  
Author: AkitaOnRails \<fabioakita@gmail.com\>  
Date: Sun Jul 5 15:06:44 2009 -0300

adicionando scaffold de Post

…  
-

Pronto, besteira feita, e agora? Faça de conta que esse commit representa todo o trabalho que você fez durante o dia todo. Será que agora você terá que fazer tudo de novo? Claro que não, o Git prevê esse tipo de coisa. Para começar, o ideal é que você tente recuperar um erro imediatamente quando o fez, não deixe para depois. Agora faça assim:

* * *

$ git reflog  
89b53e7 HEAD@{0}: HEAD~1: updating HEAD  
15bb972 HEAD@{1}: commit: Revert “adicionando scaffold de Post”  
89b53e7 HEAD@{2}: HEAD~1: updating HEAD  
4a41f10 HEAD@{3}: commit: Revert “adicionando scaffold de Post”  
89b53e7 HEAD@{4}: commit: adicionando scaffold de Post  
d394bee HEAD@{5}: HEAD~1: updating HEAD  
bd69909 HEAD@{6}: commit: teste  
-

O comando ‘git reflog’ listará os commits inacessíveis. Podemos ver na segunda linha o commit que acabamos de ‘apagar’. Para recuperá-lo, faça o seguinte:

* * *

git merge 15bb972  
-

Pronto, isso trás o commit perdido de volta ao histórico oficial e será como se nada tivesse acontecido. Qualquer coisa que já está no repositório pode ser recuperado, porém se você apagou algum novo arquivo que ainda não estava no commit daí não há o que fazer. Por isso mesmo sempre recomendamos que se faça commits o tempo todo.

### Branches no passado

Toda vez que queremos um novo branch usamos o seguinte comando:

* * *

git checkout b novo\_branch  
--

Isso indica que criaremos o ‘novo\_branch’ tendo como pai o branch onde estamos neste momento. Porém, digamos que queremos criar um branch a partir de um commit no passado. Podemos fazer desta forma:

* * *

git checkout b novo\_branch d394bee7ec01b2d90f00f20fc698364e9d943352  
--

Use o comando ‘git log’ para identificar o SHA1 do commit que quer. Visualmente ficaremos com o seguinte:

![](http://s3.amazonaws.com/akitaonrails/assets/2009/7/5/Picture_2_original.png)

### Quem mexeu no meu Queixo?

Às vezes queremos saber quem mexeu em determinado trecho de um arquivo, às vezes porque faltou algum comentário e queremos perguntar a quem fez a modificação para saber se podemos mexer, refatorar ou coisa parecida.

Isso é simples, use o seguinte comando:

* * *

$ git blame base.rb   
…  
^db045db (David Heinemeier … 2004-11-24 … 15) module ActiveRecord #:nodoc:  
98dc5827 (Pratik Naik … 2008-05-25 … 16) # Generic Active Record ex  
73673256 (Jeremy Kemper … 2007-12-10 … 17) class ActiveRecordError \<   
^db045db (David Heinemeier … 2004-11-24 … 18) end   
73673256 (Jeremy Kemper … 2007-12-10 … 19)   
0432d151 (Pratik Naik … 2008-07-16 … 20) # Raised when the single-t   
73673256 (Jeremy Kemper … 2007-12-10 … 21) # (for example due to impr   
605bc775 (David Heinemeier … 2004-12-14 … 22) class SubclassNotFound \< A  
605bc775 (David Heinemeier … 2004-12-14 … 23) end  
…  
-

(O trecho acima está encurtado)

Com isso podemos saber quem mexeu em cada linha, quando mexeu e em que commit está essa modificação. Assim podemos inclusive rastrear o commit que contém a modificação.

### Reescrevendo a última mensagem de commit

Quantas vezes não fazemos um commit e nos damos conta que escrevemos a mensagem de commit com algum erro ortográfico, ou mesmo esquecemos de detalhar alguma coisa importante? Mas o Git nos ajuda nisso também. Em vez de desfazer o commit e refazê-lo, podemos usar este comando:

* * *

git commit -amend  
--

Isso abrirá seu editor padrão (ex. Vim) e lhe dará a oportunidade de editar a mensagem de commit.

### Obtendo mais ajuda

Não se esqueça, para conhecer alguns dos principais comandos do Git use este comando:

* * *

git -help  
--

E para obter detalhes e instruções sobre como usar cada comando, faça assim:

* * *

git help commit  
-

Isso vale para todos os comandos. É a melhor forma de explorar e aprender a usar os comandos.

### Aprendendo mais

Por hoje acho que isso já é suficiente. Continue sempre explorando mais e mais as possibilidades do Git. Acompanhe o trabalho do Scott Chacon, do Github, para saber mais. Outro site interessante é o [Git Community Book](http://book.git-scm.com/) com mais documentação. Se quiser um livro impresso, recomendo o [Pro Git](http://www.amazon.com/Pro-Git-Scott-Chacon/dp/1430218339).

E, finalmente, não deixe de ajudar a tradução do site [GitReady](http://pt-br.gitready.com/) para português seguindo as instruções no post do [Tailor Fontela](http://www.tailorfontela.com.br/2009/03/07/gitready/). Esse site tem mais dicas importantes para sua rotina com Git.

