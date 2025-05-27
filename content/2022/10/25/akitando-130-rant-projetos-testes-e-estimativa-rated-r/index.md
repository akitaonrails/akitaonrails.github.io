---
title: "[Akitando] #130 - Rant: Projetos, TESTES e Estimativa??? | Rated-R"
date: '2022-10-25T10:30:00-03:00'
slug: akitando-130-rant-projetos-testes-e-estimativa-rated-r
tags:
- testes
- tdd
- gestão
- projetos
- equipes
- estimativa
- agile
- metodologia
- akitando
draft: false
---

{{< youtube id="H_-7o_pLn1s" >}}

Finalmente vou discutir um pouco sobre Programação Orientada a Testes e o que isso tem a ver com gerenciamento de projetos, equipes, e um pouco sobre como todo mundo ainda encara estimativas da maneira errada.

Este video é pra você programador, gerente, cliente, empreendedor, que tem dificuldades de entregar projetos de qualidade. Vamos entender tudo que vocês estão fazendo de errado e porque dá errado.

== Conteúdo

* 00:00 - Intro
* 01:13 - CAP 01 - Suas Premissas estão Erradas - Esqueça Bullshit
* 05:33 - Programadores não são Pedreiros!
* 08:31 - CAP 02 - Provas de Conceito - Comecem a Fazer!
* 13:01 - CAP 03 - Programação Orientada a Testes - Comecem a Fazer!
* 17:53 - Demonstração de testes de Firefox
* 19:02 - Demonstração de testes de React
* 19:27 - Demonstração de testes de Tailwind
* 19:57 - Demonstração de testes de Django
* 20:28 - Demonstração de testes de Laravel
* 21:06 - Demonstração de testes de VSCode
* 22:14 - Demonstração de testes de Rust
* 24:02 - Demonstração de testes de Spring Boot
* 27:25 - Vocês não SABEM fazer testes!
* 28:45 - CAP 04 - Como a falta de Testes afeta Produtividade? A Raíz do Ágil
* 32:27 - Como é um fluxo de trabalho Ágil?
* 37:01 - CAP 05 - O que significa Estimar? Estimar não é Prever
* 47:27 - CAP 06 - Removendo Maus Elementos. Não acumule problemas.
* 50:07 - CAP 07 - Resumindo os Princípios: O Mínimo pra Começar
* 52:27 - Bloopers

## SCRIPT

Olá pessoal, Fabio Akita

Vamos dar uma pausa na série de videos técnicos. Se não assistiu ainda, fiz uma minissérie falando sobre redes e logo em seguida começando a falar sobre Linux. Como foi muita coisa técnica, eu me entediei, então resolvi mudar a marcha hoje pra falar sobre gerenciamento de projetos, em particular finalmente quero discutir sobre o famigerado desenvolvimento orientado a testes. É um puta tema cabeludo que daria pra fazer um canal inteiro sobre, mas a idéia é discutir só alguns pontos básicos, pra iniciantes no assunto mesmo. Então vamos lá.



(...)





Se você já tem experiência, trabalha em grandes empresas e grandes projetos, certamente vai discordar de algumas coisas que vou falar hoje e não está errado. Processos de gerenciamento de projetos de software variam bastante e devem ser customizados especificamente pro seu tipo de empresa, pro seu estilo de trabalho em equipe. Não existe nenhuma metodologia que vai se encaixar magicamente em todos os lugares. Simplesmente não existe, é inútil tentar fazer isso. Eu falei sobre isso no video de Esqueça Metodologias Ágeis. Recomendo assistir esse também depois.







A expectativa é que existe algum conjunto de procedimentos que toda equipe consegue seguir pra manter os projetos estáveis e eficientes. Certamente deve existir algum tipo de PMI, Agile, CMMi, bla bla bla Alguma fórmula que o Spotify, o Netflix, a Microsoft, alguém inventou, que resolve todos os problemas. E não tem. Quanto mais cedo aceitarem isso, menos dor de cabeça vão ter. Se você se ver dizendo "a gente segue o modelo Spotify" ou segue qualquer modelo, certamente está fazendo errado. Veja no meu video do Guia Definitivo de Organizações.







Além disso, se você é um empreendedor não-técnico, certamente assistiu um monte de palestras motivacionais, bullshit de startups e tá fazendo um monte de coisas erradas. Eu fiz 3 videos pra vocês também, o de Empreendendo Errado com Software e o video em duas partes dos 10 Mitos sobre Tech Startups. Vou tentar não repetir o que já disse lá, então assistam depois também.







Vamos lá, no final do dia, você, como membro de uma equipe de desenvolvimento de software, precisa entregar alguma coisa que seu chefe ou seu cliente precisam no produto deles. Ou mesmo no seu próprio produto. Se for iniciante, é muito mais fácil integrar uma equipe que já existe, que tem membros experientes e processos já em andamento. Um iniciante sempre vai fazer errado da primeira vez, especialmente sozinho. Não tem como acertar de cara sem nunca ter feito, e isso não é um defeito, é natural. São muitas peças móveis que você nunca viu funcionando. É que nem eu dar um carro desmontado e mandar montar tudo e ainda funcionar direito no final. Impossível.








Vai parecer que é simples, só encaixar as peças e apertar os parafusos. Mas não é só encaixar. Precisa monitorar cada pedaço, testar, ver se não tem vazamentos, se tá tudo alinhado, balanceado, etc. Porque se sair só montando tudo sem testar nada, quando terminar e tentar ligar o carro, vai explodir. Ou, o mais provável, nem vai ligar, e ninguém vai saber porque. E agora que tá tudo montado, vai precisar desmontar tudo e ir testando. No mínimo vai ser uma grande perda de tempo.








Antes de mais nada, você precisa de pelo menos um membro da equipe um pouco mais experiente. Nem vou dizer sênior porque não quero ficar tentando definir hoje o que é junior ou sênior, mas alguém que já entregou no mínimo um projeto de sucesso. Porque essa pessoa precisa se responsabilizar pelas decisões técnicas. Decidir qual framework, bibliotecas, módulos, como as coisas vão ficar organizadas, como vai ser feito deployment. E lógico, todo mundo da equipe pode e deve contribuir com idéias, sugestões, mas alguém precisa bater o martelo e todo mundo seguir em frente. 







Senão toda hora se perde tempo com discussão inútil. Um grupo cheio de opiniões que leva horas ou dias pra decidir as coisas é ineficiente e o resultado sempre vai ser uma droga. Aliás, se isso acontece, é um bom sinal que o tal sênior responsável é ruim. Nenhuma equipe respeita alguém que só fala mas não faz. Um bom sênior fala menos e mostra mais, ensina como faz na prática. E o melhor é errar cedo, ter evidências de porque a primeira decisão deu errado, e isso servir de input pra uma segunda decisão melhor. Do que ficar horas discutindo o melhor caminho, pra no final dar errado de qualquer jeito.







