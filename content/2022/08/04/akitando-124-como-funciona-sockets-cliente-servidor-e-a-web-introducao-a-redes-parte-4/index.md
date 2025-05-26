---
title: "[Akitando] #124 - Como Funciona Sockets, Cliente, Servidor e a Web? | Introdução
  a Redes Parte 4"
date: '2022-08-04T10:21:00-03:00'
slug: akitando-124-como-funciona-sockets-cliente-servidor-e-a-web-introducao-a-redes-parte-4
tags:
- IPC
- socket
- node.js
- http
- https
- tls
- ftp
- sftp
- telnet
- ssh
- port
- browser
- akitando
draft: false
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/lc6U93P4Sxw" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Agora que todo mudno sabe como funciona o básico de rede, vamos ver como funciona o básico de aplicações de rede, o que são sockets, pra que eles servem, como disso chegamos em protocolos como HTTP ou FTP e os vários detalhezinhos que complicam a cabeça de um iniciante em programação Web.

## Conteúdo

* 00:00 - Intro
* 01:36 - Noção de Sockets
* 02:26 - Entendendo Comunicação Entre Processos
* 03:18 - Memória Protegida/Isolada Impede Comunicação
* 05:30 - Comunicação via Pipes
* 07:18 - Comunicação via Arquivos
* 09:56 - BSD Sockets
* 12:43 - Fluxo de conexão
* 16:54 - Portas
* 19:55 - Recapitulando navegador/DNS
* 21:15 - Exemplo de server web com Node
* 22:17 - localhost é diferente de 0.0.0.0
* 23:43 - Continuando Exemplo de Node
* 24:19 - Portas Efêmeras
* 25:47 - Continuando Exemplo de Node
* 29:00 - Debugando com Telnet e Developer Tools
* 31:57 - Camadas de Segurança
* 34:07 - Big Loop
* 37:24 - OSI, TCP, HTTP
* 39:28 - Mostrando FTP
* 42:25 - De redes distribuídas a "walled gardens"
* 45:06 - Bloopers

## SCRIPT

Olá pessoal, Fabio Akita

No começo dessa mini-série eu ia só até o episódio passado, mas depois que escrevi, resolvi estender mais três episódios. Estou pulando toda uma parte sobre rede física, MLPS, OLDM, Wimax, 802.11. Vale estudar o livro de redes do Tanenbaum pra esses detalhes, o objetivo é focar mais em assuntos que ajudem programadores e não quem está interessado em seguir na carreira de infraestrutura, por isso eu sei que pra quem é de telecom ou infra tem bastante coisa simplificada. Agora quero ir direto pra camada de transporte e aplicação e nos próximos episódios falar assuntos que o Tanenbaum não chega a explicar no livro. 



Só antes de continuar, tem uma errata que esqueci de falar nos videos anteriores, sobre o primeiro video de redes. Lá eu tava tentando simplificar com metáforas pra falar que ondas como de rádio e internet wireless se parecem com ondas na água, mas do jeito que falei ficou parecendo que wireless precisa de um meio como ar pra se propagar, mas claro que não, ondas na água são diferentes de ondas eletromagnéticas, que se propagam no vácuo, diferente de som. Por isso que no espaço não tem barulho, mas satélites conseguem se comunicar. Já tá na errata do episódio mas achei melhor esclarecer.



Todo programador vai ter que lidar com coisas como endereços IP, que já expliquei, e também com as tais portas. Toda vez que você roda um `npm start` da vida, sobe uma aplicação web nas tais portas 3000 ou 4000. Todo tutorial só menciona isso: magicamente funciona. Mas não explica o que está acontecendo de verdade. É hora de entender a mágica. O episódio de hoje é sobre sockets.




(...)






Em resumo bem resumido, pense em sockets literalmente como tomada da sua casa. Diferentes portas tendo diferentes padrões de buracos, como o padrão brasileiro sendo uma porta, padrão europeu sendo outra, padrão americano outra e assim vai. E só plugues corretos encaixam em determinadas tomadas. Por isso seu notebook importado não encaixa na porcaria da tomada do Brasil. +





Na prática o conjunto de endereço IP e porta de saída, digamos, do seu navegador conectando num site, e o endereço IP e porta de entrada do tal site, essas quatro informações é o mínimo pra definir um socket. É o plug e a tomada conectada. Não se atenha tanto ao nome mas a esse conjunto de informações, é o que se precisa pra formar uma conexão de rede entre dois processos, que é o caminho que os pacotes que falamos antes vão trafegar.






Sockets, na verdade, é uma forma de comunicação entre processos. Todo sistema operacional existe pra gerenciar processos. Expliquei isso nos videos de Programação pra Iniciantes, em particular nos de concorrência e paralelismo e gerenciamento de memória. Processo é todo programa que tem rodando no seu computador, seja seu spotify ou banco de dados. No nível mais básico, um processo é representado por um número, um process ID ou PID que o sistema operacional dá pro seu programa. Quando do terminal de um Linux se digita `ps -ax` dá pra ver os processos e seus PIDs. O sistema operacional aloca uma certa quantidade de memória e internamente, seu processo acha que tem acesso a toda memória teórica de 64-bits, mas na realidade o sistema operacional é quem intermedia o acesso à RAM ou Swap de disco.







Isso é importante. Um processo é como uma criança rica mimada gastando cartão de crédito dos pais. Ele não tem noção que tem limite, e só vai gastando, e os pais, que é o sistema operacional, vai sempre só pagando, então essa criança tem a ilusão que tem dinheiro infinito. É mais ou menos assim. Seu PC tem só 8 giga de RAM real, mas seu processo acha que tem do endereço 0 até 2 elevado a 64 de memória, que seria o máximo teórico de 16 exabytes. Nenhum computador de verdade tem exabytes de RAM ainda. Isso é importante de entender então vou insistir com outra metáfora.







