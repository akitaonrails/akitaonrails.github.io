---
title: 'Situação Brasil: No Macs for the Rest of Us'
date: '2015-11-10T16:54:00-02:00'
slug: situacao-brasil-no-macs-for-the-rest-of-us
translationKey: situacao-brasil-no-macs-for-the-rest-of-us
description: "Testei um Dell Inspiron com Ubuntu depois que um MacBook Pro ficou caro demais para o orçamento brasileiro. Linux cobre cerca de 80% do meu uso, mas software proprietário ainda exige Mac ou Windows."
tags:
- linux
- apple
- hardware
- off-topic
draft: false
---

Este artigo quer ser prático, então vou direto ao ponto. Com o **inquestionável** governo inepto e corrupto que temos, um dos efeitos concretos para nós, desenvolvedores de software, é a incapacidade de comprar boas máquinas para fazer o nosso próprio trabalho.

![Cotação do Dólar 2015](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/523/cotacao_dolar.png)

O Real entrou em queda livre no começo deste ano e só agora começa a estabilizar um pouco. Mesmo assim, ficamos cada vez mais longe do ideal de comprar um notebook profissional.

No site oficial da Apple do Brasil, somando a desvalorização do Real e o **maldito** Custo Brasil em impostos, a máquina ideal de desenvolvimento, o Macbook Pro 15" Retina com 16GB de RAM e 512GB SSD, chega à quantia impossível de R$ 23.499,00.

Nos Estados Unidos, essa mesma máquina custa USD 2.499 mais (pouco) imposto. Se fôssemos pelo mercado paralelo (que eu recomendo), com o dólar nos atuais R$ 3,80 mais uns 30% a 40% do "custo paralelo", ainda assim não vamos pagar menos que R$ 13.500.

Mesmo escolhendo a versão 13" Retina com 8GB de RAM, que custa USD 1.799 nos EUA, aqui não sai por menos que R$ 9.700.

Ou seja, é mais que o dobro do que a maioria dos desenvolvedores consegue pagar, considerando um orçamento de R$ 4.000, até R$ 5.000 se esticarmos muito.

O TL;DR é simples: o melhor hardware (não só processador, mas teclado, trackpad, acabamento geral) continua sendo o Macbook Pro. Nenhuma outra máquina chega perto, e para mim o melhor sistema operacional continua sendo o OS X, com virtualização de Linux para desenvolvimento. Sem poder comprar um Macbook, resta escolher um bom PC e rodar Linux.

### Qual Máquina Comprar?

Mesmo comprando uma máquina no Brasil, não dá para levar a melhor configuração, que empurra o preço para acima dos R$ 8.000.