Isso talvez seja a coisa mais fundamental numa equipe. Errar antes e consertar rápido é infinitamente melhor do que horas e horas de discussão tentando chegar em consenso e bikeshedding. Ninguém tem certeza? Foda-se. Cara ou coroa. Faz um teste. Vê se funciona. Se falhar, agora veja porque falhou, conserta, e segue em frente. Essa é a essência do processo de lidar com o desconhecido. Todo mundo pensa que quando algo é desconhecido o certo é tentar planejar infinitamente até ter todos os passos minuciosamente detalhados. Mas tá errado. É desconhecido, qualquer planejamento que tentar fazer, quanto mais detalhado for, mais errado vai estar.







Acho que esse é o ponto principal da discussão de hoje. Quando você e sua equipe são inexperientes, das duas uma, ou vão andar super lento porque vão tentar planejar em excesso, discutir em excesso, ou vão ser kamikazes retardados que vão começar a fazer e só ir fazendo sem parar pra ver se estão indo na direção certa. Ambos estão errados. Não consigo entender porque o desespero não leva ao mais óbvio, que é errar cedo, consertar rápido e o mais importante: garantir que o que já foi feito e está certo, não quebre à toa, porque isso seria o equivalente a andar pra trás.









Não tem nenhum problema rascunhar o que precisa ser feito. Faça um checklist de funcionalidades. Faça post-its com cada tarefa. Faça uma planilha. Não importa. Todo mundo da equipe precisa ter uma noção geral do que precisa ser feito. Mas não tente detalhar em excesso. Só coloque detalhes no que estiver muito incerto, no momento em que precisa ser feito e não com meses de antecedência. Portanto, qualquer um que tenha estudado engenharia de software ou gerenciamento de projetos tradicional, e viu coisas como requisitos, casos de uso, ou até mesmo stories, pára. Você só precisa de uma lista, curta, com poucas palavras. Não é pra levar dias escrevendo, é pra levar horas, no máximo. Vou voltar nesse ponto mais pro fim.









Não importa quantos diagramas, fluxogramas, photoshops ou words vocês produzam, nada disso é o software. Pra um amador, dá impressão que o ideal é ter o máximo de páginas de requerimentos detalhados quanto possível. Tá errado. Essa noção errada vem pelo seguinte: qualquer projeto de engenharia civil, pra fazer uma casa ou um prédio, precisa de meses de planejamento, várias plantas baixas, diagramas de encanamento, diagrama elétrico e tudo mais, pra garantir que o prédio seja construído perfeitamente dentro das especificações.








Portanto, software deveria ser a mesma coisa. Vamos fazer quinhentas páginas de diagramas UML, que é o equivalente a planta baixa, porque daí, quando for escrever o software propriamente dito, vai sair tudo perfeitamente dentro das especificações. Essa premissa está errada. Todo mundo acha que um programador é um pedreiro. Não querendo desvalorizar o trabalho de pedreiros, mas um programador, na realidade, é o arquiteto. O trabalho de pedreiro, é 100% automático desde sempre. O pedreiro de software é o compilador ou interpretador. A planta baixa É o código fonte do software. Portanto todo programador, quer ele queira ou não, faz trabalho de um arquiteto.








Lógico, se sua linha de trabalho é só instalar Wordpress pra diversos clientes. Não se está produzindo software novo, só copiando e colando o que já existe e esse trabalho, sim, parece mais uma linha de fábrica. Mas estamos falando de fazer software que não existe, quase do zero. Reusando vários componentes como frameworks ou bibliotecas, sim, mas o software final não seria possível fazer numa linha de fábrica. Cada passo no desenvolvimento desse software requer tomadas de decisões de cada programador envolvido. Não existe receita.








O famoso exemplo de fazer um botão com cor na tela. Dá pra fazer de dezenas de jeitos diferentes. Posso fazer todo o CSS e HTML do zero. Posso escolher usar um Tailwind da vida. Mas se escolher isso, não pode ser só pra um botão, o certo é usar em todos os botões e elementos gráficos de todas as telas. Eu quero isso? Posso escolher fazer todo o sistema de eventos do zero ou usar React ou Vue. Mas de novo, isso vai afetar todo o sistema. Qual minha equipe tem mais facilidade pra usar? Já tinha começado como um sistema em Angular? Se eu decidir que quero usar Vue no lugar, quanto custa reescrever tudo? Vale a pena? 








Tudo são decisões. Muitas sem grandes consequências, mas algumas podem quebrar seu projeto inteiro se feito de forma irresponsável. Como se toma esse tipo de decisão? Não tem receita pra isso. Na maioria das vezes, seu prazo tá apertado, e o ideal é não escolher decisões que envolvam jogar tudo fora e fazer tudo de novo, então isso já elimina várias escolhas. Mas algumas são incertas, se der certo talvez vocês ganhem produtividade pra frente. Pra isso se fazem provas de conceito.








Todo mundo ignora o poder das provas de conceito. Prova de conceito ou protótipos são pedaços de código, uma pequena parte da aplicação, que deve ser feito com o objetivo de potencialmente jogar fora depois. Portanto não precisa ser integrado ao código principal. Pode ser feito como uma branch do repositório, o que num GitHub chamamos de pull requests ou num GitLab chamamos de merge requests. Tecnicamente é um desvio no repositório de código. Enquanto todo mundo continua trabalhando no tronco principal, a branch `main`, alguém trabalha nesse desvio, num galho, por alguns poucos dias, pra ver na prática se a mudança sugerida realmente trás benefícios ou não.









Provas de conceito tem que ser um empreendimento curto, um micro-projeto de prazo fixo. Coisa de 2 dias, uma semana no máximo. Mesmo estando incompleto, no final desse período deve dar pra equipe ver na prática como a idéia se materializa em código, os impactos que causa, e se todo mundo está confortável em seguir em frente. Daí pode até jogar fora esse galho e todo mundo voltar pro tronco principal aplicando seja lá qual seja essa mudança técnica. Ou então se prova que a idéia era mais complexa do que se imaginava, e todo mundo descarta essa idéia. Mas isso não foi perda de tempo.








Você tem 10 grandes dúvidas técnicas que podem custar muito tempo, coisas no nível: devemos usar React ou Vue? Devemos ficar no Postgres ou migrar pra Firebase? Devemos ficar só em APIs REST ou já começar tudo em GraphQL? Vamos dar deploy das coisas em Vercel ou criar Terraform pra AWS? Só que ninguém da equipe nunca teve muita experiência em nenhuma dessas coisas. Cada uma pode potencialmente custar 2 a 4 meses. Sua equipe só tem 3 pessoas. Então fácil, se for fazer tudo, não vai sair por menos que 10 meses pra equipe, e com a falta de experiência, fácil vai virar o ano.







Em vez disso, pára tudo, cada um da equipe vai fazer provas de conceito de cada coisa, num prazo máximo de 2 semanas. E esse prazo é fixo, depois de 2 semanas vamos ver o que saiu. No final, mais da metade dessas coisas se provam realmente mais complicadas ou o custo claramente não vai compensar. Em vez de ir em frente com 10 coisas incertas que vai custar pelo menos 1 ano pra fazer, vocês concordam agora em desistir de 7 delas, porque a prova de conceito deu evidências que não vai dar certo. Por outro lado, 3 dessas coisas se provaram boas, e vocês vão seguir em frente.