Cada processo rodando na máquina enxerga uma memória virtual, de 0 até 16 exabytes. Quando falamos que se consegue endereçar memória, na realidade pense assim: Imagine um livro com uma parte de índice no começo. O índice tem espaço pra 16 exabytes de linhas, mas o livro em si não tem 16 exabytes de páginas, saca? Todos os processos estão compartilhando a mesma memória física de 8 gigabytes reais, mas ele só enxerga o índice. 






O sistema operacional intermedia e garante que um processo não consiga acessar a memória real inteira, as páginas do livro, de outro processo. Por isso falamos que rodam isolados, sem um sobrescrever a memória do outro. Eu explico sobre isso nos episódios sobre gerenciamento de memória. Mas a parte importante é entender que um processo não enxerga nunca a memória de outro processo. Ele acha que está sozinho na máquina.







Antigamente, nos primeiros computadores sem isolamento de memória, um processo poderia escrever num endereço de memoria real e um outro processo poderia ler essa informação diretamente desse endereço. Um livros sem índices. Na época dos computadores de 8 e 16 bits era mais ou menos assim. Até a Intel inventar memória protegida. Todo processo enxergava todas as páginas e poderia escrever em qualquer lugar. Endereçar memória diretamente era mais rápido mas levava a dezenas de bugs de um processo escrevendo em cima de endereços que outro processo tava usando, levando desde a comportamento não-determinístico até a crashes. Isso era menos ruim quando a gente só rodada um programa de cada vez, na era do MS-DOS. Mas nos primeiros Windows isso já era um problemão.







Desde que passamos a isolar os processos e demos endereços virtuais em vez de reais, pelo menos essa categoria de bugs foi extinta, já na época do Windows 3.1 e foi melhorando a cada nova versão. Também significa que se um processo quiser se comunicar com outro processo, não tem como, porque não tem como gravar algo na memória que outro processo possa ler diretamente. As únicas duas formas de dois processos se comunicarem ou é via pipes ou via arquivos. Vamos entender.







Pipes de Linux é simplesmente ligar a saída padrão de um programa na entrada padrão de outro programa, o stdout ligado ao stdin via um pipe, ou cano. Que nem quando fazemos `cat algum_arquivo` pipe `grep alguma coisa`. Expliquei um pouco disso no episódio de Ubuntu se quiser relembrar. Isso significa que um programa roda primeiro, cospe algum resultado no stdout, e esse resultado é passado pro stdin, pra entrada, do próximo programa. É uma forma de dois programas diferentes se comunicar, mas é uma forma serial: um programa precisa rodar primeiro até o fim, terminar, e só depois começa o outro. 








Portanto é mais complicado se eu quero os dois programas rodando em paralelo, sem um esperar o outro terminar. A única outra solução é um programa ficar cuspindo coisas num arquivo e o outro programa ficar lendo desse arquivo. Esse arquivo serve de ponte, de stream de entrada e saída pra ambos, criando um tipo de conexão. Isso resolve o problema deles conseguirem rodar em paralelo, ao mesmo tempo. Como exemplo, pense num programa que vai gravando coisas num arquivo de log e pense outro programa como o Prometheus, que vai lendo esse log e organizando a informação. Arquivos é uma área compartilhada que dois processos podem usar pra se comunicar, já que memória é isolada.








Todo iniciante precisa se acostumar a lidar com arquivos. Sem entrar em detalhes, na maioria das linguagens, você manda abrir um arquivo a partir de um path ou caminho, que é a sequência de diretórios e sub-diretórios separados por uma barra e o nome do arquivo com extensão. Isso abre o que chamamos de um stream, pense como se fosse um cano de bits bidirecional, um rio onde flui bits. Agora podemos ou ler ou escrever nesse stream.






Podemos ler bit a bit, ou pedir pra ir enchendo tipo um balde antes, um buffer, um acumulador, pra pegar linha a linha de cada vez, por exemplo. Mesma coisa pra escrever, podemos jogar bit a bit nesse stream, ou preencher um buffer antes e mandar vários bits de uma só vez, como uma linha inteira. Podemos programar pra deixar encher esse balde, e quando tiver uma certa quantidade de bits ou quando vier algum caracter especial como uma quebra de linha, pedir pra notificar o programa pra fazer alguma coisa com o que veio. De novo, a maioria das bibliotecas de linguagens modernas já cuidam disso e você como programador só lida com coisas como linha a linha. Mas por baixo existem coisas como buffers. 







Vale lembrar que se você programar numa linguagem um pouco mais baixo nível, tipo C, Rust ou até Java, vai lidar mais com esses conceitos de buffers. Java tem classes como Buffered Stream, por exemplo. Numa linguagem mais alto nível como Javascript, ele cuida disso pra gente por baixo dos panos, e você só fala "vai lendo de linha a linha e vai me dando". Bibliotecas de linguagens de alto nível foram feitas pra oferecer produtividade ao custo de dar menos controle. Por outro lado é o velho 80/20, pra 80% das coisas que precisa, o 20% que oferece por padrão costuma ser suficiente. Pros outros 20%, aí precisa descer pra um C da vida.







Só pra ter de referência aqui, como que em Javascript com Node dá pra escrever e ler de um arquivo? Primeiro carrega a biblioteca "fs" de filesystem e ele tem várias funções como esse `writeFile` onde passo o nome do arquivo e o conteúdo como String. Se não der nenhum erro, podemos usar `readFile` pra ler o conteúdo que acabamos de escrever e mostrar na tela com o bom e velho `console.log`. Mas o principal é entender que a semântica são funções como essas, read alguma coisa, write alguma coisa.



`var fs = require("fs");
fs.writeFile('hello.txt', 'Hello World', function(err) {
   if (err) {
      return console.error(err);
   }

   fs.readFile('hello.txt', function (err, data) {
      if (err) {
         return console.error(err);
      }
      console.log("read: " + data.toString());
   });
});`




Enfim. Com pipes e arquivos, você tem o mínimo suficiente pra fazer dois processos comunicarem entre si mesmo sem compartilhar memória RAM. Esse tipo de técnica fica embaixo de um guarda chuva de assuntos que chamamos de IPC ou inter process communication. Existem outras formas de comunicação como sinais, mas só isso é suficiente pra hoje. Se você só tem um computador, isso é suficiente. Mas aí lá nos anos 60 inventaram um troço que fodeu esse esquema. Essa tal de rede.







