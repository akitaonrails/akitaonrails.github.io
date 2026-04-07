---
title: 'Implementação em Ruby on Rails de um sistema de Ranking/Popularidade (do jeito certo)'
date: '2016-10-31T16:51:00-02:00'
slug: implementacao-ruby-on-rails-sistema-ranking-popularidade-correto
translationKey: rails-ranking-popularity
aliases:
- /2016/10/31/ruby-on-rails-implementation-of-a-proper-ranking-popularity-system/
tags:
- ruby
- ranking
- algoritmo
- traduzido
draft: false
---

Estava lendo um post publicado recentemente, intitulado ["Ruby on Rails implementation of a ranking system using PostgreSQL window functions"](http://naturaily.com/blog/post/ruby-on-rails-implementation-of-a-ranking-system-using-postgresql-window-functions) e, para ser justo, o objetivo do post era apresentar a [função de janela "ntile" do PostgreSQL](https://www.postgresql.org/docs/8.4/static/functions-window.html).

Acontece que, no caminho, o autor cometeu o mesmo erro que eu vejo se repetir o tempo todo.

Vamos supor que você tem um projeto com recursos que precisa listar por "popularidade". Pode ser um site estilo Reddit, onde as pessoas curtem ou descurtem posts e comentários. Pode ser um e-commerce onde as pessoas curtem ou descurtem produtos.

Pode ser qualquer coisa em que as pessoas curtem ou descurtem algo.

O maior erro que se comete é considerar um score simplório assim:

```ruby
popularity = positive_votes - negative_votes
```

Existe um artigo antigo chamado ["How Not To Sort By Average Rating"](http://www.evanmiller.org/how-not-to-sort-by-average-rating.html) e cito:

> "_Por que está errado:_ Suponha que um item tenha 600 votos positivos e 400 negativos: 60% positivo. Suponha que o item dois tenha 5.500 votos positivos e 4.500 negativos: 55% positivo. Esse algoritmo coloca o item dois (score = 1000, mas só 55% positivo) acima do item um (score = 200, com 60% positivo). ERRADO."

Aí você pode pensar: já sei como consertar:

```ruby
Score = average_rating = positive_votes / total_votes
```

De novo, está errado, e cito mais uma vez:

> "_Por que está errado:_ A média funciona bem quando sempre se tem uma tonelada de votos, mas suponha que o item 1 tenha 2 votos positivos e 0 negativos. Suponha que o item 2 tenha 100 votos positivos e 1 negativo. Esse algoritmo coloca o item dois (toneladas de votos positivos) abaixo do item um (pouquíssimos votos positivos). ERRADO."

### Solução Correta: Limite Inferior do Intervalo de Confiança de Wilson para uma Bernoulli

E cito de novo:

> "_Como assim:_ Precisamos balancear a proporção de votos positivos com a incerteza de um número pequeno de observações. Felizmente, a matemática para isso já tinha sido resolvida em 1927 por Edwin B. Wilson. O que queremos perguntar é: dadas as avaliações que tenho, existe 95% de chance de que a fração 'real' de avaliações positivas seja, no mínimo, quanto? Wilson dá a resposta. Considerando apenas votos positivos e negativos (ou seja, não uma escala de 5 estrelas), o limite inferior da proporção de avaliações positivas é dado por:"

![Equação do Limite Inferior de Bernoulli](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/565/rating-equation.png)

Recomendo que você leia o [artigo original](http://www.evanmiller.org/how-not-to-sort-by-average-rating.html), mas vamos ao que interessa. Seguindo o post original que linkei no começo, eu tenho uma app Rails simples de blog posts, só que em vez de um campo `visits_count` preciso adicionar campos `positive:integer` e `negative:integer`, além da interface para registrar os votos.

E vou substituir a classe `PostWithPopularityQuery` pelo seguinte:

```ruby
class PostWithPopularityQuery
  def self.call
    Post.find_by_sql ['SELECT id, title, body, positive, negative,
        ((positive + 1.9208) / (positive + negative) -
        1.96 * SQRT((positive * negative) / (positive + negative) + 0.9604) /
        (positive + negative)) / (1 + 3.8416 / (positive + negative))
        AS ci_lower_bound
      FROM posts 
      WHERE positive + negative > 0
      ORDER BY ci_lower_bound DESC']
  end
end
```

E isto é o que eu espero ver num scaffold simples de `index.html.erb`:

![Página index de Posts](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/564/Screen_Shot_2016-10-31_at_16.43.50.png)

Eu iria além e recomendaria que `ci_lower_bound` fosse um campo float na tabela, com um ActiveJob assíncrono atualizando esse valor em intervalos maiores (a cada 5 minutos, por exemplo). Aí a action `PostsController#index` faria um `SELECT` direto, ordenando por um campo real e indexado `ci_lower_bound DESC`, sem refazer as contas a **cada** query.

Agora **ESTE** é o jeito correto de implementar um sistema simples e ingênuo de ranking de popularidade que realmente funciona como deveria.

E não é a única forma. Há dezenas de boas discussões sobre algoritmos online. Todo serviço que depende de popularidade de conteúdo vem refinando algoritmos desse tipo há anos. O Facebook tinha um algoritmo chamado "EdgeRank", que dependia de variáveis como Afinidade, Peso, Decaimento Temporal, e parece que evoluiu tanto que hoje calcula popularidade contra mais de [100 mil variáveis](http://marketingland.com/edgerank-is-dead-facebooks-news-feed-algorithm-now-has-close-to-100k-weight-factors-55908)!!

Mas, independente do serviço online, eu garanto que **nenhum** ordena por contagem simples de visitas ou pela média simples dos votos. Isso seria simplesmente errado.
