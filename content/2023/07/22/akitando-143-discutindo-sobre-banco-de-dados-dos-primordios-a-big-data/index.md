---
title: "[Akitando] #143 - Discutindo sobre Banco de Dados - Dos primórdios a Big Data"
date: '2023-07-22T08:00:00-03:00'
slug: akitando-143-discutindo-sobre-banco-de-dados-dos-primordios-a-big-data
tags:
- dbase
- clipper
- xbase
- harbour
- foxpro
- dbf
- database
- b-tree
- btrfs
- sql server
- oracle
- postgresql
- mariadb
- mysql
- sqlite3
- amazon
- aws
- dynamodb
- cassandra
- datastax
- scilladb
- akitando
draft: false
---

{{< youtube id="Bfm3Ms2cTg0" >}}

Não se pode ser um bom programador sem entender de verdade como bancos de dados funcionam. E não se pode entender banco de dados sem entender algoritmos e estruturas de dados. E hoje vou mostrar como dos primeiros bancos de dados dos anos 80 chegamos aos SQL e NoSQL atuais. 

Este video complementa meu video anterior "Fiz um Servidor de SQL?" e outros videos que vou referenciando ao longo deste. Anote tudo e assistam depois.

## Capítulos


* 00:00:00 - Intro
* 00:01:15 - CAP 01 - O que é um Banco de Dados? A era do dBase
* 00:10:04 - CAP 02 - Procurando com Índices - NDX e B-Tree
* 00:18:53 - CAP 03 - Do DBF ao SQLite3 - O banco mais usado do Mundo
* 00:23:42 - CAP 04 - Tudo são Árvores B - A estrutura mais importante da computaçãot
* 00:28:51 - CAP 05 - JSON no SQL?? Você não está entendendo
* 00:31:45 - CAP 06 - Proteção e Consistência - As garantias dos bancos
* 00:35:38 - CAP 07 - Do xBase a Cliente-Servidor - As 3 Camadas
* 00:38:59 - CAP 08 - Programando Errado - Você não sabe usar o servidor
* 00:45:26 - CAP 09 - Constraints - Usando do jeito certo
* 00:48:13 - CAP 10 - Monitorando - Sempre monitore tudo!
* 00:50:23 - CAP 11 - Big Data - Virando gente grande
* 00:53:40 - CAP 12 - Dividindo pra Conquistar - Acelerando seu App Web
* 00:56:28 - CAP 13 - Big Data Parte 2 - Por que NoSQL?
* 01:00:39 - CAP 14 - Teorema CAP - As partes importantes
* 01:07:12 - CAP 15 - Estratégias de Chaves Primárias - Chaves Surrogadas
* 01:11:25 - CAP 16 - Hashing Consistente - Sharding
* 01:18:42 - CAP 17 - O Problema de Cloud - Calculando Precificação
* 01:24:51 - CAP 18 - Recomendação pra Iniciantes - Arroz com Feijão
* 01:27:39 - Bloopers


## Links