Com redes, temos mais de um computador rodando em paralelo e seria bacana se um processo rodando em um computador pudesse falar com um processo rodando em outro computador. E seria mais legal ainda se pudéssemos usar uma semântica parecida com lidar com arquivos, sem de fato usar arquivos. Ter comandos parecidos como "read" ou "write", ler ou escrever num stream de bits. Pensando assim que em 1983 surge a implementação de Berkeley Sockets no UNIX original BSD versão 4.2. 







Por isso são chamados de BSD sockets, de Berkeley Software Distribution ou POSIX sockets. POSIX que é o conjunto de APIs e protocolos que define o que é um UNIX. Pra entender um pouco mais sobre UNIX e Linux e licenças de software livre, não deixe de assistir o episódio de Apple e GPL que fiz faz tempo. BSD Sockets se tornou meio que o padrão de como lidamos com comunicação entre processos de forma mais geral. 







Já vimos nos episódios anteriores dessa mini-série de redes, como que informação é fragmentada em pacotes, e como esses pacotes são transferidos numa rede de um computador até outro, seja numa rede local ou seja na internet em geral. Vamos assumir que tudo isso funciona e que os sistemas operacionais sabem como produzir pacotes e enviar na rede e consumir pacotes que chegam da rede, seja via fibra ótica, cabo de cobre ou rede sem fio.








Não por acaso venho me repetindo bastante sobre sistemas de armazenamento: como HDs são dispositivos de blocos e não dispositivos de arquivos. No baixo nível do hardware, sistemas operacionais lidam com blocos de bits num HD ou blocos de bits em pacotes de rede. Tudo são blocos, toda informação é fragmentada e transferida num stream. Podemos fazer buffers de blocos. Se blocos de bits forem arquivos num HD, podemos pensar em blocos de bits que vem pela rede meio como arquivos também. As abstrações são parecidas embora no meio físico sejam diferentes. No fim do dia você está lendo bits de algum lugar e escrevendo bits em algum lugar, esse é o conceito principal.








Não é a definição exata mas a grosso modo poderíamos pensar em sockets como uma generalização das primitivas de arquivos. Um Linux entrega um file descriptor ou file handle pro seu programa, tanto se for um arquivo local no seu HD ou um socket de rede. Pense em um handle ou descriptor como uma caixa preta que representa um arquivo, um intermediário pra quem você pede pra receber bits ou enviar bits. E essa caixa preta poderia ser um arquivo em disco, mas poderia ser uma conexão remota em rede. Tem uma preparação extra que precisa fazer pra se comunicar na rede e em toda linguagem de programação vai ser parecido. O protocolo que os Berkeley Sockets definiram funciona mais ou menos assim.






`const http = require('http');

const hostname = '127.0.0.1';
const port = 3000;

const prepareResponse = (req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('Hello World\n');
}

const server = http.createServer(prepareResponse);

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});`


Primeiro seu programa pede um bind pro sistema operacional. Bind é literalmente ligação, a ligação de um endereço IP com um outro número de 16 bits que chamamos de porta. Bind é um pedido de registro. Funciona assim. Todo processo quando inicia, o sistema operacional oferece um número de identificação, o tal PID. Só que esse PID muda o tempo todo. Hoje seu Spotify inicia com PID 10. Mas amanhã pode já ter outro programa com PID 10, então o sistema atribui PID 11 ou qualquer outro número. PIDs identificam programas rodando naquele momento, mas não servem pra identificar um programa individualmente a qualquer momento. Então precisamos de outro número que seja fixo que o programa possa pedir pra se registrar.








Digamos que seu programa peça pro sistema registrar ele com o número 3000. O sistema operacional mantém uma tabela em memória e poderia associar o PID atual do seu programa, digamos que seja 11, com esse número 3000, que ele chama de porta, ligados ou bound num endereço IP. Porta é um número que identifica um processo que o sistema operacional mantém numa tabela de controle na memória dele. Se ninguém antes pediu pra registrar essa porta, o sistema te associa nela e nenhum outro programa pode pedir pra se ligar na mesma porta. Porta é só isso, um identificador do programa rodando ligado ao endereço IP do computador.








Quando o sistema consegue te associar nessa porta 3000, devolve um ok pro programa e devolve o equivalente a um stream de bits, o cano aberto, como se tivesse acabado de conseguir abrir um arquivo. E agora seu programa pode entrar em modo de escuta, ou listen. Nesse momento ele fica bloqueado esperando o sistema te mandar alguma coisa por esse cano e não precisa fazer mais nada enquanto isso. Normalmente isso fica numa thread bloqueada ou é usado I/O assíncrono, que não é escopo explicar hoje. Só entenda que depois do bind, seu programa ficaria parado esperando e escutando o que vier através dessa porta 3000. O processo de bind e listen de sockets é similar ao processo de dar open e abrir um arquivo.








Daí alguém na rede resolve mandar alguma informação, pro endereço IP do computador onde ele tá rodando, e mandando junto que quer falar com seja lá quem está ligado nessa porta 3000. O sistema operacional recebe isso e vê, "hum, quem tá escutando na porta 3000, vamos ver na tabela, ah é o processo de PID 11, vou mandar no cano aberto dele". Agora seu programa, que estava só escutando, começa a receber bits. Nesse momento ele pode escolher aceitar ou rejeitar, normalmente só se aceita, isso é o passo de accept. 







E é no accept que fecha o que se chama de conexão entre este computador e o outro que pediu a conexão. O socket serve pra estabelecer essa conexão, esse stream de bits, entre dois programas rodando, mesmo se for em máquinas diferentes. E agora os dois programas precisam enviar comandos que ambos entendam. Se seu programa receber bits que formam um comando válido, pode começar ou a receber ou a enviar bits de volta pela mesma conexão. Aqui é a metáfora das tomadas de padrão diferente. 







