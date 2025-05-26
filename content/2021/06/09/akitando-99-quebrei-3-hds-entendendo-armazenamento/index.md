---
title: "[Akitando] #99 - Quebrei 3 HDs: Entendendo Armazenamento"
date: '2021-06-09T13:21:00-03:00'
slug: akitando-99-quebrei-3-hds-entendendo-armazenamento
tags:
- drobo
- synology
- raid
- CHS
- LBA
- akitando
draft: false
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/lxjBgxmDZAI" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Nessa nova mini-série quero explicar os diversos conceitos sobre armazenamento e neste primeiro episódio vou explorar um pouco sobre RAID e mostrar como antigamente a gente mapeava dados em disco usando o sistema de cilindros-cabeças-setores e como as coisas evoluiram hoje.

## Conteúdo:

* 00:00 - Intro
* 02:17 - Drobo - o que é RAID?
* 04:11 - RAID-5
* 05:56 - Synology
* 06:52 - Resolvendo um problema catastrófico de HDs
* 09:23 - Você ainda não entende HDs/RAID-0
* 11:21 - o começo: instaladores de Linux
* 13:54 - CHS
* 17:28 - Blocos
* 21:18 - Velocidades
* 24:09 - fdisk
* 25:35 - LBA
* 26:54 - TBC


## SCRIPT

Olá pessoal, Fabio Akita




Se você assistiu o episódio sobre meus Backups que fiz lá no começo do canal sabe que costumo ser um pouco obsessivo sobre armazenamento. Eu cheguei a perder algumas coisas que tinha em disquetes e cartuchos de zip drive, então meus primeiros projetinhos, coisas da faculdade, eu perdi. Desde então tento manter múltiplas cópias das coisas mais importantes.






Eu tenho backupsdo meu Outlook do ano 2000 por exemplo, todos os meus emails de mais de 20 anos atrás. Mesmo os atuais que ficam no Gmail eu baixo offline com o Thunderbird pra ter uma cópia local. Nunca confie em serviços cloud, especialmente se forem gratuitos. Você sempre vai receber exatamente o que paga. Um belo dia sua conta tá suspensa, por erro ou porque você foi imprudente e não habilitou autenticação de 2 passos nem manteve senhas fortes. Vai acontecer, é só questão de quando.








Mesmo usando coisas como Dropbox, Google Drive e Microsoft OneDrive - sim, eu uso os três - tenho uma cópia nos HDs do meu PC, outra cópia no meu laptop, e outra nos meus NAS. A grande vantagem que eu vejo hoje em dia comparado com os anos 90 ou anos 2000 é que armazenamento barateou muito.







No primeiro dia de 1995, ano que entrei na faculdade, o custo médio por 1 gigabyte era nada menos que 850 dólares, em dólares dos anos 90! Só 1 giga! 5 anos depois, no último dia de 1999 o mesmo 1 gigabyte agora custava em média 15 dólares. E em 2009 custava só 7 centavos. Hoje em dia 1 terabyte é menos de 100 dólares.







Hoje eu quero discutir um pouco sobre armazenamento. Na nossa saga pela máquina de Turing e a linguição de bytes, eu expliquei como bytes mais ou menos são organizados na memória, estruturas de árvores, stack, heap e tudo mais. Mas memória RAM é volátil. Toda vez que você desliga o computador essa memória foi pro saco.








Pra ter algo persistente agora precisamos entender como armazenar nossa fita de bytes numa mídia sólida, como os atuais drives de SSD NVME. Muita gente pensa que a única coisa importante sobre drives é que a gente particiona e tem uma estrutura de diretórios e arquivos, e só lê arquivos e grava arquivos e acabou a história. Só que é muito mais que isso. Então vamos entender.






(...)






Por muitos anos, desde 2008, eu mantinha meu backup num dispositivo chamado Drobo. Quando saiu parecia excepcional, hoje em dia é bem ultrapassado, mas eu ainda tenho um Drobo 5N que é um NAS. NAS é sigla pra Network Attached Storage ou armazenamento anexado na rede que é um nome mais bonito pra um PC na rede com vários HDs.







