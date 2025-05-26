---
title: 'Situação Brasil: No Macs for the Rest of Us'
date: '2015-11-10T16:54:00-02:00'
slug: situacao-brasil-no-macs-for-the-rest-of-us
tags:
- off-topic
- linux
- beginner
- learning
draft: false
---

Este é um artigo com o objetivo de ser prático, portanto só vou dizer que com o **inquestionável** governo inepto e corrupto que temos um dos efeitos práticos para nós, desenvolvedores de software, é a incapacidade de comprar boas máquinas para desempenhar nosso próprio trabalho.

![Cotação do Dólar 2015](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/523/cotacao_dolar.png)

O Real entrou em queda livre no começo deste ano e só agora está estabilizando um pouco, mas mesmo assim significa que ficamos mais longe do ideal de comprar um notebook profissional.

No site oficial da Apple do Brasil, se somarmos a desvalorização do Real e o **maldito** Custo Brasil em impostos, uma máquina ideal de desenvolvimento que é o Macbook Pro 15" Retina com 16GB de RAM e 512GB SSD vai custar a impossível quantia de R$ 23.499,00.

Nos Estados Unidos, essa mesma máquina custa USD 2.499 mais (pouco) imposto. Se fôssemos pelo mercado paralelo (que eu recomendo), com o dólar nos atuais R$ 3,80 mais uns 30% a 40% do "custo paralelo", significa que ainda assim não vamos pagar menos que R$ 13.500.

Mesmo se escolhermos a versão 13" Retina com 8GB de RAM, que custa USD 1.799 nos EUA, aqui não vai sair por menos que R$ 9.700.

Ou seja, é mais que o dobro do que a maioria dos desenvolvedores consegue pagar, considerando um orçamento de R$ 4.000, até R$ 5.000 se esticarmos muito.

O TL;DR é simples: o melhor hardware (não só processador, mas teclado, trackpad, acabamento em geral) continua sendo o Macbook Pro. Nenhuma outra máquina chega perto e pra mim o melhor sistema operacional continua sendo o OS X (com virtualização de Linux para desenvolvimento). Em não podendo comprar um Macbook, temos que escolher um bom PC e rodar Linux.

### Qual Máquina Comprar?

Mesmo comprando uma máquina no Brasil, não vai ser possível comprar a melhor configuração, que eleva o preço pra acima dos R$ 8.000.

