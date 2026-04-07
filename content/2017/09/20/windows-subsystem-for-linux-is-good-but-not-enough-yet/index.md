---
title: "Windows Subsystem for Linux é Bom, Mas Ainda Não Suficiente"
date: '2017-09-20T14:43:00-03:00'
slug: windows-subsystem-for-linux-e-bom-mas-ainda-nao-suficiente
translationKey: windows-subsystem-linux
aliases:
- /2017/09/20/windows-subsystem-for-linux-is-good-but-not-enough-yet/
tags:
- windows
- wsl
- manjaro
- nvidia
- mac
- microsoft
- apple
- traduzido
draft: false
---

Em julho de 2016 escrevi um post precipitado intitulado ["The Year of Linux on the Desktop - It's Usable!"](http://www.akitaonrails.com/2016/07/26/o-ano-do-linux-no-desktop-esta-usavel) e, de fato, ele era (mal e mal) utilizável.

O verdadeiro "Ano do Linux no Desktop" ainda não chegou. Mas está chegando, como vou explicar.

**TL;DR** este não vai ser 'mais-um-post-de-instalação-do-WSL', já existem vários por aí, por exemplo [este](https://medium.com/xtrememl/why-how-to-use-windows-10-wsl-built-in-linux-for-machine-learning-6a225f4bbd3a) ou [este outro](https://www.neowin.net/news/bash-plus-windows-10-equals-linux-gui-apps-on-the-windows-desktop). E você sempre pode [pesquisar no Google](http://lmgtfy.com/?q=windows+10+creator+update+install+WSL).

No início de 2016 a Microsoft anunciou e lançou uma versão bem alpha do que viria a ser o Windows Subsystem for Linux (WSL). Ele inicializava e rodava alguns programas, mas era cheio de bugs. Justo, afinal era ainda apenas um preview para Insiders (aliás, evite builds do Insider Preview, eles travam com tela azul o tempo todo, é desenvolvimento ativo).

Um ano se passou, chegamos ao Windows 10 Anniversary Update e, finalmente, ao tão esperado **Creators Update**. A evolução foi significativa.

Se você não sabe o que é o WSL, recomendo muito que leia os [artigos no blog de desenvolvedores da Microsoft](https://blogs.msdn.microsoft.com/wsl/) e o excelente post da Jessie Frazelle, [Windows for Linux Nerds](https://blog.jessfraz.com/post/windows-for-linux-nerds/). Em resumo: o WSL intercepta as system calls do kernel do Windows e as mapeia como system calls do kernel Linux, enganando binários ELF64 não modificados para que rodem como se estivessem num sistema Linux de verdade. O detalhe crucial é que não há nenhum kernel Linux rodando! Ele também encapsula serviços do Windows como sistema de arquivos e rede em dispositivos que o Linux consegue acessar.

Portanto, não é virtualização. Não existe Hyper-V envolvido. É o Windows executando binários ELF64 diretamente, sem recompilação, sem modificação.

Diferentemente do OS X, onde é preciso ajustar o código-fonte e recompilar para rodar no Darwin (a camada Mach/BSD do sistema), aqui dá para baixar binários Ubuntu (ou de qualquer outra distro — Fedora e SUSE estão chegando em breve à Windows App Store) e executá-los **diretamente**.

Melhor ainda: dá para rodar daemons de sistema (sim, PostgreSQL, Memcached, Redis, etc. todos carregam e rodam em background) e até programas com interface gráfica via X!

Não me entendam mal, tenho o maior respeito por quem trabalha duro na Microsoft para fazer isso acontecer. É um feito técnico notável por si só.

![Windows e X lado a lado](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/657/2017-09-14.png)

Olhem bem para esse screenshot. É algo digno de admiração: GNOME-VIM nativo rodando lado a lado com o Microsoft Edge carregando um site servido por uma aplicação Rails dentro do WSL, acessando o PostgreSQL.

Mas será que funciona bem para o dia a dia?

### O WSL é bom de verdade?

**TL;DR** não chega nem perto de ser tão fluido quanto rodar uma distro Linux pura, e a integração está longe de ser tão boa quanto o OS X em termos de usabilidade — o Windows simplesmente não foi redesenhado de forma significativa para ser um sistema UNIX como o OS X.

Num mundo ideal, o Windows substituiria toda a base NT e construiria sua própria infraestrutura inspirada em BSD (como o Darwin) ou criaria uma distro Linux própria usando o kernel Linux pronto (provavelmente inviável por causa da GPL).

Mas isso é irreal. A Apple conseguiu fazer isso numa época em que a base instalada de Macs era pequena, então alienar alguns usuários não custava tanto. O Windows é grande demais para falhar. É e continuará sendo um pesadelo de manutenção de proporções épicas.

Dito isso, o WSL em si é um milagre, então não tenho como reclamar. A Microsoft teve uma década realmente difícil na virada do século. O Windows 10 é uma volta por cima, e depois de duas grandes iterações está finalmente se tornando razoável de novo. Talvez estejamos a mais algumas atualizações de um WSL realmente utilizável. Só o tempo dirá.

A Apple teve seu milagre na virada do século, e o OS X e o iOS são sistemas operacionais excelentes. Os melhores da categoria. E conseguir reiniciar um ecossistema inteiro do zero não é algo que qualquer empresa consegue fazer.

As distros Linux tiveram seus altos e baixos. Nenhum ecossistema evolui de forma saudável e coesa sendo tão fragmentado. Mas cada distro principal conseguiu forçar seu próprio ecossistema na marra. A Canonical sobreviveu onde muitas falharam, mas ainda não é a vencedora definitiva, e dá a impressão de que está [perdendo o fôlego](https://arstechnica.com/information-technology/2017/04/ubuntu-unity-is-dead-desktop-will-switch-back-to-gnome-next-year/). A RedHat aproveitou a febre do dot-com e conseguiu voar alto no mercado corporativo. Não existe distro "melhor". É, de novo, uma questão de gosto e ego, na maior parte do tempo para a maior parte das pessoas.

E a comunidade OSS ainda desperdiça uma quantidade absurda de tempo em disputas sem sentido, como a [controvérsia do Systemd](https://www.reddit.com/r/linuxmasterrace/comments/616wxo/what_is_with_all_the_controversy_with_systemd/) ou o tempo que está levando para abandonar o X e finalmente migrar para o Wayland. OSS tem prós e contras, como tudo o mais.

Mas voltando ao WSL, antes que eu me perca. Sim, como prometido, quase tudo que se faz num Ubuntu 16.04 nativo pode ser feito nesse novo ambiente. Até o ridículo `cmd.exe` foi bastante atualizado para o século XXI. Ainda está longe de um Terminal padrão do Linux ou OS X, mas está chegando lá. Na prática, eu recomendaria instalar o [WSL Terminal](https://github.com/goreliu/wsl-terminal) como substituto, e apesar do nome terrível "Bash on Ubuntu on Windows", eu recomendaria instalar o ZSH em vez do Bash para ter mais recursos de usabilidade.

Dá para pesquisar tutoriais sem fim sobre como personalizar o ambiente, Vim, ajustar o PostgreSQL, etc. Então não vou repetir isso aqui. Um aviso importante: tenho que rodar `sudo /etc/init.d/PostgreSQL start` para iniciar os daemons. Eles não sobem automaticamente depois de reiniciar o sistema — guarde isso.

Também dá para instalar um servidor X no Windows, como o [xming](https://sourceforge.net/projects/xming/), fazer `export DISPLAY=:0` e então `sudo apt install gvim` para carregar a versão gráfica do Gvim, por exemplo. Ou um desktop GNOME ou XFCE completo, se for o seu negócio. Dá para rodar aplicações X lado a lado com apps Windows, e isso é muito legal. Gosto de instalar o [YADR](https://github.com/skwp/dotfiles), aquela coleção de dotfiles supercustomizada, e ele funciona bem.

Estou usando o [ASDF](https://github.com/asdf-vm/asdf) para instalar e gerenciar múltiplas versões de Ruby, Node.js, Elixir, etc. E também funciona.

Consegui mover minhas chaves SSH da instalação anterior do [Arch Linux](http://www.akitaonrails.com/2017/01/10/arch-linux-a-melhor-distro-de-todas). E aí consigo clonar os repositórios Git normalmente. E aqui vem o **grande problema**. Clonei e configurei um projeto Rails. Este é o melhor resultado que consegui rodando toda a suíte RSpec com testes de aceitação usando PhantomJS:

```
Finished in 5 minutes 35 seconds (files took 48.53 seconds to load)
888 examples, 0 failures
```

Isso rodando no meu [Dell XPS 9550](http://www.akitaonrails.com/2017/01/31/do-macbook-pro-para-o-dell-xps-arch-linux-para-usuarios-criativos) com Core i7 Skylake (4 cores, 8 threads), 16 GB de RAM e SSD NVME2. Pedi a um colega para rodar no Mac Mini dele, de 2012, com Core i5 (provavelmente Haswell), 10 GB de RAM e SSD normal. Este foi o resultado dele:

```
Finished in 3 minutes 37.6 seconds (files took 9.73 seconds to load)
888 examples, 0 failures
```

Sim, chocante. A emulação do sistema de arquivos é [notoriamente lenta](https://meta.discourse.org/t/installation-notes-for-discourse-on-bash-for-windows/48141/3?u=sam) no WSL (pelo menos 4 vezes mais lenta, como se vê nos números acima).

Este outro teste rodou num hardware um pouco mais novo (ainda bem inferior ao meu Dell XPS) com Linux Mint:

```
Finished in 3 minutes 2.4 seconds (files took 22.69 seconds to load)
888 examples, 1 failure
```

Rodei a mesma suíte algumas vezes para confirmar, mas não consegui passar da marca de 5 minutos, e o carregamento de arquivos fica sempre em torno de 1 minuto, enquanto em outros sistemas operacionais é de 2 a 4 vezes mais rápido.

Se o seu fluxo de desenvolvimento é intensivo em I/O, você vai sofrer. A compilação do Webpack, que já é lenta, fica ainda mais lenta. Npm/Yarn demora uma eternidade. Instalar coisas a partir do código-fonte é muito devagar.

Não chega a ser inutilizável, mas essa lentidão vai cansar rápido.

### E a Virtualização?

Depois de ver a performance de sistema de arquivos deplorável descrita acima, pensei: _"e quanto a rodar tudo no bom e velho Virtualbox?"_

Em teoria, o WSL "deveria" ser uma camada mais fina que o Virtualbox, mas o grande vilão em termos de overhead parece ser a camada de abstração do sistema de arquivos, e não necessariamente o acesso a CPU ou RAM. Meu instinto inicial diria que um Virtual Drive — um único arquivo montado como HD virtual — teria um desempenho bem melhor.

Então lá fui eu instalar o Virtualbox com o mesmo conjunto de ferramentas (asdf, etc.).

Montar uma pasta compartilhada diretamente para o equivalente no WSL não funciona direito; parece que o protocolo de montagem não entende dot files, então eles simplesmente não aparecem. É preciso compactar a pasta com tar e descompactar dentro da máquina para preservar arquivos ocultos e permissões.

Rodando a mesma suíte RSpec no Virtualbox com 4 Cores (dos 8 que minha máquina tem) e 4GB de RAM:

```
Finished in 2 minutes 3.4 seconds (files took 6.33 seconds to load)
888 examples, 2 failure
```

Então fomos de 5:35 min para 2:03 min e o carregamento de arquivos de 49 segundos para 6 segundos! Cerca de 2,5 vezes mais rápido na execução e nada menos que 8 vezes mais rápido no carregamento de arquivos! É absurdo, mas faz todo sentido. Minha máquina de 2016, dentro do Virtualbox, ainda supera hardware bare-metal de 2011/2012. E o WSL fica na última posição.

Esqueça benchmarks sintéticos — este é um caso real misturando execuções bound em CPU e I/O. Só para comparar, tentei ver se conseguia mais desempenho rodando no VMWare Workstation. O resultado:

```
Finished in 2 minutes 3.3 seconds (files took 6.21 seconds to load)
```

Praticamente idêntico. Para mim, isso mostra que o Virtualbox percorreu um longo caminho para se igualar a soluções comerciais historicamente mais robustas como VMware e Parallels, então fico com o Virtualbox por enquanto.

Fiz outro teste: instalação do Ruby 2.4.2 a partir do código-fonte usando `asdf`. Primeiro no WSL (rodando com `time`):

```
229.38s user 244.59s system 113% CPU 6:57.51 total
```

E a mesma instalação no Virtualbox:

```
295,39s user 22,43s system 135% CPU 3:53,87 total
```

Mais uma vez, cenário misto de CPU e I/O. No Virtualbox sou pelo menos duas vezes mais rápido.

Se quiser ver cenários mais controlados com benchmarks sintéticos, recomendo ler [o artigo do Phoronix sobre WSL vs Virtualbox](http://www.phoronix.com/scan.php?page=article&item=intel-7900x-wsl&num=1).

### O Dilema do "Ano do Linux no Desktop"

A falta de software comercial é um problema, e uma das causas é a ausência de compatibilidade binária retroativa.

Apesar de todos os seus problemas, a Microsoft manteve compromisso com um conceito muito difícil: dá para executar binários não modificados do Windows 95 no Windows 10 atual. Na maioria das vezes eles "simplesmente funcionam". Nas distros Linux, todo binário é compilado contra cabeçalhos de biblioteca muito específicos — o próprio kernel, Glibc e muitos outros. Sempre que um desses muda, todos os binários precisam ser recompilados. É por isso que existe o conceito de "distros", onde se recompila e testa um conjunto completo de softwares. O Long-Term Support (LTS) é basicamente travar as versões dessas dependências por alguns anos para que o software rode sem precisar recompilar tanto. Mas em distros de ponta, é inevitável recompilar muita coisa várias vezes.

O Windows carrega os binários de dependências antigos consigo. O OS X faz o mesmo em certa medida. E o OS X vai além, com o conceito de "fat binaries" (ou "Universal Binaries"), onde um pacote contém múltiplos binários voltados para diferentes arquiteturas de hardware (32-bit vs 64 bit, Intel vs ARM vs PowerPC).

Principalmente por causa desse suporte, aplicações comerciais complexas como o Office ou o Creative Suite da Adobe conseguem rodar em muitas máquinas diferentes, em versões diferentes do sistema operacional, por muitos anos sem precisar atualizar. Nas distros Linux, binários são uma dor de cabeça. É por isso que ter o código-fonte disponível é tão importante — e esse é um debate filosófico sobre o conceito do "Software Livre" como concebido por Richard Stallman.

É um dilema sem solução. Distros Linux não têm compatibilidade binária retroativa nativa. Desenvolvedores precisam contar com ferramentas como o [ABI Compliance Checker](https://lvc.github.io/abi-compliance-checker/) e tentar usar [symbol versioning](http://www.airs.com/blog/archives/220) do glibc, entre outros recursos. Mas não é realista esperar que voluntários contribuindo com seu tempo livre para o código aberto mantenham versões antigas de software por muitos anos. É um compromisso justo. Quer o melhor, o mais rápido, o mais seguro? Atualize frequentemente, mas aceite que software antigo e não mantido vai quebrar.

Portanto, sem liberar o código-fonte, não dá para ter binários compatíveis e bons em cada grande distribuição, em versões diferentes, ao longo de muitos anos.

### Qual é o certo para você?

Não adianta tentar fazer benchmark de sistemas operacionais. Todos são geralmente bons o suficiente.

Macs são mais caros (às vezes por uma diferença absurda de mais de um milhão de reais). Não tem como negar. O compromisso é que o hardware da Apple, o OS X e o ecossistema são geralmente os melhores no geral, e o "acabamento" dos produtos costuma ser de fato superior do ponto de vista de experiência de uso.

Para a melhor combinação de software mainstream com software open source, não existe alternativa melhor. Se puder comprar um Mac, compre um Mac.

Quem é gamer precisa ficar com o Windows. Sem discussão. Os melhores jogos estão no Windows, ponto. A melhor combinação de hardware suporta Windows. Nenhum ajuste no Linux vai te dar o desempenho bruto necessário para extrair 4K a 60fps das novas GPUs AMD e NVIDIA via DirectX. O hardware Mac tem limitações e não aceita as GPUs mais novas. Se quer jogar os últimos jogos AAA do jeito que foram projetados para rodar, monte um hardware personalizado com Windows 10.

Desenvolvedores web têm mais sorte. Não tem como errar — é literalmente questão de gosto qual sistema operacional escolher. Dá para entregar os mesmos resultados usando as mesmas ferramentas. E a não ser que você precise de infraestrutura específica Microsoft (SQL Server, Active Directory, etc.), instala qualquer distro Linux e fica feliz.

Desenvolvedores de apps desktop precisam pensar no público-alvo. Se quer construir apps desktop Windows, tem que estar no Windows. Mas dá para usar .NET/Xamarin ou Java para construir binários cross-platform. O problema é que, idealmente, precisam ter os três sistemas para garantir que o software se comporta como esperado.

Desenvolvedores mobile também têm azar. Android dá para fazer no Windows ou Linux, mas para desenvolver para a App Store da Apple é preciso ter Mac. Não tem como escapar disso, e boa sorte esperando a Apple liberar suas ferramentas para outras plataformas.

Profissionais criativos podem escolher entre Windows e OS X. Depende das ferramentas. Se você usa Adobe, qualquer um serve bem, mas provavelmente vai querer uma workstation personalizada. Até a Apple remodelar o ridículo Mac Pro, não encontrará o melhor hardware pelo preço na Apple. O iMac 5K atual é bom, mas acima disso não tem opção. Por exemplo, se precisar de 2 GPUs NVIDIA Titan ou Quadro rodando em paralelo, a Apple não vai ajudar.

Se o fluxo de trabalho exige Final Cut Pro, Logic Pro, Motion 5, a melhor opção disponível é o iMac 5K.

Eu não sou mais desenvolvedor em tempo integral. Divido meu tempo gerindo uma empresa, fazendo apresentações, experimentando tecnologia e pesquisando. Meu setup ideal seria um MacBook Pro. Mas estou me forçando a viver fora do ecossistema Apple, e dói. Meu lado desenvolvedor web fica feliz no Linux (Manjaro GNOME é meu favorito atualmente). Mas quando o lado criativo precisa de ferramentas, Gimp, Inkscape, Kdenlive simplesmente não chegam lá. Estou muito acostumado com Photoshop, Illustrator, Final Cut/Premiere, Motion 5/After Effects. O LibreOffice Impress é terrível para apresentações complexas, e os slides baseados em HTML/JS servem para coisas simples. Tente fazer gráficos e animações sérias lá e você vai sofrer demais.

{{< youtube id="a59U6kRJHLg" >}}

Se você é um criativo, **precisa** de telas com calibração de cores (espaço Adobe RGB), precisa de poder de processamento bruto para renders rápidos e pós-processamento avançado. Editores de vídeo Adobe vão preferir Windows. Editores Final Cut são bem atendidos nos Macs, mesmo que o sistema de refrigeração dos novos MacBook Pros seja terrível:

{{< youtube id="6TWbXV5xeYE" >}}

E se você é editor de vídeo em tempo integral, pode pagar tanto por um PC quanto por um Mac de ponta, então a disputa fica pequena.

Se você é editor de vídeo com orçamento limitado, **não vai** ter um bom fluxo de edição 4K no Linux, ponto. O suporte para explorar o potencial total das GPUs modernas é fraco, não há bom suporte a Cuda ou OpenCL, e a maioria das ferramentas de edição não os utiliza. O Blender — que é primariamente uma ferramenta de modelagem 3D e animação — é considerado uma das melhores ferramentas de edição de vídeo disponíveis no Linux, o que já diz muito. O estado lamentável do suporte a GPU no Linux compromete o uso criativo. A única outra ferramenta de edição não-linear que consegue atingir fluxos de trabalho profissionais é o [LightWorks](https://www.linux.com/learn/pro-level-video-editing-lightworks-linux), que não é open source, requer os binários proprietários da NVIDIA e [custa dinheiro](https://www.lwks.com/index.php?option=com_shop&view=shop&Itemid=205).

Se for por esse caminho, provavelmente é melhor ficar com Windows ou OS X por enquanto.

### Conclusão

Me perdi um pouco no meio do caminho, mas a conclusão é simples:

* O WSL ainda não chegou lá. Precisamos esperar mais algumas atualizações. Quando você ouvir que melhoraram a abstração do sistema de arquivos em algumas ordens de magnitude, aí sim vale tentar de novo. E lembre-se que existem toneladas de [issues abertas](https://github.com/Microsoft/BashOnWindows/issues), então os resultados variam muito.
* Se você é desenvolvedor web, está seguro em qualquer distro Linux.
* Se você é um profissional misto, precisando tanto de ferramentas de desenvolvimento quanto de ferramentas criativas, use Mac ou Windows 10 com uma distro Linux totalmente virtualizada.
* Se é gamer, Windows.
* Se é profissional criativo em tempo integral, tanto Macs quanto PCs servem bem.

Por enquanto vou ficar com meu Dell XPS rodando Windows 10 e Manjaro GNOME no Virtualbox. O Virtualbox é rápido o suficiente para não prejudicar meu fluxo de trabalho. E as ferramentas criativas conseguem aproveitar os núcleos CUDA da minha NVIDIA sem problema, então consigo renderizar no Blender e fazer o Premiere processar vídeo 4K em tempo razoável.