Esse Drobo 5N tem 5 baias pra HDs. E eu tenho 5 HDs mecânicos de 4 terabytes cada. Isso dá um total de 4 vezes 5 que é 20 terabytes, mas eu só posso usar pouco menos de 15. Se você nunca ouviu falar em redundância pode achar isso estranho, pra onde foi os outros 5 teras??







O Drobo e outros NAS costumam usar alguma variação do conceito de RAID que é sigla pra Redundant Array of Inexpensive Disks ou um arranjo redundante de discos baratos. O problema é o seguinte, HDs tradicionais mecânicos tem o problema de serem mecânicos, terem partes móveis. O HD tem discos um em cima do outro formando um cilindro e cada um tem cabeças de leitura, um pra cada lado do disco, ligadas num motor pra movimentar essas cabeças a milímetro de distância dos discos. 








Eu lembro que nos anos 90 a gente tinha que dar um comando no MS-DOS chamado `park` que é estacionar. Era um comando pra forçar o estacionamento das cabeças. Pense em cabeças como a agulha que desliza sobre um disco de vinil de música. Apesar das cabeças num HD não tocarem fisicamente os discos e sim usar magnetismo pra ler os bits, se você esbarrasse no computador podia arriscar dessa cabeça tocar no disco, e aí podia estragar. Por isso era boa prática mandar estacionar antes de desligar o computador. Hoje em dia eles são mais inteligente e já fazem isso sozinhos.








O ponto é que existem muitas peças móveis, e tudo que tem peças móveis eventualmente vai falhar. Seja por problema de fabricação, seja só por tempo de uso. Tudo deteriora. E quando isso acontecer você pode perder acesso aos seus dados.







Existem variações na implementação de estratégias de RAID, mas no modelo clássico RAID-5 tem esse número porque se espera ter pelo menos 5 HDs. 4 vão estar ligados e um 5o fica offline de reserva, desligado mesmo e por isso chamamos de Cold Spare. Apesar de ser 4 HDs ligados ao mesmo tempo, você enxerga como se fosse um único drive. Um único volume pra ser mais exato.







Os dados, mais corretamente os blocos, são divididos entre os 4 drives e cada HD mantém uma parte da cópia do outro drive. Sabemos que HDs mecânicos eventualmente vão morrer. Mas vamos apostar que em 4 drives a chance de todos morrerem ao mesmo tempo é baixa. Normalmente só um  vai morrer primeiro. Se isso acontecer os outros 3 drives vão ter cópias dos demais e seu volume vai sobreviver intacto, sem perder nenhum dado.








Isso te dá tempo pra pegar aquele 5o HD de reserva, o cold spare pra substituir pelo que falhou. Daí o controlador do RAID vai reconstruir o novo HD com os dados redundantes dos outros três. Por isso que apesar de eu ter um total de 20 tera nos meus 4 drives, ele só me deixa usar 15. Porque os outros 5 tera são gastos com redundância. São os dados de paridade. E eu já tive esse problema de HDs morrerem várias vezes e toda vez fui salvo por esse sistema.








Em data centers isso é crucial. Imagina que um data center como os do Google ou Amazon da vida tem milhares de HDs. Todos eles vão falhar uma hora. Não de uma vez, mas aos poucos. Com essa quantidade massiva, falha alguns por dia, especialmente porque ficam ligados e funcionando dia e noite sem nunca desligar. HDs usados em data centers são diferentes do que a gente usa nos nossos PCs caseiros. HDs como os Seagate Iron Wolf Pro, feitos pra serem mais robustos e resistentes. HD doméstico quebra mais fácil, por isso é mais barato.









No meu caso, eu precisava de mais de 15 teras. Eu tenho duas opções: uma seria trocar os HDs de 4 teras por outros maiores de 6 ou 8 teras. Em vez disso eu queria testar os produtos de NAS da Synology e por isso comprei um modelo de entrada que é o DS420j, e já digo que achei razoável. 






