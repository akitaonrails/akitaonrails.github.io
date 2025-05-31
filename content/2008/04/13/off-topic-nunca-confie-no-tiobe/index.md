---
title: 'Off Topic: Nunca confie no TIOBE'
date: '2008-04-13T14:40:00-03:00'
slug: off-topic-nunca-confie-no-tiobe
tags:
- off-topic
- principles
- fallacies
- tiobe
draft: false
---

Eu já usei números do TIOBE em minhas apresentações. Já usei os números em artigos no meu blog. Tinha uma vaga noção de como eles formavam aquele número, mas nunca parei para pensar neles. Alguém aí sabe como se forma o índice TIOBE de “Popularidade de Linguagem?”

Hoje li [dois](http://blog.timbunce.org/2008/04/12/tiobe-or-not-tiobe-lies-damned-lies-and-statistics/) [artigos](http://contentment.org/2008/04/perl-is-not-going-away.html) discutindo justamente isso. Ambos tem razão e se parar para pensar por 30 segundos, era óbvio que eu nunca deveria ter usado esses números. Ainda mais eu, que falei mais de uma vez dos perigos da estatística mal utilizada! Vamos entender o porquê.


Pois bem, como é formado o índice TIOBE?

É uma porcentagem, não ajustada, sobre a quantidade de hits em 5 engines de procura pelos termos +"[linguagem] programming". Vejamos exemplos com números absolutos apenas no Google:

- Java – 3,4 milhões hits
- C – 2,2 milhões hits
- C++ – 1,7 milhão hits
- PHP – 1,5 milhão hits
- Perl – 0,9 milhão hits
- Python – 584 mil hits
- C# – 558 mil hits
- Ruby – 363 mil hits
- Smalltalk – 28,4 mil hits
- Groovy – 15,7 mil hits

Agora, vejamos no Yahoo!

- C – 12,3 milhões hits
- Java – 9,6 milhões hits
- C++ – 4,9 milhões hits
- PHP – 4,9 milhões hits
- Perl – 2,8 milhões hits
- Python, 2,2 milhões hits
- C# – 1,9 milhão hits
- Ruby – 1,6 milhão hits
- Smalltalk – 103 mil hits
- Groovy – 31,3 mil hits

Mas existem listas de exceções para agrupamentos ou desagrupamentos. Por exemplo, C# também é procurado por “CSharp”, “C-Sharp”, “C# 3.0”, etc. O resultado de todos é somado como “C#”. No exemplo acima procurei simplesmente por “C# programming”.

Depois disso eles pegam o total de resultados, por exemplo C# no Google foi 558 mil e dividem pelo total de resultados das 1as 50 linguagens – ou no meu exemplo, das primeiras 9. Assim eu teria para C# 558 mil / 11.249.100 = 4,9%. O mesmo é feito para o Yahoo e outros search engines. As porcentagens finais são somadas e divididas por 5 (total de search engines). Vejamos meus resultados menores não usando nenhuma das exceções e nem usando os 5 search engines, apenas os 2 principais.

- Java – 27%
- C – 25%
- C++ – 13,6%
- PHP – 12,7%
- Perl – 7,47%
- Python – 5,3%
- C# – 4,87%
- Ruby – 3,6%
- Smalltalk – 0,3%
- Groovy – 0,1%

Bem, acabamos de ver o jeito fácil de fabricar índices. Essa metodologia é absolutamente quebrada e não é preciso ser um especialista em estatística para dizer isso. Não se compara a nenhuma metodologia considerada ‘séria’ como um IBOPE (e que ainda assim ainda é controverso).

## Os problemas

Apenas os que eu, sendo leigo em estatística, poderia dizer:

- Assumem-se resultados de terceiros, os search engines, presumindo-se que eles façam um bom trabalho.

- Desconsidera-se duplicatas. Um mesmo artigo que por alguma razão ganhou notoriedade e foi re-publicado em centenas de blogs por aí (muitos de nós blogueiros somos notórios por sermos apenas ecos das fontes primárias). Assim um artigo que deveria contar apenas como 1, de repente vira 100. Veja um Google App Engine que foi recém-lançado. Isso deve inflar os índices de Python, por exemplo.

- Considera-se que todos os 5 search engines são igualmente relevantes já que faz-se apenas a média simples do resultado de todas elas. Não existe nenhum índice de ajuste. O Yahoo!, me parece, faz um péssimo trabalho em pesquisa. Procurar por “C programming” no Google trouxe 2,2 milhões de hits, já no google trouxe 12,3 milhões! Duvido que seja porque o banco de dados do Yahoo! é 10 vezes maior, mas sim provavelmente porque ele é 10 vezes pior em eliminar ‘barulho’. Não ficaria surpreso se ele considerasse “Objective C programming” como sendo um hit para “C programming”, entenderam? Como o primário select * from tabela where texto like “C programming”

- Outro motivo de porque não se pode confiar em número de hits em search engines? “Ruby programming” trouxe parcos 363 mil hits no Google. Mas e “Ruby Rails”? Isso trás **8,1 milhões** de hits no Google (!) Eu naveguei até a página 63 e eram todos links relevantes realmente Ruby e Rails (nada a ver com pedras preciosas ou linhas de trem, por exemplo, ou seja, pouca sujeira). Com o mesmo string o Yahoo! trouxe 3,9 milhões, bem acima dos 1,6 milhão anteriores. Vemos como é difícil atingir um número confiável para cada plataforma.

A reclamação dos dois autores dos posts que linkei acima é: Mesmo com os resultados que vimos, por que Python se tornou linguagem do ano passado? Por que Ruby se tornou linguagem do ano retrasado? Está claro – por esse método – que Java, C, C++, Perl e PHP estão uma ordem de grandeza acima.

Minha avaliação é: o Índice TIOBE presume muita coisa e deixa passar muito erro. Numa situação de medida como essa, a margem de erro é maior que o número sendo medido. É praticamente impossível tirar qualquer conclusão disso.

Uma metodologia igualmente ridícula? Vamos ‘assumir’ que se uma pessoa que recebe um panfleto de candidato político, não a joga na rua, é porque ele gosta dele. Portanto poderíamos eleger um presidente contando os panfletos jogados na rua e assumindo que quem tiver menos panfletos na rua é o que as pessoas mais gostaram e, portanto, o ganhador.

Eu já disse antes em outro artigo: [Somos matematicamente ignorantes](/2008/3/1/off-topic-somos-matematicamente-ignorantes). Infelizmente, diferente de álgebra de primeiro grau, estatística ainda é uma área muito pouco esclarecida. Eu estudei estatística no Instituto de Matemática e **Estatística** da USP e ainda assim sei muito pouco a respeito. As pessoas constantemente são obrigadas a apenas “engolir” os números que a TV mostra sem saber como determinar, minimamente, se os critérios são adequados.

Minha recomendação é: na dúvida, ignore os índices. Não sou Dijkstra mas eu diria _“Statistics Considered Harmful”_ Até que as pessoas entendam o que é estatísticas, mostrar-lhes índices é apenas um ato de tentar mentir com mais substância. Em seu [artigo](http://blog.timbunce.org/2008/04/12/tiobe-or-not-tiobe-lies-damned-lies-and-statistics/), Tim cita Mark Twain:

> “Existem três tipos de mentiras: mentiras, grandes mentiras e estatísticas.”

Da minha parte, não pretendo mais mencionar o TIOBE em nenhum artigo e em nenhuma apresentação como argumentação de que Ruby está crescendo. Na prática acredito que não existam índices confiáveis hoje para avaliar isso.