Ao custo de 2 semanas da equipe, vocês economizaram mais de meio ano de trabalho que ia dar errado, e vão prosseguir com 3 coisas que vão custar um mês da equipe e que todo mundo tem mais certeza que vai dar certo. Esse é o grande truque: não se comprometa com coisas de longo prazo que ninguém tem certeza. Pague um tempo curto pra descobrir se dá pra cobrir essa incerteza. Não é jogar tempo fora, é pagar um pouco pra não jogar muito mais fora. Essa noção deveria ser simples, mas na minha experiência, pouca gente parece entender que mais vale a pena jogar fora 2 semanas do que se comprometer cegamente com um projeto incerto que vai levar um ano. 







Na cabeça de muita gente, como 1 ano tá longe, fica aquela sensação de "vamos indo, lá na frente a gente vê como faz". Especialmente em tech startups que vivem de dinheiro de investimento, esse tipo de decisão errada acontece muito, porque afinal é muito mais fácil gastar o dinheiro dos outros. E mesmo quem tem que gastar do próprio bolso, fica apreensivo com essa noção de "jogar 2 semanas fora". Só que não é "jogar fora", é o mesmo que pagar um seguro. 







Ninguém gosta de pagar mil reais, dois mil reais, todo ano, que ao final do ano, parece que não serviu pra nada. Só que se durante esse ano tiver um acidente, e você atropelar e machucar alguém, agora não é dois mil reais que vai custar, vai ser 100 mil, 200 mil reais. Quem faz economia porca e fica de bravata achando que "não precisa, não vai acontecer", é o primeiro que se envolve em acidentes e depois fica falido. Em projetos é a mesma coisa. Se for coisa que você já faz várias vezes antes, o risco é baixo, já sabe o que tem que fazer, tem noção de quanto vai custar e mais ou menos sabe o que pode ou não dar errado, então consegue ir em frente. Mas se nunca fez, é melhor fazer um teste antes de decidir.








E caindo no dia a dia de programação, é esse o mesmo argumento de porque falamos que todo programador deveria fazer, no mínimo, testes unitários de tudo que está trabalhando. Toda nova funcionalidade, deveria ser coberta de testes. Toda correção de bugs, deveria começar com um teste que simula o bug, pra que já comece falhando, e você sabe que corrigiu quando esse teste passa. Não só isso, esse bug em particular não vai acontecer de novo. Todo teste que você começa escrevendo antes de fazer o código, é como uma mini prova de conceito antes de tentar fazer uma coisa que não tem muita certeza. Se não tem certeza, comece escrevendo um teste.








Muitas pessoas já me pediram pra fazer um video sobre testes, mas eu realmente não tenho vontade, porque testes é um assunto que tem já toneladas de documentação, livros, tutoriais, cursos, blog posts, PDFs gratuitos online, pra cada linguagem diferente, pra cada framework. Testes não é um troço que você aprende em 5 minutos e faz igual pra sempre. É um conjunto de técnicas. O ideal é um junior parear com alguém mais experiente e aprender na prática: quando precisa fazer, e com que nível de detalhes. É muito importante que sua equipe tenha pelo menos uma pessoa mais experiente que entende a importância de ter testes e oriente os demais a fazer.








Deixa eu fazer o sales pitch de 2 minutos de porque todo programador deve fazer testes, de porque nenhum pull request pode ser mergeado sem testes, e porque uma pessoa que se diz sênior e é contra fazer testes, por definição, não deveria se considerar sênior. Toda regressão é tempo e dinheiro jogado fora. E o que é uma regressão?







Regressão é exatamente o que o nome diz. Se até este momento, digamos que alguém de QA testou tudo e tinha zero bugs. Alguém me faz um pull request que ficou trabalhando sem integrar por duas semanas. Sem testar. E dá merge na master. Faz deploy, e o que acontece? Surgem um monte de bugs. Não só na funcionalidade que ele tava trabalhando, mas em outros lugares que antes funcionava. Esse amador regrediu o trabalho de todo mundo. Tudo deu passos pra trás. 







Agora o certo é dar revert nesse pull request, reverter mesmo. Só que esse pull request não tem mais como voltar atrás, porque dar deploy, ele alterou o schema do banco de dados e não tem como voltar mais ao schema anterior sem um grande downtime. Um desastre. E, claro, tenha certeza que esse indivíduo fez esse deploy na tarde de sexta-feira. Lógico. Cancela o happy hour porque a noite de sexta vai ser longa, fim de semana adentro, pra consertar essa cagada.








O fluxo é simples: todo programador, seja fazendo testes-antes ou testes-depois, quando diz que concluiu seu pull request, também adicionou um mínimo de testes, fez rebase com a master, e indicou pra equipe que tá tudo pronto. Alguém da equipe sempre deve avaliar esse pull request, normalmente alguém mais experiente. Pelo menos pra bater o olho e ver que não tem nada que parece muito mau feito ou muito fora do lugar e, principalmente, se tem testes. Se não tiver, já rejeita.








Se for uma equipe minimamente bem equipada, está usando repositórios privados de Git seja num GitHub ou GitLab. Ambos tem suporte a rodar testes automatizados num serviço separado. Nesse momento ele já puxou o que está nesse pull request, subiu um container de docker, e executou os testes automatizados do projeto. E quando o avaliador for checar o pull request, já vai saber inclusive se os testes passaram ou não. O GitLab tem a própria ferramenta que é o GitLab CI, de Continuous Integration. Tem diversos serviços externos que integram com GitHub como CircleCI, Travis CI, Semaphore e outros. É super simples configurar no seu projeto e não vejo nenhum motivo pra não usar.








Se o pull request parece que está ok, e o CI diz que os testes passaram, só agora é permitido fazer merge desse código novo na master. No mínimo, sabemos que as funcionalidades que funcionavam antes, cobertas com testes, continuam funcionando depois, mesmo com a inclusão desse código novo. É um bom indicativo pra toda a equipe que as coisas estão andando pra frente, e não ficando com débito técnico acumulado pra trás. Eu vi um tweet alguns dias atrás, de alguém que tava relatando como um idiota da equipe resolveu atualizar a versão do Java, acho que do 16 pro 18 e fez deploy pra produção. Óbvio que deu pau. Óbvio que o pau apareceu na sexta-feira.








Tem idiota que acha que porque usa uma linguagem compilada, com tipagem estática como Java, não tem problema não ter testes, porque se tudo compila, obviamente é porque funciona. Não tem nada que é mais certificado de júnior, do que pensar assim. Ahhnnnn como assim? Voltando ao exemplo de software livre. Vamos ver o projeto do navegador Firefox. Sabe Firefox? Sim, aquele Firefox. Eu baixei o código aqui na minha máquina. Firefox é feito na maior parte em C++, um pouco de Rust, um pouco de Javascript. É um navegador bem estável e quem usa acho que raramente tem algum problema dele renderizar errado, crashear ou coisas estranhas assim.