Sem me alongar muito, nada de errado com esse modelo, ele faz exatamente o que diz que faria e acho que se for só pra backup tá bem mais que suficiente. Mas não dá pra usar ele no dia a dia com arquivos grande, porque ele é limitado pela velocidade dos HDs mecânicos e não tem opção pra aumentar a RAM e nem colocar um SSD NVME como cache. Uma versão como o DS920+ já tem opção pra esses upgrades e isso aumentaria bastante a velocidade: mais cache. E mesmo assim, se eu quisesse editar video direto dele precisaria ser um outro modelo que também tenha saída de rede 10Gigabit em vez do tradicional 1 gigabit. Lembrem-se disso quando estiverem escolhendo um.








Esses dias eu tive um problema. Uns dois anos atrás eu pedi pro meu sócio trazer HDs pra mim quando ele foi pros Estados Unidos. O problema de HDs, como eu falei, é que  são frágeis. Se você jogar os HDs na na mala e não proteger muito bem, com todo o balanço da viagem, mala sendo jogada dentro do avião, é quase certeza que vai estragar.







Dito e feito, eles nunca se comportaram como deveriam. Eu usei eles no Drobo, mas aí o Drobo reclamou que os HDs tavam falhando. Resolvi comprar mais 4 HDs novos no Mercado Livre e fui trocando. Daí esses HDs massacrados ficaram sobrando. Quando comprei o Synology eu pensei: ok, eu sei que eles não tão 100% mas vamos tentar de novo. Se falhar não vai ser todos de uma vez.







Funcionou por alguns meses, esses dias o Synology desligou tudo sozinho. Tentei religar e entrar no painel de administração e batata, 3 dos HDs tavam marcados com defeito. Três de uma vez só é foda. Mas na prática os próprios HDs é que sinalizam pro servidor que tão começando a falhar e que é arriscado continuar, não quer dizer que quebraram totalmente. Ainda bem que hoje em dia os HDs são mais inteligentes, eles tem a funcionalidade de SMART que é sigla pra Self-Monitoring, Analysis and Reporting Technology ou seja, Auto-monitoramento, análise e tecnologia de relatório. O HD sabe que vai morrer a qualquer momento.









Enfim, lá vou eu encomendar mais HDs no Mercado Livre. Eles acabaram de chegar, dessa vez comprei Western Digital RED que são os equivalentes em robustez aos Seagate Iron Wolf. Qualquer uma das duas linhas eu recomendo. O problema é que 3 HDs de uma vez começaram a notificar problema. Num dia normal onde no máximo só um falha, bastaria trocar só ele e os outros três iriam ser usados pra reconstruir o quarto.








Como os três falharam, o próprio Synology se auto-desligava inteiro por garantia. Então seria arriscado tentar o processo de reconstrução dele mesmo. Eu queria uma forma mais direta de fazer um clone de um HD direto pro outro. Por isso procurei um sistema de clonagem e achei um genérico que parece que funciona, da marca Mymax e você acha no Mercado Livre.








É um dispositivo que não precisa estar ligado no computador pra funcionar. Você coloca o HD original no slot A, o novo HD no slot B, só garante que o novo HD é do mesmo tamanho ou maior que o original, aperta um botão e ele sozinho vai fazer um clone, bloco a bloco. E isso é importante. Esse dispositivo não tem a mínima idéia de que sistema de arquivos o HD tem, se é NTFS de Windows ou ext4 de Linux. Ele não precisa carregar um filesystem e copiar arquivo a arquivo, isso seria o arriscado. Em vez disso ele vai fazer um clone de verdade, copiando bloco a bloco de um HD pra outro. Isso é modo raw ou crú.







Daí veio a idéia desse episódio. Muita gente, incluindo programadores não tem a mínima idéia de como HDs funcionam. No máximo sabem que um SSD é mais rápido que um HD e só. Quando eu falei clonar um HD, muita gente deve imaginar tipo selecionar vários arquivos e copiar pro outro como faria num Windows Explorer. 






