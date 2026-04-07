---
title: "O Ano do Linux no Desktop - Está Usável!"
date: '2016-07-26T14:13:00-03:00'
slug: o-ano-do-linux-no-desktop-esta-usavel
translationKey: year-linux-desktop-usable
aliases:
- /2016/07/26/the-year-of-linux-on-the-desktop-it-s-usable/
tags:
- microsoft
- off-topic
- traduzido
draft: false
---

23/07/16: por coincidência, postei esse review um dia antes do release final :-) Então o build final é o 14393 e [já está disponível](http://arstechnica.com/information-technology/2016/07/windows-10-anniversary-update-is-ready-to-go-and-free-for-just-a-few-more-days/) de graça agora mesmo!

Já fazem 3 meses desde que postei [minhas impressões iniciais](http://www.akitaonrails.com/2016/04/12/o-ano-do-linux-no-desktop-pela-microsoft) sobre a feature mais importante do Windows 10 Anniversary Edition: o Bash no Windows. Minha conclusão na época foi que ainda não estava pronto pra produção.

Minha conclusão agora, em 26 de julho, é que finalmente está usável o suficiente pra desenvolvedores web, particularmente pra desenvolvedores Ruby que sempre sofreram com a falta de suporte no Windows.

![It's alive!](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/543/big_Screen_Shot_2016-07-26_at_13.28.48.png)

O processo de instalação é o mesmo. Você precisa estar inscrito no programa [Windows Insider](http://www.howtogeek.com/249966/how-to-install-and-use-the-linux-bash-shell-on-windows-10/), esperar pelo menos um dia se for sua primeira vez. Habilite o **Fast ring** de updates, instale a edição Preview pelo Windows Update normal e então ligue a feature "Windows Subsystem for Linux (Beta)".

> Da última vez eu estava testando Windows 10 sobre Virtualbox sobre Ubuntu 14.04 num notebook Dell Inspiron (i7 com 8 cores e 16GB de RAM). Estava lentíssimo, não recomendo de jeito nenhum. Agora voltei pro meu confiável Macbook Pro 2013 com 16GB de RAM e SSD rodando VMWare Fusion, e o Windows 10 voa aqui. Super recomendado.

Depois de fazer tudo isso, você pode iniciar o "Bash on Ubuntu on Windows" (que nome enorme). A primeira boa surpresa é que ele pede pra você registrar um novo nome de usuário em vez de cair direto no Root. Como falei no post anterior, é boa prática criar um novo usuário e adicionar ao grupo sudoers, e é isso que ele faz. Então você pode instalar pacotes usando "sudo apt-get install".

Você deveria seguir meu [post anterior](http://www.akitaonrails.com/2016/04/12/o-ano-do-linux-no-desktop-pela-microsoft) pra ver todos os pacotes e configurações que eu normalmente faço numa máquina Linux de desenvolvimento.

RVM agora funciona! Consegui instalar Ruby 2.3.1 via RVM sem nenhum problema.

Consegui dar `git clone` num pequeno projeto Rails e rodar `bundle install` direitinho. Todas as gems foram baixadas, extensões nativas compilaram sem nenhuma falha.

Algumas coisas ainda não funcionam. Por exemplo, você não vai conseguir terminar a instalação do Postgresql 9.3. Ele vai baixar e instalar, mas o setup do cluster falha, como você pode acompanhar nessa [thread de issue](https://github.com/Microsoft/BashOnWindows/issues/61).

Mas você não precisa ter **tudo** instalado sob o Ubuntu, dá pra usar o [Postgresql for Windows](https://www.postgresql.org/download/windows/) nativo e editar seu `config/database.yml` apontando pro server `127.0.0.1` e porta `5432`. No lado do Ubuntu, basta instalar o `libpq-dev` pra que a gem `pg` consiga compilar suas extensões nativas e pronto.

Serviços menores como Memcached ou Redis instalam direitinho com `apt-get`, mas eles não vão dar auto-start via Upstart. Você pode iniciá-los manualmente e usar algo como [Foreman](https://github.com/ddollar/foreman) pra controlar os processos. Os dois sobem e funcionam bem o suficiente, então dá pra testar caching nos seus projetos Rails e também testar workers Sidekiq.

Eu sei que ainda é Preview, então tem correções de bug e possivelmente algumas features novas que podem entrar no release final em agosto. Uma reclamação chata que eu tenho é que todo comando que eu rodo com `sudo` demora alguns segundos pra começar, então é irritante, mas funciona no final.

Node.js 6.3.1 instala e roda com sucesso. Consegui dar `npm i` e `node server.js` no [repositório de exemplo](https://github.com/openshift/nodejs-ex) Node do Openshift.

Crystal 0.18.7 instala com sucesso e conseguiu compilar meu projeto [Manga Downloader](https://github.com/akitaonrails/cr_manga_downloadr) direitinho. Executou meu teste de performance embutido em 15 minutos. A performance não é estonteante, mas roda corretamente até o fim. (E sim, então, Crystal agora também roda no Windows!).

Go 1.6 funciona. Só dei um `go get` pra instalar o Martini e rodei o simples server "Hello World". Compila, inicia e executa rapidíssimo como esperado.

Infelizmente, Elixir 1.3.1 trava, ainda não sei por quê.

```
$ iex
Crash dump is being written to: erl_crash.dump...done
erl_child_setup closed
```

Na real, o próprio Erlang trava só de tentar rodar `erl`. Nenhuma das ferramentas Elixir funciona como consequência. Sem iex, sem mix. O engraçado é que estava funcionando no Preview inicial. Então ou é algo do novo Preview ou algo dos releases mais novos do Erlang. Existem [issues abertas](https://github.com/Microsoft/BashOnWindows/issues?utf8=✓&q=is%3Aissue%20elixir) sobre esse problema, então vamos torcer pra ser corrigido logo.

<a name="best-windows-dev-env"></a>

### "O Melhor Ambiente para Rails no Windows"

Eu tenho [esse post bem antigo de 2009](http://www.akitaonrails.com/2009/1/13/the-best-environment-for-rails-on-windows) pra guiar desenvolvedores presos no Windows que precisam implementar projetos Rails. O primeiro conselho é evitar Ruby for Windows. Eu realmente louvo os esforços de grandes desenvolvedores como o Luis Lavena, que investiu muito tempo pra fazer aquilo funcionar bem o suficiente. Mas, infelizmente, a realidade é que Ruby foi feito pra ambientes Linux, ele se conecta a extensões nativas em C que têm um monte de dependências difíceis de disponibilizar no Windows.

Então a melhor opção até agora era instalar Vagrant (via Virtualbox ou, melhor ainda, VMWare) como runtime e usar editores disponíveis no Windows como Sublime Text 3 ou Atom.

Agora você pode evitar a parte de Vagrant/virtualização e usar diretamente o "Bash on Ubuntu on Windows". É tão completo que dá até pra usar ZSH e instalar dotfiles complexos como o YADR. Dá pra rodar Postgresql for Windows e conectar em localhost:5432 na sua aplicação Rails ou em qualquer aplicação web que precise de Postgresql, por exemplo.

Você pode instalar o ConEmu como um emulador de terminal melhor do que o cmd.exe padrão estupidamente ruim. Siga [esse artigo](https://conemu.github.io/en/BashOnWindows.html) pra acompanhar novidades sobre o suporte ao Bash no Windows. Por enquanto você tem que mudar o hotkey "Ctrl-V" pra outra coisa ("Ctrl-Shift-V"), as setas não funcionam direito no Vim, e dá pra adicionar uma Default Task pro Bash assim: `%windir%\system32\bash.exe ~ -cur_console:p`

![Desenvolvendo Rails no Windows](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/544/big_Screen_Shot_2016-07-28_at_14.13.36.png)

### Conclusão

Então, sim, pelo menos a partir dessa versão que testei (instalada em 25 de julho), esse é um "Bash on Ubuntu on Windows" **usável** e desenvolvedores web de Ruby a Javascript a Crystal a Go podem começar a testar e tentar fazer do Windows 10 Anniversary sua plataforma primária pra desenvolvimento sério baseado em Linux.

Adicione Sublime Text ou Atom (ou Visual Studio, se for sua praia) e você está pronto. Espero que os próximos releases corrijam alguns dos bugs e problemas de performance, mas comparado ao que vimos em abril, é uma melhoria gigantesca.

Parabéns à Microsoft por isso!

E se você quer saber mais detalhes hardcore sobre como o Windows Subsystem for Linux é de fato implementado, eu recomendo essa série de posts no blog do próprio MSDN:

* [Windows Subsystem for Linux Overview](https://blogs.msdn.microsoft.com/wsl/2016/04/22/windows-subsystem-for-linux-overview/)
* [Pico Process Overview](https://blogs.msdn.microsoft.com/wsl/2016/05/23/pico-process-overview/)
* [WSL System Calls](https://blogs.msdn.microsoft.com/wsl/2016/06/08/wsl-system-calls/)
* [WSL File System Support](https://blogs.msdn.microsoft.com/wsl/2016/06/15/wsl-file-system-support/)
