---
title: "[Akitando] #123 - Como sua Internet Funciona | Introdução a Redes Parte 3"
date: '2022-07-23T11:54:00-03:00'
slug: akitando-123-como-sua-internet-funciona-introducao-a-redes-parte-3
tags:
- internet
- router
- roteador
- dhcp
- dns
- arp
- ipv4
- ipv6
- nat
- cgnat
- akitando
draft: false
---

{{< youtube id="gcv5hXyTcIo" >}}

Vamos mais na prática como a internet da sua casa funciona. O que vem depois do modem. Como seu PC, seu celular, sua TV, conseguem se comunicar e acessar a internet? E se no ipv4 dizem que já acabou os possíveis endereços de IP, como continuamos usando internet sem migrar pro tal ipv6? Aliás, o que é ipv6? Vamos tirar essas coisas básicas do caminho.

## Conteúdo:

* 00:00 - Introdução
* 00:47 - Tanenbaum
* 01:43 - OSI Model
* 04:39 - Configurando roteador
* 06:22 - Endereço ipv4
* 07:36 - Máscara de Rede
* 09:23 - Telefones e ramais
* 11:28 - NAT
* 14:25 - ARP
* 16:40 - Default Gateway
* 17:56 - DHCP
* 19:39 - Hubs e Switches
* 21:58 - DNS
* 26:30 - Pi-Hole (DoH)
* 27:57 - Roteamento
* 30:20 - CGNAT
* 33:20 - IPv6
* 40:23 - Conclusão
* 40:53 - Bloopers

## Links:

