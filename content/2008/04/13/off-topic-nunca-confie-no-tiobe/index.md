---
title: 'Off Topic: Nunca confie no TIOBE'
date: '2008-04-13T14:40:00-03:00'
slug: off-topic-nunca-confie-no-tiobe
translationKey: off-topic-nunca-confie-no-tiobe
description: "Ao examinar a fórmula do TIOBE, o autor mostra como hits de buscadores, duplicatas e ruído distorcem a medida. Por isso, o índice não sustenta conclusões confiáveis sobre o crescimento das linguagens."
tags:
- linguagens-de-programacao
- ciencia
- off-topic
draft: false
---

Eu já usei números do TIOBE em apresentações e em artigos aqui no blog. Tinha uma vaga noção de como eles montavam aquele índice, mas nunca parei para pensar a sério. Alguém aí sabe como se forma o índice TIOBE de "Popularidade de Linguagem"?

Hoje li [dois](https://blog.timbunce.org/2008/04/12/tiobe-or-not-tiobe-lies-damned-lies-and-statistics/) [artigos](http://web.archive.org/web/20080527051237/http://contentment.org/2008/04/perl-is-not-going-away.html) discutindo justamente isso. Os dois têm razão, e se você parar para pensar por 30 segundos, era óbvio que eu nunca deveria ter usado esses números. Eu, que já falei mais de uma vez dos perigos da estatística mal utilizada! Vamos entender o porquê.

Pois bem, como é formado o índice TIOBE?

É uma porcentagem, sem ajuste nenhum, da quantidade de hits em 5 search engines para os termos +"[linguagem] programming". Vejamos exemplos com números absolutos apenas no Google:

- Java: 3,4 milhões de hits
- C: 2,2 milhões de hits
- C++: 1,7 milhão de hits
- PHP: 1,5 milhão de hits
- Perl: 0,9 milhão de hits
- Python: 584 mil hits
- C#: 558 mil hits
- Ruby: 363 mil hits
- Smalltalk: 28,4 mil hits
- Groovy: 15,7 mil hits

Agora, vejamos no Yahoo!:

- C: 12,3 milhões de hits
- Java: 9,6 milhões de hits
- C++: 4,9 milhões de hits
- PHP: 4,9 milhões de hits
- Perl: 2,8 milhões de hits
- Python: 2,2 milhões de hits
- C#: 1,9 milhão de hits
- Ruby: 1,6 milhão de hits
- Smalltalk: 103 mil hits
- Groovy: 31,3 mil hits

Existem ainda listas de exceção para agrupar ou separar termos. C#, por exemplo, também é procurado como "CSharp", "C-Sharp", "C# 3.0", e o resultado de todos é somado como "C#". No exemplo acima eu procurei simplesmente por "C# programming".

Depois disso, eles pegam o total de resultados de cada linguagem e dividem pelo total das 50 primeiras. No meu exemplo, com as 10 da lista, C# fica 558 mil / 11.249.100 = 4,9%. O mesmo é feito para o Yahoo e os outros search engines. As porcentagens finais são somadas e divididas por 5. Vejam o que dá no meu exemplo menor, sem usar nenhuma exceção e apenas com os 2 buscadores principais:

- Java: 27%
- C: 25%
- C++: 13,6%
- PHP: 12,7%
- Perl: 7,47%
- Python: 5,3%
- C#: 4,87%
- Ruby: 3,6%
- Smalltalk: 0,3%
- Groovy: 0,1%

Pronto: acabamos de ver o jeito fácil de fabricar índices. Essa metodologia é absolutamente quebrada, e não é preciso ser especialista em estatística para dizer isso. Não dá nem para comparar com uma metodologia considerada "séria", como um IBOPE, que mesmo assim já é controverso.

## Os problemas

Alguns dos problemas que eu, leigo em estatística, consigo apontar:

- Confiança cega em terceiros: presume-se que os search engines fazem um bom trabalho.

- Duplicatas entram na conta. Um mesmo artigo que ganha notoriedade é republicado em centenas de blogs (muitos de nós, blogueiros, somos notórios por ser apenas ecos das fontes primárias). O que deveria contar como 1 vira 100. O Google App Engine, recém-lançado, deve estar inflando o índice de Python, por exemplo.

- Os 5 search engines pesam igual, porque o índice é só a média simples do resultado de todos. Não existe nenhum fator de ajuste. E o Yahoo!, na minha experiência, faz um péssimo trabalho em pesquisa: "C programming" deu 2,2 milhões de hits no Google e 12,3 milhões no Yahoo!. Duvido que o banco de dados do Yahoo! seja 10 vezes maior; o mais provável é que ele seja 10 vezes pior em eliminar ruído. Não me surpreenderia se ele contasse "Objective C programming" como hit de "C programming", algo no nível do primário `select * from tabela where texto like "C programming"`.

- O número de hits depende da string exata da busca. "Ruby programming" trouxe parcos 363 mil hits no Google. Já "Ruby Rails" traz **8,1 milhões** de hits (!). Naveguei até a página 63 e eram todos links relevantes de Ruby e Rails (nada de pedras preciosas ou linhas de trem, ou seja, pouca sujeira). Com a mesma string, o Yahoo! trouxe 3,9 milhões, bem acima do 1,6 milhão anterior. Fica claro como é difícil chegar a um número confiável para cada plataforma.

A reclamação dos dois autores dos posts que linkei é essa: mesmo com os resultados que vimos, por que Python se tornou a linguagem do ano passado? Por que Ruby se tornou a linguagem do ano retrasado? Por esse método está claro que Java, C, C++, Perl e PHP estão uma ordem de grandeza acima.

Minha avaliação: o Índice TIOBE presume muita coisa e deixa passar muito erro. Numa situação de medida como essa, a margem de erro é maior que o número sendo medido. É praticamente impossível tirar qualquer conclusão daí.

Quer uma metodologia igualmente ridícula? Vamos "assumir" que uma pessoa que recebe um panfleto de candidato político e não o joga na rua gosta dele. Poderíamos eleger um presidente contando os panfletos jogados na rua: quem tiver menos panfletos no chão é o mais querido e, portanto, o vencedor.

Eu já falei disso em outro artigo: [Somos matematicamente ignorantes](/2008/3/1/off-topic-somos-matematicamente-ignorantes). Infelizmente, diferente de álgebra de primeiro grau, estatística ainda é uma área muito pouco esclarecida. Eu estudei estatística no Instituto de Matemática e **Estatística** da USP e ainda assim sei muito pouco a respeito. As pessoas são constantemente obrigadas a "engolir" os números que a TV mostra, sem saber como julgar, minimamente, se os critérios são adequados.

Minha recomendação: na dúvida, ignore os índices. Não sou Dijkstra, mas eu diria _"Statistics Considered Harmful"_. Enquanto as pessoas não entenderem o que é estatística, mostrar índices para elas é apenas tentar mentir com mais substância. No artigo que linkei lá em cima, Tim cita Mark Twain:

> "Existem três tipos de mentiras: mentiras, grandes mentiras e estatísticas."

Da minha parte, não pretendo mais mencionar o TIOBE em nenhum artigo ou apresentação como argumento de que Ruby está crescendo. Na prática, acredito que não exista hoje nenhum índice confiável para avaliar isso.