Na faixa dos R$ 5.000, esqueçam SSD, não existe. O melhor custo-benefício que achei foi o [Dell Inspiron 15 Series 5000](http://web.archive.org/web/20150625001142/http://www.dell.com/br/p/inspiron-15-5548-laptop/pd?oc=cai5548u1612656br052&model_id=inspiron-15-5548-laptop), que no momento da publicação deste artigo estava R$ 4.117. Vale escolher com bastante RAM, mais de 8GB de preferência, para evitar ao máximo o swap no disco lento, normalmente mecânico de 5400 RPM.

Se alguém tiver boas opções nessa faixa, com pelo menos Core i5 de 3a geração, 8GB de RAM e 256GB de SSD, compartilhe nos comentários.

Em termos de hardware, um Lenovo Thinkpad ou mesmo um Sony Vaio (que também deve estar proibitivamente caro) têm acabamento melhor que o da Dell. Asus e Acer eu não considero boas opções para durar muito tempo, e o acabamento também não é grande coisa.

Já adianto que teclado e trackpad de PC são terríveis. Se possível, use teclado e trackpad externos da Apple. O modelo da Dell que estou testando tem um teclado horrível, fora o layout brasileiro que eu detesto: plástico leve, com feedback de clique muito ruim para quem digita rápido. O trackpad interrompe a digitação a cada leve toque, tem dificuldade de registrar múltiplos cliques corretamente e no geral atrapalha mais do que ajuda.

### Perfis de Desenvolvedor

A ideia é uma máquina para desenvolvedores. A menos que você seja um desenvolvedor .NET, instale uma distribuição Linux. Qual distro depende do seu perfil: quanto mais low level, mais você se aproxima de querer um Arch Linux. Quanto mais high level, sobretudo desenvolvedor de web apps, mais eu recomendo um Ubuntu LTS, que no caso seria o Ubuntu 14.04.

Windows está fora de cogitação, sinto muito. Fui usuário de Windows por quase 15 anos antes de migrar para Macs em 2004. Sou muito experiente com Windows, conheço todos os meus caminhos tortuosos pelo Registry e a bagunça que é o famigerado C:\WINDOWS. Testei todos os últimos Windows (7, 8, 8.1, 10) e a conclusão é a mesma: não faço nenhuma questão de voltar.

Se tivesse que desenvolver em .NET, nem tentaria emular o ambiente, apenas usaria Windows mesmo, numa máquina virtual. A única solução, quando o ambiente de desenvolvimento exige um híbrido de .NET com open source, é rodar Linux com virtualização.

O ciclo de desenvolvimento open source num Mac também não é exatamente simples. Você precisa entender o XCode e precisa saber que o GCC deixou de ser a escolha default faz tempo, já que a Apple migrou para LLVM-Clang, e por conta disso muita coisa pode quebrar. Mesmo assim, o pessoal do [Homebrew](https://brew.sh/) fez um excelente trabalho removendo a maior parte dos problemas. Dá para desenvolver confortavelmente, desde que você não seja um desenvolvedor system/low level.

Para desenvolvimento de iOS, você precisa do XCode. Não há alternativa. Nas outras linguagens dá para trabalhar com relativa facilidade, seja Python, Ruby ou as mais novas como Rust, Elixir e Go. Java também roda mais ou menos bem no Mac, então Java 8, Clojure, Scala e Groovy estão à disposição.

Opcionalmente, recomendo usar um ambiente Linux virtualizado dentro do Mac. Seja direto pelo Virtualbox, que não é a coisa mais estável do mundo no Mac, seja pelo VMWare Fusion, com [Vagrant](https://www.vagrantup.com/vmware) para facilitar. Essa segunda opção vai custar caro, USD 170.

### Software Proprietário vs Código Aberto

Sim, no Linux temos diversas opções, como Inkscape, Gimp e Blender. Sim, "dá" para fazer muita coisa.

Na prática, usabilidade conta.

No OS X temos Keynote, iMovie e Garageband, sem iguais em usabilidade. Para fins mais high end, temos Aperture, Final Cut Pro e Logic Pro, de novo sem iguais em usabilidade e flexibilidade.

No Windows, dá para escolher o pacote da Adobe, que vai de Photoshop e Illustrator a Premiere Pro e After Effects, todos com versões também para Mac.

No mundo da produtividade, esqueçam LibreOffice ou mesmo Google Docs: o pacote Microsoft Office, em particular Word e Excel, ainda é imbatível. Dá para fazer parecido, dá para editar parecido, mas ainda não chega perto, especialmente em planilhas mais complexas e cheias de fórmulas, pivot tables e afins.

Todos eles custam, e custam caro. Obviamente não é justo comparar com as opções open source. Mas eu gostaria muito de ter a opção de pagar para rodar isso numa distro Linux. O problema é que distros Linux não são amigáveis para software proprietário. Vai ser sempre o dilema do 100% aberto contra o híbrido ou o 100% fechado. Que o digam os caras do Ubuntu.

Um exemplo pequeno é o 1Password, que uso no Mac, no Android, usava no iOS (quando tinha iPhone) e tem versão para Windows. Tudo, menos para Linux. Fui obrigado a rodar o 1Password de Windows via Wine para conseguir acessar minhas senhas de novo. "Bem feito, quem mandou usar software proprietário."

Para o bem ou para o mal, o ideal de software 100% aberto nunca esteve tão longe, ainda mais hoje, quando todo app tem um componente online. Existe agora muito "client" open source, mas o back-end é totalmente closed source. Pior: nem é um binário na sua máquina, está no "cloud".

Ninguém vai aderir ao ideal da [Affero GPL](http://www.gnu.org/licenses/why-affero-gpl.en.html), em que o código rodando no cloud também deveria ser aberto. E, mesmo se fosse, não seria prático para ninguém simular o mesmo ambiente cloud de todo mundo.

Hoje, o mundo open source não é um mundo de liberdade absoluta. Eu costumo sintetizar assim: ele é o melhor custo-benefício que as empresas já tiveram para manter software comoditizado.

Linguagens, frameworks, toolkits, ferramentas de desenvolvimento e bibliotecas de criptografia são software comoditizado.

Pacote Adobe, Office e afins ainda não são commodities. Continuam a todo vapor, com feature nova atrás de feature nova, todo semestre. É impossível um copy-cat open source, sem recursos, atingir o mesmo nível. E nem há interesse nisso.

Para quem precisa de software proprietário como ferramenta do dia a dia, o conselho é direto: não saia do Windows, não saia do Mac.

Eu preciso ocasionalmente. 80% das minhas necessidades dependem de software comoditizado ou de software que não é o core business de nenhuma empresa que o produz. Para o Google, o Chromium vale a pena ser open source, mas ninguém chega perto do código do Ad Sense, que é o verdadeiro core business.

Para todo mundo, vale a pena que os clients que consomem os serviços sejam open source. Vou achar um bom client para Dropbox, para Google Drive, mas nem tente procurar o resto: o core business ainda é e vai continuar fechado. É aí que o ideal do Free Software vai ficando cada vez mais distante.

Eu não sou idealista. Para a maioria dos desenvolvedores, o que temos já basta, se sustenta e vira viável num mundo híbrido. No mundo real, 80% do que preciso está disponível. Os outros 20% eu resolvo por virtualização, com o meu Office rodando via Wine ou via Virtualbox.

Talvez eu consiga rodar o Apple Keynote via Hackintosh num Virtualbox. Ou então resolvo os últimos 5% com um Macbook defasado, mas que rode o que preciso nas poucas horas em que preciso dele.

Tentei instalar um Hackintosh via Virtualbox e, embora tenha conseguido depois de várias tentativas e muitos tutoriais, ele fica absolutamente instável e lento, mesmo com 2 dos meus 4 Core i7, 4GB de RAM e 128MB de memória de vídeo. Não dá para usar. Se eu quiser usar Keynote, vai ter que ser um Mac de verdade, não tem substituto.

### Por que Ubuntu + Unity?

Se tem uma coisa em que todo mundo tem opinião é em como usar o seu Linux. Depende de quem você é.

Se você for um programador mais idealista, vai odiar o Ubuntu justamente por pegar o que o Debian faz e adicionar a *argh* terrível camada de software proprietário por cima.

Se você for um programador mais hardcore, vai querer entender cada centímetro do seu Linux, e para isso sempre vai achar o Arch Linux (ou pelo menos o [Antergos](http://web.archive.org/web/20150913071621/http://antergos.com/)) uma opção superior. Para esse pessoal, o Pacman sempre será infinitamente superior ao Apt-Get ou ao Yum.

Se você for do tipo "seja estável sem mexer muito, mas não seja comum", pode acabar indo para o lado do Fedora.

E, seja qual for a distro, sempre vai existir a eterna briga entre Window Managers. O pessoal do KDE com o seu Plasma falando mal do antiquado Gnome, o XFCE afirmando sua posição de "simples e estável", ou uma distro nova como o Elementary OS criando o seu novo Pantheon. Isso não tem fim.

A maioria dos programadores novos, que usam Linux há 5 anos ou menos, não entende como alguém pode usar um Linux sem customizá-lo totalmente ao seu gosto. Editar cada arquivo do X11, cada tema e cada pacote de ícones para virar um "Windows-alternativo", um "OS X-rebelde".

No meu caso, o que muitos podem não entender, é que sou usuário de Linux das antigas. Meu primeiro Linux foi o Slackware 1.0 em 1996. Instalei RedHat pré-4 e depois vieram distros como o Mandrake, muito antes de um Kurumin. Instalei as primeiras versões da maioria das distros de hoje.

Já varei noite após noite customizando o meu X, baixando temas, baixando widgets, ajustando cada parte do sistema. Depois eu fazia alguma coisa errada, resolvia formatar tudo e começava do zero de novo. Passei muito tempo checando flags de compilação de kernel para deixar o meu o mais customizado possível.

Fiquei nessa vibe de 1997 até talvez 2001. É cansativo, sério. Se você é programador, na faixa dos 20 anos e nunca fez isso, eu diria que tem obrigação **moral** de passar por esse processo. Todo programador precisa achar legal ter controle total do próprio ambiente.

Mas não é saudável fazer isso por mais de 5 anos. Depois disso, você quer mesmo é ser produtivo, produzir em vez de customizar. A quantidade de horas necessária para deixar uma distro 100% "minha" simplesmente não compensa.

É por isso que eu gosto do OS X: não preciso customizar nada. Tudo já vem do jeito certo out-of-the-box, o melhor Window Manager, em cima de um dos melhores sabores tradicionais de Unix, com acesso razoavelmente simples tanto ao mundo open source quanto ao melhor do mundo closed source. É o melhor dos dois mundos.

No mundo Linux, você tem que lidar com a ideologia do GPL. Eu entendo perfeitamente os argumentos do Stallman, li e reli o site inúmeras vezes. Quantas vezes você **realmente** leu o [gnu.org](http://www.gnu.org/philosophy/philosophy.html) inteiro? Infelizmente não existe almoço grátis: ficar na ideologia significa abrir mão de muita coisa que eu realmente não tenho disposição de abrir.

No caso, o Dell que eu comprei veio com Ubuntu pré-instalado. É o que ele suporta, o que significa que todo o hardware funciona e os drivers estão atualizados. Pretendo ficar dentro do ecossistema Ubuntu, incluindo o Unity, que eu sei que muitos não curtem por ideologia ou porque acham que XFCE, Gnome, KDE ou sei lá o quê funciona melhor para o gosto deles.

De novo: o custo de customizar simplesmente não compensa. Software não se instala uma vez e funciona para sempre. Tem que atualizar, tem que ter suporte, tem que ser consistente. O pessoal da Canonical é a única empresa seriamente focada em usabilidade e consumidor final, e isso importa.

A Canonical é freada o tempo todo pela ideologia e por opiniões demais que nunca chegam a consenso, e é vilipendiada toda vez que toma uma decisão: sempre uma metade da comunidade fica sem o que quer e vai chiar. É um processo moroso e burocrático que uma Apple simplesmente decidiu ignorar por completo.

Só que a Apple tem como trazer a Microsoft, a Adobe e gerar modelos de negócio lucrativos para centenas de outras software houses. A Canonical ainda não consegue fazer isso e depende muito das horas vagas de programadores voluntários do mundo open source. Essa dependência é ao mesmo tempo uma grande força e o seu maior problema.

Última dica: tive problemas para manter o sistema em inglês (menus e tudo mais) e usar um teclado USB externo de Mac no layout English (US, alternative international). O normal, acentuar o "c" para sair o cedilha "ç", não funcionava. Só funcionou depois que segui este tutorial do [Kemel Zaidan](http://linuxlegal.blogspot.com/2014/02/cedilha-no-ubuntu-1310-com-teclado.html).

### Conclusão

Vou continuar usando Ubuntu como máquina principal? Ainda não sei. Estou mantendo as opções abertas para tempos mais difíceis, com o dólar acima de R$ 2,50. Abaixo desse patamar, fico com um Mac sem pensar duas vezes.

Para usuários domésticos, um Linux funciona bem. É a ideia do Chrome OS, um Linux rodando basicamente Web Apps como Google Docs, Gmail e afins. Nesse nível, tanto faz o OS ou a configuração. A vantagem de um Linux para o uso web de 90% da população é não ficar vulnerável aos malwares mais óbvios.

Para usuários de escritório, um Linux funciona razoavelmente bem, mas, como eu disse, o Office ainda não dá para substituir. A saída é a empresa inteira adotar um formato mais simples de documentos e não fazer nada muito complexo no Excel, por exemplo. No geral, Google Docs e Google Drive ou Dropbox, com Gmail Business, funcionam bem o suficiente.

Para desenvolvedores .NET, fiquem no Windows.

Para desenvolvedores open source, tanto faz ficar no Linux ou no Mac. Se for high end, escolha um Mac se puder pagar. Se for mais low level, fique no mundo Linux puro mesmo. Na dúvida: Ubuntu 14.04 LTS (com Unity!), instale a sua opção de Sublime Text 3 e o resto funciona perfeitamente.

Para usuários híbridos, que são desenvolvedores a maior parte do tempo mas também precisam de software proprietário (o meu caso), dá para ficar no Linux. Na maior parte do tempo não vai doer tanto. Mas naquele único momento em que você precisar editar um vídeo, mexer num Photoshop mais pesado ou montar um Keynote mais elaborado, tenha um Mac à mão. Para esse caso, não há alternativa.