Tem gente que tem até computadores ou HDs externos com mais de um drive configurado em RAID-0, formando um único volume, ou seja, estão em stripe. Mau eles sabem que se um dos HDs falhar você acabou de perder todos os dados dos dois ao mesmo tempo.







Se você não sabe o que é Stripe, é uma versão de RAID que faz um único volume em cima de dois ou mais HDs. Daí no seu Windows você enxerga só um drive C:, por exemplo. A vantagem é que a velocidade vai ser maior, porque você distribui o trabalho entre os dois HDs, em paralelo. No melhor caso você vai ter o dobro de performance. Alguns blocos vão pra um HD e outros blocos vão pro outro HD. 







Mas você pode pensar, ué, se metade dos arquivos foi pra um HD e outra metade foi pro outro, se um dos HD falhar eu vou perder só metade dos meus arquivos, mas a outra metade tá salva, não tá? Não! Eu disse que vai distribuir blocos e não arquivos. 








O você talvez não saiba é que arquivos são divididos em blocos, normalmente de tamanho fixo, digamos de 512 bytes. Então um arquivo de 1 megabyte pode ocupar pelo menos 2 blocos. Um arquivo de 10 mega vai ocupar 20 blocos e assim por diante. 







Agora, o sistema RAID-0 de stripe vai DIVIDIR esses blocos entre os dois HDs. Por isso é mais rápido ler depois, porque ele pode ler partes do mesmo arquivo vindo de HDs diferentes. E por isso que se você perder um dos HDs, vai perder o arquivo todo, porque tá picotado. Se você perder só 1 bloco, seu arquivo inteiro foi corrompido. Você trocou confiabilidade por performance. E isso é válido, por exemplo, se você tá configurando um servidor de cache, onde se os dados forem corrompidos, consegue reconstruir porque tem os originais em outro lugar.









As aplicações tentam facilitar as escolhas pra você, por isso às vezes você não sabe o que está acontecendo. Por exemplo, toda vez que reinstala um Windows, ou qualquer distro Linux moderna, só precisa ir dando next, next, next e o instalador é inteligente o suficiente pra fazer as escolhas mais sensíveis e você nem precisa entender o que ele fez. Uma dessas escolhas é como particionar seu HD, como gravar uma partição de boot, qual sistema de arquivos escolher e formatar. Em poucos minutos você parte de um HD virgem pro sistema operacional instalado e funcionando.









Nem sempre foi assim. Talvez tirando os Macs, que mesmo nos anos 90 tinha 100% de controle do hardware e do software, então ele sabia exatamente que HDs estavam instalados e como formatar da melhor forma. A vantagem da idéia de comoditizar PCs da IBM é que você podia comprar os componentes separadamente, um chip compatível com x86 só que da Cirrus, uma placa mãe talvez da Soyo, uma placa de som da Sound Blaster, um modem da US Robotics, e um HD ou Winchester como a gente chamava naquela época da Seagate.








Agora você quer instalar MS-DOS ou um UNIX ou uma das primeiras versões de Linux no começo dos anos 90. Boa sorte. Falando especificamente de Linux, primeiro você ia encomendar uma distro comercial como um RedHat. A versão 4.2 foi minha segunda distro. Daí coloca o disquete de boot pra inicializar o sistema, detectar o hardware que a BIOS já achou, carregar os drivers mais básicos pra cada componente. No final ele monta um ramdisk, que é o equivalente a um volume de HD só que na memória.







Agora você troca o disquete e coloca o de root ou suplemento como a RedHat costumava chamar. Ele vai montar esse disquete como o diretório /usr no ramdisk. Agora ele tem as ferramentas pra continuar. O próximo passo é detectar seu HD, se é IDE ou SCSI, carregar o driver e te dar a opção de particionar os volumes usando o temido `fdisk`.