Pra comunicação acontecer, ambos precisam concordar que comandos aceitam trocar. Esse acordo entre as duas pontas é o tal de protocolo. Pense em protocolo como sendo os pinos nas posições corretas que encaixam certo nos buracos da tomada. Mesmo tendo um processo pendurado numa porta, se ele não for um servidor web, não adianta um navegador web tentar se comunicar nele, eles não vão se entender e só vai dar erro. Por exemplo, se um navegador web tentar se conectar com um servidor de banco de dados, só vai dar erro, porque o banco de dados não entende comandos de HTTP que o navegador manda.








Falando bem resumido, esse é o básico do básico do básico de programação distribuída em rede. Toda linguagem vai te dar bibliotecas e funções que tem nomes parecidos com esses passos, bind, listen, accept, send. Apesar da sintaxe de cada linguagem ser diferente, podem ver que em todas é o mesmo processo, porque as primitivas no sistema operacional são as mesmas e as tecnologias de rede são as mesmas. Independe da linguagem, o jeito de falar em rede é sempre a mesma. Eu sempre falo que é mais importante saber a fundação do que uma linguagem só, porque se você aprendeu isso em C, facilmente vai conseguir fazer a mesma coisa em Java ou Python.









Do lado do sistema operacional, entenda que portas é só uma tabelona com identificadores numéricos de 16-bits, onde é possível associar 2 elevado a 16 portas no total, de 0 até 65 mil 536. Por isso você nunca viu número de portas acima disso. Essa tabelona diz que se receber bits endereçados pra um IP e porta, ele sabe pra qual cano de qual processo rodando enviar. Agora vamos entender isso a partir do programa mais comum pra se comunicar em rede hoje, seu navegador web, como Chrome ou Firefox.








Seu navegador é um exemplo desse tal programa que pede uma conexão, um cliente. Ele não precisa fazer bind, porque não precisa que ninguém se conecte nele. Ele só quer se conectar na porta dos outros, de um servidor web. E é isso que diferencia um cliente de um servidor. Um servidor faz bind e listen numa porta e fica esperando, escutando. Um cliente envia pacotes pro endereço IP do servidor e pede pra se conectar num programa rodando lá que está escutando numa determinada porta. Pra isso funcionar, o cliente precisa saber não só o endereço IP como em qual porta o servidor está escutando. E por isso se estabeleceu que certas portas são exclusivas pra um determinado uso.









Mas não se enganem, portas são só números numa tabela que o sistema operacional gerencia. Os usos de cada número de porta são completamente arbitrários, determinados por consenso, e pro programa em si não faz nenhuma diferença se ligar numa porta 80 ou 3000 ou 8080. Não existe nenhum tratamento especial diferente. Portas são só números. E por isso você sobe uma aplicação web feita em Node numa porta 3000 e ela funciona igual quando subimos na porta 80 num servidor na Amazon.








Por convenção, estabeleceu-se que as primeiras 1024 portas, de 0 até 1023 são portas de sistema, e num Linux precisa ter permissão de root pra fazer um programa se registrar numa delas. Essa distinção existe porque vários usuários podem abrir sessões num mesmo servidor UNIX ou Windows Server, mas só o administrador pode subir processos em portas abaixo de 1024. Usuários nesse servidor podem subir processos em outras portas menos nessas. É nesse intervalo que se encontram as duas portas mais famosas de todas, a 80 de HTTP e 443 de HTTPS. Temos outras famosas, como porta 21 de FTP, porta 22 de SSH, porta 25 de SMTP pra envio de emails, porta 37 que usamos pra sincronia de horário via NTP, porta 53 que é DNS, porta 194 é de IRC, 993 pra IMAP de cliente de email e assim por diante. 









Existe uma organização que registra o uso dessas portas baixas, a IANA ou Internet Assigned Number Authority. Dá pra ligar qualquer programa numa porta baixa, mas normalmente essas portas costumam ter serviços específicos como servidor web ou DNS. Por isso que num navegador quando digitamos endereço, podemos omitir a porta, porque o navegador preenche a porta pra gente usando essas convenções. Quando digitamos http://www.google.com primeiro ele precisa resolver esse nome de domínio, pra isso resolve esse nome num endereço IP e pra isso precisa de um name server ou DNS.








Já mostrei no episódio anterior como seu sistema operacional pergunta quem é esse nome pra um DNS, como o 1.1.1.1 da CloudFlare ou 8.8.8.8 do Google. O DNS vai te devolver um grupo de endereços IP e seu computador escolhe um deles. A partir desse ponto faz um cache disso localmente. Se no navegador pedir de novo o www.google.com, nem precisa pedir pro DNS, porque já tem gravado num cache local. Toda resposta de DNS tem uma coisa chamada TTL ou time to live, que é tipo uma expiração. Quando expirar, aí sim seu computador vai no DNS e pergunta de novo qual é o endereço do nome www.google.com. Em outro video vou explicar DNS com um pouco mais de detalhe mas se acostumem com esse conceito primeiro.










Enfim, graças ao DNS ou o cache local de DNS, seu navegador agora tem um endereço IP. Ele pode começar a se conectar. Mas como disse antes, precisa saber em que porta nesse endereço vai estar o programa que vai te devolver os HTMLs. Esse programa chamamos de servidor web, e como falei antes, por convenção, vai estar escutando nas portas 80 ou 443. Se no navegador você digitou http:// significa que quer conectar na porta 80. Se digitar https:// quer dizer que quer conectar na porta 443. O que vem antes dos dois pontos é com qual protocolo quer se comunicar com esse servidor, no caso HTTP ou HTTP com TLS.









Protocolos é quem definem os tais comandos e valores que ambos o navegador e o programa servidor web conseguem entender, os pinos certos pros buracos certos da tomada. No protocolo HTTP temos comandos em texto como GET ou POST pra pedir ou enviar coisas do navegador pro servidor. Vamos fazer um exemplo simples só pra consolidar o conceito. Vou fazer rapidinho um servidor web em Node.js estilo hello world, só pra ter um programa escutando numa porta. Isso você encontra quinhentos tutoriais na internet não vou detalhar muito.