Na faixa dos R$ 5.000 esqueçam SSD, não existe. O que achei com um custo-benefício mais razoável foi o [Dell Inspiron 15 Series 5000](http://www.dell.com/br/p/inspiron-15-5548-laptop/pd?oc=cai5548u1612656br052&model_id=inspiron-15-5548-laptop) que no momento da publicação deste artigo estava R$ 4.117. Importante escolher com muita RAM (mais de 8GB de preferência) para evitar ao máximo swap ao disco lento (mecânico de 5400 RPM normalmente).

Se alguém tiver boas opções nesta faixa para: no mínimo Core i5 3a geração, 8GB de RAM, 256GB de SSD, não deixe de compartilhar nos comentários.

Em termos de hardware, se puder comprar um Lenovo Thinkpad ou mesmo um Sony Vaio (que também deve estar proibitivamente caro), acredito terem acabamentos de hardware melhores que a Dell. Asus, Acer, eu não considero como boas opções que vão durar muito tempo e o acabamento também não é grande coisa.

Já adianto que teclado e trackpad de PCs são terríveis. Se possível use um teclado e trackpad externos da Apple. Especialmente o modelo da Dell que estou testando tem um teclado horrível (fora o layout brasileiro que eu detesto), plástico leve que tem feedback de clique muito ruim para quem digita rápido e um trackpad que interrompe a digitação o tempo todo com qualquer leve toque, tem dificuldade de registrar corretamente múltiplos cliques e no geral dá mais dor de cabeça do que ajuda.

### Perfis de Desenvolvedor

A intenção é uma máquina para desenvolvedores. E a menos que você seja um desenvolvedor .NET, definitivamente instale uma distribuição Linux. Qual distro depende de qual é o seu perfil, quanto mais low level for, mais você se aproxima de querer usar um Arch Linux. Quanto mais high level for, desenvolvedor de web apps, principalmente, mais eu recomendo ficar com um Ubuntu LTS (e no caso seria mesmo o Ubuntu 14.04).

Windows está fora de cogitação, sinto muito, eu fui usuário de Windows por quase 15 anos antes de migrar para Macs em 2004. Sou muito experiente com Windows, conheço todos os meus caminhos tortuosos pelo Registry e a bagunça que é o famigerado C:\WINDOWS. Experimentei todos os últimos Windows (7, 8, 8.1, 10) e a conclusão é a mesma: não faço nenhuma questão de voltar. Novamente, se tivesse que desenvolver em .NET, não tentaria emular o ambiente, apenas usaria Windows mesmo, numa máquina virtual. A única solução se seu ambiente de desenvolvimento exige um híbrido de .NET com open source é rodar Linux com virtualização.

O ciclo de desenvolvimento open source num Mac não é exatamente simples também. Você precisa entender o XCode, precisa entender que GCC não é a escolha default faz tempo (a Apple migrou para LLVM-Clang faz tempo) e por conta disso muita coisa pode quebrar. Mesmo assim o pessoal do [Homebrew](http://brew.sh/) fez um excelente trabalho em remover a maior parte dos problemas. Então, sim, dá pra desenvolver confortavemente se você não for um desenvolvedor system/low level.

Para desenvolvimento de iOS, você precisa do XCode. Não há alternativa. Dá para desenvolver em outras linguagens com relativa facilidade, seja Python, Ruby ou as novas como Rust, Elixir ou Go. Java é mais ou menos simples no Mac também então Java 8, Clojure, Scala, Groovy, estão à disposição.

Opcionalmente eu recomendo usar um ambiente virtualizado Linux dentro do Mac. Seja diretamente via Virtualbox (que não é a coisa mais estável do mundo no Mac) ou com VMWare Fusion (via [Vagrant](https://www.vagrantup.com/vmware) para facilitar, mas esta opção vai te custar caro, USD 170).

### Software Proprietário vs Código Aberto

Sim, no Linux temos diversas opções, como Inkscape, Gimp, Blender. Sim, "dá" pra fazer muita coisa.

Na prática, usabilidade conta.

No OS X temos Keynote, iMovies e Garageband que não tem iguais em termos de usabilidade. Para fins mais high end, temos Aperture, Final Cut Pro e Logic Pro. Novamente, sem iguais em usabilidade e flexibilidade.

No Windows, podemos escolher o pacote da Adobe, que vai de Photoshop e Illustrator até Premiere Pro e After Effects - que também tem versões para Mac.

No mundo de produtividade, esqueçam LibreOffice ou mesmo Google Docs, o pacote Microsoft Office (em particular Word, Excel) ainda são imbatíveis e sem iguais. Dá pra fazer parecido, dá pra editar parecido, ainda não é perto da mesma coisa, especialmente em planilhas mais complexas e cheias de fórmulas, pivot tables, etc.

Todos eles custam, e custam caro. Obviamente não é justo comparar com opções open source. Mas eu gostaria muito de ter a opção de pagar para ter funcionando numa distro Linux. O problema é que distros Linux não são amigáveis para software proprietário. Vai ser sempre o dilema do 100% aberto vs híbrido ou 100% fechado. Que diga o pessoal do Ubuntu.

Um pequeno exemplo é o 1Password, que eu uso no Mac, no Android, usava no iOS (quando tinha iPhone) e tem versão pra Windows. Tudo, menos pra Linux. Fui obrigado a usar 1Password de Windows via Wine para conseguir acessar minhas senhas de novo. "Bem feito, quem mandou usar software proprietário."

Pelo bem ou pelo mal o ideal de software 100% aberto nunca esteve mais longe. Especialmente hoje que todo app tem um componente online. Existe agora muito "client" open source, mas o back-end é totalmente closed-source. Pior: nem é um binário na sua máquina, está no "cloud". Ninguém nunca vai aderir ao ideal ao [Aphero GPL](http://www.gnu.org/licenses/why-affero-gpl.en.html) onde o código no cloud deveria ser aberto também. E mesmo se fosse, não seria prático pra ninguém simular o mesmo ambiente cloud de todo mundo.

Atualmente, o mundo open source não é um mundo de liberdade absoluta. Eu costumo sintetizar como o mundo open source sendo o melhor custo-benefício que as empresas já tiveram para manter software comoditizado.

Linguagens, frameworks, toolkits, ferramentas de desenvolvimento, bibliotecas de criptografia, são softwares comoditizados.

Pacote Adobe, Office, etc não são commodities ainda. Continuam à todo vapor, com feature nova atrás de feature nova, todo semestre. É impossível um copy-cat open source, sem recursos, conseguir atingir o mesmo nível. Nem há o interesse.

Para quem precisa de software proprietário como ferramenta do dia a dia, não saia do Windows, não saia do Mac.

Eu preciso ocasionalmente. 80% das minhas necessidades dependem de software comoditizado ou software que não é o core business de nenhuma empresa que as produzem. Para o Google, o Chromium vale a pena ser open source, mas nem chegue perto do código do Ad Sense - que é o real core business. Para todo mundo, vale a pena que os clients que consomem seus serviços sejam open source. Vou encontrar um bom client para Dropbox, para Google Drive, mas nem tente procurar: o core business ainda é e vai continuar sendo fechado. É onde o ideal de Free Software vai ficando mais e mais longe.

Eu não sou idealista, e para a maioria dos desenvolvedores, o que temos é o suficiente, ele se sustenta e se torna viável num mundo híbrido. Significa que no mundo real 80% do que precisamos está disponível. Os outros 20% vou precisar resolver por virtualização e terei meu Office rodando ou via Wine ou via Virtualbox. E talvez eu consiga ter meu Apple Keynote via Hackintosh num Virtualbox. Ou então vou resolver os últimos 5% com um Macbook defasado mas que rode o que preciso para as poucas horas em que preciso delas.

Tentei instalar um Hackintosh via Virtualbox e embora tenha conseguido instalar (depois de múltiplas tentativas e muitos tutoriais) ele é absolutamente instável e lento mesmo dando a ele 2 dos meus 4 Core i7 e 4GB de RAM com 128MB de memória de vídeo. Não dá pra usar, se eu quiser usar Keynote vai ter que ser um Mac mesmo, não tem substituto.

### Por que Ubuntu + Unity?

Se tem uma coisa que todo mundo tem uma opinião é quando se fala em como usar seu Linux. Depende de quem você é.

Se você for um programador no mínimo mais idealista, você vai odiar Ubuntu pela razão dele usar o que o Debian fez e adicionar a *argh* terrível camada de software proprietário por cima.

Se você for um programador mais hardcore vai querer entender cada centímetro do seu Linux e pra isso vai sempre achar que Arch Linux (ou pelo menos [Antergos](https://antergos.com/)) é uma opção superior. Pra esse pessoal o Pacman sempre será infinitamente superior a Apt-Get ou Yum.

Se você for do estilo mais "seja estável sem mexer muito mas não seja comum" pode acabar indo pra direção de Fedora.

E independente da distro sempre haverá a eterna briga entre Window Managers. O Pessoal do KDE com seu Plasma falando mal do antiquado Gnome ou o XFCE afirmando sua posição de "simples e estável" ou então uma distro nova como o Elementary OS criando seu novo Pantheon. Isso não tem fim.

A maioria dos novos programadores, que usam Linux a 5 anos ou menos, não consegue entender como alguém pode usar um Linux e não customizá-lo totalmente a seu gosto. Editar cada arquivo do X11, editar cada tema e pacote de ícones pra ficar um "Windows-alternativo" um "OS X-rebelde".

No meu caso, o que muitos podem não entender, é que eu sou usuário Linux das antigas. Meu primeiro Linux foi o Slackware 1.0 em 1996. Eu instalei RedHat pré 4. Depois vieram distros como Mandrake, muito antes de um Kurumin. Eu instalei as primeiras versões da maioria das distros de hoje. Eu já varei noites e noites customizando meu X. Noites e noites baixando temas, baixando widgets, customizando cada parte do meu sistema. Depois eu fazia alguma coisa errada e resolvia formatar tudo e começar tudo de novo. Muito tempo checando flag de compilação dos kernel pra fazer meu kernel mais customizado possível.

Eu fiquei nessa vibe de 1997 até talvez 2001. É cansativo. Sério. Se você é programador, na faixa dos 20 e nunca fez isso, eu diria que você tem obrigação **moral** de passar por esse processo. Todo programador tem que achar legal ter controle total do seu próprio ambiente.

Mas não é saudável fazer isso por mais de 5 anos. Depois disso você quer realmente ser produtivo. Produzir e não customizar. A quantidade de horas necessárias pra fazer uma distro 100% "minha" não compensa.

É por isso que eu gosto de OS X: não precisa customizar nada. Tudo está do jeito certo "out-of-the-box", o melhor Window Manager, em cima de um dos melhores sabores de Unix tradicionais e com acesso razoavelmente simples tanto ao mundo open source quanto ao melhor do mundo closed source. É o melhor dos dois mundos.

No mundo Linux você tem que lidar com a ideologia do GPL. Eu entendo perfeitamente os argumentos do Stallman, li e reli o site inúmeras vezes.Quantas vezes você **realmente** leu o [gnu.org](http://www.gnu.org/philosophy/philosophy.html) inteiro?  Infelizmente não existe almoço grátis, ficar na ideologia significa abrir mão de muita coisa que eu realmente não tenho disposição para abrir.

Em particular, o Dell que eu comprei veio com Ubuntu pré-instalado. É o que ele tem suporte, o que significa que o hardware todo funciona, tem drivers atualizados. Pretendo ficar dentro do ecossistema Ubuntu, incluindo o Unity que eu sei que muitos não gostam por questões de ideologia ou porque acham que XFCE ou Gnome ou KDE ou XXX funciona melhor para seus gostos.

De novo: o custo de customizar simplesmente não compensa. Software não se instala uma vez e funciona pra sempre. Tem que atualizar, tem que ter suporte, tem que ser consistente. O pessoal da Canonical é a única empresa seriamente focada em usabilidade e consumidor final, e isso é importante. Ele é constantemente freado pela ideologia e por opiniões demais que nunca chegam em consenso e é vilificado toda vez que toma uma decisão: sempre uma metade da comunidade não vai ter o que quer e vai chiar. A Canonical tem que lidar com um processo moroso e burocrático que uma Apple simplesmente decidiu bypassar completamente. Só que no caso da Apple, ela tem como trazer a Microsoft, a Adobe, e gerar business models lucrativos para centenas de outras software houses. A Canonical ainda não tem como fazer isso e depende muito das horas vagas de programadores voluntários no mundo open source, e essa dependência é tanto uma grande força quanto o maior problema.

Última dica: eu tive problemas em manter a linguagem padrão (para menus e tudo mais) em inglês e usar teclado USB externo de Mac com o layout English (US, alternative international). O normal que é acentuar o "c" pra ter a cedilha "ç" não funcionava. Só depois que segui este tutorial do [Kemel Zaidan](http://linuxlegal.blogspot.com.br/2014/02/cedilha-no-ubuntu-1310-com-teclado.html) que funcionou.

### Conclusão

Vou continuar usando Ubuntu como máquina principal? Não sei ainda. Estou mantendo minhas opções abertas para tempos mais difíceis onde o dólar custa acima de R$ 2,50. Para abaixo desse patamar, definitivamente fico com um Mac.

Para usuários domésticos, um Linux funciona bem, é a idéia do Chrome OS que é um Linux rodando basicamente Web Apps como Google Docs, Gmail, etc. E nesse nível tanto faz mesmo qual OS ou qual configuração. A vantagem de um Linux para o uso Web de 90% da população é não ficar vulnerável aos malwares mais óbvios.

Para usuários de escritório, um Linux funciona razoavelmente bem mas como eu disse, o Office ainda não dá pra substituir. A única forma é a empresa inteira adotando um formato mais simples de documentos e não fazer nada muito complexo com Excel por exemplo. No geral, um Google Docs e Google Drive ou Dropbox, Gmail Business, funcionam bem o suficiente.

Para desenvolvedores .NET, fiquem no Windows.

Para desenvolvedores open source, tanto faz ficar no Linux ou no Mac. Se for high end, escolha um Mac se puder pagar. Se for mais low level, fique no mundo Linux puro mesmo. Na dúvida: Ubuntu 14.04 LTS (com Unity!), instale sua opção de Sublime Text 3 e o resto funciona perfeitamente.

Para usuários híbridos que são desenvolvedores a maior parte do tempo mas também precisam de software proprietário (meu caso), dá pra ficar no Linux, na maior parte do tempo não vai doer tanto, mas naquele 1 momento que você precisar editar um vídeo, editar um Photoshop mais pesado, fazer um Keynote mais elaborado, tenha um Mac à mão. Não há alternativas para esse caso.
