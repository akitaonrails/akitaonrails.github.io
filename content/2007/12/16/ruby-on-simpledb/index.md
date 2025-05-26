---
title: Ruby on SimpleDB
date: '2007-12-16T10:06:00-02:00'
slug: ruby-on-simpledb
tags:
- nosql
- insight
- biography
draft: false
---

Bancos de Dados não relacionais é um tema alienígena à grande maioria dos web developers. Na realidade a maioria dos programadores sequer sabe que, o que eles chamam de “banco de dados”, é na realidade um “banco de dados relacional”, ou [RDBMS](http://en.wikipedia.org/wiki/Relational_database_management_system).

A Amazon recentemente anunciou seu novo serviço [SimpleDB](http://www.amazon.com/b/ref=sc_fe_c_1_3435361_1?ie=UTF8&node=342335011&no=3435361&me=A36L942TSJ2AJA) ou seu _database in the cloud_. Ele trabalhará em conjunto com o serviço de storage S3 para prover armazenamento e administração de um **banco de dados orientado a documentos** manipulada através de APIs SOAP. Veja, o SimpleDB não é relacional, não tem schema, portanto não é orientado a colunas.

[Chad Fowler](http://www.chadfowler.com/2007/12/16/open-source-competition) acabou de reportar que ele procurou no [RubyForge](http://rubyforge.org/) se alguém por acaso já não teria criado algum wrapper para as APIs do SimpleDB e, de fato, elas já existem. Temos os projetos [aws-simpledb](http://rubyforge.org/projects/aws-simpledb/), o [aws-sdb](http://rubyforge.org/projects/aws-sdb/) e o [simpledb](http://rubyforge.org/projects/simpledb/). E quem quiser estudar em detalhes o funcionamento das APIs do SimpleDB, deve ver a [documentação](http://docs.amazonwebservices.com/AmazonSimpleDB/2007-11-07/GettingStartedGuide/)? da própria Amazon.


### CouchDB

Esse conceito não é novo, os interessados devem conhecer o [CouchDB](http://www.couchdbwiki.com). Essencialmente os conceitos são os mesmos. Coincidentemente ambos foram escritos em [Erlang](http://www.erlang.org/faq/t1.html), claro por causa das características de paralelismo inerentes a essa linguagem.

Não sei quanto ao CouchDB mas o SimpleDB é baseado no framework [MapReduce](http://en.wikipedia.org/wiki/MapReduce) do Google, para suportar processamentos absurdamente paralelos de dados em clusters não-confiáveis.

Segundo este [site](http://www.automatthew.com/2007/12/amazon-simpledb-and-couchdb-compared.html), estas são as características em comum das duas:

- Bancos de dados não relacionais
- Sem schema
- Suporte a replicação de dados
- acessados via HTTP

E agora, onde eles diferem:

| SimpleDB | CouchDB |
| APIs em SOAP e um pseudo-REST | REST |
| chamadas REST usam apenas GET com parâmetros | chamadas REST usam os verbos GET, POST, PUT, DELETE com as semânticas corretas |
| chamadas especificam o banco de dados, registros, atributos, modificadores com parâmetros de query | chamadas especificam o banco de dados e o registro via URL, com parâmetros de query para modificadores |
| criação, atualização e deleção são atômicas ao nível individual de atributos | criação, atualização e deleção são atômicas |
| todos os dados são considerados strings UTF-8 | suporta todos os tipos de dados JSON (string, number, object, array, true, false, null) |
| automaticamente indexa dados | índices estão no controle do usuário, por ‘views’, definidas com funções Javascript, podem ser armazenadas como documentos, podem ser executadas a qualquer momento, como views temporárias |
| queries são limitadas a 5 segundos, com timeout, definidas com parâmetros de query HTTP, compostas de booleanos e conjuntos de operações com alguns operadores óbvios (=, !=, \>, etc) | queries são essencialmente views, com a adição de modificadores (start\_key, end\_key, count, descending) fornecidas como parâmetros de query HTTP |
| como os valores são string UTF-8, não há opções de ordenação | ordenação é flexível e arbitrariamente complexa, já que é baseada em tipos de dados JSON definidas nas views |
| respostas são em XML | respostas são em JSON |

Se quiser pesquisar um sistema parecido com o serviço SimpleDB, o CouchDB é uma excelente opção. E ela tem bindings para diversas linguagens, incluindo nosso Ruby, através do [CouchDb-Ruby](http://www.couchdbwiki.com/index.php?title=Getting_Started_with_Ruby).

Copiando o exemplo do seu Wiki, eis como se criaria um banco de dados no CouchDb:

* * *
ruby

server = Couch::Server.new(“localhost”, “5984”)  
server.put(“/foo/”, "")  
-

Eis como se criaria um documento:

* * *
ruby

server = Couch::Server.new(“localhost”, “5984”)  
doc = \<\<-JSON  
{"type":“comment”,“body”:“First Post!”}  
JSON  
server.put(“/foo/document\_id”, doc)  
-

E finalmente, como se busca um documento:

* * *
ruby

server = Couch::Server.new(“localhost”, “5984”)  
res = server.get(“/foo/document\_id”)  
xml = res.body  
-

Rails utiliza ActiveRecord, mas podemos facilmente substituir o ActiveRecord da mesma forma como já fazemos com ActiveResource, portanto [não vejo](http://groups.google.com/group/couchdb/browse_thread/thread/e1eac1af681baae3) porque não poderíamos ter algumas aplicações usando CouchDB ou SimpleDB como back-end. Alguém se habilita? :-)

### Divagando pela História

Esse assunto me interessa porque diferente da geração atual mais jovem de programadores, eu comecei com banco de dados não relacionais há quase **20 anos**. Conheci programadores que lidaram com o supra-sumo dos bancos de dados. Se você perguntar a qualquer jovem programador quais os melhores bancos de dados do mundo ele dirá: Oracle – e se for um xiita open source, talvez PostgreSQL. Não que esse bancos não sejam bons, pelo contrário. Porém, ainda são bebês na infância se compararmos com os bancos de dados realmente robustos que rodam há **40 anos** ininterruptos como o [IMS](http://en.wikipedia.org/wiki/Information_Management_System) da IBM. Todo mundo já ouviu falar de COBOL, mas eis o back end com o qual ele lida: um banco de dados hierárquico não-relacional (e não vamos esquecer do [CICS](http://en.wikipedia.org/wiki/CICS), claro, mas gerenciadores transacionais são outro assunto, e o único com que trabalhei foi o [Tuxedo](http://en.wikipedia.org/wiki/Tuxedo_(software))).

Tenho um grande amigo, ex-IBM, que lidou diretamente com esse tipo de sistema. Ele não vê graça nenhuma no que nós fazemos hoje. O que sempre me dizia: _nós já fazíamos essas coisas 20 ou 30 anos atrás._ Quer dizer, não sei porque tanta empolgação em conceitos que já são tão velhos. Muita gente não sabe, mas a IBM dos anos 60 e 70 criou basicamente tudo que conhecemos hoje como “tecnologia moderna”: sistemas distribuídos, sistemas operacionais com compartilhamento de tempo, gerenciadores transacionais, bancos de dados hierárquicos, bancos de dados relacionais, e-mail, etc.

Inovação **científica** (não trivialidades de consumo) necessariamente vem de laboratórios bem estabelecidos e financeiramente fortes. IBM, AT&T, Bell Labs, universidades como Berkeley, MIT, vêm à mente. Basicamente a computação moderna saiu desses institutos.

Também conheci muitos consultores de outras tecnologias que ainda existem e se alguém trabalhar em algum grande banco, ou agências governamentais, talvez ainda encontre o bom e velho banco de dados [Adabas](http://en.wikipedia.org/wiki/Adabas). Ele provavelmente foi o primeiro banco de dados comercial, criado em 1970. Mas o nome mais conhecido é a linguagem para manipular seus dados, o [NATURAL](http://en.wikipedia.org/wiki/NATURAL). Já recebi algumas propostas de Natural alguns anos atrás. Esse produto é da Software AG, empresa alemã que fornecia o banco para ninguém menos que a SAP AG (se não me engano, as duas empresas ficavam em lados opostos da mesma rua). Então, a SAP adquiriu o Adabas, rebatizando-o de SAP DB. Até que recentemente esse banco se tornou o [MaxDB](https://www.sdn.sap.com/irj/sdn/maxdb), que hoje faz parte da família [MySQL](http://www.mysql.com/sap/), e este nome sim, garanto que os jovens de hoje reconhecem.

Outra plataforma que poucos ouvem falar mas vira e mexe eu vejo ou recebo proposta de trabalho: o banco de dados orientado a objetos [Caché](http://en.wikipedia.org/wiki/Caché_%28software%29). Sua principal características: dizem que é o banco mais rápido do mundo (até agora), com seu sistema de estruturas de dados hierárquico em arrays multidimensionais. Nunca notei se havia um nicho de mercado que prefere Caché, mas a [InterSystem](http://www.intersystems.com) tem outro produto construído sobre o Caché chamado Ensemble. Recentemente participei de um projeto que substitui o Ensemble de uma grande telecom para SAP.

Num outro nicho, o mercado de saúde, hospitais, além do Ensemble outro produto que fazia sucesso na sua época foi o bom o velho [MUMPS](http://en.wikipedia.org/wiki/MUMPS). Conheci um consultor de MUMPS uma vez que migrou para SAP. Pensem assim: MUMPS veio **ANTES** de C, portanto, diferente das linguagens imperativas atuais, ele não é inspirado em C. A sintaxe parece meio alienígena mas é interessante dar uma olhada.

Meu primeiro ‘banco de dados’, obviamente, foi em Basic. Claro, o mais rudimentar de todos os bancos: uma estrutura de dados de tamanho fixo, um arquivo binário, e navegaçao baseada em offset a partir do tamanho da estrutura, mais um pequeno índice para navegar mais rapidamente. Com 11 ou 12 anos, não se pode exigir mais do que isso. E eu não tinha acesso a grandes mainframes, claro, então IMS era algo que eu só ouviria falar anos depois.

Mas rapidamente migrei para [dBase](http://en.wikipedia.org/wiki/DBASE) III, da [Ashton\_Tate](http://en.wikipedia.org/wiki/Ashton-Tate). O pessoal que desenvolveu o dBase, da [Jet Propulsion Labs](http://en.wikipedia.org/wiki/Jet_Propulsion_Laboratory) (NASA) fez por brincadeira, para rodar sobre CP/M e depois vendeu para a Ashton-Tate. Para quem não se lembra, o antigo MS-DOS é um clone (mal-feito, claro) de CP/M. Naquela época tínhamos vários clones, como PC-DOS e DR-DOS. Coisas que gostava dessa época: eu não tinha nem idéia do que eram estrutura relacional, nem estrutura hierárquica. Para mim haviam apenas tabelas (DBF) e índices (NDX, IDX). Sabia existia redes locais, token ring, compartilhamento de arquivos via Netware, IPX/SPX e que DBFs tinham locks baseadas em tabela para que várias pessoas pudessem utilizar _quase_ ao mesmo tempo. Também, sabia que essas estrutura tendiam a se corromper com extrema facilidade e me perguntava como elas conseguiam funcionar :-)

Rapidamente migrei para Clipper Autumn 86 (que estava no fim e eu lembro que tinha sérias limitações de memória no linkeditor, o limite de 500kb) e para o Clipper Summer 87, da Nantucket. O [Clipper](http://en.wikipedia.org/wiki/Clipper_programming_language) começou como um compilador de dBase III. Fiz muitos sisteminhas em Clipper e no começo dos anos 90 migrei para [FoxPro](http://www.foxprohistory.org/tableofcontents.htm#how_it_started). Nessa época esse mercado ficou meio conturbado, a Ashton-Tate foi adquirida pela Borland, a Nantucket foi absorvida pela Computer Associates e a Fox foi para as asas da Microsoft. O Windows ainda estava apenas começando a se popularizar, todas elas lançaram algum produto gráfico, como o Visual dBase, CA-Visual Objects e o Visual FoxPro, respectivamente.

Foi quando comecei a largar o mercado baseado em derivados de dBase e foi para Pascal e Delphi. Mas isso é outra história ;-)