Se você é desenvolvedor de front-end, certamente já usou o Developer Tools certo? Pra debugar o que está programando. E esse Developer Tools tem uma suite de testes, pra garantir que toda nova versão, antes de lançar pra você baixar na sua máquina, passa todos os testes e não introduz nenhuma regressão. Ou seja, tudo que funcionava numa versão continua funcionando na mais nova. No repositório de código fonte, só rodar `mach test devtools/*` e olha só, abre a versão que acabei de compilar direto do código fonte e roda uma suite de testes de integração, simulando cada funcionalidade do Developer Tools. É assim que a Mozilla garante que código novo não introduz regressões óbvias.








Se der uma fuçada no código, olha só, cada diretório tem um sub-diretório de testes. E muitos deles tem testes específicos pra bugs que foram reportados. Assim eles garantem que bugs corrigidos também não vão aparecer do nada de novo. Bugs que foram corrigidos e aparecem de novo porque não tinha um teste pra cobrir, se chama "jogar dinheiro fora". Porque tem que corrigir mais de uma vez. Ao longo do tempo, você está perdendo tempo, dinheiro, eficiência, e mercado pra outro projeto que vai fazer melhor que você com menos recursos.








Tem gente que acha que porque é programador front-end, não precisa se preocupar com testes. Acho que todo mundo gosta do projeto React do Facebook, quer dizer "meta", certo? Eu baixei aqui o código fonte da biblioteca React. E olha só, se rodar `yarn test`, o React tem uma suite de testes feita em Jest. Pelo mesmo objetivo. Mais de 7 mil testes unitários garantem que quando você atualiza o React, não vai quebrar tudo.







Sabe aquela biblioteca de estilos, o TailwindCSS? Um amador poderia imaginar que é só uma coleção de CSS, obviamente não precisa de testes, certo? Errado. Eu baixei o código fonte do Tailwind e adivinha, se rodar `yarn test`, mais testes unitários em Jest. Quase 900 testes unitários, fora checagens com eslint que por acaso deu alguns erros. Eu baixei do branch principal, ainda estão mexendo e na próxima versão esses bugs serão corrigidos. Mas está claro o que funciona e o que não funciona pra quem está contribuindo.







Bah. Esse povo de front tá muito fresco. Ficar fazendo testes é coisa de hipster. Certamente povo de Python, mais calejado, mais raíz, não se importa com essas besteiras. Por isso eu baixei aqui o código fonte do framework Django. E olha só, tem um diretório chamado `tests` e dentro eu posso rodar esse script chamado `runtests.py`. E lá vai ele rodar centenas de testes pra garantir também que versões novas do Django não tá quebrando nada que já funcionava antes. Mais de 16 mil testes. Passando bonitinho.







Foda-se povo de Javascript e Python. Vamos mudar pra PHP. PHP sempre foi conhecido por ser Quick and Dirty, rápido e sujo. Código raíz. Programador Cowboy que programa orientado a gambiarra. POG-zão na veia. Eu baixei aqui o código fonte do framework Laravel que é um dos mais usados hoje. Só que não. Eu posso rodar `composer exec phpunit` e olha só, quase 8 mil testes, de novo, pra garantir que a versão mais nova não introduz nenhuma regressão. Por acaso falhou, povo ainda tá mexendo, próxima versão estável certamente já vai ter corrigido esse bug. Mas nós sabemos que tem o bug, porque tem suite de testes.







Aliás, sabe o editor de textos mais usados por programadores hoje? O tal do Visual Studio Code? Provavelmente até você assistindo que não gosta de testes aí usa pra fazer seus códigos porcaria. Eu baixei o código fonte também e tem testes automatizados rodando `yarn smoketest`, que segundo a documentação deles, é rodado antes de gerar o binário final que você baixa pra instalar. Igual o Firefox, tem testes de integração onde abre o aplicativo e vai testando cada funcionalidade que a gente aceita que simplesmente funciona em toda nova versão. E tudo só funciona, porque tem testes pra garantir isso. 







E voltando ao Firefox. Parte dele é feito em Rust. E pra você, seu infeliz, que ainda acha que só porque o código compila, tá tudo bem? Não era o Rust que tem o tal compilador mais inteligente de todos os tempos? Que muita gente acha que é mágica e garante não só binário super performático como se tivesse sido feito em C e sem bugs de gerenciamento de memória e problemas de segurança? Muita gente só falta dizer que o compilador escreve o código pra você, de tão bom que ele é. Certamente, se o código em Rust compila, não precisa de testes, certo? 







Bom, eu baixei o código fonte da biblioteca Tokio, que é o framework pra desenvolvimento assíncrono em aplicativos feitos em Rust. Todo projeto Rust acompanha um arquivo `Cargo.toml`, assim como todo projeto Javascript acompanha um `package.json`. E assim como existe npm ou yarn, em Rust temos o comando `cargo`. `cargo install` é equivalente a um `npm install`. E adivinha, o próprio cargo, ferramenta padrão que já vem com o Rust, tem essa opção `test`. E o que isso faz? Vamos ver. Só executar `cargo test`. Olha só ele rodando a suite de testes da biblioteca Tokio. 







Ou seja, nem mesmo um projeto em Rust, que é armado com o compilador que é considerado a obra prima dos compiladores, evita os autores do Tokio de não fazer testes. Aliás, pode ver, ele sai rodando centenas de testes, não é um ou dois. Ahhh mas só de compilar já devia ser suficiente ... não, sua múmia paralítica, os criadores do Rust armaram o Cargo pra rodar testes. Você acha que você, logo você, entende mais do que os criadores do Rust? 








E você que é de Java e também detesta testes, que tem essa noção atrasada de porque o Java compila, tem tipos estáticos, então se compila tá tudo certo. Você que acha que só linguagens dinâmicas não compiladas como Ruby ou Javascript que precisam de testes. Sabe onde nasceu o conceito de TDD? Foi com Kent Beck, que fez o primeiro jUnit, em Java. Desde os anos 90 a gente sabe que só porque alguma coisa compila, não quer dizer que funciona. Só porque compila não significa que bugs não foram introduzidos. E por ficarem cansados de toda hora ter que correr atrás do próprio rabo, de ficar corrigindo coisa que já funcionava, que os agilistas originais formalizaram o conceito de testes.








Aliás, falei de Java e não mostrei Java. Só de exemplo, baixei o código fonte de um dos frameworks web mais usados que é o Spring Boot. Rodando o bom e velho `gradlew build` olha só. Baixa todas as dependências, junto com a internet inteira duas vezes, e roda todos os testes automatizados na sequência. O build só é considerado ok se compila e os testes rodam sem erro até o fim. E são milhares de testes. Ué, mas não era só compilar que já tava garantido que funciona? Obviamente não. 








Muito antes de existir o conceito de TDD a gente já fazia testes automatizados de um jeito ou de outro. Toda empresa de software madura faz testes. É por isso que seus programas e seu sistema operacional não quebram o tempo todo, toda hora. E mesmo com tudo isso, ainda assim bugs acontecem. Significa que se não tivessem todos esses testes, teríamos ordens de grandeza mais bugs em tudo. Novas versões iam demorar ordens de grandeza mais pra sair. Ia precisar de ordens de grandeza mais pessoas testando. Mas não. Hoje em dia quase todo dia algum programa que você tem instalado ganha uma versão nova, mas você raramente é incomodado. Bugs acontecem, mas são raros. E a razão disso é que todo software maduro, proprietário ou de código aberto, tem testes.