* Computer Networks (5th Edition PDF) (https://www.mbit.edu.in/wp-content/uploads/2020/05/Computer-Networks-5th-Edition.pdf)
* What is a DNS record? (https://www.cloudflare.com/learning/dns/dns-records/)
* MAC spoofing (https://en.wikipedia.org/wiki/MAC_spoofing)
* What is Carrier-grade NAT (CGN/CGNAT)? (https://www.a10networks.com/glossary/what-is-carrier-grade-nat-cgn-cgnat/)
* What is IPv6, and why is adoption taking so long? (https://www.networkworld.com/article/3254575/what-is-ipv6-and-why-aren-t-we-there-yet.html)

## SCRIPT

Olá pessoal, Fabio Akita



Finalmente vou poder falar um pouquinho mais sobre a parte que mais interessa pra programadores iniciantes, que é o básico do básico de uma rede caseira. Eu resolvi falar disso porque recentemente estava justamente fuçando minha própria rede de casa, configurando meu NAS novo, e pareceu uma boa hora pra introduzir alguns conceitos de rede. Muito do que quero falar em episódios futuros depende de todo mundo saber pelo menos esse básico.




Hoje pulamos do modem pro roteador e o vocabulário mais básico sobre endereços IP, rotas, e tudo mais. Pra maioria das pessoas tudo isso é invisível. Você já conecta no seu Wifi e tudo funciona. Mas programadores precisam entender porquê essas coisas funcionam. Então vamos lá.




(...)






Sem vocês saberem nos últimos dois episódios eu toquei em dois tópicos específicos de redes. O que se chama de camada física e a camada de dados, physical layer e data link layer. Claro, eu só toquei em pouquíssimos tópicos desses assuntos, se quiserem saber o assunto completo, como sempre, eu recomendo que estudem o famoso livro de redes do professor Tanenbaum. Quem fez ciências da computação provavelmente teve que estudar esse livro, e na minha época da faculdade também era ele.






Se conseguiram chegar até aqui, espero que já consigam enxergar dados não como arquivos e sim como conjuntos de blocos de bits, ou o que chamamos de pacotes. E espero que já tenham começado a entender a idéia de protocolos como o formato como preenchemos os metadados do cabeçalho desses pacotes. A metáfora de e-commerce onde o produto é o dado e o pacote de fora onde se preenche endereços é o protocolo. Esses pacotes tem coisas como o número deles pra depois a gente receber e montar na ordem certa.







O hello world do estudo de redes é o modelo de referência OSI, que tecnicamente não é mais usado hoje em dia. A gente tá mais familiarizado direto com o protocolo TCP/IP que se usa na internet. O Tanenbaum diz que os protocolos associados ao modelo OSI não são mais usados, mas o modelo em si é bem útil e geral e ainda válido. Já no TCP/IP é o contrário, o modelo em si não é muito útil mas os protocolos são muito utilizados. Por isso na prática a gente usa TCP/IP mas aprende o modelo OSI.







O modelo OSI é dividido em 7 camadas e eu disse que já mencionei parte das duas mais baixas, a camada física 1 e a camada de data link 2. A idéia das camadas é que elas poderiam ser substituídas sem alterar as camadas de cima. Por exemplo, posso trocar a camada física de cabos ethernet por wifi e o resto funciona igual. A camada física é isso, a camada responsável por transportar bits por algum canal de comunicação.






A camada de data layer é responsável por cuidar de coisas como checagens de erros. Checksums e o algoritmo Internet 16-bits que mencionei no episódio anterior. A idéia de detectar um erro e pedir pra repetir o pacote caso tenha erro. Depois vem a camada que não falei, a camada de rede propriamente dita, é quem cuida das rotas e pra onde enviar os pacotes. 





No caso de TCP/IP as camadas física e data link são uma camada só, a camada chamada só de link. E a camada de rede é a responsabilidade do protocolo IP. Quando falamos em IP pensamos em endereço IP, mas IP em si é Internet Protocol, que é a camada de Internet junto com outro protocolo, o ICMP ou Internet Control Message Protocol, que a gente usa quando fazemos ping por exemplo.








Acima disso, no modelo OSI temos camada de transporte, sessão, apresentação e de aplicação. Tecnicamente a camada de transporte em si é o TCP que é Transport Control Protocol, ou protocolo de controle de transporte. Portanto TCP/IP é justamente protocolo de controle de transporte de pacotes na internet. TCP tem como característica controlar conexão entre duas pontas de forma confiável. Em paralelo temos UDP ou User Datagram Protocol, que é um protocolo que não fecha conexão e não usa o sistema de sequenciamento de pacotes do TCP. Ele tem menos metadados e é mais leve, mas é menos confiável e feito pra situações onde perder um pacote não é um problema. Streaming de audio e video é um exemplo onde UDP pode ser útil.








A camada de aplicação é onde encapsulamos outros protocolos dentro. É onde nós programadores mais trabalhamos com coisas como HTTP pra web, SMTP pra email, DNS pra domínio e assim por diante. A maioria dos protocolos que usamos no dia a dia de programação são empacotados nessa última camada de aplicação. Pras camadas embaixo, não importa o que foi encapsulado, porque vamos fragmentar tudo em frames e eles só se importam em entregar esses frames de uma máquina pra outra. É como um entregador do mercado livre. Pra ele não interessa o que tem dentro do pacote, ele vai entregar do mesmo jeito seja lá o que tiver lá dentro.








Mas entregar, precisamos saber pra quem entregar. Eu disse no episódio de modem que a responsabilidade dele é modular e demodular entre sinal digital e sinal analógico. Mas essas caixinhas de uma Vivo ou Claro da vida fazem mais, são também roteador e ponto de acesso. É como um negócio pequeno familiar como a padaria do pai que é padeiro, a mãe recebe pedidos, manda o filho ir entregar e vai funcionando assim. Essa é a beleza dos protocolos de internet, você pode entuchar tudo num PCzinho fraco que vai funcionar ou dividir responsabilidades com PCs mais fortes pra escalar. Pra maioria das pessoas, com 1 TV, 3 ou 4 celulares, 1 ou 2 PCs, usar essa caixinha tá mais que bom e vai funcionar bem o suficiente que poucos vão notar a perda de performance e possível falta de segurança.







Eu mesmo não tenho usos muitos drásticos, mas talvez por ser mais old school, eu prefiro desligar a função de ponto de acesso e deixar ele conversar só com um dispositivo, o meu router separado. Não é um router robusto nem nada disso, é só um TP-Link Archer C6 normal. Eu uso um cabo cat5e que suporta até 1 gigabit. Como meu plano é de 300 megabits só, mais do que isso sobra. O roteador registra o gateway de saída padrão como sendo o IP do modem que é 192.168.15.1. E o roteador como sendo o dispositivo 192.168.15.2.







Hoje vamos falar desse tal de endereço IP, esse número de quatro blocos divididos por pontos que todo mundo já viu pelo menos uma vez na vida. Infelizmente pra realmente explicar isso eu precisaria tocar no assunto de roteamento, classless interdomain routing ou CIDR, e eu realmente não tenho nenhuma vontade de explicar isso. Então, de novo, recomendo o livro do Tanenbaum e o capítulo sobre a camada de rede pra estudar. Dessa vez só vou dizer o que é, mas não porque é assim.







Mesmo cortando o grosso, ainda assim explicar endereços é um saco. Vamos por partes. Um endereço IP é basicamente um número de 32-bits que escolhemos dividir em 4 blocos de 8 bits. Assim como em decimal, quando temos um número grande como 1 milhão, a gente costuma separar por ponto a cada três números pra ficar mais fácil de ler. Sendo blocos de 8 bits, se você é de front-end já tá acostumado com cores RGB sendo 3 blocos de 8 bits cada, indo de 0 até 255. Mesma coisa. Os endereços IP podem ir de 0.0.0.0 até 255.255.255.255.








Aqui vale falar outra coisa, eu venho falando em blocos ou pacotes ou frames, mas existem várias nomenclaturas usadas de formas confusas e no mundo de IP fala-se em datagrams, é a mesma coisa, pacotes de bits com um cabeçalho de metadados. Assim como antigamente tinha telegrama no mundo analógico, em digital temos datagramas. Mas no fundo é tudo pacote de bits, não se perca nas diferentes nomenclaturas. A parte importante são os campos de metadados definidos pelo protocolo, que descrevem pros diversos componentes da rede, como switches e seus dispositivos o que fazer com esse pacote, pra onde mandar e tudo mais. Mas realmente não tenho nenhuma vontade de detalhar esses campos, novamente, leia Tanenbaum.








Mas voltando, endereços IP versão 4 ou IPv4 como chamamos são números de 32-bits. Mas só esse número não quer dizer muita coisa sozinho. A gente sempre precisa de uma máscara de sub-rede, subnet mask, que é aquele número 255.255.255.0 ou similar que você também já deve ter visto e como o próprio nome diz é uma máscara pra ser aplicada no endereço IP pra saber qual parte define a sub-rede e qual define o host. Isso é uma coisa que todo programador tem obrigação de saber que são operações bitwise. 







Se nunca viu operação bitwise, vamos ver como que funciona. Vamos pegar o endereço que o modem deu pro roteador, 192.168.15.2 e escrever o número em binário aqui na tela, 32 bits. Eu quero saber qual é o prefixo que identifica a sub-rede. Pra isso usamos a máscara. Lembra, 255 significa tudo 1, então 3 blocos de 8 bits 1 e o resto é zero. Agora fazemos operação bitwise AND, ou seja, fazemos AND bit a bit. 1 and 1 é 1, 1 and 0 é 0, 0 and 0 é 0. Eu expliquei isso no guia mais hardcore de introdução a computadores.







Fazendo isso, o que sobra no final é o prefixo de rede. 192.168.15.0. A máscara arranca fora o sufixo que identifica o dispositivo individual na rede. Essa máscara na prática me diz que os primeiros 24 bits representam a rede, por isso outra forma de representar isso é escrever 192.168.15.255/24. Isso denota uma rede onde é possível ter até 256 dispositivos. Se fosse 192.168.255.255/16 ou máscara 255.255.0.0 significa que poderíamos ter 2 elevado a 16 ou seja, mais de 65 mil dispositivos. É uma rede grande demais, por isso você não vê rede barra 16 por aí. Num roteador caseiro, uma rede barra 24 é mais que suficiente, porque ninguém tem mais de 200 dispositivos em casa precisando de endereços.









Por que precisa ter isso? Um roteador é responsável por rotear pacotes na rede interna e também ligar com outro roteador numa rede externa, tipo a rede da Vivo. Se não tivesse essa hierarquia de rede e hosts, todo roteador precisaria ter uma tabela com cada endereço de cada dispositivo dizendo pra onde o pacote de cada um deles precisaria ir. Em vez disso o roteador só precisa saber, se da rede internet vier um pacote cujo prefixo do endereço seja 192.168.15.x ele precisa mandar pra rede externa do modem. Não importa se veio de 192.168.15.2 ou 192.168.15.3. Então o roteador só precisa manter uma linha em memória pra essa rede em vez de uma tabela com todos os endereços dessa rede. 








É mais ou menos como telefones. Se todo mundo tivesse um número de telefone de 11 números aleatórios, toda central em todo estado precisaria ter uma tabelona com 100% de todos os números pra saber pra onde mandar. Mas a gente usa o tal de DDD, os dois primeiros números representam uma região, mais ou menos uma cidade ou conjunto de cidades. Na Grande São Paulo o DDD é 11, Rio de Janeiro, o DDD é 21, em Natal o DDD é 84 e assim por diante. Então se a Central de São Paulo faz uma ligação pra um número com prefixo 84, ele sabe que precisa rotear a chamada pra Central da Natal. A Central de São Paulo não precisa ter o banco de dados com os números de Natal, só mandar pra outra central que vai ter esse sub-conjunto de números de Natal, que é a Central de Natal.








Endereços IP é a mesma coisa, só que mais simples, ele representa a sub-rede e o host, ou identificador do dispositivo nessa rede. Mas tem mais detalhes pra quem quer estudar redes de verdade que é entender CIDR ou Classless InterDomain Routing, como se usa máscaras pra definir sub-redes independentes dentro de uma mesma organização, por exemplo, blocos de IPs diferentes pra cada departamento. E a forma antiga que se usava até 1993 de classful addressing, onde provedores tinham que lidar com classes A até E. Como falei antes, isso tudo tem a ver sobre como roteadores sabem como rotear quais pacotes pra quais redes. Isso é o capítulo de camada de rede do Tanenbaum.








O que mais interessa é o problema que vocês já devem ter ouvido falar. Especialmente depois da explosão da internet no fim dos anos 90, seguido da explosão de smartphones nos anos 2010, a gente literalmente tem ordens de grandeza mais dispositivos conectados na internet do que existem endereços disponíveis num número de 32-bits como definido pelo IPv4. É mais ou menos o mesmo problema que expliquei no episódio dos 640 kilobytes de RAM quando se achava que isso era o máximo de RAM que uma pessoa normal jamais ia precisar, e nos anos 90 se provou que isso era muito pouco. 32-bits que dá um máximo de 4 gigabytes também é pouco e hoje estamos em 64-bits.









IPv4 sendo 32-bits significa que o máximo teórico de endereços seria pouco mais de 4 bilhões. Só de smartphones já temos mais de 3 bilhões. Some a isso todo PC, todo servidor em todo data center. Some a isso um tanto de IPs que já foram desperdiçados também. A gente já passou de 4 bilhões de endereços muitos anos atrás. Mas porque tudo continua funcionando? E pra entender isso eu acho importante todo mundo saber o que é um NAT ou Network Address Translator.







O conceito é muito simples. Todo provedor como Vivo ou Claro tem muito menos blocos de endereços IP reais do que clientes. Por isso é impossível dar um endereço real pra cada cliente e de fato ninguém faz isso. Em vez disso eles implementam o que chamamos de um CGNAT ou Carrier Grade NAT, ou seja, um NAT tamanho industrial. O grande lance é que podemos ter o intervalo inteiro de IPv4 dentro de cada sub-rede isolada e traduzir o endereço quando ela sai de uma rede e vai pra outra.







Em redes embaixo de NAT existem 3 blocos de endereços reservados só pra isso. Os com prefixo 10 barra 8, que é um intervalo de 24 bits de mais de 16 milhões de endereços possíveis. Ou com prefixo 172.16 que é barra 12, uma rede de 20 bits ou mais de 1 milhão de endereços e finalmente com prefixo 192.168 que é barra 16 que é uma rede de 16-bits ou mais de 65 mil hosts. Por isso que normalmente seus dispositivos na sua rede local de casa ou do escritório costumam ser 192.168 alguma coisa ou 172 ponto alguma coisa ou 10 ponto alguma coisa. São intervalos reservados pra redes locais embaixo de NAT.








Meu PC tem endereço 192.168.1.200. Eu quero assistir alguma coisa do YouTube. Faz de conta que o endereço de destino é 142.250.219.14 porta 443 que é a porta de HTTPS. Outro dia explico portas. Então meu PC monta pacotes onde a origem é meu endereço 192.168 com destino 142.250 bla bla porta 443 pedindo a página de video e manda isso na rede local aqui de casa.






Antes de chegar em NAT vou aproveitar pra adicionar mais detalhes desse processo. Dentro de uma rede local os pacotes não são roteados pelo endereço IP. No protocolo de rede, estamos na camada de rede, mas na rede local o que importa é a camada de data link, da ethernet. E ethernet não entende endereços IP. 







Essa tangente vale a pena fazer. Segura o exemplo do YouTube. Digamos que eu queira falar com um dispositivo aqui dentro na minha rede local. No caso o meu NAS. Eu que configurei então sei que tá com endereço local 192.168.1.161. Posso abrir aqui o command prompt do Windows e dar um ping pra ele. Todo mundo já fez ping pra medir latência e tempo de resposta, ele manda um pacote ICMP e mede o tempo. De novo, como meu PC sabe mandar pacote exatamente pra esse dispositivo e não confunde com, digamos, minha smart TV que tá na mesma rede?







O jeito mais simples seria toda vez eu ficar mandando pacotes pra todo mundo na rede perguntando "ow, quem aí é IP final 161", daí o NAS responde "sou eu! manda pra cá". E ficar fazendo isso toooooda vez, pra todo pacote. Mas conseguem enxergar como isso seria um desperdício? Eu ia ficar toda hora incomodando os vizinhos gritando no corredor. Minha TV ia receber pacotes que não precisa. Meu smartphone conectado via Wifi ia ficar recebendo. Toda vez que preciso enviar pacotes, ia ter que ficar gritando no corredor. Seria um saco.







Por isso existe um outro tipo de pacote chamado ARP ou Address Resolution Protocol. No command prompt mesmo eu posso digitar `arp -a` e vai aparecer uma tabela, que é um cache aqui no meu PC. Quando eu fiz o ping pro meu NAS, na realidade ele pediu pro ARP gritar no corredor "ow, quem aí é o NAS!?". Aí o NAS respondeu "sou eu, caralho!" e incomodou todo mundo na rede. Mas aí o ARP que não é burro nem nada, registrou a posição do apartamento no andar. É pra isso que serve o tal MAC address. Toda placa de rede, seja ethernet, seja wifi, tem um endereço único de 48 bits que vem de fábrica. 2 elevado a 48 são mais de 281 trilhões de endereços. É endereço suficiente pra todas placas de rede já fabricadas e em operação.








Olha a tabela que o comando `arp -a` me mostra agora. Tem um registro dizendo que 192.168.1.161 é esse MAC address que eu escondi uma parte. O endereço IP é relevante pra roteador de internet, mas na camada de baixo da rede física, IP não quer dizer nada. Ethernet encontra coisas baseado em MAC address. Mas com isso meu PC já sabe que se quiser falar com o NAS de novo, não precisa mais gritar no corredor. É só mandar direto pra placa de rede que responde nesse MAC address. 







Mas isso funciona pra endereços da rede local. Se for endereço IP 192.168 o ARP vai ficar gritando aqui no corredor. Mas e se for o endereço do YouTube, que é no prédio ali na esquina? Agora não adianta ficar gritando no corredor. E é pra isso que serve o tal do default gateway que você também costuma ver na configuração de rede do seu roteador. É como se fosse o porteiro do seu prédio. Todo endereço que não faz parte deste prédio você manda pro default gateway, que por convenção é o endereço IP mais baixo, como 192.168.1.1. E agora pede pra ele ir no outro prédio, pedir pro porteiro de lá, o roteador de lá, gritar no corredor de lá. Rede é mais ou menos isso mesmo, todo mundo gritando pra lá e pra cá e uma correria de entrega de pacotes.








Mas tudo isso pressupõe que todo apartamento tem um endereço IP único dentro do prédio. Mas digamos que se mudou um vizinho pentelho, e só pra foder, ele resolveu colocar o mesmo número de apartamento do vizinho. O ARP vai gritar no corredor "ow. quem aí é endereço final 161" e dois apartamentos gritam "sou eu!!" e agora? Agora eu não posso entregar o pacote pra nenhum dos dois, porque não sei dizer quem tá dizendo a verdade. Então o pacote é dropado, jogado fora, e nenhum dos dois recebem. Um deles precisa colocar um endereço IP que nenhum outro esteja usando. Essa é a regra de conduta do prédio.








Pensa, seria uma zona se toda vez que você se muda pra um prédio, você mesmo precisasse definir qual é o número do seu apartamento. O prédio é progressista, ele deixa você escolher o número que mais te agrada. Só que aí metade escolhe número 13, a outra metade escolhe 22. E o ARP ia ficar o dia inteiro gritando nos corredores e não ia poder entregar nada pra ninguém. O prédio seria uma zona. Ainda bem que na vida real, todo apartamento já tem números pré determinados e você não escolhe. Hoje em dia, numa rede local, é a mesma coisa.








Pra isso serve essa outra coisa que você já deve ter visto no seu roteador chamado DHCP ou Dynamic Host Configuration Protocol. Toda vez que um novo dispositivo se conecta na rede, ele pergunta pro servidor de DHCP, que em cenário caseiro, fica no seu modem ou no seu roteador separado. Em empresas um servidor DHCP pode ser um servidor separado e independente. Mas o funcionamento é o mesmo. O DHCP é o síndico do prédio. O meu PC conecta na rede e checa "ow, tem um síndico ativo por aí?" e o DHCP responde "opa. tem eu aqui! o que manda?". Aí o PC pergunta "ow, que endereço tem sobrando aí pra mim?" e o DHCP mantém uma tabela parecida com aquela do ARP, e fala "opa, tem final 200, firmeza?" e o PC responde "valeu irmão, vou usar esse então".








E quando o NAS conecta, ou a TV ou seu smartphone, todos perguntam pro DHCP qual endereço tá sobrando e ele manda um certinho, de tal forma que ninguém tem um IP colidindo com de outro dispositivo. E assim o ARP funciona e os pacotes são entregues pros lugares certos. No DHCP eu posso também configurar dizendo que um certo MAC address sempre receba o mesmo endereço de IP. É útil pra coisas como meu NAS porque eu monto um drive nele do meu PC e seria um saco se toda hora o DHCP desse um endereço diferente pra ele. 






Tudo parece encaixar bonitinho, mas tem alguns problemas que eram mais graves no começo da internet e foram sendo tratados ao longo do tempo. Por exemplo, antigamente a gente usava hubs em redes, pra compartilhar um cabo entre vários computadores. Lembra antigamente quando tinha extensões de telefone na sua casa? Aí seu namorado liga e toca nos dois telefones, a menina no quarto atende e a mãe na cozinha atende também. Daí a mãe se toca "opa, é o namorado da minha filha, vou desligar pra não ouvir a conversa". E sendo uma mãe honesta, ela desliga. Mas isso pressupõe que todo participante nessa rede seja honesto.







É o que placas de rede legítimas numa rede em hub fazem. Se vem pacotes que não é pro MAC address dele, ele dropa, ou rejeita esses pacotes e não fica escutando. Porém, a placa de rede tá aqui fisicamente na minha máquina, eu posso hackear ela. E isso se chama colocar essa placa em modo promíscuo. Quem já brincou com softwares como Wireshark sabe disso. A gente podia ficar vendo todos os pacotes trafegando na rede, mesmo os que não são pra mim. Por isso que hoje em dia se usa switches. Um switch estabelece uma conexão direta entre o dispositivo e o roteador e os outros canais do switch não vêem pacotes que não sejam direto pro MAC address dele. Por isso que hubs são baratinhos, porque eles enviam os pacotes pra todo mundo conectado, sem processar nada.









Mas ainda tem outro problema. De novo, MAC address é um endereço que vem de fábrica na placa de rede. Mas eu posso modificar essa placa e fazer ele responder qualquer outro MAC address. Daí o switch é obrigado a mandar pacotes pra mim que não eram pra mim. Não só isso, mesmo meu endereço IP mudando por causa do DHCP, meu MAC address é sempre o mesmo, então o provedor consegue saber o tempo todo com quem estou me conectando e registrar isso. Por isso empresas como a Apple vem planejando gerar MAC address aleatórios em iPhones por exemplo, pra dificultar saber quem é quem. 







Na prática, se você compartilha a internet numa casa, dormitório ou sei lá, com outras pessoas, não use hubs, use switches. Não importa se você confia nas pessoas da sua casa, você não sabe se ela sem querer instalou um malware que colocou o PC dela em modo promíscuo e tá escutando os pacotes da sua rede. Em computação você não deve nunca confiar em ninguém, sob nenhuma hipótese, essa é a regra número um. Nada nunca é 100% confiável, então assuma sempre 100% suspeito.







Enfim, com esses componentes básicos você já deve entender que seus dispositivos conseguem endereços IP usando um servidor de DHCP e por isso muitos de vocês nunca precisaram configurar endereços na mão. Também já sabem que tem esse ARP que descobre qual dispositivo na rede responde pra qual endereço e mantém um cache que faz o de-para de endereço IP pra MAC address. Sabe que todo mundo está conectado no roteador seja diretamente via cabo de rede, via wifi, e se for cabo e tiver múltiplos dispositivos, coloca um switch pra conectar todo mundo de forma mais segura. 

E sabe que internamente os pacotes são roteados pelo MAC address, mas se eu quiser acessar servidores fora da minha rede, peço pro default gateway, que é tipo o porteiro do prédio, pra ir falar com o porteiro do outro prédio. E esse é o básico do básico de redes que você precisa saber.









Mas vamos voltar pro exemplo de acessar o YouTube, acho que dá tempo de explicar como de fato me comunico com o mundo externo, fora do meu prédio. Eu falei que meu PC tem o endereço IP interno de 192.168.1.200 e quero assistir um video no youtube. Eu magicamente falei que ele pode se conectar talvez no prédio vizinho cujo endereço é 142.250.219.14. 

Deixa eu explicar como essa mágica funciona e ela começa na configuração do seu servidor de DHCP no roteador, onde configurei esse tal de endereço DNS. Isso é um servidor externo e normalmente vem o endereço do servidor de DNS do seu provedor, como da Vivo. Eu recomendo como primeira coisa mudar isso ou pro servidor do Google que é 8.8.8.8 ou da CloudFlare que é 1.1.1.1.








Explicando de forma mais simples, um servidor DNS tem como única função traduzir um endereço em forma de texto como www.youtube.com em um endereço IP. A rede não entende nomes humanos, só entende endereços. Quando seu PC pediu um endereço IP pro DHCP ele ganhou também essa configuração de DNS. Quando no seu PC você digitou www.youtube.com no navegador, o PC checa pra qual DNS deve perguntar e vai ser pro endereço que recebeu do seu DHCP. Todos os outros dispositivos da sua casa vão ter essa mesma configuração, seja seu smartphone, seja sua smart TV.









Se eu abrir um terminal de Linux temos o comando `dig` e eu posso fazer `dig www.youtube.com` e volta essa tabela aqui. O que interessa pra gente é esse "Answer Section". E eu vejo que a primeira linha é o `www.youtube.com` que eu pedi. E ele aponta pra um registro CNAME ou canonical name. Um registro CNAME diz pro DNS fazer uma nova pesquisa pra esse nome `youtube-ui.l.google.com`. Daí volta o resto da tabela que diz que esse domínio aponta pra múltiplos registros A com vários endereços. Registro A é um endereço IPv4, registro AAAA seria endereço IPv6 e já falo disso. Mas e agora, o que eu faço com esse tanto de IPs?








Toda vez que você perguntar pro DNS sobe o youtube, ele vai devolver conjuntos de endereços IP diferentes. Essa é uma estratégia do Google. Ele nunca te dá 100% de todos os registros, porque eles tem literalmente centenas de máquinas pro YouTube, em dezenas de data centers espalhados pelo mundo. Ele vai te devolver alguns endereços de máquinas do data center que é geograficamente mais próximo de você. Daí seu PC recebe esse conjunto e faz um round-robin load balancing. Traduzindo, ele faz balanceamento de carga. Ou seja, numa aba ele vai usar o primeiro endereço. Numa segunda aba, ele talvez vai usar o segundo endereço e assim por diante. Assim você vai sempre caindo em servidores diferentes, pra balancear sua carga.










Cada servidor recebe no pacote algumas informações sobre você, como os cookies do seu navegador. Daí ele sabe que você já tinha feito login num outro servidor e te mantém logado no servidor seguinte. Pra você, é como se estivesse sempre no mesmo lugar, sem saber que por baixo seu PC tá te mandando toda hora pra um desses outros servidores da lista. Um DNS é isso, um serviço que contém uma tabelona apontando um nome de servidor pra um ou mais endereços IP.








Lembram quando falei sobre modo promíscuo que alguém pode estar escutando seus pacotes na rede? Então, um provedor sempre está, entre aspas, em modo promíscuo, porque ele recebe os pacotes de todos os clientes assinantes pra poder mandar pra internet. Então ele é obrigado a receber todos os pacotes pra passar pra frente. Claro, se ele for honesto, assim como sua mãe na extensão, deveria só passar pra frente e não escutar a conversa. Mas, seguro morreu de velho e o certo é assumir que não só eles estão escutando, mas registrando e até revendendo esses dados. Você não tem como saber.







Por isso se fala pra nunca acessar sites que não sejam HTTPS, ou seja, cuja conexão é encriptada. Daí mesmo se alguém no meio escutar seus pacotes não tem como saber o que tá sendo transmitido. Porém, DNS normalmente não é criptografado e antes do HTTPS ativar, o navegador precisa converter www.youtube.com pra um dos endereços IP do Google. E essa pergunta pro DNS é feita em forma não encriptada. Claro, o provedor ou qualquer um no meio do caminho pode só ver o endereço IP e deduzir que é endereço do Google. Mas eu já estou dando a informação que é www.youtube.com de mão beijada. E por isso existem novas tecnologias como DNS over HTTPS ou DNS over TLS que, como o nome diz é o equivalente HTTPS pra DNS. 








Isso é simples de ativar, basta colocar na configuração do seu router e seu celular o endereço de um servidor de DNS que suporte DNS over HTTPS, no caso o mais famoso é o 1.1.1.1 do CloudFlare. Mesmo assim, o CloudFlare é outra entidade, o Google também. Eu estaria confiando que eles não estão fazendo nada de errado, o que também é impossível de saber. Mas entre confiar na Vivo ou na Claro, hoje em dia nossa escolha é escolher o menor de dois maus. É por isso que eu pessoalmente uso um DNS caseiro, o Pi-Hole. Como ele cacheia a resolução de endereços, mesmo o CloudFlare pra onde ele conecta não sabe exatamente quando eu pedi esses endereços. Mas isso é tema pra outro dia. Só entenda que estamos meio expostos no setor de DNS ainda.









Enfim, eu fiz uma longa tangente só pra voltar pro assunto de NAT. Agora meu PC tem um endereço IP local graças ao DHCP do meu roteador e eu tenho o endereço IP do youtube, graças a algum DNS como do CloudFlare. Pronto, agora eu posso fazer um pacote com origem sendo 192.168.1.200 e destino sendo 142.250.218.14. Mando o pacote pro default gateway do meu roteador TP-Link. Ele por sua vez roteia o pacote pro Modem na rede 192.168.15.1. E o Modem manda esse pacote pra rede da Vivo.







A rede da Vivo vai enviar pra Internet e aqui vem a parte de roteamento na internet que eu não estou a fim de explicar. Mas pelo menos posso mostrar. No Linux costuma ter um comando chamado `traceroute` e no Windows tem o comando `tracert`. Eu chamo então `tracert 142.250.218.14` 

e ele vai me mostrar o caminho do pacote da minha máquina até a máquina do Google. Olha só, na primeira linha, como falei, vai pro roteador que é 192.168.1.1. Dele vai pro modem 192.168.15.1 que ele chamou de meuvivofibra.  






Lá dentro da rede da Vivo ele passa por outras sub-redes como esse da telesp. Pra quem não sabe a Vivo lá por 2002 ou 2003 foi criada como a junção de várias telecoms pelo Brasil. Em São Paulo, a empresa original era a Telesp. Enfim, dessa rede ele passa pra outra chamada vivozap. E aí vai passando por outros hops até no final chegar no destino. Existem vários serviços com tabelas que associam endereços IP com coordenadas geográficas de latitude e longitude. É uma estimativa. Dá pra chegar perto, mas eu posso mudar o endereço IP de uma máquina numa região pra de outra região. Ainda mais do tamanho do Google que eles podem remanejar grandes grupos de endereços de um data center nos Estados Unidos pro Brasil, por exemplo.









Mas segundo o serviço IP2Location ele diz que esse IP 142.250.218.14 

que eu tentei acessar está em Mountain View, na Califórnia, sede do Google. Mas se eu usar outro serviço como o IPapi.co, ele parece ser um pouco mais atualizado e me diz que esse endereço na realidade está em São Paulo. E isso faz mais sentido. O DNS do Google me mandou pra um endereço mais próximo geograficamente de mim, pra ter menos hops ao longo da rota. Quanto mais perto, menor a latência, maior a velocidade. Por isso grandes serviços como Google tem servidores espalhados ao redor do mundo pra garantir que a maioria das pessoas tenham a melhor velocidade possível.









Tá ótimo. Mas e agora? Como que o Google sabe pra quem devolver os pacotes de video? Ué, é só devolver pra origem que tá registrado no pacote, não? Só que lembra? Meu pacote tá com origem 192.168.1.200. 

Dentro da rede da Vivo não tem só você. Todo cliente da Vivo vai ter IPs como 192.168 alguma coisa. Vira aquela situação que eu falei do vizinho pentelho que copiou o mesmo número do seu apartamento. 

O Google não tem como devolver a resposta pra pessoa certa só com isso. E ele nem precisa, porque ele nunca recebeu esse endereço 192.168.1.200.








E finalmente eu volto pro assunto do tal NAT e como não temos endereços IPv4 suficientes pra todos os dispositivos do mundo. Pra visualizar é a mesma coisa que um número de telefone comercial e ramais. Já pensou que dificuldade que ia ser se uma grande empresa tivesse um número de telefone diferente pra cada pessoa que trabalha lá? Uma empresa com 10 mil funcionários precisando ter 10 mil números de telefone diferentes? Eles não tem. Na realidade normalmente tem um número de telefone comercial que liga num PBX. Esse PBX roteia pra mesa da pessoa certa baseada num número de ramal. 







É parecido na Vivo, o NAT é o PBX. Ela tem alguns poucos IPv4 de verdade. Mas internamente dá tipo ramais pra cada cliente. É isso que um NAT faz, no caso um CGNAT, carrier grade, porque é um NAT gigante. Faz um teste, vai no Google e pesquise por "what is my ip", qual é meu ip. Qualquer primeiro link serve. No meu caso vai aparecer esse aqui que estou escondendo os últimos dígitos. Esse é o endereço IP da Vivo de saída e é esse endereço que ele carimbou por cima do meu pacote antes de enviar pro Google, e é pra esse endereço que o Google vai devolver os pacotes de video.








Daí o CGNAT da Vivo mantém uma tabelona que mapeia que quando voltar resposta do Google, é pra devolver pro modem certo que fez o pedido. E é por isso que você consegue conectar na internet e se comunicar mesmo não tendo um endereço IPv4 válido na internet. O CGNAT faz o trabalho de enviar e devolver os pacotes pras sub-redes corretas. Literalmente Network Address Translator ou tradutor de endereço de redes. O problema disso é que você consegue se conectar nos outros, mas outros de fora não conseguem achar você diretamente. Pra alguém de fora se conectar em você, primeiro você precisa se conectar nele pra abrir uma conexão.









Vou deixar como lição de casa. No mundo de hoje que fazemos chamadas de Zoom, ligação via Whatsapp e outras formas de Voz sobre IP ou VoIP, o requerimento é que duas pontas só conseguem se conectar diretamente se ambos os lados conseguem se encontrar na internet. Mas normalmente você e a pessoa que quer falar estão escondidas numa sub-rede privada atrás de um NAT de provedor. Portanto nenhum dos dois lados está acessível. Como que se cria uma conexão ponto a ponto, sem precisar de intermediários? Pra isso existem formas como ICE que é STUN/TURN e protocolos como RTP. Dêem uns googles aí de como isso funciona. Não vou tentar explicar hoje.









Voltando ao problema de endereços IP serem 32-bits e permitirem no máximo 4 bilhões de endereços. A essa altura já era pra ter acabado esses endereços. Se uma Vivo tiver, sei lá, 100 milhões de clientes, ia precisar de 100 milhões de endereços IPv4, pelo menos, sem contar que cada cliente tem hoje um PC, uma smart TV, alguns smartphones, então fácil ia precisar de meio bilhão de endereços. Mas graças ao CGNAT, faz de conta, com 1 único endereço IPv4 ela pode manter esse meio bilhão de dispositivos em redes privadas escondidas com endereços 192.168 ou 10 ponto da vida por trás. E é assim que a gente evitou acabar os IPv4. Mas isso é um paliativo.









NAT ajudou a evitar o colapso da internet por falta de endereços mas ao mesmo tempo dificultou e complicou muita coisa, como o que falei de Voz sobre IP e todo tipo de conexão ponto a ponto, como você conseguir jogar online com seus amigos. Como na prática todo mundo tá escondido em redes privadas atrás dos provedores, estamos à mercê da boa vontade deles pra muita coisa. Esse problema não é novo, já se falava do problema de acabar endereços desde o fim dos anos 80. Desde o começo dos anos 90 já se começou pesquisas sobre como resolver esse problema. E já temos a solução na forma do IPv6 desde 1998.










Você já deve ter visto IPv6. É um número de 128 bits. Eu venho dizendo que 64 bits é um número absurdo. Computadores modernos de 64 bits não tem barramentos de 64 bits ainda, o máximo acho que é 48 bits, que já é endereço de memória como se não houvesse amanhã mesmo pra um supercomputador. Pra ter uma idéia, a maioria das pessoas hoje já acha 128 gigabytes de RAM algo absurdo. Pra endereçar 128 giga um barramento de 37 bits seria suficiente.








2 elevado a 128 é um número tão absurdo que um ser humano normal não consegue imaginar. Imagina a superfície inteira do planeta Terra, incluindo a superfície dos oceanos, inteiramente coberta por PCs. Eu poderia ter 7 x 10 elevado a 23 endereços IP por metro quadrado. Conseguem entender? 10 seguido de 23 zeros de quantidade de PCs, por metro quadrado. Estudantes de química vão notar que esse número é maior que o número de Avogadro. Literalmente seria possível dar um endereço IP pra cada molécula da superfície da Terra e sobrar. É astronomicamente grande.








Na prática isso significa que todo dispositivo em existência hoje, todo PC, todo servidor, cada smartphone, cada dispositivo inteligente da sua casa como sua TV ou sua geladeira, cada uma poderia ter um endereço IP único com facilidade, por gerações a fio. E fazendo isso não precisaríamos mais estar atrás de um CGNAT. Todo mundo poderia estar diretamente na internet sem intermediários, o que facilitaria muito todo tipo de serviço ponto a ponto como voz sobre IP, e nunca teríamos que nos preocupar de novo com acabar endereços e ter que fazer gambiarras como NAT.







O problema é que o sucesso da internet evitou que pudéssemos migrar pra melhor solução a tempo. IPv6 surgiu no calor da febre da bolha da Internet do fim dos anos 90. Pra maioria da população, nem se sabia se essa tal de internet ia mesmo dar certo. Muita gente achava que era só um troço passageiro que ia morrer logo. Coisa de hipster. Usar internet no fim dos anos 90 era opcional, e muita gente não tava interessada. Pra dar certo, investiu-se tudo no que já existia e se sabia que funcionava, que era IPv4. Por que a gente ia se preocupar em acabar endereços se ninguém nem sabia se ia entrar gente suficiente pra acabar os endereços? Migrar naquele momento pra IPv6 parecia uma otimização prematura.









E pra piorar, tivemos o crash da bolha da internet em 2001. Aí sim, ninguém ia investir milhões de dólares pra migrar toda a infraestrutura de tudo pra IPv6. Pra tudo funcionar perfeito, o certo, seria o mundo inteiro migrar quase que tudo de uma vez pra IPv6. Senão como alguém com IPv4 vai conectar num servidor IPv6? Pra isso foram sendo inventadas formas de migração menos agressivas como NAT de IPv6 pra IPv4. Temos NAT64 por exemplo, que permite que PCs que já usem endereço IPv6 consigam conectar em servidores que ainda são IPv4. Mas a moral da história foi essa: o inimigo do IPv6 foi o sucesso do IPv4.







E vocês sabem, se alguma é opcional, a maioria sempre vai esperar até a última hora. Por que eu vou gastar meu tempo pra ter todo esse trabalho se todo mundo ainda vai estar usando o esquema antigo? Vou ficar no antigo também. É a lei do menor esforço. Migração pra IPv6 só vai acontecer o dia que for mandatório, tipo os governos decidirem que ninguém mais acessa nenhum serviço do governo se não for IPv6. Mas governos normalmente são os últimos a adotar qualquer coisa nova. Eu não esperaria muito deles. Enquanto isso a gente vive num mundo em eterna transição entre IPv4 e IPv6. Alguns provedores já suportam nativamente, alguns você pode ligar e pedir pra habilitar roteamento por IPv6, mas não tem um padrão. Cada caso é um caso. 








Tem uma questão de privacidade também. Se todo dispositivo tiver um IPv6 estático, seria como um MAC address que nunca muda. Hoje em dia ninguém do lado de fora pode dizer com 100% de certeza quem é você porque só enxerga o IP público do provedor e não seu IP privado da rede atrás do NAT. Mas se for direto com IPv6 dá pra dizer com certeza que veio do seu dispositivo. Por isso sistemas operacionais como Windows usam números IPv6 temporários pra se comunicar e garantir algum nível de privacidade. Não recomendo desligar isso. Mas veja, se eu der o comando `ipconfig` no meu Windows eu vejo que eu tenho um IPv6 estático na minha placa de rede, que obviamente estou obfuscando uma parte, e embaixo tenho o IPv6 temporário, que é o que um servidor iria ver se eu conectar direto nele sem NAT.








De qualquer forma, se IPv4 até dava pra você decorar. IPv6 é mais difícil. Primeiro o número é longo, então a notação pra ficar menos difícil digitar foi separar oito blocos de 16 bits por dois pontos. Mas diferente de IPv4 onde escrevemos cada bloco no formato decimal mesmo, de 0 até 255, 16 bits é um número que vai até mais de 65 mil então ficaria longo. Por isso escrevemos em hexadecimal, onde cada dígito vai de 0 até F, assim o bloco precisa de no máximo 4 dígitos hexadecimais. São 8 blocos de 4 dígitos hexadecimais separados por dois pontos.








Se escolher direito, pelo menos no começo, vai ter muito endereço com vários blocos de zero no meio. Pra facilitar, o protocolo permite omitir esses blocos. E finalmente, endereços IPv4 podem ser escritos como IPv6 colocando dois dois pontos antes do endereço escrito no mesmo formato de antes. Enfim, pra maioria tudo isso é automático, porque o modem do provedor vem com servidor de DHCP e ponto de acesso wifi, então ele automaticamente te dá endereço IP, configura seu DNS, e basta você se conectar no Wifi que já tá navegando. Mas programadores precisam saber que esses detalhes existem. Em breve muitos de vocês vão precisar lidar com esse problemas, como conectar pessoas num app de comunicação ponto a ponto tendo que furar NAT ou implementar IPv6.








E com isso terminamos essa parte da mini-série sobre o básico de redes. Isso resume, super resumido, os capítulos de camada física, camada de data link, camada de rede e um pouco da camada de transporte do modelo OSI, com um pezinho na camada de aplicação que é a parte mais prática de verdade e que devo tentar falar mais em outros episódios. Se ficaram com dúvidas mandem nos comentários abaixo, se curtiram o video deixem um joinha, assinem o canal e compartilhem o video com seus amigos. A gente se vê, até mais!
