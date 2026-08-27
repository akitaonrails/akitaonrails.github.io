---
title: "[Off-Topic] Agile feito Errado"
date: '2013-11-01T10:48:00-02:00'
slug: off-topic-agile-feito-errado
translationKey: off-topic-agile-feito-errado
description: "O texto argumenta que Agile não salva equipes sem capacidade técnica e comprometimento. Planning, pair programming, qualidade e responsabilidade viram encenação, e maus profissionais precisam ser substituídos."
tags:
- agile
- engenharia-de-software
- gestao
- off-topic
draft: false
---

Uma das coisas mais comuns que já vi em inúmeras empresas é adotar alguma metodologia na esperança de que isso melhore as coisas. Invariavelmente não muda nada e às vezes piora. Já repeti isso inúmeras vezes e repito de novo: Agile não é uma bala de prata, e nenhuma receita mágica conserta maus profissionais. Maus profissionais não têm conserto.

Vale a distinção. Um profissional júnior, que ainda tem deficiências técnicas e vontade de crescer, aprende técnicas, práticas e ferramentas, e ganha qualidade técnica, produtividade e eficiência. Um mau profissional, que até pode ter alguma capacidade técnica, está mais interessado em pouco trabalho, pouco esforço e pouca responsabilidade, e chega a ser mal caráter na conduta e na atitude. Esse não muda.

