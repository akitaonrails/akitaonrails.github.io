---
title: Desmistificando o método Kanban
date: '2013-05-31T19:31:00-03:00'
slug: desmistificando-o-metodo-kanban
tags:
- of-topic
- principles
- management
- agile
draft: false
---

**Original de 24/11/2010**: [Gestão 2.0](http://info.abril.com.br/noticias/rede/gestao20/gestao/desmistificando-o-metodo-kanban/)

Se você acompanha as discussões sobre metodologias de gerenciamento de projetos de software Ágeis, já deve ter ouvido falar sobre o hype a respeito de Kanban. Eu já conversei com algumas pessoas da área explicando que eu não discordo do conceito em si, mas que acho confuso chamá-lo de “Kanban”.

Para os que não entenderam, Kanban é uma técnica derivada do processo “Lean” que é uma generalização do Sistema Toyota de Produção, o famoso processo industrial criado pela Toyota décadas atrás e que ajudou a revolucionar a Toyota. Criar hype sobre a técnica Kanban não é novidade e a área de Engenharia de Produção já passou por isso antes.

Um dos problemas de se usar o nome “Kanban” é que ela se associa com “Lean” e isso leva a toda uma discussão sobre Agile-Lean que eu particularmente desgosto, especialmente porque o Kanban aplicado a software não tem muito a ver com o Kanban de produção e, portanto, também não tem a ver com Lean.

Para realmente entender o Sistema Toyota de Produção é importante ir às raízes, estudar sobre Taiichi Ohno, W. Edward Deming. Também recomendo a leitura do livro [“O Sistema Toyota de Produção do Ponto de Vista da Engenharia de Produção“](http://bit.ly/fphUsr), escrita por Shigeo Shingo, que atuou como consultor externo e ensinou cursos de engenharia industrial desde 1955. Desse livro, quero parafrasear um trecho do Prefácio da Edição Japonesa:

> O maior problema encontrado enquanto estudava o Sistema Toyota de Produção do ponto de vista da Engenharia de Produção é o fato de ser frequentemente considerado como sinônimo de sistema Kanban. O sr. Ohno escreve:

> Sistema Toyota de Produção é um sistema de produção. O método Kanban é uma técnica para sua implementação. 

> Muitas publicações são confusas nessa questão e oferecem uma explicação do sistema, afirmando que o Kanban é a essência do Sistema Toyota de Produção. Uma vez mais: O sistema Toyota de produção é um sistema de produção e o método kanban é meramente um meio de controlar o sistema.

> Análises superficiais do Sistema Toyota de Produção dão especial atenção ao método Kanban devido às suas características únicas. Consequentemente, muitas pessoas concluem que o Sistema Toyota de Produção é equivalente ao método Kanban. No cerne desse método tem-se que:

> Ele é aplicado somente à produção de natureza repetitiva. Os níveis totais de estoque são controlados por um número de cartões Kanban. É um sistema administrativo simplificado

> **Um método Kanban deve ser adotado somente depois que o sistema de produção em si tenha sido racionalizado**. Esse é o motivo pelo qual esse livro insiste repetidamente no fato de que o Sistema Toyota de Produção e o método Toyota são entidades separadas.

> (…)

> Devo acrescentar que 90% do excelente desempenho gerencial da Toyota foi atribuído ao Sistema Toyota de Produção em si, e apenas 10% ao método Kanban – uma clara demonstração da maior importância do Sistema Toyota de Produção.

Além disso o mais importante é entender que o método Kanban foi criado para engenharia de produção em ambientes industriais. Como própria definição, Shigeo resume:

> Os sistemas Kanban são extremamente eficientes na simplificação do trabalho administrativo e em dar autonomia ao chão-de-fábrica, o que possibilita responder a mudanças com maior flexibilidade. Uma das vantagens dos sistemas Kanban é que, ao dar instruções no processo final, eles permitem que a informação seja transmitda de forma organizada e rápida.

> **Os sistemas Kanban podem ser aplicados somente em fábricas com produção repetitiva**. A natureza repetitiva da produção pode não exercer muita influência, contudo, se houver instabilidades temporais ou quantitativas.

> **Os sistemas Kanban não são aplicáveis em empresas com produção sob projeto não repetitivo**, onde os pedidos são infrequentes e imprevisíveis.

Finalmente, uma das essências do Sistema Toyota de Produção é minimização dos desperdícios e operação com estoque mínimo ou, idealmente, zero, de acordo com a idéia de just-in-time (ou melhor definido como “just-on-time”). Porém, no mundo físico de produção, é impossível operar com estoque zero. Para isso existem os Kanbans cujas quantidades são definidas pela quantidade de material dividido pela capacidade dos paletes. O objetivo dos Kanbans é que eles diminuam de quantidade, se aproximando sempre do nível ideal de estoque zero. Portanto, uma definição “filosófica” minha é que o objetivo do Kanban é acabar com o Kanban.

Se for para pegar aleatoriamente um dos aspectos do Sistema Toyota de Produção, que seja entender um dos mais importantes, o conceito de melhoria contínua, ou “Kaizen“. No mundo ocidental, quem já estudou produção ou conceitos de qualidade total com certeza já esbarrou com isso, na forma da idéia do ciclo PDCA (Plan, Do, Check, Act) de Deming.

Aliás, já notaram que toda “metodologia” é muito parecida em seu processo? Se olharem bem vão ver que todos são basicamente derivados do ciclo PDCA de Deming. Apenas variações com nomes diferentes da mesma idéia básica de melhoria contínua.

Associar histórias de software com “estoque”, um backlog contínuo como “kanban” não torna seu processo necessariamente Ágil e muito menos Lean se embutido a isso não existir no mínimo o entendimento de melhoria contínua, Kaizen. É muito fácil fazer um processo desses virar rotina e procedimento e, com isso, perder toda a essência, assim como já está acontecendo com implementações de Scrum.

Se quiserem aprender, recomendo que leiam ao menos os seguintes livros:

* [The Toyota Way](http://www.amazon.com/Toyota-Way-Management-Principles-Manufacturer/dp/0071392319) – Jeffrey K. Liker
* [The Machine that Changed the World](http://www.amazon.com/Machine-That-Changed-World-Revolutionizing/dp/0743299795) – James P. Womack
* [A Study of the Toyota Production System](http://www.amazon.com/Study-Toyota-Production-System-Engineering/dp/0915299178) – Shigeo Shingo
* [Theory of Constraints](http://www.amazon.com/Theory-Constraints-Eliyahu-M-Goldratt/dp/0884271668) – Eliyahu M. Goldratt
