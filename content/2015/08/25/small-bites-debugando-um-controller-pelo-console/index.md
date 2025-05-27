---
title: "[Small Bites] Debugando um Controller pelo Console"
date: '2015-08-25T15:48:00-03:00'
slug: small-bites-debugando-um-controller-pelo-console
tags:
- learning
- rails
draft: false
---



Hoje fui investigar um problema estranho em produção onde um controller não estava reagindo da mesma forma que em staging (aqueles momentos Murphy!) No final o problema era um SQL insert travando e dando timeout em toda request, problema em infraestrutura no Heroku Postgresql, e não da aplicação, mas para isolar o sintoma o seguinte truque ajudou.

Uma coisa que eu costumo fazer nesses casos é ligar o Rails Console (<tt>bundle exec rails c</tt> ou <tt>bin/rails c</tt>), criar a hash <tt>params</tt> com os parâmetros iguais ao que a aplicação está recebendo e manualmente executar as linhas da action pra ver os resultados.

Quando é pouca coisa isso ajuda a dar alguns insights. Porém neste caso a aplicação era grande e tinha uma quantidade enorme de <tt>before_action</tt> sendo executados e pra simular o mesmo ambiente eu precisaria executar tudo um atrás do outro. Em vez disso tem outra forma.

Ao abrir o Rails Console ele lhe dá um objeto que representa sua aplicação. Com ele você pode simular sua aplicação diretamente pelo console.

Por exemplo, para chegar ao ponto onde eu queria testar, primeiro precisa estar autenticado na aplicação. No meu caso basta fazer isso:

```
app.get "/users/sign_in"
```

Isso carrega o ambiente pro formulário de login, incluindo o token CSRF que podemos visualizar assim:

```
app.session.to_hash
=> {"session_id"=>"8dbf5adfe1738752bc05ce9e6d5ab9fc", "_csrf_token"=>"wp/0bjiEyRWgCfeBtkuFy+yZ2G/IihC0X1uSafn4noQ="}
```

Basta copiar o <tt>_csrf_token</tt> e usar para submeter o formulário ao controller do Devise:

```
app.post "/users/sign_in", {"utf8"=>"✓", "authenticity_token"=>"wp/0bjiEyRWgCfeBtkuFy+yZ2G/IihC0X1uSafn4noQ=", "user"=>{"login"=>"john", "password"=>"test123"} }
```

Finalmente, posso executar a URL que eu preciso para ver exatamente o que está acontecendo no ambiente de produção:

```
app.get "/rota/que/quero/testar"
```

Isso não é novo, um dos primeiros posts que explica as diversas ferramentas que existem no console é do próprio Signal v Noise, de 2012, ["Three quick Rails console tips"](https://signalvnoise.com/posts/3176-three-quick-rails-console-tips), escrito pelo Nick Quaranto. Para coisas rápidas e insights que podem ajudar a debugar e testar melhor sua app, este é um aliado muito poderoso!