Olha esse do tutorial do próprio site oficial do Node.js. Primeiro ele carrega a biblioteca "http". Em seguida declara duas variaveis, uma pra guardar o endereco 127.0.0.1. Esse é o endereço que chamamos de loopback, ele representa o endereço local de rede do seu computador. Todo pacote enviado pra esse endereço não vai sair do seu computador, ele vai devolver pra ele mesmo. Por isso chamamos de loopback. Vale entender isso porque muita gente acha que 127.0.0.1 é a mesma coisa que outro endereço, o 0.0.0.0 e não sabe a diferença.






Normalmente um endereço IP é associado com uma placa de rede instalado na sua máquina, mas 127.0.0.1 é como se fosse uma placa de rede virtual, de mentira. Ele recebe pacotes e devolve pra ele mesmo. 127.0.0.1 é a mesma coisa que localhost. Quando damos bind de um processo nesse endereço, dá pra abrir o navegador e conectar por ele com http://localhost. Mas se alguém de fora tentar se conectar no mesmo serviço, na mesma porta, não vai conseguir, porque na placa de rede de verdade não tem bind nessa porta. Localhost só é acessível de dentro do próprio computador, não de fora.






Tem também o endereço 0.0.0.0 que significa “qualquer placa de rede do computador”. Quando queremos pendurar um servidor que vai receber bits independente de por qual placa de rede do seu computador vier, penduramos ele no 0.0.0.0. E no navegador podemos digitar localhost porque 127.0.0.1 é um desses “qualquer placa de rede”, mas também um navegador em outro computador na rede, vai conseguir se conectar no seu programa. Todo computador responde nesses endereços locais. Muita gente pensa que são a mesma coisa, mas só localhost e 127.0.0.1 são a mesma coisa. Pra desenvolvimento a gente usa localhost, porque normalmente não queremos outra pessoa na mesma rede acessando enquanto estamos no meio do desenvolvimento. Mas num servidor de verdade queremos dar bind em 0.0.0.0 pra deixar o programa acessível a qualquer pessoa.









A segunda variável define que quer se ligar na porta 3000. Eu expliquei que portas de 0 até 1023 são reservados e o sistema operacional exige permissão de administrador pra ligar um programa nessas portas baixas. Por isso que em máquina de desenvolvimento, preferimos usar portas de 1025 até 49 mil 151. Porque com suas permissões de usuário normal, pode pedir pro sistema ligar seu programa numa porta, sem privilégios especiais, sem precisar ficar usando o comando `sudo` toda hora. Por isso que pra subir uma aplicação de Node.js ou Django ou Laravel, numa porta como 3000 ou 4000, não precisa executar com `sudo`. 








Pra complementar, de 49 mil 152 até 65 mil 535 são o que chamamos de portas dinâmicas ou privadas. Em particular 49 mil 152, que é um número difícil de decorar em decimal, mas é a mesma coisa que 2 elevado a 15 menos 2 elevado a 14, que é mais fácil de lembrar. Também são chamadas de portas efêmeras. Você até pode mas normalmente não se registra nenhum programa servidor que vai ficar rodando permanentemente nesse segmento. Essas são as portas usadas, por exemplo, por comunicadores como o Zoom ou Skype pra abrir conexão com outra pessoa na internet. Pode ser usado por games pra sessões multiplayer. São portas temporárias. Programas de comunicação tentam diversas dessas portas e usam a primeira livre que acharem. Não é regra, mas eu acho que programas que usam UDP em vez de TCP usam mais essas portas.








Por isso que nós programadores web, quando fazemos uma aplicação usando Node.js ou Spring ou Laravel ou qualquer coisa assim usamos portas como 3000, 4000, 8000, 8080 como era o Tomcat de Java e assim por diante. Qualquer uma depois de 1024 e antes daqueles 49 mil e tanto servem. Sem interferir com calls de Zoom e sem precisar de privilégios de administrador e ter que ficar digitando `sudo`. De novo, portas são só números. Se você achava que porta 8080 ou 3000 tinha algum significado, não tem, foram escolhidas arbitrariamente por alguém e todo mundo só usa a mesma porta por convenção.








Enfim, agora é específico de cada linguagem e framework, mas no caso do Node criamos uma instância do que ele chama de "server". Eu modifiquei um pouco o exemplo do tutorial porque quando criamos o servidor já registramos como queremos que ele responda quando vier algum comando de HTTP. Já volto nisso. Na sequência, fazemos essa instância de server pausar e ficar escutando, esperando alguma coisa, que o sistema operacional vai mandar pra gente no cano dessa porta 3000. Se ninguém mais estava pendurado na porta 3000, e ele conseguir se ligar com sucesso, daí escreve essa mensagem de servidor rodando. E pronto, agora está escutando na porta 3000 desse computador.







Vamos voltar pro navegador. Lá no campo de endereço escrevo que quero usar o protocolo "http", dois pontos, barra, barra, localhost que é outra forma de dizer "127.0.0.1", dois pontos, porta 3000. Se eu não colocasse explicitamente esse dois pontos 3000, ele ia assumir que seria porta 80. Tenta aí, em qualquer site como google.com, digita no final dois pontos 80. Vai ver que dá no mesmo. 







E pronto, veio uma resposta Hello World. Vamos voltar pro código do servidor. Lembra que quando criei a instância de server registrei uma função de resposta? O framework do Node esconde os detalhes. O Linux recebeu os pacotes de bits do navegador endereçados pra porta 3000, viu que tinha meu programa pendurado nele e começou a reenviar os pacotes pro cano da porta 3000.