Veja meu blogzinho feito em Ruby on Rails. Ele é ridiculamente simples. Eu mesmo que fiz em 2012. Não lembro se foi em Rails versão 3 ou 4. De lá pra cá eu atualizei até o Rails 6 rodando em Ruby 3. Toda vez que sai versão nova da linguagem ou do framework, eu atualizo, pra ganhar as correções de segurança principalmente. Eu venho atualizando faz 10 anos. E toda vez atualizo as bibliotecas também. Mas diferente do tweet da pessoa que falou que o cara atualizou o Java e subiu pra produção. Antes eu rodo meus testes em Rspec. Se não passa, obviamente não subo. Faço pequenos ajustes quando precisa, se a API de alguma biblioteca mudou. Mas meus testes pegam a maior parte dos problemas. Uma vez por ano, gasto 30 minutos, atualizo as coisas e subo. 








Ter testes não é burocracia, não é perda de tempo. É um seguro. Não fazer testes é a mesma coisa que dirigir sem seguro. Na maior parte do tempo, não parece ter muito valor mesmo. Sempre dá pra fazer tudo rápido, sujo e na gambiarra. Você se sente o herói de entregar as coisas rápido. Mas é inevitável, sua produtividade, e da sua equipe, vão gradativamente caindo. Porque mais e mais se perde tempo corrigindo bugs do que fazendo coisa nova. Em breve, a maior parte do seu tempo é só corrigindo bugs. E o que o amador fala? Ahhh, vamos mudar pro framework mais novo. Vamos mudar pra linguagem mais da hora. Quantos de vocês conseguiram manter e atualizar o mesmo sistema por uma década?









Não existe nenhuma linguagem inventada na história que só pelo fato de compilar garante que não precisa ter testes. Todo mundo que entendia isso já fazia testes de alguma forma. A gente fazia alguns scripts separados do código pra rodar partes que eram mais sensíveis se quebrasse, ou que sabíamos que sempre alguém fazia merda e quebrava. Era uma das coisas que separavam os amadores dos espertos. O que aconteceu foi que as comunidade ágeis deram nomes aos bois e criaram convenções e semânticas pra todo mundo falar a mesma língua. Mas não existiu uma data especial que divide antes, com zero testes, e depois, com testes. Foi gradual, onde décadas atirando no próprio pé naturalmente levaram os programadores mais experientes a chegar na mesma conclusão.








Enfim. O problema é que a maioria de vocês assistindo detesta fazer testes. A desculpa é perda de tempo. Mas a verdade é porque vocês não conseguem fazer. Vocês acham que ninguém percebe. Todo mundo que se sente incapaz de fazer alguma coisa, tenta denegrir esse alguma coisa. E é óbvio, não sabe fazer porque nunca faz. Assim como tudo em programação, fazer testes depende de treino e prática. Não existe nenhum livro ou curso que dá pra ler e automaticamente sair fazendo testes perfeitos. 







Você que é front, assistiu um curso e já saiu criando interfaces do nível de complexidade de um Canvas instantaneamente? Ou precisou de semanas e semanas apanhando de CSS obscuro? Ou você que é back, só leu um tutorial e já saiu criando APIs perfeitas em GraphQL integrado com backend de Firebase? Em 5 minutos já saiu codando como se não houvesse amanhã? Duvido.







Não adianta ficar só procurando coisa pra ler. Precisa praticar. Assim como tudo que já fez, todos os seus primeiros testes vão ser uma bosta. Mas é assim que começa. Eu citei vários projetos de código aberto. Dá uma olhada nos testes deles pra se inspirar. Tem centenas de outros projetos mais parecidos com o que estiver trabalhando agora. Baixa e lê os testes deles. Copia. Altera. Testa. Joga fora. Começa de novo. Repete. É assim mesmo.







Outra desculpa é falar que o projeto já tá faz meses ou até anos sem nenhum teste. É o cúmulo da preguiça ouvir isso. Ótimo. Faça você o primeiro teste. Pelo menos essa uma funcionalidade que acabou de entregar, está coberto e vai ser mais difícil de aparecer bug aleatório pela falta de atenção de outro programador depois. E se alguém pisar em cima do seu código, só de rodar esse um teste, dá pra saber que quebrou, quem foi, em qual commit, e corrigir mais fácil. De 1 teste em 1 teste, a cobertura naturalmente aumenta. 








Alguém reportou um bug? Abriu um ticket? Faça o teste que simula o bug reportado. Agora corrige. Pronto, esse é 1 bug que dificilmente vai aparecer de novo. E olha só, do nada, você começou a andar pra frente em vez de ficar só olhando pra trás. E total de cobertura? Precisa ser 100%? Isso é outra pergunta idiota que sempre aparece numa discussão de quem é desleixado. Foda-se. Você não fez nem 1% ainda, pra que quer discutir 100%? Não interessa. Faz 50%, faz 500%. Só, faz, a, porra, dos, testes. 









O que acontece é o seguinte. Sua equipe tem 3 pessoas. Cada um consegue pegar 2 ou 3 tarefas do backlog por semana. 6 a 9 tarefas entregas toda semana. Se o sistema começa a ser usado por usuários de verdade, rapidamente começam a aparecer bugs e problemas. Surge 1 ticket, 2 tickets. De repente a equipe só consegue entregar 3 a 6 tarefas por semana, porque precisa resolver bugs urgentes. Mas continua entregando coisas. Só que essas coisas novas, causam mais bugs. Na próxima semana a produtividade caiu pra 2 a 4 tarefas. E o número de bugs aumenta em vez de diminuir. Em pouco tempo, a equipe male male entrega 1 ou 2 tarefas novas, o resto do tempo é só resolvendo bugs.









E qual a decisão do gerente do projeto? "Ah, é normal, precisa contratar mais programadores." Ele convence a diretoria. Dobra a equipe. E voilá, a equipe volta e entregar 6 a 9 tarefas novas por semana. E todo mundo continua sem se importar com testes ou qualidade em geral, é crunch, só entregar e entregar. O volume de código só aumenta, ninguém joga nada fora, vai só acumulando débito técnico. Mais código novo significa mais bugs. No final acontece a mesma coisa, nas semanas seguintes a produtividade cai pra 3 a 6 tarefas, depois pra 2 a 4 tarefas, e de novo, a nova equipe, com o dobro de integrantes, tá male male entregando 1 ou 2 coisas novas por semana, o resto é só apagando incêndio.








Digamos que todo mundo é ruim em testes. Se lá no começo tivesse decidido entregar tudo com testes, em vez de 6 a 9 tarefas, a equipe estaria entregando só de 4 a 6 coisas, talvez menos. Parece bem ruim. A diferença é que vai ser 4 a 6 TODA semana. Surgiu um bug novo? O programador que pega pra corrigir adiciona testes, e segue todo o processo que descrevi antes. Esse bug em particular não aparece de novo. Entregou coisa nova? A suite de testes garante que o que tinha antes não quebrou por conta disso. E assim, toda semana, de forma sustentável, a equipe entrega 4 a 6 tarefas. Não é o máximo de 9, mas não cai pra 1 ou 2.









