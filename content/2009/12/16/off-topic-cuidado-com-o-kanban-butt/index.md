---
title: "[Off Topic] Cuidado com o Kanban-butt"
date: '2009-12-16T23:22:00-02:00'
slug: off-topic-cuidado-com-o-kanban-butt
translationKey: off-topic-cuidado-com-o-kanban-butt
description: "Kanban é uma técnica do Toyota Production System, não sinônimo de Lean nem uma metodologia completa. Em software, que é não repetitivo, entender o porquê vem antes de aplicar a ferramenta."
tags:
- agile
- gestao
- off-topic
draft: false
---

Por alguma razão, muita gente anda discutindo e evangelizando [Kanban](http://en.wikipedia.org/wiki/Kanban) ultimamente, e isso começa a me irritar. Aplicar a ferramenta Kanban como se ela fosse uma metodologia inteira é um erro. Essa ferramenta foi criada e difundida pela Toyota, décadas atrás, dentro de uma metodologia bem maior: o [Toyota Production System](http://en.wikipedia.org/wiki/Toyota_Production_System) (TPS), do grande [Taiichi Ohno](http://en.wikipedia.org/wiki/Taiichi_Ohno).

Como eu disse num [artigo anterior](/2009/12/10/off-topic-voce-nao-entende-nada-de-scrum), as metodologias ágeis têm a mesma fundação. Para entender o TPS vale voltar à literatura original, e uma dessas fontes é o livro O Sistema Toyota de Produção, do Ponto de Vista da Engenharia de Produção, de [Shigeo Shingo](http://en.wikipedia.org/wiki/Shigeo_Shingo), publicado em **1996**. No Prefácio ele diz:

> Muitos acreditam que ao implementar um novo sistema, somente _“know-how”_ é necessário. No entanto, se você quer obter êxito, você deve entender, também, _“know-why”_  
>   
> Com o know-how, você pode operar o sistema, mas você não saberá o que fazer no caso de encontrar problemas sob condições diferentes das usuais. Com o know-why, ou “sabendo o porquê”, você entende por que você tem de fazer o que está fazendo e assim enfrentar situações de mudança.


Especificamente sobre Kanban ele diz:

> O maior problema encontrado enquanto estudava o TPS do ponto de vista de Engenharia de Produção é o fato de ser frequentemente considerado como sinônimo de sistema _Kanban_. O sr. Ohno escreve:  
>   
> * TPS é um sistema de produção  
> * O método _Kanban_ é uma técnica para sua implementação  
>   
> Muitas publicações são confusas nessa questão e oferecem uma explicação do sistema, afirmando que o _Kanban_ é a essência do TPS. Uma vez mais: _O TPS é um sistema de produção e o método kanban é meramente um meio de controlar o sistema._  
>   
> Análises superficiais do TPS dão especial atenção ao método _kanban_ devido às suas características únicas. Consequentemente, muitas pessoas concluem que o TPS é equivalente ao método _Kanban_.

> Um método _Kanban_ deve ser adotado somente depois que o sistema de produção em si tenha sido racionalizado. Esse é o motivo pelo qual este livro insiste repetidamente no fato de que o TPS e o método Toyota são entidades separadas.

> Devo acrescentar que 90% do excelente desempenho gerencial da Toyota foi atribuído ao TPS em si, e apenas 10% ao método _Kanban_ – uma clara demonstração da maior importância do TPS.

Vale repetir: Shigeo escreveu isso em **1996**. Impressiona que, mais de uma década depois, ainda cometamos os mesmos erros de interpretação.

Assim como o [Manifesto Ágil](http://agilemanifesto.org), o Sistema Toyota tem um conjunto de 14 princípios, conhecido no Ocidente como [The Toyota Way](http://en.wikipedia.org/wiki/The_Toyota_Way). E, do mesmo jeito que em Agilidade, colocar post-its na parede e rodar Sprints não faz nada virar Ágil. Seguir o método Toyota exige muito mais do que usar Kanban.

Para entender a Toyota é obrigatório entender o Toyota Way, e um dos melhores livros para começar é o The Toyota Way, de Jeffrey Liker. Se você pretende levar isso a sério, precisa também entender a revolução gerencial da Toyota, narrada no clássico The Machine that Changed the World, de James Womack.

Se ainda não está convencido, na conclusão do capítulo sobre Kanban, o próprio Shigeo Shingo diz:

> Os sistemas Kanban podem ser aplicados somente em fábricas com produção repetitiva. (…)  
>   
> Os sistemas Kanban não são aplicáveis em empresas com produção sob projeto não repetitivo, onde os pedidos são infrequentes e imprevisíveis.  
>   
> O tipo de produção que com maior probabilidade se beneficiaria do Kanban, é aquele que utiliza processos comuns de transformação dos materiais.

Uma dica: desenvolvimento de software é uma tarefa não repetitiva. Mesmo assim, os princípios do TPS continuam muito aplicáveis quando o _know-why_ está claro.

O método Toyota é mais conhecido genericamente como [Lean Manufacturing](http://en.wikipedia.org/wiki/Lean_production). O melhor trabalho adaptando Lean ao mundo de software é o livro [Lean Software Development](http://en.wikipedia.org/wiki/Lean_software_development), de Tom e Mary Poppendieck. Antes de falar levianamente em Kanban, é obrigatório ler esses trabalhos; caso contrário, será só mais uma ferramenta fadada a falhar, e vamos acabar com uma onda de Kanban-butts.

Tudo que vem fácil, vai fácil. “Parece” fácil implementar Ágil. “Parece” fácil implementar Kanban. Não existe almoço grátis. Leve as coisas de forma superficial e não espere nada além de resultados medíocres. É assim que funciona.

