---
title: "[Akitando] #42 - Entendendo Apple, GPL e Compiladores"
date: '2019-03-06T17:00:00-03:00'
slug: akitando-42-entendendo-apple-gpl-e-compiladores
tags:
- apple
- android
- swift
- objective-c
- java
- kotlin
- mobile
- llvm
- clang
- freebsd
- compiladores
- emscripten
- webassembly
- asm.js
- v8
- rust
- software livre
- GPL
- GCC
- akitando
draft: false
---

Disclaimer: esta série de posts são transcripts diretos dos scripts usados em cada video do canal [Akitando](https://www.youtube.com/channel/UCib793mnUOhWymCh2VJKplQ). O texto tem erros de português mas é porque estou apenas publicando exatamente como foi usado pra gravar o video, perdoem os errinhos.


<iframe width="560" height="315" src="https://www.youtube.com/embed/suSvMnNwV-8" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


### Descrição no YouTube

Finalmente! Chegamos no episódio 42!

Se você é geek que nem eu sabe que 42 é um número especial. Segundo o sábio profeta Douglas Adams o número 42 é a resposta da vida, do universo e de tudo. Se não acreditam leiam a bíblia do Guia do Mochileiro das Galáxias. De curiosidade é por isso que minha empresa se chama Codeminer 42. E em especial este ano eu vou completar meus 42 anos. Mas chega de numerologia, vamos começar a história de hoje.

Hoje vamos fugir um pouquinho do tema de Back-end, que pretendo retomar semana que vem. Desta vez quero contar uma história que eu pessoalmente acho interessante. Vou falar sobre Apple, sobre licenças de software livre, sobre compiladores, um pouco do mundo mobile e um pouco do mundo web de novo. É uma história meio complicada mas que vai ajudar vocês a entenderem um pouco da dinâmica de como o mundo real afeta a evolução e adoção de linguagens e tecnologias. 

Errata: várias vezes no vídeo eu falo "SpiderMonkey" mas eu queria dizer "JavascriptCore". A SpiderMonkey é a engine de Javascript do Firefox, a JavascriptCore que é a engine que vem no WebKit e Safari. E o V8 é o do Chrome.

Errata 2: Eu falo que GPL é General Protection License, mas na verdade é General Public License.

Errata 3: me avisaram nos comentários e eu realmente comi bola quando falei dos emuladores de Android. Antigamente as imagens do OS eram realmente só de ARM mas hoje em dia de fato já existem imagens compilados pra x86, então em um Virtualbox habilitado pra usar os recursos de virtualização dos processadores AMD e Intel como o VT-X é possível acelerá-los. Ainda não é a mesma coisa que no MacOS/iOS que é um simulador sem necessidade de camada de virtualização, mas não deixa de ser um avanço. 

Links:

* Why WebAssembly is Faster Than asm.js (https://hacks.mozilla.org/2017/03/why-webassembly-is-faster-than-asm-js/)
* Awesome Wasm (https://github.com/mbasso/awesome-wasm)
* Swift is like Kotlin (http://nilhcem.com/swift-is-like-kotlin/)
* THE CASE THAT NEVER ENDS: ORACLE WINS LATEST ROUND VS. GOOGLE (https://www.wired.com/story/the-case-that-never-ends-oracle-wins-latest-round-vs-google/)
* Facts and effects of Caldera/SCO vs IBM (https://www.computerweekly.com/feature/Facts-and-effects-of-Caldera-SCO-vs-IBM)
* A new GCC runtime library license snag? (https://lwn.net/Articles/343608/)
* A visual timeline of the Microsoft-Novell controversy (https://arstechnica.com/information-technology/2007/01/linux-20070128/)
* The Microsoft-Novell Linux deal: Two years later (https://www.infoworld.com/article/2654097/the-microsoft-novell-linux-deal--two-years-later.html)
* An Introduction to Tivoization (http://www.linfo.org/tivoization.html)
* Linus Torvalds, Dual-Licensing Linux Kernel with GPL V2 and GPL V3 (https://lkml.org/lkml/2007/6/13/289)
* An insider's look at drafting the GPLv3 license (https://opensource.com/article/18/6/gplv3-anniversary)
* Apple’s great GPL purge (http://meta.ath0.com/2012/02/05/apples-great-gpl-purge/)
* Apple Invests in LLVM, Suggests Merge with GCC (https://www.osnews.com/story/12715/apple-invests-in-llvm-suggests-merge-with-gcc/)
* Arquitetura LLVM (https://www.aosabook.org/en/llvm.html)
* What is LLVM? The power behind Swift, Rust, Clang, and more (https://www.infoworld.com/article/3247799/what-is-llvm-the-power-behind-swift-rust-clang-and-more.html)

## Script

Olá pessoal, Fabio Akita

Desta vez vamos dar uma pequena pausa na série Começando aos 40. Vocês já viram dois episódios falando sobre back-end e o assunto ainda não acabou, mas pra quebrar um pouco decidi fazer uma longa tangente hoje e falar sobre um tema cabeludo que envolve o mundo de software livre, a Apple e compiladores. É até difícil definir que tema é esse exatamente. Tem a ver com compiladores e linguagens mas não é só isso. Mas é uma história que eu acho fascinante e queria compartilhar com vocês. 

Além disso hoje finalmente estou completando o episódio 42. Se você é geek que nem eu sabe que 42 é um número especial. Segundo o sábio profeta Douglas Adams o número 42 é a resposta da vida, do universo e de tudo. Se não acreditam leiam a bíblia do Guia do Mochileiro das Galáxias. De curiosidade é por isso que minha empresa se chama Codeminer 42. E em especial este ano eu vou completar meus 42 anos. Mas chega de numerologia, vamos começar a história de hoje.


(...)



Como vocês viram nos vídeos passados, acho que deu pra entender que a Microsoft foi um rolo compressor nos anos 90 empurrando tecnologia atrás de tecnologia, boas ou ruins. Depois ela foi bruscamente parada no começo do século por causa do julgamento anti-truste. E de 2001 até pelo menos 2014, quem calçou seus sapatos de certa forma foi a Apple. Sem repetir muito o que todo mundo já sabe vamos resumir: em 1999 os iMacs translúcidos de plástico colorido foram um enorme sucesso pra marcar o retorno de Steve Jobs, numa época onde a Apple estava a dias de fechar as portas e declarar falência. Em 2001 surgia o Mac OS X baseado no NextStep e BSD UNIX, também em 2001 o iPod conquistou o mundo, em 2003 o iTunes conquistou o mundo. 


Em 2005 com a ascendência do Ruby on Rails e a preferência por Macs de seu criador fez com que a comunidade Rails e o gosto pela estética da Apple andassem lado a lado. De 2005 a 2006 a Apple migrou dos processadores PowerPC pra Intel e de repente todo mundo queria usar Macs pra desenvolvimento já que ele era um sabor de BSD UNIX. Diversas ferramentas que só existiam em Linux passaram a ser portados. Gerenciadores de pacotes como Fink, MacPorts e hoje HomeBrew começaram a surgir. E mais importante, Ruby vinha pré-instalado nos Macs, facilitando ainda mais a adoção inicial. 


Por duas vezes a Apple não só passou ilesa como explodiu em crescimento no meio de duas grandes crises. Em 2001 ela lançou seu iPod bem na queda da Crash das Ponto Coms, um dos piores episódios da história da Internet. E em 2007 os iPhones aparecem, 1 ano antes da famosa crise econômica de 2008 que muitos diziam que poderia ser o fim do mundo, e você pode assistir em filmes recentes como o incrível The Big Short. Mesmo em meio a essa crise, em 2009 a App Store vai ao ar inaugurando a era do desenvolvimento mobile e todo mundo quer aprender Objective-C agora, validando o estilo de orientação a objetos que já era mais familiar a quem usava Ruby do que quem usava Java. A Apple forçou a evolução da Web em direção à morte do Flash, e ao HTML 5 e CSS 3 que rodavam melhor nos seus navegadores Safari. E com o nascimento do MobileMe que foi o serviço online de cloud da Apple; nasceu o framework javascript SproutCore, que depois viria a se tornar Ember, inaugurando o estilo de produtos Web que conhecemos hoje.


Pós crise de 2008 e 2009, todo mundo queria desenvolver produtos mais sofisticados, com linguagem visual limpa, com a usabilidade que a Apple era lendária por oferecer em seus produtos. Mesmo antes disso, enquanto o mundo enterprise estava adotando soluções J2EE como o IBM Websphere ou BEA Weblogic a própria Apple tinha uma arquitetura mais simples e mais sofisticada na forma do WebObjects que era o motor por trás do lendário e-commerce da Apple na época. Uma pena que o WebObjects nunca teve real tração. Toda essa experiência trouxe a Apple como uma das maiores influenciadoras das tecnologias da época. E isso coincidiu com o pior período da história da Microsoft pós-processo dos Estados Unidos contra suas práticas monopolistas depois da Guerra dos Navegadores, então a Apple praticamente não teve competição.


Voltando ao nosso tema de programação e linguagens, entenda que 2006 e 2007 foram anos interessantes pro mundo dos compiladores por três motivos: a migração da plataforma de Macs para Intel, o lançamento do iPhone e a migração no mundo de software livre da famosa licença GPL v2 para o controverso GPL v3. Esses três acontecimentos, na minha opinião, influenciaram muito o landscape de desenvolvimento de software entre os mundos comercial e de software livre, e eu acho que ainda não vimos tudo que pode sair disso até hoje.


No ano 2000 um novo projeto começou a aparecer como uma pesquisa, o Low Level Virtual Machine de Chris Lattner e Vikram Adve. Em resumo essa tecnologia se tornou um compilador modular que chamamos de LLVM apesar de não ser de fato uma máquina virtual como uma JVM. O monopólio dos compiladores, principalmente no mundo open source, era basicamente do GCC, responsável por compilar os códigos em C, C++ e várias outras linguagens, incluindo coisas como Fortran, e que gera o binário da kernel Linux e todas as ferramentas de licença aberta que rodam ao seu redor nas distribuições Linux. Mas o GCC é um grande monolito, com mais de 25 anos de contribuições e evoluções, complicado de evoluir, expandir e integrar. Porém com décadas de refinamento e ajustes, é definitivamente um dos melhores compiladores do mercado. 


O LLVM foi criado pra ser diferente, ele separou o processo de compilação em 3 grandes estágios, front-end, otimização e back-end. Não confundir com as carreiras de front-end e back-end. Pense na entrada do compilador que é o front, o miolo, e a saída do compilador que é o back, Vale a pena eu explicar o que isso significa. Em resumo, o front-end pega o seu código fonte, digamos em C, e faz a checagem e o parsing. O resultado desse estágio é seu código limpo e traduzido em outra linguagem intermediária, chamada literalmente de Intermediate Representation ou IR. Não seria muito diferente do Java gerando bytecodes ou do .NET que gera em IL pro CLR que é literalmente Intermediate Language. Também meio parecido com o que um transpiler de Coffeescript ou Dart ou Typescript faz transformando em Javascript por baixo. Na sequência esse código em IR passa pelo tal miolo, a fase de otimização, que vai fazer todas aquelas otimizações que eu expliquei no episódio anterior pra deixar seu código o mais eficiente possível. Inclusive como o GCC e outros compiladores, essa fase pode precisar “passar” pelo código múltiplas vezes, você às vezes vai ver esse termo “passes” porque algumas otimizações exigem conhecimento do código anterior. Finalmente o LLVM pega esse sub-produto otimizado e passa pro back-end, que vai finalmente traduzir em binário de máquina, gerando o executável do seu programa. Mas o importante é entender que existem 3 grandes pedaços de software independentes que, juntos, formam o compilador.


Então, em vez de usar GCC pra compilar C, você pode substituir por Clang que é um front-end de C feito pra LLVM. Teoricamente hoje você poderia tirar o GCC e recompilar uma distribuição Linux inteira usando Clang, até existem projetos testando isso. Por muitos anos, fazer o LLVM cuspir um binário tão otimizado quanto o de GCC foi bem difícil. E também havia a questão: pra que eu quero substituir o GCC se ele já funciona tão bem?


Em 2005 a Apple fez um de seus movimentos mais interessantes e pouco comentados e contratou Chris Lattner, que na época estava em início de carreira na Microsoft Research. Em 2006 Steve Jobs sobe ao palco na conferência WWDC e anuncia a transição da plataforma Mac dos processadores IBM PowerPC para Intel, mais especificamente a nova linha de processadores Intel Core. O sistema operacional OS X 10.4 Tiger foi o primeiro compilado ainda com GCC pra rodar tanto em PowerPC quanto Intel. 


Mas em 2007 teríamos a sequência com o OS X 10.5 Leopard e o XCode 3.1, a IDE de desenvolvimento pra Mac e junto com ela viria o compilador GCC 4.2 e junto o LLVM integrado ao code generator do GCC, que foi conhecido como LLVM-GCC. O XCode 4.1 da época do Mac OS X Lion de 2011 foi o último a vir com o GCC como compilador, e de lá em diante o desenvolvimento em MacOS e iOS depende só do Clang. Ou seja, de 2006 até 2008 os produtos com processadores PowerPC foram todos migrados para Intel. Mas mais importante que isso, o compilador GCC foi sendo gradativamente substituído por Clang, a partir de 2007 até pelo menos 2011. Guarde essa informação.


No começo do século um novo tipo de produto começou a fazer um sucesso estrondoso. Lembra quando eu contei qual era o objetivo original do Java quando ele foi criado no começo dos anos 90? Ser um sistema pra um hardware de set-top-boxes. Ele estava quase uma década adiantado porque foi só nos anos 2000 que esse tipo de produto realmente explodiu, em particular o Tivo. Aqui no Brasil não tivemos Tivo mas tivemos similares. Era aquele produto que você podia gravar programas de TV a cabo pra assistir depois. É o que se chamava de DVR ou Digital Video Recorder, basicamente um receptor de sinal analógico, que digitalizava o vídeo e gravava organizado num HD. Acho que até hoje algumas empresas de TV a cabo ainda oferecem esse tipo de produto. Mas nos Estados Unidos o Tivo teve um sucesso explosivo. Tecnicamente falando ele era um mini-pczinho com uma placa de captura de vídeo que rodava uma versão de distribuição Linux. 


Não é hoje que vou entrar em detalhes sobre licenças de software livra, mas a kernel Linux e a maioria das ferramentas que compõe uma distribuição que forma um sistema operacional completo, as ferramentas GNU, o compilador GCC e tudo mais usavam a licença GPL v2. GPL que significa General Protection License. Na prática, qualquer um, especialmente qualquer empresa que modifique código licenciado via GPL é obrigado a republicar as modificações ao público. O GPL não é uma unaminidade, por isso existem outras licenças, mas a maioria das coisas num Linux costumava ser GPL. E foi o que a Tivo fez: ela seguiu a licença e liberou as modificações que fez. Isso inclusive permitia que hobistas pudessem baixar esse código, fazer suas próprias modificações e carregar no Tivo. Então era como se fosse um PCzinho que dava pra brincar e instalar seus próprios programas.


Pelo menos naquela época, a maioria das empresas não gostava que seus dispositivos fossem modificados pra fazer coisas que não deveriam. Existem motivos pra isso, e nem vou entrar no mérito de certo ou errado, vamos só entender que eles não gostavam. Então na série 2 eles adicionaram um hardware que validava a assinatura do binário. Eu não sei como exatamente eles faziam isso, mas se você é iniciante vale entender pelo menos o conceito básico. Existe uma coisa em computação que chamamos de hashing. Existem algoritmos como os antigos MD5 ou SHA-1 ou os atuais SHA-256 ou bcrypt. Sem entender de criptografia entenda que eles são funções. O argumento de entrada pode ser qualquer bloco de dados, seja texto ou seja um binário. E a saída é sempre um texto de tamanho fixo. 


Isso não é encriptação. Quando se encripta alguma coisa, você consegue reverter o processo e desencriptar. Em hashing não existe forma de pegar o resultado e reverter o processo e conseguir o argumento original. Dois blocos de dados diferentes podem dar o mesmo resultado, isso seria o que chamamos de colisão, mas é raro que isso aconteça num cenário real. O importante é que esse resultado serve como uma impressão digital, um fingerprint, de seja lá qual dado você tenha passado pra função. Ou seja, digamos que você passe o binário do kernel Linux. E o Tivo tem um firmware separado que quando carrega a kernel passa o binário por essa função e compara com a impressão digital que ele tem guardado num hardware que você não pode modificar. 


Ou seja, se você modificou o kernel e instalou lá, a impressão digital vai ser diferente, então o Tivo pode rejeitar esse novo binário e impedir o boot. Essa seria uma forma simplória de fazer isso. Existem formas mais sofisticadas mas esse exemplo deve ajudar a entender parte do processo. Isso seria um tipo de DRM ou Digital Rights Management que a indústria de música adorava. Mas a Tivo achou um loophole no GPL v2, uma brecha na licença. A licença obrigava a liberar o código modificado, e isso eles fizeram, mas ela não fala nada sobre impedir o hardware de rodar código modificado no seu hardware.


Isso foi uma controvérsia gigante porque esse sistema de DRM, do ponto de vista dos desenvolvedores, restringia a liberdade do que o consumidor poderia fazer com o hardware que ele comprou. Isso gerou uma enorme polarização na opinião se uma empresa podia ou não fazer isso. Richard Stallman e Eben Mogler, os criadores da licença GPL ficaram enfurecidos, porque a GPL v2 não conseguia proibir essa atitude. Então eles iniciaram a modificação da GPL v2 para o novo GPL v3 que adicionava cláusulas que impediria isso que eles chamaram de “Tivoização”. E se você acha que o mundo open source apoiou essa medida, você está enganado. Isso gerou uma nova controvérsia e uma nova polarização. Por exemplo, Linus Torvalds odiou a medida e a kernel do Linux permanece na GPL v2.


Como eu já havia explicado no episódio da Lerna vs a ICE, licenças de software livre podem ser divididas em duas grandes categorias: as licenças restritivas e as licenças permissivas. Ao contrário do que o senso comum pode imaginar, o GPL é uma licença restritiva. Licenças como BSD, MIT, Apache e outras são mais permissivas. Em última instância a GPL impõe uma restrição importante: você é obrigado a liberar qualquer modificação que fizer num código GPL e essa modificação também será GPL. E sem cláusulas especiais e sub-licenças como LGPL você teria que se preocupar inclusive, se o binário gerado por um compilador com licença GPL se ela herda o GPL e se pode ser usada livremente ou não. É por isso que inclusive muitos chamam a GPL de uma licença viral. Já código licenciado via BSD por exemplo, não tem essa restrição. Você pode modificar o código e não tem a obrigação de liberar a modificação. Você pode gerar um binário e comercializar o binário e não se preocupar em ter que liberar o código.


A discussão sobre licenças de software livre é em última instância uma discussão sobre propriedade intelectual. A maioria das empresas prefere ficar bem longe de licenças restritivas pra não comprometer suas propriedades intelectuais, que é o que garante o seu valor. Nos anos recentes no começo dos anos 2000 tivemos grandes casos controversos em torno de propriedade intelectual no mundo open source como o famoso caso da SCO ou Santa Cruz Operation que processou a IBM pedindo nada menos que 1 bilhão de dólares, alegando que eles infringiram na sua propriedade do UNIX e usaram esse conhecimento nas contribuições ao Linux que a IBM fazia. 


Se a SCO tivesse ganhado isso teria sido uma bomba nuclear tornando o Linux material radioativo pra quem usasse. Mas numa virada de eventos um juiz determinou que quem possuía os direitos que a SCO clamava na verdade era a Novell. E nessa mesma época por 2005 ou 2006 a Microsoft fechou um acordo de 400 milhões de dólares com a Novell que era dona do Suse Linux, cujo combinado era que uma não iria processar a outra em torno de propriedade intelectual, meio que sugerindo que haveria alguma coisa no Linux que deixaria quem não usasse Suse Linux vulnerável a algum processo no futuro de alguma forma. A comunidade open source odiou esse movimento, claro.


Certo ou errado, vocês podem entender pelo menos porque levar propriedade intelectual e licenças a sério é importante, principalmente nos Estados Unidos. À medida que as empresas iam adotando tecnologias open source, essa dúvida sempre deixa todos com os nervos à flor da pele. Se o Linux, que é a kernel por baixo de todas as distribuições e que estava sendo adotado rápido por todos, fosse condenado num processo desses, ele se tornaria material radioativo e toda empresa usando poderia descobrir uma bomba relógio explodindo. Isso é realmente sério. Se nos anos 2000 alguém perguntasse porque a Apple preferiu usar a base do FreeBSD nos OS X em vez do Linux, esse certamente poderia ser considerado um dos principais motivos: o FreeBSD usa licença BSD que é bem permissivo, ao contrário da GPL que tinha todas essas dúvidas pairando no ar.


Agora, o GPL v3 é um problema sério. Que outra empresa além da Tivo prefere manter certos códigos escondidos e dificultar você de instalar o que quiser em seus hardwares? Eu sempre fui fã da Apple e certamente a integração de hardware e software que eles fazem é excepcional, mas se você pensar puramente em questão de software livre, você vai ficar no mínimo em cima do muro com as práticas da Apple. E não confunda, sim, a Apple tem o código da base do seu sistema operacional aberto ao público na forma do Darwin, mas o MacOS é bem mais que só o Darwin, tem centenas de componentes que eles não querem abrir, incluindo a forma como o sistema se integra perfeitamente nos Macs e Macbook e, claro, nos iPhones de hoje. Se você notou que um iPhone faz a mesma coisa que um Tivo, impedindo você de instalar outro sistema nele, você pensou certo.


No outro lado do espectro, além de distribuições baseadas na kernel Linux, existem as distribuições baseadas em BSD, como FreeBSD, OpenBSD, NetBSD. O Linux é como se fosse um clone de UNIX, mas os BSDs em princípio são herdeiros do UNIX original. BSD seria o concorrente da outra linhagem de UNIX, o System V que deriva da época do UNIX System III da AT&T. Como o próprio nome diz, a filosofia dessas distribuições é Software Livre no sentido mais permissivo e liberal, com a licença BSD. Vamos dizer que eles “toleram” a GPL mas nunca gostaram dela e o GPL v3 foi uma afronta direta e ofensiva pra eles, e podemos dizer que eles não gostaram nada das cláusulas restritivas anti-Tivoização. Existe uma longa história de brigas políticas em torno do que é considerado Software Livre ou não e vou parar por aqui pra não me alongar demais por hoje.


O maior problema? Tudo no mundo open source era compilado com o GCC. Como eu já expliquei no episódio sobre a Lerna vs a ICE, licenças não podem ser mudadas retroativamente, só em novas versões. Como quem controla o GCC é o Richard Stallman, ele migraria pra nova GPL v3. Ou seja, quem não quisesse adotar a nova licença ficaria preso na versão 4 do GCC que ainda seria GPL v2. Então começou uma corrida contra o relógio. Você pode ficar usando o GCC que ainda era GPL v2 mas quanto mais tempo passa, mais ele fica defasado e até inseguro, já que correções e novas funcionalidade só iriam subir no GCC com GPL v3.


Resumo da história? Tanto FreeBSD quanto a Apple começaram um projeto que iria levar alguns anos pra sair do GCC e migrar a compilação de tudo pra usar LLVM e Clang, que era o único concorrente viável ao GCC. Se você alguma vez já se perguntou porque no MacOS vem um Bash tão antigo? Porque além do GCC outras ferramentas GNU mudaram pro GPL v3, o Bash foi um deles. Por isso hoje se instala o Bash mais novo e outras ferramentas com versões mais novas, como o próprio Git, você mesmo via Homebrew ou de outra forma manual como baixar os códigos fonte e gerando binários você mesmo. E por isso às vezes você tem confusão de compilar usando GCC ou Clang.


Pra Apple, além da questão das licenças, a linguagem Objective-C que é o coração dos frameworks de aplicativos nativos de MacOS e iOS nunca teve prioridade no grupo de desenvolvimento do GCC. Por causa disso o projeto Clang começou a avançar a passos mais largos e por isso eles começaram a estratégia de primeiro começar a usar GCC como o front-end pra LLVM, já que a primeira coisa mais difícil era parsear corretamente os códigos em C, C++ e Objective-C e por isso você começa com LLVM-GCC como eu disse antes. À medida que a compatibilidade do front-end entre GCC e Clang ficou mais próxima, daí eles começaram a colocar Clang como escolha padrão até finalmente remover completamente o GCC antigo.


Nesse período de 2006 então a Apple estava migrando seus sistemas operacionais de PowerPC pra Intel e ao mesmo tempo já estava planejando outro dispositivo pra ser lançado em 2007: o primeiro iPhone. E os iPhones não usam processador Intel e sim ARM. E os iPhones seriam sempre produzidos com o bloqueio de DRM pra impedir outro sistema de rodar no hardware, ou seja, eles seriam Tivoizados. E com todos os aplicativos desenvolvidos usando Objective-C e com a necessidade de compilar binários nativos pra Intel e para ARM.


Agora vamos entender outra coisa do LLVM que eu não disse antes. O LLVM é um conjunto modular de bibliotecas. O compilador Clang é um conjunto dessas bibliotecas. Como ele foi desenhado pra ser modular, significa que você teria relativa facilidade de trocar partes do front-end ou do back-end. Por exemplo, você pode fazer back-ends que cospem binários em Intel ou PowerPC ou ARM ou qualquer outro tipo de hardware. E como o front-end também é modular e ele cospe em IR antes de passar pro módulo de otimização, você também tem facilidade de integrar no XCode pra fazer análise estática do código e debug. Com a integração de ferramentas sofisticadas como o famoso DTrace do antigo Solaris e a substituição do debugger GDB que era usado com GCC pelo LLDB, a IDE do XCode foi ficando mais e mais avançada para conseguir instrumentar o código e otimizar muito melhor do que antes.


Ao mesmo tempo que Chris Lattner e sua equipe iam evoluindo o LLVM dentro da Apple, muitas das pesquisas geraram novas funcionalidades primeiro no próprio Objective-C como a introdução de lambdas e o ARC que é o Automatic Reference Counting. Pra você que é iniciante, na maioria das linguagens mais modernas você não pensa muito em gerenciar memória porque linguagens como Java tem garbage collectors, ou seja, o runtime gerencia a memória por você. Mas se você começou a aprender com linguagens como C, sabe que precisa você mesmo codificar o gerenciamento de memória manualmente. Ou seja, no seu código você chama funções como malloc e free e outros pra pedir memória pro sistema operacional e depois devolver essa memória. Lembra que eu falei que além de multi-thread o outro aspecto em programação mais difícil é gerenciamento de memória? 


Pois é, à medida que sua aplicação fica complexa, você vai errar isso. Ao longo da sua carreira você vai ficar ouvindo falar de vazamento de memória por exemplo. Gerenciar memória é complicado, porque memória se fragmenta, você precisa lidar com coisas como regiões, arenas e muitos outros detalhes. Mas se você tem uma máquina potente, digamos, com 8GB de RAM ou mais, você fica preguiçoso e não percebe vazamentos porque tem memória sobrando. Pra facilitar se falta memória RAM o sistema operacional ainda tem a opção de usar o HD como memória. É isso que se chama de SWAP. Se você chega nesse ponto com uma aplicação mal feita que vaza memória, tudo bem, o sistema vai passar a usar HD. Tudo vai ficar lento pra caramba, mas não vai crashear. Mas pense em 2007 um iPhone com meros 128MB de RAM pra comportar o sistema operacional e os aplicativos e sem a opção de um HD pra fazer swap. Ou seja, se faltar memória o sistema vai crashear o aplicativo. Então gerenciar memória se torna especialmente importante em dispositivos com poucos recursos.


E como Objective-C é basicamente compatível com C e usa a mesma semântica de você manualmente codificar onde quer alocar memória e onde quer devolver essa memória, os primeiros aplicativos pra iOS que eram feitos por amadores ou mesmo por descuido acabavam tendo muitos vazamentos e crasheavam dando uma má experiência aos usuários. Por isso recursos como o ARC que foram introduzidos ao Objective-C eram importantes, pra evitar que você precise manualmente escrever código pra gerenciar memória, além da introdução de ferramentas como o DTrace e LLDB pra instrumentar seu código e conseguir analisar exatamente onde estão ocorrendo vazamentos, pra que você consiga consertar antes de mandar o binário final pra App Store.


E como desenvolvedor você ainda tem outro problema grave. Se você já tentou desenvolver pra Android deve ter notado que se quiser testar seu código antes de instalar no celular, a única forma de rodar no seu computador é usando uma máquina virtual. Não estou falando da JVM mas de máquinas virtuais de verdade como QEMU, VirtualBox ou VMWare. Primeiro porque o Android é um sistema operacional baseado em Linux e os binários estão pré-compilados pra processadores ARM. E binários de ARM não são compatíveis com processadores Intel que roda na sua máquina de desenvolvimento, seja PC ou Mac. 


A única forma então é usar um emulador, que é uma máquina virtual, que vai traduzir as instruções de ARM em instruções de Intel. Quando você ouve que seu novo Samsung S10 ou mesmo Xiaomi Mi Mix rodam Qualcomm, você sabe que é um processador ARM. Então você programa seu aplicativo pra Android e sobe um emulador de Android como o da Bluestacks ou Nox ou qualquer outro no seu PC e ele vai emular o Android fazendo ele pensar que está rodando numa máquina ARM. Por isso é tudo tão absurdamente lento pra testar seu código, porque emular exige essa tradução de instruções e isso é lento. Não tem jeito.


Mas se você já desenvolveu pra iOS em Macs sabe que a mesma coisa não acontece quando você pede pra testar seu novo app de iPhone no seu Mac. Seu app roda com velocidade total, sem nenhuma lentidão. E você vai notar no XCode que quando vai rodar seu app no seu Mac de desenvolvimento, não existe uma opção pra subir um Emulador, como no Android, e sim um Simulador. A Apple fez uma coisa difícil mas que se pagou: eles compilam o sistema operacional iOS que roda em iPhone e iPad pra binários de Intel de verdade. Então quando você sobe o simulador, ele não precisa de uma máquina virtual pra traduzir as instruções, ele já é binário de Intel! E quando você compila seu projeto pra rodar no simulador o XCode está usando o LLVM pra cuspir binários de Intel também. Só quando você manda empacotar pra publicar na App Store que ele vai compilar em binário de ARM. Parece uma coisa meio óbvia de fazer, mas fazer isso da forma quase transparente como o XCode faz é impressionante até hoje dado que as ferramentas de desenvolvimento de Android do Google até hoje não fazem isso.


Por outro lado, alguns podem argumentar que apesar das funcionalidades impressionantes que a Apple conseguiu colocar no Objective-C, ele ainda tem a sensação de ser uma linguagem com sintaxe muito velha, especialmente se comparado ao Android onde o Google resolveu copiar a linguagem Java, embora similar ao J++ da Microsoft nos anos 90, ele também não é compatível com a JVM de verdade. O runtime do Android, o Dalvik é diferente. De qualquer forma, já discutimos como a linguagem Java também tem sintaxe considerada meio velha se comparada a coisas como Python ou Ruby ou mesmo Groovy. Mas se comparar com Objective-C - que eu pessoalmente gosto - a maioria vai dizer que prefere Java por estar mais acostumado e ter visto na faculdade.


Enquanto evoluía o LLVM, o Clang, os frameworks de iOS, as tecnologias do XCode, Chris Lattner começou a pensar numa nova sintaxe de linguagem. Assim em 2010 surgia o Swift, uma linguagem que é extremamente agradável ordens de grandeza se  comparado ao Objective-C. E aqui surge outra enorme vantagem do LLVM. Assim como você pode ter back-ends que cospem binários de Intel ou ARM, você também pode ter múltiplos front-end. Você já tinha o front-end que entendia Objective-C, então eles fizeram um novo front-end pra essa nova linguagem Swift. E qual a vantagem? Os binários de ambos Objective-C e Swift são compatíveis entre si. Então seria super fácil você migrar pra Swift e continuar consumindo as mesmas bibliotecas e frameworks que já existiam e eram feitos em Objective-C. Você não precisa reescrever tudo em Swift, pode migrar aos poucos.


Então no mundo de Mac e iOS você tem agora a escolha de usar Swift com sua sintaxe bem mais moderna inspirada em Ruby, Python, Groovy e outras linguagens, com construções modernas, com o ARC pra gerenciar memória e ter a facilidade de rodar sua aplicação iOS em velocidade máxima no simulador de iOS com tudo compilado em binário de Intel e depois facilmente empacotar em binário de ARM pra rodar no seu iPhone de verdade. Por isso muitos desenvolvedores preferem criar apps pra iOS antes de Android até hoje.


No mundo Android as coisas não eram muito agradáveis. O Google também teve sua parcela de dor de cabeça com processo por propriedade intelectual. Lembram que eu já falei várias vezes que a Sun tinha sido adquirida pela Oracle? Então, eles foram processados por usar Java e a Oracle veio atrás com força. Oito anos depois o processo ainda não acabou e em 2018 a Oracle estava ganhando a batalha. Mas todo esse stress não faz o Google ter muito amor pelo Java. Ao mesmo tempo eles decidiram começar a mudar o foco do Java pra outra linguagem, no caso o Kotlin. 


No Android o processo é o seguinte: você escreve seu código em Java e pode usar um compilador normal pra gerar bytecodes Java. Por isso você pode também usar muitas bibliotecas Java que já existem. Daí o bytecode Java é traduzido num segundo conjunto diferente de bytecodes chamado DEX que é o que roda no Dalvik. Antes esse DEX era interpretado no Dalvik, e tinha mais ou menos as mesmas funcionalidades que uma JVM como um Just-in-time compiler ou JIT pra gerar o binário nativo de ARM à medida que era executado. Como eu também já disse, isso é bacana pra aplicativos que rodam num servidor que fica de pé por dias e dias. Mas num dispositivo móvel que você abre um aplicativo e fecha a qualquer momento, um JIT ajuda mas não tanto assim, porque ele não tem tempo pra otimizar como poderia. Fora que rodar um compilador JIT também consome processamento, e isso consome bateria, que é outra coisa que sempre falta em dispositivos móveis.


Então nas versões mais recentes o bytecode DEX é pré-compilado em binário nativo antes de rodar, esse é o processo que você vai ouvir falar como AOT ou Ahead-of-Time compiler. Que é o que um compilador normal como GCC ou Clang fazem: geram binários nativos. O processo de desenvolvimento no Android tem mais passos pra poder ter essa opção de compatibilidade com o bytecode Java, que foi uma jogada importante pra conseguir trazer programadores Java pro mundo Android sem precisar ensinar uma nova linguagem pra todo mundo.


Mas ao mesmo tempo temos a Oracle baforando no cangote do Google e a essa altura já disse várias vezes que Java é uma linguagem que já não é mais considerada agradável de trabalhar e nem tão produtiva se comparado a outras linguagens como o novo Swift. Então o Google foi bater na porta de outra empresa, a JetBrains, que a anos faz uma das melhores IDEs comerciais pro mundo Java, e em 2011 havia começado a criar uma nova linguagem, que assim como Groovy ou Scala ou Clojure também compilam em bytecode compatível com Java. Pro Google foi uma escolha fácil porque eles negociaram pra liberar as ferramentas da JetBrains de graça pra desenvolvedores Android e a evangelizar a nova linguagem deles, que é chamado de Kotlin. Kotlin que é finalmente uma linguagem moderna mas familiar e ser ser exótica demais como Clojure.


Então no mundo mobile, em iOS você ainda pode usar Objective-C que é considerado uma linguagem “velha” mas agora a maior parte do desenvolvimento é na linguagem Swift que é bem mais moderna e produtiva. Mesma coisa no mundo Android onde você ainda pode usar a linguagem Java e as bibliotecas Java que também já é considerado meio “velho” por muita gente mas também pode migrar pro Kotlin que está ainda em adoção por toda a comunidade Android. Você pode até misturar código Kotlin e Java no mesmo projeto. Na verdade, por coincidência, seja porque ambas se inspiraram em fontes parecidas na linhagem de linguagens, Swift e Kotlin tem sintaxes até que similares. Dependendo do código que você ver, pode até quase confundir um pelo outro. Claro, as bibliotecas de iOS e Android são bem diferentes, mas as duas linguagens são igualmente modernas e eu pessoalmente diria que são as melhores até agora para o mundo geral de programação de aplicativos, especialmente se comparar com Java ou C#.


Mas deixando o mundo mobile um pouco de lado, um dos resultados de tudo isso foi a evolução rápida do LLVM enquanto uma solução robusta pra desenvolvimento de compiladores. Em vez de ter que mexer no monolito complicado que é o GCC e ainda ter que lidar com a política da licença GPL v3, você pode ir pro LLVM e foi isso que muita gente fez, menos o Google. Pra ser justo, o Google contribui pro LLVM também mas não usa tão extensivamente quanto a Apple. A linguagem Go eles preferiram criar o compilador do zero, primeiro em C e depois traduzindo o código C no próprio Go. Lembra que eu falo que o Google tem a péssima mania de ficar reinventando a roda? A gente chama isso de NIH ou síndrome de Not-Invented Here, muitos programadores sofrem dessa síndrome de prima-donna de achar que pode fazer melhor que os outros.


Mas já sabemos que C/C++, Objective-C e Swift tem front-ends pra LLVM e sabemos que ele tem back-ends que geram binários pra Intel e ARM. E sabemos que ele tem um design mais moderno, mais modular e com ferramentas mais modernas pra desenvolvedores como o LLDB  que muitos consideram melhor do que o antigo GDB. E ele ficou muito bom em otimizar o IR pra gerar binários nativos quase tão performáticos quanto o GCC. Isso abre uma oceano de possibilidades. E se decidíssemos criar mais front-ends pra outras linguagens?


E foi isso que a comunidade open source começou mesmo a fazer. Hoje temos front-ends de LLVM pra ActionScript, Ada, C#, Common Lisp, Crystal, CUDA, D, Delphi, Fortran, Graphical G, Halide, Haskell, bytecode Java, Julia, Kotlin, Lua, Objective-C, a linguagem de shading de OpenGL, Pony, Python, R, Ruby, Rust, Scala, Swift, e Xojo. 
Mas claro, algumas estão mais avançadas do que outras, algumas são mais experimentais. Algumas usam só algumas funcionalidades como o Just-in-Time compiler do LLVM que é o caso da linguagem Julia e inclusive em lugares inusitados como o banco de dados PostgreSQL que hoje também usa o JIT do LLVM pra otimizar queries complexas.


Uma das linguagens que você mais deve ter ouvido falar que depende de LLVM é o Rust da Mozilla. Agora você sabe o que roda por baixo do Rust e quem gera os binários. A linguagem Rust é uma das mais diferentes de todas que já mencionamos até agora. Sem entrar em muitos detalhes hoje, ela tem um foco maior no problema do gerenciamento de memória combinado com preocupação de segurança. Mas seu maior problema é o que chamamos da ergonomia da linguagem. Apesar de ser uma sintaxe moderna, ela realmente exige mais do desenvolvedor se comparado a um Swift ou Kotlin. Partes do Firefox hoje são escritos com Rust e, adivinhem, alguns evangelistas da linguagem são ex-rubistas também.


Outra linguagem que compila com LLVM que ainda não é muito conhecida mas que eu pessoalmente gosto bastante é a Crystal. Ela se parece muito, mas muito mesmo com Ruby já que é inspirada diretamente nela, e em alguns casos você pode quase copiar e colar trechos de código Ruby e compilar com Crystal sem mexer em nada, então a curva de aprendizado pra quem vem de Ruby é muito mais simples. Ao contrário de Rust a ergonomia da linguagem é muito melhor. Mas Rust tem características que a tornam mais adequadas como substituto de C pra desenvolver código nativo rápido e leve. O Crystal se assemelha mais ao Go, ele tem um runtime maior e um garbage collector maior também. Diferente do Go que tem o investimento infinito Google por trás, o Crystal é um esforço quase voluntário da comunidade, por isso anda mais devagar. Mas graças ao LLVM os binários que o Crystal gera são competitivos com Go mesmo nesse estágio. 


E mesmo sem ser programador você provavelmente usa tecnologias LLVM hoje e nem sabe disso. Por exemplo tanto o SpiderMonkey que é a engine, ou motor, de Javascript do navegador Safari no MacOS e no iOS quanto o V8 que é a engine de Javascript do Chrome possuem a funcionalidade de Just-in-Time Compiler ou JIT que eu mencionei já hoje e no episódio anterior. Repetindo: Javascript é uma linguagem interpretada, como Python ou Ruby. O SpiderMonkey e o V8 recebem o arquivo de texto escrito em Javascript e fazem um parsing e começam a interpretar o código. 


Porém como vocês já sabem e eu expliquei no episódio da História do Front-end nesta série, começou a surgir o conceito de Single Page Application, que é basicamente um site que se comporta mais como um aplicativo de desktop do que um site web normal de conteúdo. Na prática são sites onde você não fica navegando entre diversas páginas, você carrega uma página e fica nela e por sua vez ela carrega muito javascript pra controlar o comportamento. Imagine Google Docs, ou Spotify. Nesses casos as engines de Javascript, quando percebem que estão rodando faz algum tempo começam um processo que é mais devagar, que é o JIT, e começam a otimizar e compilar as partes do código Javascript mais executadas em binário nativo, que ainda depende do runtime das engines, mas é bem mais eficiente do que interpretação.  No caso, o SpiderMonkey usa o JIT do LLVM. SpiderMonkey e V8 passaram anos evoluindo e competindo pra ver quem era o melhor e acho que isso continua assim até hoje.


Por isso aplicativos como Spotify, Atom, Slack, Discord e outros conseguem rodar com performance aceitável. Some a isso que os navegadores por baixo hoje suportam CSS acelerado pelo hardware gráfico, as GPUs como o que já vem integrado no seu processador Intel ou placas externas como os GeForce da NVIDIA ou os Radeon e Vega da AMD. A evolução do que chamamos de GPU foi uma explosão neste século como o de CPUs foi nos anos 70 a 2000. Num determinado momento as GPUs passaram a suportar shaders, que como o nome diz, serviam pra controlar a sombra ou tonalidade das cores. Mas em breve elas passaram a ser programáveis numa linguagem similar a C. E adivinhem, podemos acelerar esses shaders compilando em tempo real, via um JIT, usando LLVM hoje em dia. Por isso se você executar um VirtualBox, a renderização gráfica via software, que é lento, hoje é compilado via JIT por um driver chamado llvmpipe. Se você lida com desenvolvimento com placas NVIDIA tem o compilador pros CUDA cores da GeForce, e a NVIDIA contribuiu os códigos de back-end pra permitir gerar shaders pras suas placas diretamente no LLVM abrindo as portas pra qualquer linguagem poder se beneficiar do processamento paralelo massivo em GPUs.


Agora, o último assunto de hoje pra você entender como o LLVM pode ir mais longe. O Front-end pode ser qualquer linguagem, ele cospe o IR, que é otimizado e depois passado pra um Back-end, que também pode ser qualquer coisa, por exemplo, os back-ends que geram binários de Intel ou ARM como já repeti várias vezes. Porém, vocês já viram que existem os transpilers, como o do Typescript que cospe Javascript. E se pudéssemos usar um front-end de C como o Clang e usar um back-end que cospe Javascript?


Esse é o projeto Emscripten. A demonstração mais impressionante se não me engano em 2014 foi quando a Epic Games pegou uma animação usando a engine de jogos Unreal e compilou com esse Emscripten, usando LLVM, de C pra Javascript e somado às capacidades de aceleração via GPUs dos navegadores via WebGL, conseguiu rodar o que antes era um programa nativo dentro de um navegador, com excelente performance graças a tudo que eu expliquei que dá pra fazer com LLVM. Pra fazer isso, eles limitaram o Javascript num sub-conjunto que ficou conhecido como ASM.js. O conceito é simples: CPUs tem instruções nativas, que podemos escrever em Assembly e usar um Assembler pra cuspir o bytecode nativo da máquina. Máquinas virtuais como a JVM tem seus bytecodes. E se considerarmos que o Javascript é um assembly da máquina virtual chamada navegador?


Isso abre todo um leque de possibilidades. E foi o que inspirou o projeto WebAssembly que surgiu pra formalizar esse sub-conjunto de Javascript que poderia ser o back-end pra compiladores baseados em LLVM. Hoje em dia ainda temos o Enscripten pra compilar em ASM.js e o novo projeto Brynaryen que nasceu sendo uma extensão do Enscripten mas foi reescrito do zero em C++ pra gerar WebAssembly - maldita síndrome de not-invented here, a Mozilla também sofre disso como o Google. Ainda não tivemos nenhum resultado bombástico, mas diversos grupos estão fazendo experimentos pra entender o que realmente podemos fazer. Se você procurar por emscripten vai ver demonstrações muito interessantes, inclusive uma pequena distribuição de Linux compilado inteiro com Emscripten e rodando dentro do navegador, sem emulação nem nada. Na prática, no futuro, poderíamos escrever aplicativos Web em qualquer linguagem e compilar tanto pra WebAssembly quanto pra binário nativo se quiséssemos. Mas ainda estamos no começo dessa jornada.


E por hoje vamos ficar por aqui, pra variar virou um episódio grande, mas eu queria contar essa história pra que você pudessem entender como política influencia a evolução das linguagens, ferramentas e arquiteturas que nós usamos hoje. Não é só uma questão se determinada linguagem é mais rápida que outra ou não. Como programador você precisa entender como diversos fatores externos e modelos de negócio e interesses políticos influenciam tudo que você usa.


Na semana que vem vou retornar ao tema de back-end falando sobre outro assunto que é controverso e muitos se confundem até hoje: concorrência e paralelismo e como diferentes linguagens lidam com isso de formas diferentes. Se ficou com dúvidas nesse episódio não deixe de mandar nos comentários abaixo, se curtiram mandem um joinha, compartilhem com seus amigos, assinem o canal e não deixem de clicar no sininho pra não perder os próximos episódios. A gente se vê semana que vem, até mais!