Daí a empresa decide contratar mais gente e dobra a equipe. Mas a equipe é diligente e treina os novos integrantes sobre a importância de qualidade. A produtividade quase dobra, de 4 a 6 pra 8 a 10 tarefas. A produtividade só dobra se todo mundo segue o protocolo, ninguém pisa no calo de ninguém, e tudo que já foi feito e testado continua funcionando no futuro. Todo upgrade de bibliotecas e correções de segurança tem garantia que o sistema continua funcionando, porque a suite de testes tá passando. Daí nenhum deploy de upgrade feito na sexta feira causa desastre que vai precisar varar fim de semana corrigindo. Olha só que mágico.









Muita gente vai inventar um monte de desculpas pra não fazer testes, e eu garanto que pra cada desculpa nós já temos soluções. Nenhum programador precisa rodar a suite de testes o tempo todo se essa suite demora muito pra executar. Basta rodar alguns poucos ao redor do trabalho que está fazendo naquele momento. Daí sobe um pull request que vai ser pego por um GitLab CI e esse servidor de CI é quem vai rodar a suite inteira de testes. Não só isso, se a suite passar, esse CI pode fazer CD, que é continuous deployment, e automaticamente subir em ambiente de staging e notificar a equipe de QA.






Obviamente eu não posso mostrar projetos confidenciais dos meus clientes, mas posso mostrar esse projeto interno que nós usamos. Olha um pull request. Se olharmos o que mudou podemos ver que além do código, temos ajustes em specs também, que são testes. Quando o desenvolvedor subiu o código, o CI pegou e iniciou o job pra rodar os testes. Nesse caso levou pouco mais de 5 minutos. Passou com sucesso e, lógico, só porque todos os testes passaram não significa que não tem nenhum bug, só que não tem nenhum bug muito óbvio. Mais do que isso, no nosso caso tem configurado também checagens de segurança. No ecossistema Ruby temos coisas como Brakeman, que avalia o código por buracos de segurança conhecidos como injections. 






Essa aplicação sobe no Heroku, que tem uma funcionalidade chamada review apps. Podemos ter um deployment separado de testes pra cada pull request que ainda está aberta. Justamente pra alguém conseguir testar de verdade antes de aprovar. Um review app é um ambiente de staging, só que isolado pra cada pull request. Dá pra ter dezenas de review apps em paralelo. Assim não precisa ficar acumulando e integrando tudo no mesmo ambiente de staging pra testar, o que seria uma zona. Testa tudo isolado. Vai aprovando no ritmo do responsável pelos testes. E no final, quando estiver tudo testado, aprovado e mergeado no branch principal, daí faz um deployment pra produção aqui do lado.








Neste exemplo, no dia que fui tirar foto de tela, não tinha nenhum pull request aberto. Mas eles apareceriam listados aqui. Cada um com uma URL separada de testes. Esse é outro motivo de porque eu sempre recomendo Heroku. Ele não é o mais barato, mas esse tipo de recurso facilita o fluxo de trabalho em ordens de grandeza. Só as horas de desenvolvimento que se economiza de cada desenvolvedor já se paga. 









Enfim, uma vez cada pull request de cada desenvolvedor sendo aprovado, tudo vai sendo integrado no branch principal e podemos fazer um deploy de tudo integrado pro ambiente de staging. Agora o pessoal de QA pode fazer o trabalho deles direito, que é testar as coisas novas, e não ficar retestando tudo de novo que já funcionava antes. Todo report de bugs volta pro programador, que faz a correção e ajusta os testes pra cobrir os casos que não tinha pensado. 







Com o pull request foi ajustado, os testes passam, QA já viu em staging, o sênior da equipe pode dar a última olhada e fazer o merge na branch principal. E aí alguém de devops ou alguém responsável pela produção pode pegar o que está na branch principal e fechar uma versão pra produção, com a segurança de saber que se está na branch principal, então está funcionando corretamente. 








E se estiver usando Heroku, ainda tem uma facilidade extra. Digamos que todo mundo fez tudo direitinho, mas mesmo assim surgiu um bug que só aparecem em produção. Basta ir nesta aba de atividades e clicar em roll back pra voltar pra versão anterior. Heroku é caro, mas é nessas horas que ele se paga. Medo de deploy na sexta-feira só existe em equipes disfuncionais que não fazem esse básico que acabei de falar.








Falando em disfuncional, o maior desafio em toda equipe de projetos, é coordenar a comunicação. Ao ter um repositório de códigos como Git, um processo de testes de integração contínua, pareamento entre sêniors e juniors pra compartilhar conhecimento, e um protocolo como de pull requests, estabelecemos um conjunto simples e objetivo de entendimento nessa equipe. Não seguir esse protocolo é um desrespeito à equipe. Você não programa pra você mesmo, você contribui com sua equipe. O importante não é andar rápido, o importante é não estragar o que já funcionava. 







Da mesma forma, ninguém deve sair adicionando coisas no projeto que ninguém está sabendo. Por isso que no mundo ágil se inventou os tais rituais como de planejamento e revisão. Rituais não devem ser obrigações, mas pontos de coordenação. Se os rituais estão sendo meramente pras pessoas aparecerem mas não participar, então não servem pra nada e devem ser eliminados e repensados. Esse é um ponto não-técnico que não quero tentar detalhar demais, mas preciso falar de um ponto específico: estimativas.








Se tem uma coisa que programador odeia fazer mais do que testes é estimar tarefas. Já disse isso em outros videos, mas existem duas palavras que todo mundo não-técnico confunde: estimar e prever. O programador estima, mas os gerentes ou diretores acham que receberam previsões. Estimativas são ordens de grandeza, não está certo nem errado. É uma ordem de grandeza. Previsões sim, é pra serem precisas. Quando um programador diz que pode levar uns 2 ou 4 dias, é isso que pode levar, 2 a 4 dias. Talvez leve 5. E aí o gerente que achava que tinha uma previsão na mão, fica puto, porque tava esperando 2 dias, recebeu em 5 e quer sair chutando tudo. E é isso que eu chamo de um idiota.








Eu acho que todo gerente de projetos deveria gastar um tempo movimentando o próprio dinheiro no mercado financeiro. Comprar e vender ações, ou opções, ou criptomoedas, não importa. Porque todo mundo gostaria de saber pra onde vai o mercado, se vai subir ou se vai cair. É impossível acertar 100% do tempo. Se alguém soubesse prever isso, quebraria o mercado financeiro. O máximo que podemos fazer é dar chutes educados. Estimativas. A gente tenta acertar, comprar na baixa, vender na alta. Ou no mínimo planejar pra alta e se proteger da baixa. Criamos contingências, e sabemos que é impossível ganhar sempre. O máximo que podemos fazer é tentar minimizar perdas. E as perdas nunca vão ser zero.