Agile é mais [uma fórmula](http://www.akitaonrails.com/2013/10/30/off-topic-matematica-trolls-haters-e-discussoes-de-internet) cuja imagem (resultado) é a [promessa de hiper-produtividade](http://www.akitaonrails.com/2009/12/10/off-topic-voce-nao-entende-nada-de-scrum) que pode chegar a 500% do atual. Novamente, qual o Domínio (as premissas)?

A premissa mais básica para Agile é que a equipe tenha capacidade técnica e comprometimento. Isso nenhuma metodologia ensina ou muda. Cada indivíduo da equipe é uma pessoa capaz ou simplesmente não vai funcionar. Código bem feito, bem organizado, seguindo as boas práticas conhecidas, com testes e disciplina, é o mínimo para começar, o arroz com feijão.

Se isso não existir, desista. Nenhuma metodologia, nem macumba, nem exorcismo, nem feng shui vão ajudar. Colocar Scrum, práticas de XP, Kanban ou qualquer outra coisa numa equipe ruim, com liderança fraca, produz algumas das seguintes prostituições das boas práticas:

## Planning para Inglês ver

Um bom planning só é possível se o Product Owner se dedicar a manter um backlog priorizado e bem definido. E entenda: a definição das User Stories deve estar pronta **antes** do Sprint Planning. Uma User Story vaga, mal definida, não ajuda em nada.

Enquanto a equipe trabalha no Sprint, o PO define as próximas User Stories, e pode chamar um ou mais membros da própria equipe ou de equipes paralelas para ajudar. No Sprint Planning tudo já deve estar bem definido, de preferência pré-pontuado e priorizado. A equipe apenas pontua o Sprint e, de acordo com a Velocidade atual, vê o que cabe no próximo. Uma reunião bem feita dura 1 ou 2 horas no máximo.

Sintomas: se demorar mais que 2 horas, tiver pessoas demais só para fazer quórum, User Stories mal definidas que geram discussões intermináveis e nenhuma ação, você está fazendo errado.

## Pair Programming para Inglês ver

Pair Programming é uma prática muito boa, e a equipe decide como praticá-la. Só que você pode encontrar um membro que quase nunca programa bem sozinho e, ao fazer o "pair", vira mais ouvinte do que participante. É o famoso "peso morto". Fica só dando pitaco, ou fica em silêncio jogando Candy Crush e navegando no Facebook. Não tem valor algum.

Sintomas: isso é mais fácil de acontecer em equipes muito grandes (acima de 6), pois fica mais fácil se "esconder" fazendo pair-fake com diferentes pessoas. Aliás, eu nunca recomendo mais do que 4 pessoas numa equipe ágil. Mesmo sendo um único produto, se tiver 15 pessoas, por exemplo, melhor dividir em 3 equipes de 5. Melhor ainda se as pessoas rotacionarem nessas equipes para que não se criem "panelas" onde um ruim protege o outro ruim.

## Protecionismo Departamental

Programadores profissionais hoje precisam ser multi-funcionais, polivalentes. Obviamente cada um tem um tipo de capacidade melhor do que a outra. Por exemplo, o que chamaríamos de um "front-end" deve ser o mestre do HTML 5, CSS 3, Javascript, mas também deve saber o mínimo de Rails, Node.js, Python ou o que for o back-end para conseguir organizar os templates e integrar com controllers, models, helpers, etc. E os "back-ends" também devem minimamente saber HTML, e mesmo infraestrutura.

Pontuação de User Stories (seja em Story Points, Working Hours, etc) deve ser sempre a mesma não importa quem puxe a User Story. Não existe isso de: "essas 3 stories são minhas, essas 2 são do Fulano, essas 4 são do Ciclano". As stories são priorizadas e cada um vai puxando uma story de cada vez à medida que termina a anterior.

Sintomas: stories que são pontuadas diferente dependendo da pessoa que vai pegar, ou stories "reservadas", ou tipos de stories que só um "tipo" de profissional pode pegar. Não existe isso de "esta story é de infra, só um cara de infra deve poder pegar, e o cara de back não deveria estar olhando pra ela". Sprints são responsabilidade da equipe toda.

Uma das vantagens de pair programming e equipes pequenas é cada um aprender novas capacidades com os outros. Um back pode puxar uma Story que tem alguma coisa de front, mesmo sem ser o melhor de front, e nada impede de pedir pair com um bom front da equipe na hora que precisar. Uma User Story pode demorar 2 horas se for feita por um bom back, mas pode levar 5 horas se feita por um front.

O correto é o cara de front se aproximar das 2 horas, e não reservar a story. O correto é a velocidade da equipe aumentar gradativamente, e para isso a velocidade individual de cada membro também precisa aumentar. E para isso ele deve constantemente aprender novas capacidades. É assim que todos evoluem. Reservar stories é o melhor exemplo de batedor-de-ponto querendo 'proteger' seu emprego e esconder sua mediocridade.

## Qualidade para Inglês ver

Todos os membros da equipe devem estar preocupados tanto com a qualidade técnica do código quanto com a qualidade funcional, ou seja, se a funcionalidade realmente se comporta da forma correta com os usuários finais. Muitas vezes existem equipes que alocam pessoas com o objetivo único de ser um "Q&A" (Quality Assurance), que se responsabiliza de montar casos de teste, automatizar testes de integração, alinhar com o PO e com analistas de negócios, marketing, etc.

Vou dizer que pessoalmente não gosto dessa distinção, mas confesso que em alguns casos faz muito sentido. Só que isso deve ser feito de forma que não se retire da equipe a responsabilidade de entregar funcionalidades que de fato funcionam. Não pode existir a sensação de "foda-se se tiver bugs, depois o Q&A pega". Mas é isso que acontece muitas vezes.

Sintoma: procure User Stories que são entregues, depois rejeitadas, depois refeitas, depois rejeitadas de novo, e ficam assim por muito tempo. Uma User Story que fica 1 mês sem ser aceita é um absurdo monstruoso, uma abominação. Pior ainda se existirem membros da equipe que, quando você olha o backlog passado, estão sempre envolvidos em stories que sempre são rejeitadas e sempre demoram dias para serem aceitas. É o típico caso do profissional que mantém o emprego resolvendo problemas que ele mesmo criou. Remova essas maçãs podres da equipe o quanto antes, porque contaminam o pote todo muito rapidamente.

## Desculpas, Desculpas, Desculpas

"Não deu pra fazer porque faltou teste, mas o cara que faz teste estava sobrecarregado então travei."

"Não deu pra fazer porque tinha um obstáculo na outra equipe que não resolveram, então travei."

"Não deu pra fazer porque estava mal especificado, mandei um e-mail pra tirar a dúvida, ninguém respondeu, então travei."

Um bom profissional dá soluções, não aponta culpados nem fica procurando desculpas para justificar a própria incompetência. Significa que ninguém pode reclamar? Claro que não. Sempre existem problemas difíceis de resolver, e as pessoas podem e devem procurar ajuda quando necessário.

Sintomas: é fácil identificar o procrastinador profissional. O sujeito nunca está na mesa dele, passa mais tempo conversando no café do que trabalhando. Chega tarde todo dia, sai cedo todo dia. Quando está na mesa, você olha e o infeliz está no YouTube ou no Hacker News.

E que fique bem claro: nenhuma dessas atividades, isolada, é um problema. Até eu dou uma pausa e fico no Facebook. Só que quem age assim **constantemente**, **rotineiramente**, está de palhaçada. Pior: se no fim do dia a tarefa dele estivesse pronta, com código bem feito e sem bugs, eu não reclamaria. Normalmente não está. A tarefa fica incompleta, o código mal feito, sempre precisando ser refeito, e o sujeito aparece com desculpas parecidas com as de cima.

Isso é ser mal caráter, é atitude de criminoso. Ele está deliberadamente roubando a empresa: o salário está sendo pago e o valor não está sendo entregue. É um ladrão.

Um bom profissional, que trabalha sério, não espera ser cobrado para dizer "ah, eu perguntei, ninguém respondeu, então não fiz". Quando encontra um obstáculo, corre atrás do problema. Dúvida técnica, pergunta aos colegas do lado (pessoalmente, e-mail, chat, gtalk). Problema funcional, procura o PO direto. Problema departamental, levanta da cadeira e vai até a outra equipe tirar a dúvida. Se a tarefa depende de um terceiro que não colaborou, vai direto ao chefe resolver.

O sintoma básico do mau profissional é o oposto: ele não vai atrás. Fica contente quando encontra o obstáculo, porque daqui a uma semana, só na próxima reunião de Review, vai dizer "puuuuuts, eu até tentei, mas o Fulano não colaborou, então não deu". Tá de brincadeira.

## Conclusão

Se sua equipe tiver apenas 1 dos problemas descritos acima, já é uma catástrofe. Se tiver mais de um, é um problema de intervenção militar, nível Iraque. Mais do que isso, só uma bomba nuclear para resolver. E pior ainda, alguém que apresenta **todos** os maus comportamentos descritos acima é um sociopata criminoso. Não adianta dar bronca, não adianta tentar consertar: não tem conserto... mas tem solução: trocar as maçãs podres o quanto antes.

E novamente, para ficar claro, é óbvio que existem todos os tipos de maus profissionais, e não estou falando somente de programadores. Existem maus gerentes, maus analistas, maus coordenadores, maus supervisores, maus diretores, etc. Isso vale para todo mundo.

Se você é um programador e está vendo tudo isso, corra atrás. Se o problema for na diretoria, sinto dizer que não há o que fazer. Agora, se você é um gerente, um supervisor, alguém em cargo de autoridade, e não está tomando nenhuma atitude sabendo de tudo isso: se demita, você está fazendo muito errado e sendo conivente com um ambiente cuja cultura é o mau-caratismo.

Aplicar 'algumas' práticas Ágeis, interpretadas da maneira errada, não é ser Ágil, é se enganar. É como uma dieta nutricional. Durante o dia você segue a dieta à risca, mas quando ninguém está olhando come chocolate e doces, e no dia seguinte fala "puts, não sei porque essa dieta não funciona, estou seguindo direitinho, acho que a dieta não presta, vamos tentar outra." #lamentavel