Se você já teve o azar de cair num sistema que só te dá fdisk, e você nunca usou na vida, vai ser difícil. Só no fim dos anos 90 a RedHat adicionou a ferramenta Disk Druid que já ajuda muito, e hoje em dia você tem um GParted ou equivalente que vai particionar seu HD automaticamente, indicar onde você tá errando, e você nem precisa saber muitos detalhes.







Mas fdisk não, fdisk ele te pede pra criar a partição nativa que vai montar como o root ou barra, a partição de swap e pra fazer isso você precisa digitar o número do primeiro e do último CILINDRO. Daí ele te mostra informações como setores ou sectors e cabeças ou heads. Esse é o sistema CHS, cylinder-sector-head que são as coordenadas que definem a geometria tridimensional do seu HD.







Se você nunca pensou nisso, vou resumir. Se você abrir um HD mecânico, vai encontrar vários discos organizados um em cima do outro. Em cima de cada disco vai ter um braço com uma cabeça na ponta, que é quem lê e escreve de fato no disco. Cada cabeça identifica um dos discos. Quantas cabeças tem depende do HD.







Agora, como se organiza o disco? Na época do LP de música, o disco de vinil era organizado numa trilha espiral. Você coloca a cabeça no começo da espiral, mais pra borda do disco e enquanto gira, a cabeça vai deslizando dentro da trilha, lendo o engruvinhado que representa as ondas, que ele traduz como som. E o final da trilha é perto do meio do disco. 







HDs não são espiral, em vez disso é um conjunto de anéis um dentro do outro. É isso que chamamos de cilindro. A distância de cada cilindro varia de acordo com a evolução da tecnologia magnética da cabeça. Se os cilindros estiverem muito perto e o motor não tiver precisão suficiente, poderia acabar pulando cilindros. Então o número de cilindros é limitado pela resolução da cabeça e o limite onde o magnetismo causa interferência.







Em vez de ser um engruvinhado físico dentro da trilha como num disco de vinil, no caso de HD as trilhas são magnéticas. A cabeça serve pra magnetizar ou desmagnetizar um bit de cada vez. Faz de conta que se tem uma carga então é 1, se tira a carga é zero. Se as trilhas, ou cilindros ficarem pertos demais, a carga de um bit poderia afetar o estado do outro bit. Aliás, um jeito fácil de estragar um HD é colocar um ímã forte perto. Isso é verdade até hoje.








Um HD moderno tem mais de 16 mil cilindros por lado do disco. A estrutura de dados que identifica cada cilindro tem 16-bits então é possível ter até 65 mil quinhentos e trinta e seis cilindros. Eu acho que ainda não estamos perto de atingir esse limite. À medida que a precisão do motor e das cabeças foi aumentando a gente pulou de menos de 4 mil cilindros nos anos 90 até mais de 16 mil hoje. Por isso dá pra ter HDs com 18 terabytes ou mais.








Um disco pode ser escrito dos dois lados, assim como você pode virar um vinil e do outro lado tem mais música. Como num HD não tem como "virar" o disco, ele vai ter duas cabeças por disco. Numa estrutura padrão de 8-bits significa que podemos identificar até 256 cabeças, numeradas de 0 a 255, isso dá um máximo de 128 discos. Na prática, duvido que existe um HD que chega perto de 128 discos.







Continuando, esses cilindros são organizados em setores. Dependendo do sistema operacional, sistema de arquivos, os setores podem variar de tamanho. Um dos tamanhos mais comuns era 512 bytes. Hoje em dia acho que é 4 kilobytes. Estou especulando, mas eu acho que essa divisão existe pra ajudar a fragmentar menos os dados. Fora que não seria eficiente movimentar o motor pra ler um bit de cada vez. Ele vai ler blocos de bits de cada vez. Na realidade acho que mais de um setor.