O meu programa em Node começa a receber pacote e dá accept. E aí vê o que fazer com esses pacotes. Daí tinha essa minha função registrada no server. Ele encapsula esses pacotes numa estrutura chamada Request, ou HTTP Request. É isso que faz essa biblioteca "http" que estamos usando. Ele se encarrega de receber os bits e organizar tudo bonitinho nesse objeto de Request pra gente. A partir desse ponto eu posso fazer lógica de código pra fazer coisas diferentes dependendo do que vier nessa request, como carregar um arquivo HTML. No caso, como é um exemplo besta, eu só mando responder a mensagem de Hello.







Mas não é só a mensagem. Isso é um protocolo, tem algumas regrinhas. O mínimo do mínimo que se espera de resposta é montar uma segunda estrutura chamada HTTP Response. Nesse response registro um status code 200, que é o código do protocolo HTTP pra dizer que tá tudo ok, daí por boa etiqueta, registro também um cabeçalho com um mime type, no caso pra indicar que não vou responder um HTML e sim só um texto puro. É com esse mime type que o navegador sabe se é pra interpretar como HTML ou se é um binário e é pra fazer download, por exemplo. E finalmente, posso escrever minha mensagem de hello no response como um simples string.






O Node vai pegar esse pacote de response que preenchi e mandar pro sistema operacional devolver pela rede pro navegador pela mesma conexão. E o sistema operacional por baixo vai fazer tudo que já expliquei antes, vai quebrar esse response em datagrams, vai encontrar a rota pra enviar, etc. E no final o navegador vai receber o pacote de resposta e interpretar isso visualmente na tela, desenhando o hello na tela pro usuário. Esse é o fluxo mais básico de web. Se não entender nem isso, não vai entender nada mais complicado, então garanta que esse fluxo está super claro na sua cabeça.









Tem outra forma de ver como isso funciona. Antigamente todo sistema operacional vinha com um programa de internet bem simples chamado telnet. É um programa que se conecta em qualquer porta que tenha algum outro programa escutando e com ele posso manualmente digitar comandos pra enviar, caso eles aceitem comandos em texto em vez de binário. No caso do Arch Linux hoje ele fica no pacote opcional chamado de inetutils. Em nenhuma distro se instala mais por padrão porque acho que é considerado um risco de segurança. São ferramentas que precedem o conceito de encriptação. Em vez de telnet hoje se usa SSH pra abrir conexões encriptadas, mas como não quero ter que lidar com criptografia neste episódio, deixa eu mostrar o bom e velho telnet.










Aquele meu programa de hello de Node continua rodando. Ele tá pendurado na porta 3000 e mesmo quando processa a requisição de algum navegador, continua aceitando novas requisições de outros navegadores. Por isso que um servidor web consegue atender várias pessoas ao mesmo tempo. Vamos abrir um outro terminal e conectar direto nele usando telnet, passando o endereço e a porta.








Pronto, estou conectado. Agora posso enviar uma requisição HTTP manualmente. O protocolo HTTP diz que posso digitar o comando GET seguido de uma URI que é o barra alguma coisa e no final escrever HTTP/1.0 denotando a versão do protocolo que estou querendo usar. Isso é tudo texto. Nas linhas seguintes posso mandar outros detalhes desse comando, mas se der dois enters, duas quebras de linha, isso indica pro servidor que terminei minha requisição.








E olha só, quando dei dois enters, o Node entendeu que podia começar a responder, e essa é a resposta que ele envia. Olha só o que tinha mandado ele preencher na tal estrutura de resposta. O status code 200 veio na primeira linha, seguido do content type que é texto puro, mais uma data e horário que o framework preencheu pra mim e o fechamento da conexão seguido do corpo da resposta que é o string da mensagem hello.










Claro, hoje em dia não preciso de telnet pra ver isso. Todo navegador agora tem o tal Developer Tools, que se  acessa com o atalho control shift J no Windows ou control option J no Mac. Ele tem essa aba Network ou rede, onde podemos ver os pacotes de request e response e os cabeçalhos. Mesma coisa que fizemos no telnet, olha como no request ele mostra que o navegador fez um comando GET e embaixo temos a mesma resposta que recebemos via telnet, status code 200, content type text plain, a data e horário. Antes de existir Dev Tools a gente usava coisas como Telnet pra debugar.









Em linhas gerais é assim que um navegador, um cliente de APIs e tudo mais que fazemos na web funciona. Com o navegador conectando na porta 80 ou 443 ou numa porta de usuário como a 3000 do meu Node.js. O navegador monta uma estrutura em texto chamada request, um servidor feito em qualquer framework como Node da vida recebe, decide o que fazer baseado no que foi pedido, monta uma outra estrutura chamada response e devolve. Esse é o básico do básico de web.








A porta 443 e TLS é uma camada a parte. É um processo que acontece entre seu navegador e o servidor web, independente da aplicação por baixo. Esse meu hello em Node não precisa estar ciente que a conexão estava ou não criptografada. O navegador pede um handshake, um aperto de mão, com o servidor que, se estiver devidamente configurado com certificados SSL, vão abrir uma conexão segura usando chaves assimétrica, trocar uma chave simétrica, e a partir daí todo pacote que o servidor web envia vai criptografado e o navegador consegue descriptografar e vice versa. Eu explico isso na parte 2 dos meus videos sobre criptografia.









Mas eu digo que tanto faz porque o programa Node por baixo vai receber a request já descriptografado direitinho, como se nada tivesse acontecido. E em redes existe isso de cada camada na arquitetura trabalhar os pacotes trafegando e as camadas de cima, como minha aplicação, não precisar estar cientes e funcionar normalmente. Se não sabia o que é uma boa arquitetura, a arquitetura OSI de camadas de rede é uma boa inspiração, onde cada camada tem sua responsabiilidade, cada camada não precisa estar ciente se uma camada embaixo foi adicionada ou trocada, contanto que realizem as mesmas tarefas. Programação de software pra rede costuma ter essa metáfora de camadas de uma cebola. Quem já brincou de Tor e coisas assim já deve ter ouvido falar de Onion, por isso. Outro dia falo de coisas como Tor.