* [Heroku](https://www.heroku.com/postgres)
* [Amazon ElastiCache](https://aws.amazon.com/elasticache/)
* [Amazon RDS](https://aws.amazon.com/rds/)
* [Amazon Aurora](https://aws.amazon.com/pt/rds/aurora/)
* [Amazon S3 Glacier Storage Classes | AWS](https://aws.amazon.com/s3/storage-classes/glacier/)
* [Astra DB | DataStax](https://www.datastax.com/products/datastax-astra)
* [Scylla Cloud](https://www.scylladb.com/product/scylla-cloud/)
* [SAP HANA Cloud](https://www.sap.com/products/technology-platform/hana.html)
* [Big Data SQL Cloud Service | Oracle](https://www.oracle.com/big-data/big-data-sql/)
* [Azure SQL Database](https://azure.microsoft.com/en-us/products/azure-sql/database)
* [Google Cloud](https://cloud.google.com/sql)
* [Pricing | MongoDB](https://www.mongodb.com/pricing)
* [Valentina SQLite Server](https://valentina-db.com/en/valentina-sqlite-server)
* [Configure Amazon DynamoDB (calculator.aws)](https://calculator.aws/#/addService/DynamoDB)
* [CAP Twelve Years Later: How the "Rules" Have Changed (infoq.com)](https://www.infoq.com/articles/cap-twelve-years-later-how-the-rules-have-changed/)
* [Dynamo: Amazon’s highly available key-value store - Amazon Science](https://www.amazon.science/publications/dynamo-amazons-highly-available-key-value-store
* [PostgreSQL JSON Tutorial (postgresqltutorial.com)](https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-json/)
* [GitHub - azadkuh/sqlite-amalgamation: The SQLite amalgamation mirror with cmake](https://github.com/azadkuh/sqlite-amalgamation)

## SCRIPT

Olá pessoal, Fabio Akita

Desde que comecei o canal, banco de dados é um dos temas que eu mais queria discutir, mas vim postergando pra poder explicar fundamentos antes. O objetivo não é ensinar SQL ou MongoDB nem nenhum outro em detalhes, é dar perspectiva pra quem está iniciando entender porque diabos existem tantos tipos diferentes de bancos de dados e quando se deve considerar usar um em vez do outro. Vai ser um video mais alto nível, sem tanto código em si, mas sim dar insights pra vocês pesquisarem nas respectivas documentações depois. Vou começar nos primórdios e só na metade vamos começar a cair em SQL e NoSQL. Então, vamos lá.





(...)





Infelizmente, se você estava esperando um video sobre modelagem, modelo entidade-relacional, ORMs, design patterns e coisas assim, ainda não é este video. Objetivo é falar mais o que acontece por baixo dos panos, as tecnologias que formam um banco de dados. Eu acho que modelagem só é efetiva se você sabe como a plataforma por baixo realmente funciona, senão modelagem vira só superstição e você só acha que sua modelagem é boa sem realmente saber o que ela causa por baixo. Tudo que você não sabe como realmente funciona vira superstição.








Sempre falo que uma das vantagens que eu tive, foi conseguir testemunhar as versões 1.0 de quase tudo que surgiu nos últimos 40 anos. Se você pegar um banco de dados moderno, como um DynamoDB da AWS, ou um Postgres, eles tem dezenas de funcionalidades que não são imediatamente óbvios pra que foram criados. Sem saber isso, você acaba tentando usar nos lugares errados ou acha que são ruins, ou acha que você que é burro e não consegue usar.






Pense por um segundo, o que é um banco de dados? À primeira vista poderíamos dizer que é um programa que facilita e gerencia o armazenamento de dados estruturados. Pense um armário com gavetas, cada gaveta com um tipo de formulário. As gavetas seriam nossas tabelas e o armário seria o banco de dados. Acho que é parecido com o que a maioria de vocês deve imaginar.







Pra iniciantes, acho que vale a pena retornar aos fundamentos. Por isso sempre falo tanto que é importante aprender a fundação, como algoritmos e estruturas de dados. O problema é que a estrutura mais simples de aprender e por causa disso comum de usar são listas. Essas seriam as gavetas. Em particular listas ligadas ou arrays puros. E se escolher partir desse ponto, vai ter problemas. Vamos entender.







O banco de dados mais simples de todos, um armário só com uma gaveta, é um mero array em memória com registros, como um struct ou uma instância de uma classe, um objeto. Lembram como um array é estruturado em memória? Um array de inteiros com 10 elementos, provavelmente tem 10 vezes 64 bits ou 8 bytes, ocupando 80 bytes no total. Todo array tem elementos de mesmo tamanho fixo, sempre. 







Se eu quiser pegar o 5o elemento desse array, basta contar que tenho 4 elementos antes, vezes 8 bytes, então 32 bytes pra frente, vou achar o 5o elemento. Se eu souber qual posição do array quero encontrar, independe se está no começo ou no fim, o tempo de acesso é o mesmo, tempo constante. O array pode ter 10 elementos ou 10 mil elementos. Leva mais ou menos o mesmo tempo pra acessar qualquer posição.







Quando todos os meus dados cabem na memória RAM, toda operação é simples. Mesmo se eu não souber a posição, na pior das hipóteses faço força bruta via um loop do primeiro até o último elemento, até encontrar. E isso seria de longe, o jeito mais tosco de se procurar alguma coisa numa lista, mas pra conjuntos de dados pequenos, quase ninguém nota a diferença. Mas deixa eu repetir: procurar dados numa lista com um grande loop e if dentro é o jeito mais absurdamente horrendo e inaceitável. Vou repetir de novo pra ficar claro: se você está fazendo um loop pra procurar itens numa lista, você é insano!







Isso porque todo programador, especialmente iniciantes, sempre lidam com poucos dados. É muito difícil entender complexidade de algoritmos e diferença nos tempos de processamentos se só tem cem, mil elementos. Só quando começar a lidar com centenas de milhares, milhões de elementos, que vai começar a entender a diferença. Já vou chegar nisso.








Enfim. Imagine que lá no começo da computação, todo mundo lida com poucos dados comparado com hoje. Por isso as primeiras soluções são simples. Um array com elementos de tamanho fixo é a forma mais fácil de pensar. E quando acaba a memória? Digamos, uma lista de produtos ou lista de clientes num ecommerce? Obviamente não cabe tudo em RAM. Daí temos que pensar em gravar esses dados em disco. E a forma mais simples de fazer isso é o bom e velho arquivo append only, onde vamos adicionando novos elementos no fim do arquivo.









É fácil. Pense num registro como uma struct de C, ou uma classe de Javascript ou Python, só que garantindo que todos os elementos tenham tamanho fixo. Determino uma struct com o primeiro campo sendo o nome completo, com umas 100 letras, onde cada uma é representada por um código UTF-8, de 8 bits,  100 bytes no total. Depois temos um número de telefone, com DDD de 3 caracteres, um prefixo de 3 números como era antigamente e um sufixo de 4 números, mais parênteses e hífen, total de 13 letras ou 13 bytes. 








Temos um total de 100 bytes mais 13, ou 113 bytes. O primeiro registro vai ocupar o começo do arquivo começando no endereço zero e indo até o endereço 112 bytes. O segundo registro começa no byte 113 e vai até 225 e assim por diante. Posso abrir o arquivo, ir até o final e gravar mais um registro. E assim fica fácil sair cadastrando novos registros.







De curiosidade, queria aproveitar pra mostrar a segunda linguagem e ambiente de programação que aprendi depois do Basic, quando eu era pré-adolescente. Acho que era 1990 e tinha uns 13 ou 14 anos. Meu pai tinha pedido pro meu tio trazer um PC do Paraguai, era um PC-AT 286 com 1 megabyte de RAM, 10 ou 20 mega de HD. Veio instalado com MS-DOS 3.0 e meu tio tinha deixado também o programa que ele usava pra trabalhar: o dBase III Plus, ainda da antiga empresa Ashton-Tate.







E era só isso que tinha instalado. Não tinha internet naquela época. Eu não tinha livro nem nada. Por acaso um outro primo meu tava estudando isso e me emprestou uma apostila do curso que  tava fazendo. Foi meu primeiro PC, então só de ver ligado e ter um teclado que podia usar, em vez de uma máquina mecânica de datilografia, já achava incrível. Minha primeira ideia foi copiar a apostila do meu primo. Eu redigitei tudo do zero acho que no Wordstar.








Este é o Wordstar. Ele tem um aspecto esquisito porque tá configurado no modo de 50 linhas que o VGA permite, em vez de 25 linhas de CGA. Essa versão é uma das últimas que saiu pra DOS, acho que a 7.0, daí tem ajudas que as versões iniciais não tinham, com um menu completo com todas as opções. Senão a única forma de usar era lembrar dos atalhos como control mais P e B pra iniciar modo negrito, daí repetir control P e B pra voltar pro modo normal. Control P e Y pra itálico e assim por diante.








Era tão moderno que tinha até um Preview em modo gráfico pra mostrar como ficaria na impressora. Essa época estávamos na transição do modo texto de DOS pro modo gráfico de Windows 3. Muitos editores de texto atuais como o próprio VS Code ou Obsidian da vida tem modo de ficar focado que deixa o texto no centro e esconde toda distração. São inspirados em editores antigos como o Wordstar. Esse é o editor que o George R. R. Martin diz que usa pra escrever Game of Thrones.







Enfim, pequena tangente pra mostrar como eu copiei a apostila de dBase. Mais pra frente consegui comprar livros de verdade. Acho que nenhuma linguagem comprei tantos livros pra aprender quanto dBase e seu sucessor, o Clipper. Olha só os que ainda guardei. A razão de tanto livro é que antigamente não tinha Google nem Stackoverflow, lembrem-se disso. Depois que surgiu a Web, já não precisei de tanto livro assim.







Abrindo o dBase, tem um REPL, um interpretador de comandos, que nem quando se digita `node` ou `python` e dá pra começar a digitar comandos. Mas também tem um sistema de menus aqui pra facilitar. Olha só, posso escolher a opção de criar um novo banco de dados. Digito o campo "nome", tipo "character" com 100 letras. Depois o campo "telefone", tipo "character" também, com 13 letras. Vou aproveitar e adicionar um campo de "empresa" com 100 letras. Pronto. Daí quando salvo já me deixa começar a cadastrar.







Vamos lá, quero me cadastrar aqui, "Fabio Akita", telefone bla bla bla, empresa Codeminer 42. Agora vou cadastrar "Cecil Wayne", o criador do dBase que depois se tornaria vice-presidente da Ashton-Tate. Finalmente, vamos cadastrar Brian Russell, que criou o compilador Clipper, pra Nantucket Corporation. Nenhuma dessas empresas existe mais. 







A Ashton Tate foi adquirida pela Borland que depois viraria Inprise, depois Embarcadero e a divisão CodeGear que ainda mantém o Delphi, se não me engano. A Nantucket iria pra CA ou Computer Associates, que desde 2018 faz parte da Broadcom. Todo o sucesso que eles tiveram nos anos 80 e 90 desapareceram ao ponto que hoje ninguém mais lembra. É um bom lembrete que nada dura pra sempre.







Enfim. Terminei de cadastrar meus contatos. Posso salvar e sair com control + end. Agora estou na tal linha de comando do interpretador. Posso abrir o arquivo do banco fazendo "use contatos", digitar o comando LIST e olha só, lista o que acabei de registrar. Esse é o avô de todos os CRUDs, o CRUD original no mundo dos microcomputadores. Não o primeiro, mas possivelmente um dos mais populares.







O formato de arquivo que Cecil inventou foi o famoso DBF, literalmente database file. Quando eu era novo, antes de pular pra tecnologias mais novas como SQL Server da Microsoft, na minha cabeça "banco de dados" é o que você chama de tabela. O dBase gravava uma tabela por arquivo e chamava isso de banco de dados. Hoje, banco de dados é um servidor com conjuntos de tabelas num único arquivão. No fim dos anos 80, banco de dados, pra mim, era um arquivo com uma tabela.







Esse arquivo tem um espaço reservado nos primeiros endereços pra metadados, informações como o total de registros e coisas assim. Mas os registros em si tem todos o mesmo tamanho fixo. No exemplo dos contatos, são 100 bytes pro nome, 13 pro telefone e 100 pra empresa, então cada registro sempre vai ocupar 213 bytes. Basta ir pulando de 213 em 213 bytes pra ir avançando pro próximo registro.







Como programador você precisa entender essa estrutura. Digamos que eu queira encontrar o telefone do Brian. Como faz? Como é anos 80, vamos começar do jeito mais simples, ou seja, tosco. Podemos escrever um programinha besta, que vou chamar de "list.prg". Abro o arquivo com "USE", limpo a tela e começo a fazer um loop checando que não estamos no fim do arquivo, end-of-file ou EOF como tá aqui. 







Daí fico comparando o campo nome do registro atual com "Brian". E não acharia nada. Isso porque preciso procurar pelo nome exato, então "Brian Russell". Claro, posso só pesquisar as primeiras letras também, mas é uma operação a mais, por agora vou simplificar. Da linha de comando do DOS podemos chamar o dbase passando esse programa.  


```
USE contatos
CLEAR
DO WHILE .NOT. EOF()
	IF NOME = 'Brian Russell'
		@ 10,10 SAY 'Empresa:' GET EMPRESA
		EXIT
	ENDIF
	SKIP
ENDDO
```




Nesse exemplo idiota, começa pesquisando o primeiro registro, que é Fabio. Não achou e não é fim de arquivo, então vai pro próximo com o comando `SKIP`, que é Cecil, ainda não é fim de arquivo, então vai pro próximo e acha o Brian, daí é só pegar o campo empresa, imprimir na tela com esse comando `SAY` e sair do loop com `EXIT`. 





Esse é o pior caso: onde o que quero achar é o último registro. Imagine um arquivo muito maior, com mil registros. Precisaria ir um a um mil vezes. Todas as vezes. Por isso, esse é jeito mais tosco e mais primitivo de procura num banco de dados. Agora que entendeu isso, prometa que nunca vai fazer desse jeito.







Num computador moderno, esse programa vasculhando milhares de registros ia demorar menos de um segundo. Mas nos anos 80 poderia levar alguns segundos, dependendo de quantos registros tenho. Mas claro, nem nos anos 80 a gente era ruim de fazer desse jeito tosco.






Em dBase mesmo dava pra criar um segundo arquivo, um índice. Basta fazer "INDEX ON NOME TO INDNOME" e vai criar um arquivo separado de índice com extensão "NDX". E podemos abrir o banco de dados com "USE contatos INDEX INDNOME". Como já tá aberto podemos só fazer "SET INDEX TO INDNOME". É assim que podemos ficar mudando de índices dependendo de que campo queremos procurar.







Eu digitei errado o nome da empresa do Cecil, vamos usar `SEEK 'Cecil Wayne'` e fazer `REPLACE EMPRESA WITH 'Ashton Tate'`. Pronto, é assim que procuramos e depois modificamos um registro. O comando Seek vai usar o índice, em vez de fazer o loop com comparação como fiz antes. Aliás, esse comando REPLACE serve pra mudar dados dos campos do registro atual. Com SEEK podemos encontrar um registro, mas pra criar um novo, teríamos que fazer "APPEND BLANK" antes, pra "apendar", anexar um registro vazio no fim do arquivo, daí o REPLACE gravaria os dados nesse registro novo. Esse é o básico.







Esse tipo de índice eu já expliquei no episódio de Árvores e também nos de armazenamento. É uma variante de uma B-Tree. Lembram que falei que árvores são as estruturas mais importantes na computação? O arquivo DBF de banco de dados é mais ou menos como se fosse um array de structs em disco, mas um arquivo NDX de índice é uma estrutura de árvore B. Daí, em vez do tempo de procura ser linear em força bruta com loop um a um, com o índice passa a ser logarítmico, que é uma ordem de grandeza mais rápido e eficiente.







Ou seja, no meu programa de procura tosca via loop e comparação, se cada comparação e skip levasse, digamos, 1 milissegundo, e eu tivesse 10 mil registros e o que eu procuro estivesse no último registro, então no pior caso levaria 10 mil milissegundos, 10 segundo inteiro. Mas se eu usar um índice em B-Tree, com complexidade logarítmica, levaria talvez pouco mais de 10 milissegundos. 






Mesmo se eu dobrasse a quantidade de registros, o tempo de pesquisa não iria aumentar muito mais que isso, dado a natureza logarítmica. Dependendo do que estou fazendo, o ganho de performance poderia ser 100 vezes ou mais usando o índice correto. Por isso falamos tanto no mundo de bancos pra sempre garantir que tem um índice correto preparado.







Mas e se eu quisesse agora procurar pelo telefone? Ou pelo nome da empresa? Bom, podemos criar um índice pra cada campo, como `INDEX ON TELEFONE TO INDFONE` e `INDEX ON EMPRESA TO INDEMPR`. Note como o nome do índice eu tive que truncar, porque em MS-DOS nomes de arquivos podiam ter no máximo 8 letras. Era uma limitação do FAT16 antigo. O sistema de arquivos FAT que você usa pra formatar SD Cards pra câmera é ou FAT32 ou o mais moderno ExFAT, e não o FAT16 antigo. São compatíveis, mas com limites muito maiores, por isso dá pra ter nomes de arquivos longos normalmente.







Voltando pro DOS podemos listar os arquivos criados. Como disse antes, cada registro vai ocupar aproximadamente 213 bytes. Tenho 3 registros, então teríamos pelo menos 639 bytes. No caso o formato DBF grava mais coisas como cabeçalho de metadados, por isso faz sentido ser 986 bytes. Mas veja cada arquivo de índice. 1 kilobyte cada. Acho que é o tamanho mínimo pra um índice.






Eu fiz um programa besta pra adicionar mais registros falsos só pra aumentar o tamanho dos arquivos. Olha a listagem aqui. A chatice de uma linguagem tão rudimentar quanto dBase III é que ele sequer tem função pra gerar números aleatórios nem tem coisas triviais como calcular o módulo de um número. Então tive que fazer um gerador de números usando só segundos. Não tem nem função pra pegar milissegundos então tenho muitas letras repetidas, mas tudo bem. Olha só como tive que fazer pra calcular o módulo na mão. Daí vou pegando letras da tabela ASCII e concatenando. Super rudimentar.








Gerando 40 novos registros e reindexando, vamos ver o tamanho dos arquivos. O banco de dados, a tabela de contatos em si, com 43 registros agora ficou com quase 10 kilobytes, Pouco mais que 240 bytes por registro, em média. Já os índices, o de nome ficou com quase 8 kilobytes e telefone que é um campo menor, ficou com pouco mais de 2 kilobytes. Empresa é o mesmo tamanho de Nome então ficou com uns 8 kilobytes também.







Pense por um segundo. Os arquivos de índice estão ocupando quase o dobro do espaço da tabela em si. Muita gente pode não entender isso, mas índices ocupam espaço, e não é pouco espaço. Mais importante que isso. Num banco moderno, digamos que a operação de inserção na tabela de um novo registro leve 1 milissegundo. Mas agora digamos que temos esses 3 índices. E atualizar cada um dos índices leve mais 1 milissegundo cada. Agora é um total de 4 milissegundos pra inserir um novo registro e atualizar os índices. O tempo de inserção ficaria 4 vezes maior. 








Índices é uma faca de dois gumes. Por um lado podemos acelerar a pesquisa em 100 vezes, talvez mais, mas por outro lado, operações como inserção, atualização ou deleção vão demorar duas vezes mais, quatro vezes mais, dependendo da quantidade de índices que tivermos. Entenderam? 





Aliás, índices em dBase, ou mesmo em Clipper, eram super instáveis. Vira e mexe ficavam desatualizados e por isso todo programa que fazíamos naquela época colocávamos no menu uma opção de manutenção. Ensinávamos o operador do cliente rodar de vez em quando. Era a operação pra reindexar tudo do zero, pra garantir que a pesquisa ia funcionar. Quanto maior a tabela, mais demorado ficava reindexar. Felizmente bancos de dados modernos são bem mais estáveis pra atualizar os índices e fazem isso sem precisar de intervenção manual, na maior parte do tempo.







Mas não é só isso. Até agora só falei sobre adicionar novos registros nesse arquivo. Isso é fácil, é só ir apendando, concatenando os bytes do registro no fim do arquivo. Atualizar, também não é tão difícil. Só dar "SEEK" pra encontrar o registro pelo índice e dar "REPLACE" pra substituir com o dado novo por cima do campo desejado. Mas e pra apagar? O que acontece?







Pensa um Array em memória. É uma sequência contínua. Se você quiser deletar um elemento no meio, não tem outro jeito. Precisa criar um novo array e copiar todos os elementos de novo, pra não ficar buraco no meio. Por isso que em memória usamos outras estruturas como listas ligadas. Daí é só mudar o ponteiro do elemento anterior pra apontar pro elemento seguinte. Mas listas ligadas são super ineficientes comparados com arrays, são mais difíceis de navegar, porque não tem endereços contínuos, então não tem como só calcular o offset e ir direto pro elemento no fim, tem que ir navegando ponteiro a ponteiro. É muito lento.








Um arquivo DBF é parecido com um array: não tem como apagar um registro no meio. O que acontece é que cada registro tem um bit separado só pra dizer se é válido ou não. Quando manda apagar, ele só grava esse bit de zero pra um, daí quando tentamos dar SEEK ou navegar pra frente com SKIP, ele vai ignorar se esse bit estiver marcado como apagado. Isso torna a operação simples com um trade-off: o espaço no disco vai continuar sendo ocupado, o arquivo não diminui de tamanho.








Por isso que além de reindexação, que é regerar os arquivos de índice, na tal opção de manutenção, também tinha outro comando: "PACK". O que o PACK vai fazer é a mesma coisa que com um array: gerar um novo arquivo DBF do zero e copiar todos os registros não apagados pra lá, e no final apagar o arquivo antigo. Esse é o único jeito de recuperar espaço do disco. Mas pra isso precisava ter quase o tamanho do arquivo original de espaço livre sobrando pra fazer a operação.







Isso existe até hoje em bancos de dados modernos. Quem já mexeu com SQLite3 ou Postgres deve ter esbarrado no comando "VACUUM", tem até a opção de AUTO VACUUM pra ele fazer isso sozinho sem termos que enviar o comando manualmente, mas em essência é a mesma ideia do comando PACK de dBase: recuperar espaço em disco e desfragmentar os dados no disco pra ficar mais eficiente e ocupando menos espaço.







Falando em SQLite3, ele seria o sucessor espiritual do dBase e Clipper. É provavelmente o banco de dados relacional mais usado no mundo. Está em todo lugar. Se você tem dispositivos smart com Android da vida, os aplicativos rodando dentro certamente usam SQLite3. O roteador da sua casa, sua Smart TV, sua Alexa, seu smart watch, tudo tem SQLite3. Qualquer aplicativo que precise armazenar qualquer tipo de dados, normalmente usa SQLite3.







A razão disso é por ser extremamente pequeno, altamente eficiente, flexível e portável. O código fonte dele é em C super limpo, que pode ser facilmente portado pra rodar em qualquer sistema operacional, seja Linux, seja Mac e pra qualquer arquitetura, seja x86 no seu PC, seja ARM na sua SmartTV ou console de videogame. Cabe tudo num único arquivo de C com poucos page down e oferece uma linguagem compatível com SQL. É muito bem feito, um dos melhores e mais úteis projetos de código aberto de todos os tempos. Se você é estudante de C, vale a pena explorar o código fonte, não é tão difícil de entender.








Isso me leva ao episódio onde mostrei o que seria uma introdução de como fazer uma linguagem similar a SQL e eu usei justamente um trecho da gramática de SQL do SQLite3. Só que por baixo fiz ele acessar uma estrutura em memória de Javascript. Poderia ser um arquivo DBF como de dBase e Clipper que acabei de mostrar. A diferença é que em vez de comandos como APPEND, REPLACE, USE, SKIP que mostrei até agora, poderíamos oferecer uma versão com SELECT, INSERT ou UPDATE.







O formato DBF é usado até hoje em muitos lugares. Um Pandas de Python tem capacidade de carregar e manipular DBF. A linguagem R pra cálculo numérico também consegue entender DBF. Linguagens como Javascript, Java, C#, todos tem bibliotecas que conseguem carregar DBF. É um formato legado que ainda é usado, por ser super simples, por ter sistemas legados em indústrias antigas. Obviamente, ninguém deveria iniciar um novo sistema dependente desse formato, pra isso existem coisas mais modernas, como o próprio SQLite3.







SQLite3, como dBase ou Clipper, não depende de ter um servidor de rede pra servir os dados, nem clientes complicados. Ele abre o arquivo e você manipula diretamente. Por isso é tão pequeno e eficiente. Existem opções pra oferecer SQLite3 em rede, mas o foco dele sempre foi rodar localmente. Acho que exige menos de 1 megabyte de RAM pra rodar, talvez faixa de meio megabyte, o que é ridiculamente pequeno. Muitos programas de Clipper dos anos 90 precisava mais que isso. 







dBase, Clipper, FoxPro é o que chamamos da família de linguagens xBase, que suportam o formato DBF. Existe uma versão mais moderna de Clipper de código aberto que é o Harbour e seu fork, o xHarbour. Não sei se alguém usa, mas serviria pra portar antigos programas xBase pra rodar em plataformas mais modernas além de adicionar funcionalidades modernas como orientação a objetos e capacidade de se conectar em bancos SQL modernos. De novo, não recomendo começar nenhum novo projeto neles. Qualquer Python da vida, conectando num SQLite3 ou Postgres vai ser melhor.







Tecnologias dos anos 80 eram limitados pelos poucos recursos que a gente tinha. Os processadores eram super lentos comparados com hoje. Estamos falando de milhares de vezes mais lento. Os programas precisavam ser super eficientes, porque qualquer operação fora do lugar roubava recursos escassos, seja de CPU, seja de RAM. Eles precisavam rodar em menos de 640 kilobytes de RAM, em 15 megahertz ou menos. Qualquer processador porcaria de hoje em dia tem 2 ou mais núcleos, cada um com pelo menos 1 gigahertz. Olha a diferença.







Eu mencionei que o sistema de arquivos FAT16 do MS-DOS da época só suportava arquivos de 8 letras mais 3 de extensão. Não tinha memória suficiente pra suportar estruturas de dados maiores que isso. Mais importante: não tinha processamento sobrando pra garantir a integridade dos dados. Coisas como calcular o checksum ou fazer hash dos arquivos. Pros anos 80 seria muito pesado. Por isso disquetes em FAT16 costumavam falhar, arquivos ficavam corrompidos, dados se perdiam. 







Mesma coisa pro formato DBF. Era comum esses arquivos se corromperem. Backup era essencial. E backup naquela época era mandar fazer uma cópia num disquete no fim do dia. Toda lojinha da esquina, que tinha um programa em Clipper pra controlar estoque, fornecedores, contas a pagar e a receber e coisas assim, sabia que precisava fazer isso. Fiz alguns programas desse tipo no começo dos anos 90.







No SQLite3, o formato de arquivos reflete essa diferença. Pra começar não é um arquivo append only como DBF, onde vai simplesmente gravando um registro na frente do outro e navegando via offset de endereços. Ele adota uma estrutura de árvore B, uma B-Tree. Não só no índice mas no banco de dados em si. Aliás, no caso do SQLite3, tem um único arquivo que contém várias tabelas, em vez de cada tabela ser um arquivo separado. 







Internamente não vai alocando registros e sim páginas. Páginas são como ranges, ou intervalos de endereços. Por exemplo, a página 1 pode ser do endereço 1 até 500, página 2 do endereço 501 até 1001. Páginas contém registros, ou linhas de uma tabela. As páginas são organizadas numa árvore B e os registros são nós folhas, leaf nodes, dentro das páginas.







Nos episódios de árvore, de sistemas de arquivos e de SQL eu falei sobre B-Trees e suas variantes como B+Trees, que sistemas de arquivos modernos como ZFS ou BTRFS utilizam. Tudo no seu sistema operacional é alguma variante de árvores, em particular árvores B, por isso falei que era importante saber como funcionam. No caso do SQLite3 tanto o banco de dados propriamente dito, quanto seus índices, são variantes de árvores B. Elas são muito eficientes. Vamos recapitular.







Primeiro de tudo, o B não é de binário. Árvore binária é um tipo de árvore mas não é b-tree. O B não tem uma definição definitiva mas pense como "balanceada". Uma característica importante é se auto-balancear. Todos os nós folha tem a mesma profundidade. Isso significa que não importa qual chave tá procurando, leva mais ou menos o mesmo tempo pra acessar qualquer nó. Isso é importante porque o tempo de "seek" ou procura num HD mecânico custa tempo. Uma árvore B minimiza a quantidade de operações de procura.







Árvores B tem alto fan-out, ou seja, são feitas pra cada nó interno poder ter um número grande de nós filhos, que é a ordem da árvore. Isso ajuda armazenamento em disco porque permite uma grande porção dos dados ser escrito tudo numa única página. O jeito antigo do DBF de ir alocando um registro de cada vez no fim é bem ineficiente e gera muita fragmentação. Alto fan-out significa que muitas chaves podem ser acessadas de uma só vez numa única operação de procura em disco. É melhor pegar uma chave que não precisava junto do que ficar procurando aleatoriamente por todo o disco.








Operações de inserção e deleção são muito eficientes. O algoritmo que mantém a árvore balanceada, e eu mostro uma versão disso no video de árvore, é super eficiente. Quando uma nova chave é inserida ou apagada a árvore é re-balanceada, pra garantir a propriedade dos nós folha terem sempre a mesma profundidade. E é muito estável mesmo com a árvore crescendo muito. Um banco de dados de SQLite3, que é super pequeno, aguenta um arquivão que pode teoricamente atingir até 280 terabytes.








Operações que pegam vários registros de uma só vez, tipo um SELECT WHERE da vida ficam mais eficientes, pela propriedade de vários registros estarem juntos numa mesma página. Com poucas operações de disco dá pra pegar todas elas ordenadas de uma só vez. Então, coisas como listagens e montar relatórios, tende a ser muito mais eficiente do que num DBF antigo. Tudo que você pedir que seja ordenado e sequencial, tende a ser eficiente pelas propriedades de páginas que expliquei.








Eu sempre ouvi que ninguém deveria tentar fazer um banco de dados do zero sem ter visto como um de verdade funciona por baixo, e esse é um dos motivos: operações em disco, especialmente mecânico, custam caro. Hoje custam caro, mas nos anos 80 ou 90 eram bem mais rudimentares. Um HD moderno, como meu IronWolf de 12 terabytes vem embutido com 256 megabytes de memória RAM. Não tinha PC nos anos 90 com tudo isso de RAM. Sem cache, as operações são mais custosas, porque realmente precisa colocar a cabeça em cima do disco de verdade.








Aqui estou especulando porque realmente não me lembro se era esse o caso, mas por exemplo, eu reservaria espaço no começo do disco pra colocar coisas como metadados, índices e os dados em si começariam a ser gravados depois. Como se eu tivesse uma partição C:, mais perto do centro do disco físico, onde as operações são mais rápidas do que perto das bordas dos discos. Daí numa partição D: ficariam os dados em si. 







Aliás, acho que é por isso que antigamente a gente particionava o HD, no C: ficava o sistema operacional, pra garantir que no boot o disco trabalhe menos e seja mais rápido, daí os dados e programas ficam no D:, mais longe do centro do disco. Mesma razão de hoje em dia deixarmos o boot num SSD ou NVME, que é muito mais rápido, mas sua biblioteca do Steam colocamos num HD mecânico separado. Sempre é um trade off entre mais performance ou mais espaço.







E não só SQLite3, claro, qualquer banco de dados moderno, como Postgres, Oracle, SQL Server, e até bancos não relacionais, como MongoDB, Firebase, Dynamo, Cassandra. E não só bancos de dados como sistemas de arquivos como ZFS ou BTRFS que já mencionei, todos usam alguma variante de árvore B, exatamente por todas essas propriedades. Tudo que lida com gerenciamento de dados, usa árvores B.







Porra Akita, mas um MongoDB não grava tudo em JSON? Eu mando JSON e ele me devolve JSON, portanto JSON deve ser o formato mais eficiente, não? Sério, se você for bem iniciante eu deixo isso passar, mas se algum programador pensa assim, realmente não entende nada de programação. JSON é um formato de consumo, não um formato de armazenamento. É um formato de tradução pra facilitar a vida mas é altamente ineficiente. Eu isso no episódio que falo do código do Twitter.







Primeiro, não é JSON, internamente os nós filhos são gravados em BSON que ele chama de Binary JSON, é um formato binário, como Protobufs do Google. Segundo, é internamente organizado numa B+Tree, ou árvore B+, onde os valores propriamente ditos são gravados direto nos nós folha no fim da árvore, diferente de uma árvore B pura que só tem os ponteiros.







O objetivo todo do episódio onde eu fiz um SQL em cima de um array de javascript, foi pra demonstrar que ter SQL não descreve nada de como é o banco de dados por baixo. Mesma coisa no MongoDB: a linguagem e formato de dados, como JSON, que se usa por cima, não diz nada sobre como é a arquitetura por baixo. Tanto que um Postgres, via SQL, pode devolver os dados em formato JSON se você quiser. É só uma tradução. JSON em si não significa nada pra nenhum banco de dados. Eles só precisam escolher exportar ou importar dados nesse formato. É só um formato, como XML ou CSV ou Excel.







Todo formato de dados de consumo como esse vai exigir um passo de importação pro formato interno binário de verdade, ou exportação pra esse formato. Então se você faz um "SELECT *"
da vida num banco, primeiro ele vai puxar todos os registros no formato binário dele. Isso vai ocupar um X de memória. Daí você escolhe que quer em formato JSON, então ele vai precisar de mais um tanto Y de memória, maior do que X, pra fazer essa tradução. É um processo de serialização e desserialização, e sempre vai exigir o dobro de memória pra ter essa conveniência.







Por isso que comunicação de um serviço com outro serviço, deveria ser sempre utilizando protocolos binários compatíveis entre eles, por exemplo, protobufs. Evitando ao máximo fazer tradução de dados, especialmente em formato texto. O formato de dados do SQLite3 não tem nenhuma relação com ele ter capacidade de receber comandos em SQL. Não existe um banco de dados "SQL", existem bancos de dados que entendem a linguagem SQL, só isso. Internamente todos são implementados de formas diferentes pra determinados cenários e casos de uso. 







Um SQLite3 é ótimo pra usar numa SmartTV, já um Postgres ou MongoDB da vida, nem tanto. Eles foram feitos pra rodar em servidores. Existem até projetos pra rodar SQLite3 em servidores, mas de novo, não foi feito pra isso. Use a ferramenta certa no lugar certo. Só porque você consegue arrancar um parafuso da parede com um alicate, não quer dizer que deveria, acha a porra da chave correta.








Internamente, todo banco de dados vai ter um formato de arquivos de armazenamento como um DBF, ou mais corretamente como o formato de um SQLite3, e formato de arquivos de índice. Todos vão ser alguma variante de árvore B ou árvore B+. Além disso temos mais coisas modernas, no caso do SQLite3 vai ter um outro arquivo com nome terminando em "wal", de write ahead log. Isso é outra coisa que sistemas de arquivos como FAT não tinham, mas todo sistema moderno como NTFS ou ext4 tem: um journal.







Pra economizar recursos, aquele comando REPLACE que eu mostrei lá no começo com dBase, escreve por cima do registro antigo no arquivo DBF diretamente. Isso é péssimo. Porque digamos que estamos fazendo uma atualização em massa em todos os registros do arquivo. Colocando o prefixo 9 em todo telefone que é de São Paulo, lá em 2012. Agora digamos que no meio dessa atualização acabou a luz e o computador reboota. Fodeu.








Isso era comum antigamente e significava que muito provavelmente o arquivo ficou num estado corrompido e eu perdi algum dado. Hoje em dia não se faz mais isso. Existem diversas estratégias, mas o SQLite3 escolheu um log de escrita pra frente ou write ahead log. Ele primeiro escreve as modificações nesse arquivo separado de log, depois que termina, troca um pelo outro. Bem simplificado é como se eu tivesse um arquivo chamado "contatos" daí tenho uma cópia dele chamado "contatos-wal" e as atualizações eu faço nesse segundo arquivo. Se tudo correu bem até o fim, agora troco um arquivo pelo outro.







É um pouco mais avançado que isso, mas só pra ter na cabeça a idéia. Se acabar a luz e o segundo arquivo estragar, ainda tem o original intacto. Além disso, se precisar fazer pesquisas, posso pesquisar no original enquanto a transação não acaba no segundo arquivo, em vez de ficar travado tendo que esperar até todas as operações acabarem. Todo banco de dados tem algum mecanismo desse tipo, mais sofisticado pra ter o menor tempo de trava quanto possível e garantir que nunca nenhum dado vai ser corrompido.







É um tipo de mecanismo de COW ou Copy on Write, como o sistema de arquivos BTRFS também tem em Linux. Por isso que é bem incomum hoje em dia perder dados. Mesmo o Windows tem NTFS, que protege razoavelmente bem. Qualquer Linux mais vagabundo usa pelo menos ext4, que tem suporte a journaling. Pra perder dados hoje, você precisa estar usando um hardware muito do vagabundo, como um SD card de câmera. 








SD card é um hardware de armazenamento que foi feito pra ter grande capacidade e ser super barato. Ele foi feito pra tirar fotos, gravar videos e logo em seguida transferir pra um computador. Não foi feito pra deixar lá guardado pra sempre. Não é confiável e podemos perder dados do nada, especialmente nos modelos mais baratos. SSDs baratos de Aliexpress, mesma coisa, mas nesse caso porque são fraudes mesmo, fabricados pra falhar. Cuidado com isso.








Outra característica que bancos relacionais trouxeram foi esse conceito de transação e ACID, de atomicidade na operações. Ou todas acabam com sucesso ou nenhuma acaba. De consistência, por exemplo, regras de unicidade, chaves estrangeiras, e tudo mais. Os dados precisam sempre seguir essas regras, sem exceção. Isolamento, ou seja, se um conjunto de transações roda em paralelo, o resultado tem que ser o mesmo se eles tivessem rodado sequencialmente. O banco não pode ficar num estado inconsistente. E durabilidade, se a transação diz que gravou o dado, podemos acreditar que realmente está fisicamente no disco. 








Caso um erro aconteça, como a famosa falta de luz, o banco precisa voltar pro último estado consistente conhecido. Nunca pode continuar operando num estado inconsistente. Cada banco implementa isso de formas diferentes, mas no geral significa que podemos confiar nos dados num banco de dados relacional. Seja um MySQL ou Posgres ou SQL Server, no geral, implementam bem essas características. Mesmo o pequeno SQLite3 faz isso. Um dos jeitos mais toscos é simplesmente bloquear o arquivo todo pra cada transação, esperar completar com sucesso e só aí liberar pra outras operações. Mas claro, isso seria altamente ineficiente.









Mas era assim que bancos de dados xBase, DBF funcionavam em rede nos anos 90 quando começamos a usar placas de rede em MS-DOS e fazer pequenas redes usando ferramentas da antiga Novell ou o Windows 3.1 for Workgroups ou o venerado OS/2 da IBM. Na prática, um computador era elegido como um servidor de arquivos, esses arquivos DBF e NDX eram compartilhados em rede, e todos os outros computadores na rede enxergavam os mesmos arquivos.







Cada computador tinha a mesma versão do programa em dBase ou Clipper ou FoxPro instalado. Se algum tivesse uma versão mais antiga, era caos. A consistência, as regras, dependiam totalmente da versão do programa instalado em cada máquina. A atomicidade era mais ou menos garantida por um sistema de lock. Quando um programa quisesse inserir um registro novo, ele travava o acesso àquele arquivo. Se um segundo computador tentasse ler, recebia um erro que o arquivo tava ocupado, e precisava esperar.







Isso nem sempre funcionava. E se o arquivo DBF, sozinho numa única máquina tendia a se corromper, porque não existia nenhum sistema de proteçõ como journals, imagine em rede. Corromper arquivos era rotina. Experimenta esquecer de fazer backup no fim do dia, certeza que no dia seguinte ia dar pau e corromper alguma coisa. Sistemas de arquivos em rede como Novell era uma puta gambiarra feita em cima do DOS, com tecnologias super imaturas. 






Hoje usamos protocolos de internet como TCP/IP, mas naquela época usávamos protocolos mais rudimentares como IPX/SPX e NetBIOS da Microsoft. Verdadeiras porcarias. E mesmo a tecnologia de redes em si, hoje usamos Ethernet de 1 gigabit pra cima, antigamente eram cabos coaxiais que nem de TV a cabo, que male male, faziam 10 megabits. Perdiam pacotes, corrompiam dados e assim vai.







Com a migração de MS-DOS pra Windows e da arquitetura de 16 bits pra 32 bits, ganhamos até 4 gigabytes de RAM pra trabalhar, sem precisar fazer gambiarras de memória em DOS como eu explico no episódio dos 640 kilobytes. E com isso, em vez de cada programa em cada máquina da rede, tentar acessar diretamente os arquivos de dados, eles passaram a conversar com um software servidor. Dessa forma, só um software tinha acesso direto aos arquivos e todos os outros, programas clientes, conversavam com esse servidor usando algum protocolo, com alguma linguagem, no caso o SQL.







Essa foi a era de programas feitos em Visual Basic ou Delphi, conversando com bancos de dados servidores mais modernos como SQL Server, que tinha T-SQL, ou Oracle, que tinha PL/SQL ou alguns mais de nicho como o Interbase da Borland, que era o padrão pra quem usava Delphi. Em vez de cada programa cliente ter que controlar a integridade dos arquivos, melhor terceirizar isso pra um servidor. Os clientes só falam "ow, grava isso pra mim" ou "ow, pesquisa isso pra mim" e o servidor se vira. Isso aumentou muito não só a escalabilidade mas também a estabilidade. Se um cliente manda uma operação não suportada, o servidor pode só recusar, em vez de tentar executar e corromper arquivos.







SQLite3, oficialmente não tem um servidor. Mas tem gente tentando fazer um sei lá porque. Tem um projeto chamado ValentinaDB que faz isso. Não vejo nenhuma vantagem. Se você quer um banco de dados SQL, formato cliente-servidor, use um de verdade, que é maduro, como MySQL ou Postgres. Use SQLite3 pra programas que precisam de dados localmente, como seu roteador de internet que já dei de exemplo.








Quando temos o formato de um servidor, temos algumas vantagens e algumas desvantagens. A primeira é que a velocidade vai depender da qualidade da rede. Tudo que roda localmente sempre é mais rápido. Em rede você precisa pegar o resultado, quebrar em pacotes, rotear esses pacotes, ir recebendo, processando um buffer, e só aí vai ter os dados. 






Podemos escolher ir recebendo e já processando os dados localmente, ou podemos escolher esperar receber a resposta toda e só depois fazer alguma coisa. É a diferença de receber tudo de uma vez ou usar técnicas de streaming. E aí depende da sua pesquisa. Se for tosca e mal feita, e mandar tipo um "SELECT *" pra uma tabela de 10 gigabytes, sem usar streaming, boa sorte, vai ocupar toda a memória da sua máquina e mais o swap em disco.








Isso é o que iniciantes tem mais dificuldade de entender: os dados que pedem precisam ir pra algum lugar. Nada é de graça em computação. O trabalho principal de um programador é justamente administrar os recursos da máquina da maneira mais eficiente possível. Por exemplo, digamos que preciso montar um relatório em PDF de todas as vendas do mês. Vou fazer tipo um "SELECT * FROM ORDERS WHERE created_at > date() - 30". Essa é uma pesquisa rudimentar que filtra todas as ordens criadas nos últimos 30 dias. Faz de conta que vai devolver 500 ordens.








Digamos que cada uma dessas linhas consuma 500 bytes, só meio kilobyte. Se eu puxar tudo de uma vez do banco e colocar num array em memória, vai ocupar 250 megabytes. É bastante coisa. Daí abrimos uma biblioteca qualquer pra montar PDF e converter essas linhas em um documento PDF em memória. Pra simplificar o exemplo, digamos que cada linha no PDF também use 500 bytes. Significa que no fim da operação, vou estar consumindo 500 megabytes na memória, meio gigabyte, metade com os dados que vieram do banco e metade com o PDF.







Qual o jeito certo? Depende, talvez seja esse mesmo. Existem técnicas se quiser otimizar. Um dos jeitos é escolhendo uma biblioteca de PDF que suporte escrever direto pro disco em vez de acumular tudo em memória. Por exemplo, em Java tem a biblioteca PDFBox da Apache. Podemos ir salvando incrementalmente uma página de cada vez pro disco. Digamos que cada página tenha 20 ordens, então só vou precisar de aproximadamente 10 megabytes na memória por vez.







Além disso podemos ir recebendo uma linha de cada vez do banco, e montar uma linha no PDF e descartar essa memória, daí recebo a próxima linha e faço a mesma coisa, sem acumular tudo. Em resumo, significa que de memória de trabalho precisaria, no máximo, ter uns 10 megabytes pra montar uma página de PDF e mais meio megabyte por linha que recebo do servidor de banco de dados, um total de 10 mega e meio. 






Aí não importa se o relatório vai ter 100 ordens ou 1000 ordens, sempre vou usar o máximo de 10 mega e meio de cada vez, e não 500 megabytes pra 500 ordens ou 1 gigabyte se for mês de natal e tiver 1000 ordens. Esse é seu trabalho como programador: encontrar o teto máximo que realmente precisa e limitar o uso de recursos. Só assim é possível escalar. O jeito amador é ir usando cada vez mais memória à medida que os dados vão aumentando de volume. Sempre pense em jeitos de usar um teto fixo de memória e processamento, independente de quantos dados vai processar.








Quando falamos que é importante entender SQL direito, primeiro é pra aprender a fazer queries ou pesquisas, SELECTs que devolvam a menor quantidade de dados quanto possível, porque cada dado extra que vier e não usarmos, vai desperdiçando memória e processamento. Mas também precisamos entender algumas noções como, se vamos escrever ou atualizar dados, é melhor mandar os comandos todos de uma só vez do que mandar um de cada vez, esperar um por um terminar e confirmar antes de mandar o próximo.







Aquele exemplo que falei de adicionar o número 9 na frente de todo número de telefone de São Paulo em 2012. Digamos que tenha 100 mil usuários na minha tabela. O jeito mais tosco possível é fazer um programa que conecta no banco e primeiro faz um "SELECT *" e devolve todo mundo pro seu programa. De novo, se cada registro ocupa meio kilobyte e você deu asterisco, mandou voltar todos os campos da tabela, são 50 mil megabytes, 50 gigabytes de dados. Estão entendendo porque isso de puxar tudo pra memória é ruim? É o jeito mais fácil de pensar primeiro, mas é o pior jeito.







Digamos que você tá num servidor parrudo na Amazon, ou num PC igual o meu com 64 gigabytes, e depois de um bom tempo,  carregou a tabela inteira em memória. Agora você faz um loop nessa lista e manda dar um UPDATE no servidor pra cada registro. Um UPDATE em uma transação separada, 100 mil vezes. São 100 mil updates, 100 mil alterações individuais de índice, 100 mil commits, e 100 mil esperas de retorno OK do servidor. Lá se vão mais algumas horas esperando.








Qual o jeito certo? Se não ficou óbvio, não precisa dar SELECT de nada. Só fazer um único comando de UPDATE. Algo como "UPDATE SET TELEFONE = "9" + TELEFONE WHERE CITY = 'Sao Paulo' AND bla bla" . Um único comando que vai mexer em todos os milhares de registros tudo de uma só vez. Com uma única conexão de rede, um único commit, uma única espera. Não precisa puxar todo mundo pra memória, depois fazer update um a um separado. Entenda esse conceito. A melhor operação trás zero dados do servidor e opera tudo lá.







Do jeito tosco, o programa cliente, digamos sua aplicação web ou mobile, mandou individualmente um comando de update pra cada usuários, esperou a resposta e mandou o próximo, 100 mil vezes. Do jeito certo, seu programa só se conectou uma vez e só mandou um comando, e afetou os mesmos 100 mil registros. A diferença de tempo aqui vai ser na ordem de centenas ou milhares de vezes mais rápido e usando ordens de grandeza menos recursos de memória e processamento. Isso é entender SQL.








Programadores iniciantes aprendendo hoje não tem desculpa. O pessoal das antigas que fazia dBase, até consigo entender, porque naquele formato rudimentar de DBF, não tinha outra forma. Tinha que iniciar um loop "DO WHILE" fazer uma condição com "IF" e aí fazer "REPLACE" no registro atual, dar "SKIP" pra pular pro próximo e repetir 100 mil vezes. Não tinha um servidor que fazia isso sozinho pra gente. 








Mas pelo menos naquela época estava tudo rodando localmente na mesma máquina, modificando diretamente o arquivo. É o que o servidor de SQL vai ter que fazer no lado dele. Mas um cliente de banco de dados não tem que fazer loop nenhum se comunicando com servidor registro a registro, quase nunca. Se você tem um loop pra processar dados vindos do servidor de banco de dados, provavelmente está errado. No mínimo é um red flag que precisa ser revisto. Pelo menos lembre disso como regra: se tem um loop, está errado, pense de novo.








Outra coisa que o formato antigo não permitia fazer e você tem que aprender como fazer no SQL são constraints. As tais regras de consistência. Por exemplo, um campo que nunca pode ter valor vazio. Ou um campo que é uma chave estrangeira, um campo numa tabela com o ID primário de outro registro em outra tabela. Chaves estrangeiras garantem que você só está escrevendo IDs que realmente existem. No formato DBF não existia isso, você como programador precisava garantir essas regras manualmente, no código, com um monte de IFs pra lá e pra cá. Em SQL, se tem um monte de IFs, provavelmente deveriam ser constraints.








No mundo moderno de cliente e servidor, significa que muitas vezes essas regras vão ser duplicadas, no cliente pra poder mostrar pro usuário que ele digitou dados inválidos, por exemplo, e no servidor, pra garantir que nas tabelas só tenha dados realmente corretos. Muita gente acha essa redundância ruim, mas eu acho o contrário. Não existe nada pior que dado inconsistente. É melhor checar duas vezes do que não checar. Checagens de consistência que só existem no front-end, e no lado do banco de dados aceita tudo e não checa nada, é a maior porcaria de todas as porcarias. Sempre esses bancos de dados estão em estado inconsistente e sempre vai dar problema. 







Crie a tabela no schema com as constraints e validações todas, validação de tipos de dados, validação de tamanho, validação se pode ser vazio ou não, validação de chaves, tudo. Daí faça uma classe do lado cliente que reflete as tabelas usando um ORM, como Hibernate em Java ou um model em Sequelize no Javascript ou model de Django em Python, não importa, repita as mesmas validações. Daí faça um componente em React pro front-end. 







Repita as mesmas validações. Puuuts, mas vai repetir 3 vezes? Sim, repita 3 vezes, e faça testes unitários pra cada uma delas e teste de integração que cheque todas ao mesmo tempo. Esse é o seu trabalho. É que nem médico achar que lavar mão toda hora antes da cirurgia é perda de tempo. "Ah, de novo? Eu já lavei de manhã, não precisa de novo". Lave de novo.







Beleza, tem que estudar SQL. Não só saber sintaxe de SQL, mas o  uso de recursos e processamento no servidor. E como otimizar. Nenhum ORM, biblioteca ou framework vai fazer isso pra você. Na verdade, é muito fácil fazer o jeito errado assumindo que o framework vai cuidar de tudo sozinho. Muitos tutoriais, no intuito de serem didáticos, vão te ensinar o jeito menos eficiente. Porque o jeito mais eficiente costuma ser mais difícil de explicar e demonstrar. 







E quando você testa com poucos registros, 10, 100, mil, não faz  nenhuma diferença. Só quando realmente coloca em produção que vai entender o impacto. Essa é a diferença de crianças e adultos: quem já teve a experiência de perder dados de cliente ou ficar tudo lento que a loja pára de funcionar. Só aí que entende "ahhhh, eu tava entendendo errado". Pois é. Tente evitar ter que chegar nesse ponto. Nem todo mundo precisa enfiar o dedo na tomada pra saber que toma choque.







Num sistema grande de verdade, numa equipe com vários desenvolvedores, é difícil de checar se todo código foi bem feito ou não. E mesmo sendo experiente, na pressão alguém deixa passar um código que vai usar memória sem precisar ou que vai deixar tudo lento porque botou um loop num lugar que não deveria. Por isso que todo sistema web em produção precisa ser monitorado. Existem diversas ferramentas de monitoramento, seja usando os antigos Nagios ou Zabbix ou serviços mais modernos como Splunk, Datadog, AppOptics, AppDynamics, Dynatrace, Sentry.io, Instana, Azure Monitor e vários outros. Não tem desculpa não usar pelo menos um.







Honestamente eu não sei dizer qual é o melhor hoje em dia, mas na dúvida, sempre usei e continuo recomendando no mínimo instalar o New Relic RPM. Alguns deles são passivos, com os antigos Nagios ou Logtail, porque medem coisas fora da aplicação, como uso de CPU, memória, análise dos arquivos de log. Mas os melhores exigem que você instale uma biblioteca que age como um agente dentro da aplicação. Como tem acesso à memória da aplicação, dá pra fazer análises muito melhores.







Sem entrar em detalhes, podemos avaliar logo depois de um deployment em produção, e ver se uso de memória aumentou e fica constante, por exemplo, ou se continua lentamente subindo até uma hora crashear. Ou podemos monitorar quando uma campanha de marketing entra no ar e vem um volume maior de tráfego. O aumento do uso de recursos está proporcional? Mais importante, podemos avaliar quais partes do código costumam consumir mais recursos. 







Com isso podemos focar em melhorias bem mais precisas só nas partes que realmente precisa. Em vez de ficar no achismo de mexer no código sem saber quais reais impactos está causando. Depois que uma aplicação entra em produção, toda manutenção deve ser feita ao redor de métricas. Sempre medir o antes e o depois. Se o objetivo for consumir menos infraestrutura, sempre atacar os principais ofensores segundo as métricas. Se você não consegue medir, certamente não consegue consertar.







No lado do banco de dados, nenhum consegue crescer infinitamente. Como disse, pro caso geral de empresas pequenas ou médias, leva muito tempo pra começar a entrar no território de Big Data. Dezenas ou centenas de terabytes de dados. Um banco de dados relacional tradicional costuma ter os seguintes problemas de escalabilidade:







Primeiro, as tabelas simplesmente estão grandes demais. E quando eu digo grandes, quero dizer centenas de gigabytes, ou terabytes. Por mais que você tenha índices, lembra o que mostrei no caso do DBF e seus índices NDX? O arquivo de índice vai crescendo também. Quanto mais dados for inserindo, maior vai ficando os seus índices também. E vai chegar uma hora que pesquisar índices tão pesados vai ser lento.








A primeira estratégia pra lidar com esse problema se chama "arquivamento". O certo é ter ou um segundo servidor de banco de dados usado só pra pesquisas e relatórios, mas fora do acesso pra usuários. Digamos que você tenha um ecommerce. Se tiver sucesso e vender muito, sua tabela de ordens vai ter milhões de vendas. Mas pensa: pra que serve dados de ordens antigas? Ordens de usuários que cancelaram contas ou que não entram faz muito tempo? Mova pra um segundo banco de dados.









Assim você tem um banco de dados com dados que realmente seus usuários precisam, mas sem os dados que ninguém nunca acessa. Digamos que sua empresa é uma multi-nacional com dezenas de filiais, dezenas de milhares de funcionários e seu sistema controla tudo de RH: folha de pagamento, benefícios, férias, documentação, e tudo mais. Pra que tem dados de funcionários de 5 anos atrás? Arquive. Mova pra um segundo banco de dados, ou mova pra um backup frio mesmo, como fita ou pra um AWS Glacier da vida, que é tipo um S3 mais barato.







Em qualquer empresa média ou grande, com sistemas de controle internos, vai ter tabelas com dados antigos que não precisam estar lá. É uma prática que de tempos em tempos, todo ano, talvez todo semestre, se faça essa manutenção de limpeza: arquivar, mover dados mortos, pra outro lugar que se acessa menos. Não é apagar. É mover. Nunca é uma boa idéia apagar nada. 







Nunca se sabe quando vai precisar, especialmente sua área jurídica. Mantenha dados no mínimo em backup, por no mínimo 5 anos, por causa da lei. A grande maioria das pequenas empresas peca em sequer ter um backup que funciona, quanto mais se preocupar com arquivamento. De novo, não é pra pequenos isso. Pequenos tem que se preocupar com o básico: ter um backup, pra começar.







Mas aí começamos a entrar no território de unicórnios. Uber, Netflix, iFood, MercadoLivre, e várias tech startups que geram toneladas de dados. Digamos que é um iFood da vida. Não só vai ter informações básicas como cadastro do usuário e tabela de pedidos simples, mas vai ter mais dados como quem foi o motoqueiro que fez cada entrega, que rotas usou, que contatos foram realizados durante o percurso, o usuário abriu chat, o que ele falou? É uma granularidade e volume muito maior de dados. Cada pequeno pedido gera megabytes de dados pra depois serem usados pra inteligência, métricas de como melhorar a experiência e tudo mais.







Empresas assim geram gigabytes de dados por dia. O problema não é só o volume de dados, mas a velocidade em que são gerados. Aqui é o território de Data Warehouses, Data Lakes e coisas assim. Em nenhuma dessas empresas vai ter um único servidor de banco de dados com tudo. Sempre vai ter múltiplos bancos de dados, e certamente de vários tipos diferentes pra cada caso de uso diferente.







Simplificando bastante. Do lado do usuários que usa o app, faz pedidos, acompanha a entrega e tudo mais, cada usuário vai gerar dezenas de requisições pros servidores de um iFood ou Uber da vida. As pesquisas sendo feitas precisam ser rápidas. Estamos falando de centenas de milhares de usuários acessando a plataforma ao mesmo tempo. Por mais parrudo que seja um servidor, nenhum aguentaria. Precisa distribuir essa carga em múltiplos servidores.







Quando se instala múltiplos servidores de aplicação, eles não podem todos acessar um único servidor de banco de dados. Iria gerar uma fila enorme e muita espera, muita latência entre requisições. O problema de bancos de dados relacionais como Posgres ou SQL Server é que foram originalmente feitos pra funcionar num único servidor parrudo. A gente escalava o serviço melhorando o hardware da máquina, colocando mais RAM ou colocando uma CPU maior. Eles não foram pensados pra funcionar em múltiplos servidores.








Hoje em dia fazemos um meio do caminho. O maior volume de operações costuma ser pesquisa. Como pesquisa de cardápio. Enquanto faz isso não está gravando nada, só pesquisando. Todos os serviços de bancos de dados SaaS modernos conseguem criar servidores réplica, cópia da original, automaticamente. Assim os servidores de aplicação web conseguem fazer a pesquisa em qualquer uma das réplicas, evitando que se crie gargalo só em um.







Mais do que isso, hoje em dia, um servidor de aplicação vai primeiro fazer a pesquisa num servidor de cache, como um Memcache ou Redis. Se usar uma AWS temos Amazon ElastiCache, que é basicamente Memcache ou Redis como serviço. A aplicação primeiro checa se tem o cardápio do restaurante no cache, se não tiver, aí pesquisa via SQL no banco de dados, grava no cache e serve de volta pro usuário. Muito da carga de pesquisa cai em cima de alguma solução de cache. É impossível criar serviços grandes como um iFood ou MercadoLivre sem ter um volume grande de cache.








Temos dois problemas com isso. O primeiro é que apesar de ser razoavelmente simples de criar servidores de réplica, é difícil de ter múltiplos servidores que aguentem escritas. Operações como INSERT, UPDATE ou DELETE acontecem num único servidor principal. Todas as outras réplicas costumam ser read-only, somente de leitura. Existe um pequeno delay, uma pequena latência, entre a escrita completar no servidor principal e as réplicas serem atualizadas, mas isso costuma valer a pena.








Todo ecommerce da vida, tem essa arquitetura de servidor de banco de dados mestre principal pra escritas, várias réplicas somente de leitura e muito cache, aliado à uma estratégia de jobs assíncronos, com Apache Kafka da vida. Estratégias que já expliquei no episódio do Ingresso.com, do Twitch e do Twitter, depois revejam. Mas mesmo assim, ainda tem casos especiais.







Digamos que temos um serviço de analytics, como um Google Analytics, capturando cada visualização, cada clique, toda operação que usuários estão fazendo em diversos apps, diversos sites, pra gerar monitoramento em tempo real, relatórios periódicos com informações de cada usuário. 




Ou imagine que fazemos o software que captura informações vindas de Apple Watch ou Galaxy Watch. Informações de batimentos cardíacos, que cada usuário te manda 1 vez a cada 2 minutos. Apple e Samsung tem milhões de usuários, consegue imaginar esse volume de dados?






Ou imagine uma corretora de criptomoedas como uma Binance, com milhares de transações acontecendo a cada minuto, milhares de pessoas comprando e vendendo sem parar. Ou imagine um servidor de games com Call of Duty ou Fortnite, onde se captura informações de cada ação de cada jogador, cada movimento, cada tiro, cada pontuação. Jogadores do mundo inteiro.







Estamos falando de gigabytes, sendo gerados por minuto. É muito dado. E em cima desses dados, queremos gerar compilados, como o relatório da sua saúde na última hora, ou nas últimas 24 horas, ou do mês. Pra isso tem que ordenar, agrupar, processar e sumarizar gigabytes de dados recebidos por cada usuário. É muito pesado. E não por acaso essa discussão começou a surgir no fim dos anos 2000. Justamente quando redes sociais como Facebook, Twitter, estavam atingindo proporções que nenhuma outra plataforma nunca tinha atingido até aquele ponto. Sem contar o advento de Mobile e da popularização de games online.








Nessas circunstâncias, de fato, o esquema de bancos de dados relacionais atinge seus limites. As pesquisas ficam lentas pelo volume absurdo de dados. Pior, as escritas ficam absurdamente lentas, em parte por causa das garantias que estávamos acostumados a ter, como durabilidade. A idéia de que se mandamos o servidor gravar uma linha e ele diz "ok" significa que aquela linha garantidamente está no disco. Nesses cenários de Big Data, essa garantia se torna um problema.







Quando falamos em Big Data, precisamos lidar com premissas diferentes. Num banco, se sumir uma linha do seu extrato, é um grande problema. Literalmente a conta não vai fechar. Vai faltar um depósito. Vai faltar um pagamento. Dinheiro vai sumir. Pior, se uma linha for duplicada. Mesma coisa num ecommerce. Mesma coisa num sistema com da Receita Federal. Todos precisam de garantias na consistência e integridade dos dados. Por isso existe e sempre vai existir um lugar pra bancos de dados com características que um Oracle, SQL Server ou Postgres oferecem hoje.








Mas pra certos tipos de dados, como analytics, como dados de batimentos cardíacos, como dados de jogos online, mesmo se você perder ou duplicar uma linha dessas, qual o impacto? É baixo ou, no caso geral, nenhum impacto. Estando dentro de uma margem de erro, no fim do dia, você não tá interessado em cada clique individual no seu site, estamos interessados na quantidade geral por dia, por semana, por mês. Não estamos interessados no batimento exato de 5 minutos atrás, mas sim na média por hora, na média durante um exercício ou na média durante o sono. E assim por diante.







É por isso que a partir do começo dos anos 2010 começaram a surgir bancos de dados não relacionais, os NoSQL. Bancos de dados criados pra responder situações diferentes, em particular de Big Data, onde queremos lidar com séries de dados consolidados. Onde velocidade de escrita e baixa latência tem prioridade sobre consistência. Queremos poder escrever em múltiplos servidores ao mesmo tempo, mesmo que durante algum período de tempo, os dados fiquem ligeiramente inconsistentes. 







O problema é como distribuir a carga, tanto de processamento pra pesquisa, quanto pra escrita, e como dividir os dados entre múltiplos servidores diferentes, pra permitir escalabilidade? Recapitulando: bancos de dados relacionais funcionam muito bem num único servidor, oferecendo as garantias ACID de atomicidade, consistência, isolamento e durabilidade que todos nós gostamos. Tem opções pra escalar via réplicas somente de leitura e, até certo ponto, replicação bi-direcional, que é sempre complicado. Mas pra situações de Big Data e volumes gigantes de escritas, começa a se tornar uma tarefa complicada, chata e com poucas opções.








Não tem como falar de NoSQL sem mencionar o famoso teorema CAP, proposto por Eric Brewer no ano 2000. Foi um divisor de águas no estudo de sistemas distribuídos e provavelmente você vai aprender no curso de ciências da computação, mas em resumo ele propõe que bancos de dados verdadeiramente distribuídos, ou seja, que rodam em múltiplos servidores, ou múltiplos nós de um cluster, no máximo satisfazem duas de três propriedades: consistência, availability ou disponibilidade e partition tolerance ou tolerância a partição.







Ou temos consistência e durabilidade, mas o sistema não tolera partições, ou seja, alguns nós do cluster podem ficar offline do nada. Isso não é legal porque não é impossível um servidor dar problema, ou mesmo termos que tirar um deles do ar pra manutenção. Então queremos consistência e tolerância a partição, mas aí temos baixa disponibilidade, ou vamos ter o ideal, disponibilidade e tolerância a partição, mas teremos baixa consistência, ou o que chamamos de "consistência eventual", onde um servidor, por um ligeiro período de tempo, pode não ter os mesmos dados que os outros servidores.







CAP é um teorema e não uma teoria, ou seja, não é uma lei. Quando estudar vai encontrar que nem todo mundo concorda com todos os argumentos, em particular, porque os termos consistência, disponibilidade e tolerância a partição podem ser facilmente mal interpretados. Não tem uma definição muito exata pra cada coisa, e todo mundo sabe o que acontece quando termos ficam abertos à interpretação: ninguém se entende. E isso acontece com frequência, porque na minha cabeça eu quero falar de consistência mas você tá entendendo como integridade. E uma coisa é diferente da outra.







Daí tem o problema da natureza binária. É um dos poucos lugares que de fato não podemos levar ao pé da letra que só podemos escolher 2 propriedades das 3. No caso de termos disponibilidade e tolerância, não significa que não vamos ter nenhuma consistência. Depende se precisamos de consistência forte, onde é obrigatório que todas as réplicas sempre tenham exatamente o mesmo dado correto, ou se podemos ter consistência fraca, eventual, onde durante alguns segundos, os dados diferem entre os servidores. De novo, num banco, não podemos ter um saldo, recarregar o navegador e aparecer outro saldo, mas no exemplo dos batimentos cardíacos, se faltar um batimento durante 1 minuto, não vai ser um problema, não quer dizer que você teve uma parada cardíaca nem nada.







A outra coisa é tolerância a partição. De novo, pense num data center, onde um grande serviço pode ter um banco distribuído em múltiplos data centers, uma dúzia de servidores em Nova Iorque, outra dúzia de servidores em Londres, todos sincronizados, mas aí temos uma pane na internet entreeles. Um link submarino deu pane, caiu a fibra ótica. É raro acontecer, mas acontece. E o sistema tem que saber o que fazer quando acontecer, ou seja, ser tolerante a essa partição da rede. 








O problema é que isso realmente é muito raro de acontecer. Nossa infraestrutura dos anos 2020 é mil vezes melhor que nos anos 2000, hardware, redes, infra em geral é muito mais estável. Então nossos sistemas não precisam ser tão agressivos na preparação pra uma situação tão rara. Talvez seja melhor ser otimizado considerando o caso que não vai acontecer, e colocar estratégias de degradação graciosa caso aconteça, como simplesmente uma página de "aguarde alguns segundos". Mesmo se tiver pane na rede, hoje em dia, se recupera em poucos minutos. Antigamente poderia levar horas ou dias.









Essas são algumas das considerações ao se discutir o teorema CAP. Na prática vamos lidar com alguma estratégia de sharding e alguma estratégia de replicação de dados. Replicação é como acontece com um banco de dados relacional, onde podemos adicionar nós na rede, e eles vão receber uma cópia dos dados, daí cada servidor vai ficar idêntico ao outro, fornecendo redundância e possibilitando dividir a carga dos usuários pra mais servidores. 







No caso de banco de dados relacional, por causa da característica de consistência forte, ficamos limitados na quantidade de servidores que podemos ter pra escrita. Num NoSQL, com consistência eventual, qualquer dos nós pode ser usado pra escrita, mas vai levar um tempo pra replicar os dados pros outros servidores. A consistência vai existir, mas vai ser eventual, ou seja, eventualmente vai estar tudo consistente.







Na real, bancos de dados NoSQL como Cassandra ou Dynamo tem como configurar que nível de consistência queremos ter. Mais forte ou mais fraco. Podemos configurar isso dependendo das necessidades. Uma coisa é um pequeno cluster de 3 servidores de Cassandra tudo no mesmo data center, na mesma rede. Outra coisa são múltiplos clusters de dúzias de servidores em vários de data center diferentes, como é a operação do tamanho de uma Netflix.








Bancos como Cassandra ou Dynamo foram feitos mais pra situações onde precisamos funcionar em múltiplos data centers. Dividido em regiões geográficas diferentes. Um no Japão, outro na Europa, outra na América e todos os servidores de todos os clusters sincronizando entre si. Não é uma situação que vamos encontrar todo dia. 






Pra maioria das empresas médias, em vez de lidar com uma infraestrutura dessas do zero, o mais prático seria usar um DynamoDB da AWS. Como tudo da AWS, eles gerenciam a maior parte dessa complexidade e podemos só usar. Claro que, por causa disso, o custo por transação é bem mais caro. Mas é esse o trade-off que precisa ser estudado. Ou vamos ter que investir em contratar pessoal especializado em infraestrutura, pra ficar 24 por 7 lidando com hardware, bare metal, num data center.







Ambos Cassandra e Dynamo oferecem capacidades de particionamento e replicação. MongoDB também tem isso, mas ele chama de sharding e replica sets. O que buscamos é a capacidade de conseguir particionar os dados em múltiplos servidores de forma balanceada, e de ter replicação entre alguns desses servidores pra ter redundância. Se um deles tiver uma pane e cair, tem outra cópia idêntica pra continuar servindo os mesmos dados. É muito complexo pra tentar detalhar em um video, mas eu queria que vocês pelo menos soubessem que isso existe pra saber onde procurar depois.







Pra agora é interessante conhecer um último conceito: IDs. Voltando pro exemplo lá do começo, a tabela de contatos feito em DBF com dBase. Lembram que falei que mesmo se eu fizer um índice de nome, precisaria procurar pelo nome completo pra achar? Hoje em dia, em qualquer banco de dados, todos oferecem alguma forma de pesquisar parcialmente ou palavras que soam parecido. É o que um Elasticsearch, Solr ou os recursos de full-text search de um Postgres e outros bancos de dados oferecem. É um índice diferente pra esse tipo de pesquisa em particular. Expliquei um isso no episódio do Twitter, vejam lá depois.







Antigamente, nos anos 80, não tínhamos o poder de processamento pra fazer coisas desse tipo. Em vez de tentar lembrar se "Brian Russell" tem dois "S" ou dois "L", em muitos casos era mais fácil lembrar o código dele, o ID. Por isso toda tabela a gente se acostumou a colocar esse código. Assim como todo pedido de compra tem um código. Assim como todo indivíduo nesse país é um CPF. Toda linha numa tabela é um código numérico, que usamos como uma chave primária ou, no caso de bancos relacionais, usamos pra fazer uma linha em uma tabela referenciar uma linha em outra tabela, e chamamos esses IDs de chaves estrangeiras, porque ela é estrangeira à tabela.









O jeito considerado errado hoje, principalmente em códigos que vamos divulgar pros usuários, é fazer a chave primária ser um número auto-incremental. Ou seja, começando de 1 e incrementando, próxima linha sendo 2, linha seguinte sendo 3 e assim por diante. Um erro de segurança que foi muito comum antigamente era ter uma aplicação web onde a URL mostra esse código, por exemplo, digamos que tivesse `mercadolivre.com/users/1` que é a URL pra página com os dados cadastrais de um usuário.








Num sistema bem feito, quando o usuário faz login, eu guardo o ID dele na sessão. Quando ele navega pra outras páginas privadas, checamos com o ID na sessão antes de mostrar a informação. Se ele tentar acessar a URL que seria de outro usuário, conseguimos invalidar o pedido e devolver um erro 403 não permitido. Esse seria o certo, mas num sistema grande, alguém pode deixar passar um bug e não checar. 






Daí alguém de fora, percebendo que estão usando IDs auto incrementais, e o dele é ID 1000, óbvio que significa que tem usuários abaixo de 1000 e alguns acima, e ele vai começar a tentar forçar IDs até alguma página abrir na conta de outro usuário. O certo é não ter esse bug. Mas também não é legal oferecer informação de graça pra estranhos, como a existência de outros usuários com IDs fáceis de achar.







O ideal é usar um número aleatório gigante. Um campo de inteiro de 32 bits pode conter números de 0 até mais de 4 bilhões. Mas se for um inteiro de 64 bits, estamos na ordem de 18 milhões de trilhões. É muito número. Por isso não precisamos usar números sequenciais auto incrementais, use números aleatórios. Vai ser perto de impossível tentar adivinhar o ID de alguém. 







Pra isso usamos funções geradores de números como UUIDs. Nem precisamos usar o número inteiro que ele gera, basta truncar e pegar um pedaço e as chances de colisão, ou seja, de escolher um número que já existe na sua tabela, vai ser hiper baixo. E como o certo é criar campos de chave primária com constraint de unicidade, ele não vai deixar inserir um ID duplicado. Existem dezenas de estratégias pra gerar números aleatórios pra IDs, vale a pena parar pra pesquisar e evitar números sequenciais. Chamamos isso de chaves surrogadas. Não é nenhuma lei, mas é uma boa prática. Pra tabelas internas, cujos IDs você nunca vai mostrar em público, aí tanto faz.








Expliquei isso porque em sistemas distribuídos, temos o problema de balancear dados entre diferentes servidores. Quando replicamos dados, estamos fazendo uma cópia dos dados de um servidor pra outro, pra servir de redundância, mas num sistema grande distribuído, queremos dividir o processamento, e isso exige que alguns servidores vão ter dados que outros servidores não vão ter. Deixa eu dar um exemplo besta.







Digamos que trabalho na Receita Federal. Eca. Fazer um único banco de dados com todos os impostos de renda, de todas as pessoas e empresas, num único banco de dados, é bem pesado. Ainda mais se tiver a informação histórica de todo mundo das últimas décadas. Um jeito ingênuo de lidar com isso é manualmente dividir os dados. Por exemplo, posso fazer um servidor com dados da região Sudeste, outro servidor só pra região Sul, outro só pra região Nordeste e assim por diante.








Problema que um servidor vai continuar tendo mais volume de dados que outros. Não vai ser balanceado. Rapidamente o da região Sudeste vai precisar dividir. Daí teríamos que fazer um servidor só pra São Paulo separado. Mas mesmo assim, o volume só de São Paulo sempre vai ser muito maior que tudo, vamos dividir pelo menos a cidade de São Paulo num único servidor sozinho. Tá vendo o trampo? Ficar tentando dividir os dados assim manualmente vai ser um parto. Pior ainda pro software. Teríamos que fazer algo como "if sao paulo, procura no servidor X", ou "if regiao nordeste, procura no servidor Y". Isso rapidamente fica caótico.








Existe uma solução melhor. Antes, vamos ver um outro jeito ingênuo de balanceamento. Alguém poderia pensar "hum, e se não olharmos pros dados, esquece isso de região ou estado, vamos olhar só pro ID". Nesse caso digamos que os IDs são numéricos e sequenciais, exatamente como eu disse pra não fazer. Daí temos 3 servidores que vamos chamar de A, B e C e 12 itens na tabela, com ID de 1 a 12, pra simplificar. Como eu divido esses 12 itens entre os 3 servidores?







Fácil, que tal usarmos o módulo do ID? Lembra a idéia de módulo? No caso faríamos módulo 3. Módulo é quando você pega o restante da divisão de um número por outro. Por exemplo. 1 módulo de 3 seria 1, 2 módulo de 3 seria 2, 3 módulo de 3 é 0, por que 3 dividido por 3 dá um e sobra zero. Interessante é acima disso. 4 dividido por 3 é 1 e sobra 1, então o módulo é 1. 






5 dividido por 3 é 1 e sobra 2, então o módulo é 2, mas 6 dividido por 3 é exato 2 e sobra zero, o módulo é zero. Qualquer número módulo 3 vai ser um número de 0 a 2. Sempre vai rotacionando. Estabelecendo arbitrariamente que o servidor A é zero, B é 1 e C é 2, sabemos como dividir cada uma das 12 linhas em cada um dos 3 servidores, sacaram?






Então no servidor A teremos os itens com IDs, 1, 4, 7 e 10. No servidor B teremos os itens com IDs 2, 5, 8 e 11 e no servidor C teremos os itens com IDs 3, 6, 9 e 12, todos os múltiplos de 3. E toda vez que quisermos inserir uma nova linha, fazemos o módulo do ID e vemos pra qual servidor mandar. Isso garante que todos  vão estar balanceados, ou seja, todos vão ter exatamente o mesmo número de linhas. Resolvido então?







Mas é a Receita Federal, eles crescem infinitamente. Muito em breve só 3 servidores não vai dar conta. Precisamos adicionar mais um novo servidor. Agora fodeu. A conta passa de módulo 3 pra módulo 4. Ou seja, precisamos rebalancear todos os dados em todos os servidores. Na nova configuração, cada ID vai ficar num servidor diferente do que tava antes. Essa estratégia funciona pra balancear se nunca mexermos na quantidade de servidores, mas  não escala se precisarmos adicionar novos, porque precisa mover todos os dados de lugar pra rebalancear.








Por isso foi inventado o algoritmo de Consistent Hashing em computação distribuída. É um esquema de organização de IDs que permite adicionar ou remover servidores sem precisar mover todos os dados de lugar toda vez. Ele consegue isso organizando todos os IDs num anel, um círculo de hashes. Pra entender hashes recomendo que assistam o primeiro episódio de criptografia. 







Em resumo bem resumido, hash é uma função que pega qualquer informação, por exemplo uma string, e devolve um número de tamanho fixo. Mas é uma função não reversível, ou seja, a partir do número não tem como encontrar a string original, porque diversas strings podem chegar no mesmo número. A função só garante que se você passar a mesma string, vai chegar no mesmo número.








Dependendo da função ela devolve um número até um determinado tamanho, por exemplo, um SHA512, vai devolver um número de até 512 bits. O número máximo de 512 bits é um absurdo maior que a quantidade de átomos no universo visível. Obviamente é exagerado demais pra um campo de ID. Um Cassandra usa outra função de hash não criptográfico, ou seja, que não deve ser usado pra criptografia, mas é bom o suficiente pra IDs, o Murmur3 que devolve hashes de 64 bits, onde o maior número é da ordem de milhões de trilhões, que ainda é um número gigante, mas mais gerenciável.








Enfim, o principal é que no sistema de consistent hashing consideramos um anel que vai de 0 até esse número máximo de 64 bits. Daí fazemos o hash dos IDs dos servidores. Digamos que temos 4 servidores. Eles se distribuem pelo anel. O lance de uma função de hash é que ela tende a ter uma distribuição uniforme, o oposto de sequencial. Podemos gerar o hash dos dados do registro, com a combinação de diversos dados como o endereço IP do usuário mais o horário, ou qualquer coisa assim.







Por exemplo, imagine um anel onde cada ponto desse anel começa em 0 no topo e tem todos os números até 2 elevado a 64, no final do anel, encostado no zero, pra dar uma volta. Entenderam, todos os IDs possíveis estão no anel. Daí aplicamos a função de hash pros nomes ou endereços IP de cada servidor, e aí eles caem arbitrariamente pelo anel, só pro exemplo, o servidor A lá em cima, depois o B mais pra direita lá embaixo e o C mais pra esquerda embaixo.






Vamos inserir alguns dados, digamos que é o hash do nome do registro. O primeiro registro tem o nome de John e digamos que o hash gerado caia entre o Nó A e o Nó B. A regra é pra ele escolher o servidor com o hash maior ou igual ao do ID olhando na direção de relógio, da esquerda pra direita. Nesse caso vai ser o Nó B. O próximo registro tem nome de Fred e o hash por acaso tem ponto aqui entre o B e o C, então ele cai no Nó C. E o último registro com nome de Susan cai aqui entre o C e o A, então vai no A. Sempre na direção de relógio.









Beleza e qual a vantagem disso? Bom, vamos voltar pro cenário onde queremos adicionar um novo servidor, o nó D e o hash dele vai aqui entre o C e o A, por acaso. Mas ele cai depois da Susan. O que acontece é que todos os dados com IDs depois do C que estavam caindo no Nó A, agora precisam ser movidos pro Nó D. É assim que rebalanceia. Mas prestem atenção, no exemplo de usar a função simples de módulo, precisaria mover todos os dados de todos os servidores quase. Aqui, os dados dos servidores B e C não precisam ser mexidos, só os do A que precisam ser divididos. Os registros com IDs maiores que D e menores que A, continuam no A.









Digamos que o servidor A tenha uma pane qualquer e precise ser removido. E agora? Todo registro que antes cairia no A, pela regra de olhar o próximo servidor em sentido de relógio no anel, então vai passar a cair no B. Só isso. E nenhum dado de nenhum outro servidor precisa ser mexido. Falando simplificadamente é assim que garantimos ter a menor quantidade possível de dados sendo movidos quando a infraestrutura muda. A idéia é mover a menor quantidade de dados quanto possível quando precisamos adicionar novos servidores. 







Tem várias nuances nessa estratégia. Por exemplo, quando da remoção de um Nó, pode acontecer de outro Nó acabar acumulando dados demais. Pra evitar isso, cada Nó pode ter múltiplos hashes aleatórios que o colocariam em múltiplas posições no anel, daí os dados poderiam ser melhor rebalanceados. Se ficou interessado, depois leia a documentação a respeito em sites como do Cassandra ou no paper do DynamoDB da Amazon.







Dizendo assim parece fácil, mas em DynamoDB por exemplo, você tem que entender o conceito de chave de partição e chave opcional de ordenamento. Dados com a mesma chave de partição caem na mesma partição, obviamente. O problema é se quisermos fazer uma pesquisa que precisaria buscar dados em múltiplas partições. Pra isso tem comandos com o "Scan", mas isso é uma operação bem mais custosa do que pesquisar dentro de uma mesma partição. 







Portanto a estratégia de partição precisa estar muito bem definida no começo, senão vai ter obstáculos de não conseguir fazer pesquisas rápidas quando precisar. As coisas não são automáticas, trocamos conveniência por performance. Num banco relacional, onde normalmente fica tudo junto, é só rodar um comando SQL e temos o que queremos rápido. Num sistema distribuído as coisas estão, duh, distribuídas, e precisamos levar isso em consideração.







No DynamoDB, que é oferecido com um serviço da AWS, precisamos entender bem o comportamento da nossa aplicação, não só pra não dificultar operações depois, mas porque a cobrança também não é simples. Não se paga por gigabyte armazenado, por exemplo. Precisa calcular a quantidade de escritas por segundo. A quantidade de escritas por segundo durante um pico. A duração de cada operação de leitura, porcentagem de capacidade de leitura que quer deixar reservado, o nível de consistência das leituras, quantas quer que sejam fortemente consistemente, quantas fracamente consistentes.







Por exemplo, na calculadora online deles, o preço por gigabyte, na região US east, é de meros 25 centavos por mês. Sucesso então? Não, com 10 escritas não transacionais, 100 escritas por segundo em horário fora de pico, 400 escritas por segundo em horário de pico, 72 horas operando em pico durante o mês, com capacidade reservada de escrita pra um ano, pode somar mais 23 dólares por mês e 150 dólares que precisa pagar a vista logo no começo pra reserva. 






Daí continuando com os valores padrão pra leitura, só pra não entediar, mais 3 dólares por mês e mais 30 dólares upfront à vista. Então, por mês nessa configuração vai pagar uns 26 dólares, mais 180 dólares à vista na entrada. E essa configuração é a mais basiquinha, pra um app pequeno.






Na categoria de bancos de dados NoSQL oferecidos como serviço, ou seja, que não precisamos saber como configurar e dar manutenção na infraestrutura, tem diversas outras opções, como MongoDB Atlas ou Google Firebase. Firebase é bem popular pra aplicações pequenas, porque até 1 gigabyte de mensagens, até 1 gigabyte de armazenamento, 5 gigabytes de cloud storage, o custo é gratuito. Já um MongoDB Atlas você paga até que "barato" a 10 centavos por milhão de operações de leitura, ou o recomendado 57 dólares por mês pra solução dedicada de 10 giga até 4 terabytes de armazenamento.







Não é simples calcular o real valor que vai pagar, tem dezenas de parâmetros pra considerar, como quantidade de invocação de funções e gigabytes por segundo ou minutos de cloud build ou gigabytes transferidos pela rede e mais. O preço vai variar de acordo com o sucesso ou fracasso da sua aplicação. Quanto mais "barato" ficar, mais fracassado é seu app, quanto mais sucesso fizer, mais caro vai ficar. No começo parece uma grande vantagem, mas justo quando fizer sucesso e achar que vai ganhar bastante, é também quando eles vão te cobrar mais caro. Essa é a faca de dois gumes de serviços que você não gerencia. Uma hora a conta chega.







Isso sem contar o custo do desenvolvimento e manutenção da sua aplicação. Quanto mais exótico for um banco de dados, mais difícil vai ser encontrar profissionais qualificados ou treinar em casa. Só porque um banco é exótico, não significa que resolve seus problemas. Em muitos casos, alguém pode escolher o Google Firebase pelo hype mas na realidade o desenvolvimento teria ficado mais barato se tivesse escolhido, digamos um MongoDB Atlas.






Ambos Firebase e MongoDB tem a flexibilidade de lidar com documentos estilo JSON, sem precisar se prender à estrutura mais rígida de um schema de banco de dados relacional. Mas só dizer JSON não significa que são iguais. MongoDB permite lidar com documentos mais complexos, embedded arrays, sub-documentos. O modelo do Firebase é bem mais simples.






Mas o Firebase tem atualizações em tempo real, que é importante pra quem desenvolve aplicações mobile. Mudanças no banco podem ser empurradas como notificações direto pros usuários em tempo real. MongoDB não tem isso nativo. Dá pra colocar mas dá mais trabalho, portanto é mais custo de desenvolvimento.






Por outro lado, se quisermos fazer pesquisas mais complexas, MongoDB tem uma linguagem de queries mais avançada, incluindo coisas como joins e índices secundários. Firebase tem capacidades de query, mas limitadas. Da mesma forma, transações. Todo mundo foge de banco relacional, mas todos adoram ter transações e dados fortemente consistentes. MongoDB tem mais suporte a transações do que Firebase. De novo, se quiser algo semelhante a transações no Firebase, o custo de desenvolvimento sobe. E se transações é realmente importante, talvez um banco relacional como AWS RDS tivesse sido melhor, em primeiro lugar.








Mas a vantagem de serem "as a service" quer dizer que tanto MongoDB Atlas quanto o Filestore do Firebase tem escalabilidade e replicação automáticas em múltiplas regiões pra alta disponibilidade. Ou seja, se throughput de operações e garantir que nunca fique fora do ar seja primordial, ambos podem ajudar com isso. Mas você vai pagar por isso, e não vai ser barato. Como expliquei, o modelo de precificação é complexo. Precisa seriamente gastar tempo pesquisando e avaliando muito bem o que acontece não só agora, que sua aplicação tá no começo, mas daqui seis meses se fizer sucesso.








Não tem como eu explicar todos os bancos de dados oferecidos como serviços hoje. A Amazon é a mais famosa. Todo mundo escolhe o AWS RDS pra soluções de MySQL ou Postgres como serviço, mas o Google também tem o Cloud SQL como concorrente. Vai depende de precificação e funcionalidades que pra você podem ser importantes. Além deles tem o Azure SQL Database e acho que até a Oracle oferece o banco de dados SQL deles como serviço.







Pra complicar a vida, a própria Amazon oferece produtos similares na mesma plataforma, como o Apache Aurora que parece com RDS. Aurora é um produto superior de banco de dados MariaDB, Postgres, SQL Server, Oracle, tem maior garantia de disponibilidade, dobro da performance no mesmo perfil de hardware, mais facilidade de escalabilidade, opções de backup, replicação, porém, obviamente custa mais caro. Ou seja, tem SQL pra todos as necessidades e capacidade de pagamento.







Digamos que você é um apologista de NoSQL, não quer mesmo SQL. Daí tem o MongoDB Atlas e Google Firestore que já falei, mas temos mais opções. Pro mundo enterprise, a SAP oferece o HEC que é o HANA Enterprise Cloud. Tem a ScyllaDB que oferece uma versão de Cassandra deles e tem o AstraDB da DataStax que também é Cassandra como serviço. Isso sem contar o Heroku que oferece Postgres como serviço, Redis como serviço. E em termos de cache, Memcache e Redis, a AWS tem o Elasticache como já falei. Tem serviços pra todo mundo, é só conseguir pagar.








Mas, pra você que é iniciante em programação, não se deixe enganar por hype de NoSQL. A gente vem discutindo esse assunto desde pelo menos 2008. E eu posso te garantir algumas coisas: não existe consenso, pelo simples fato que cada banco de dados tem pontos fortes e pontos fracos, cada um serve pra situações diferentes. Pra aplicações bem pequenas, meio que tanto faz se vai escolher um banco relacional SQL como um MariaDB ou Postgres ou se vai direto pra um FireStore da vida. Você tem poucos dados, tem poucos problemas pra lidar. 








A primeira versão de qualquer coisa que fizer sempre vai ser isso: versão 1.0. Só quando tiver usuários de verdade, dados de verdade, receita e faturamento de verdade, só aí vai realmente entender o que precisa. E se ficar limitado a usar só uma ferramenta pra tudo, em breve vai ter tanto problema, e vai ignorar que existem já soluções pra cada problema, que corre o risco de fracassar por ignorância. 







Na dúvida, a solução mais comum é a mesma: AWS RDS com Postgres ou MariaDB, que é o que a grande maioria dos frameworks web usam, como Ruby on Rails. Django, Laravel, Spring. Daí uma solução de cache usando Redis ou Memcache, e pra isso tem AWS ElastiCache. E finalmente jobs assíncronos, seja com Kafka, seja com AWS SQS. Isso resolve 90% dos seus problemas. Se precisar de alguma coisa de documentos schemaless em JSON, um Postgres já suporta isso nativamente. Quer só fazer um protótipo, vai de Firebase.







Se por acaso estiver na rara categoria de Big Data, significa que você não é uma micro empresa, ou um freelancer. Já é uma empresa média. Aí é outra categoria, já vai olhar pra Aurora, DataStax, e soluções pra Data Science como Apache Spark, Hadoop e muita coisa customizada. Vai ter profissionais experientes de infraestrutura de devops. Essa categoria não é pra amadores. Por isso, se for iniciante, não se preocupe com isso tão cedo. Você não é o Netflix.







No fim do dia, entender bancos de dados, sejam relacionais, sejam NoSQL, significa entender o problema que se quer resolver primeiro. Daí aplicar fundamentos de ciências da computação. Árvores, estruturas de dados, redes, sistemas de arquivos, sistemas operacionais, fundamentos de criptografia. Ficar acompanhando discussões inúteis em fios de Twitter da bolha dev, só vai te confundir, nunca tem nada de útil e você vai ser mais um maria-vai-com-as-outras. Se atenha a pesquisar documentação oficial de cada coisa.






A grande maioria dos programadores iniciantes hoje tem o mesmo problema de ignorar fundamentos, ignorar os problemas que se quer resolver, e escolher baseado em likes. Influencer nenhum sabe o seu cenário particular. Óbvio que vai dar ruim. Se ficaram com dúvidas mandem nos comentários abaixo, se curtiram o video deixem um joinha, assinem o canal, e não deixem de compartilhar o video com seus amigos. A gente se vê, até mais.
