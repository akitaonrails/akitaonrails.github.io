---
title: "[Akitando] #88 - RANT: Selo de Segurança é Marketing | Entendendo o Fator
  Humano"
date: '2020-12-08T09:30:00-03:00'
slug: akitando-88-rant-selo-de-seguranca-e-marketing-entendendo-o-fator-humano
tags:
- segurança
- infosec
- itil
- cobit
- togaf
- sarbanes-oxley
- hacker
- phishing
- engenharia social
- akitando
draft: false
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/wz1Ioqb89Jo" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## DESCRIÇÃO

Esquece Hacker, Mr. Robot, IAs do mal. Vamos entender o principal problema de segurança: o fator humano e como isso leva a processos de segurança que podem ser tudo, menos seguros. E também porque as coisas são como são de acordo com a lei.


Todo desenvolvedor de software precisa entender esse básico. Segurança não é opcional e você não devia achar que é problema dos outros. Antes de entrar em assuntos mais técnicos, garanta que você entendeu os conceitos deste video.

ERRATA: vários já apontaram nós comentários e estão certos, sem pensar disse "tigres na África" mas parece que tigres não são comuns na África, então fica a errata.


Links:

* Vazamento de senhas do Ministério da Saúde expõe pacientes da COVID, diz jornal (https://canaltech.com.br/hacker/vazamento-de-senhas-do-ministerio-da-saude-expoe-pacientes-da-covid-diz-jornal-175307/)
* KnowBe4 (https://www.knowbe4.com/phishing-security-test-offer)
* 2020 Twitter bitcoin scam (https://en.wikipedia.org/wiki/2020_Twitter_bitcoin_scam)
* Guide to COBIT Best Practices (https://reciprocitylabs.com/guide-to-cobit-best-practices/)
* COBIT vs ITIL vs TOGAF: Which Is Better For Cybersecurity? (https://www.upguard.com/blog/cobit-vs-itil-vs-itsm-which-is-better-for-cybersecurity-and-digital-resilience)

## SCRIPT

Olá pessoal, Fabio Akita


Muita gente já me pediu pra falar sobre segurança da informação, famoso infosec, especialmente porque vira e mexe aparece notícias de hackers, invasões e coisas assim. Muita gente me pergunta se deveria instalar um Kali Linux ou Parrot pra começar. E o que eu mais vejo é de novo povo achando que "ser de segurança" é saber rodar metasploit, usar Kali ou participar de eventinhos idiotas pra brincar de hackerzinho. E tá longe, muito longe disso. Milhares que quilômetros longe aliás. Quão longe? A distância de dar a volta ao mundo a pé nem começa a descrever quão longe. Se fosse tão fácil assim qualquer um seria hacker, e obviamente não é.







Eu ia falar de outro assunto hoje, mas resolvi encaixar este porque faz duas semanas teve mais um vazamento de informações, do Ministério da Saúde, com dados de pessoas que fizeram teste de Coronga. E foi um negócio tão esdrúxulo que faz a gente ficar pasmo quando fica sabendo. E parte do que aconteceu eu vou explicar hoje. Pra resumir, um médico subiu uma planilha com dados de pacientes num repositório público no GitHub. Nem acho que foi malícia, mas burrice mesmo, afinal é um médico. 







O esdrúxulo foi o Ministério da Saúde ter confiado e deixado uma agência de fundo de quintal subir um sistema pra cadastrar pacientes que guarda senha em texto aberto. E de terem exportado planilhas pros médicos COM as malditas senhas abertas. É de uma escrotice monumental. O cara precisa ter nascido com talento pra autorizar um jumentice dessas. Parabéns, o mundo não precisa de hackers se vocês facilitam a vida tanto assim, puta que o pariu. Bando de imbecil.







Já aviso que eu não sou nem nunca fui um profissional de segurança trabalhando em tempo integral. Mas nem precisa, um bom desenvolvedor de software precisa saber o básico de segurança e eu posso dizer, com segurança (wink), que pelo menos 90% dos desenvolvedores é de nível tosco pra baixo. Lamentável mesmo. Parece que tudo que sabem sobre o assunto é meme idiota de Edward Snowden ou Julian Assange que, aliás, pra todos os efeitos práticos é um conhecimento bem inútil.







Então, pra expectativa ficar clara, eu não vou entrar em detalhes em nenhuma ferramenta em particular, não vou tentar detalhar a carreira em si, e muito menos vou ensinar ninguém a virar hacker. Acho que só com o básico do básico, que ninguém faz, já vai ficar um episódio grande. Quem for da área pode complementar nos comentários abaixo e talvez eu faça outro mais específico. Mas na minha cabeça não faz sentido alguém se dizer de segurança e estar aprendendo coisas básicas usando um video tutorial de YouTube que ele deveria ler documentações ou lendo o código fonte das coisas. Essa já é a primeira lição de hoje.






(..)






Espero que eu não seja a primeira pessoa de quem vocês estão ouvindo isso, mas tudo que se mostra sobre hackers na mídia é completamente exagerado, senão a série de TV ou filme seria extremamente tedioso. Portanto, não, quase tudo que você viu num Mr. Robot da vida não se aplica. Pra ser justo, eu até sei que existem alguns caras geniais quase nível Elliot, e você provavelmente nunca vai saber que eles existem, porque isso é outra característica de um bom hacker: ser low profile, não ficar se exibindo e chamando a atenção. Quem faz um ataquezinho bosta e fica postando se achando o bonzão é um amador, uma criança. Aceita que a probabilidade maior, de 99,99999% é que você nunca vai ser um Elliot.









Outra coisa, não é que os hackers são gênios russos extraordinários, é que o nível de segurança do que nós desenvolvedores de software fazemos é tão baixo que, de verdade, não precisa ser nenhum gênio pra invadir. Alguns frameworks e bibliotecas tem ajudado a minimizar os erros mais toscos, mas 90% dos desenvolvedores simplesmente não sabe o que tá fazendo. Ele segue o procedimento do tutorial e assume que tá seguro. Eu mesmo, que me considero cuidadoso, cometo erros básicos de segurança de vez em quando, imagina um iniciante. Quanto mais cedo você se educar sobre o assunto, melhor você vai ser como desenvolvedor, e mais valor vai ter. Não precisa virar hacker, só fazer o básico mesmo porque em terra de cego, quem tem um olho é rei.









Se você tem o mínimo de interesse no assunto precisa entender algumas verdades universais. Só porque ninguém detectou uma vulnerabilidade, não significa que o produto é seguro. Só significa que “ninguém detectou a vulnerabilidade”. Vocês conseguem entender essa diferença? Só porque ninguém invadiu sua casa até hoje, não significa que sua casa é segura. Só significa que ninguém se interessou em invadir ainda. E normalmente você só vai entender o quão inseguro é sua casa quando estiver amordaçado no banheiro com um invasor apontando uma arma pra sua orelha. 








E nesse dia é tarde demais pensar em segurança. E eu sou neurótico sabendo que tem pessoas específicas que ficam tentando saber onde eu moro e maliciosas o suficiente pra burlar um porteiro, que eu mantenho uma destas escondido em casa pro 0.1% de chance de ser invadido. E eu sou da posição que você precisa ser neurótico com o 0.1%.











Daí vem outra verdade universal: não existe 100% de segurança. No caso de computadores, a única forma de garantir 99.9999% de segurança é seu computador estar offline, fora da internet, desligado, e enterrado em alguma montanha da Islândia. E mesmo assim não é 100%. Sempre há a mínima possibilidade de alguém ter acesso físico a essa máquina. Se está ligado na internet, você corre riscos o tempo todo. Todo mundo fica preocupado com as grandes notícias como o Meltdown e Spectre da Intel em 2018. Nossa, fodeu, eu uso Intel por isso estou inseguro. Pára, você já tava inseguro independente disso com esse projeto feito por agenciazinha barata, que faz empresa de fachada pra ganhar licitação de governo, e guarda senhas de cidadãos que fizeram exames em texto aberto no seu banco de dados e ainda distribui essa senhas numa planilha pra outras pessoas, que acabam subindo um GitHub da vida. É o cúmulo da tosquice. E sim, foi algo assim que aconteceu no vazamento do Ministério da Saúde na semana do dia 26 de novembro de 2020. Meltdown e Spectre, ou hackers russos é o menor dos seus problemas. Você deixou sua casa destrancada e colocou uma placa dizendo “sou trouxa, me roube” na frente.











A última verdade absoluta é que você jamais vai estar seguro e pensar em segurança deve ser uma neurose obsessiva que você precisa ter o tempo todo, todos os dias que você for responsável por qualquer coisa que tá online, incluindo seu celular e notebook. Você usa a mesma senha pra tudo, não ativa 2 factor, instala um tanto de app pirata e joguinho chinês no seu celular e vai dando OK em tudo que te pede permissão? Você está, por definição, 100% inseguro. 








Eu odeio a palavra mindset mas sim, tenha um mindset de perseguição. Você está inseguro, neste exato momento pode ter um keylogger gravando tudo que você digita no seu teclado, sua câmera pode estar ligada com a luz que indica tendo sigo desligado, e deve ter um processo em background fazendo cópias dos seus dados sem você saber. Você não sabe que não tem, então você deve assumir que tem. Ou pior, você confiou a senha que você usa em todo site num cadastro de site do governo achando que “claro, um site do governo não deve ser tão inseguro” e acorda no dia seguinte com sua senha exposta porque o governo obviamente contrata cabideiro barato sobrinho de político pra guardar sua senha aberta num banco de dados tosco.









É igual fazer um safari sozinho nas savanas da África. Só porque você não morreu nas garras de um tigre faminto, não significa que você está seguro nem que não existem tigres famintos. Eles só não te encontraram até agora. Você vai dormir a céu aberto ou vai tomar a precaução de montar tenda num lugar alto e com poucos pontos de entrada? E isso é importante, se por um lado você não pode ser imprudente e achar que nada vai dar errado, por outro lado você não pode congelar sua vida e parar de fazer tudo porque tudo é inseguro. Você precisa fazer coisas arriscadas, entendendo o que pode perder, mas mesmo assim ir em frente e criar contingências.









Segurança não é ter 100% de garantia que nada vai dar errado e sim ter consciência de que tem uma alta probabilidade de dar errado, e implementar contingências (faca), backups pro  caso do pior acontecer. Segurança não é só evitar alguma coisa ruim de acontecer, mas ter planos implementados pra agir imediatamente caso o pior aconteça, e com isso minimizar seu prejuízo. No pior caso talvez você perca uma perna, mas não perde todo o resto, e com sorte ainda arrebenta o perpetrador no processo, evitando prejuízos futuros. Gerenciamento de risco é uma arte que vai aparecer em diversas outras áreas, incluindo gerenciamento de projetos, gerenciamento de qualidade, ou no nosso caso, em gerenciamento de segurança.









E aqui vem outra coisa que muita gente não entende. Pra maioria das empresas, segurança é o entendimento das consequências da lei e a implementação de processos que minimizem os impactos da lei caso aconteça uma infração, por exemplo, causada por invasão. Por exemplo, lavagem de dinheiro é uma ofensa criminal. Mas se você fosse o CFO de uma empresa lavando dinheiro algumas décadas atrás, tecnicamente você podia tentar se safar com o famoso "eu não sabia, eu só trabalho aqui". Assim a instituição "empresa" é culpada, mas o Fulano da Silva que controlava o financeiro é inocente. Obviamente muita gente se safava assim e por isso nasceram coisas como Sarbanes Oxley, ou Sarbox.








Eu aprendi isso por volta de 2001 ou 2002 quando estávamos no crash da bolha da internet e surgiram casos como WorldCom e Enron. Em resumo, dentre várias práticas ilegais, a Enron que era um conglomerado de energia, abria várias pessoas jurídicas, tipo vários CNPJ e transferia muitas das liabilities pra elas. Liability, pra quem não sabe, male male se traduz como responsabilidades ou riscos jurídicos. O truque é transferir esses riscos da empresa principal Enron pra essas outras empresas de fachada. Assim, na contabilidade da empresa principal esses problemas não apareciam e com isso enganavam os investidores. E pra piorar ela era auditada pela Arthur Andersen, na época parte do que a gente chamava das Big Five, as cinco maiores consultorias do mundo. E a auditoria teoricamente deveria assegurar que coisas assim não estavam acontecendo.










O caso foi tão grave que a Arthur Andersen foi obrigada a mudar de nome depois disso. O braço de consultoria formou o que hoje você conhece como Accenture e a auditoria Arthur Andersen mudou pra só Andersen. O gigante foi quebrado em vários pedaços, parte saiu da empresa completamente, partes foram pra Ernst & Young e Delloitte, mas a Andersen nunca mais foi a mesma. E por causa de casos como esse da Enron, WorldCom e outras, levou o senador Paul Sarbanes e o representante Michael Oxley a sugerir o ato Sarbanes Oxley em 2002, que todo mundo conhece como Sarbox ou SOX e faz parte do dia a dia de qualquer grande empresa até hoje. 







Em resumo o que mudou é que agora os diretores não podem dizer “eu só trabalho aqui”. Se fraude financeira for exposta, cada diretor pode ser individualmente indiciado criminalmente e ir pra cadeia. O grande lance de uma LLC nos Estados Unidos ou LTDA que é limitada no Brasil, é a limitação de liability, ou seja, separar as responsabilidades do CPF das do CNPJ. Então um crime associado à pessoa jurídica não deveria refletir na pessoa física diretamente. Dica pró: é sempre melhor adquirir propriedades via uma empresa limitada, preferencialmente fora do país, num paraíso fiscal. Você sempre quer ter o menos possível associado à você, pessoa física, porque é menos que pode ser tomado de você se acontecer algum problema.








Mas nesse caso, se você é diretor de uma grande empresa pública, que tem ações na Bolsa, é parte do seu próprio interesse garantir que não exista fraudes financeiras ou muita contabilidade “criativa” que é o termo que usamos na indústria, ou se houver, garantir que ninguém nunca vai saber. A chave aqui pra você aprender é que um crime só existe se ele é descoberto.









O motivo de porque estou contando esse caso é pra ilustrar outra coisa importante em segurança. A intenção, na maioria dos casos, não é em fazer um sistema realmente limpo, seguro e sem buracos e sim em garantir que, caso o sistema seja inseguro, as responsabilidades estejam bem delimitadas. Existe uma diferença muito grande aqui entre garantir segurança e limitar responsabilidades. A prioridade é na segunda opção. Existem muitas empresas que oferecem serviços relacionados a isso: implementação de protocolos de regulamentação, monitoramento, e principalmente um tipo de “seguro” que é basicamente dizer: esta empresa implementou os procedimentos “aceitos” como seguros, segundo a regulamentação tal e tal, e se aconteceu uma brecha de segurança, os envolvidos não devem ser criminalmente responsabilizados. 









Isso é importante porque a intenção não é melhorar as coisas pra serem totalmente seguras. Do ponto de vista técnico, eu disse que é impossível ser 100% seguro, só mitigar e criar contigências, e a implementação de processos e protocolos é uma forma de gerenciar riscos aos envolvidos. Certamente é melhor do que não fazer nada. Do ponto de vista mais cético, tem muito mais marketing na forma como muitas empresas exploram essa tecnicalidade. Você que é consumidor e não-técnico pode achar que porque certo produto online é “auditado” ou tem uma empresa de segurança sendo mencionada, ou tem algum “selo” de garantia, é porque devem ter a melhor segurança implementada. Na prática não é nada disso, é só puro marketing. 









Pra ser justo vamos dar um passo atrás. Quando você é uma tech startup que começou faz pouco tempo, a prioridade é sobreviver. Foda-se segurança. Foda-se governança. Você precisa implementar coisas novas o mais rápido possível, atrair a maior quantidade de usuários possível, e a última coisa que você precisa é um cara de governança adicionando burocracias no seu processo. Povo quer dar push direto na master do Git. No nível amador é assim mesmo. Muitos poderiam pensar, pô porque não fazer direitinho desde o começo, e a resposta é simples: porque fazer direitinho demais custa tempo. 









E a única coisa que uma tech startup iniciante não tem é justamente tempo. Mesmo quando ele ganha um primeiro round de investimentos, ele só ganhou um pouco mais de tempo pra conseguir entregar novas funcionalidades e aumentar a base de usuários pra bater as metas pra ganhar o próximo round de investimentos. De novo, nunca existe tempo suficiente. Assim, tudo que se considera boas práticas acabam ficando de lado, porque do que adianta seguir muitas boas práticas se você pode falir amanhã? E empresa morre e as boas práticas morrem junto.









Mas e se alguém hackear os sistemas e invadir? Nesse estágio inicial, seria até uma boa notícia, porque aos olhos do mundo, se um hacker achou algo de valor nessa tech startup, um investidor poderia entender que talvez essa tech startup valha mais do que se imaginava. Porque se a idéia é uma porcaria, ninguém vai estar interessado nela, muito menos os hackers. De qualquer forma, vai levar algum tempo pra idéia de governança e segurança começar a ficar relevante dentro dessa pequena empresa. Se tudo der certo, digamos que fique grande. Agora ela tem centenas de milhares, talvez milhões de usuários. E pra suportar isso tenha uma infraestrutura com centenas de containers em cloud, talvez milhares ou dezenas de milhares de funcionários, dentre programadores, marketing, financeiro, suporte e tudo mais.









Agora, num estágio desses, que você já é um sucesso estrondoso. Digamos um grande e-commerce, uma grande fintech, a última coisa que você precisa é marketing negativo por conta de ter sido atacado e ter os dados dos seus usuários expostos na darknet. Quando você é muito grande uma invasão significa o que deveria mesmo: que você foi negligente e absolutamente incompetente. E não tem nada mais caro de recuperar do que credibilidade e confiança que foram quebradas de um jeito tão traumático assim. E não estamos falando só de ataques de hackers, mas sim como seu sistema cair do nada e ficar fora do ar por horas, porque faltou governança de infraestrutura e, pior, perdendo dados dos seus usuários no processo.






Qualquer conselho administrativo que se preze morre de medo dessas coisas. E mesmo se não tem medo, vai ter quando precisar fazer operações grandes como um M&A que é sigla pra Merge and Acquisition, literalmente ser vendida pra outra empresa maior, ou abrir um IPO, que é se tornar uma empresa pública. Agora um terceiro vai precisar fazer uma auditoria do que você tem implementado, o equivalente Andersen que falei antes. E se ele não encontrar bons processos implementados, ou seja, responsabilidades bem definidas, grandes volumes de “papel”, a transação não vai acontecer. 










Por exemplo, a CVM do Brasil, a Comissão de Valores Mobiliários não vai autorizar seu IPO. A empresa que queria te comprar, não vai mais te comprar. E é óbvio. Imagina uma empresa que cresceu rápido demais, talvez na sorte até, por momento oportuno do mercado, mas sequer sabe quantos sistemas tem online, que máquinas tem, quem tem acesso a o que, que versões de software estão instalados. Um lugar tão bagunçado assim e grande é uma puta liability, uma bomba relógio que pode explodir a qualquer momento, e todo mundo vai ficar longe de você. Ou você vai atrair só investidores oportunistas com intenção de entrar barato e sair caro rápido.









Num determinado momento do crescimento de uma empresa, não só do ponto de vista de sistemas, mas da administração como um todo, vai exigir uma “profissionalização”. Você vai querer uma boa equipe de contabilidade e auditoria pra garantir que não está correndo o risco de cometer um crime fiscal sem saber, da mesma forma como vai querer uma boa equipe de governança pra garantir que seus sistemas não sejam um desastre esperando pra acontecer, especialmente se no seu horizonte tem eventos como abrir um IPO. É quando você vai começar a ouvir palavrões como o Sarbanes Oxley que expliquei antes e coisas como ITIL, Cobit ou Togaf.








Eu pessoalmente odeio trabalhar em processos. Prefiro vender coco na praia do que ter que lidar com isso. Já tive que lidar com isso e odiei. Não porque é necessariamente uma coisa ruim, muito mais que não é pro meu perfil, porque certamente tem muita gente que gosta disso e é feliz trabalhando nisso. Ei, More Power to You, sou a favor. Então vocês que são de processos e auditoria, não venham me xingar nos comentários porque não é nada contra vocês. Opinião pessoal de um desenvolvedor de software mesmo.








No video que falei brevemente sobre devops alguns meses atrás eu expliquei a diferença de perfis de alguém que é puramente um programador de alguém que é puramente de infraestrutura. Um programador é voltado a mudar os sistemas o máximo possível. No seu ponto de vista, cada nova linha de código que ele faz deveria ir direto pra produção no segundo que ele dá enter nessa linha. 









Pro cara da infraestrutura é o oposto, seu mundo ideal é onde nenhum sistema é modificado nunca, onde uma vez que ele instala e funciona, ninguém nunca mais mexe. Quando a empresa é pequena, a equipe é pequena e os sistemas são mais simples, é muito fácil pro grupo todo saber o que tem e como as coisas funcionam. O programador e o sysadmin vão gritar o dia todo um com o outro, mas eles se resolvem uma hora e tomam uma breja no fim do dia. É a melhor fase de uma empresa, na minha opinião. Por isso tem muito programador que fica pulando de startup em startup, porque ele gosta só desse começo.









Mas quando você é gigante, tem milhares de funcionários e centenas de sistemas, nenhuma pessoa mais sabe exatamente como 100% de tudo funciona em detalhes. E quando alguém sobe uma nova funcionalidade com bug, pode ser impossível rastrear o que causou o crash do sistema. Das cinquenta equipes, que acumularam centenas de modificações, e tudo subiu junto no deploy. Quem causou o problema? Quem vai saber consertar? Pior ainda, foi no deploy que subiu hoje que veio o bug? Ou o bug já estava lá e só agora foi ativado e na verdade foi no deploy da semana passada? Ou do mês passado? 








Agora imagina isso acontecendo todo dia. E como Murphy é o único que trabalha eficiente nesse tipo de ambiente, claro que o crash vai se dar tipo na véspera de uma grande campanha de marketing, onde vai vir milhares de usuários novos que vai esbarrar nesse bug. Mais provavelmente no dia da Black Friday. Rapidamente tudo vira caos, é a pior fase de uma empresa que precisa de crescimento.









É por isso que tanto empresas mais antigas que lidam com TI, como bancos, ou tech startups que cresceram rápido começam a assimilar aspectos de governança. Governança é basicamente um basta no jardim da infância, é a hora de colocar alguns adultos pra limpar a bagunça e, mais importante, evitar mais bagunças. É quando você começa a ver coisas como ITIL por exemplo. Sem entrar em grandes detalhes porque não é o escopo do episódio, ITIL é um framework de processos e boas práticas pra categoria que se chama IT service management. Se você é programador já deve ter ouvido falar pelo menos que existe uma rivalidade contra formas consideradas mais “tradicionais” de gerenciamento de projetos, como o PMBOK. ITIL é como se fosse o PMBOK da infraestrutura e serviços de TI.










PMBOK, por exemplo, não é uma metodologia, ou seja, não é um passo a passo de como gerenciar projetos. Como o nome diz ele é um BOK, um body of knowledge ou corpo de conhecimentos sobre o assunto de projetos. Ou seja, ele acumula tudo que é aceito como mais interessante sobre o assunto pra você estudar. Mas não vai ter dizer o que é melhor pra sua situação em especial. Por exemplo, ele vai listar formas conhecidas pra organizar as tarefas de um projeto, estruturando como WBS ou work breakdown structures e desenhando num Gantt chart. 








Se você vai ou não usar certos itens no seu projeto, depende do projeto. E esse “depende” é a palavra chave. Só quem já usou em vários lugares, errou, e aprendeu com isso, vai ter mais noção de onde usar cada pedaço de conhecimento do PMBOK. Pessoas experientes sabem escolher a meia dúzia de itens que eles sabem que vão funcionar no meio de centenas de opções. Amadores tendem a querer usar tudo de uma vez, mesmo quando não precisa. Por isso existe tanta “consultoria” que, “teoricamente”, saberia escolher as melhores combinações pra cada situação. Bem entre aspas, porque isso é na teoria mesmo.








ITIL é o corpo de conhecimento das boas práticas que foram aprendidas ao longo de anos por muitas equipes em muitas empresas e que foram documentadas e organizadas nesse corpo de conhecimento. Coisas básicas como as formas de se fazer um inventário das máquinas do seu data center. Ou coisas como gestão de incidentes, quando um usuário esbarra num bug, onde ele registra? Quando registrar, quem responde? Onde isso fica armazenado? O que se faz com essa informação? Como você garante que o mesmo incidente não se repita. E assim por diante. 









É quando você começa a adicionar passos de burocracia meio óbvias numa grande organização. Antigamente, o programador da startup tava precisando de um servidor pra subir algo rápido? Ele mesmo podia ir na conta da AWS da empresa, subir um servidor no EC2 e pronto. Só que agora ele adicionou uma máquina a mais na organização que só ele sabe que existe. E se ele for demitido? Como fica essa máquina? Quem mais tem acesso? Numa organização com centenas de programadores seria totalmente caótico se todo mundo pudesse criar servidores. Então isso normalmente é proibido, como parte do processo de governança.









Da mesma forma existem corpos de conhecimento e boas práticas em processos de segurança. É onde entram frameworks como Cobit ou Togaf. De novo, recomendo que pesquisem a respeito se tiverem interesse, mas grosseiramente resumindo, pensem que é como PMBOK ou ITIL mas pra segurança. Cobit parece um pouco com CMMi porque ele define níveis de maturidade. Por exemplo, nível zero é onde está toda startup no começo, uma zona completa. 






Nível um é ad-hoc, tem alguns processos mais ou menos, talvez só uma pessoa responsável em fazer git push pro heroku pra subir pra produção. Nível dois tem procedimentos mas só os sêniores da empresa sabem como fazer, tipo manualmente substituir certificados TLS nos servidores. E assim por diante até nível cinco. Ele parte do entendimento que essa progressão ajuda a aumentar segurança quando você vai diminuindo a variância da qualidade dos procedimentos e processos, e eles são bem documentados e repetíveis com mínimas diferenças. Quanto mais variância existe ou, mais depende das pessoas que estão executando os processos, mais aberto a brechas você fica por erros humanos.









Em todos os grandes frameworks de processos, seja PMBOK, seja CMMi, ou ITIL, ou Cobit, tem pelo menos duas coisas que sempre me chamaram atenção. Eles são focados em processos e procedimentos e indicadores, em criar estruturas, de tal forma a minimizar a necessidade de decisões individuais das pessoas que operam esses processos. Ou seja, criar rotinas bem definidas. Isso porque quanto mais flexível for pra cada pessoa tomar decisões, maiores as chances de erro. E o maior problema tanto de gerenciamento em geral, de governança e segurança em particular é isso: o fator humano.









Isso é um dilema que eu também não tenho idéia concreta ainda de como resolver completamente e por isso grandes organizações sempre vão ter stress. A pequena tech startup era eficiente, ágil e arrojada porque os funcionários tem o maior nível de liberdade pra agir. O maior ativo de uma tech startup é de fato sua equipe, não só programadores, mas todo mundo. E elas sabem disso, a pequena fintech vê nos grandes bancos uma baleia gigante, lenta e ultrapassada que, sendo grande, não tem velocidade pra acompanhá-los. Mas quando essa fintech tem sucesso e começa a crescer exponencialmente, tanto em usuários quanto em funcionários, agora a maior liability que ela tem é justamente sua equipe. Toda tech startup que chega no passo de estar contratando a rodo está dramaticamente piorando sua organização interna. Já passou a fase iniciante da startup arrojada.







Ter sucesso significa quase que necessariamente se tornar aquilo que você queria combater no começo. Ninguém descreveu isso melhor do que Harvey Dent no Cavaleiro das Trevas: ou você morre um herói, ou vive tempo suficiente pra ver você se tornando o vilão. E não tem muito como fazer. Quando você tem agora 10 mil funcionários, ninguém tem como saber mais o nome de todo mundo de cabeça, mesmo se tentar muito, é impossível. Quem contrata não é mais um dos donos, é um mero funcionário de RH. E ele vai errar bastante nas contratações. Digamos que ele erre pouco, só 10%. Pronto, sua empresa automaticamente em pelo menos  mil funcionários que não deveria ter, ou que são incompetentes ou que são ativamente mal intencionados. 









Eu raramente faço propaganda pra terceiros, em particular nunca falo dos meus clientes, mas eu tive um bom dos Estados Unidos que encaixa bem nesta parte do episódio então vou acabar fazendo um pouco de propaganda. Mas fica o disclaimer que não é mais meu cliente e eu não estou fazendo uma recomendação, nem eles me pagaram pra falar deles. Isso dito, a empresa se chama KnowBe4. É uma empresa de treinamento de segurança. Dizendo só isso pode não parecer grande coisa mas eu acho a idéia deles muito boa.








No dia 15 de julho deste ano de 2020 o Twitter sofreu o que se conhece como phone spear-phishing attack. Esse é um nome mais fancy pra dizer: “meu funcionário foi enganado por telefone e deu informações importantes ou acessos a quem não deveria.” Quem assiste filme de hackers fica achando que tem um russo chamado Elliot num quartinho sujo escuro digitando no seu notebook em alta velocidade e acessando os sistemas do FBI. Talvez tenha, mas a maioria esmagadora dos principais casos de ataques se dá da forma mais prosaica possível: você liga pro funcionário da empresa e pede acesso, e muitas vezes você ganha.







E foi exatamente isso que aconteceu, alguém ligou pra alguns funcionários do Twitter e foi convincente o suficiente pra fazer eles darem acesso ao sistema de gerenciamento interno que usam. A ferramenta interna que tiveram acesso permitia mudar o e-mail de confirmação da contas. Com isso conseguiram mudar as senhas, desligaram autenticação de dois fatores, e ganharam acesso de cento e trinta contas de grandes personalidades, como Barack Obama, Bill Gates e muito mais. 







Daí eles partiram pra segunda parte do golpe: fizeram tweets nessas contas com uma oferta da China: depositem bitcoins num certo endereço que eles iam devolver em dobro. E sim, muita gente idiota caiu e eles chegaram a acumular mais de 12 bitcoins antes do Twitter conseguir recuperar o controle e tirar os tweets do ar. Em preços do dia que estou escrevendo este script, isso seriam mais de um milhão de reais. Parece bastante, e é pra um golpe que não durou um dia inteiro, mas é uma gota na água em termos absolutos. Não foi tanto dinheiro assim. É um milhão de reais e não um milhão de dólares.







Isso se chama engenharia social, e sempre foi e vai continuar sendo uma das formas mais simples e mais eficientes de se invadir qualquer sistema. Simplesmente peça o acesso. Consiga informações pessoais de funcionários e isso hoje em dia é fácil, basta olhar no Linkedin, depois stalkear nas redes sociais e você vai saber tudo, nome dos pais, nome do cachorro e tudo mais. Depois monte textos convincentes e fale com assertividade, como sendo o chefe, do departamento de auditoria, do banco ou qualquer coisa assim, diga algumas informações pessoais e peça pra ele confirmar outros dados. Se for paciente, uma hora você vai conseguir o suficiente pra acessar os sistemas internos com as permissões desse funcionário e voilá, de repente você se torna o Barack Obama e faz as ações do Twitter cair 4% no dia seguinte.










E de novo você pensa, puts, deve ser um Elliot super inteligente que fez tudo isso. Que nada, parece que o FBI prendeu uns quatro suspeitos do golpe, tudo moleque. Um de dezenove anos, um de vinte e dois anos e dois adolescentes. Amadores. Tanto que foram capturados. Phishing é uma das formas de engenharia social. Toda vez que você recebe um e-mail, mensagem de zap, ligação de telefônica, alguém se dizendo da receita federal, do banco, ou que é um príncipe nigeriano, ou te oferecendo emprego, é alguém tentando aplicar phishing em você tentando fisgar uma fraqueza pessoal sua. Se eu tivesse que chutar, diria que a grande maioria dos golpes do mundo se dá via phishing e não via alguma forma sofisticada de invasão direta na sua máquina.










Segundo a KnowBe4, noventa e um porcento dos ataques que resultam em violação de dados em grandes empresas, como foi com o Twitter, se dá via spear phishing. É aquele seu funcionário descontente que tá procurando outro emprego e recebe e-mails do LinkedIn com ofertas de emprego que - diga-se de passagem - a maioria hoje é e-mail automático de bots e contas falsas. Alguém mal intencionado acha esse indivíduo porque ele é pouco profissional e fica falando mal da empresa nas redes sociais. Batata, o perpetrador forja um e-mail com uma proposta de trabalho irrecusável, faz parecer um e-mail vindo do LinkedIn e o que o idiota faz? Ele clica nos links que recebe pra participar da suporta seleção, ou compartilha informações que não devia da empresa onde está. Em pouco tempo, o sistema foi invadido.







Uma das coisas que a KnowBe4 faz como serviço é enviar e-mails de phishing de propósito pra todos esses funcionários com perfil vulnerável. Pra saber quem são os idiotas que clicam. E a partir daí eles oferecem treinamento pra essas pessoas, focando direto nos pontos fracos. Outros serviços incluem sistemas pra vasculhar as redes sociais pra encontrar aqueles que parecem mais vulneráveis e fáceis de enganar, e oferecer treinamento também. Ou outros testes como deixar pendrives espalhados pelo escritório, pra ver quem é curioso de plugar na própria máquina. E sim, se você não sabia, USB e mesmo Thunderbolt são conexões com falhas e um pendrive especialmente modificado pode atacar sua máquina. Nunca plugue um pendrive desconhecido que não foi você mesmo que comprou e formatou.









Aliás, se não é óbvio, vamos deixar óbvio: pessoas são fáceis de enganar e roubar porque a maioria não acredita que vai ser vítima e sempre acha que vai ser esperto ou esperta e nunca vai ser vítima de golpes. Todo mundo acredita nisso e mesmo assim todo mundo continua caindo. O sucesso de redes sociais é a prova disso e se você quer entender porque, veja meu episódio sobre O Dilema das Redes Sociais. Todo mundo sabe que redes sociais coletam trocentos dados sobre você, toda hora, todos os dias. Eles sabem quando você não está em casa, porque você compartilha a localização via o GPS do seu celular. Eles sabem quem é sua família. Eles sabem o que você tem comprado. Fazer engenharia social nunca foi tão fácil como agora, graças às redes sociais. 









Esquece conspirações de inteligência artifical do mal ou de hackers russos ou dos chineses. A razão pra se preocupar com privacidade não é porque o governo tá te monitorando ou porque alguém tá ganhando dinheiro vendendo seus dados. É porque seus dados estando publicamente disponíveis tornam ataques de phishing muito mais fáceis pra qualquer amador mal intencionado que sequer sabe fazer uma linha de código direito. Golpistas sempre existiram, desde antes da tecnologia, e sempre enganaram pessoas só falando de forma convincente e, desde sempre, todo mundo ainda continua caindo na lábia.









Muitos programadores se acham mais inteligentes que a maioria da população não-tech porque sabe fazer um pouco de código. Na minha experiência, até hoje eu fico pasmo de ver como um programador, que deveria ser uma pessoa de lógica, consegue ter tão pouca lógica. Você vê no dia a dia, defende causas idiotas, idolatra influencers de quintal, acredita em utopias de conto de fadas e cai em esquemas de pirâmide. Vou dar um exemplo, um conhecido meu, programador considerado sênior, resolveu entrar num grupo de investimento que prometia rendimentos garantidos. A palavra “garantido” já devia ser suficiente pra saber que é golpe, mas vamos lá.









É simples, você deposita o dinheiro mas não pode tirar. Se tirar perde os tais “rendimentos garantidos”. E ele acredita que tá rendendo porque vê o número do saldo no site dos caras sempre aumentando. E ele ficava verdadeiramente empolgado. “Caraca, olha como eu tô ganhando!” E a gente falava, velho, você não tá ganhando. Saca o dinheiro. “Nãaaao se sacar eu deixo de ganhar!” E a gente. “Velho, o cara tá te enganando”. E o cara, “nãaao, o cara é um gênio, já viu o instagram dele? Olha os carrão que ele consegue comprar, ele sabe como crescer esse dinheiro.” E a gente, “Velho! Qual é o seu problema? Ele compra os carrão com o dinheiro que você dá pra ele! Puta que pariu!“ (piiii)







Voltando, eu não entrei em detalhe sobre frameworks como Cobit ou Togaf, mas eles existem porque apesar de você se achar inteligente, esperto e que não precisa de alguém te dizendo o que fazer, os processos estão lá porque a grande maioria das pessoas comete erros crassos, burros mesmo, como a história do golpe. Mesmo gente considerada sênior. E um bom hacker vai começar usando engenharia social, spear phishing por exemplo, e numa organização com milhares de pessoas, não é difícil achar alguém ingênuo que cai em golpes simples. E basta uma pessoa com permissões que não devia ter pra começar o ataque. E boom, alguns minutos depois, você é o Barack Obama no Twitter. E nem precisou de um hacker russo pra isso.









Por isso temos tantos processos de segurança e auditoria em grandes empresas, o que a maioria de nós chamaria de “burocracia chata”. Segurança técnica 100% não existe. Nem com o computador desconectado da internet e desligado. Se alguém tiver acesso ao hardware, ele vai invadir. Um bom cara forense consegue remover dados úteis de HDs destruídos da forma errada. O problema é que um computador enterrado numa caverna e desligado não tem nenhum valor prático. Ele precisa estar ligado e conectado pra ter valor, mas aí ele automaticamente passa a estar arriscado.









Tem gente que tem medo de sair de casa porque tem o risco de ser atropelado por um bêbado. Tem medo de andar de avião porque tem o risco de cair. De fato todos esses riscos existem. Mas mesmo se você ficar todo dia embaixo da sua cama, nem assim você tá 100% seguro. Alguém pode invadir sua casa. Um meteoro pode cair na sua cabeça. Ou você pode simplesmente ficar doente e morrer cedo. O simples fato de você existir sempre vai te trazer riscos. Por isso sempre o mais importante não é buscar risco zero e sim é gerenciar os riscos. 








Gerenciar riscos não é eliminar riscos e sim escolher quais riscos vale a pena tomar porque o retorno parece bom. Ou quais contingências deixar preparado, o famoso plano B, pra mitigar o tamanho do risco pra algo mais aceitável. Carro é perigoso? Sim, então coloque cinto de segurança e ande devagar. Vai eliminar todos os riscos? Claro que não, mas definitivamente vai mitigar. Em vez de morrer talvez só quebre uma perna. É aceitável pelo valor de diminuir seu trajeto de 4 horas a pé todos os dias pra 15 minutos.








Frameworks de segurança como Cobit são processos que ajudam a mitigar os riscos inerentes a ter sistemas de TI bem como criar contingências, plano B, plano C, plano D, e processos pra caso algum incidente ocorra. Não adianta resolver o incidente, tem que garantir que se acontecer de novo o impacto ou vai ser menor, ou o mesmo incidente nunca mais vai acontecer. A solução algumas vezes vai gerar um tanto de inconvenientes, por exemplo forçar uma VPN interna que dá pau de vez em quando. Tokens de autenticação que vira e mexe falham. Procedimentos de documentação e relatórios chatos de post-mortem. Algumas vezes os processos parecem que mais atrapalham do que ajudam e muitas vezes isso é verdade. 









Faz parte do trabalho do profissional de segurança, ou do CSO que é o Chief Security Office, tomar a decisão de bypassar o processo ou mudar o processo caso o custo-benefício não esteja valendo a pena. Isso não é uma coisa que dá pra determinar automaticamente, alguém precisa parar pra pensar, avaliar e tomar uma decisão. O problema de muitas empresas é que quanto maior for, menos responsabilidade o tomador de decisão vai querer assumir, portanto na dúvida, segue o procedimento e não muda nada, mesmo que esteja atrapalhando. 







Não lembro se já contei isso em outro video, mas por volta de 2002 ou 2003 eu era consultor numa grande telecom, uma das top 3 do Brasil. Por causa das políticas de segurança a gente não podia conectar nossos notebooks na rede deles, precisava usar o desktop homologado deles. Rodava um Windows 2000 com usuário bem limitado de permissões. Pra instalar um Winzip precisava ligar no número do suporte e abrir um chamado pra vir alguém instalar. Era chato pra cacete. Mas, o computador tinha um disk drive, sabe de disquete de três e meio polegadas? Eu pensei comigo, bom, a BIOS deve ter senha e vai ser difícil abrir a máquina pra tirar a bateria pra resetar mas tentei entrar na BIOS e porra, tava aberto! Daí mudei a ordem do boot pra ir pelo disk drive.









Peguei um disquetinho que eu já tinha que quebrava senhas de Windows 2000. Criptografia naquela época ainda não era tão boa. Em poucos minutos eu quebrei a senha e ganhei acesso de administrador na máquina. A partir daí eu podia fazer o que bem quisesse. Obviamente eu fiz a mesma coisa nas máquinas dos meus colegas da consultoria e só a gente tinha máquinas abertas sem precisar abrir suporte. Esse é mais um exemplo de uma grande empresa com um monte de processos implementados, mas que de fato não tá garantindo segurança de nada. Se eu fosse um usuário malicioso, poderia fazer coisas erradas ali. Mesmo se tivesse tirado o disk drive e tivesse senha na BIOS, ia dar mais trabalho, mas eu ia desmontar a máquina e tirar a bateria quando ninguém estivesse olhando.








Tem um outro caso que eu nunca vou esquecer. De novo era por volta de 2003 em outra grande empresa daqui de São Paulo. Pense que estamos uns 3 ou 4 anos antes do lançamento do iPhone. A gente não tinha 4G. Era a porcaria de 2G no máximo, nível pior que um modem em linha discada. Ou seja, internet era só o que tinha no wifi de casa ou na rede do escritório. Só que muita empresa grande tinha protocolos de segurança com proxy de http que a gente era obrigado a usar pra acessar a Web. E o protocolo é baseado no conceito de whitelists, ou seja, bloqueia tudo por padrão e vai abrindo chamado no suporte pra pedir pra abrir cada site que precisar. Eu era consultor SAP, a gente precisava da documentação online. Precisava acessar fóruns pra tirar dúvidas. Não tinha stackoverflow mas tinha outros sites da época. E a gente queria acessar sites nada a ver de vez em quando. Não tinha twitter mas tinha Orkut.








Obviamente a primeira coisa que eu fazia quando via um proxy era um http tunnel. Pesquise sobre isso, tem várias formas de fazer, mas é tipo tunelar pacotes http encriptados pelo proxy da empresa pra um servidor externo e de lá ele faz as requisições pros sites que eu queria. Era bem mais simples antigamente porque a gente quase não usava HTTPS porque certificado TLS era muito caro. Então era quase tudo texto aberto. Como os pacotes eram encriptados antes de passar pelo proxy, não dava pra monitorar. Daí por algum tempo eu e meus colegas tínhamos acesso ilimitado à web. De novo, não adianta só seguir um procedimento, colocar um proxy e achar que tá seguro. Precisa entender como essas coisas funcionam.










Mas o povo de segurança parece que sabia e eles estavam monitorando nossos pacotes e vieram encher o saco que a gente não podia encriptar o que passava porque senão eles não conseguiam monitorar. Duh. Daí vieram reclamar com a gente e bloquearam tudo. Daí eu falei com meus colegas e convenci eles a fazerem uma vaquinha. Eu fui no Shopping do lado e comprei um Hub de ethernet. Daí não tinha 4G mas tinha um serviço de internet via rádio chamado Giro, e eu aluguei um modem deles. Daí eu conectei o modem no hub, nossos computadores no hub via cabo ethernet e escondi embaixo da mesa. Daí nossos computadores tinham duas saídas de rede. Eu mudei a tabela de roteamento pra todo IP interno da empresa ir pela rede interna e todo IP externo ir pelo modem, assim a gente tinha acesso a tudo sem problemas.







Passou alguns dias o cara da segurança veio reclamar de novo. Mas dessa vez ele veio querer saber como a gente tava acessando web se no monitoramento dele não passava nenhum pacote vindo das nossas máquinas. Deu vontade de falar, ué, você é o esperto, descobre aí. Não lembro como acabou a história direito mas eu acho que o gerente deu o braço a torcer e falou foda-se, os caras entregam tudo que precisa, não vamos atrapalhar. Que foi uma boa decisão, eu acho. Quer que eu faça meu trabalho, não fica no caminho, só isso. Mas do ponto de vista dos protocolos de segurança da empresa, eles se abriram a um bom risco, sorte deles que a gente era bom.









O objetivo do video de hoje foi só explorar o pico do iceberg, o conceito de por que existem processos de segurança em grandes empresas e como eles não estão totalmente errados, porque a maioria das pessoas representa um risco real pra qualquer empresa. E não porque a empresa é má e não confia nas pessoas, mas porque pessoas não deveriam confiar nem nelas mesmas. A quantidade de golpes só vai aumentar quanto mais gente entra na internet. Antigamente pouquíssima gente usava internet, hoje quase todo mundo usa, e todo mundo vai ser vítima de algum golpe. Não é “se” e sim “quando”. Não assuma que você é mais esperto e por isso não precisa se preocupar, sempre vai ter alguém mais esperto. Assuma sempre que você está inseguro, desprotegido, e comece de baixo pra cima.









O maior problema de segurança é a ilusão de segurança. Só porque você instalou um software de segurança, ou porque tem uma consultoria de segurança do lado, ou mesmo porque você acha que ninguém estaria interessado em você, isso não torna você mais seguro. Num próximo episódio eu vou dar uma introdução a assuntos um pouco mais técnicos. Por agora espero que tenham gostado das histórias. Compartilhem suas histórias nos comentários abaixo. Se curtiram o video mandem um joinha, assinem o canal e compartilhem os vídeos com seus amigos. A gente se vê, até mais.