Um navegador web como Chrome é um dos softwares mais complexos que você tem instalado no seu computador depois do próprio sistema operacional, especialmente pra renderizar a parte gráfica corretamente. Mas pra se conectar num servidor web e mandar comandos simples de GET, um mero telnet como mostrei já serve. Vários outros programas simulam um navegador simples como os programas wget ou curl de Linux, que a gente usa mais pra fazer download, mas tecnicamente ele se comporta como um navegador web. Ou bibliotecas que usamos pra fazer clientes pra APIs como o Axios de Javascript, ou a classe HttpClient de Java ou C#, ou a classe http.client de Python e assim por diante. São todos mini navegadores, sem a parte gráfica.







Se nunca pensou assim, um servidor é todo programa que pede um bind de uma porta pro sistema operacional e fica em modo listen de escuta, esperando pra dar accept e abrir uma conexão com outro computador remoto. Aliás, vale outro conceito básico. Eu categorizo programas em dois tipos, short lived e long lived. Ou em bom português, programas de tiro curto e programas persistentes. Programa de tiro curto são muitos dos que você roda via linha de comando, comandos como o grep, sed, ou awk de Linux, programas que recebem um input, processam alguma coisa, cospem um resultado e saem fora. Servidores ou programas persistentes são loops.






Vamos desconsiderar por um segundo que existem threads, I/O assincrono, e que tudo seja como era antigamente, quando só dava pra rodar um comando bloqueante e síncrono por vez. Se eu fosse escrever numa pseudo-linguagem, ou seja, uma linguagem que não existe, a estrutura mais básica de um servidor de rede seria assim:


`while(true) {
	listen(:3000)

	stream = accept()
	while(not stream.eof) {
	    request += stream.read_line
	}
	response = processa_alguma_coisa(request)
	send(response)
}`





Todo servidor fica num loop infinito até receber sinal do sistema operacional pra morrer, o tal SIGTERM ou sinal de término, que se você já usou Linux, já enviou com o comando `kill`. Ou no Windows via powershell com o comando `taskkill`. Enfim, entenda que se executar um programa e ele tiver o comportamento de esperar um evento, reagir, e voltar a esperar, normalmente é um loop, equivalente a um while true.






Dentro desse while, ele manda comando pro sistema operacional, o `listen`, pra pedir pra ficar esperando o que vier numa porta, como 3000. Nesse ponto que eu falei pra ignorar que existe threads e concorrência. Faz de conta que quando ele dá listen, fica parado nessa linha até receber alguma coisa. Uma hora alguém conecta e começa a enviar bits. Daí sai dessa linha e cai no `accept` onde recebe o stream de bits, o tal cano de bits. Agora eu fiz um pseudo código arbitrário que é ficar lendo linha a linha até sinalizar `eof` que, se nunca viu, costuma ser sigla pra end of file, que terminou o envio ou acabou o arquivo. 






Agora, o programa faz alguma coisa com esses bits que vieram, que chamei de request, e monta alguma resposta, que é a estrutura de response. No final envia de volta ou dá `send` desse response, pedindo pro sistema operacional devolver, pela mesma conexão fechada no accept, e o loop reinicia esperando outra requisição. Volta pro estado de listen, até aparecer mais bits. No mundo real existem threads e na realidade uma das coisas que pode acontecer dependendo da linguagem é o accept abrir uma nova thread pra processar o request e response enquanto o loop de listen continua ativo esperando mais conexões. Possibilitando lidar com dezenas ou centenas de conexões simultaneamente.








Aproveitando o conceito. Todo programa gráfico é um grande loop também. Ele fica esperando você digitar alguma coisa ou clicar alguma coisa com o mouse, é parecido com esse `listen`. E fica no loop infinito até receber um sinal pra fechar como o menu de Quit ou alt-f4 no Windows. Um game também é um grande loop, esperando seus comandos e reagindo. Essa é a fundação pro que muitos chamam de programação orientada a eventos original. O programa reage a eventos, como input de mouse e teclado ou algo assim. Não vou entrar em paradigmas, mas só pra lembrar que esse é um dos patterns mais comuns em programação, o que eu pessoalmemnte chamo de Big Loop.









Normalmente, em web, a gente fica muito preso ao protocolo HTTP, onde as duas peças principais são a tal estrutura texto de HTTP Request e HTTP Response e comandos básicos como GET, POST ou PUT. Todo tutorial de web começa direto neles. E por causa disso muita gente faz o que não devia, tentando embutir tudo que pode dentro dessas estruturas. Mas a internet não é feita só de HTTP, ela só é a mais popular. Muitos falam “internet” pensando em redes, roteadores, pontos de acesso. E chama o resto de Web. Mas Web, que é o nome mais curto pra World Wide Web, que se refere à capacidade de hipertexto de páginas HTML. A idéia que uma página pode ter links pra outras páginas formando uma teia, ou Web.








Mas internet na realidade é um conjunto de tecnologias, que envolve coisas como ethernet, wifi, fibra, o TCP/IP e todos os outros protocolos de aplicação, incluindo o HTTP de Web. E chamamos assim porque como expliquei antes, o modelo OSI de internet define sete camadas. A camada física que foi o episódio que expliquei sobre ondas, cabos de cobre e wireless. A camada de data link responsavel entre outras coisas como checar erros, como eu expliquei sobre Hamming Code e tudo mais. A terceira camada, de rede é que lida com coisas como roteamento, endereços IP e tudo mais.







Eu pulei as camadas seguintes, a camada 4 de transporte, a camada 5 de sessão, a camada 6 de apresentação e a camada 7 de aplicação. Isso porque em TCP/IP as funções da camadas acima da 5 acabam sendo acumuladas na camada de aplicação, que é onde mora protocolos como HTTP de Web.







Em OSI existe uma camada pra lidar com sessões, mas em Web controlamos sessão direto no HTTP usando cabeçalhos como de cookies. Sessões servem pra literalmente identificar uma sessão individual de cada usuário e no modelo OSI esse controle ficaria na camada 5, mas a gente acaba achando mais fácil acumular isso direto na camada de aplicação. Por isso em vez de ter um jeito único de lidar com sessões, protocolos como HTTP, FTP, IMAP e tudo mais, cada um controla sessões do seu jeito. Tem vantagens e desvantagens de se fazer isso.