Gerenciamento de projetos é a mesma coisa. Um gerente inteligente não se interessa em tentar prever cada tarefa individualmente. Ele observa o movimento geral da equipe e do produto. Tá em tendência de alta de produtividade? Baixa de produtividade? Tem como influenciar a baixa? Qual é o obstáculo? Algum diretor deu carteirada e quebrou o planejamento? Alguém ficou doente? Um bom gerente está numa posição que um analista financeiro não tem: de influenciar as tendências. 






Lógico, quanto mais um programador ganha experiência e tem mais segurança no que realmente sabe e o que não sabe, mais e mais suas estimativa se aproximam de previsões. Ele já tem uma boa noção de quanto tempo leva a maioria das coisas. Quanto mais inexperiente, mais longe vai ser essa estimativa. Faz parte do crescimento profissional de cada um começar a quantificar suas próprias capacidades. Ninguém tem obrigação de "acertar" estimativas, mas claro, quanto mais precisas forem, mais todo mundo consegue confiar mais e mais em você. É uma das formas de subir na carreira. Entregar o que promete.







Tarefas, stories ou seja lá como quer chamar, são meras formalidades. Quanto mais curtas, objetivas, direto ao ponto forem, melhor. O objetivo não é um concurso de literatura onde todo mundo tem que fazer uma dissertação. A quantidade de palavras deve ser o suficiente pra que toda a equipe envolvida saiba no que está sendo trabalhado. Só isso. Tem quinhentos blog posts, livros e cursos tentando ensinar "a melhor forma" de escrever requerimentos. E a maioria é bullshit. Quer dizer, até faz sentido, pode ser usado como inspiração, mas não existe nenhuma receita que dá pra só seguir. Assim como testes e estimativas, escrever requerimentos também depende de prática. Estude o que se sugere, mas não siga ao pé da letra.








User Stories tem aquele formato idiota de "eu, como usuário, quero conseguir adicionar um produto no carrinho e ter o total do pedido, para poder pagar minha compra" ou algo assim. Pode ser, é bonitinho, tem o objetivo de forçar as pessoas a pensar em pra quem é a funcionalidade sendo feita, qual o objetivo e facilitar pensar na melhor forma de fazer. Tem coisa que precisa de mais detalhe que isso. Um protótipo de tela no Canvas. Um rascunho de conta de imposto. Tem coisa que nem precisa de tanto detalhe assim. Bugs costumam ser mais diretos "quando o usuário abre no firefox de mac, o box de items fica em cima do box de cartão e não dá pra digitar o código de segurança do fucking pedido e a fucking compra não finaliza". Tá super claro.








Eu tive um cliente que o imbecil do CTO mandava todo programador descrever em detalhes como ia programar, antes de escrever uma linha de códigos. Tinha que listar que classes novas ia criar, com que métodos, com quais nomes. Era a coisa mais idiota que eu já vi, só perde pra época que povo achava que precisava fazer diagramas de classe UML precisos meses antes de escrever uma linha de código. É idiótico. É da época que falei que se achava que programador era só pedreiro e havia uma forma mágica de descrever tudo, antes de escrever o código. É uma noção boçal.









O resumo é simples: a descrição deve ser a mais concisa, com o menor número de palavras possível. A equipe deve conseguir se reunir e em pouco tempo entender o que precisa ser feito, quem vai fazer, quem precisa de ajuda. O gerente, ou Product Owner, e o equivalente tech lead ou programador mais sênior, deveriam estar alinhados. Daí quando seja lá qual programador entregar o pull request praquela funcionalidade, o tech lead consegue avaliar rápido e mandar pro QA. O PO e o QA precisam estar alinhados, pra ver se o que foi entregue resolve o que se queria resolver. 







Burocracia e formalidades em excesso aparecem em empresas onde esses personagens tem preguiça de conversar ou pior: não sabem o que estão fazendo. Porque se soubessem, poderiam ir direto ao assunto. Toda burocracia em excesso é defendida por aqueles que não sabem o que estão fazendo, porque aí podem usar a desculpa de "mas, mas, eu segui os procedimentos, a culpa não é minha". Toda burocracia é uma muleta pra cabideiro que não deveria estar ocupando as posições que estão ocupando. É assim simples. 








Voltando pra estimativas. Não existe nenhuma fórmula nem procedimento que, dado uma descrição em texto de um caso de uso, ou user story ou seja lá o que for, chega num número de horas ou dias exatos pra resolver essa tarefa. Cocomo e outras bullshitagens são lixo. Não tem como. Só a experiência dos programadores envolvidos é capaz de dar uma ordem de grandeza, cuja qualidade vai ser proporcional à experiência da equipe. Se a equipe for super experiente, mesmo assim vai ser uma ordem de grandeza. 








Não tem nada mais retardado do que gente que pega esses números de estimativas, número de horas realizadas, vai pondo num gráfico e fica tentando derivar coisas desses números, fazer integral, aplicar fórmulas. Só porque se tem números, não signfica que existe cálculos que dê pra fazer. Eu posso sair jogando dados, colocar todos os resultados num gráficos e gerar um monte de conclusões. É assim que nasce pseudo-ciência, numerologia, astrologia e todas essas logias idiotas. Estimativa é um chute. Estimativas nunca estão erradas, porque não são previsões. Fazer contas com esses números não faz nenhum sentido.








Dá pra saber que vai ser perto de 6 meses mas menos de 1 ano. Agora, se vai ser 5 meses, 2 semanas, 4 dias e 5 horas, exatamente. Isso é impossível. Gastar horas tentando estimar tudo é um exercício de futilidade. Não perca tempo tentando prever com exatidão. Aprenda a lidar com ordens de grandeza. Simplesmente escreva o que se sabe que realmente precisa fazer. E nem tente detalhar 6 meses de trabalho de uma só vez. É inútil. Descreva o curto prazo em detalhes, 1 mês, no máximo 2 meses de trabalho. Tenha a direçao do longo prazo em mente, mas ajuste enquanto vai andando. Deixe a equipe se dividir em quem faz o que. E siga o que falei até agora sobre pull requests e merge.








Mesmo sem ter estimativa nenhuma, você como gerente ou como qualquer membro da equipe vai ver que numa semana a equipe entregou 10 tarefas, stories ou seja lá como quer chamar. Na semana seguinte, entregou 9. Na outra semana conseguiu entregar 11. Na semana seguinte entregou 7. O que o gerente ou facilitador dessa equipe começa a notar? Uma tendência. Parece que, seja lá como se descreve tarefas nessa equipe, eles conseguem entregar uma média de 8 a 9 unidades dessas "coisas". E se for esperto, vai notar que quando entrega menos coincide quando sobe versão nova pra produção, daí o suporte recebe reports de bugs, que entram no backlog da equipe e isso diminui a quantidade de "coisas" entregues.