Pra ler os bits no disco, o motor precisa mover a cabeça de uma borda a outra do disco, passando pelos cilindros. Digamos que você tenha um arquivo de 100 bytes. Agora imagine que você usou um sistema de arquivos bem estúpido que vai gravando cada byte em lugares aleatórios no disco. O pobre motor vai precisar trabalhar bastante pra achar cada byte. É um motor mecânico, se cada byte estiver num cilindro, isso vai fazer o motor trabalhar bastante e tudo vai ficar lento.







Agora, se os mesmos 100 bytes estiverem organizados sequencialmente, um byte atrás do outro, o motor só precisa ter o trabalho de chegar no primeiro byte do cilindro e pronto, girar o disco é mais fácil que mover a cabeça. Então é só deixar o disco girar e quando eu achar o primeiro byte vou lendo sequencialmente um atrás do outro. Isso minimiza o trabalho do HD.






Digamos que você tenha um arquivo de 21 mil e trezentos bytes, ou mais ou menos 21 ponto oito megabytes. Se dividir em setores de 512 bytes e arredondar, porque não dá pra ter números quebrados, seriam 42 setores. Mas isso daria um total de 21 mil quinhentos e quatro bytes, isso é duzentos e quatro bytes maior que nossos 21 mil e trezentos. E agora?







Na prática o HD vai reservar quarenta e dois setores. Ele vai usar quarenta e um setores inteiros e o último vai ocupar só trezentos e oito e deixar livre duzentos e quatro bytes. E esses duzentos e quatro bytes tão perdidos, não dá pra usar eles pra outro arquivo. Como os arquivos do seu sistema operacional e os que você produz nunca vão ser exatamente múltiplos de quinhentos e doze ou seja lá qual for o tamanho do setor, sempre o último setor vai desperdiçar alguns bytes de espaço inusável. E isso é normal.








É um dos motivos de porque o total ocupado no seu HD não é a soma do tamanho em bytes de todos os arquivos. Na prática vai ser um pouco mais, porque precisa ser múltiplo do tamanho do setor. Eu sempre falo que computação é um trade off. Pra ter zero desperdício de espaço, era só fazer cada setor ser 1 bit. Mas você já deve ter entendido que além de fragmentar bastante, isso ia fazer o motor do nosso HD suar sangue pra ler depois.







Com isso você entende porque a velocidade num HD nunca é constante. Depende do tamanho do arquivo, da fragmentação do drive. O problema é que nunca temos como saber se o drive vai ter mais arquivos muito pequenos ou poucos arquivos muito grandes. Por isso também costuma ser ordens de grandeza mais rápido ler um único arquivo gigante, tipo um zip grande ou um video ou um arquivo de ISO de 500 gigabytes em vez de quinhentos mil arquivos de 1 megabyte cada. O tamanho total é o mesmo, mas o número de operações do HD vai ser muito maior e é isso que mais afeta a velocidade.








O arquivo grandão tende a ter seus setores próximos. Mesmo com alguma fragmentação, você dá a ordem pro HD e ele só tem que se preocupar com uma sequência. Mas no caso de quinhentos mil arquivos, você vai ter que dar quinhentos mil comandos de leitura e pra cada arquivo o motor vai ficar se movendo pra achar onde no disco tá cada um. Isso que chamamos de overhead, o trabalho extra de ter que receber milhares de comandos em vez de só um. 








Conseguem imaginar esse trampo? Não é à toa que um HD vai se deteriorando com o tempo. Daí como a gente não sabe se vai ter mais arquivos pequenos ou mais arquivos grandões, também precisamos achar um tamanho de setor que balanceia desperdício de espaço no último setor de um arquivo e não pode ser tão pequeno que vai fazer o HD ser mais lento tendo que caçar muitos setores por arquivo. Se eu quiser ter pouca ou nenhuma fragmentação, basta fazer setores gigantes, mas aí cabe poucos arquivos. Se eu quiser ter milhões de pequenos arquivos, desperdiçando pouco espaço, basta fazer o setor ser o menor possível, só que aí a velocidade vai cair drasticamente. Trade off.