Exemplo de outro protocolo era o antigo FTP ou File Transfer Protocol que hoje em dia ninguém mais usa pelo mesmo motivo que não se usa Telnet, ambos precedem conceitos mais modernos de segurança. Muitos antigos servidores de FTP estão expostos atrás de um servidor web, como o FTP da Unicamp que eu usava muito na faculdade e hoje hospeda espelhos de arquivos de Linux. Se digitar ftp.unicamp.br no seu navegador, vai ver que ele coloca http:// na frente, indicando que não está usando o protocolo FTP.







Num terminal Linux, se instalar o antigo pacote inetutils, além do telnet, vai ganhar o programa ftp. Basta digitar `ftp ftp.unicamp.br` no terminal. Ele vai pedir um usuário. Como antigamente, muitos servidores públicos aceitavam o usuário `anonymous`. E felizmente esse ainda aceita. A senha pode ser qualquer coisa ou vazia. E pronto, abriu uma conexão de FTP onde ele passa a esperar comandos que são parecidos com os comandos pra navegar no seu HD via terminal como `cd` pra mudar de diretórios ou `ls` pra listar o conteúdo do diretório. Se digitar `help` mostra os comandos que o protocolo FTP suporta. Lembra que HTTP suporta comandos como GET? Em FTP ele suporta comandos diferente. Get em FTP é pra fazer download de algum arquivo.







Eu até consigo mudar de diretório fazendo `cd /pub` pra ir pro diretório público, mas não sei porque, comandos como `ls` não devolvem nada e dão timeout. HTTP versão 1.0 era ótimo pra baixar páginas HTML e até mesmo fazer download de arquivos, como agora. Mas era chatinho enviar arquivos pro servidor. Hoje em dia é fácil, mas nos primórdios, a gente ainda não entendia tudo que dava pra fazer, nem lembro se HTML 1.0 tinha form multipart. Pra enviar arquivos pra um servidor, o certo era usar FTP.






Acumulamos um monte de funções em cima de HTTP que antes eram de outros protocolos. Hoje em dia é muito normal abrir um Gmail e anexar um arquivo. Ou abrir um Dropbox e subir um arquivo. E mesmo se quisermos transferir arquivos num equivalente FTP, não se usa FTP pelo mesmo motivo que hoje usamos HTTPS em vez de HTTP, por segurança. HTTPS é HTTP mais encriptação com certificado TLS. O equivalente seria FTPS. Assim como em vez de Telnet hoje usamos SSH. E SSH é mais versátil porque permite não só abrir um terminal remoto seguro, como também trafegar arquivos, via SFTP que é FTP sobre SSH. Vou falar mais de SSH no próximo episódio.








Outro protocolo que até existe ainda mas num nicho muito pequeno é o que falei 2 episódios atrás quando expliquei correção de erros e parchives. O protocolo NNTP de rede Usenet. A idéia era ter um servidor de artigos de texto, como fóruns e sincronizar diferentes servidores usando esse protocolo NNTP. De novo, acumulamos essas funções dentro de HTTP e o equivalente seria sites como StackOverflow, HackerNews, Reddit.








No começo da internet não usávamos navegador web pra tudo. Usávamos programas separados como FTP pra transferir arquivos. News pra ler notícias e discussões da Usenet, literalmente newsgroups. Telnet pra abrir sessões remotas de terminal. E Gopher, que eu quase nunca usei porque meio que tinha o mesmo propósito de HTTP e perdeu espaço quando a Web ficou mais popular. Mas todos são exemplos dos primeiros protocolos de aplicação no começo da internet comercial. Na prática, Usenet ainda é usado até hoje pra facilitar pirataria, algumas coisas que talvez seja mais difícil em BitTorrent ainda se acha na Usenet.









Todos foram substituídos. HTTPS se tornou o protocolo mais popular. SSH é a única boa alternativa tanto pra telnet quanto ftp. E protocolos específicos como NNTP, IRC de chat, Gopher e outros, tiveram suas funções acumuladas em HTTPS. E o S de segurança se tornou importante nos primórdios do comércio eletrônico, onde encriptação se tornou essencial pra permitir trafegar coisas como número de cartão de crédito. Sem isso seria impossível ter comércio online.






Tivemos primeiro o SSL da Netscape, e hoje é o TLS ou Transport Layer Security. Isso possibilitou escalar a economia na Web mas também dificultou pra hobistas e amadores que queriam só fuçar a rede com comandos simples no terminal, porque agora temos que lidar com uma camada de encriptação no meio.. Antigamente era só plugar telnet em qualquer porta que já dava pra fuçar, hoje já não é tão simples e como isso torna as coisas mais indiretas e abstratas, imagino que deve dificultar o aprendizado de muita gente.








Sem contar que se eu quisesse contribuir na rede e participar de sub-redes como servidores de chat IRC, era só montar meu próprio servidor IRC e plugar na internet. Ou se quisesse ter meu próprio servidor de newsgroups era só montar um servidor de NNTP e plugar na Usenet e assim a gente podia fazer parte do mesmo serviço distribuído na rede. No momento onde centralizamos tudo em HTTP, também perdemos a característica de serviços distribuídos e entramos na era de walled gardens ou jardins emparedados. Acho que os únicos exemplos de rede verdadeiramente distribuída onde qualquer um pode entrar e participar é BitTorrent e Bitcoin da vida. Sim, eu sei, como falei antes Usenet e IRC ainda existem, mas são nichos bem pequenos e desconhecidos. Tem muito mais gente usando Discord do que IRC.







E falando nisso, eu acho que preciso explicar um pouquinho sobre segurança de rede e vou deixar isso pro próximo episódio. Se ficaram com dúvidas mandem nos comentários abaixo, se curtiram o video deixem um joinha, assinem o canal e compartilhem o video com seus amigos. A gente se vê, até mais!