O gerente fala com o tech lead, que revê o processo, e vê que ele tava deixando passar pull requests com testes não tão bons. Ele pareia com o programador júnior que tava fazendo errado. Ensina na prática onde tava errando. E agora ele passa a produzir melhor. E é assim que uma equipe evolui, um passo de cada vez. Não é via metodologia, nem aumentando formalidades e burocracias, é via bom senso. Resolvendo problemas na raíz em vez de ficar inventando band-aids, ou pior, mais burocracias inúteis. E o principal: reorganizado a lista de coisas a fazer pra garantir que as coisas mais importantes estão sendo feitas primeiro e tudo que é opcional ou de pouco valor está no fim da lista. Assim, caso não dê tempo de fazer tudo, pelo menos você sabe que o mais importante foi feito.








Cuidado, não estou dizendo que não se deve perder tempo descrevendo tarefas ou que não se deve fazer estimativas. Estou falando que a formalidade não é tão importante, tem que começar a escrever e aceitar que vai estar mau escrito. Aceitar o feedback de que o programador fez errado porque do jeito que tava escrito ficou ambíguo. E aí vai ajustando os detalhes pra próxima vez, até o nível que faz sentido. "Ah, se tivesse descrito essa conta com um exemplo, ele teria entendido", ou algo assim. Aceitar que uma estimativa nunca vai estar certa ou errada. É só uma referência. Não tente fazer projeções baseado em estimativas, porque isso só vai multiplicar um erro com outro erro.








Em vez disso veja em ordens de grandeza como falei. Seja lá como organiza as tarefas da equipe, veja, no geral, que tipos de funcionalidades ou correções de bugs a equipe entrega num certo período de tempo, como toda semana. Daí nem precisa perguntar pra equipe se o que tem no backlog cabe ou não na semana. Você já sabe essa resposta pela velocidade que já conhece. Quando sabe que não vai caber, seja honesto e faça seu trabalho: corte ou simplifique. Não tem mágica. Se não cabe, não cabe. Se tentar fazer caber, obviamente a qualidade vai cair. É onde vai vir o "se eu pular fazer testes, talvez caiba". E quando se cede uma vez, isso vai acumular. Na semana seguinte já começa a vir a conta. E uma decisão feita no desespero numa semana, vai prejudicar todo o resto do andamento daqui pra frente.








Não existe almoço de graça. Toda vez que vai se deixando passar uma pequena coisa errada, isso vai acumulando. Em breve, vai estar tudo errado. Ser sustentável é exercitar disciplina. E não tem coisa mais maçante, mais entediante, do que ser disciplinado. Quando tudo é uma bagunça, é difícil elencar os problemas. Mas numa equipe disciplinada, fica fácil ver quem tá puxando a equipe pra trás. Sem ter a muleta da burocracia, fica fácil ver quem é a pessoa inconstante, aquele que promete demais, entrega de menos, e quando entrega outra pessoa precisa consertar. A equipe inteira sabe quem é essa pessoa. Eles devem ensinar, ajudar, mas quando a pessoa é resistente a trabalhar em equipe, ela deve ser removida. É assim simples.








A decisão errada é manter essa pessoa e contratar outra pra aumentar produtividade. Muitas equipes que eu já vi teriam a produtividade aumentada só de cortar os maus elementos, porque agora eles não precisam ficar consertando o que o mau elemento tá entregando de mau jeito. Automaticamente a produtividade aumenta, o stress diminui, todo mundo trabalha melhor. Uma coisa que aconteceu durante esse período que já passou de vacas gordas, com montes de empresas contratando gente ruim no atacado, é que em vez de aumentar a produtividade, eles prejudicaram a qualidade do produto e das equipes. Imagina um monte de gente ruim, fazendo o contrário de tudo que falei até agora. Só acumulou um monte de código porcaria que funciona em produção na força bruta, com alguns poucos hiper estressados, varando noite, consertando a porcaria que recebe.









Se a equipe não se importa com o que está entregando, nada do que eu falei até agora importa. E todo novo integrante, ao ver que ninguém tá realmente muito interessado, vai aprender do jeito errado: que o melhor é ligar o foda-se e fazer igual todo mundo. E é assim que um projeto entra em colapso, porque ninguém está ligando. Em empresas com dinheiro dos outros demais, é o que mais acontece. Mas se sua empresa realmente depende do código sendo feito, sinto dizer, rapidamente todo mundo vai perder o controle. E daí pra frente é só cavar o buraco mais fundo. 









De novo. Todo projeto é uma incerteza, especialmente nos primeiros dias. Especialmente se for uma equipe nova, recém constituída. Precisam aprender a trabalhar juntos ao mesmo tempo que precisam entender o que diabos vão construir. É uma montanha de incertezas. Por isso o ideal é garantir que o básico do básico está garantido: que pelo menos o que está sendo entregue vai continuar funcionando ao longo do tempo. Exercitem o processo de testes, pull requests, integração contínua, deployment em staging. Daí comecem a ver até que nível de detalhes realmente as tarefas precisam ser definidas. E vai ajustando.








Não tente estabelecer regras escritas em pedra no dia um. É inútil. Comece no equivalente a fazer rascunhos. Avalie se o rascunho está num nível de detalhes suficiente. Se não estiver, vai ajustando. O PO, o UX, precisam ir refinando isso. Daí o QA e o suporte precisam também ir refinando o processo de testes. Esse processo volta pra equipe de desenvolvimento, que reflete se está cometendo deslizes técnicos que poderiam evitar bugs óbvios. Todo mundo ainda estava crú em fazer testes, e aos poucos vai aprendendo a realmente testar os casos que interessam e deixar de lado os casos que não precisa. Naturalmente vão se acostumando a saber até onde precisa ou não cobrir determinados tipos de funcionalidades.











Sério. Exercite sua equipe em usar Git direito, em usar os recursos de testes que certamente já tem no seu framework. Como falei, Rails tem, Django tem, Laravel tem, Spring Boot tem, Express tem, React tem. Todo mundo tem suporte a testes que vocês só escolheram não usar. Só que vocês não são seres ungidos que fazem código sem erros. Pelo contrário, todo programador vai mais fazer erros do que acertar. Especialmente se for júnior. É normal. Só que hoje todo mundo deixa esses erros acumularem no repositório, porque os deploys pra produção acontecem só 1 vez por mês, ou 1 vez por bimestre. Daí toda vez que faz deploy fica todo mundo apreensivo, porque já sabe que vai dar merda. Todo mundo sabe que empurrou os problemas com a barriga. Daí o dia do deploy é o dia da pizza na madrugada. Todo mundo correndo atrás do próprio rabo pra consertar os erros que vão aparecendo. Um caos.








Não seja esse clichê. Faz direito um pouco todo dia pro dia de deploy em produção ser só mais um dia normal, tedioso, sem nenhuma adrenalina, porque todo mundo tem segurança que tá tudo testado e funcionando. Fazer as coisas direito é muito chato, eu sei. Deixa pra fazer código porco gambiarrado nos seus projetinhos pessoais. Mas em projeto dos outros, aprenda a ser profissional. Imagina se seu médico também fizesse programação orientada a gambiarras sem testes como você faz. Imagine se o médico do seu filho fizesse como você faz. Acho que não ia gostar né? Cresce, e age como profissional. Se ficaram com dúvidas, mandem nos comentários abaixo. Se curtiram o video deixem um joinha, assinem o canal e compartilhem o video com seus amigos. A gente se vê, até mais!


