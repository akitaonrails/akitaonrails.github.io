---
title: "[Screencast] Começando com Git"
date: '2010-08-17T00:21:00-03:00'
slug: screencast-comecando-com-git
tags:
- learning
- beginner
- git
- screencast
draft: false
---

 **Atualização 09/04/12:** Este screencast foi liberado para visualização gratuita. Acesse este [post](http://akitaonrails.com/2012/04/09/screencasts-liberados-gratuitamente)

**Atualização 17/08:** Tem uma pequena correção para quem usa Windows que não coloquei no screencast. Veja no fim do artigo.

Como prometido, continuo com minha iniciativa de publicar screencasts, vídeo-aulas completas para que você possa aprender sobre as novas tecnologias.

Todos devem saber que Git cresceu muito em popularidade desde 2007, quando publiquei meu [primeiro artigo evangelizando Git](http://www.akitaonrails.com/2007/09/22/jogar-pedra-em-gato-morto-por-que-subversion-no-presta). Depois disso publiquei outros artigos incluindo o famoso [Micro Tutorial de Git](http://www.akitaonrails.com/2008/04/02/micro-tutorial-de-git)

Graças ao [Github](http://www.github.com) todo bom desenvolvedor que se preza tem o Git na sua caixa de ferramentas. Você, sua equipe e sua empresa só tem a ganhar aprendendo esta ferramenta.

- Nível: Iniciante, Intermediário
- Tema: Começando a usar a ferramenta de controle de versionamento de código, Git
- Duração: **3:17h**
- Formatos: 
  - [Maior](http://bit.ly/Iv8XfH) 800×600 – 510Mb (zip, Quicktime/H.264)
  - [iPhone](http://bit.ly/1b7CwLc) 480×360 – 471Mb (zip, Quicktime/H.264)

- Plataformas: Linux (Ubuntu), Mac OS X, Windows 7
- Acompanha PDF com os slides usados na apresentação
- Tem organização em Capítulos


E assistam na íntegra aqui:

<video controls>
<source src="https://screencasts2010.s3.us-east-2.amazonaws.com/Comecando_com_Git/Come%C3%A7ando+com+Git.mov">
Your browser does not support the video tag. [Direct Link](https://screencasts2010.s3.us-east-2.amazonaws.com/Comecando_com_Git/Come%C3%A7ando+com+Git.mov)
</source></video>

E se está interessado em aprender mais, leia todos os meus artigos já publicados neste blog sobre Git:

- [Git com Smart HTTP Transport](/2010/03/14/git-com-smart-http-transport)
- [Deploy com Git Push](/2010/02/13/deploy-com-git-push)
- [A Controvérsia do Ticket #2033 – Ruby on Git](/2009/09/04/a-controv-rsia-do-ticket-2033-ruby-on-git)
- [Dicas de Git](/2009/07/05/dicas-de-git)
- [Pequena dica de Git para Windows](/2009/02/23/pequena-dica-de-git-para-windows)
- [Por que Git é melhor que X](/2008/12/02/tradu-o-por-que-git-melhor-que-x)
- [Entendendo Git e Instalando Gitorious – Git via Web](/2008/10/02/entendendo-git-e-instalando-gitorious-git-via-web)
- [Colaborando no Github](/2008/09/21/colaborando-no-github)
- [Git com Sake](/2008/04/03/git-com-sake)
- [Finalmente, Rails mudando de SVN para Git](/2008/04/02/finalmente-rails-mudando-de-svn-para-git)
- [Micro-Tutorial de Git](/2008/04/02/micro-tutorial-de-git)
- [Git on Cygwin on Windows](/2008/02/13/git-on-cygwin-on-windows)
- [Git para Cientistas da Computação](/2008/02/12/git-para-cientistas-da-computa-o)
- [Ruby on Git](/2008/02/04/ruby-on-git)
- [Aprenda Git pelo Peepcode](/2007/10/26/aprenda-git-pelo-peepcode)
- [Git, muito Promissor](/2007/09/22/git-muito-promissor)
- [Jogar Pedra em Gato Morto: Por que Subversion não Presta](/2007/09/22/jogar-pedra-em-gato-morto-por-que-subversion-no-presta)

## Atualização: Git – Cloning e pushing via https no Windows

Li este post do [Lars Vogel](http://www.vogella.de/blog/2010/08/09/git-https/) hoje com uma dica para quem usa Windows. Vou traduzir para facilitar. Isto é quando você quiser fazer clone ou push para repositórios Git via HTTPS (como o Github passou a suportar recentemente), por exemplo:

* * *

git clone https://vogella@github.com/vogella/de.vogella.rcp.example.git  
…  
git push https://vogella@github.com/vogella/de.vogella.rcp.example.git  
-

Você pode receber este erro no Windows:

* * *

error: error setting certificate verify locations:  
CAfile: /bin/curl-ca-bundle.crt  
CApath: none  
-

Se ver este erro para resolver é só desabilitar a verificação de SSL:

* * *

git config -global http.sslverify “false”  
--

Depois desta configuração, clone e push via https vai funcionar no Windows.

Outra alternativa que o Vogel não testou é a seguinte:

* * *

mkdir c:\bin\  
copy “C:\Program Files\Git\bin\curl-ca-bundle.crt” c:\bin\curl-ca-bundle.crt  
-

Ou:

* * *

git config -system http.sslcainfo \bin/curl-ca-bundle.crt  
--

A discussão completa sobre esse problema do msysGit pode ser encontrada [aqui](http://github.com/blog/642-smart-http-support).

E se estiver atrás de um proxy HTTP você pode configurar assim:

* * *

git config -global http.proxy http://proxy:8080  
--

Para checar a configuração:

* * *

git config -get http.proxy  
--