Na maioria dos sistemas de arquivos o tamanho do setor não é menor que 512 bytes e em alguns casos pode ser mais próximo de 4 kilobytes. Isso desperdiça um pouco de espaço, mas o preço veio caindo então hoje temos espaço sobrando, daí dá pra desperdiçar espaço pra ter mais velocidade. Se estiver no Windows e quiser saber, basta abrir um command prompt com permissão de administrador e rodar `fsutil fsinfo ntfsinfo c:` ou outro drive. No meu caso por exemplo meu C: tem setores de 4 kilobytes e meu I: tem 512 bytes.








Voltando à nossa instalação de Linux RedHat do meio dos anos 90, cá estamos frente à frente com essa tela de fdisk pedindo pra gente adivinhar o tamanho das partições baseado em cilindros. Antigamente o tamanho máximo de um HD era pouco menos de 8 gigabytes. Eu falei que cada gigabyte custava uns 15 dólares? Então isso era um HD de uns 120 dólares. Em 2021 isso é o preço de um HD Barracuda de 6 Terabytes. Quase mil vezes maior.








Esse HD Barracuda de cinco mil e quatrocentos rotações por minuto, diz a propaganda que consegue uma velocidade máxima de 6 gigabits por segundo. Como é em bits, precisa dividir por 8 pra ter em bytes, que é uns 700 megabytes por segundo. Mas isso é velocidade teórica de pico. Na prática num HD desses você vai ter sorte se conseguir mais que uns 300 megabytes por segundo, em média.







Pra piorar nossa conta, HDs modernos mais caros tem módulos de memória RAM. Ou no caso de Intel Optane, tem um mini SSD de cache. A Barracuda tem duzentos e cinquenta e seis mega de RAM. Isso é pelo menos dezesseis vezes mais RAM do que eu tinha no meu PC em 1995, e é só pra cache. A vantagem de ter RAM no HD que ele pode manter dados mais acessados na memória daí não precisa movimentar o motor pra pegar nos discos, por exemplo. É uma das formas do HD mecânico ficar mais rápido.







Mais do que isso, quando você pede pra gravar seu arquivo na realidade você não pede pro HD. Você pede pro seu sistema operacional como seu Windows e o Windows que vai fazer o pedido pro HD. O HD tem RAM, mas sua máquina também tem RAM e o Windows vai primeiro gravar em RAM, esperar acumular mais operações de escrita, reordenar pra facilitar o trabalho e vai dar "ok" e devolver o controle pro seu editor de textos. Provavelmente ele nem mandou pro HD ainda. Quando mandar o HD pode usar a RAM dela e dizer pro Windows que tá tudo ok também.






Isso parece inteligente não parece? RAM é ordens de grandeza mais rápido que seu HD. Eu disse que a velocidade do HD mecânico vai ser na faixa de 300 megabytes por segundo, na média. Um pente de memória DDR4 de 3600 megahertz tem picos de velocidade de 28 GIGAbytes. Isso é quase cento e cinquenta vezes mais rápido. É isso que significa diferença de ordens de grandeza.






O problema desses níveis de cache no meio do caminho é que antigamente, quando você recebia OK que o arquivo foi gravado, com grande probabilidade ele realmente foi gravado. Se daqui 1 segundo a energia da sua casa cair e desligar seu computador, pelo menos aquele último arquivo com certeza gravou no seu disco.






Hoje, se a força cair, você não tem certeza que o arquivo foi gravado. Provavelmente foi, porque é rápido, mas não se sabe. Num desktop, computador doméstico, tudo bem, porque raramente vai dar coincidência de você estar no meio da operação de escrita e a energia cair. Mas num servidor, tipo do Dropbox, com milhões de pessoas subindo arquivos sem parar, as chances de perder dados se a energia cair é alta. Por isso data centers tem tantos sistemas de redundância. O sistema de RAID que eu falei é só uma das peças do Lego deles.







