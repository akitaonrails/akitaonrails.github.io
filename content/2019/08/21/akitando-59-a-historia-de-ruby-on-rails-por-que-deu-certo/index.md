---
title: "[Akitando] #59 - A História de Ruby on Rails | Por que deu certo?"
date: '2019-08-21T17:00:00-03:00'
slug: akitando-59-a-historia-de-ruby-on-rails-por-que-deu-certo
tags:
- ruby
- ruby on rails
- rubyconf
- railsconf
- dhh
- ruby central
- why the lucky stiff
- smalltalk
- agile
- apple
- akitando
draft: false
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/oEorhw5r2Do" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


15 anos atrás Ruby on Rails é lançado, e todo mundo tinha certeza que logo desapareceria.

Ruby on Rails 6.0 acabou de ser lançado.

Why, The Lucky Stiff sumiu faz 10 anos.

Estou iniciando o 2o ano do meu canal e acho que agora é uma boa hora para contar essa história.

Esta é a história que eu queria ter contado logo que comecei o canal, 1 ano atrás. Mas eu precisava explicar muitas outras histórias antes para dar contexto. Minha própria carreira inicial. A história da computação e da Web nos anos 90 a 2000. Conceitos como Agilidade e Startups.

Agora que contei boa parte do que queria, se vocês assistiram os vídeos do último ano, devem estar equipados pra entender esta parte da história. Neste episódio vou compilar 8 anos de história, de onde veio Ruby on Rails, e porque ele estava destinado a dar certo mesmo que todos os "experts" achassem que não daria.


Se quiser aprender mais, entre no grupo de Rails do Facebook: https://www.facebook.com/groups/rubyonrailsbrasil/

É o maior e melhor grupo que eu conheço e eles estão sempre compartilhando dicas, materiais e cursos, fora ofertas de emprego.


Disclaimer: 

Esta história é contada sob meu ponto de vista pessoal tendo participado ativamente de muitos eventos. Posso ter esquecido alguns momentos e nomes importantes, então mande nos comentários se eu perdi alguma coisa.

Logo de cara, só depois que terminei de subir o video notei que esqueci de mencionar o pessoal do Rio Grande do Sul, do antigo Mailee e que fez o Catarse, o Kickstarter brasileiro!! Perdoem-me por ter esquecido.


Links:

* 15 Minute Blog Demo 2005 (https://www.youtube.com/watch?v=Gzj723LkRJY)
* Ten Years Of Test Driven Development (http://wiki.c2.com/?TenYearsOfTestDrivenDevelopment)
* The history of testing framework in Ruby (http://rubykaigi.org/2015/presentations/kou/)
* Why’s Poignant Guide to Ruby (https://poignant.guide)
* Why The Lucky Stiff Documentary (https://www.youtube.com/watch?v=64anPPVUw5U)
* Ruby Koans (http://rubykoans.com)
* Ruby Quiz (http://rubyquiz.com)
* RailsCasts (http://railscasts.com)
* RubyTapas (www.rubytapas.com/)
* CodeSchool: Rails for Zombies (https://www.pluralsight.com/courses/code-school-rails-for-zombies)
* Blog Igvita (https://www.igvita.com)
* Rails and Merb Merge (https://yehudakatz.com/2008/12/23/rails-and-merb-merge/)
* RailsEnvy videos (https://www.youtube.com/watch?v=YZeZsZEEpno&list=PLfBoZfyUGYQZ--h9B4e_tmyob8tbqOTKd)
* The Decision to Leave Code School (https://www.greggpollack.com/the-decision-to-leave-code-school/)
* Travis CI joins the Idera family (https://blog.travis-ci.com/2019-01-23-travis-ci-joins-idera-inc)
* Reia (https://github.com/tarcieri/reia)
* 11 types of apps you can build with Ruby on Rails (https://naturaily.com/blog/ruby-on-rails-apps)
* Who gives a F*** about Rails in 2019? (https://naturaily.com/blog/who-gives-f-about-rails?utm_source=linkedin&utm_medium=post)
* Why should you choose Ruby on Rails for your MVP? (https://prograils.com/posts/why-should-you-choose-ruby-on-rails-for-your-mvp?utm_source=rubydaily&utm_medium=referral&utm_campaign=rails-mvp-1)

* AkitaOnRails: Retrospectiva on Rails - 10 Anos e Muito Mais! (http://www.akitaonrails.com/2014/08/26/retrospectiva-on-rails-10-anos-e-muito-mais)
* AkitaOnRails: Entrevistas (https://www.akitaonrails.com/interview)
* AkitaOnRails: _Why, Ruby Dramas, and Dynamiting Courtlandt (http://www.akitaonrails.com/2016/09/26/the-next-10-years)
* AkitaOnRails: The Next 10 Years (http://www.akitaonrails.com/2016/09/26/the-next-10-years)


R.I.P.:

* Remembering Jason Seifer (https://www.greggpollack.com/remembering-jason-seifer/)
* EZRA ZYGMUNTOWICZ: IN MEMORIAM (https://www.engineyard.com/blog/ezra-zygmuntowicz-in-memorium)
* REMEMBERING JIM WEIRICH (https://lithespeed.com/remembering-jim-weirich/)
* Remembering James Golick (https://medium.com/@benkaufman/remembering-james-golick-23c1dc3ab920)
* GIVING OPEN-SOURCE PROJECTS LIFE AFTER A DEVELOPER'S DEATH (https://www.wired.com/story/giving-open-source-projects-life-after-a-developers-death/)

=== Script


Olá pessoal, Fabio Akita

Finalmente! Finalmente, decidi fazer um episódio sobre Ruby on Rails. Muita gente que me conhece nas interwebs como AkitaOnRails começou a me acompanhar quando eu comecei a evangelizar Rails mais de 12 anos atrás. Quando comecei o canal talvez muitos pensariam que a coisa mais óbvia é que eu ia continuar falando de Rails, mas até hoje ainda não fiz nenhum video a respeito. Esse é o episódio que eu queria ter feito 1 ano atrás mas que precisei publicar 58 vídeos antes pra dar o contexto. Exagerando um pouco eu diria que todos os videos que eu fiz até agora foram um prólogo pra esse. Também é apropriado que estou oficialmente iniciando o 2o ano do canal exatamente com esse tema. Quem acompanha o canal já me viu mencionando alguns eventos históricos de Ruby on Rails como nesse episódio da série Começando aos 40 (episodio 1 de backend)



Se alguém me perguntar hoje: é essencial usar Rails? Honestamente não, embora eu diria que você se daria melhor usando Rails, sem dúvida. Em 2019 temos muitas outras opções se, e somente se, você souber o que está fazendo. Eu ainda considero Rails o melhor framework de ponta a ponta e o melhor ecossistema pra maioria dos casos, o pacote completo. Os princípios e fundamentos que tornaram Rails especial em 2004 continuam valendo hoje. Mesmo que você não use Ruby, você provavelmente está "On Rails" e não sabe disso. A história do Rails é um caso único e eu não vejo ele se repetindo de novo tão cedo.



A idéia do video de hoje não é ser a história totalmente completa, mas sim a história pelo meu ponto de vista enquanto personagem nessa história, então vai ter alguns eventos talvez importantes que eu talvez pule. Enquanto escrevia eu via as páginas aumentando, 10 páginas, 20 páginas, 30 … e resolvi que não vou cortar em múltiplos video, pra variar. Vai tudo numa tacada só (... respira …), então vão pegar a pipoca, a água, vão no banheiro antes, e senta aí que lá vem história.




(...)




Como é o jeito "certo" de desenvolver um software médio web hoje em dia? Simples, começa criando um novo projeto no GitHub ou GitLab. 
Daí roda o generator do seu framework pra criar o esqueleto. Faz o primeiro commit e dá push pro repositório e agora abre acesso pros seus colegas de trabalho. 
Vamos organizar o trabalho da equipe num backlog e cada um vai fazendo uma pequena feature. Cada feature você abre um novo Pull Request ou Merge Request, dependendo se for GitHub ou GitLab. 




Agora vamos criar os specs e fazer o código pra passar. Ou se você não é adepto de test-first development ou TDD como Eu também não sou sempre, pode ser o bom e velho test-after, importante é subir seu código com um mínimo de testes. Alguém insistiu em tentar subir código sem testes? git reset --hard nele!
Junta os commits dos testes, do seu código, manda pro branch do pull request. Finalizou? Pede pros colegas darem aquela revisada marota. 
Agora que tem algum código já seria bom automatizar a execução dos testes, então vamos configurar um Travis-CI ou Circle-CI ou o CI integrado do próprio GitLab.




Agora a gente vai subindo novos códigos, vendo os testes de todo mundo da equipe rodando e passando. E depois de alguns pull requests mergeados, temos uma primeira versão que já dá pra pro usuário brincar. Hora de subir num ambiente de staging pra mandar pros usuários testarem. Então bora criar um projeto no Heroku, definir os recursos extras como banco de dados que vamos precisar e git push heroku.



Sucesso! Aplicativo funcionando! E pra facilitar a vida, vamos criar um continuous deployment ligado ao CI pra toda vez que subir código novo e os testes passarem, ele já subir a versão nova pro ar. Ou então pra cada pull request ainda não aprovado subir um ambiente de testes no Heroku em paralelo também. Assim a vida dos testers e QA vai ficar mais fácil.




Além disso podemos conectar serviços como CodeClimate pra constantemente avaliar a saúde do nosso código, ver se não estamos acumulando muito débito técnico. Avaliar se não estamos deixando de atualizar bibliotecas com bugs de segurança. 
Se quisermos adicionar recursos mais avançados como WebSockets, pra criar um chat ou fazer push notifications, devemos usar serviços como o bom e velho Pusher. Pra maioria de nós não é necessário usar Node.js ou Go ou algo assim. E podemos habilitar o New Relic RPM no Heroku pra monitorar o uso da nossa aplicação e avaliar possíveis gargalos que precisamos ir otimizando. Ah, é bom viver nessa era de Software as a Service.




Tudo isso que eu acabei de explicar em 2 minutos é o dia a dia de qualquer projeto web comum, ou pelo menos deveria ser caso você ainda esteja numa empresa que não segue esse tipo de fluxo de trabalho. Eu diria que mesmo quem não segue, sente uma certa inveja e gostaria de estar trabalhando assim. Porém lembre-se do que eu venho falando em todos os meus vídeos: essa é uma realidade hoje pra muitos, em 2019. Isso não era verdade em 2004. E esta é a história de como a comunidade Ruby on Rails criou essa realidade.





Eu já contei parte disso no episódio do Diário de Henry Jones, mas em 2004 eu ainda era um consultor Java e SAP, lidando com o peso e burocracia de projetos enterprise desenhados em centenas de páginas de casos de uso e diagramas UML, usando coisas como IBM WebSphere ou BEA WebLogic. Mundo open source não era algo que programadores enterprise discutiam muito, porque não parecia muito "profissional", era coisa de "agência de php pra sitezinho de sobrinho". Profissionais usavam JSP, com algum framework proprietário da IBM ou da Oracle.




Pensem em um ambiente onde gerenciar banco de dados era um troço difícil, nenhum programador gostava de fazer ou mesmo podia fazer se quisesse. Pra isso existiam DBAs. Subir aplicativo web em produção era um saco, ninguém queria fazer, por isso existia gente de infra só pra subir versão nova em produção. Gerenciar versionamento de software era um saco! Ninguém queria fazer! Eu juro que existia emprego pra uma posição chamada "Gerente de Configuração" pra ferramentas da Rational tipo Clearcase, que é literalmente alguém cujo job description era fazer commit do código! (mindblown!)




O que havia de mais avançado no mundo open source naquela época era poder desenvolver apps em Apache Struts ou o novíssimo Spring na era do Java 1.4 pra 1.5, subir num tomcat ou glassfish local pra testar e num JBoss pra subir em produção. Usar Subversion era um troço meio subversivo ainda. Povo preferia usar Clearcase ou Microsoft SourceSafe. E mesmo usar Subversion era sofrido, tenta fazer merge de branches pra subir no trunk. E desenvolver fora da rede offline não dava porque Subversion precisava estar online já que commit é o equivalente a commit mais push num Git de hoje. Windows XP ainda era mais do que normal, com um tanto de antivirus tipo McAfee (video) pesando e mesmo assim com aquela sensação que ligar o XP na internet era que nem fazer sexo sem proteção. Acho que eu formatava e reinstalava meu sistema com certa frequência só pra garantir. Eram tempos difíceis ...





Então em 2005 a gente  esbarra num video com o chamativo título de "Blog em 15 minutos" de um moleque desconhecido com cara de cagador de regra … não, não, não era eu, era esse dinamarquês chamado David Heinemeir Hansson que a gente se acostumou a chamar só de DHH. Pff ... em 15 minutos meu Eclipse com os plugins de Websphere nem carregou tudo ainda. Esse video aliás, tem quase 15 anos, e eu acho que vale a pena incorporar ele aqui. Lembrem-se, eu sei que 15 anos atrás muitos de vocês assistindo tinham uns 10, talvez 15 anos de idade, mas tente assistir assumindo que Nada que vocês usam hoje existia naquela época.


(... blog 15 minutos)



A gente chamava esse video também de "video do oops". O David foi convidado pra vir pro FISL de 2005, o Forum Internacional de Software Livre que acontece em Porto Alegre, todo ano. Um dos organizadores naquele ano foi meu camarada Rodrigo Kochenburger que hoje mora em São Francisco e é um dos melhores programadores que eu já conheci. Antes de mim, pessoas como ele já estavam engajados nessa comunidade de nicho que era Ruby. Agora, entenda que literalmente ninguém usava Ruby fora do Japão e mesmo lá era só um pequeno grupo. Quando o DHH veio apresentar o Rails no FISL a platéia eram basicamente pythonistas e outros que tavam nos corredores. Se tinha meia dúzia de rubistas, no FISL inteiro, era muito.





Pra dar uma noção, tirando pessoas como o Rodrigo não tinha quase nenhum rubista na ativa em 2005. Tinha o Caffo que é outro Rodrigo, o Rodrigo Franco que tinha começado a primeira mailing list brasileira de Rails, a Rails-BR. Tinha o Adriano Dadario e o Ronie Uliana que mantinham o antigo site/forum RubyBR. Tinha o mestre Eustáquio Rangel que publicou o primeiro livro de Ruby no Brasil, e o Ronaldo Ferraz que publicou o primeiro tutorial de Rails em português. Ainda ia levar algum tempo pra aparecer outros blogs que viraram referência aqui no Brasil como o Simples Ideias do Nando Vieira. Aliás, eu provavelmente vou esquecer muitos nomes do começo da história, me perdoem e quem se lembrar da galera das antigas pode mandar nos comentários abaixo.




Naquela época o Vinicius Teles do Rio de Janeiro já tinha publicado seu livro sobre Extreme Programming e estava começando a aplicar em projetos Rails. E outros nomes começaram a surgir como o Manoel Lemos, que hoje virou venture capitalist na Redpoint mas na época desenvolveu o BlogBlogs em 2006, antes de entrar pra Editora Abril. A ótima equipe que de alguma forma o Marco Gomes conseguiu juntar foi quem construiu o famoso Boo-Box em 2007. Na época existia os e-mail do UOL e tinha um produto paralelo que era o BOL ou Brasil Online, que foi feito em Rails lá por 2006 ou 2007 também. 





Como falei em outros episódios eu acredito em ciclos de mercado. É muito difícil identificar o começo de um ciclo, normalmente você se dá conta que tá dentro de um quando já passou da fase de early adopters. Mas em 2005 eu sabia que Ruby on Rails, principalmente no Brasil, estava ainda começando o dia 1 desse ciclo. É muito raro conseguir enxergar o dia 1 de alguma coisa que vai conseguir completar o ciclo de 10 anos e embarcar nele no começo. Em 2005 eu tinha já uns 10 anos de carreira, e eu lembro que senti esse frio na espinha quando relembrei de 1995, ano que tivemos alguns dos lançamentos mais históricos até então, o Java 1.0, o Delphi 1.0, o Netscape 1.0 com Javascript 1.0, o Windows 95 inaugurando a era 32-bits. E ali estava eu, 10 anos depois, sentindo que um novo ciclo de 10 anos estava iniciando no mundo de programação. Eu não podia imaginar o que viria pela frente, só agora em retrospectiva dá pra ligar os pontos.





Eu achei o David Hansson, o DHH, um cara muito inteligente, diferente da maioria puramente técnica. Ele criou um produto que ninguém tinha feito igual até então. E não estou dizendo só em criatividade técnica. Estou falando em produto como um todo mesmo. Aliás, ninguém se referia a sites como “produtos” nessa época. Algumas coisas eram geniais só de bater o olho e algumas coisas a gente sabia que seria genial mas faltava ainda tempo pra se provar.





Vamos começar do básico. Naquela época dentre algumas das linguagens mais usadas estava Basic, tanto do Visual Basic, quanto VBScript de ASP e plugins de Office, e no novo .NET, daí C#, Java, PHP, ColdFusion, lembram de ColdFusion?? Lembrando que estamos falando de C# acho que 2, Java 1.5, PHP 3 ou 4. Javascript ainda era não mais que um brinquedo pra soltar box de alert nas páginas. ActionScript que era baseado em Javascript só existia no mundo Flash. Nenhuma das novas linguagens que você conhece hoje tinham sido inventados ainda como Scala, Elixir, Go, Rust, Clojure, Swift, Kotlin. Objective-C ou Erlang já existiam mas ninguém nunca tinha ouvido falar neles no mercado em geral.





Falando em Objective-C a gente tava entrando no final do ciclo de hype de orientação a objetos. Nos anos 70 principalmente a discussão sobre o que era a melhor forma de descrever e programar objetos foi tema de inúmeras discussões, livros, eventos e eu argumentaria que a melhor linguagem orientada a objetos de todos os tempos foi Smalltalk. Porém as empresas que mantinham as versões comerciais de Smalltalk como ParcPlace-Digitalk, ObjectShare, acho que tiveram ingerências ou azar mesmo, e começaram a desaparecer nos anos 80. E o aparecimento de coisas como Visual Basic e depois Java meio que foi o tiro de misericórdia. Smalltalk desapareceu quase totalmente nos anos 90, ninguém mais ouvia falar. Hoje se você procurar ainda acha a Cincom ou a Gemstone e versões open source como o Squeak e Pharo. Só alguns nichos ainda carregavam a herança de Smalltalk em linguagens como Objective-C que a NEXT de Steve Jobs estava usando e essa linguagem obscura do Japão chamada Ruby, que é uma das únicas que se assemelha ao estilo do Smalltalk e Objective-C, mesmo hoje.







Escolher Ruby foi um acerto improvável. Muitos poderiam criticar o fato do DHH não ter escolhido algo como Python que também é uma linguagem interpretada, orientada a objetos e com tipagem dinâmica, mas teria sido a escolha errada. Eu nem sei se o DHH chegou a pensar tão longe assim, eu acho que foi mais sorte mesmo, mas ainda bem que ele escolheu Ruby no lugar. Apesar da linguagem em si ter características excepcionais de ser super flexível, expressiva e agradável de trabalhar comparado com Java, ele tinha Uma coisa que ninguém mais tinha: … ninguém usava, não tinha um ecossistema estabelecido. É como você encontrar ouro e acumular, anos antes do mundo determinar que ele tinha valor.





O DHH começou como um freelancer, trabalhando da Dinamarca que é o país dele, pra agência chamada 37signals, de Chicago, que foi fundado por Jason Fried. Ele já tinha trabalhado um pouco com Java, um pouco com PHP, e assim como todos nós naquela época, já estava de saco cheio da burocracia do Java ou dos bugs e cultura de "quick and dirty" do PHP e Perl do fim dos anos 90. Então por 2003 ou 2004 a agência começou a migrar pra virar uma empresa de produtos, e o DHH resolveu dar uma chance pra esse tal de Ruby. Assim ele desenvolveu o lendário Basecamp que é uma ferramenta colaborativa pra organizar pequenos projetos, e em 2004 ele extraiu o framework Ruby on Rails. Aliás, primeira dica, nunca acredite num framework que não foi extraído de um aplicativo de verdade. 




(musica de suspense)
Agora aqui entra a minha análise pessoal. O fato do DHH ter se aliado a Jason Fried e o DNA da 37signals ser de design, especialmente numa época onde o design da Apple estava começando a despontar, foi extremamente importante. Muito da linguagem minimalista do design da escola alemã de Bauhaus se misturou ao estilo de código, produto e filosofia do DHH. Naquela época o normal pra um arquiteto enterprise era criar frameworks o mais flexível possível, tudo explícito, tudo configurável, com o maior número de abstrações e indireções pra suportar projetos corporativos de qualquer tamanho e qualquer escala, e de preferência via comitê, com consenso de gente que nem de fato vai usar. Era a filosofia de “e se amanhã eu precisar?”. O DHH preferiu fazer o caminho inverso, que na época era muito inédito: criar um produto de verdade primeiro, que realmente funciona com usuários de verdade, e depois extrair as peças da fundação pra montar um framework. Ironicamente era assim que antes empresas como IBM e Oracle extraíam seus produtos: depois de implementar primeiro num grande cliente, como o governo ou os militares. 




(comercial java)



Pouca gente fazia isso nos anos 2000. Arquitetos corporativos eram esnobes demais pra ir pra ralé e, deus me livre, fazer alguma coisa que funciona de verdade. (excerpt) No mundo PHP o pessoal fazia produtos inteiros, vide Joomla, vide Drupal, vide Wordpress. Mas eles raramente extraíam as partes comuns pra reusar em outro projeto, e a comunidade ficava fragmentada em ilhas. O estilo de código quick and dirty macarrônico, muita otimização prematura, porque o PHP não era exatamente a coisa mais performática do mundo também, e diferente de Ruby o PHP de fato tomou muita porrada de verdade. Em vez de "perder tempo" fazendo frameworks, eles ficavam cada um na sua ilha de produto e não se preocupavam muito em reuso. O máximo eram as tentativas de imitar o mundo Java, e imitar justamente a parte ruim: fazendo frameworks gigantes demais como o Zend e criando monstrinhos como o primeiro Magento.



“Vamos ficar masturbando diagramas abstratos como se fosse arte barroca o dia inteiro”.



(comercial php)



Comparativamente o framework Ruby on Rails era muito pequeno. Quando eu escrevi o primeiro livro de Rails eu também não sabia tudo de Rails ainda, então eu escrevi meu livro, capítulo a capítulo lendo o código fonte de cada parte. O código naquela época era pequeno o suficiente pra dar pra ler de ponta a ponta. Mais importante: o código que eu como desenvolvedor de uma app usando Rails precisava escrever era surpreendentemente pouco. Vindo de J2EE a gente tinha que fazer um trilhão de boilerplates; exatamente porque o framework exigia tudo explícito. 




Por exemplo, quero fazer um Entity Bean em 2000. Precisava fazer um arquivo que é a interface, outro que é a implementação em si, outro que é um stub pra acesso remoto e por aí vai. Cada coisa que você fazia num J2EE precisava de uns 3 ou 4 arquivos de boilerplate pra ligar as coisas no framework. Não seria exagero dizer que se o projeto tinha 100 arquivos, só uns 20 era código de verdade com regra de negócio e tudo. Por isso a gente precisava usar Eclipse com plugins: pra ele gerar e atualizar essas classes extras pra gente. Era que nem os JavaBean antigos, se eu precisasse programar 10 propriedades, precisava implementar 20 métodos: 10 getters e 10 setters e, de novo, o Eclipse gerava isso automaticamente pra gente. Sério, era um saco programar com as primeiras versões de J2EE. (abaixa a cabeça)






Mas aí eu vi que no Rails não precisava fazer nada disso. Tinha quase zero boilerplates, era uma heresia! Ele apresentou esse conceito de Convention over Configuration e DRY ou Don't Repeat Yourself, que é um pensamento meio óbvio hoje  - ou pelo menos deveria ser - mas não era em 2004. Toda entidade vai ter os mesmos 3 ou 4 arquivos de boilerplate que não serve pra nada, então pra que gerar? Faça o framework inferir o que precisa gerar em tempo de execução e não gere nenhum arquivo que não seja absolutamente necessário. E, mais do que isso, o pouco que eu preciso gerar, não precisa de um plugin numa IDE: roda um script na linha de comando e boom, gera tudo pra mim! Isso era revolucionário! Daí é facil ver como um projeto que deveria ter 100 arquivos, em Rails tinha só uns 20 ou menos.




Justiça seja feita, o J2EE foi quem introduziu o modelo de MVC ou Model View Controller ou mais corretamente o Model 2 da Sun para o mundo em geral. Só que era tão complicado de entender que fazia sentido você precisar de certificação de arquiteto Java só pra conseguir entender esse tal de MVC. O Rails foi quem tornou MVC e conceitos como thin-controllers algo finalmente acessível pro público em geral.





O gerador do Rails sempre gera o esqueleto do projeto. Você sempre sabe que controllers vai nessa pasta, models vão nessa pasta, e views vão nessa outra pasta. Sem XMLs complicados pra configurar e duas dúzias de boilerplates que você nunca sabe onde colocar. Daí todo projeto Rails tem mais ou menos a mesma estrutura e era fácil pular de projeto e saber onde ficam as coisas. E a idéia se pagou porque 15 anos depois, a estrutura do Rails 5 de hoje é muito parecida com a do Rails 1. Mais do que Convention over Configuration, desde o começo Rails era o que gente chamava de opinionated, ou seja, seguia as opiniões do DHH. Isso é controverso até hoje, mas ele bateu o pé e insistiu em integridade conceitual. 





Isso Não é uma democracia e Rails era um framework sem consenso e sem comitê. Já não era sem tempo, consenso em mundo técnico é só o mínimo denominador comum dos membros. Em vez de tentar abraçar o mundo e criar um framework que poderia ser pra qualquer coisa ele focou pra ser bom pra fazer apps similares ao Basecamp. Tem gente que odeia isso, mas haters gonna hate. Você pode trocar alguns componentes com alguma facilidade, mas quanto mais diferente você tentar ficar do Rails original, mais complicado vai ficar pra manter o projeto no futuro.





E aqui vemos a influência da Apple. Macbooks bem que poderiam ter mais portas de expansão, ser mais fácil de trocar peças e assim por diante. Mas aí ele seria igual um Dell ou Lenovo. O que torna o Macbook um Macbook é a forma. Sempre vai existir a discussão de forma contra função mas qualquer coisa diferente só pra conseguir consenso com algum nicho destrói sua integridade conceitual. Minimalismo parte do princípio que quem faz o design tem uma opinião muito forte sobre o que é esse mínimo. DHH não é nenhum Jobs, mas ambos certamente tinham muita opinião e não seriam dobrados com facilidade, e ambos foram provados corretos ao longo da década. Não é difícil de argumentar que se hoje Macs são dominantes no mundo de tech startups, foi por causa de Ruby on Rails. Sim, a culpa é nossa. Vejam este vídeo de 2007 que foi feito em parceria com a Apple Education:




(apple video)




Um dos aspectos que vinham ligados por padrão era segurança. Numa época onde era super comum sites sendo lançados em produção com erros primários como cross site request forgery, cross site scripting, sql injection, session hijacking, tudo isso já era travado por padrão no Rails. De novo um efeito de Convention over Configuration, ou seja, porque ter que ligar coisas manualmente que já deveriam estar ligadas por padrão? Você precisava manualmente desligar as proteções se quisesse, e aí fica por sua conta. Por isso apps Rails por muitos anos sempre estiveram entre alguns dos mais seguros por padrão. Todo framework que te vende “flexibilidade” porque você mesmo pode escolher quais componentes por adicionar, sempre vai ser pior porque a grande maioria vai sempre escolher errado. 





E se isso não fosse suficiente, nesse esqueleto que ele gera igual pra todo projeto ainda havia outra coisa Completamente diferente: um diretório chamado test. E todo gerador de models, ou controllers ou views também gerava arquivos correspondentes de testes vazios nesse diretório. Lembrem-se era 2004, o manifesto ágil de software tinha saído só 3 anos antes. Vamos lembrar uma coisa, Gerry Weinberg fez testes pela primeira vez em cartões perfurados em 1989. Kent Beck, um dos criadores de Extreme Programming começa a experimentar essa ideia e cria SUnit em 1994 inaugurando a idéia da gramática de testes como test cases, asserts,  e vai fazendo pesquisa e escrevendo a respeito até finalmente consolidar a idéia de test driven development e lançar o JUnit no ano 2000. Ou seja, a idéia de TDD não tinha ainda 4 anos desde que o mercado começou a ouvir falar.




Os mundos de desenvolvimento tradicionais, sejam .NET, Java, PHP, não estavam assim muuuuito empolgados em adotar, só alguns pequenos nichos. Então nesse ponto era muito frustrante querer que os programadores fizessem testes, se você tentasse provavelmente todo mundo ia tirar sarro de você na melhor das hipóteses ou você podia ser demitido mesmo, por ser improdutivo fazendo código irrelevante pro projeto! Éee eu sei! De novo, aqui temos outro insight: é muito difícil implementar mudanças radicais como um TDD num ecossistema gigante que já existe e é resistente a mudanças. Não vai acontecer tão fácil, mas existem estratégias. Lembram que eu falei antes que um dos acertos improváveis do DHH foi ter escolhido Ruby, uma linguagem que ninguém usava? Eis o motivo de porque deu certo: porque ele precisava introduzir um novo paradigma mas sem ter que gastar tempo convencendo antigos usuários de Ruby e migrando projetos inteiros pro novo paradigma, por isso dava pra se mover muito rápido.






No ano 2001 o mundo Ruby começou a se interessar com a idéia de testes no estilo de xUnit, surgiram bibliotecas como testsup, depois Lapidary, finalmente RubyUnit e Test::Unit que seguia o estilo xUnit do Kent Beck. E isso foi adotado no Rails do DHH, como padrão! Não algo que você tinha que adicionar depois, mas algo que o framework obrigava você a manualmente tirar se não quisesse. Junte a isso que alguns agilistas como Ward Cunningham e acho que Martin Fowler já estavam com um olho no Ruby porque ele lembra o Smalltalk que eles já gostavam como a verdadeira orientação a objetos, um estilo que ficou perdido nos anos 80. 





Aliás, o primeiro livro de Ruby em inglês saiu em 2001, apelidado de Pickaxe por causa da capa, foi escrito por dois signatários do Manifesto Ágil, Dave Thomas e Andy Hunt. Portanto você imagina que além de tudo essa comunidade ocidental de Ruby, começando do zero já iniciaria com Extreme Programming e The Pragmatic Programmer como filosofias de fundação. Finalmente uma comunidade de software que estava começando do zero do jeito certo, ou seja, o jeito verdadeiramente Ágil de desenvolvimento. 





Mais do que isso, o tipo de desenvolvedor que virava rubista era muito estranho. O exemplo mais notável foi o lendário Why, the Lucky Stiff, que escreveu naquela mesma época o lendário livro que muitos usaram pra aprender Ruby: The Poignant Guide to Ruby. Sério, olha algumas páginas desse livro (video). 


Why era um pseudônimo, e ele nunca quis revelar seu nome ou qualquer detalhe da sua vida, e quando algumas pessoas começaram a fuçar e começar expor sua vida pessoal, inclusive revelando seu nome verdadeiro como sendo Jonathan Gilette, ele fez uma coisa que admiro até hoje. Ele resolveu sumir do mapa em 2009, sem deixar vestígios. Aliás, em 18 de agosto de 2019 faz 10 anos desde que Why apagou todos os seus repositórios e sites e desapareceu.





Ele era um artista que usava código pra se expressar, e ao contrário de um Python ou Java com seu estilo de engenharia de ter só um jeito certo pra se fazer as coisas, e tudo deve ter consenso em comitê, o Ruby era o oposto: manipule a linguagem como você quiser. Ele tinha a liberdade do Lisp com a expressividade do Smalltalk. Nenhuma outra linguagem da época permitiria algo como o que Why fazia. Why the Lucky Stiff que inclusive é um nome que aparece citado uma única vez no romance The Fountainhead, de Ayn Rand. Outra coincidência que eu achei muito providencial dado que Why fez a mesma coisa que o fim do livro A Nascente. 


(video acabando com chunky bacon)



Se você nunca ouviu a expressão “Chunky Bacon”, você ainda não aprendeu Ruby do jeito certo (risos). Ruby começou sendo ferramenta de artistas. A primeira geração de rubistas é um grupo que não se via igual talvez desde os anos 60 ou 70. E o que eu falei que Ruby atraía desenvolvedores estranhos é porque eram pessoas que gostavam de expressar suas décadas de experiência com código. Entrar num grupo gigante é fácil, é só ser um seguidor. Mas pra entrar num grupo com zero pessoas, você precisa ser um criador. Por isso a primeira geração de rubistas trouxe gente como Chad Fowler, Rich Kilmer, David Black, o falecido e adorado Jim Weirich, depois agilistas como Dave Thomas ou Martin Fowler ou Uncle Bob. Não deixem de assistir o documentário sobre o Why que eu co-apresentei na Rubyconf Brasil de 2014 com Kevin Triplett e meus artigos sobre ele que vou deixar nas descrições abaixo.





Então vamos recapitular nossa sopa primordial: uma linguagem obscura, que resgata o espírito de Smalltalk e Lisp, a orientação a objetos original, que implementa corretamente os princípios ágeis, e até mesmo outras noções como yagni ou you ain’t gonna need it, que é o jeito minimalista que o DHH aprendeu na renascença da nova Apple de Steve Jobs, numa comunidade de misfits e artistas wannabe, de desenvolvedores experientes dos anos 70 a 90 que queriam voltar a se expressar com código. Claro que isso atraiu a atenção de muitos  agilistas da época, incluindo metade dos signatários do manifesto. E mais do que isso: chegamos ao fim da depressão do crash das ponto coms em 2001, estava na hora de recomeçar a criar produtos e o Basecamp e o estilo Getting Real da 37signals se tornou o exemplo de como fazer isso. Aliás, o Getting Real que aqui no Brasil chegamos a fazer uma tradução oficial em português também e que se tornou o manifesto da nova geração de empreendedores de produtos de tech startups, muito antes do surgimento de Lean Startup.





E claro, todo mundo deu risada de Ruby on Rails, um framework não-enterprise, que não era infinitamente configurável, que vinha com defaults estranhos como MySQL em vez de suportar Oracle, que não tinha suporte pra Windows, que te obrigava a apagar os arquivos de testes, porque ninguém queria fazer testes no mundo Java, e ainda usando Macs??? Profissionais usam Windows XP, lógico! E ainda usando essa linguagem bizarra chamada Ruby que diz que é orientada a objetos mas não tem tipos estáticos como toda linguagem profissional como Java ou C#. Lógico que ia ser um fracasso. (gandhi) 




Ah, e você não gosta do Jira hoje? Imagina como o Jira era mil vezes pior em 2004, e como todo mundo ria que algo no estilo Basecamp nunca seria usado no mundo enterprise. Se ainda não entendeu a gravidade da situação da época foi em 2003, 1 a 2 anos antes que o Java Server Faces, o JSF tinha acabado de ser lançado e todo mundo estava adotando aquele lixo, que era um ASP.NET WebForms piorado pra Java! Ah sim, pra quem gosta de falar em frameworks baseados em componentes e orientados a eventos, ASP.NET e JSF. (joinha)



A partir de agora, apertem os cintos, vamos fazer uma longa timeline, de uns 7 anos! Eu não vou por temas e sim em ordem cronológica. Vocês assistiram os demais videos do meu canal né? Porque agora muita coisa que eu disse neles vai se encaixar.




2004 foi um ano especial. Em 1o de Abril o Gmail foi lançado, demonstrando um dos primeiros single page applications e o poder de tecnologias como Ajax. Em 24 de julho saiu o primeiro beta público do Ruby on Rails versão 0.5. Em 2 de Outubro o DHH apresenta o Rails pela primeira vez numa RubyConf, que na época estima-se que tinha umas 60 pessoas na platéia. Três dias depois a O’Reilly promove a conferência Web 2.0 onde o termo foi cunhado pela primeira vez. Em 10 de dezembro o Google lança aquela funcionalidade que você usa todo dia e nem pensa muito, o Google Suggest, que vai te dando sugestões à medida que você vai digitando os termos de pesquisa, usando XMLHTTP e de novo demonstrando o poder do AJAX e comunicação assíncrona em tempo real. Todo mundo queria fazer a mesma coisa.






2005 não ia ficar pra trás. Logo no 1o dia do ano, a Robot Co-op lança o 43 Things; o site é um early adopter de Ruby on Rails. Em 8 de fevereiro o Google Maps lança pra Internet Explorer e Firefox, redefinindo o nível de interação possível em um web browser. Essa era a época que o Google tava literalmente on-fire lançando um app atrás do outro. E alguns dias depois, em 15 de Fevereiro, Jesse James Garrett cunha o termo Ajax para descrever as novas aplicações web ricas como Flickr, Google Suggest, ou Google Maps. No dia seguinte o Rodrigo Caffo cria a primeira mailing list brasileira de Rails, a Rails-BR. 




Em março o britânico Peter Cooper começaria o blog Ruby Inside, o melhor blog pra se manter atualizado no mundo Ruby e Rails e que daria origem anos depois ao conjunto de mailing lists como JavaScript Weekly, Ruby Weekly, RubyFlow, Frontend Focus, Node Weekly, Golang Weekly e vários outros que centenas de milhares de desenvolvedores usam até hoje e se mantém com um dos melhores canais pra se manter atualizado. Em 7 de Abril tivemos outra revolução, o Lançamento inicial do sistema de controle de versão distribuída git. E na sequência, em 2 de Julho, o DHH grava o demo do blog de 15 minutos, demonstrando a velocidade do desenvolvimento rápido com Rails. Esse video se torna viral e todos os sites de todas as linguagens começam a notar a presença desse alien.





E não demorou muito, também por volta de julho tivemos o lançamento inicial do Groovy on Grails, um framework inspirado no Rails pra recém lançada linguagem Groovy que roda na JVM. Foi o primeiro de muitos clones de Rails que apareceriam nos próximos anos. Daí ainda em julho, no dia 7, é lançada a biblioteca javascript script.aculo.us 1.0.0 que possibilita um novo nível de interação em páginas web, tornando fácil adicionar os efeitos de estilo Web 2.0 nas suas aplicações. No dia  21 de Julho, o framework Django é lançado depois de ficar em desenvolvimento por mais de 2 anos. Em 4 de Agosto o livro Agile Web Development with Rails, primeira edição foi publicado pela PragProg, novamente escrito pelos agilitas Dave Thomas e Andy Hunt. E foi em outubro de 2005 que o indiano Satish Talim inaugurou o curso online pra iniciantes RubyLearning que está ativo até hoje e foi importante naquela época.



De curiosidade, em 3 de Dezembro teve a Conferência Snakes and Rubies que levou os criadores do Django e do Rails (video) pra discutir sobre frameworks web e os caminhos diferentes que eles tomaram. Naquela época ainda não estava claro quem ia ganhar, mas os motivos que eu já citei antes devem deixar claro porque um foi muito diferente do outro apesar de terem começado parecido. 10 dias depois o Rails 1.0 é lançado. (...) Nós tínhamos alguns dos melhores escritores de blog daquela geração, um dos melhores sempre foi o Ilya Grigorik do blog Igvita e que hoje é engenheiro de web performance do Google. Seus artigos sobre performance no Ruby e Web em geral influenciaram toda a nossa geração e vale a pena reler ainda hoje. Seu primeiro blog post foi ao ar em 28 de dezembro. E assim acaba 2005!





As coisas começam a esquentar em 2006. Primeiro, em março, Jamis Buck que entrou pra equipe Core do Rails renomeia seu projeto SwitchTower pra se tornar o que conhecemos como Capistrano e a forma inédita de automatizar deployment de projetos em máquinas de produção orquestrando via SSH, e essa ferramenta inspiraria diversas outras como o Fabric e Ansible de Python que vieram depois dele. Ainda em março, no dia 21 o Jack Dorsey posta o primeiro tweet: “just setting up my twttr”. 2 dias depois o Eustáquio Rangel lança o primeiro livro de Ruby no Brasil e um mês depois em 5 de Abril eu escrevo meu primeiro post no que viria depois a se tornar o blog AkitaOnRails.com. 




Em 22 de Junho acontece a primeira RailsConf em Chicago. E já em 30 de Junho o rubista Hamptom Caitlin sobe o primeiro commit do SASS e inicia uma nova era de meta-linguagens pra tornar possível ser capaz de codar decentemente em linguagens chatas como CSS. Também já em 5 de Julho surge o JRuby 0.9, uma versão de Ruby que roda em cima da JVM e já consegue rodar Rails. Charles Nutter e Tom Enebo continuam firmes e fortes mantendo a linguagem até hoje.




Muito antes de termos a onda de cursos online que temos hoje, a comunidade Ruby on Rails foi pioneira em mostrar como cursos de qualidade poderiam ser feitos e foi Geoffrey Grosenbach que iniciou isso com seu Peepcode, que anos depois seria adquirida pela Pluralsight. Muita gente, incluindo eu, aprendemos muito nos cursos do Geoffrey.





Pra continuar os lançamentos revolucionários, em 25 de Agosto a Amazon Web Services, ou AWS, lança o Elastic Compute Cloud (EC2) e inicia de fato a Era do "Cloud Computing" como conhecemos hoje. No dia seguinte, em 26 de Agosto o John Resig lança o então adorado e hoje denegrido jQuery. Pouco mais de um mês depois em 6 de Outubro meu primeiro livro "Repensando a Web com Rails" saiu da gráfica, o primeiro de Rails publicado no Brasil. Três dias depois em 9 de Outubro, o Ronaldo Ferraz lança o primeiro tutorial de Rails no Brasil. E ainda em Outubro surge o primeiro framework concorrente de Rails escrito em Ruby, o Merb 0.03 que significa ("Mongrel+Erb").



(video jobs iphone)



E falando em 2007, logo no começo do ano em 9 de Janeiro o mundo da tecnologia recebe um novo marco: o lançamento do primeiro iPhone. Poucos dias depois em 18 de Janeiro é lançado o Rails 1.2 lançado com o lendário RESTful resources e o mundo finalmente aprendeu que HTTP não é só GET e POST e finalmente os outros verbos ganharam uso. Foi neste ponto que mundo Web começou a proliferar a idéia de APIs REST como Roy Fielding publicou no ano 2000 definindo REST. Ruby on Rails se tornou o gold standard em APIs. Em 20 de Fevereiro o Christian Neukirchen define a interface Rack, inspirado pelo Web Service Gateway Interface ou WSGI de Python que foi definido na famosa PEP 333 de 7 de dezembro de 2003. 





Em 4 de março o saudoso Ryan Bates lançou o primeiro episódio do videocast chamado Railscasts. Assim como Geoffrey da Peepcode ele criou dezenas de videos curtos sensacionais e muito bem produzidos e editados. Novamente mostrando como videos de programação poderiam ser bem feitos e ensinando toda uma geração de Railers, incluindo eu mesmo. Infelizmente ele parou por volta de 2013. Eu diria que o sucessor espiritual do Ryan hoje é o Avdi Grimm com seu também excelente RubyTapas, cujo primeiro episódio foi ao ar em 24 de setembro de 2012, então ele realmente é quase uma continuação do Railscasts só que voltado ao Ruby em si. Eu recomendo que vocês assinem.





Na renascença das tech startups, começaram a surgir as famigeradas redes sociais, a versão moderna do muro das lamentações. Na melhor fase tivemos Orkut, Friendster e MySpace que já estavam saturados mas o público pedia por mais. Facebook estava só começando a aparecer, não lembro se nesse ano já tinha aberto no Brasil. De repente um grupo que tinha crescido no mundo de blogs com a Odeo resolveu criar um modelo experimental de micro-blogging, que você podia enviar posts via SMS, e por isso tinha o limite de 140 caracteres. E eles resolveram batizar esses micro-posts de tweets, inaugurando também a era de nomes bizarros pra startups. E, mais importante, escolheram Ruby on Rails pra implementar. Claro, ser inspirado pelo framework do blog de 15 minutos pra fazer uma plataforma de micro-blogging fazia todo sentido. Eu abri minha conta em 2007 se não me engano. 






Agora, em Abril de 2007 inicia-se a maior infâmia da história até então, a famigerada controvérsia do "Rails não Escala" iniciada por uma comunicação mal feita do Alex Payne, do próprio Twitter. Lembram que eu expliquei que Twitter foi criado como uma plataforma de micro-blogging? Pensa se o Twitter tivesse sido programado em cima do Wordpress. Só que 2 anos depois ele deu certo e milhões de pessoas começaram a usar, só que o uso mudou. Em vez de ser micro blog posts, a plataforma começou a ser usada como um sistema de comunicação, ou seja, de broadcast de mensagens. Claro que nem Ruby, nem PHP, nem Python, aguentariam isso. O problema nunca foi a linguagem, foi a arquitetura.






Só existia uma arquitetura conhecida na época que suportaria o broadcast massivo de mensagens, e se chamava Erlang. Mas ninguém queria ter que usar a sintaxe do Erlang, e por sorte o Odersky tinha acabado de lançar o Scala, com o framework Akka, que copia a arquitetura de atores do Erlang e possibilita usar esse sistema em cima da JVM. Ou seja, o Scala era a coisa mais próxima do Erlang que se tinha e, claro, fazia sentido mudar essa parte do back-end. Não é que o Rails não escala, nenhum outro framework em nenhuma outra linguagem ia escalar. Hoje em dia, pra esse cenário seria Elixir. Essa controvérsia seguiria o Rails por anos (e finalmente nos livramos disso, afinal se você acha que o Rails não escala, olhe pro GitHub, até hoje feito em Rails e usando a última versão)






Em 18 de Maio de 2007 o mundo de testes nunca mais seria o mesmo. Já expliquei sobre a importância de desenvolvimento com testes e como isso foi um gancho importante pra ganhar o apoio dos agilistas ao Rails, mas foi neste dia que o lendário RSpec foi lançado, baseado nas experiências de Steven Baker desde 2005 e com a ajuda de Dave Astels, Aslak Hellesøy que depois criaria o Cucumber, iniciando a era de Behavior Driven Development, e claro o simpático David Chelimsky que a comunidade brasileira adorou conhecer quando eu trouxe nas duas primeiras Rails Summit Latin America em 2008 e 2009. Todos os frameworks de teste na maioria das linguagens modernas que você conhece hoje como o Chai do Javascript é descendente direto do RSpec.





Seguindo na linha dos clones de Rails, ainda em maio de 2007 surge o Framework Play para Java. Em 16 de Maio eu iniciei meu primeiro emprego oficial como Railer full-time na Surgeworks, uma pequena consultoria de Utah. Mais pro fim vou falar da pessoa que se arriscou em contratar um brasileiro numa época em que isso era muito raro. Eu trabalhei remoto por um ano mais ou menos, onde eu finalmente comecei a programar em Rails profissionalmente, aos 30 anos. Só pra relembrar: eu deixei de ser sênior de Java e SAP e voltei a ser júnior e ganhar como júnior.





Por volta de Julho outro nome importante apareceu, o grupo do RailsEnvy com Gregg Pollack e Jason Seifer que contribuíram muito no estilo diferentão dos hipsters de Rails dessa época. Eles aproveitaram a campanha Get a Mac que a Apple agressivamente publicou como comerciais de TV entre 2006 e 2009, no auge da dominância da Apple do Zeitgeist, os famosos comerciais “Hello I’m a Mac …. 


(comercial mac vs pc)





Então em 2007 Gregg e Jason fizeram diversos clones desses videos com o mesmo princípio com Rails pra tornar mais divertido a forma como a gente via as demais tecnologias diferentes de Rails que até aquele momento ainda estavam vivendo no passado. E eles fizeram vários videos começando com o famoso Hi, I’m Ruby on Rails … (comercial)





Vocês podem ver os videos no canal de YouTube do Gregg Pollack que vou deixar linkado abaixo. Com o tempo o Gregg e Jason acabaram se separando, o Gregg montou a consultoria EnvyLabs e em paralelo, seguindo nos passos de Geoffrey Grosenbach e Ryan Bates montou o famoso Code School, com uma grade mais estruturada pra ensinar Ruby on Rails e outras novas tecnologias. E foram eles que criaram o conceito de Rails for Zombies que depois outras comunidades, como Python, copiaram também. Não existia comunidade que gerava mais conteúdo técnico do que a de Rails naquela época. O Rails for Zombies foi o primeiro curso do Code School que foi lançado em 2010. E o negócio foi vendido em 2015 também pra PluralSight onde vocês ainda podem achar os cursos.





Em 4 de Outubro tivemos o lançamento inicial do microframework Sinatra, também escrito em Ruby mas que não tinha o objetivo de competir com o Rails, ele era mais focado em micro-aplicações ou mesmo pra ser micro-serviço de APIs; ele é largamente copiado em outras linguagens até hoje. Ainda em outubro, no dia 19 finalmente os rubistas Chris Wanstrath e Tom Preston-Werner começam a trabalhar no GitHub, literalmente de um Starbucks. O Chris tinha o blog Err the Blog e começou criando bibliotecas de Ruby que conseguiam interfacear com Git.





Também em outubro, no dia 22 foi a primeira vez que eu organizei um evento, em São Paulo, o RejectConf SP que teve muitos dos nomes do Ruby brasileiro que você reconhece até hoje como Carlos Brando (CTO do Enjoei), Danilo Sato (ThoughtWorks), Fabio Kung (que foi do Heroku por muitos anos e agora está no Netflix), Vinicius Teles (da HE:Labs), Carlos Villela (que foi da ThoughtWorks por muitos anos e foi pra DigitalOcean), George Guimarães (Plataformatec) e mais. A Caelum do Paulo Silveira estava lá também ajudando com o coffee-break da galera.    Vocês estão vendo como as coisas estão acontecendo muito rápido, todo mês, às vezes toda semana estava saindo alguma coisa que influenciaria o mercado pelos próximos anos. Como eu disse no começo, 2004 marcou o início de uma nova era pra Web. 




(2008)
E pra não quebrar a tradição do ano iniciar com alguma coisa, já no primeiro dia de 2008 tivemos nosso primeiro grande RubyDrama. Era engraçado que antigamente não existia dramas em nenhum lugar, com frequência. Era tão raro na real que quando acontecia a gente chamava de RubyDrama. Notem que dramas só começaram a acontecer com frequência com o surgimento de plataformas como o Twitter. No caso do Ruby em 2008, Zed Shaw, o criador do Mongrel que foi o primeiro servidor de aplicações pra Rails, fez uma declaração bombástica de sua saída, chamando a comunidade Ruby de ghetto. Isso reverberou por um algum tempo. E ele não estava totalmente errado, só que ele não sabia jogar o jogo, o Zed é o tipo de cara tecnicamente excepcional mas de cabeça quente. Mas, todo drama que parece tão importante pra você hoje, alguns anos depois, ninguém mais nem se lembra, e o Mongrel foi rapidamente substituído por outros servidores de aplicação como o Thin, Passenger, Unicorn e depois o Puma que usamos hoje.




Mais importante do que isso, nesse mesmo dia 1o de Janeiro de 2008 foi quando o Heroku recebeu seu primeiro investimento seed de USD 20 mil da Y/Combinator. Esse foi o mesmo ano que eu participei da minha primeira Railsconf nos Estados Unidos. Lá eu conheci o James Lindenbaum um dos fundadores do Heroku. Eles estavam com um estande no evento e ninguém mais se lembra disso mas a primeira versão do Heroku era pra ser uma IDE Web pra desenvolvimento de software. Só que eles viram que isso não ia rolar naquela época. Pense que 10 anos atrás ainda era muito difícil imaginar coisas como o Electron que usamos hoje, o Google ainda não tinha começado a otimizar o Javascript, acho que nem tinha o V8 ainda. Então eles tiraram essa idéia mas ficaram com a segunda parte que era onde os apps iam rodar, a infraestrutura de containers que surgiria muito antes do Docker e que inaugura o primeiro PaaS ou Platform as a Service. Aliás, é disso que nasce as boas práticas do Doze Fatores ou 12 factors pra escalabilidade em 2007, escrito por Adam Wiggins que foi co-fundador do Heroku também. E, claro, Ruby on Rails foi o primeiro framework que estava compatível com os Doze Fatores.
 




Se você é de Elixir, pra efeitos históricos vale relembrar o projeto Reia de Tony Arcieri, que eu recomendo que vocês sigam porque ele manja muito sobre segurança e hoje em dia Rust. Pra dar perspectiva, o primeiro commit do Elixir do José Valim foi em 9 de Janeiro de 2011. O primeiro commit do Reia é de 21 de março de 2008 e ele é basicamente o Elixir uns três anos antes: uma nova linguagem muito mais próxima de Ruby que compila em bytecodes que executam na VM Beam do Erlang. No fim o Tony perdeu o interesse no projeto e foi fazer outras coisas como a biblioteca Celluloid pra Ruby que hoje é usado pra abstração de concorrência, seja de threads ou I/O assíncrono, inclusive hoje é dependência no Rails.





Já em 2 de Abril o desenvolvimento do Rails sai de Subversion e move seus repositórios pro GitHub, dando credibilidade pra essa ferramenta chamada Git que quase ninguém tinha ouvido falar fora dos grupos de Linux e desenvolvimento do kernel. Por muito tempo 90% dos repositórios que tinha no GitHub eram projetos Ruby e Rails, e todo mundo de fora começou a ficar interessado em testar. Alguns dias depois, em 10 de Abril o GitHub sai do beta e lança publicamente. Hoje em dia vocês nem pensam e basicamente adotam Git, mas nessa época além de Subversion, no mundo open source ainda tinha gente que usava CVS mesmo, e a nova geração ainda estava entre coisas como Mercurial ou Bazaar. Em 14 de Abril foi quando José Valim mandou seu primeiro commit pro Rails, foi o começo de 2 anos de trabalho que o tornou membro do grupo Rails Core em 2010. 





Nesse ano eu estava tendo que me virar. Em Junho eu tinha saído da Surgeworks e entrei na Locaweb. Embarquei pra Portland, no Oregon, pra Railsconf com a missão de conseguir integrar com a comunidade de lá e organizar o primeiro grande evento de Rails no Brasil, na América Latina na real. Com cerca de 3 meses só pra organizar tudo do zero, em 15 de Outubro tivemos o Rails Summit Latin America 2008, no Auditório Elis Regina do Anhembi em São Paulo. Deu bastante trabalho mas os nomes que eu consegui trazer muitos vão reconhecer até hoje como Chad Fowler, um dos rubistas originais no Ocidente, fundador da Rubyconf, meus amigos Ninh Bui e Hongli Lai da Phusion que desenvolveram o Passenger, um dos servidores de aplicação tipo o Puma de hoje, o David Chelimsky que contribuía no projeto RSpec e Cucumber, o Chris Wanstrath, fundador do GitHub, o Dr. Nic, o Obie Fernandez e mais. Ninguém achava a) que um evento desses fosse possível, nem b) que ele seria consistente e duraria quase 10 anos! Nessa primeira edição acho que já conseguimos juntar mais de 400 pessoas.




Outro acontecimento que vale lembrar nesse ano foi em 2 de setembro quando o Google finalmente lança o venerado e hoje temido navegador Chrome junto com a engine de Javascript mais importante de todos os tempos, o controverso V8, que vai dar início ao atual ecossistema Javascript. Pare um instante pra considerar isso se você for iniciante. A Apple se inspirou no Konqueror do KDE, fez fork e transformou o componente KHTML no WebKit. Daí o Google tinha contratado engenheiros do Firefox alguns anos antes mas eles nunca se acharam na posição de empurrar um novo navegador, mas chegaram num ponto que fez sentido começar com o WebKit como fundação e, no melhor estilo Google, fazer um deles parecido a partir de um fork em 2013.




Pra fechar bem o ano, em 23 de Dezembro tivemos o merge dos projetos Rails e Merb e a  equipe do Merb se junta ao Rails core team. Lembram o RubyDrama do começo do ano do Zed Shaw? Ele tinha meia razão, sempre existiu um grupo fechado pra discutir o desenvolvimento do Ruby on Rails, e isso não é nenhum problema, o DHH sempre quis ser como um Steve Jobs, ele controla o Rails com mãos de ferro, e não só o código mas tudo relacionado ao “produto” Ruby on Rails, como a marca, o nome, os eventos e tudo mais. Certo ou errado, ele owna as decisões em vez de se esconder atrás de um comitê. Isso é integridade conceitual que todo projeto precisa: um ditador benevolente. Gostem ou odeiem, foi o que manteve o Rails intacto até hoje.





Mas deixa eu explicar esse episódio, só pra ter registrado. Durante essa bolha de interesse explosivo em cima de Ruby on Rails, alguma empresas foram fundadas pra suportar a infraestrutura de startups que cresciam do nada como Twitter ou GitHub, especialmente depois da famigerada controvérsia do Rails não escala do Alex Payne. Uma dessas foi a Engine Yard, que estava competindo com a AWS e Rackspace. Pense que em 2008 a AWS só existia fazia 2 anos e nem todo mundo ainda tinha entendido essa idéia de máquinas virtuais voláteis cobradas por uso. Ainda dava pra pensar em competir com a AWS. A Engine Yard foi fundada por pessoas excepcionais, em particular o EZRA ZYGMUNTOWICZ, super gente boa que eu conheci em 2008 também. Ele era genial, tanto como programador, como quanto infra. 





Por exemplo, na época ele criou um sistema de deployment em máquinas físicas usando o protocolo Jabber que se usa em instant messager. Pensa você abrir faz de conta, um whatsapp de hoje em dia, e falar com sua infraestrutura e mandar ordens como atualizar as máquinas ou deployar apps, em 2008! Além disso ele foi o único que enxergou como fazer um concorrente de verdade pro Ruby on Rails, dado sua experiência com hardware e otimização de Linux, ele começou fazendo patches no Rails e no Mongrel e eventualmente criou o Mongrel ERB, um software que tira o Rails da equação. Em vez de fazer só mais um micro-framework, ele resolveu competir pau a pau e fez um Rails que muitos argumentariam que era melhor, esse foi o Merb.






A equipe que a Engine Yard montou contou com programadores como o Yehuda Katz e Carl Lerche pra acelerar o desenvolvimento do Merb. Tudo isso enquanto ele estava montando um data center, carregando servidores nas costas, montando rede, e ajudando outras tech startups a escalarem seus projetos em Rails. Então eles rapidamente criaram uma excelente reputação. Eles eram um dos maiores patrocinadores da Railsconf. Só que o erro foi que eles começaram a evangelizar o Merb agressivamente demais. Tipo, eles iam nas Railsconf falar mal do Rails e ofereciam o Merb como opção. Eu disse que o DHH queria ser o Steve Jobs? Saibam que a Railsconf só pode acontecer com o aval dele, porque a marca Ruby on Rails é trademark do DHH e o evento também. Imagina se na Macworld aparecesse um palestrante falando que Mac é um lixo, na frente do Steve Jobs. …. Pois é, o DHH ficou furioso com isso e eu soube de uma conversa dele com o Tom Mornini, um dos co-fundadores e na época CTO da Engine Yard. Eu estava online pouco depois que isso aconteceu falando com o Matt Aimonetti, outro core developer do Merb na época e o autor do post de reconciliação anunciando que o Merb seria mergeado no Rails. 







Eu não estava fisicamente na sala ouvindo, então não me citem, mas do que eu ouvi foi um ultimato do DHH pro Tom Mornini. Ou vocês páram com essa palhaçada de falar mal do Rails, na Railsconf, que inclusive é o seu sustento já que vocês atendem clientes de Rails, ou vamos “ter problemas”. Isso seria péssimo problema de relações públicas num estágio onde eles provavelmente ainda estavam no vermelho, procurando mais investidores e mais clientes. Então no final a Engine Yard cedeu à pressão e anunciou parar o Merb. Foi assim que o Yehuda Katz, Carl Lerche e Matt Aimonetti entraram pro grupo Rails Core Team e foi assim que o Merb morreu e nasceu o Rails 3.0. ufffff





(2009)
Com toda essa controvérsia “resolvida” por enquanto, podemos começar o próximo ano, 2009 em 16 de Março com o lançamento do Rails 2.3; agora sendo uma aplicação Rack. Finalmente, só agora, 7 anos depois do lançamento do framework baseado em I/O assíncrono Twisted do Python, em 27 de Maio temos o lançamento inicial do Node.js graças ao V8 lançado um ano antes. Ela permite que programadores escrevam Javascript client side e server side, pela primeira vez desde o falecido Netscape Livescript nos anos 90. E só pra colocar um pé do Rails até nisso, Ryan Dahl mesmo disse que foi inspirado pelo parser do Mongrel de Zed Shaw pra fazer o Node.js.






Em 13 de Dezembro, Jeremy Ashkenas sobe o primeiro commit do Coffeescript, um dos primeiros transpilers pra tentar tornar programar em Javascript algo mais agradável. Lembrando que nesta época ainda não tínhamos nem sinais do ES6 e Javascript pré-ES6 era um pesadelo de se usar. Na época o Coffeescript era excelente pra se trabalhar, ele inventou o conceito de fat arrows pra funções anônimas, interpolação de strings e muito mais que hoje você tem no ES6, então é muito fácil odiar o Coffee hoje sem saber como era em 2009. O Coffeescript serviu seu propósito em ajudar a evoluir o Javascript.





Virando mais um ano, por volta de abril de 2010 Steve Jobs publica o prego no caixão do Adobe Flash com o artigo Thoughts on Flash e sedimenta o caminho para HTML 5 + CSS 3 + Javascript não só em dispositivos móveis mas também em desktops. O Flash se tornou um morto-vivo desde então. A intenção original de Jobs era empurrar o então melhor navegador com o então melhor engine Javascript que era o Safari no Mac e agora no iPhone como uma plataforma para criar aplicações web. Eu diria que foi Jobs que sem querer tornou mainstream o conceito de Single Page Apps e o primeiro framework javascript a oferecer isso foi o hoje defunto SproutCore que deixou descendente na forma do atual Ember, que foi criado pelo mesmo Yehuda Katz que trabalhou no Merb da Engine Yard e também no Rails 3.0 e resolveu o problema de dependências do Ruby com a introdução do Bundler, que se tornaria referência pra todas as ferramentas de gerenciamento que vieram depois dele como Hex do Elixir, Cargo do Rust, Npm e Yarn no Javascript e assim por diante.






Esse negócio de dois frameworks se unificarem e só sobrar um, como o próprio Yehuda lembrou na época, já tinha acontecido outras vezes. No mundo Java o Struts 2 foi um merge com outro framework, o WebWork que se vendia como “Struts feito direito”. Em 1o de agosto de 2010 é lançado o Rails 3.0 com contribuições do Merb core team; um ano desde o lançamento do Rails 2.3. O que sobrou da comunidade Merb viu as promessas de um caminho de migração e a idéia de que o Rails se tornaria mais próximo das idéias do Merb se esvair. E esse foi o fim dessa história.





2011 foi outro ano interessante, em 12 de Julho o Criador do Ruby, Yukihiro Matsumoto (Matz) e outros membros do Ruby Core, são contratados pelo Heroku. Em 31 de Agosto o Rails 3.1 é lançado e o jQuery substitui o antigo Prototype como padrão. E em 19 de Setembro eu anunciei a criação da minha primeira empresa de desenvolvimento de software própria, a Codeminer 42. Aqui se iniciaria uns 4 anos de pesadelo na minha vida, vocês não tem idéia de como doeu criar uma empresa do zero, bootstrapped, sem investimento externo, pra crescer de forma sustentável e ser lucrativa. Felizmente já faz uns 3 ou 4 anos que as coisas tão super bem, graças a de … graças aos esforços incessantes de quem trabalhou nesses últimos anos na empresa.





Finalmente, em Novembro de 2011 outro produto importante foi lançado, o Travis-CI, fundado por rubistas como Josh Kalderimis, Konstantin Haase, Sven Fuchs e outros, em Berlin, na Alemanha. Eles conseguiram finalmente produtificar o conceito de integração contínua. Não só isso como ofereceram um serviço gratuito pra projetos open source que se integra diretamente no GitHub e pela primeira vez projetos de software livre tinham a opção de demonstrar seu nível de testes diretamente na primeira página dos repositórios. Vocês podem ver que nós rubistas originais levávamos testes realmente a sério. 




Só de bônus, foi também em 2011 mas não achei a data que Bryan Helmkamp criou o CodeClimate pra automatizar ferramentas de análise de código como Rubocop, Flay, Brakeman e outros, se integrando ao GitHub pra demonstrar como anda a saúde de nosso código. A partir desse ponto fomos refinando mais e mais nosso cinto de utilidades de qualidade de código Ruby e demos o exemplo pra todas as outras comunidades. Nenhum até hoje conseguiu chegar no mesmo nível obsessivo de qualidade que nós das primeiras gerações de Railers quisemos alcançar.





Vou parar a cronologia por aqui, veja que estou parando 8 anos atrás, mas acho que vocês podem ver como os acontecimentos do mercado em geral e do Ruby on Rails a esta altura já tinham mudado o mundo de desenvolvimento de software. Novas linguagens começaram a surgir, muitos influenciados por Ruby. Novos frameworks começaram a surgir, muitos influenciados por Ruby on Rails. O fluxo de trabalho havia sido já fundamentalmente mudado graças à adoção das práticas ágeis de extreme programming, Os conceitos de produtos Web 2.0, adoção de SaaS, PaaS, mundo cloud e tudo mais derivou dessa geração de Ruby on Rails entre 2004 e 2011. E em 2011 ainda estamos 2 anos antes do Docker ser lançado pela primeira vez, essa história é longa.




Lá no começo, em 2008 eu comecei a entrevistar diversos rubistas e outros desenvolvedores e publiquei no meu blog. Se você é de Microsoft vai saber quem é Scott Hanselman, leia a entrevista no blog. Adrian Holovaty o criador do Django de Python? Tá no blog também. Criadores de conteúdo como Geoffrey Grosenbach que na época tocava o Peepcode e o Peter Cooper que na época tocava o Ruby Inside? Tão no blog também. Depois da controvérsia que o Alex Payne do Twitter causou com o Rails não Escala eu entrevistei um dos primeiros engenheiros do Twitter, o Blaine Cook, confira no blog. Membros fundadores do Ruby Central e os primeiros rubistas, Chad Fowler, David Black depois Evan Phoenix do projeto Rubinius e Ruby Specs, tão no blog. Rails Core Team Alumni como Jamis Buck e Josh Peek, também tão lá no blog. Enfim, vou deixar a página com as entrevistas linkadas nas descrições abaixo.





Durante esse período entre 2008 e 2016 eu tive a oportunidade de trazer muitos dos principais nomes pra cá incluindo os fundadores do Ruby Central como Chad Fowler, David Black e Rich Kilmer, depois Evan Phoenix. Trouxe gente do Rails Core da época como Matt Aimonetti, Aaron Petterson que é o Tenderlove. Fundador do GitHub Chris Wanstrath, depois Scott Chacon. O Konstantin Haase do Sinatra e Travis-CI. E na última tivemos gente do Ruby Core Team do Japão com a presença de Akira Matsuda. E falando em última, foi no dia 25 de setembro de 2016, que depois de 10 anos organizando eventos de Ruby, eu decidi pendurar as chuteiras.





Como tudo que eu faço fora do meu trabalho principal, eu nunca lucrei nada com os eventos. Vamos dizer que como gerador de conteúdo eu dou um péssimo empresário, porque meu primeiro livro de Rails eu escrevi sem ganhar um centavo porque abri mão dos royalties pra baratear o custo, o objetivo era fomentar o mercado. O blog eu até experimentei colocar ads por um tempo mas era muito feio então desisti e nunca monetizei. Os podcasts que eu fazia com Carlos Brando ou o Rosa nunca monetizei. A Rubyconf eu nunca tive nenhuma compensação financeira. E agora fazendo videos, eu também não monetizo. 





Faz mais de 10 anos que eu gero conteúdo de graça e espero poder continuar fazendo isso. E eu não faço isso porque eu sou um cara legal, pelo bem disso ou pelo bem daquilo. Eu só faço assim porque eu quero. O dia que eu não puder, eu páro. Na minha cabeça eu sempre tive uma noção que se meu conteúdo fosse atrelado a um incentivo financeiro, isso ia me comprometer demais. Isso já aconteceu antes, quando tinha patrocinador ou grupos externos envolvidos. E não tem nada que me irrita mais do que eu não poder falar alguma coisa porque certos grupos não iam gostar. Por isso eu prefiro pagar as coisas do meu bolso pra nunca ser usado como plataforma pros outros.





Quando anunciei minha aposentadoria da Rubyconf Brasil, eu achava que finalmente ia conseguir passar um ano sem ter que pensar em eventos… ledo engano. Em dezembro de 2016 uma idéia apareceu do nada na minha cabeça, eu juro que tentei tirar essa idéia da cabeça, mas aí eu e meu sócio começamos a montar a conferência experimental The Conf, mas isso é história pra outro dia. Agora em 2019 estamos na 3a edição da The Conf, crescendo um passo de cada vez, como aconteceu com a Rubyconf Brasil. Um dia eu juro que páro de fazer eventos. E, de novo, eu quero que o evento seja o mais independente possível, basicamente eu e meus sócios pagamos praticamente tudo. 






Essa história pra mim começou numa quarta-feita a noite em abril de 2006 quando eu me dei conta que quase ninguém no Brasil inteiro tava dando a mínima pra Ruby on Rails ou sequer sabia o que era isso. Eu nunca tinha visto algo assim antes: a tecnologia certa, com os conceitos certos, tudo pronto, e todo mundo ignorando. Eu tinha duas escolhas, me mudar pra São Francisco e tentar a vida em tech startup de Rails, ou tentar começar do absoluto zero no Brasil. Obviamente escolhi a segunda opção e foi assim que eu comecei, com zero seguidores, zero views, zero empresas e zero emprego. 





Preciso agradecer muito meu primeiro chefe de Rails, o Carl Youngblood que achou meu blog lá no começo e me mandou uma oferta de trabalho remoto pra Surgeworks. A coincidência é que o Carl foi missionário no Brasil. Ele é mórmom de Utah. E ele fala português brasileiro quase perfeito, com sotaque brasileiro e tudo, foi muito bizarro ver um gringo falar melhor português do que eu falo inglês. E foi assim que me tornei o primeiro brasileiro da equipe e pra onde eu levei diversos nomes que você deve conhecer hoje como Carlos Brando, o Rodrigo Kochenburger que mencionei no começo, o Marcos Tapajós do Rio de Janeiro, o Renato Carvalho de Brasília que depois fundou a Startaê e vários outros.





Com a missão de evangelizar Ruby e Rails no Brasil eu embarquei numa jornada de palestras por todo o Brasil, fui pra Natal, Teresina, Brasilia, Fortaleza, Campos no Rio, Xanxerê, Londrina, Porto Alegre, Curitiba, Salvador, Rio de Janeiro, São Carlos, Campo Grande, além de ter tido a oportunidade de fazer amigos como o Nihn e Hongli da Phusion na Railsconf de Portland em 2008, ter ido pra Las Vegas pela primeira vez na RailsConf 2009, ter conseguido palestrar pela primeira vez num evento internacional na RailsConf 2010, onde eu conversei pela primeira vez com o DHH, com o Bob Martin e muitos outros, e de lá fui palestrar em Buenos Aires na Locos x Rails, em Moscow, em Amsterdam, em Tel Aviv em Israel que certamente foi um dos países mais fascinantes que eu já conheci, e finalmente em Tokyo em 2011 onde eu pude conhecer o grupo por trás do desenvolvimento do Ruby, incluindo seu criador, o Matz, que assistiu minha palestra sobre como a comunidade de Ruby cresceu no Brasil. Ao longo de 10 anos eu devo ter dado umas 200 palestras no Brasil e no mundo, foi uma jornada absurda que eu não imaginava que pudesse acontecer naquela quarta feira a noite em 2006.




Não podia deixar de relembrar os rubistas que nós perdemos. O Jason Seifer, que foi parceiro de Gregg Pollack no RailsEnvy nos deixou em abril de 2017. O excelente blogueiro de Ruby e criador de bibliotecas como o resource controller original, anterior ao inherited resources nos deixou 3 dias antes de acabar 2014. Ezra Zygmuntowicz nos deixou em Dezembro de 2014. O simpático e saudoso Jim Weirich que inspirou toda uma geração a se importar com testes nos deixou também em 2014, em fevereiro. 2014 foi um ano ruim onde, por diversas razões, perdemos excelente pessoas na nossa comunidade.




Falando em Jim Weinrich se você gosta da linguagem Ruby devia se exercitar num de seus legados, o site Ruby Koans com diversos exercícios diferentes do que vocês está acostumado e que vai te fazer pensar bastante. E na mesma linha temos o Ruby Quiz do James Edward Grey II com mais dezenas de exercícios. São excelentes opções pra você que quer juntar seus amigos pra aprender Ruby, como desenvolver com TDD, no formato de Dojo.





Ruby on Rails já completou 15 anos. Foi uma década e meia de mercado e até hoje ainda temos um mercado enorme, onde rubistas ainda estão entre os desenvolvedores mais bem pagos do mercado e onde o framework ainda é o pacote mais completo, tanto do ponto de vista do framework em si e do ecossistema que se formou ao redor. É o pacote mais pragmático pra montar uma tech startup, salvo raras exceções em componentes especiais que podem ser feitos em Elixir ou Go. Mas se você não quer ter dores de cabeça, você ainda escolhe Ruby on Rails. E se precisa de exemplos, não precisa ir muito longe, o GitHub que você talvez já use todo dia é Ruby on Rails, o gigante Shopify foi um dos primeiros a usar Rails e usa até hoje, o AirBnb é Rails, Kickstater é Rails, a Bloomberg ainda usa Rails, o Twitch usa Rails, Zendesk é Rails, Hulu que foi adquirida primeiro pela Fox e agora pela Disney é Rails. 





Uma das coisas que muita gente critica é que Ruby on Rails é um framework que se tornou quase um monopólio dentro da comunidade Ruby, temos alguns micro-frameworks como Sinatra e outros menores que tem seu lugar, mas depois do incidente do Merb, nunca mais outro framework chegou perto de competir. Muita gente usa isso pra dizer como em Java, PHP, Javascript tem muito mais opção. Só que isso é um problema na verdade, porque todo mundo pega uma escolha diferente e isso fragmenta a comunidade. Agora você como desenvolvedor muda de empresa, vai encontrar um projeto com bibliotecas e estruturas e estilos completamente diferentes. Toda vez você tem uma curva de aprendizado maior e você nunca realmente domina, é o caso de virar um Jack of all trades, master of none. Como em Ruby, todo projeto em Rails é parecido, quando você muda de empresa, encontra o mesmo ambiente e já é produtivo imediatamente. Por isso andamos tão rápido em tão pouco tempo, porque além disso todo o ecossistema de bibliotecas, produtos e soluções só precisava focar num único framework e com isso nasceu Heroku, Travis, CodeClimate, New Relic. 




Levou anos pras outras comunidades começarem a entender um pouco disso e agora no Python meio que Django é a escolha padrão, em PHP o Laravel é a escolha padrão, em Elixir o Phoenix é o padrão, em Crystal o Lucky ou Kemal são padrão, no Java não tenho certeza se Play ou Spring é mais usado, no Go não tenho idéia de qual é padrão mas acho que não tem, são várias opções, em Javascript nem me pergunta, não quero nem pensar nessa zona. 




A única outra comunidade na época que pôde usufruir desse fator, pelo bem ou pelo mal, foi o ASP.NET da Microsoft. A diferença é que o ASP.NET original era baseado nos paradigmas que tínhamos no J2EE do fim dos anos 90 e que foi justamente o que o Rails veio combater em 2004. E em 2004 nenhuma outra linguagem tinha opção parecida. Levou anos e anos até finalmente chegarmos no estágio de hoje, onde todo mundo finalmente está trabalhando mais ou menos “on Rails” que quer dizer com foco em qualidade, em entregar valor, em usar as práticas ágeis, usando essa geração de SaaS e IaaS com bons repositórios de código como GitHub ou GitLab, bons gerenciadores de projeto especialmente os derivados do Pivotal Tracker, embora os derivados de Trello também quebrem o galho, boas soluções de deployment de Heroku a soluções da AWS. E até a Microsoft cedeu e com o ASP.NET MVC ele se aproximou dos paradigmas do Ruby on Rails também.





O modelo de desenvolvimento de software se divide em antes e depois de 2004. E tudo que construímos nos 10 anos seguintes até 2014 é o que usamos até hoje em 2019 como o estado da arte. Eu queria falar dos últimos 8 anos desde 2011 mas vou parar por aqui e quem sabe retomar num próximo episódio, mas o objetivo de hoje era registrar o que eu lembro que foi importante pra mim no começo da história e qual foi a importância do surgimento do Ruby on Rails e porque vai ser muito difícil algo parecido acontecer de novo: o DHH teve a sorte de lançar o produto certo na hora certa, com diversos acontecimentos por todo o mercado convergindo no tipo de solução que ele apresentou. O produto certo, feito com os princípios corretos, escolhendo as tecnologias e paradigmas que mais tinham chance, e conseguindo convencer o grupo certo de pessoas, inspiradas pela vontade de se expressar com código em vez de só seguir patterns chatos corporativos e fazer produtos enterprise que ninguém ligava.




Mas sendo muito honesto eu acredito que a influência do Ruby on Rails foi até mais ou menos 2012. Depois disso finalmente as demais comunidades adotaram práticas similares e apareceu uma nova classe de problemas pra resolver. O tipo de coisa que você precisa pra ter um Whatsapp, Discord, Hangouts, Facebook Messenger. Eu diria que é onde o problema original do Twitter finalmente atingiu o mainstream e realmente passamos a resgatar o modelo do Erlang em outras linguagens como Clojure, Go, Elixir, e o meio tapa buraco que foi Node.js pra esses casos. Depois de 2012 que as linguagens mobile se modernizaram com Swift e Kotlin. E também foi depois de 2012 que o Docker apareceu e a conversa sobre devops ganhou um level up culminando com o surgimento de ferramentas e plataformas como Terraform e Kubernetes. 




Com tudo isso dito, missão cumprida! Por hoje eu fico por aqui. Se ficaram com dúvidas mande nos comentários abaixo, se curtiram mandem um joinha, não deixem de assinar o canal e clicar no sininho pra não perder os próximos episódios. A gente se vê semana que vem, até mais!
