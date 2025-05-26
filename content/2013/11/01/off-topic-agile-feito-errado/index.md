---
title: "[Off-Topic] Agile feito Errado"
date: '2013-11-01T10:48:00-02:00'
slug: off-topic-agile-feito-errado
tags:
- off-topic
- career
- management
- agile
- carreira
draft: false
---

Uma das coisas mais comuns que já vi em inúmeras empresas é tentar adotar alguma metodologia com a esperança que isso melhore as coisas. Invariavelmente não muda nada e até piora. Já repeti isso inúmeras vezes e vou repetir de novo: Agile não é uma bala de prata, não é uma receita mágica que vai consertar maus profissionais. Maus profissionais não tem conserto. Para ficar claro: um profissional júnior, que ainda tem deficiências técnicas e tem vontade de crescer, vai conseguir aprender técnicas, práticas, ferramentas e aumentar em qualidade técnica, em produtividade, em eficiência. Um mau profissional, que pode até ter alguma capacidade técnica, mas que está mais interessado em pouco trabalho, pouco esforço, pouca responsabilidade, e chega a ser mal caráter na sua conduta e atitude, não vai mudar.

Agile é mais [uma fórmula](http://www.akitaonrails.com/2013/10/30/off-topic-matematica-trolls-haters-e-discussoes-de-internet#.UnO4tpHDHwI) cuja imagem (resultado) é a [promessa de hiper-produtividade](http://www.akitaonrails.com/2009/12/10/off-topic-voce-nao-entende-nada-de-scrum#.UnO4wpHDHwI) que pode chegar a 500% do atual. Novamente, qual o Domínio (premissas)?

A premissa mais básica para Agile é que a equipe tenha capacidade técnica e comprometimento. Isso nenhuma metodologia vai ensinar ou mudar, ou cada indivíduo da equipe é uma pessoa capaz ou simplesmente não vai funcionar. Fazer código bem feito, bem organizado, seguindo as boas práticas conhecidas, com testes, com disciplina, etc é o mínimo necessário para começar, é o arroz com feijão. Se isso já não existir, desista, nenhuma metodologia, nem macumba, nem exorcismo, nem feng shui, vão ajudar. O que vai acontecer ao se colocar Scrum ou práticas de XP ou Kanbam ou qualquer outra coisa numa equipe ruim, com liderança fraca, são algumas das seguintes prostituições das boas práticas:

## Planning para Inglês ver

Um bom planning só é possível se o Product Owner se dedicar a ter um backlog priorizado e bem definido. E entenda, a definição das User Stories deve estar pronta **antes** do Sprint Planning. Uma User Story vaga, mal definida, não vai ajudar em nada. Enquanto a equipe está trabalhando no Sprint, o PO deve definir as User Stories, pode se juntar a um ou mais membros da própria equipe ou de equipes paralelas para ajudar nisso. Durante o Sprint Planning, tudo já deve estar bem definido, já pré-pontuado de preferência, priorizado e a equipe vai meramente pontuar o Sprint e, de acordo com a Velocidade atual, ver o que cabe no próximo Sprint. É uma reunião que, se bem feita, vai durar 1 ou 2 horas no máximo.

Sintomas: se demorar mais que 2 horas, tiver pessoas demais só para fazer quórum, User Stories mal definidas que geram discussões intermináveis e nenhuma ação, você está fazendo errado.

## Pair Programming para Inglês ver

Pair Programming é uma prática muito boa, a equipe decide como praticá-la. Porém, você pode encontrar um membro da equipe que quase nunca programa bem sozinho e ao fazer o "pair", é mais ouvinte do que um participante - o famoso "peso morto". Só fica dando pitaco ou mesmo só fica em silêncio (jogando Candy Crush ou navegando no Facebook). Ou seja, não tem valor algum.

Sintomas: Isso é mais fácil de acontecer em equipes muito grandes (acima de 6), pois fica mais fácil se "esconder" fazendo pair-fake com diferentes pessoas. Aliás, eu nunca recomendo mais do que 4 pessoas numa equipe ágil. Mesmo sendo um único produto, se tiver 15 pessoas, por exemplo, melhor dividir em 3 equipes de 5 pessoas. Melhor ainda se as pessoas rotacionarem nessas equipes para que não se crie "panelas" onde um ruim protege o outro ruim.

## Protecionismo Departamental

Programadores profissionais hoje precisam ser multi-funcionais, polivalentes. Obviamente cada um tem um tipo de capacidade melhor do que a outra. Por exemplo, o que chamaríamos de um "front-end", deve ser o mestre do HTML 5, CSS 3, Javascript, mas também deve saber o mínimo de Rails, Node.js, Python ou o que for o back-end para que consiga organizar os templates, já integrar com controllers, models, helpers, etc. E os "back-ends" também devem minimamente saber HTML, e mesmo infraestrutura.

Pontuação de User Stories (seja em Story Points, Working Hours, etc) deve ser sempre o mesmo não importa quem puxe a User Story. Não existe isso de: "essas 3 stories são minhas, essas 2 são do Fulano, essas 4 são do Ciclano". As stories são priorizadas e cada um vai puxando uma story de cada vez à medida que termina a anterior.

Sintomas: stories que são pontuadas diferentes dependendo da pessoa que vai pegar, ou stories "reservadas", ou tipos de stories que só um "tipo" de profissional pode pegar. Não existe isso de "esta story é de infra, só um cara de infra deve poder pegar, e o cara de back não deveria estar olhando pra ela". Sprints são responsabilidade da equipe toda. 

Uma das vantagens de pair programming e equipes pequenas é cada um aprender novas capacidades com os outros. Um back pode puxar uma Story que tem alguma coisa de front, mas ele não é o melhor de front, mas na hora que precisar nada impede de pedir pair com um bom front da equipe para ajudar. Uma User Story pode demorar 2 horas se for feita por um bom back, mas pode levar 5 horas se feita por um front.

O correto é que o cara de front se aproxime das 2 horas e não que a story seja reservada. O correto é a velocidade da equipe aumentar gradativamente, e para isso a velocidade individual de cada membro deve aumentar gradativamente. E para isso ele deve constantemente aprender novas capacidades. É assim que todos evoluem. Reservar stories é o melhor exemplo de batedor-de-ponto querendo 'proteger' seu emprego e esconder sua mediocridade.

## Qualidade para Inglês ver

Todos os membros da equipe devem estar preocupadas tanto com a qualidade técnica do código quanto com a qualidade funcional (se a funcionalidade realmente se comporta da forma correta com os usuários finais). Muitas vezes existem equipes que alocam pessoas com o objetivo único de ser um "Q&A" (Quality Assurancy), que se responsabiliza de montar casos de testes, automatizar testes de integração, alinhar com o PO e com analistas de negócios, marketing, etc.

Vou dizer que pessoalmente não gosto dessa distinção, mas confesso que em alguns casos faz mesmo muito sentido. Só que isso deve ser feito de forma que não seja retirada da equipe a responsabilidade de entregar funcionalidades que de fato funcionam, não pode existir a sensação de "foda-se se tiver bugs, depois o Q&A pega". Mas é isso que acontece muitas vezes.

Sintoma: procure User Stories que são entregues, depois rejeitadas, depois refeitas, depois rejeitadas e ficam assim por muito tempo. Uma User Story que fica 1 mês sem ser aceita é um absurdo monstruoso, uma abominação. Pior ainda se existir membros da equipe que, quando você olha o backlog passado, vai ver que está sempre envolvido em stories que sempre são rejeitadas e sempre demoram dias pra serem aceitas. É o típico caso do profissional que mantém seu emprego resolvendo problemas que ele mesmo criou. Remova essas maçãs podres da equipe o quanto antes, ela contamina o pote todo muito rapidamente.

## Desculpas, Desculpas, Desculpas

"Não deu pra fazer porque faltou teste, mas o cara que faz teste estava sobrecarregado então travei."

"Não deu pra fazer porque tinha um obstáculo na outra equipe que não resolveram, então travei."

"Não deu pra fazer porque estava mal especificado, mandei um e-mail pra tirar a dúvida, ninguém respondeu, então travei."

Um bom profissional dá soluções, não aponta culpados ou fica procurando desculpas para justificar a própria incompetência. Significa que ninguém pode reclamar? Claro que não, sempre existem problemas difíceis de resolver e as pessoas podem e devem sempre procurar ajuda quando necessário.

Sintomas: Mas é fácil identificar o procrastinador profissional. O sujeito nunca está na mesa dele, passa mais tempo conversando no café do que trabalhando. Chega tarde todo dia, sai cedo todo dia. Quando está na mesa você olha e o infeliz está no YouTube! ou no Hacker News. E que fique bem claro: nenhuma dessas atividades, isoladamente, é um problema. Até eu dou uma pausa e fico no Facebook. Só que quem tem esse comportamento **constantemente**, **rotineiramente**, está de palhaçada. E pior: se no final do dia a tarefa dele está terminada, com código bem feito, sem bugs, etc, eu não reclamaria, mas normalmente não está: a tarefa está incompleta, código mal feito, que sempre precisa se refeito. E o sujeito vem com desculpas parecidas com as que mostrei acima.

Isso é ser mal caráter, é atitude de criminoso. Ele está deliberadamente roubando a empresa, seu salário está sendo pago e o valor não está sendo entregue. É um ladrão.

Um bom profissional, que trabalha sério, não espera ser cobrado para dizer "ah, eu perguntei, ninguém respondeu, então não fiz". Um bom profissional, quando encontra um obstáculo, corre atrás do problema. Se for uma dúvida técnica, pergunta aos colegas do lado (pessaolamente, e-mail, chat, gtalk, etc). Se o problema for funcional, corre diretamente ao PO. Se o problema for departamental, ele mesmo levanta da cadeira e vai até a outra equipe para tirar a dúvida. Se a tarefa depende de um terceiro que não quis colaborar, ele vai diretamente ao seu chefe para resolver o problema. Enfim: o sintoma básico do mal profissional é que ele não vai atrás, ele fica contente quando encontra o obstáculo porque daqui uma semana, só na próxima reunião de Review, ele vai dizer "puuuuuts, eu até tentei fazer, mas o Fulano não colaborou, então não deu". Tá de brincadeira.

## Conclusão

Se sua equipe tiver apenas 1 dos problemas descritos acima, já é uma catástrofe. Se tiver mais de um, é um problema de intervenção militar, nível Iraque. Mais do que isso, só uma bomba nuclear para resolver isso. E pior ainda, alguém que apresenta **todos** os maus comportamentos descritos acima é um sociopata criminoso. Não adianta dar bronca, não adianta tentar consertar: não tem conserto ... mas tem solução: trocar as maçãs podres o quanto antes.

E novamente, para ficar claro, é óbvio que existem todos os tipos de maus profissionais, não estou falando somente de programadores. Existem maus gerentes, maus analistas, maus coordenadores, maus supervisores, maus diretores, etc. Isso vale para todo mundo.

Se você é um programador e está vendo tudo isso, corra atrás, mas se o problema for na diretoria sinto dizer que não há o que fazer. Agora, se você é um gerente, um supervisor, alguém de cargo de autoridade, e não está tomando nenhuma atitude sabendo de tudo isso: se demita, você está fazendo muito errado e sendo conivente com um ambiente cuja cultura é o mau-caratismo.

Aplicar 'algumas' práticas Ágeis, interpretadas da maneira errada, não é ser Ágil, é se enganar. É como numa dieta nutricional. Durante o dia segue a dieta à risca, mas quando ninguém está olhando come chocolate e doces e no dia seguinte fala "puts, não sei porque essa dieta não funciona, estou seguindo direitinho, acho que a dieta não funciona, vamos tentar outra." #lamentavel