Enfim, acabei dando uma tangente. O ponto é que todas essas peças móveis, dos HDs mecânicos até seu programa, tem muitas camadas no meio do caminho, muitos caches, e uma pane em alguma dessas camadas vai fazer você perder arquivos. Felizmente em 2021 as chances de você perder ou corromper arquivos é menor do que na minha época de MS-DOS e Winchesters de meros 20 megabytes que custavam uma fortuna.






E eu ainda não terminei o fdisk do Linux que tava instalando. Se prestar atenção, mesmo o fdisk de 1997 já tem uma ajuda. Nas primeiras versões você precisava saber tudo o que eu falei até agora sobre a geometria física dos HDs. Se eu tinha um HD de 8 giga, ia querer reservar uma partição de swap de uns 128 megabytes, que era o máximo. 







Olha só essa tela do fdisk. Eu dou `p` pra dar `print` nas partições. Não tem nada. Daí dou `n` pra `new` ou nova partição. Começo no cilindro 1. Agora eu precisaria fazer esse cálculo que ele mostra acima. Unidade é cilindros vezes 16 mil sessenta e cinco setores, onde cada setor tem quinhentos e doze bytes, então cada cilindro pode ter uns 8 megabytes. 









Em cima ele fala que meu disco pode ter até mil e vinte e quatro cilindros, cada cilindro com sessenta e três setores, indo de zero até duzentos e cinquenta e cinco heads ou cabeças. Claro que meu HD vai ter menos que isso. 128 megabytes é do cilindro 1 até dezessete, o que vai dar cento e trinta e seis blocos. O fdisk assume cada bloco tendo uns mil e vinte e quatro bytes. Pra chegar no número de cilindros é só dividir os cento e vinte e oito que eu quero por mil e vinte e quatro.









Pra ter o número de blocos por cilindro é só dividir a unidade, os quase 8 gigas por mil e vinte e autro. Isso dá o número de blocos por cilindro que são uns oito mil. Agora é multiplicar isso pelo número de cilindros pra cada partição. Cento e vinte e oito mega dividido por 8 vai dar dezesseis e uns quebrados, por isso arredonda pra 17.








Achou chato? Pois é, isso era chato. Agradeça que os aplicativos de particionamento hoje fazem todas essas contas pra você. Na realidade, a partir de 2002 com o padrão ATA-6 finalmente mudamos pro sistema de endereçamento linear de 48-bits chamado LBA ou Logical Block Addressing. E com isso esse sistema CHS de cilindro, cabeça, setor foi declarado obsoleto.








LBA é um mapeamento de endereços lineares em cima do sistema de CHS que o HD entende fisicamente por baixo. 2 elevado a 48 dá um máximo de duzentos e cinquenta e seis terabytes. Parece bastante pra uso doméstico, mas pra servidores não é tanto assim não. Por isso depois foi de 48-bits pra 64-bits.







Assim você endereça o disco do endereço zero até duzentos e cinquenta e seis teras. E por baixo ele vai converter em cilindros, cabeças e setores como antes. Você vai notar que muito na programação é fazer "de-para" que é conversão de coisas complicadas em coisas mais simples.







Tabelas de-para é que nem um dicionário, você traduz as coordenadas tridimensionais do disco por exemplo, cilindro, cabeças e setores num número. E pro sistema operacional, pra você como programador, é como se fosse um arrayzão gigante de 0 até aquele máximo. À medida que as coisas evoluem a gente pode desperdiçar um pouco de memória e processamento em ficar fazendo essas conversões. 





Desta vez vou quebrar o assunto em múltiplos episódios. Eu fui escrevendo e no final deu quase 80 páginas de coisas que se eu tentar explicar tudo de uma só vez vai ficar complicado demais. Acho que por hoje já foi o suficiente, mas não se preocupem que eu já escrevi a continuação então o próximo episódio vai chegar mais rápido dessa vez. Se ficaram com dúvidas mandem nos comentários abaixo, não deixem de assinar o canal e clicar no sininho pra não perder a continuação, e compartilhem o video pra ajudar o canal. A gente se vê, até mais.

